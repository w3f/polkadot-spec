<TeXmacs|1.99.13>

<project|host-spec.tm>

<style|<tuple|generic|std-latex|old-dots>>

<\body>
  <chapter|Message Passing>

  <\quote-env>
    Disclaimer: this document is work-in-progress and will change a lot until
    finalization.
  </quote-env>

  <section|Overview>

  Polkadot implements two types of message passing mechanisms; vertical
  passing and horizontal passing.

  <\itemize>
    <item>Vertical message passing refers to the communication between the
    parachains and the relay chain. More precisely, when the relay chain
    sends messages to a parachain, it's \Pdownward message passing\Q. When a
    parachain sends messages to the relay chain, it's \Pupward message
    passing\Q.

    <item>Horizontal message passing refers to the communication between the
    parachains, only requiring minimal involvement of the relay chain. The
    relay chain essentially only stores proofs that message where sent and
    whether the recipient has read those messages.
  </itemize>

  <big-figure|<image|figures/c08-overview.pdf|1par|||>|Parachain Message Passing Overview>

  <section|Message Queue Chain (MQC)>

  The Message Queue Chain (MQC) is a general hash chain construct created by
  validators which keeps track of any messages and their order as sent from a
  sender to an individual recipient. The MQC is used by both HRMP and XCMP.

  Each block within the MQC is a triple containing the following fields:

  - <with|font-family|tt|parent_hash>: The hash of the previous triple.\ 

  - <with|font-family|tt|message_hash>: The hash of the message itself.\ 

  - <with|font-family|tt|number>: The relay block number at which the message
  was sent.

  <big-figure|<image|figures/c08-message_queue_chain.pdf|1par|||>|Message Queue Chain Overview>

  A MQC is always specific to one channel. Additional channels require its
  own, individual MQC. The MQC itself is not saved anywhere, but only
  provides a final proof of all the received messages. When a validators
  receives a candidate, it generates the MQC from the messages placed withing
  <with|font-family|tt|upward_messages>, in ascending order.

  <section|HRMP>

  Polkadot currently implements the mechanism known as Horizontal
  Relay-routed Message Passing (HRMP), which fully relies on vertical message
  passing in order to communicate between parachains. Consequently, this goes
  against the entire idea of horizontal passing in the first place, since now
  every message has to be inserted into the relay chain itself, therefore
  heavily increasing footprint and resource requirements. However, HRMP
  currently serves as a fast track to implementing cross-chain
  interoperability. The upcoming replacement of HRMP is Cross-Chain Message
  Passing (XCMP), which exchanges messages directly between parachains and
  only updates proofs and read-confirmations on chain. With XCMP, vertical
  message processing is only used for opening and closing channels.

  <subsection|Channels>

  A channel is a construct on the relay chain indicating an open,
  one-directional communication line between a sender and a recipient,
  including information about how the channel is being used. The channel
  itself does not contain any messages. A channel construct is created for
  each, individual communication line.

  A channel contains the following fields:

  <with|font-family|tt|HrmpChannel>:

  <\itemize>
    <item><with|font-family|tt|sender_deposit: int>: staked balances of
    sender.

    <item><with|font-family|tt|recipient_deposit: int>: staked balances of
    recipient.

    <item><with|font-family|tt|limit_used_places: int>: the maximum number of
    messages that can be pending in the channel at once.

    <item><with|font-family|tt|limit_used_bytes: int>: the maximum total size
    of the messages that can be pending in the channel at once.

    <item><with|font-family|tt|limit_message_size>: the maximum message size
    that could be put into the channel.

    <item><with|font-family|tt|used_places: int>: number of messages used by
    the sender in this channel.

    <item><with|font-family|tt|used_bytes: int>: total number of bytes used
    by the sender in this channel.

    <item><with|font-family|tt|sealed: bool>: (TOOD: this is not defined in
    the Impl-Guide) indicator wether the channel is sealed. If it is, then
    the recipient will no longer accept any new messages.

    <item><with|font-family|tt|mqc_head>: a head of the MQC for this channel.
  </itemize>

  This structure is created or overwritten on every start of each session.
  Individual fields of this construct are updated for every message sent,
  such as <with|font-family|tt|used_places>, <with|font-family|tt|used_bytes>
  and <with|font-family|tt|mqc_head>. If the channel is sealed and
  <with|font-family|tt|used_places> reaches <with|font-family|tt|0> (occurs
  when a new session begins), this construct is be removed on the <em|next>
  session start.

  The Runtime maintains a structure of the current, open channels in a map.
  The key is a tuple of the sender ParaId and the recipient ParaId, where the
  value is the corresponding <with|font-family|tt|HrmpChannel> structure.

  <\verbatim>
    \;

    channels: map(ParaId, ParaId) =\<gtr\> Channel
  </verbatim>

  <subsection|Opening Channels>

  Polkadot places a certain limit on the amount of channels that can be
  opened between parachains. Only the the sender can open a channel.

  In order to open a channel, the sender must send an opening request to the
  relay chain. The request is a construct containing the following fields:

  <with|font-family|tt|ChOpenRequest>:

  <\itemize>
    <item><with|font-family|tt|sender: ParaId>: the ParaId of the sender.

    <item><with|font-family|tt|recipient: ParaId>: the ParaId of the
    recipient.

    <item><with|font-family|tt|confirmed: bool>: indicated whether the
    recipient has accepted the channel. On request creation, this value is
    <with|font-family|tt|false>.

    <item><with|font-family|tt|age: int>: the age of this request, which
    start at <with|font-family|tt|0> and is incremented by 1 on every session
    start.
  </itemize>

  TODO: Shouldn't <with|font-family|tt|ChOpenRequest> also have an
  <with|font-family|tt|initiator> field? Or can only the sender open an
  channel?

  <subsubsection|Workflow>

  Before execution, the following conditions must be valid, otherwise the
  candidate will be rejected.

  <\itemize>
    <item>The <with|font-family|tt|sender> and the
    <with|font-family|tt|recipient> exist.

    <item><with|font-family|tt|sender> is not the
    <with|font-family|tt|recipient>.

    <item>There's currently not a active channel established, either seal or
    unsealed (TODO: what if there's an active closing request pending?).

    <item>There's not already an open channel request for
    <with|font-family|tt|sender> and <with|font-family|tt|recipient> pending.

    <item>The caller of this function (<with|font-family|tt|sender>) has
    capacity for a new channel. An open request counts towards the capacity
    (TODO: where is this defined?).

    <item>The caller of this function (<with|font-family|tt|sender>) has
    enough funds to cover the deposit.
  </itemize>

  The PVF executes the following steps:

  <\itemize>
    <item>Create a <with|font-family|tt|ChOpenRequest> message and inserts it
    into the <with|font-family|tt|upward_messages> list of the candidate
    commitments.
  </itemize>

  Once the candidate is included in the relay chain, the runtime reads the
  message from <with|font-family|tt|upward_messages> and executes the
  following steps:

  <\itemize>
    <item>Reads the message from <with|font-family|tt|upward_messages> of the
    candidate commitments.

    <item>Reserves a deposit for the caller of this function
    (<with|font-family|tt|sender>) (TODO: how much?).

    <item>Appends the <with|font-family|tt|ChOpenRequest> request to the
    pending open request queue.
  </itemize>

  <subsection|Accepting Channels>

  Open channel requests must be accepted by the other parachain.

  TODO: How does a Parachain decide which channels should be accepted?
  Probably off-chain consensus/agreement?

  The accept message contains the following fields:

  <with|font-family|tt|ChAccept>:

  <\itemize>
    <item><with|font-family|tt|index: int>: the index of the open request
    list.
  </itemize>

  <subsubsection|Workflow>

  Before execution, the following conditions must be valid, otherwise the
  candidate will be rejected.

  <\itemize>
    <item>The <with|font-family|tt|index> is valid (the value is within range
    of the list).

    <item>The <with|font-family|tt|recipient> ParaId corresponds to the
    ParaId of the caller of this function.

    <item>The caller of this function (<with|font-family|tt|recipient>) has
    enough funds to cover the deposit.
  </itemize>

  The PVF executes the following steps:

  <\itemize>
    <item>Generates a <with|font-family|tt|ChAccept> message and inserts it
    into the <with|font-family|tt|upward_messages> list of the candidate
    commitments.
  </itemize>

  Once the candidate is included in the relay chain, the relay runtime reads
  the message from <with|font-family|tt|upward_messages> and executes the
  following steps:

  <\itemize>
    <item>Reserve a deposit for the caller of this function
    (<with|font-family|tt|recipient>).

    <item>Confirm the open channel request in the request list by setting the
    <with|font-family|tt|confirmed> field to <with|font-family|tt|true>.
  </itemize>

  <subsection|Closing Channels>

  Any open channel can be closed by the corresponding sender or receiver. No
  mutual agreement is required. A close channel request is a construct
  containing the following fields:

  <with|font-family|tt|ChCloseRequest>:

  <\itemize>
    <item><with|font-family|tt|initiator: int>: the ParaId of the parachain
    which initiated this request, either the sender or the receiver.

    <item><with|font-family|tt|sender: ParaId>: the ParaId of the sender.

    <item><with|font-family|tt|recipient: ParaId>: the ParaId of the
    recipient.
  </itemize>

  <subsection|Workflow>

  Before execution, the following conditions must be valid, otherwise the
  candidate will be rejected.

  <\itemize>
    <item>There's currently and open channel or a pending open channel
    request between <with|font-family|tt|sender> and
    <with|font-family|tt|recipient>.

    <item>The channel is not sealed.

    <item>The caller of the Runtime function is either the
    <with|font-family|tt|sender> or <with|font-family|tt|recipient>.

    <item>There is not existing close channel request.
  </itemize>

  The PVF executes the following steps:

  <\itemize>
    <item>Generates a <with|font-family|tt|ChCloseRequest> message and
    inserts it into the <with|font-family|tt|upward_messages> list of the
    candidate commitments.
  </itemize>

  Once a candidate block is inserted into the relay chain, the relay runtime:

  <\itemize>
    <item>Reads the message from <with|font-family|tt|upward_message> of the
    candidate commitments.

    <item>Appends the request <with|font-family|tt|ChCloseRequest> to the
    pending close request queue.
  </itemize>

  <subsection|Sending messages>

  The Runtime treats messages as SCALE encoded byte arrays and has no concept
  or understanding of the message type or format itself. Consensus on message
  format must be established between the two communicating parachains (TODO:
  SPREE will handle this).

  Messages intended to be read by other Parachains are inserted into
  <with|font-family|tt|horizontal_messages> of the candidate commitments
  (<with|font-family|tt|CandidateCommitments>), while message which are only
  intended to be read by the relay chain (such as when opening, accepting or
  closing channels) are inserted into <with|font-family|tt|upward_messages>.

  The messages are included by collators into the committed candidate receipt
  (), which contains the following fields:

  TODO: This should be defined somewhere else, ideally in a
  backing/validation section (once this document is merged with AnV).

  <with|font-family|tt|CommittedCandidateReceipt>:

  <\itemize>
    <item><with|font-family|tt|descriptor: CandidateDescriptor>: the
    descriptor of the candidate.

    <item><with|font-family|tt|commitments: CandidateCommitments>: the
    commitments of the candidate receipt.
  </itemize>

  The candidate descriptor contains the following fields:

  <with|font-family|tt|CandidateDescriptor>:

  <\itemize>
    <item><with|font-family|tt|para_id: ParaId>: the ID of the para this is a
    candidate for.

    <item><with|font-family|tt|relay_parent: Hash>: the hash of the relay
    chain block this is executed in the context of.

    <item><with|font-family|tt|collator: CollatorId>: the collator's SR25519
    public key.

    <item><with|font-family|tt|persisted_validation_data_hash: Hash>: the
    hash of the persisted valdation data. This is extra data derived from the
    relay chain state which may vary based on bitfields included before the
    candidate. Therefore, it cannot be derived entirely from the relay
    parent.

    <item><with|font-family|tt|pov_hash: Hash>: the how of the PoV block.

    <item><with|font-family|tt|signature: Signature>: the signature on the
    Blake2 256-bit hash of the following components of this receipt:

    <\itemize>
      <item><with|font-family|tt|para_id>

      <item><with|font-family|tt|relay_parent>

      <item><with|font-family|tt|persisted_validation_data_hash>

      <item><with|font-family|tt|pov_hash>
    </itemize>
  </itemize>

  The candidate commitments contains the following fields:

  <with|font-family|tt|CandidateCommitments>:

  <\itemize>
    <item><with|font-family|tt|fees: int>: fees paid from the chain to the
    relay chian validators

    <item><with|font-family|tt|horizontal_message: [Message]>: a SCALE
    encoded arrary containing the messages intended to be received by the
    recipient parachain.

    <item><with|font-family|tt|upward_messages: [Message]>: message destined
    to be interpreted by the relay chain itself.

    <item><with|font-family|tt|erasure_root: Hash>: the root of a block's
    erasure encoding Merkle tree.

    <item><with|font-family|tt|new_validation_code:
    Option\<less\>ValidationCode\<gtr\>>: new validation code for the
    parachain.

    <item><with|font-family|tt|head_data: HeadData>: the head-data produced
    as a result of execution.

    <item><with|font-family|tt|processed_downward_messages: u32>: the number
    of messages processed from the DMQ.

    <item><with|font-family|tt|hrmp_watermark: BlockNumber>: the mark which
    specifies the block number up to which all inbound HRMP messages are
    processed.
  </itemize>

  <subsection|Receiving Messages>

  A recipient can check for unread messages by calling into the
  <with|font-family|tt|downward_messages> function of the relay runtime
  (TODO: currently it's not really clear how a recipient will check for new
  messages).

  Params:

  <\itemize>
    <item><with|font-family|tt|id: ParaId>: the ParaId of the sender.
  </itemize>

  On success, it returns a SCALE encoded array of messages.

  <section|XCMP>

  XCMP is a horizontal message passing mechanism of Polkadot which allows
  Parachains to communicate with each other and to prove that messages have
  been sent. A core principle is that the relay chain remains as thin as
  possible in regards to messaging and only contains the required information
  for the validity of message processing.

  <big-figure|<image|figures/c08-xcmp_overview.pdf|1par|||>|Parachain XCMP Overview>

  The entire XCMP process requires a couple of steps:

  <\itemize>
    <item>The sender creates a local Message Queue Chain (MQC) of the
    messages it wants to send and inserts the Merkle root into a structure on
    the relay chain, known as the Channel State Table (CST).

    <item>The messages are sent to the recipient and contain the necessary
    data in order to reproduce the MQC.

    <item>The BIOS module of the recipient process those messages. The
    messages are then inserted into the next parablock body as inherent
    extrinsics.

    <item>Once that parablock is inserted into the relay chain, the recipient
    then updates the Watermark, which points to the relay block number which
    includes the parablock. This serves as an indicator that the receiving
    parachain has processed messages up to that relay block.
  </itemize>

  Availabilty

  <\itemize>
    <item>The messages created by the sender must be kept available for at
    least one day. When AnV assigns validators to check the validity of the
    sending parachains parablocks, it can load the data from the CST, which
    includes the information required in order to regenerate the MQC.

    <item>...
  </itemize>

  <subsection|CST: Channel State Table>

  The Channel State Table (CST) is a map construct on the relay chain which
  keeps track of every MQC generated by a single sender. The corresponding
  value is a list of pairs, where each pair contains the ParaId of the
  recipient, the Merkle root of MQC heads and the relay block number where
  that item was last updated in the CST. This provides a mechanism for
  receiving parachains to easily verify messages sent from a specific source.

  <\verbatim>
    \;

    cst: map ParaId =\<gtr\> [ChannelState]

    \;
  </verbatim>

  <with|font-family|tt|ChannelState>:

  <\itemize>
    <item><with|font-family|tt|last_updated: BlockNumber>: the relay block
    number where the CST was last updated.

    <item><with|font-family|tt|mqc_root: Option\<less\>Hash\<gtr\>>: The
    Merkle root of all MQC heads where the parachain is the sender. This item
    is <with|font-family|tt|None> in case there is no prior message.
  </itemize>

  Besides the CST, there's also a CST Root, which is an additional map
  construct and contains an entry for every sender and the corresponding
  Merkle root of each <with|font-family|tt|ChannelState> in the CST.

  <\verbatim>
    \;

    cst_roots: map ParaId =\<gtr\> Hash

    \;
  </verbatim>

  When a PoV block on the recipient is created, the collator which builds
  that block fetches the pairs of the sender from the CST and creates its own
  Merkle root. When that PoV block is sent to the validator, the validator
  can just fetch the Merkle root from the CST Root and verify the PoV block
  without requiring the full list of pairs.

  <subsection|Message content>

  All messages sent to the recipient must contain enough information in order
  for the recipient to verify those messages with the CST. This includes the
  necessary Merkle trie nodes, the parent triple of each individual MQC block
  and the messages themselves. The recipient then recreates the MQC and
  verifies it against the CST.

  <subsection|Watermark>

  Collators of the recipient insert the messages into their parablock as
  Inherents and publish the parablock to the relay chain. Once included, the
  watermark is updated and points to the relay chain block number where the
  inclusion ocurred.

  <\verbatim>
    \;

    watermark: map ParaId =\<gtr\> (BlockNumber, ParaId)

    \;
  </verbatim>

  <section|SPREE>

  ...
</body>

<\initial>
  <\collection>
    <associate|preamble|false>
  </collection>
</initial>

<references|<\collection>
</collection>>

<auxiliary|<\collection>
</collection>>