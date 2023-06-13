---
title: -chap-num- Availability & Validity
---

Polkadot serves as a replicated shared-state machine designed to resolve scalability issues and interoperability among blockchains. The validators of Polkadot execute transactions and participate in the consensus of Polkadots primary chain, the so called relay chain. Parachains are independent networks that maintain their own state and are connected to the relay chain. Those parachains can take advantage of the relay chain consensus mechanism, including sending and receiving messages to and from other parachains. Parachain nodes that send parachain blocks, known as candidates, to the validators in order to be included in relay chain are referred to as collators.

The Polkadot relay chain validators are responsible for guaranteeing the validity of both relay chain and parachain blocks. Additionally, the validators are required to keep enough parachain blocks that should be included in the relay chain available in their local storage in order to make those retrievable by peers, who lack the information, to reliably confirm the issued validity statements about parachain blocks. The Availability & Validity (AnV) protocol consists of multiple steps for successfully upholding those responsibilities.

Parachain blocks themselves are produced by collators ([Section -sec-num-ref-](chapter-anv#sect-collations)), whereas the relay chain validators only verify their validity (and later, their availability). It is possible that the collators of a parachain produces multiple parachain block candidates for a child of a specific block. Subsequently, they send the block candidates to the the relay chain validators who are assigned to the specific parachain. The assignment is determined by the Runtime ([Section -sec-num-ref-](chapter-anv#sect-candidate-backing)). Those validators are then required to check the validity of submitted candidates ([Section -sec-num-ref-](chapter-anv#sect-candidate-validation)), then issue and collect statements ([Section -sec-num-ref-](chapter-anv#sect-candidate-statements)) about the validity of candidates to other validators. This process is known as candidate backing. Once a candidate meets a specified criteria for inclusion, the selected relay chain block author then choses any of the backed candidate for each parachain and includes those into the relay chain block ([Section -sec-num-ref-](chapter-anv#sect-candidate-inclusion)).

Every relay chain validator must fetch the proposed candidates and issue votes on whether they have the candidate saved in their local storage, so called availability votes ([Section -sec-num-ref-](chapter-anv#sect-availability-votes)), then also collect the votes sent by other validators and include them in the relay chain state ([Section -sec-num-ref-](chapter-anv#sect-candidate-inclusion)). This process ensures that only relay chain blocks get finalized where each candidate is available on enough nodes of validators.

Parachain candidates contained in non-finalized relay chain blocks must then be retrieved by a secondary set of relay chain validators, unrelated from the candidate backing process, who are randomly assigned to determine the validity of specific parachains based on a VRF lottery and are then required to vote on the validity of those candidates. This process is known as approval voting ([Section -sec-num-ref-](chapter-anv#sect-approval-voting)). If a validator does not have the candidate data, it must recover the candidate data ([Section -sec-num-ref-](chapter-anv#sect-candidate-recovery)).

## -sec-num- Collations {#sect-collations}

Collations are proposed candidates [Definition -def-num-ref-](chapter-anv#defn-candidate) to the Polkadot relay chain validators. The Polkodat network protocol is agnostic on what candidate productionis mechanism each parachain uses and does not specify or mandate any of such production methods (e.g. BABE-GRANDPA, Aura, etc). Furthermore, the relay chain validator host implementation itself does not directly interpret or process the internal transactions of the candidate, but rather rely on the parachain Runtime to validate the candidate ([Section -sec-num-ref-](chapter-anv#sect-candidate-validation)). Collators, which are parachain nodes which produce candidate proposals and send them to the relay chain validator, must prepare pieces of data ([Definition -def-num-ref-](chapter-anv#defn-collation)) in order to correctly comply with the requirements of the parachain protocol.

###### Definition -def-num- Collation {#defn-collation}
:::definition

A collation is a datastructure which contains the proposed parachain candidate, including an optional validation parachain Runtime update and upward messages. The collation datastructure, C, is a datastructure of the following format:

$$
{C}={\left({M},{H},{R},{h},{P},{p},{w}\right)}
$$
$$
{M}={\left({u}_{{n}},…{u}_{{m}}\right)}
$$
$$
{H}={\left({z}_{{n}},…{z}_{{m}}\right)}
$$

**where**  
- ${M}$ is an array of upward messages ([Definition -def-num-ref-](chapter-anv#defn-upward-message)), ${u}$, interpreted by the relay chain itself.

- ${H}$ is an array of outbound horizontal messages ([Definition -def-num-ref-](chapter-anv#defn-outbound-hrmp-message)), ${z}$, interpreted by other parachains.

- ${R}$ is an *Option* type ([Definition -def-num-ref-](id-cryptography-encoding#defn-option-type)) which can contain a parachain Runtime update. The new Runtime code is an array of bytes.

- ${h}$ is the head data ([Definition -def-num-ref-](chapter-anv#defn-head-data)) produced as a result of execution of the parachain specific logic.

- ${P}$ is the PoV block ([Definition -def-num-ref-](chapter-anv#defn-para-block)).

- ${p}$ is an unsigned 32-bit integer indicating the number of processed downward messages ([Definition -def-num-ref-](chapter-anv#defn-downward-message)).

- ${w}$ is an unsigned 32-bit integer indicating the mark up to which all inbound HRMP messages have been processed by the parachain.

:::
## -sec-num- Candidate Backing {#sect-candidate-backing}

The Polkadot validator receives an arbitrary number of parachain candidates with associated proofs from untrusted collators. The assigned validators of each parachain ([Definition -def-num-ref-](chapter-anv#defn-validator-groups)) must verify and select a specific quantity of the proposed candidates and issue those as backable candidates to its peers. A candidate is considered backable when at least 2/3 of all assigned validators have issued a *Valid* statement about that candidate, as described in [Section -sec-num-ref-](chapter-anv#sect-candidate-statements). Validators can retrieve information about assignments via the Runtime APIs [Section -sec-num-ref-](chap-runtime-api#sect-rt-api-validator-groups) respectively [Section -sec-num-ref-](chap-runtime-api#sect-rt-api-availability-cores).

### -sec-num- Statements {#sect-candidate-statements}

The assigned validator checks the validity of the proposed parachains blocks ([Section -sec-num-ref-](chapter-anv#sect-candidate-validation)) and issues *Valid* statements ([Definition -def-num-ref-](chapter-anv#defn-statement)) to its peers if the verification succeeded. Broadcasting failed verification as *Valid* statements is a slashable offense. The validator must only issue one *Seconded* statement, based on an arbitrary metric, which implies an explicit vote for a candidate to be included in the relay chain.

This protocol attempts to produce as many backable candidates as possible, but does not attempt to determine a final candidate for inclusion. Once a parachain candidate has been seconded by at least one other validator and enough Valid statements have been issued about that candidate to meet the 2/3 quorum, the candidate is ready to be included in the relay chain ([Section -sec-num-ref-](chapter-anv#sect-candidate-inclusion)).

The validator issues validity statements votes in form of a validator protocol message ([Definition -def-num-ref-](chapter-anv#net-msg-validator-protocol-message)).

###### Definition -def-num- Statement {#defn-statement}
:::definition

A statement, ${S}$, is a datastructure of the following format:

$$
{S}={\left({d},{A}_{{i}},{A}_{{s}}\right)}
$$
$$
{d}={\left\lbrace\begin{matrix}{1}&\rightarrow&{C}_{{r}}\\{2}&\rightarrow&{C}_{{h}}\end{matrix}\right.}
$$

**where**  
- ${d}$ is a varying datatype where *1* indicates that the validator “seconds” a candidate, meaning that the candidate should be included in the relay chain, followed by the committed candidate receipt ([Definition -def-num-ref-](chapter-anv#defn-committed-candidate-receipt)), ${C}_{{r}}$. *2* indicates that the validator has deemed the candidate valid, followed by the candidate hash.

- ${C}_{{h}}$ is the candidate hash.

- ${A}_{{i}}$ is the validator index in the authority set that signed this statement.

- ${A}_{{s}}$ is the signature of the validator.

:::
### -sec-num- Inclusion {#sect-candidate-inclusion}

The Polkadot validator includes the backed candidates as parachain inherent data ([Definition -def-num-ref-](chapter-anv#defn-parachain-inherent-data)) into a block as described [Section -sec-num-ref-](chap-state#sect-inherents). The relay chain block author decides on whatever metric which candidate should be selected for inclusion, as long as that candidate is valid and meets the validity quorum of 2/3+ as described in [Section -sec-num-ref-](chapter-anv#sect-candidate-statements). The candidate approval process ([Section -sec-num-ref-](chapter-anv#sect-approval-voting)) ensures that only relay chain blocks are finalized where each candidate for each availability core meets the requirement of 2/3+ availability votes.

###### Definition -def-num- Parachain Inherent Data {#defn-parachain-inherent-data}
:::definition

The parachain inherent data contains backed candidates and is included when authoring a relay chain block. The datastructure, ${I}$, is of the following format:

$$
{I}={\left({A},{T},{D},{P}_{{h}}\right)}
$$
$$
{T}={\left({C}_{{0}},…{C}_{{n}}\right)}
$$
$$
{D}={\left({d}_{{n}},…{d}_{{m}}\right)}
$$
$$
{C}={\left({R},{V},{i}\right)}
$$
$$
{V}={\left({a}_{{n}},…{a}_{{m}}\right)}
$$
$$
{a}={\left\lbrace\begin{matrix}{1}&\rightarrow&{s}\\{2}&\rightarrow&{s}\end{matrix}\right.}
$$
$$
{A}={\left({L}_{{n}},…{L}_{{m}}\right)}
$$
$$
{L}={\left({b},{v}_{{i}},{s}\right)}
$$

**where**  
- ${A}$ is an array of signed bitfields by validators claiming the candidate is available (or not). The array must be sorted by validator index corresponding to the authority set ([Definition -def-num-ref-](chap-sync#defn-authority-list)).

- ${T}$ is an array of backed candidates for inclusing in the current block.

- ${D}$ is an array of disputes.

- ${P}_{{h}}$ is the parachain parent head data ([Definition -def-num-ref-](chapter-anv#defn-head-data)).

- ${d}$ is a dispute statement ([Section -sec-num-ref-](chapter-anv#net-msg-dispute-request)).

- ${R}$ is a committed candidate receipt ([Definition -def-num-ref-](chapter-anv#defn-committed-candidate-receipt)).

- ${V}$ is an array of validity votes themselves, expressed as signatures.

- ${i}$ is a bitfield of indices of the validators within the validator group ([Definition -def-num-ref-](chapter-anv#defn-validator-groups)).

- ${a}$ is either an implicit or explicit attestation of the validity of a parachain candidate, where *1* implies an implicit vote (in correspondence of a *Seconded* statement) and *2* implies an explicit attestation (in correspondence of a *Valid* statement). Both variants are followed by the signature of the validator.

- ${s}$ is the signature of the validator.

- ${b}$ the availability bitfield ([Section -sec-num-ref-](chapter-anv#sect-availability-votes)).

- ${v}_{{i}}$ is the validator index of the authority set ([Definition -def-num-ref-](chap-sync#defn-authority-list)).

:::
###### Definition -def-num- Candidate Receipt {#defn-candidate-receipt}
:::definition

A candidate receipt, ${R}$, contains information about the candidate and a proof of the results of its execution. It’s a datastructure of the following format:

$$
{R}={\left({D},{C}_{{h}}\right)}
$$

where ${D}$ is the candidate descriptor ([Definition -def-num-ref-](chapter-anv#defn-candidate-descriptor)) and ${C}_{{h}}$ is the hash of candidate commitments ([Definition -def-num-ref-](chapter-anv#defn-candidate-commitments)).

:::
###### Definition -def-num- Committed Candidate Receipt {#defn-committed-candidate-receipt}
:::definition

The committed candidate receipt, ${R}$, contains information about the candidate and the the result of its execution that is included in the relay chain. This type is similar to the candidate receipt ([Definition -def-num-ref-](chapter-anv#defn-candidate-receipt)), but actually contains the execution results rather than just a hash of it. It’s a datastructure of the following format:

$$
{R}={\left({D},{C}\right)}
$$

where ${D}$ is the candidate descriptor ([Definition -def-num-ref-](chapter-anv#defn-candidate-descriptor)) and ${C}$ is the candidate commitments ([Definition -def-num-ref-](chapter-anv#defn-candidate-commitments)).

:::
###### Definition -def-num- Candidate Descriptor {#defn-candidate-descriptor}
:::definition

The candidate descriptor, ${D}$, is a unique descriptor of a candidate receipt. It’s a datastructure of the following format:

$$
{D}={\left({p},{H},{C}_{{i}},{V},{B},{r},{s},{p}_{{h}},{R}_{{h}}\right)}
$$

**where**  
- ${p}$ is the parachain Id ([Definition -def-num-ref-](chapter-anv#defn-para-id)).

- ${H}$ is the hash of the relay chain block the candidate is executed in the context of.

- ${C}_{{i}}$ is the collators public key.

- ${V}$ is the hash of the persisted validation data ([Definition -def-num-ref-](chap-runtime-api#defn-persisted-validation-data)).

- ${B}$ is the hash of the PoV block.

- ${r}$ is the root of the block’s erasure encoding Merkle tree.

- ${s}$ the collator signature of the concatenated components ${p}$, ${H}$, ${R}_{{h}}$ and ${B}$.

- ${p}_{{h}}$ is the hash of the parachain head data ([Definition -def-num-ref-](chapter-anv#defn-head-data)) of this candidate.

- ${R}_{{h}}$ is the hash of the parachain Runtime.

:::
###### Definition -def-num- Candidate Commitments {#defn-candidate-commitments}
:::definition

The candidate commitments, ${C}$, is the result of the execution and validation of a parachain (or parathread) candidate whose produced values must be committed to the relay chain. Those values are retrieved from the validation result ([Definition -def-num-ref-](chapter-anv#defn-validation-result)). A candidate commitment is a datastructure of the following format:

$$
{C}={\left({M}_{{u}},{M}_{{h}},{R},{h},{p},{w}\right)}
$$

**where**  
- ${M}_{{u}}$ is an array of upward messages sent by the parachain. Each individual message, m, is an array of bytes.

- ${M}_{{h}}$ is an array of individual outbound horizontal messages ([Definition -def-num-ref-](chapter-anv#defn-outbound-hrmp-message)) sent by the parachain.

- ${R}$ is an *Option* value ([Definition -def-num-ref-](id-cryptography-encoding#defn-option-type)) that can contain a new parachain Runtime in case of an update.

- ${h}$ is the parachain head data ([Definition -def-num-ref-](chapter-anv#defn-head-data)).

- ${p}$ is a unsigned 32-bit integer indicating the number of downward messages that were processed by the parachain. It is expected that the parachain processes the messages from first to last.

- ${w}$ is a unsigned 32-bit integer indicating the watermark which specifies the relay chain block number up to which all inbound horizontal messages have been processed.

:::
## -sec-num- Candidate Validation {#sect-candidate-validation}

Received candidates submitted by collators and must have its validity verified by the assigned Polkadot validators. For each candidate to be valid, the validator must successfully verify the following conditions in the following order:

1.  The candidate does not exceed any parameters in the persisted validation data ([Definition -def-num-ref-](chap-runtime-api#defn-persisted-validation-data)).

2.  The signature of the collator is valid.

3.  Validate the candidate by executing the parachain Runtime ([Section -sec-num-ref-](chapter-anv#sect-parachain-runtime)).

If all steps are valid, the Polkadot validator must create the necessary candidate commitments ([Definition -def-num-ref-](chapter-anv#defn-candidate-commitments)) and submit the appropriate statement for each candidate ([Section -sec-num-ref-](chapter-anv#sect-candidate-statements)).

### -sec-num- Parachain Runtime {#sect-parachain-runtime}

Parachain Runtimes are stored in the relay chain state, and can either be fetched by the parachain Id or the Runtime hash via the relay chain Runtime API as described in [Section -sec-num-ref-](chap-runtime-api#sect-rt-api-validation-code) and [Section -sec-num-ref-](chap-runtime-api#sect-rt-api-validation-code-by-hash) respectively. The retrieved parachain Runtime might need to be decompressed based on the magic identifier as described in [Section -sec-num-ref-](chapter-anv#sect-runtime-compression).

In order to validate a parachain block, the Polkadot validator must prepare the validation parameters ([Definition -def-num-ref-](chapter-anv#defn-validation-parameters)), then use its local Wasm execution environment ([Section -sec-num-ref-](chap-state#sect-code-executor)) to execute the validate_block parachain Runtime API by passing on the validation parameters as an argument. The parachain Runtime function returns the validation result ([Definition -def-num-ref-](chapter-anv#defn-validation-result)).

###### Definition -def-num- Validation Parameters {#defn-validation-parameters}
:::definition

The validation parameters structure, ${P}$, is required to validate a candidate against a parachain Runtime. It’s a datastructure of the following format:

$$
{P}={\left({h},{b},{B}_{{i}},{S}_{{r}}\right)}
$$

**where**  
- ${h}$ is the parachain head data ([Definition -def-num-ref-](chapter-anv#defn-head-data)).

- ${b}$ is the block body ([Definition -def-num-ref-](chapter-anv#defn-para-block)).

- ${B}_{{i}}$ is the latest relay chain block number.

- ${S}_{{r}}$ is the relay chain block storage root ([Section -sec-num-ref-](chap-state#sect-merkl-proof)).

:::
###### Definition -def-num- Validation Result {#defn-validation-result}
:::definition

The validation result is returned by the `validate_block` parachain Runtime API after attempting to validate a parachain block. Those results are then used in candidate commitments ([Definition -def-num-ref-](chapter-anv#defn-candidate-commitments)), which then will be inserted into the relay chain via the parachain inherent data ([Definition -def-num-ref-](chapter-anv#defn-parachain-inherent-data)). The validation result, ${V}$, is a datastructure of the following format:

$$
{V}={\left({h},{R},{M}_{{u}},{M}_{{h}},{p}_{,}{w}\right)}
$$
$$
{M}_{{u}}={\left({m}_{{0}},…{m}_{{n}}\right)}
$$
$$
{M}_{{h}}={\left({t}_{{0}},…{t}_{{n}}\right)}
$$

**where**  
- ${h}$ is the parachain head data ([Definition -def-num-ref-](chapter-anv#defn-head-data)).

- ${R}$ is an *Option* value ([Definition -def-num-ref-](id-cryptography-encoding#defn-option-type)) that can contain a new parachain Runtime in case of an update.

- ${M}_{{u}}$ is an array of upward messages sent by the parachain. Each individual message, m, is an array of bytes.

- ${M}_{{h}}$ is an array of individual outbound horizontal messages ([Definition -def-num-ref-](chapter-anv#defn-outbound-hrmp-message)) sent by the parachain.

- ${p}$ is a unsigned 32-bit integer indicating the number of downward messages that were processed by the parachain. It is expected that the parachain processes the messages from first to last.

- ${w}$ is a unsigned 32-bit integer indicating the watermark which specifies the relay chain block number up to which all inbound horizontal messages have been processed.

:::
### -sec-num- Runtime Compression {#sect-runtime-compression}

|     |                                            |
|-----|--------------------------------------------|
|     | Runtime compression is not documented yet. |

## -sec-num- Availability {#sect-availability}

### -sec-num- Availability Votes {#sect-availability-votes}

The Polkadot validator must issue a bitfield ([Definition -def-num-ref-](chapter-anv#defn-bitfield-array)) which indicates votes for the availability of candidates. Issued bitfields can be used by the validator and other peers to determine which backed candidates meet the 2/3+ availability quorum.

Candidates are inserted into the relay chain in form of parachain inherent data ([Section -sec-num-ref-](chapter-anv#sect-candidate-inclusion)) by a block author. A validator can retrieve that data by calling the appropriate Runtime API entry ([Section -sec-num-ref-](chap-runtime-api#sect-rt-api-availability-cores)), then create a bitfield indicating for which candidate the validator has availability data stored and broadcast it to the network ([Definition -def-num-ref-](chapter-anv#net-msg-bitfield-dist-msg)). When sending the bitfield distrubtion message, the validator must ensure ${B}_{{h}}$ is set approriately, therefore clarifying to which state the bitfield is referring to, given that candidates can vary based on the chain fork.

Missing availability data of candidates must be recovered by the validator as described in [Section -sec-num-ref-](chapter-anv#sect-candidate-recovery). If previously issued bitfields are no longer accurate, i.e. the availability data has been recovered or the candidate of an availability core has changed, the validator must create a new bitfield and broadcast it to the network. Candidates must be kept available by validators for a specific amount of time. If a candidate does not receive any backing, validators should keep it available for about one hour, in case the state of backing does change. Backed and even approved candidates ([Section -sec-num-ref-](chapter-anv#sect-approval-voting)) must be kept by validators for about 25 hours, since disputes ([Section -sec-num-ref-](chapter-anv#sect-disputes)) can occur and the candidate needs to be checked again.

The validator issues availability votes in form of a validator protocol message ([Definition -def-num-ref-](chapter-anv#net-msg-collator-protocol-message)).

### -sec-num- Candidate Recovery {#sect-candidate-recovery}

The availability distribution of the Polkadot validator must be able to recover parachain candidates that the validator is assigned to, in order to determine whether the candidate should be backed ([Section -sec-num-ref-](chapter-anv#sect-candidate-backing)) respectively whether the candidate should be approved ([Section -sec-num-ref-](chapter-anv#sect-approval-voting)). Additionally, peers can send availability requests as defined in [Definition -def-num-ref-](chapter-anv#net-msg-chunk-fetching-request) and [Definition -def-num-ref-](chapter-anv#net-msg-available-data-request) to the validator, which the validator should be able to respond to.

Candidates are recovered by sending requests for specific indices of erasure encoded chunks ([Section -sec-num-ref-](id-cryptography-encoding#sect-erasure-encoding)). A validator should request chunks by picking peers randomly and must recover at least ${f}+{1}$ chunks, where ${n}={3}{f}+{k}$ and ${k}\in{\left\lbrace{1},{2},{3}\right\rbrace}$. ${n}$ is the number of validators as specified in the session info, which can be fetched by the Runtime API as described in [Section -sec-num-ref-](chap-runtime-api#sect-rt-api-session-info).

## -sec-num- Approval Voting {#sect-approval-voting}

The approval voting process ensures that only valid parachain blocks are finalized on the relay chain. After *backable* parachain candidates were submitted to the relay chain ([Section -sec-num-ref-](chapter-anv#sect-candidate-inclusion)), which can be retrieved via the Runtime API ([Section -sec-num-ref-](chap-runtime-api#sect-rt-api-availability-cores)), validators need to determine their assignments for each parachain and issue approvals for valid candidates, respectively disputes for invalid candidates. Since it cannot be expected that each validator verifies every single parachain candidate, this mechanism ensures that enough honest validators are selected to verify parachain candidates in order prevent the finalization of invalid blocks. If an honest validator detects an invalid block which was approved by one or more validators, the honest validator must issue a disputes which wil cause escalations, resulting in consequences for all malicious parties, i.e. slashing. This mechanism is described more in [Section -sec-num-ref-](chapter-anv#sect-availability-assignment-criteria).

### -sec-num- Assignment Criteria {#sect-availability-assignment-criteria}

Validators determine their assignment based on a VRF mechanism, similar to the BABE consensus mechanism. First, validators generate an availability core VRF assignment ([Definition -def-num-ref-](chapter-anv#defn-availability-core-vrf-assignment)), which indicates which availability core a validator is assigned to. Then a delayed availability core VRF assignment is generated which indicates at what point a validator should start the approval process. The delays are based on “tranches” ([Section -sec-num-ref-](chapter-anv#sect-tranches)).

An assigned validator never broadcasts their assignment until relevant. Once the assigned validator is ready to check a candidate, the validator broadcasts their assignment by issuing an approval distribution message ([Definition -def-num-ref-](chapter-anv#net-msg-approval-distribution)), where ${M}$ is of variant *0*. Other assigned validators that receive that network message must keep track of if, expecting an approval vote following shortly after. Assigned validators can retrieve the candidate by using the availability recovery ([Section -sec-num-ref-](chapter-anv#sect-candidate-recovery)) and then validate the candidate ([Section -sec-num-ref-](chapter-anv#sect-candidate-validation)).

The validator issues approval votes in form of a validator protocol message ([Definition -def-num-ref-](chapter-anv#net-msg-validator-protocol-message)) respectively disputes ([Section -sec-num-ref-](chapter-anv#sect-disputes)).

### -sec-num- Tranches {#sect-tranches}

Validators use a subjective, tick-based system to determine when the approval process should start. A validator starts the tick-based system when a new availability core candidates have been proposed, which can be retrieved via the Runtime API ([Section -sec-num-ref-](chap-runtime-api#sect-rt-api-availability-cores)) , and increments the tick every *500 milliseconds*. Each tick/increment is referred to as a “tranche”, represented as an integer, starting at *0*.

As described in [Section -sec-num-ref-](chapter-anv#sect-availability-assignment-criteria), the validator first executes the VRF mechanism to determine which parachains (availability cores) the validator is assigned to, then an additional VRF mechanism for each assigned parachain to determine the *delayed assignment*. The delayed assignment indicates the tranche at which the validator should start the approval process. A tranche of value *0* implies that the assignment should be started immediately, while later assignees of later tranches wait until it’s their term to issue assignments, determined by their subjective, tick-based system.

Validators are required to track broadcasted assignments by other validators assigned to the same parachain, including verifying the VRF output. Once a valid assignment from a peer was received, the validator must wait for the following approval vote within a certain period as described in [Section -sec-num-ref-](chap-runtime-api#sect-rt-api-session-info) by orienting itself on its local, tick-based system. If the waiting time after a broadcasted assignment exceeds the specified period, the validator interprets this behavior as a “no-show”, indicating that more validators should commit on their tranche until enough approval votes have been collected.

If enough approval votes have been collected as described in [Section -sec-num-ref-](chap-runtime-api#sect-rt-api-session-info), then assignees of later tranches do not have to start the approval process. Therefore, this tranche system serves as a mechanism to ensure that enough candidate approvals from a random set of validators are created without requiring all assigned validators to check the candidate.

###### Definition -def-num- Relay VRF Story {#defn-relay-vrf-story}
:::definition

The relay VRF story is an array of random bytes derived from the VRF submitted within the block by the block author. The relay VRF story, T, is used as input to determine approval voting criteria and generated the following way:

$$
{T}=\text{Transcript}{\left({b}_{{r}},{b}_{{s}},{e}_{{i}},{A}\right)}
$$

**where**  
- $\text{Transcript}$ constructs a VRF transcript ([Definition -def-num-ref-](id-cryptography-encoding#defn-vrf-transcript)).

- ${b}_{{r}}$ is the BABE randomness of the current epoch ([Definition -def-num-ref-](sect-block-production#defn-epoch-randomness)).

- ${b}_{{s}}$ is the current BABE slot ([Definition -def-num-ref-](sect-block-production#defn-epoch-slot)).

- ${e}_{{i}}$ is the current BABE epoch index ([Definition -def-num-ref-](sect-block-production#defn-epoch-slot)).

- ${A}$ is the public key of the authority.

:::
###### Definition -def-num- Availability Core VRF Assignment {#defn-availability-core-vrf-assignment}
:::definition

An availability core VRF assignment is computed by a relay chain validator to determine which availability core ([Definition -def-num-ref-](chapter-anv#defn-availability-core)) a validator is assigned to and should vote for approvals. Computing this assignement relies on the VRF mechanism, transcripts and STROBE operations described further in [Section -sec-num-ref-](id-cryptography-encoding#sect-vrf).

The Runtime dictates how many assignments should be conducted by a validator, as specified in the session index which can be retrieved via the Runtime API ([Section -sec-num-ref-](chap-runtime-api#sect-rt-api-session-info)). The amount of assignments is referred to as “samples”. For each iteration of the number of samples, the validator calculates an individual assignment, ${T}$, where the little-endian encoded sample number, ${s}$, is incremented by one. At the beginning of the iteration, ${S}$ starts at value *0*.

The validator executes the following steps to retrieve a (possibly valid) core index:

$$
{t}_{{1}}\leftarrow\text{Transcript}{\left(\text{'A\&V MOD'}\right)}
$$ 
$$
{t}_{{2}}\leftarrow\text{append}{\left({t}_{{1}},\text{'RC-VRF'},{R}_{{s}}\right)}
$$
$$
{t}_{{3}}\leftarrow\text{append}{\left({t}_{{2}},\text{'sample'},{s}\right)}
$$
$$
{t}_{{4}}\leftarrow\text{append}{\left({t}_{{3}},\text{'vrf-nm-pk'},{p}_{{k}}\right)}
$$
$$
{t}_{{5}}\leftarrow\text{meta-ad}{\left({t}_{{4}},\text{'VRFHash'},\text{False}\right)}
$$
$$
{t}_{{6}}\leftarrow\text{meta-ad}{\left({t}_{{5}},{64}_{{\text{le}}},\text{True}\right)}
$$
$$
{i}\leftarrow\text{prf}{\left({t}_{{6}},\text{False}\right)}
$$
$$
{o}={s}_{{k}}\cdot{i}
$$

where ${s}_{{k}}$ is the secret key, ${p}_{{k}}$ is the public key and ${64}_{{\text{le}}}$ is the integer *64* encoded as little endian. ${R}_{{s}}$ is the relay VRF story as defined in [Definition -def-num-ref-](chapter-anv#defn-relay-vrf-story). Following:

$$
{t}_{{1}}\leftarrow\text{Transcript}{\left(\text{'VRFResult'}\right)}
$$
$$
{t}_{{2}}\leftarrow\text{append}{\left({t}_{{1}},\text{''},\text{'A\&V CORE'}\right)}
$$
$$
{t}_{{3}}\leftarrow\text{append}{\left({t}_{{2}},\text{'vrf-in'},{i}\right)}
$$
$$
{t}_{{4}}\leftarrow\text{append}{\left({t}_{{3}},\text{'vrf-out'},{o}\right)}
$$
$$
{t}_{{5}}\leftarrow\text{meta-ad}{\left({t}_{{4}},\text{''},\text{False}\right)}
$$
$$
{t}_{{6}}\leftarrow\text{meta-ad}{\left({t}_{{5}},{4}_{\text{le}},\text{True}\right)}
$$
$$
{r}\leftarrow\text{prf}{\left({t}_{{6}},\text{False}\right)}
$$
$$
{c}_{{i}}={r}\text{mod}{a}_{{c}}
$$

where ${4}_{{\text{le}}}$ is the integer *4* encoded as little endian, ${r}$ is the 4-byte challenge interpreted as a little endian encoded interger and ${a}_{{c}}$ is the number of availability cores used during the active session, as defined in the session info retrieved by the Runtime API ([Section -sec-num-ref-](chap-runtime-api#sect-rt-api-session-info)). The resulting integer, ${c}_{{i}}$, indicates the parachain Id ([Definition -def-num-ref-](chapter-anv#defn-para-id)). If the parachain Id doesn’t exist, as can be retrieved by the Runtime API ([Section -sec-num-ref-](chap-runtime-api#sect-rt-api-availability-cores)), the validator discards that value and continues with the next iteration. If the Id does exist, the validators continues with the following steps:

$$
{t}_{{1}}\leftarrow\text{Transcript}{\left(\text{'A\&V ASSIGNED'}\right)}
$$ 
$$
{t}_{{2}}\leftarrow\text{append}{\left({t}_{{1}},\text{'core'},{c}_{{i}}\right)}
$$
$$
{p}\leftarrow\text{dleq\_prove}{\left({t}_{{2}},{i}\right)}
$$

where $\text{dleq\_prove}$ is described in [Definition -def-num-ref-](id-cryptography-encoding#defn-vrf-dleq-prove). The resulting values of ${o}$, ${p}$ and ${s}$ are used to construct an assignment certificate ([Definition -def-num-ref-](chapter-anv#defn-assignment-cert)) of kind *0*.

:::
###### Definition -def-num- Delayed Availability Core VRF Assignment {#delayed-availability-core-vrf-assignment}
:::definition

The **delayed availability core VRF assignments** determined at what point a validator should start the approval process as described in [Section -sec-num-ref-](chapter-anv#sect-tranches). Computing this assignement relies on the VRF mechanism, transcripts and STROBE operations described further in [Section -sec-num-ref-](id-cryptography-encoding#sect-vrf).

The validator executes the following steps:

$$
{t}_{{1}}\leftarrow\text{Transcript}{\left(\text{'A\&V DELAY'}\right)}
$$
$$
{t}_{{2}}\leftarrow\text{append}{\left({t}_{{1}},\text{'RC-VRF'},{R}_{{s}}\right)}
$$
$$
{t}_{{3}}\leftarrow\text{append}{\left({t}_{{2}},\text{'core'},{c}_{{i}}\right)}
$$
$$
{t}_{{4}}\leftarrow\text{append}{\left({t}_{{3}},\text{'vrf-nm-pk'},{p}_{{k}}\right)}
$$
$$
{t}_{{5}}\leftarrow\text{meta-ad}{\left({t}_{{4}},\text{'VRFHash'},\text{False}\right)}
$$
$$
{t}_{{6}}\leftarrow\text{meta-ad}{\left({t}_{{5}},{64}_{{\text{le}}},\text{True}\right)}
$$
$$
{i}\leftarrow\text{prf}{\left({t}_{{6}},\text{False}\right)}
$$
$$
{o}={s}_{{k}}\cdot{i}
$$
$$
{p}\leftarrow\text{dleq\_prove}{\left({t}_{{6}},{i}\right)}
$$

The resulting value ${p}$ is the VRF proof ([Definition -def-num-ref-](id-cryptography-encoding#defn-vrf-proof)). $\text{dleq\_prove}$ is described in [Definition -def-num-ref-](id-cryptography-encoding#defn-vrf-dleq-prove).

The tranche, ${d}$, is determined as:

$$
{t}_{{1}}\leftarrow\text{Transcript}{\left(\text{'VRFResult'}\right)}
$$
$$
{t}_{{2}}\leftarrow\text{append}{\left({t}_{{1}},\text{''},\text{'A\&V TRANCHE'}\right)}
$$
$$
{t}_{{3}}\leftarrow\text{append}{\left({t}_{{2}},\text{'vrf-in'},{i}\right)}
$$
$$
{t}_{{4}}\leftarrow\text{append}{\left({t}_{{3}},\text{'vrf-out'},{o}\right)}
$$
$$
{t}_{{5}}\leftarrow\text{meta-ad}{\left({t}_{{4}},\text{''},\text{False}\right)}
$$
$$
{t}_{{6}}\leftarrow\text{meta-ad}{\left({t}_{{5}},{4}_{{\text{le}}},\text{True}\right)}
$$
$$
{c}\leftarrow\text{prf}{\left({t}_{{6}},\text{False}\right)}
$$
$$
{d}={d}\text{mod}{\left({d}_{{c}}+{d}_{{z}}\right)}-{d}_{{z}}
$$

**where**  
- ${d}_{{c}}$ is the number of delayed tranches by total as specified by the session info, retrieved via the Runtime API ([Section -sec-num-ref-](chap-runtime-api#sect-rt-api-session-info)).

- ${d}_{{z}}$ is the zeroth delay tranche width as specified by the session info, retrieved via the Runtime API ([Section -sec-num-ref-](chap-runtime-api#sect-rt-api-session-info))..

The resulting tranche, ${n}$, cannot be less than ${0}$. If the tranche is less than ${0}$, then ${d}={0}$. The resulting values ${o}$, ${p}$ and ${c}_{{i}}$ are used to construct an assignment certificate (\<[Definition -def-num-ref-](chapter-anv#defn-assignment-cert)) of kind *1*.

:::
###### Definition -def-num- Assignment Certificate {#defn-assignment-cert}
:::definition

The **Assignment Certificate** proves to the network that a Polkadot validator is assigned to an availability core and is therefore qualified for the approval of candidates, as clarified in [Definition -def-num-ref-](chapter-anv#defn-availability-core-vrf-assignment). This certificate contains the computed VRF output and is a datastructure of the following format:

$$
{\left({k},{o},{p}\right)}
$$
$$
{k}={\left\lbrace\begin{matrix}{0}&\rightarrow&{s}\\{1}&\rightarrow&{c}_{{i}}\end{matrix}\right.}
$$

where ${k}$ indicates the kind of the certificate, respectively the value *0* proves the availability core assignment ([Definition -def-num-ref-](chapter-anv#defn-availability-core-vrf-assignment)), followed by the sample number ${s}$, and the value *1* proves the delayed availability core assignment ([Definition -def-num-ref-](chapter-anv#delayed-availability-core-vrf-assignment)), followed by the core index ${c}_{{i}}$ ([Section -sec-num-ref-](chap-runtime-api#sect-rt-api-availability-cores)). ${o}$ is the VRF output and ${p}$ is the VRF proof.

:::
## -sec-num- Disputes {#sect-disputes}

:::info
Disputes are not documented yet.
:::

## -sec-num- Definitions {#sect-anv-definitions}

###### Definition -def-num- Collator {#defn-collator}
:::definition

A collator is a parachain node that sends parachain blocks, known as candidates ([Definition -def-num-ref-](chapter-anv#defn-candidate)), to the relay chain validators. The relay chain validators are not concerned how the collator works or how it creates candidates.

:::
###### Definition -def-num- Candidate {#defn-candidate}
:::definition

A candidate is a submitted parachain block ([Definition -def-num-ref-](chapter-anv#defn-para-block)) to the relay chain validators. A parachain block stops being referred to as a candidate as soon it has been finalized.

:::
###### Definition -def-num- Parachain Block {#defn-para-block}
:::definition

A parachain block or a Proof-of-Validity block (PoV block) contains the necessary data for the parachain specific state transition logic. Relay chain validators are not concerned with the inner structure of the block and treat it as a byte array.

:::
###### Definition -def-num- Head Data {#defn-head-data}
:::definition

The head data is contains information about a parachain block ([Definition -def-num-ref-](chapter-anv#defn-para-block)). The head data is returned by executing the parachain Runtime and relay chain validators are not concerned with its inner structure and treat it as a byte arrays.

:::
###### Definition -def-num- Parachain Id {#defn-para-id}
:::definition

The Parachain Id is a unique, unsigned 32-bit integer which serves as an identifier of a parachain, assigned by the Runtime.

:::
###### Definition -def-num- Availability Core {#defn-availability-core}
:::definition

Availability cores are slots used to process parachains. The Runtime assigns each parachain to a availability core and validators can fetch information about the cores, such as parachain block candidates, by calling the appropriate Runtime API ([Section -sec-num-ref-](chap-runtime-api#sect-rt-api-availability-cores)). Validators are not concerned with the internal workings from the Runtimes perspective.

:::
###### Definition -def-num- Validator Groups {#defn-validator-groups}
:::definition

Validator groups indicate which validators are responsible for creating backable candidates for parachains ([Section -sec-num-ref-](chapter-anv#sect-candidate-backing)), and are assigned by the Runtime ([Section -sec-num-ref-](chap-runtime-api#sect-rt-api-validator-groups)). Validators are not concerned with the internal workings from the Runtimes perspective. Collators can use this information for submitting blocks.

:::
###### Definition -def-num- Upward Message {#defn-upward-message}
:::definition

An upward message is an opaque byte array sent from a parachain to a relay chain.

:::
###### Definition -def-num- Downward Message {#defn-downward-message}
:::definition

A downward message is an opaque byte array received by the parachain from the relay chain.

:::
###### Definition -def-num- Outbound HRMP Message {#defn-outbound-hrmp-message}
:::definition

An outbound HRMP message (Horizontal Relay-routed Message Passing) is sent from the perspective of a sender of a parachain to an other parachain by passing it through the relay chain. It’s a datastructure of the following format:

$$
{\left({I},{M}\right)}
$$

where ${I}$ is the recipient Id ([Definition -def-num-ref-](chapter-anv#defn-para-id)) and ${M}$ is an upward message ([Definition -def-num-ref-](chapter-anv#defn-upward-message)).

:::
###### Definition -def-num- Inbound HRMP Message {#defn-inbound-hrmp-message}
:::definition

An inbound HRMP message (Horizontal Relay-routed Message Passing) is seen from the perspective of a recipient parachain sent from an other parachain by passing it through the relay chain. It’s a datastructure of the following format:

$$
{\left({N},{M}\right)}
$$

where ${N}$ is the unsigned 32-bit integer indicating the relay chain block number at which the message was passed down to the recipient parachain and ${M}$ is a downward message ([Definition -def-num-ref-](chapter-anv#defn-downward-message)).

:::
###### Definition -def-num- Bitfield Array {#defn-bitfield-array}
:::definition

A bitfield array contains single-bit values which indidate whether a candidate is available. The number of items is equal of to the number of availability cores ([Definition -def-num-ref-](chapter-anv#defn-availability-core)) and each bit represents a vote on the corresponding core in the given order. Respectively, if the single bit equals 1, then the Polkadot validator claims that the availability core is occupied, there exists a committed candidate receipt ([Definition -def-num-ref-](chapter-anv#defn-committed-candidate-receipt)) and that the validator has a stored chunk of the parachain block ([Definition -def-num-ref-](chapter-anv#defn-para-block)).
