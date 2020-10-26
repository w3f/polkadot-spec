<TeXmacs|1.99.12>

<style|<tuple|tmbook|std-latex|algorithmacs-style|old-dots>>

<\body>
  <\hide-preamble>
    <assign|cdummy|<macro|\<cdot\>>>

    <assign|nobracket|<macro|>>

    <assign|nosymbol|<macro|>>

    <assign|tmem|<macro|1|<with|font-shape|italic|<arg|1>>>>

    <assign|tmname|<macro|1|<with|font-shape|small-caps|<arg|1>>>>

    <assign|tmop|<macro|1|<math|<with|math-font-family|rm|<arg|1>>>>>

    <assign|tmrsub|<macro|1|<rsub|<math|<with|math-font-family|rm|<arg|1>>>>>>

    <assign|tmsamp|<macro|1|<with|font-family|ss|<arg|1>>>>

    <assign|tmstrong|<macro|1|<with|font-series|bold|<arg|1>>>>

    <assign|tmtextbf|<macro|1|<with|font-series|bold|<arg|1>>>>

    <assign|tmtextit|<macro|1|<with|font-shape|italic|<arg|1>>>>

    <assign|tmverbatim|<macro|1|<with|font-family|tt|<arg|1>>>>

    <new-theorem|definition|Definition>

    <new-theorem|notation|Notation>

    \;
  </hide-preamble>

  <doc-data|<doc-title|The Polkadot Host<next-line><with|font-size|1.41|Protocol
  Specification>>|<doc-date|<date|>>>

  <\table-of-contents|toc>
    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|1.<space|2spc>Background>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-1><vspace|0.5fn>

    1.1.<space|2spc>Introduction <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-2>

    1.2.<space|2spc>Definitions and Conventions
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-3>

    <with|par-left|1tab|1.2.1.<space|2spc>Block Tree
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-14>>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|2.<space|2spc>State
    Specification> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-28><vspace|0.5fn>

    2.1.<space|2spc>State Storage and Storage Trie
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-29>

    <with|par-left|1tab|2.1.1.<space|2spc>Accessing System Storage
    \ <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-30>>

    <with|par-left|1tab|2.1.2.<space|2spc>The General Tree Structure
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-32>>

    <with|par-left|1tab|2.1.3.<space|2spc>Trie Structure
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-33>>

    <with|par-left|1tab|2.1.4.<space|2spc>Merkle Proof
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-34>>

    2.2.<space|2spc>Child Storage <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-35>

    <with|par-left|1tab|2.2.1.<space|2spc>Child Tries
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-36>>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|3.<space|2spc>State
    Transition> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-37><vspace|0.5fn>

    3.1.<space|2spc>Interactions with Runtime
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-38>

    <with|par-left|1tab|3.1.1.<space|2spc>Loading the Runtime Code
    \ \ \ <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-39>>

    <with|par-left|1tab|3.1.2.<space|2spc>Code Executor
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-40>>

    <with|par-left|2tab|3.1.2.1.<space|2spc>Access to Runtime API
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-41>>

    <with|par-left|2tab|3.1.2.2.<space|2spc>Sending Arguments to Runtime
    \ <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-42>>

    <with|par-left|2tab|3.1.2.3.<space|2spc>The Return Value from a Runtime
    Entry <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-43>>

    <with|par-left|2tab|3.1.2.4.<space|2spc>Handling Runtimes update to the
    State <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-44>>

    3.2.<space|2spc>Extrinsics <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-45>

    <with|par-left|1tab|3.2.1.<space|2spc>Preliminaries
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-46>>

    <with|par-left|1tab|3.2.2.<space|2spc>Transactions
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-47>>

    <with|par-left|2tab|3.2.2.1.<space|2spc>Transaction Submission
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-48>>

    <with|par-left|1tab|3.2.3.<space|2spc>Transaction Queue
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-49>>

    <with|par-left|2tab|3.2.3.1.<space|2spc>Inherents
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-53>>

    3.3.<space|2spc>State Replication <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-55>

    <with|par-left|1tab|3.3.1.<space|2spc>Block Format
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-56>>

    <with|par-left|2tab|3.3.1.1.<space|2spc>Block Header
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-57>>

    <with|par-left|2tab|3.3.1.2.<space|2spc>Justified Block Header
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-59>>

    <with|par-left|2tab|3.3.1.3.<space|2spc>Block Body
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-60>>

    <with|par-left|1tab|3.3.2.<space|2spc>Importing and Validating Block
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-61>>

    <with|par-left|1tab|3.3.3.<space|2spc>Managaing Multiple Variants of
    State <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-62>>

    <with|par-left|1tab|3.3.4.<space|2spc>Changes Trie
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-63>>

    <with|par-left|2tab|3.3.4.1.<space|2spc>Key to extrinsics pairs
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-65>>

    <with|par-left|2tab|3.3.4.2.<space|2spc>Key to block pairs
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-66>>

    <with|par-left|2tab|3.3.4.3.<space|2spc>Key to Child Changes Trie pairs
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-67>>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|4.<space|2spc>Networking>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-68><vspace|0.5fn>

    4.1.<space|2spc>Introduction <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-69>

    <with|par-left|1tab|4.1.1.<space|2spc>External Documentation
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-70>>

    <with|par-left|1tab|4.1.2.<space|2spc>Discovery mechanism
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-71>>

    <with|par-left|1tab|4.1.3.<space|2spc>Connection establishment
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-72>>

    <with|par-left|1tab|4.1.4.<space|2spc>Substreams
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-73>>

    4.2.<space|2spc>Network Messages <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-74>

    <with|par-left|1tab|4.2.1.<space|2spc>API Package
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-75>>

    <with|par-left|2tab|4.2.1.1.<space|2spc>BlockRequest
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-76>>

    <with|par-left|2tab|4.2.1.2.<space|2spc>BlockResponse
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-77>>

    <with|par-left|1tab|4.2.2.<space|2spc>Light Package
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-78>>

    <with|par-left|2tab|4.2.2.1.<space|2spc>Request
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-79>>

    <with|par-left|2tab|4.2.2.2.<space|2spc>Response
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-80>>

    <with|par-left|2tab|4.2.2.3.<space|2spc>RemoteCallRequest
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-81>>

    <with|par-left|2tab|4.2.2.4.<space|2spc>RemoteCallResponse
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-82>>

    <with|par-left|2tab|4.2.2.5.<space|2spc>RemoteReadRequest
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-83>>

    <with|par-left|2tab|4.2.2.6.<space|2spc>RemoteReadResponse
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-84>>

    <with|par-left|2tab|4.2.2.7.<space|2spc>RemoteReadChildRequest
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-85>>

    <with|par-left|2tab|4.2.2.8.<space|2spc>RemoteHeaderRequest
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-86>>

    <with|par-left|2tab|4.2.2.9.<space|2spc>RemoteHeaderResponse
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-87>>

    <with|par-left|2tab|4.2.2.10.<space|2spc>RemoteChangesRequest
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-88>>

    <with|par-left|2tab|4.2.2.11.<space|2spc>RemoteChangesResponse
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-89>>

    <with|par-left|1tab|4.2.3.<space|2spc>Finality Package
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-90>>

    <with|par-left|2tab|4.2.3.1.<space|2spc>FinalityProofRequest
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-91>>

    <with|par-left|2tab|4.2.3.2.<space|2spc>FinalityProofResponse
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-92>>

    4.3.<space|2spc> To be migrated <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-93>

    <with|par-left|1tab|4.3.1.<space|2spc>Node Identities and Addresses
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-94>>

    <with|par-left|1tab|4.3.2.<space|2spc>Discovery Mechanisms
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-95>>

    <with|par-left|1tab|4.3.3.<space|2spc>Transport Protocol
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-96>>

    <with|par-left|2tab|4.3.3.1.<space|2spc>Encryption
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-97>>

    <with|par-left|2tab|4.3.3.2.<space|2spc>Multiplexing
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-98>>

    <with|par-left|1tab|4.3.4.<space|2spc>Substreams
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-99>>

    <with|par-left|2tab|4.3.4.1.<space|2spc>Periodic Ephemeral Substreams
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-100>>

    <with|par-left|2tab|4.3.4.2.<space|2spc>Polkadot Communication Substream
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-101>>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|5.<space|2spc>Bootstrapping>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-102><vspace|0.5fn>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|6.<space|2spc>Consensus>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-103><vspace|0.5fn>

    6.1.<space|2spc>Common Consensus Structures
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-104>

    <with|par-left|1tab|6.1.1.<space|2spc>Consensus Authority Set
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-105>>

    <with|par-left|1tab|6.1.2.<space|2spc>Runtime-to-Consensus Engine Message
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-106>>

    6.2.<space|2spc>Block Production <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-108>

    <with|par-left|1tab|6.2.1.<space|2spc>Preliminaries
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-109>>

    <with|par-left|1tab|6.2.2.<space|2spc>Block Production Lottery
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-110>>

    <with|par-left|1tab|6.2.3.<space|2spc>Slot Number Calculation
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-111>>

    <with|par-left|1tab|6.2.4.<space|2spc>Block Production
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-112>>

    <with|par-left|1tab|6.2.5.<space|2spc>Epoch Randomness
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-113>>

    <with|par-left|1tab|6.2.6.<space|2spc>Verifying Authorship Right
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-114>>

    <with|par-left|1tab|6.2.7.<space|2spc>Block Building Process
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-115>>

    6.3.<space|2spc>Finality <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-116>

    <with|par-left|1tab|6.3.1.<space|2spc>Preliminaries
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-117>>

    <with|par-left|1tab|6.3.2.<space|2spc>GRANDPA Messages Specification
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-118>>

    <with|par-left|2tab|6.3.2.1.<space|2spc>Vote Messages
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-120>>

    <with|par-left|2tab|6.3.2.2.<space|2spc>Finalizing Message
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-121>>

    <with|par-left|2tab|6.3.2.3.<space|2spc>Catch-up Messages
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-122>>

    <with|par-left|1tab|6.3.3.<space|2spc>Initiating the GRANDPA State
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-123>>

    <with|par-left|2tab|6.3.3.1.<space|2spc>Voter Set Changes
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-124>>

    <with|par-left|1tab|6.3.4.<space|2spc>Voting Process in Round
    <with|mode|math|r> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-125>>

    6.4.<space|2spc>Block Finalization <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-126>

    <with|par-left|1tab|6.4.1.<space|2spc>Catching up
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-127>>

    <with|par-left|2tab|6.4.1.1.<space|2spc>Sending catch-up requests
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-128>>

    <with|par-left|2tab|6.4.1.2.<space|2spc>Processing catch-up requests
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-129>>

    <with|par-left|2tab|6.4.1.3.<space|2spc>Processing catch-up responses
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-130>>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|7.<space|2spc>Availability
    & Validity> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-131><vspace|0.5fn>

    7.1.<space|2spc>Introduction <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-132>

    7.2.<space|2spc>Preliminaries <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-133>

    <with|par-left|1tab|7.2.1.<space|2spc>Extra Validation Data
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-134>>

    7.3.<space|2spc>Overal process <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-135>

    7.4.<space|2spc>Candidate Selection <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-137>

    7.5.<space|2spc>Candidate Backing <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-138>

    <with|par-left|1tab|7.5.1.<space|2spc>Inclusion of candidate receipt on
    the relay chain <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-139>>

    7.6.<space|2spc>PoV Distribution <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-140>

    <with|par-left|1tab|7.6.1.<space|2spc>Primary Validation Disagreement
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-141>>

    7.7.<space|2spc>Availability <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-142>

    7.8.<space|2spc>Distribution of Chunks
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-143>

    7.9.<space|2spc>Announcing Availability
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-144>

    <with|par-left|1tab|7.9.1.<space|2spc>Processing on-chain availability
    data <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-145>>

    7.10.<space|2spc>Publishing Attestations
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-146>

    7.11.<space|2spc>Secondary Approval checking
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-147>

    <with|par-left|1tab|7.11.1.<space|2spc>Approval Checker Assignment
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-148>>

    <with|par-left|1tab|7.11.2.<space|2spc>VRF computation
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-149>>

    <with|par-left|1tab|7.11.3.<space|2spc>One-Shot Approval Checker
    Assignemnt <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-150>>

    <with|par-left|1tab|7.11.4.<space|2spc>Extra Approval Checker Assigment
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-151>>

    <with|par-left|1tab|7.11.5.<space|2spc>Additional Checking in Case of
    Equivocation <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-152>>

    7.12.<space|2spc>The Approval Check <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-153>

    <with|par-left|2tab|7.12.0.1.<space|2spc>Retrieval
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-154>>

    <with|par-left|2tab|7.12.0.2.<space|2spc>Reconstruction
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-155>>

    <with|par-left|1tab|7.12.1.<space|2spc>Verification
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-156>>

    <with|par-left|1tab|7.12.2.<space|2spc>Process validity and invalidity
    messages <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-157>>

    <with|par-left|1tab|7.12.3.<space|2spc>Invalidity Escalation
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-158>>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|8.<space|2spc>Message
    Passing> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-159><vspace|0.5fn>

    8.1.<space|2spc>Overview <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-160>

    8.2.<space|2spc>Message Queue Chain (MQC)
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-162>

    8.3.<space|2spc>HRMP <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-164>

    <with|par-left|1tab|8.3.1.<space|2spc>Channels
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-165>>

    <with|par-left|1tab|8.3.2.<space|2spc>Opening Channels
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-166>>

    <with|par-left|2tab|8.3.2.1.<space|2spc>Workflow
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-167>>

    <with|par-left|1tab|8.3.3.<space|2spc>Accepting Channels
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-168>>

    <with|par-left|2tab|8.3.3.1.<space|2spc>Workflow
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-169>>

    <with|par-left|1tab|8.3.4.<space|2spc>Closing Channels
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-170>>

    <with|par-left|1tab|8.3.5.<space|2spc>Workflow
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-171>>

    <with|par-left|1tab|8.3.6.<space|2spc>Sending messages
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-172>>

    <with|par-left|1tab|8.3.7.<space|2spc>Receiving Messages
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-173>>

    8.4.<space|2spc>XCMP <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-174>

    <with|par-left|1tab|8.4.1.<space|2spc>CST: Channel State Table
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-176>>

    <with|par-left|1tab|8.4.2.<space|2spc>Message content
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-177>>

    <with|par-left|1tab|8.4.3.<space|2spc>Watermark
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-178>>

    8.5.<space|2spc>SPREE <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-179>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|Appendix
    A.<space|2spc>Cryptographic Algorithms>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-180><vspace|0.5fn>

    A.1.<space|2spc>Hash Functions <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-181>

    A.2.<space|2spc>BLAKE2 <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-182>

    A.3.<space|2spc>Randomness <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-183>

    A.4.<space|2spc>VRF <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-184>

    A.5.<space|2spc>Cryptographic Keys <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-185>

    <with|par-left|1tab|A.5.1.<space|2spc>Holding and staking funds
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-188>>

    <with|par-left|1tab|A.5.2.<space|2spc>Creating a Controller key
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-189>>

    <with|par-left|1tab|A.5.3.<space|2spc>Designating a proxy for voting
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-190>>

    <with|par-left|1tab|A.5.4.<space|2spc>Controller settings
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-191>>

    <with|par-left|1tab|A.5.5.<space|2spc>Certifying keys
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-192>>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|Appendix
    B.<space|2spc>Auxiliary Encodings> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-193><vspace|0.5fn>

    B.1.<space|2spc>SCALE Codec <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-194>

    <with|par-left|1tab|B.1.1.<space|2spc>Length and Compact Encoding
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-195>>

    B.2.<space|2spc>Hex Encoding <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-196>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|Appendix
    C.<space|2spc>Genesis State Specification>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-197><vspace|0.5fn>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|Appendix
    D.<space|2spc>Network Messages> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-199><vspace|0.5fn>

    D.1.<space|2spc>Detailed Message Structure
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-201>

    <with|par-left|1tab|D.1.1.<space|2spc>Status Message
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-202>>

    <with|par-left|1tab|D.1.2.<space|2spc>Block Request Message
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-204>>

    <with|par-left|1tab|D.1.3.<space|2spc>Block Response Message
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-206>>

    <with|par-left|1tab|D.1.4.<space|2spc>Block Announce Message
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-207>>

    <with|par-left|1tab|D.1.5.<space|2spc>Transactions
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-208>>

    <with|par-left|1tab|D.1.6.<space|2spc>Consensus Message
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-209>>

    <with|par-left|1tab|D.1.7.<space|2spc>Neighbor Packet
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-210>>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|Appendix
    E.<space|2spc>Polkadot Host API> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-211><vspace|0.5fn>

    E.1.<space|2spc>Storage <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-212>

    <with|par-left|1tab|E.1.1.<space|2spc><with|font-family|tt|language|verbatim|ext_storage_set>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-213>>

    <with|par-left|2tab|E.1.1.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-214>>

    <with|par-left|1tab|E.1.2.<space|2spc><with|font-family|tt|language|verbatim|ext_storage_get>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-215>>

    <with|par-left|2tab|E.1.2.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-216>>

    <with|par-left|1tab|E.1.3.<space|2spc><with|font-family|tt|language|verbatim|ext_storage_read>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-217>>

    <with|par-left|2tab|E.1.3.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-218>>

    <with|par-left|1tab|E.1.4.<space|2spc><with|font-family|tt|language|verbatim|ext_storage_clear>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-219>>

    <with|par-left|2tab|E.1.4.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-220>>

    <with|par-left|1tab|E.1.5.<space|2spc><with|font-family|tt|language|verbatim|ext_storage_exists>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-221>>

    <with|par-left|2tab|E.1.5.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-222>>

    <with|par-left|1tab|E.1.6.<space|2spc><with|font-family|tt|language|verbatim|ext_storage_clear_prefix>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-223>>

    <with|par-left|2tab|E.1.6.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-224>>

    <with|par-left|1tab|E.1.7.<space|2spc><with|font-family|tt|language|verbatim|ext_storage_append>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-225>>

    <with|par-left|2tab|E.1.7.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-226>>

    <with|par-left|1tab|E.1.8.<space|2spc><with|font-family|tt|language|verbatim|ext_storage_root>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-227>>

    <with|par-left|2tab|E.1.8.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-228>>

    <with|par-left|1tab|E.1.9.<space|2spc><with|font-family|tt|language|verbatim|ext_storage_changes_root>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-229>>

    <with|par-left|2tab|E.1.9.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-230>>

    <with|par-left|1tab|E.1.10.<space|2spc><with|font-family|tt|language|verbatim|ext_storage_next_key>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-231>>

    <with|par-left|2tab|E.1.10.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-232>>

    <with|par-left|1tab|E.1.11.<space|2spc><with|font-family|tt|language|verbatim|ext_storage_start_transaction>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-233>>

    <with|par-left|2tab|E.1.11.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-234>>

    <with|par-left|1tab|E.1.12.<space|2spc><with|font-family|tt|language|verbatim|ext_storage_rollback_transaction>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-235>>

    <with|par-left|2tab|E.1.12.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-236>>

    <with|par-left|1tab|E.1.13.<space|2spc><with|font-family|tt|language|verbatim|ext_storage_commit_transaction>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-237>>

    <with|par-left|2tab|E.1.13.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-238>>

    E.2.<space|2spc>Child Storage <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-239>

    <with|par-left|1tab|E.2.1.<space|2spc><with|font-family|tt|language|verbatim|ext_default_child_storage_set>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-240>>

    <with|par-left|2tab|E.2.1.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-241>>

    <with|par-left|1tab|E.2.2.<space|2spc><with|font-family|tt|language|verbatim|ext_default_child_storage_get>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-242>>

    <with|par-left|2tab|E.2.2.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-243>>

    <with|par-left|1tab|E.2.3.<space|2spc><with|font-family|tt|language|verbatim|ext_default_child_storage_read>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-244>>

    <with|par-left|2tab|E.2.3.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-245>>

    <with|par-left|1tab|E.2.4.<space|2spc><with|font-family|tt|language|verbatim|ext_default_child_storage_clear>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-246>>

    <with|par-left|2tab|E.2.4.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-247>>

    <with|par-left|1tab|E.2.5.<space|2spc><with|font-family|tt|language|verbatim|ext_default_child_storage_storage_kill>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-248>>

    <with|par-left|2tab|E.2.5.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-249>>

    <with|par-left|1tab|E.2.6.<space|2spc><with|font-family|tt|language|verbatim|ext_default_child_storage_exists>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-250>>

    <with|par-left|2tab|E.2.6.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-251>>

    <with|par-left|1tab|E.2.7.<space|2spc><with|font-family|tt|language|verbatim|ext_default_child_storage_clear_prefix>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-252>>

    <with|par-left|2tab|E.2.7.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-253>>

    <with|par-left|1tab|E.2.8.<space|2spc><with|font-family|tt|language|verbatim|ext_default_child_storage_root>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-254>>

    <with|par-left|2tab|E.2.8.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-255>>

    <with|par-left|1tab|E.2.9.<space|2spc><with|font-family|tt|language|verbatim|ext_default_child_storage_next_key>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-256>>

    <with|par-left|2tab|E.2.9.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-257>>

    E.3.<space|2spc>Crypto <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-258>

    <with|par-left|1tab|E.3.1.<space|2spc><with|font-family|tt|language|verbatim|ext_crypto_ed25519_public_keys>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-261>>

    <with|par-left|2tab|E.3.1.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-262>>

    <with|par-left|1tab|E.3.2.<space|2spc><with|font-family|tt|language|verbatim|ext_crypto_ed25519_generate>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-263>>

    <with|par-left|2tab|E.3.2.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-264>>

    <with|par-left|1tab|E.3.3.<space|2spc><with|font-family|tt|language|verbatim|ext_crypto_ed25519_sign>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-265>>

    <with|par-left|2tab|E.3.3.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-266>>

    <with|par-left|1tab|E.3.4.<space|2spc><with|font-family|tt|language|verbatim|ext_crypto_ed25519_verify>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-267>>

    <with|par-left|2tab|E.3.4.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-268>>

    <with|par-left|1tab|E.3.5.<space|2spc><with|font-family|tt|language|verbatim|ext_crypto_sr25519_public_keys>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-269>>

    <with|par-left|2tab|E.3.5.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-270>>

    <with|par-left|1tab|E.3.6.<space|2spc><with|font-family|tt|language|verbatim|ext_crypto_sr25519_generate>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-271>>

    <with|par-left|2tab|E.3.6.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-272>>

    <with|par-left|1tab|E.3.7.<space|2spc><with|font-family|tt|language|verbatim|ext_crypto_sr25519_sign>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-273>>

    <with|par-left|2tab|E.3.7.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-274>>

    <with|par-left|1tab|E.3.8.<space|2spc><with|font-family|tt|language|verbatim|ext_crypto_sr25519_verify>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-275>>

    <with|par-left|2tab|E.3.8.1.<space|2spc>Version 2 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-276>>

    <with|par-left|2tab|E.3.8.2.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-277>>

    <with|par-left|1tab|E.3.9.<space|2spc><with|font-family|tt|language|verbatim|ext_crypto_ecdsa_public_keys>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-278>>

    <with|par-left|2tab|E.3.9.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-279>>

    <with|par-left|1tab|E.3.10.<space|2spc><with|font-family|tt|language|verbatim|ext_crypto_ecdsa_generate>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-280>>

    <with|par-left|2tab|E.3.10.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-281>>

    <with|par-left|1tab|E.3.11.<space|2spc><with|font-family|tt|language|verbatim|ext_crypto_ecdsa_sign>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-282>>

    <with|par-left|2tab|E.3.11.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-283>>

    <with|par-left|1tab|E.3.12.<space|2spc><with|font-family|tt|language|verbatim|ext_crypto_ecdsa_verify>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-284>>

    <with|par-left|2tab|E.3.12.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-285>>

    <with|par-left|1tab|E.3.13.<space|2spc><with|font-family|tt|language|verbatim|ext_crypto_secp256k1_ecdsa_recover>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-286>>

    <with|par-left|2tab|E.3.13.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-287>>

    <with|par-left|1tab|E.3.14.<space|2spc><with|font-family|tt|language|verbatim|ext_crypto_secp256k1_ecdsa_recover_compressed>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-288>>

    <with|par-left|2tab|E.3.14.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-289>>

    <with|par-left|1tab|E.3.15.<space|2spc><with|font-family|tt|language|verbatim|ext_crypto_start_batch_verify>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-290>>

    <with|par-left|2tab|E.3.15.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-291>>

    <with|par-left|1tab|E.3.16.<space|2spc><with|font-family|tt|language|verbatim|ext_crypto_finish_batch_verify>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-292>>

    <with|par-left|2tab|E.3.16.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-293>>

    E.4.<space|2spc>Hashing <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-294>

    <with|par-left|1tab|E.4.1.<space|2spc><with|font-family|tt|language|verbatim|ext_hashing_keccak_256>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-295>>

    <with|par-left|2tab|E.4.1.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-296>>

    <with|par-left|1tab|E.4.2.<space|2spc><with|font-family|tt|language|verbatim|ext_hashing_sha2_256>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-297>>

    <with|par-left|2tab|E.4.2.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-298>>

    <with|par-left|1tab|E.4.3.<space|2spc><with|font-family|tt|language|verbatim|ext_hashing_blake2_128>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-299>>

    <with|par-left|2tab|E.4.3.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-300>>

    <with|par-left|1tab|E.4.4.<space|2spc><with|font-family|tt|language|verbatim|ext_hashing_blake2_256>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-301>>

    <with|par-left|2tab|E.4.4.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-302>>

    <with|par-left|1tab|E.4.5.<space|2spc><with|font-family|tt|language|verbatim|ext_hashing_twox_64>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-303>>

    <with|par-left|2tab|E.4.5.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-304>>

    <with|par-left|1tab|E.4.6.<space|2spc><with|font-family|tt|language|verbatim|ext_hashing_twox_128>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-305>>

    <with|par-left|2tab|E.4.6.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-306>>

    <with|par-left|1tab|E.4.7.<space|2spc><with|font-family|tt|language|verbatim|ext_hashing_twox_256>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-307>>

    <with|par-left|2tab|E.4.7.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-308>>

    E.5.<space|2spc>Offchain <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-309>

    <with|par-left|1tab|E.5.1.<space|2spc><with|font-family|tt|language|verbatim|ext_offchain_is_validator>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-311>>

    <with|par-left|2tab|E.5.1.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-312>>

    <with|par-left|1tab|E.5.2.<space|2spc><with|font-family|tt|language|verbatim|ext_offchain_submit_transaction>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-313>>

    <with|par-left|2tab|E.5.2.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-314>>

    <with|par-left|1tab|E.5.3.<space|2spc><with|font-family|tt|language|verbatim|ext_offchain_network_state>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-315>>

    <with|par-left|2tab|E.5.3.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-316>>

    <with|par-left|1tab|E.5.4.<space|2spc><with|font-family|tt|language|verbatim|ext_offchain_timestamp>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-317>>

    <with|par-left|2tab|E.5.4.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-318>>

    <with|par-left|1tab|E.5.5.<space|2spc><with|font-family|tt|language|verbatim|ext_offchain_sleep_until>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-319>>

    <with|par-left|2tab|E.5.5.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-320>>

    <with|par-left|1tab|E.5.6.<space|2spc><with|font-family|tt|language|verbatim|ext_offchain_random_seed>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-321>>

    <with|par-left|2tab|E.5.6.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-322>>

    <with|par-left|1tab|E.5.7.<space|2spc><with|font-family|tt|language|verbatim|ext_offchain_local_storage_set>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-323>>

    <with|par-left|2tab|E.5.7.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-324>>

    <with|par-left|1tab|E.5.8.<space|2spc><with|font-family|tt|language|verbatim|ext_offchain_local_storage_compare_and_set>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-325>>

    <with|par-left|2tab|E.5.8.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-326>>

    <with|par-left|1tab|E.5.9.<space|2spc><with|font-family|tt|language|verbatim|ext_offchain_local_storage_get>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-327>>

    <with|par-left|2tab|E.5.9.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-328>>

    <with|par-left|1tab|E.5.10.<space|2spc><with|font-family|tt|language|verbatim|ext_offchain_http_request_start>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-329>>

    <with|par-left|2tab|E.5.10.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-330>>

    <with|par-left|1tab|E.5.11.<space|2spc><with|font-family|tt|language|verbatim|ext_offchain_http_request_add_header>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-331>>

    <with|par-left|2tab|E.5.11.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-332>>

    <with|par-left|1tab|E.5.12.<space|2spc><with|font-family|tt|language|verbatim|ext_offchain_http_request_write_body>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-333>>

    <with|par-left|2tab|E.5.12.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-334>>

    <with|par-left|1tab|E.5.13.<space|2spc><with|font-family|tt|language|verbatim|ext_offchain_http_response_wait>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-335>>

    <with|par-left|2tab|E.5.13.1.<space|2spc>Version 1- Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-336>>

    <with|par-left|1tab|E.5.14.<space|2spc><with|font-family|tt|language|verbatim|ext_offchain_http_response_headers>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-337>>

    <with|par-left|2tab|E.5.14.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-338>>

    <with|par-left|1tab|E.5.15.<space|2spc><with|font-family|tt|language|verbatim|ext_offchain_http_response_read_body>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-339>>

    <with|par-left|2tab|E.5.15.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-340>>

    E.6.<space|2spc>Trie <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-341>

    <with|par-left|1tab|E.6.1.<space|2spc><with|font-family|tt|language|verbatim|ext_trie_blake2_256_root>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-342>>

    <with|par-left|2tab|E.6.1.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-343>>

    <with|par-left|1tab|E.6.2.<space|2spc><with|font-family|tt|language|verbatim|ext_trie_blake2_256_ordered_root>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-344>>

    <with|par-left|2tab|E.6.2.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-345>>

    <with|par-left|1tab|E.6.3.<space|2spc><with|font-family|tt|language|verbatim|ext_trie_keccak_256_root>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-346>>

    <with|par-left|2tab|E.6.3.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-347>>

    <with|par-left|1tab|E.6.4.<space|2spc><with|font-family|tt|language|verbatim|ext_trie_keccak_256_ordered_root>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-348>>

    <with|par-left|2tab|E.6.4.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-349>>

    E.7.<space|2spc>Miscellaneous <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-350>

    <with|par-left|1tab|E.7.1.<space|2spc><with|font-family|tt|language|verbatim|ext_misc_chain_id>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-351>>

    <with|par-left|2tab|E.7.1.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-352>>

    <with|par-left|1tab|E.7.2.<space|2spc><with|font-family|tt|language|verbatim|ext_misc_print_num>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-353>>

    <with|par-left|2tab|E.7.2.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-354>>

    <with|par-left|1tab|E.7.3.<space|2spc><with|font-family|tt|language|verbatim|ext_misc_print_utf8>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-355>>

    <with|par-left|2tab|E.7.3.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-356>>

    <with|par-left|1tab|E.7.4.<space|2spc><with|font-family|tt|language|verbatim|ext_misc_print_hex>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-357>>

    <with|par-left|2tab|E.7.4.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-358>>

    <with|par-left|1tab|E.7.5.<space|2spc><with|font-family|tt|language|verbatim|ext_misc_runtime_version>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-359>>

    <with|par-left|2tab|E.7.5.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-360>>

    E.8.<space|2spc>Allocator <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-361>

    <with|par-left|1tab|E.8.1.<space|2spc><with|font-family|tt|language|verbatim|ext_allocator_malloc>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-362>>

    <with|par-left|2tab|E.8.1.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-363>>

    <with|par-left|1tab|E.8.2.<space|2spc><with|font-family|tt|language|verbatim|ext_allocator_free>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-364>>

    <with|par-left|2tab|E.8.2.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-365>>

    E.9.<space|2spc>Logging <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-366>

    <with|par-left|1tab|E.9.1.<space|2spc><with|font-family|tt|language|verbatim|ext_logging_log>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-368>>

    <with|par-left|2tab|E.9.1.1.<space|2spc>Version 1 - Prototype
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-369>>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|Appendix
    F.<space|2spc>Legacy Polkadot Host API>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-370><vspace|0.5fn>

    F.1.<space|2spc>Storage <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-371>

    <with|par-left|1tab|F.1.1.<space|2spc><with|font-family|tt|language|verbatim|ext_set_storage>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-372>>

    <with|par-left|1tab|F.1.2.<space|2spc><with|font-family|tt|language|verbatim|ext_storage_root>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-373>>

    <with|par-left|1tab|F.1.3.<space|2spc><with|font-family|tt|language|verbatim|ext_blake2_256_enumerated_trie_root>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-374>>

    <with|par-left|1tab|F.1.4.<space|2spc><with|font-family|tt|language|verbatim|ext_clear_prefix>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-375>>

    <with|par-left|1tab|F.1.5.<space|2spc><with|font-family|tt|language|verbatim|><with|font-family|tt|language|verbatim|ext_clear_storage>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-376>>

    <with|par-left|1tab|F.1.6.<space|2spc><with|font-family|tt|language|verbatim|ext_exists_storage>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-377>>

    <with|par-left|1tab|F.1.7.<space|2spc><with|font-family|tt|language|verbatim|ext_get_allocated_storage>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-378>>

    <with|par-left|1tab|F.1.8.<space|2spc><with|font-family|tt|language|verbatim|ext_get_storage_into>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-379>>

    <with|par-left|1tab|F.1.9.<space|2spc><with|font-family|tt|language|verbatim|ext_set_child_storage>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-380>>

    <with|par-left|1tab|F.1.10.<space|2spc><with|font-family|tt|language|verbatim|ext_clear_child_storage>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-381>>

    <with|par-left|1tab|F.1.11.<space|2spc><with|font-family|tt|language|verbatim|ext_exists_child_storage>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-382>>

    <with|par-left|1tab|F.1.12.<space|2spc><with|font-family|tt|language|verbatim|ext_get_allocated_child_storage>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-383>>

    <with|par-left|1tab|F.1.13.<space|2spc><with|font-family|tt|language|verbatim|ext_get_child_storage_into>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-384>>

    <with|par-left|1tab|F.1.14.<space|2spc><with|font-family|tt|language|verbatim|ext_kill_child_storage>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-385>>

    <with|par-left|1tab|F.1.15.<space|2spc>Memory
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-386>>

    <with|par-left|2tab|F.1.15.1.<space|2spc><with|font-family|tt|language|verbatim|ext_malloc>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-387>>

    <with|par-left|2tab|F.1.15.2.<space|2spc><with|font-family|tt|language|verbatim|ext_free>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-388>>

    <with|par-left|2tab|F.1.15.3.<space|2spc>Input/Output
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-389>>

    <with|par-left|1tab|F.1.16.<space|2spc>Cryptograhpic Auxiliary Functions
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-390>>

    <with|par-left|2tab|F.1.16.1.<space|2spc><with|font-family|tt|language|verbatim|ext_blake2_256>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-391>>

    <with|par-left|2tab|F.1.16.2.<space|2spc><with|font-family|tt|language|verbatim|ext_keccak_256>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-392>>

    <with|par-left|2tab|F.1.16.3.<space|2spc><with|font-family|tt|language|verbatim|ext_twox_128>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-393>>

    <with|par-left|2tab|F.1.16.4.<space|2spc><with|font-family|tt|language|verbatim|ext_ed25519_verify>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-394>>

    <with|par-left|2tab|F.1.16.5.<space|2spc><with|font-family|tt|language|verbatim|ext_sr25519_verify>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-395>>

    <with|par-left|2tab|F.1.16.6.<space|2spc>To be Specced
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-396>>

    <with|par-left|1tab|F.1.17.<space|2spc>Offchain Worker
    \ <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-397>>

    <with|par-left|2tab|F.1.17.1.<space|2spc><with|font-family|tt|language|verbatim|ext_is_validator>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-398>>

    <with|par-left|2tab|F.1.17.2.<space|2spc><with|font-family|tt|language|verbatim|ext_submit_transaction>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-399>>

    <with|par-left|2tab|F.1.17.3.<space|2spc><with|font-family|tt|language|verbatim|ext_network_state>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-400>>

    <with|par-left|2tab|F.1.17.4.<space|2spc><with|font-family|tt|language|verbatim|ext_timestamp>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-401>>

    <with|par-left|2tab|F.1.17.5.<space|2spc><with|font-family|tt|language|verbatim|ext_sleep_until>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-402>>

    <with|par-left|2tab|F.1.17.6.<space|2spc><with|font-family|tt|language|verbatim|ext_random_seed>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-403>>

    <with|par-left|2tab|F.1.17.7.<space|2spc><with|font-family|tt|language|verbatim|ext_local_storage_set>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-404>>

    <with|par-left|2tab|F.1.17.8.<space|2spc><with|font-family|tt|language|verbatim|ext_local_storage_compare_and_set>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-405>>

    <with|par-left|2tab|F.1.17.9.<space|2spc><with|font-family|tt|language|verbatim|ext_local_storage_get>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-406>>

    <with|par-left|2tab|F.1.17.10.<space|2spc><with|font-family|tt|language|verbatim|ext_http_request_start>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-407>>

    <with|par-left|2tab|F.1.17.11.<space|2spc><with|font-family|tt|language|verbatim|ext_http_request_add_header>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-408>>

    <with|par-left|2tab|F.1.17.12.<space|2spc><with|font-family|tt|language|verbatim|ext_http_request_write_body>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-409>>

    <with|par-left|2tab|F.1.17.13.<space|2spc><with|font-family|tt|language|verbatim|ext_http_response_wait>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-410>>

    <with|par-left|2tab|F.1.17.14.<space|2spc><with|font-family|tt|language|verbatim|ext_http_response_headers>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-411>>

    <with|par-left|2tab|F.1.17.15.<space|2spc><with|font-family|tt|language|verbatim|ext_http_response_read_body>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-412>>

    <with|par-left|1tab|F.1.18.<space|2spc>Sandboxing
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-413>>

    <with|par-left|2tab|F.1.18.1.<space|2spc>To be Specced
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-414>>

    <with|par-left|1tab|F.1.19.<space|2spc>Auxillary Debugging API
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-415>>

    <with|par-left|2tab|F.1.19.1.<space|2spc><with|font-family|tt|language|verbatim|ext_print_hex>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-416>>

    <with|par-left|2tab|F.1.19.2.<space|2spc><with|font-family|tt|language|verbatim|ext_print_utf8>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-417>>

    <with|par-left|1tab|F.1.20.<space|2spc>Misc
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-418>>

    <with|par-left|2tab|F.1.20.1.<space|2spc>To be Specced
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-419>>

    <with|par-left|1tab|F.1.21.<space|2spc>Block Production
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-420>>

    F.2.<space|2spc>Validation <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-421>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|Appendix
    G.<space|2spc>Runtime Entries> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-422><vspace|0.5fn>

    G.1.<space|2spc>List of Runtime Entries
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-423>

    G.2.<space|2spc>Argument Specification
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-425>

    <with|par-left|1tab|G.2.1.<space|2spc><with|font-family|tt|language|verbatim|Core_version>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-426>>

    <with|par-left|1tab|G.2.2.<space|2spc><with|font-family|tt|language|verbatim|Core_execute_block>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-428>>

    <with|par-left|1tab|G.2.3.<space|2spc><with|font-family|tt|language|verbatim|Core_initialize_block>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-429>>

    <with|par-left|1tab|G.2.4.<space|2spc><with|font-family|tt|language|verbatim|hash_and_length>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-430>>

    <with|par-left|1tab|G.2.5.<space|2spc><with|font-family|tt|language|verbatim|BabeApi_configuration>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-431>>

    <with|par-left|1tab|G.2.6.<space|2spc><with|font-family|tt|language|verbatim|GrandpaApi_grandpa_authorities>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-433>>

    <with|par-left|1tab|G.2.7.<space|2spc><with|font-family|tt|language|verbatim|TaggedTransactionQueue_validate_transaction>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-434>>

    <with|par-left|1tab|G.2.8.<space|2spc><with|font-family|tt|language|verbatim|BlockBuilder_apply_extrinsic>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-439>>

    <with|par-left|1tab|G.2.9.<space|2spc><with|font-family|tt|language|verbatim|BlockBuilder_inherent_extrinsics>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-447>>

    <with|par-left|1tab|G.2.10.<space|2spc><with|font-family|tt|language|verbatim|BlockBuilder_finalize_block>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-448>>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|Glossary>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-449><vspace|0.5fn>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|Bibliography>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-450><vspace|0.5fn>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|Index>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-451><vspace|0.5fn>
  </table-of-contents>

  \;

  <include|c01-background.tm>

  <include|c02-state.tm>

  <include|c03-transition.tm>

  \;

  <include|c04-networking.tm>

  <include|c04a-networking.tm>

  \;

  <include|c05-bootstrapping.tm>

  \;

  <include|c06-consensus.tm>

  \;

  <include|c07-anv.tm>

  <include|c08-messaging.tm>

  \;

  <include|aa-cryptoalgorithms.tm>

  <include|ab-encodings.tm>

  <include|ac-genesis.tm>

  <include|ad-netmessages.tm>

  <include|ae-hostapi.tm>

  <include|af-legacyhostapi.tm>

  <include|ag-runtimeentries.tm>

  \;

  <\the-glossary|gly>
    <glossary-2|<with|font-series|bold|math-font-series|bold|<with|mode|math|P<rsub|n>>>|a
    path graph or a path of n nodes, can be represented by sequences of
    <with|mode|math|<around|(|v<rsub|1>,\<ldots\>,v<rsub|n>|)>> where
    <with|mode|math|e<rsub|i>=<around|(|v<rsub|i>,v<rsub|i+1>|)>> for
    <with|mode|math|1\<leqslant\>i\<leqslant\>n-1> is the edge which connect
    <with|mode|math|v<rsub|i>> and <with|mode|math|v<rsub|i+1>>|<pageref|auto-4>>

    <glossary-2|<with|mode|math|\<bbb-B\><rsub|n>>|a set of all byte arrays
    of length n|<pageref|auto-5>>

    <glossary-2|I|the little-endian representation of a non-negative
    interger, represented as <with|mode|math|I=<around*|(|B<rsub|n>\<ldots\>B<rsub|0>|)><rsub|256>>|<pageref|auto-6>>

    <glossary-2|<with|mode|math|B>|a byte array
    <with|mode|math|B=<around*|(|b<rsub|0>,b<rsub|1>,\<ldots\>,b<rsub|n>|)>>
    such that <with|mode|math|b<rsub|i>\<assign\>B<rsub|i>>|<pageref|auto-7>>

    <glossary-2|<with|mode|math|Enc<rsub|LE>>|<with|mode|math|<tformat|<tformat|<table|<row|<cell|\<bbb-Z\><rsup|+>>|<cell|\<rightarrow\>>|<cell|\<bbb-B\>>>|<row|<cell|<around*|(|B<rsub|n>\<ldots\>B<rsub|0>|)><rsub|256>>|<cell|\<mapsto\>>|<cell|<around*|(|B<rsub|0,>B<rsub|1>,\<ldots\><rsub|>,B<rsub|n>|)>>>>>>>|<pageref|auto-8>>

    <glossary-2|C, blockchain|a blockchain C is a directed path
    graph.|<pageref|auto-9>>

    <glossary-2|Block|a node of the graph in blockchain C and indicated by
    <with|mode|math|B>|<pageref|auto-10>>

    <glossary-2|Genesis Block|the unique sink of blockchain
    C|<pageref|auto-11>>

    <glossary-2|Head|the source of blockchain C|<pageref|auto-12>>

    <glossary-2|P|for any vertex <with|mode|math|<around*|(|B<rsub|1>,B<rsub|2>|)>>
    where <with|mode|math|B<rsub|1>\<rightarrow\>B<rsub|2>> we say
    <with|mode|math|B<rsub|2>> is the parent of <with|mode|math|B<rsub|1>>
    and we indicate it by <with|mode|math|B<rsub|2>\<assign\>P<around*|(|B<rsub|1>|)>>|<pageref|auto-13>>

    <glossary-2|BT, block tree|is the union of all different versions of the
    blockchain observed by all the nodes in the system such as every such
    block is a node in the graph and <with|mode|math|B<rsub|1>> is connected
    to <with|mode|math|B<rsub|2>> if <with|mode|math|B<rsub|1>> is a parent
    of <with|mode|math|B<rsub|2>>|<pageref|auto-15>>

    <glossary-2|PBT, Pruned BT|Pruned Block Tree refers to a subtree of the
    block tree obtained by eliminating all branches which do not contain the
    most recent finalized blocks, as defined in Definition
    <reference|defn-finalized-block>.|<pageref|auto-16>>

    <glossary-2|pruning||<pageref|auto-17>>

    <glossary-2|G|is the root of the block tree and B is one of its
    nodes.|<pageref|auto-18>>

    <glossary-2|CHAIN(B)|refers to the path graph from <with|mode|math|G> to
    <with|mode|math|B> in (P)<with|mode|math|BT>.|<pageref|auto-19>>

    <glossary-2|head of C|defines the head of C to be <with|mode|math|B>,
    formally noted as <with|mode|math|B\<assign\>><with|font-shape|small-caps|Head(<with|mode|math|C>)>.|<pageref|auto-20>>

    <glossary-2|<with|mode|math|<around*|\||C|\|>>|defines he length of
    <with|mode|math|C >as a path graph|<pageref|auto-21>>

    <glossary-2|SubChain(<with|mode|math|B<rprime|'>,B>)|If
    <with|mode|math|B<rprime|'>> is another node on
    <with|font-shape|small-caps|Chain(<with|mode|math|B>)>, then by
    <with|font-shape|small-caps|SubChain(<with|mode|math|B<rprime|'>,B>)> we
    refer to the subgraph of <with|mode|math|><with|font-shape|small-caps|Chain(<with|mode|math|B>)>
    path graph which contains both <with|mode|math|B> and
    <with|mode|math|B<rprime|'>>.|<pageref|auto-22>>

    <glossary-2|<with|mode|math|\<bbb-C\><rsub|B<rprime|'>><around*|(|<around*|(|P|)>BT|)>>|is
    the set of all subchains of <with|mode|math|<around*|(|P|)>BT> rooted at
    <with|mode|math|B<rprime|'>>.|<pageref|auto-23>>

    <glossary-2|<with|mode|math|\<bbb-C\>>|the set of all chains of
    <with|mode|math|<around*|(|P|)>BT>, <with|mode|math|\<bbb-C\><rsub|G><around*|(|<around*|(|*P|)>BT|)>>
    is denoted by <with|mode|math|\<bbb-C\>>((P)BT) or simply
    <with|mode|math|\<bbb-C\>>|<pageref|auto-24>>

    <glossary-2|LONGEST-CHAIN(BT)|the maximum chain given by the complete
    order over <with|mode|math|\<bbb-C\>>|<pageref|auto-25>>

    <glossary-2|LONGEST-PATH(BT)|the path graph of
    <with|mode|math|<around*|(|P|)>BT> which is the longest among all paths
    in <with|mode|math|<around*|(|P|)>BT> and has the earliest block arrival
    time as defined in Definition <reference|defn-block-time>.|<pageref|auto-26>>

    <glossary-2|DEEPEST-LEAF(BT)|the head of
    LONGEST-PATH(BT)|<pageref|auto-27>>

    <glossary-2|StoredValue|the function retrieves the value stored under a
    specific key in the state storage and is formally defined as
    <with|mode|math|<tformat|<tformat|<table|<row|<cell|\<cal-K\>\<rightarrow\>\<cal-V\>>>|<row|<cell|k\<mapsto\><around*|{|<tformat|<cwith|1|-1|1|-1|cell-halign|c>|<tformat|<table|<row|<cell|v>|<cell|<with|mode|text|if
    (k,v) exists in state storage>>>|<row|<cell|\<phi\>>|<cell|otherwise>>>>>|\<nobracket\>>>>>>>>.
    Here <with|mode|math|\<cal-K\>\<subset\>\<bbb-B\>> and
    <with|mode|math|\<cal-V\>\<subset\>\<bbb-B\>> are respectively the set of
    all keys and values stored in the state storage.|<pageref|auto-31>>
  </the-glossary>

  <\bibliography|bib|tm-alpha|host-spec>
    <\bib-list|12>
      <bibitem*|Bur19><label|bib-burdges_schnorr_2019>Jeff Burdges.
      <newblock>Schnorr VRFs and signatures on the Ristretto group.
      <newblock><localize|Technical Report>, 2019.<newblock>

      <bibitem*|Col19><label|bib-collet_extremely_2019>Yann Collet.
      <newblock>Extremely fast non-cryptographic hash algorithm.
      <newblock><localize|Technical Report>, -,
      <slink|http://cyan4973.github.io/xxHash/>, 2019.<newblock>

      <bibitem*|DGKR18><label|bib-david_ouroboros_2018>Bernardo David, Peter
      Gaºi, Aggelos Kiayias<localize|, and >Alexander Russell.
      <newblock>Ouroboros praos: An adaptively-secure, semi-synchronous
      proof-of-stake blockchain. <newblock><localize|In
      ><with|font-shape|italic|Annual International Conference on the Theory
      and Applications of Cryptographic Techniques>, <localize|pages >66\U98.
      Springer, 2018.<newblock>

      <bibitem*|Fou20><label|bib-web3.0_technologies_foundation_polkadot_2020>Web3.0<nbsp>Technologies
      Foundation. <newblock>Polkadot Genisis State.
      <newblock><localize|Technical Report>,
      <slink|https://github.com/w3f/polkadot-spec/blob/master/genesis-state/>,
      2020.<newblock>

      <bibitem*|Gro19><label|bib-w3f_research_group_blind_2019>W3F<nbsp>Research
      Group. <newblock>Blind Assignment for Blockchain Extension.
      <newblock>Technical <keepcase|Specification>, Web 3.0 Foundation,
      <slink|http://research.web3.foundation/en/latest/polkadot/BABE/Babe/>,
      2019.<newblock>

      <bibitem*|JL17><label|bib-josefsson_edwards-curve_2017>Simon
      Josefsson<localize| and >Ilari Liusvaara. <newblock>Edwards-curve
      digital signature algorithm (EdDSA). <newblock><localize|In
      ><with|font-shape|italic|Internet Research Task Force, Crypto Forum
      Research Group, RFC>, <localize|volume> 8032. 2017.<newblock>

      <bibitem*|lab19><label|bib-protocol_labs_libp2p_2019>Protocol labs.
      <newblock>Libp2p Specification. <newblock><localize|Technical Report>,
      Protocol labs, <slink|https://github.com/libp2p/specs>, 2019.<newblock>

      <bibitem*|LJ17><label|bib-liusvaara_edwards-curve_2017>Ilari
      Liusvaara<localize| and >Simon Josefsson. <newblock>Edwards-Curve
      Digital Signature Algorithm (EdDSA). <newblock>2017.<newblock>

      <bibitem*|Per18><label|bib-perrin_noise_2018>Trevor Perrin.
      <newblock>The Noise Protocol Framework. <newblock><localize|Technical
      Report>, <slink|https://noiseprotocol.org/noise.html>, 2018.<newblock>

      <bibitem*|SA15><label|bib-saarinen_blake2_2015>Markku<nbsp>Juhani
      Saarinen<localize| and >Jean-Philippe Aumasson. <newblock>The BLAKE2
      cryptographic hash and message authentication code (MAC).
      <newblock><keepcase|RFC> 7693, -, <slink|https://tools.ietf.org/html/rfc7693>,
      2015.<newblock>

      <bibitem*|Ste19><label|bib-stewart_grandpa:_2019>Alistair Stewart.
      <newblock>GRANDPA: A Byzantine Finality Gadget.
      <newblock>2019.<newblock>

      <bibitem*|Tec19><label|bib-parity_technologies_substrate_2019>Parity
      Technologies. <newblock>Substrate Reference Documentation.
      <newblock>Rust <keepcase|Doc>, Parity Technologies,
      <slink|https://substrate.dev/rustdocs/>, 2019.<newblock>
    </bib-list>
  </bibliography>

  <\the-index|idx>
    <index+1|Transaction Message|<pageref|auto-50>>

    <index+1|transaction pool|<pageref|auto-51>>

    <index+1|transaction queue|<pageref|auto-52>>
  </the-index>
</body>

<\initial>
  <\collection>
    <associate|info-flag|minimal>
    <associate|page-height|auto>
    <associate|page-medium|papyrus>
    <associate|page-screen-margin|true>
    <associate|page-screen-right|5mm>
    <associate|page-type|letter>
    <associate|page-width|auto>
    <associate|preamble|false>
    <associate|tex-even-side-margin|5mm>
    <associate|tex-odd-side-margin|5mm>
    <associate|tex-text-width|170mm>
  </collection>
</initial>

<\references>
  <\collection>
    <associate||<tuple|7.12.0.2|80|c07-anv.tm>>
    <associate|algo-aggregate-key|<tuple|2.1|19|c02-state.tm>>
    <associate|algo-attempt-to\Ufinalize|<tuple|6.15|60|c06-consensus.tm>>
    <associate|algo-block-production|<tuple|6.3|51|c06-consensus.tm>>
    <associate|algo-block-production-lottery|<tuple|6.1|50|c06-consensus.tm>>
    <associate|algo-build-block|<tuple|6.7|53|c06-consensus.tm>>
    <associate|algo-checker-vrf|<tuple|7.10|78|c07-anv.tm>>
    <associate|algo-derive-primary|<tuple|6.10|59|c06-consensus.tm>>
    <associate|algo-endorse-candidate-receipt|<tuple|7.4|73|c07-anv.tm>>
    <associate|algo-epoch-randomness|<tuple|6.4|52|c06-consensus.tm>>
    <associate|algo-equivocation-assigment|<tuple|7.13|79|c07-anv.tm>>
    <associate|algo-erasure-encode|<tuple|7.7|75|c07-anv.tm>>
    <associate|algo-extra-assignment|<tuple|7.12|79|c07-anv.tm>>
    <associate|algo-finalizable|<tuple|6.14|60|c06-consensus.tm>>
    <associate|algo-grandpa-best-candidate|<tuple|6.11|59|c06-consensus.tm>>
    <associate|algo-grandpa-round|<tuple|6.9|59|c06-consensus.tm>>
    <associate|algo-import-and-validate-block|<tuple|3.4|30|c03-transition.tm>>
    <associate|algo-include-parachain-proposal|<tuple|7.5|74|c07-anv.tm>>
    <associate|algo-initiate-grandpa|<tuple|6.8|58|c06-consensus.tm>>
    <associate|algo-maintain-transaction-pool|<tuple|3.3|27|c03-transition.tm>>
    <associate|algo-make-shards|<tuple|7.8|75|c07-anv.tm>>
    <associate|algo-one-shot-assignment|<tuple|7.11|79|c07-anv.tm>>
    <associate|algo-pk-length|<tuple|2.2|20|c02-state.tm>>
    <associate|algo-primary-validation|<tuple|7.1|70|c07-anv.tm>>
    <associate|algo-primary-validation-announcement|<tuple|7.3|72|c07-anv.tm>>
    <associate|algo-primary-validation-disagreemnt|<tuple|7.6|74|c07-anv.tm>>
    <associate|algo-process-catchup-request|<tuple|6.16|62|c06-consensus.tm>>
    <associate|algo-process-catchup-response|<tuple|6.17|63|c06-consensus.tm>>
    <associate|algo-reconstruct-pov-erasure|<tuple|7.14|80|c07-anv.tm>>
    <associate|algo-revalidating-reconstructed-pov|<tuple|7.15|81|c07-anv.tm>>
    <associate|algo-runtime-interaction|<tuple|3.1|23|c03-transition.tm>>
    <associate|algo-singnature-processing|<tuple|7.9|77|c07-anv.tm>>
    <associate|algo-slot-time|<tuple|6.2|50|c06-consensus.tm>>
    <associate|algo-validate-block|<tuple|7.2|70|c07-anv.tm>>
    <associate|algo-validate-transactions|<tuple|3.2|26|c03-transition.tm>>
    <associate|algo-verify-approval-attestation|<tuple|7.16|81|c07-anv.tm>>
    <associate|algo-verify-authorship-right|<tuple|6.5|52|c06-consensus.tm>>
    <associate|algo-verify-slot-winner|<tuple|6.6|53|c06-consensus.tm>>
    <associate|appendix-e|<tuple|E|107|ae-hostapi.tm>>
    <associate|auto-1|<tuple|1|13|c01-background.tm>>
    <associate|auto-10|<tuple|1.9|15|c01-background.tm>>
    <associate|auto-100|<tuple|4.3.4.1|44|c04a-networking.tm>>
    <associate|auto-101|<tuple|4.3.4.2|44|c04a-networking.tm>>
    <associate|auto-102|<tuple|5|45|c05-bootstrapping.tm>>
    <associate|auto-103|<tuple|6|47|c06-consensus.tm>>
    <associate|auto-104|<tuple|6.1|47|c06-consensus.tm>>
    <associate|auto-105|<tuple|6.1.1|47|c06-consensus.tm>>
    <associate|auto-106|<tuple|6.1.2|47|c06-consensus.tm>>
    <associate|auto-107|<tuple|6.1|48|c06-consensus.tm>>
    <associate|auto-108|<tuple|6.2|49|c06-consensus.tm>>
    <associate|auto-109|<tuple|6.2.1|49|c06-consensus.tm>>
    <associate|auto-11|<tuple|1.9|15|c01-background.tm>>
    <associate|auto-110|<tuple|6.2.2|49|c06-consensus.tm>>
    <associate|auto-111|<tuple|6.2.3|50|c06-consensus.tm>>
    <associate|auto-112|<tuple|6.2.4|51|c06-consensus.tm>>
    <associate|auto-113|<tuple|6.2.5|52|c06-consensus.tm>>
    <associate|auto-114|<tuple|6.2.6|52|c06-consensus.tm>>
    <associate|auto-115|<tuple|6.2.7|53|c06-consensus.tm>>
    <associate|auto-116|<tuple|6.3|54|c06-consensus.tm>>
    <associate|auto-117|<tuple|6.3.1|54|c06-consensus.tm>>
    <associate|auto-118|<tuple|6.3.2|56|c06-consensus.tm>>
    <associate|auto-119|<tuple|6.2|56|c06-consensus.tm>>
    <associate|auto-12|<tuple|1.9|15|c01-background.tm>>
    <associate|auto-120|<tuple|6.3.2.1|57|c06-consensus.tm>>
    <associate|auto-121|<tuple|6.3.2.2|57|c06-consensus.tm>>
    <associate|auto-122|<tuple|6.3.2.3|58|c06-consensus.tm>>
    <associate|auto-123|<tuple|6.3.3|58|c06-consensus.tm>>
    <associate|auto-124|<tuple|6.3.3.1|58|c06-consensus.tm>>
    <associate|auto-125|<tuple|6.3.4|59|c06-consensus.tm>>
    <associate|auto-126|<tuple|6.4|61|c06-consensus.tm>>
    <associate|auto-127|<tuple|6.4.1|62|c06-consensus.tm>>
    <associate|auto-128|<tuple|6.4.1.1|62|c06-consensus.tm>>
    <associate|auto-129|<tuple|6.4.1.2|62|c06-consensus.tm>>
    <associate|auto-13|<tuple|1.9|15|c01-background.tm>>
    <associate|auto-130|<tuple|6.4.1.3|63|c06-consensus.tm>>
    <associate|auto-131|<tuple|7|65|c07-anv.tm>>
    <associate|auto-132|<tuple|7.1|65|c07-anv.tm>>
    <associate|auto-133|<tuple|7.2|66|c07-anv.tm>>
    <associate|auto-134|<tuple|7.2.1|66|c07-anv.tm>>
    <associate|auto-135|<tuple|7.3|68|c07-anv.tm>>
    <associate|auto-136|<tuple|7.1|69|c07-anv.tm>>
    <associate|auto-137|<tuple|7.4|70|c07-anv.tm>>
    <associate|auto-138|<tuple|7.5|71|c07-anv.tm>>
    <associate|auto-139|<tuple|7.5.1|74|c07-anv.tm>>
    <associate|auto-14|<tuple|1.2.1|15|c01-background.tm>>
    <associate|auto-140|<tuple|7.6|74|c07-anv.tm>>
    <associate|auto-141|<tuple|7.6.1|74|c07-anv.tm>>
    <associate|auto-142|<tuple|7.7|74|c07-anv.tm>>
    <associate|auto-143|<tuple|7.8|76|c07-anv.tm>>
    <associate|auto-144|<tuple|7.9|76|c07-anv.tm>>
    <associate|auto-145|<tuple|7.9.1|77|c07-anv.tm>>
    <associate|auto-146|<tuple|7.10|78|c07-anv.tm>>
    <associate|auto-147|<tuple|7.11|78|c07-anv.tm>>
    <associate|auto-148|<tuple|7.11.1|78|c07-anv.tm>>
    <associate|auto-149|<tuple|7.11.2|78|c07-anv.tm>>
    <associate|auto-15|<tuple|1.11|15|c01-background.tm>>
    <associate|auto-150|<tuple|7.11.3|78|c07-anv.tm>>
    <associate|auto-151|<tuple|7.11.4|79|c07-anv.tm>>
    <associate|auto-152|<tuple|7.11.5|79|c07-anv.tm>>
    <associate|auto-153|<tuple|7.12|80|c07-anv.tm>>
    <associate|auto-154|<tuple|7.12.0.1|80|c07-anv.tm>>
    <associate|auto-155|<tuple|7.12.0.2|80|c07-anv.tm>>
    <associate|auto-156|<tuple|7.12.1|81|c07-anv.tm>>
    <associate|auto-157|<tuple|7.12.2|81|c07-anv.tm>>
    <associate|auto-158|<tuple|7.12.3|81|c07-anv.tm>>
    <associate|auto-159|<tuple|8|83|c08-messaging.tm>>
    <associate|auto-16|<tuple|1.12|15|c01-background.tm>>
    <associate|auto-160|<tuple|8.1|83|c08-messaging.tm>>
    <associate|auto-161|<tuple|8.1|84|c08-messaging.tm>>
    <associate|auto-162|<tuple|8.2|85|c08-messaging.tm>>
    <associate|auto-163|<tuple|8.2|86|c08-messaging.tm>>
    <associate|auto-164|<tuple|8.3|87|c08-messaging.tm>>
    <associate|auto-165|<tuple|8.3.1|87|c08-messaging.tm>>
    <associate|auto-166|<tuple|8.3.2|88|c08-messaging.tm>>
    <associate|auto-167|<tuple|8.3.2.1|88|c08-messaging.tm>>
    <associate|auto-168|<tuple|8.3.3|89|c08-messaging.tm>>
    <associate|auto-169|<tuple|8.3.3.1|89|c08-messaging.tm>>
    <associate|auto-17|<tuple|1.12|15|c01-background.tm>>
    <associate|auto-170|<tuple|8.3.4|89|c08-messaging.tm>>
    <associate|auto-171|<tuple|8.3.5|89|c08-messaging.tm>>
    <associate|auto-172|<tuple|8.3.6|90|c08-messaging.tm>>
    <associate|auto-173|<tuple|8.3.7|91|c08-messaging.tm>>
    <associate|auto-174|<tuple|8.4|91|c08-messaging.tm>>
    <associate|auto-175|<tuple|8.3|92|c08-messaging.tm>>
    <associate|auto-176|<tuple|8.4.1|93|c08-messaging.tm>>
    <associate|auto-177|<tuple|8.4.2|93|c08-messaging.tm>>
    <associate|auto-178|<tuple|8.4.3|94|c08-messaging.tm>>
    <associate|auto-179|<tuple|8.5|94|c08-messaging.tm>>
    <associate|auto-18|<tuple|1.13|15|c01-background.tm>>
    <associate|auto-180|<tuple|A|95|aa-cryptoalgorithms.tm>>
    <associate|auto-181|<tuple|A.1|95|aa-cryptoalgorithms.tm>>
    <associate|auto-182|<tuple|A.2|95|aa-cryptoalgorithms.tm>>
    <associate|auto-183|<tuple|A.3|95|aa-cryptoalgorithms.tm>>
    <associate|auto-184|<tuple|A.4|95|aa-cryptoalgorithms.tm>>
    <associate|auto-185|<tuple|A.5|95|aa-cryptoalgorithms.tm>>
    <associate|auto-186|<tuple|A.1|95|aa-cryptoalgorithms.tm>>
    <associate|auto-187|<tuple|A.2|96|aa-cryptoalgorithms.tm>>
    <associate|auto-188|<tuple|A.5.1|96|aa-cryptoalgorithms.tm>>
    <associate|auto-189|<tuple|A.5.2|96|aa-cryptoalgorithms.tm>>
    <associate|auto-19|<tuple|1.13|15|c01-background.tm>>
    <associate|auto-190|<tuple|A.5.3|96|aa-cryptoalgorithms.tm>>
    <associate|auto-191|<tuple|A.5.4|96|aa-cryptoalgorithms.tm>>
    <associate|auto-192|<tuple|A.5.5|96|aa-cryptoalgorithms.tm>>
    <associate|auto-193|<tuple|B|97|ab-encodings.tm>>
    <associate|auto-194|<tuple|B.1|97|ab-encodings.tm>>
    <associate|auto-195|<tuple|B.1.1|99|ab-encodings.tm>>
    <associate|auto-196|<tuple|B.2|99|ab-encodings.tm>>
    <associate|auto-197|<tuple|C|101|ac-genesis.tm>>
    <associate|auto-198|<tuple|C.1|101|ac-genesis.tm>>
    <associate|auto-199|<tuple|D|103|ad-netmessages.tm>>
    <associate|auto-2|<tuple|1.1|13|c01-background.tm>>
    <associate|auto-20|<tuple|1.13|15|c01-background.tm>>
    <associate|auto-200|<tuple|D.1|103|ad-netmessages.tm>>
    <associate|auto-201|<tuple|D.1|103|ad-netmessages.tm>>
    <associate|auto-202|<tuple|D.1.1|103|ad-netmessages.tm>>
    <associate|auto-203|<tuple|D.2|104|ad-netmessages.tm>>
    <associate|auto-204|<tuple|D.1.2|104|ad-netmessages.tm>>
    <associate|auto-205|<tuple|D.3|104|ad-netmessages.tm>>
    <associate|auto-206|<tuple|D.1.3|105|ad-netmessages.tm>>
    <associate|auto-207|<tuple|D.1.4|105|ad-netmessages.tm>>
    <associate|auto-208|<tuple|D.1.5|105|ad-netmessages.tm>>
    <associate|auto-209|<tuple|D.1.6|106|ad-netmessages.tm>>
    <associate|auto-21|<tuple|1.13|15|c01-background.tm>>
    <associate|auto-210|<tuple|D.1.7|106|ad-netmessages.tm>>
    <associate|auto-211|<tuple|E|107|ae-hostapi.tm>>
    <associate|auto-212|<tuple|E.1|107|ae-hostapi.tm>>
    <associate|auto-213|<tuple|E.1.1|107|ae-hostapi.tm>>
    <associate|auto-214|<tuple|E.1.1.1|107|ae-hostapi.tm>>
    <associate|auto-215|<tuple|E.1.2|107|ae-hostapi.tm>>
    <associate|auto-216|<tuple|E.1.2.1|108|ae-hostapi.tm>>
    <associate|auto-217|<tuple|E.1.3|108|ae-hostapi.tm>>
    <associate|auto-218|<tuple|E.1.3.1|108|ae-hostapi.tm>>
    <associate|auto-219|<tuple|E.1.4|108|ae-hostapi.tm>>
    <associate|auto-22|<tuple|1.13|15|c01-background.tm>>
    <associate|auto-220|<tuple|E.1.4.1|108|ae-hostapi.tm>>
    <associate|auto-221|<tuple|E.1.5|108|ae-hostapi.tm>>
    <associate|auto-222|<tuple|E.1.5.1|108|ae-hostapi.tm>>
    <associate|auto-223|<tuple|E.1.6|109|ae-hostapi.tm>>
    <associate|auto-224|<tuple|E.1.6.1|109|ae-hostapi.tm>>
    <associate|auto-225|<tuple|E.1.7|109|ae-hostapi.tm>>
    <associate|auto-226|<tuple|E.1.7.1|109|ae-hostapi.tm>>
    <associate|auto-227|<tuple|E.1.8|109|ae-hostapi.tm>>
    <associate|auto-228|<tuple|E.1.8.1|109|ae-hostapi.tm>>
    <associate|auto-229|<tuple|E.1.9|110|ae-hostapi.tm>>
    <associate|auto-23|<tuple|1.13|15|c01-background.tm>>
    <associate|auto-230|<tuple|E.1.9.1|110|ae-hostapi.tm>>
    <associate|auto-231|<tuple|E.1.10|110|ae-hostapi.tm>>
    <associate|auto-232|<tuple|E.1.10.1|110|ae-hostapi.tm>>
    <associate|auto-233|<tuple|E.1.11|110|ae-hostapi.tm>>
    <associate|auto-234|<tuple|E.1.11.1|110|ae-hostapi.tm>>
    <associate|auto-235|<tuple|E.1.12|111|ae-hostapi.tm>>
    <associate|auto-236|<tuple|E.1.12.1|111|ae-hostapi.tm>>
    <associate|auto-237|<tuple|E.1.13|111|ae-hostapi.tm>>
    <associate|auto-238|<tuple|E.1.13.1|111|ae-hostapi.tm>>
    <associate|auto-239|<tuple|E.2|111|ae-hostapi.tm>>
    <associate|auto-24|<tuple|1.13|15|c01-background.tm>>
    <associate|auto-240|<tuple|E.2.1|111|ae-hostapi.tm>>
    <associate|auto-241|<tuple|E.2.1.1|111|ae-hostapi.tm>>
    <associate|auto-242|<tuple|E.2.2|112|ae-hostapi.tm>>
    <associate|auto-243|<tuple|E.2.2.1|112|ae-hostapi.tm>>
    <associate|auto-244|<tuple|E.2.3|112|ae-hostapi.tm>>
    <associate|auto-245|<tuple|E.2.3.1|112|ae-hostapi.tm>>
    <associate|auto-246|<tuple|E.2.4|113|ae-hostapi.tm>>
    <associate|auto-247|<tuple|E.2.4.1|113|ae-hostapi.tm>>
    <associate|auto-248|<tuple|E.2.5|113|ae-hostapi.tm>>
    <associate|auto-249|<tuple|E.2.5.1|113|ae-hostapi.tm>>
    <associate|auto-25|<tuple|1.14|15|c01-background.tm>>
    <associate|auto-250|<tuple|E.2.6|113|ae-hostapi.tm>>
    <associate|auto-251|<tuple|E.2.6.1|113|ae-hostapi.tm>>
    <associate|auto-252|<tuple|E.2.7|113|ae-hostapi.tm>>
    <associate|auto-253|<tuple|E.2.7.1|113|ae-hostapi.tm>>
    <associate|auto-254|<tuple|E.2.8|114|ae-hostapi.tm>>
    <associate|auto-255|<tuple|E.2.8.1|114|ae-hostapi.tm>>
    <associate|auto-256|<tuple|E.2.9|114|ae-hostapi.tm>>
    <associate|auto-257|<tuple|E.2.9.1|114|ae-hostapi.tm>>
    <associate|auto-258|<tuple|E.3|114|ae-hostapi.tm>>
    <associate|auto-259|<tuple|E.1|115|ae-hostapi.tm>>
    <associate|auto-26|<tuple|1.15|15|c01-background.tm>>
    <associate|auto-260|<tuple|E.2|115|ae-hostapi.tm>>
    <associate|auto-261|<tuple|E.3.1|115|ae-hostapi.tm>>
    <associate|auto-262|<tuple|E.3.1.1|115|ae-hostapi.tm>>
    <associate|auto-263|<tuple|E.3.2|115|ae-hostapi.tm>>
    <associate|auto-264|<tuple|E.3.2.1|115|ae-hostapi.tm>>
    <associate|auto-265|<tuple|E.3.3|116|ae-hostapi.tm>>
    <associate|auto-266|<tuple|E.3.3.1|116|ae-hostapi.tm>>
    <associate|auto-267|<tuple|E.3.4|116|ae-hostapi.tm>>
    <associate|auto-268|<tuple|E.3.4.1|116|ae-hostapi.tm>>
    <associate|auto-269|<tuple|E.3.5|116|ae-hostapi.tm>>
    <associate|auto-27|<tuple|1.15|15|c01-background.tm>>
    <associate|auto-270|<tuple|E.3.5.1|117|ae-hostapi.tm>>
    <associate|auto-271|<tuple|E.3.6|117|ae-hostapi.tm>>
    <associate|auto-272|<tuple|E.3.6.1|117|ae-hostapi.tm>>
    <associate|auto-273|<tuple|E.3.7|117|ae-hostapi.tm>>
    <associate|auto-274|<tuple|E.3.7.1|117|ae-hostapi.tm>>
    <associate|auto-275|<tuple|E.3.8|118|ae-hostapi.tm>>
    <associate|auto-276|<tuple|E.3.8.1|118|ae-hostapi.tm>>
    <associate|auto-277|<tuple|E.3.8.2|118|ae-hostapi.tm>>
    <associate|auto-278|<tuple|E.3.9|118|ae-hostapi.tm>>
    <associate|auto-279|<tuple|E.3.9.1|118|ae-hostapi.tm>>
    <associate|auto-28|<tuple|2|17|c02-state.tm>>
    <associate|auto-280|<tuple|E.3.10|119|ae-hostapi.tm>>
    <associate|auto-281|<tuple|E.3.10.1|119|ae-hostapi.tm>>
    <associate|auto-282|<tuple|E.3.11|119|ae-hostapi.tm>>
    <associate|auto-283|<tuple|E.3.11.1|119|ae-hostapi.tm>>
    <associate|auto-284|<tuple|E.3.12|119|ae-hostapi.tm>>
    <associate|auto-285|<tuple|E.3.12.1|120|ae-hostapi.tm>>
    <associate|auto-286|<tuple|E.3.13|120|ae-hostapi.tm>>
    <associate|auto-287|<tuple|E.3.13.1|120|ae-hostapi.tm>>
    <associate|auto-288|<tuple|E.3.14|120|ae-hostapi.tm>>
    <associate|auto-289|<tuple|E.3.14.1|120|ae-hostapi.tm>>
    <associate|auto-29|<tuple|2.1|17|c02-state.tm>>
    <associate|auto-290|<tuple|E.3.15|121|ae-hostapi.tm>>
    <associate|auto-291|<tuple|E.3.15.1|121|ae-hostapi.tm>>
    <associate|auto-292|<tuple|E.3.16|121|ae-hostapi.tm>>
    <associate|auto-293|<tuple|E.3.16.1|121|ae-hostapi.tm>>
    <associate|auto-294|<tuple|E.4|121|ae-hostapi.tm>>
    <associate|auto-295|<tuple|E.4.1|121|ae-hostapi.tm>>
    <associate|auto-296|<tuple|E.4.1.1|121|ae-hostapi.tm>>
    <associate|auto-297|<tuple|E.4.2|122|ae-hostapi.tm>>
    <associate|auto-298|<tuple|E.4.2.1|122|ae-hostapi.tm>>
    <associate|auto-299|<tuple|E.4.3|122|ae-hostapi.tm>>
    <associate|auto-3|<tuple|1.2|13|c01-background.tm>>
    <associate|auto-30|<tuple|2.1.1|17|c02-state.tm>>
    <associate|auto-300|<tuple|E.4.3.1|122|ae-hostapi.tm>>
    <associate|auto-301|<tuple|E.4.4|122|ae-hostapi.tm>>
    <associate|auto-302|<tuple|E.4.4.1|122|ae-hostapi.tm>>
    <associate|auto-303|<tuple|E.4.5|122|ae-hostapi.tm>>
    <associate|auto-304|<tuple|E.4.5.1|123|ae-hostapi.tm>>
    <associate|auto-305|<tuple|E.4.6|123|ae-hostapi.tm>>
    <associate|auto-306|<tuple|E.4.6.1|123|ae-hostapi.tm>>
    <associate|auto-307|<tuple|E.4.7|123|ae-hostapi.tm>>
    <associate|auto-308|<tuple|E.4.7.1|123|ae-hostapi.tm>>
    <associate|auto-309|<tuple|E.5|123|ae-hostapi.tm>>
    <associate|auto-31|<tuple|2.1|17|c02-state.tm>>
    <associate|auto-310|<tuple|E.3|124|ae-hostapi.tm>>
    <associate|auto-311|<tuple|E.5.1|124|ae-hostapi.tm>>
    <associate|auto-312|<tuple|E.5.1.1|124|ae-hostapi.tm>>
    <associate|auto-313|<tuple|E.5.2|124|ae-hostapi.tm>>
    <associate|auto-314|<tuple|E.5.2.1|124|ae-hostapi.tm>>
    <associate|auto-315|<tuple|E.5.3|125|ae-hostapi.tm>>
    <associate|auto-316|<tuple|E.5.3.1|125|ae-hostapi.tm>>
    <associate|auto-317|<tuple|E.5.4|125|ae-hostapi.tm>>
    <associate|auto-318|<tuple|E.5.4.1|125|ae-hostapi.tm>>
    <associate|auto-319|<tuple|E.5.5|125|ae-hostapi.tm>>
    <associate|auto-32|<tuple|2.1.2|17|c02-state.tm>>
    <associate|auto-320|<tuple|E.5.5.1|125|ae-hostapi.tm>>
    <associate|auto-321|<tuple|E.5.6|125|ae-hostapi.tm>>
    <associate|auto-322|<tuple|E.5.6.1|126|ae-hostapi.tm>>
    <associate|auto-323|<tuple|E.5.7|126|ae-hostapi.tm>>
    <associate|auto-324|<tuple|E.5.7.1|126|ae-hostapi.tm>>
    <associate|auto-325|<tuple|E.5.8|126|ae-hostapi.tm>>
    <associate|auto-326|<tuple|E.5.8.1|126|ae-hostapi.tm>>
    <associate|auto-327|<tuple|E.5.9|126|ae-hostapi.tm>>
    <associate|auto-328|<tuple|E.5.9.1|127|ae-hostapi.tm>>
    <associate|auto-329|<tuple|E.5.10|127|ae-hostapi.tm>>
    <associate|auto-33|<tuple|2.1.3|18|c02-state.tm>>
    <associate|auto-330|<tuple|E.5.10.1|127|ae-hostapi.tm>>
    <associate|auto-331|<tuple|E.5.11|127|ae-hostapi.tm>>
    <associate|auto-332|<tuple|E.5.11.1|127|ae-hostapi.tm>>
    <associate|auto-333|<tuple|E.5.12|128|ae-hostapi.tm>>
    <associate|auto-334|<tuple|E.5.12.1|128|ae-hostapi.tm>>
    <associate|auto-335|<tuple|E.5.13|128|ae-hostapi.tm>>
    <associate|auto-336|<tuple|E.5.13.1|128|ae-hostapi.tm>>
    <associate|auto-337|<tuple|E.5.14|129|ae-hostapi.tm>>
    <associate|auto-338|<tuple|E.5.14.1|129|ae-hostapi.tm>>
    <associate|auto-339|<tuple|E.5.15|129|ae-hostapi.tm>>
    <associate|auto-34|<tuple|2.1.4|20|c02-state.tm>>
    <associate|auto-340|<tuple|E.5.15.1|129|ae-hostapi.tm>>
    <associate|auto-341|<tuple|E.6|129|ae-hostapi.tm>>
    <associate|auto-342|<tuple|E.6.1|129|ae-hostapi.tm>>
    <associate|auto-343|<tuple|E.6.1.1|129|ae-hostapi.tm>>
    <associate|auto-344|<tuple|E.6.2|130|ae-hostapi.tm>>
    <associate|auto-345|<tuple|E.6.2.1|130|ae-hostapi.tm>>
    <associate|auto-346|<tuple|E.6.3|130|ae-hostapi.tm>>
    <associate|auto-347|<tuple|E.6.3.1|130|ae-hostapi.tm>>
    <associate|auto-348|<tuple|E.6.4|130|ae-hostapi.tm>>
    <associate|auto-349|<tuple|E.6.4.1|130|ae-hostapi.tm>>
    <associate|auto-35|<tuple|2.2|21|c02-state.tm>>
    <associate|auto-350|<tuple|E.7|131|ae-hostapi.tm>>
    <associate|auto-351|<tuple|E.7.1|131|ae-hostapi.tm>>
    <associate|auto-352|<tuple|E.7.1.1|131|ae-hostapi.tm>>
    <associate|auto-353|<tuple|E.7.2|131|ae-hostapi.tm>>
    <associate|auto-354|<tuple|E.7.2.1|131|ae-hostapi.tm>>
    <associate|auto-355|<tuple|E.7.3|131|ae-hostapi.tm>>
    <associate|auto-356|<tuple|E.7.3.1|131|ae-hostapi.tm>>
    <associate|auto-357|<tuple|E.7.4|131|ae-hostapi.tm>>
    <associate|auto-358|<tuple|E.7.4.1|132|ae-hostapi.tm>>
    <associate|auto-359|<tuple|E.7.5|132|ae-hostapi.tm>>
    <associate|auto-36|<tuple|2.2.1|22|c02-state.tm>>
    <associate|auto-360|<tuple|E.7.5.1|132|ae-hostapi.tm>>
    <associate|auto-361|<tuple|E.8|132|ae-hostapi.tm>>
    <associate|auto-362|<tuple|E.8.1|132|ae-hostapi.tm>>
    <associate|auto-363|<tuple|E.8.1.1|132|ae-hostapi.tm>>
    <associate|auto-364|<tuple|E.8.2|132|ae-hostapi.tm>>
    <associate|auto-365|<tuple|E.8.2.1|133|ae-hostapi.tm>>
    <associate|auto-366|<tuple|E.9|133|ae-hostapi.tm>>
    <associate|auto-367|<tuple|E.4|133|ae-hostapi.tm>>
    <associate|auto-368|<tuple|E.9.1|133|ae-hostapi.tm>>
    <associate|auto-369|<tuple|E.9.1.1|133|ae-hostapi.tm>>
    <associate|auto-37|<tuple|3|23|c03-transition.tm>>
    <associate|auto-370|<tuple|F|135|af-legacyhostapi.tm>>
    <associate|auto-371|<tuple|F.1|135|af-legacyhostapi.tm>>
    <associate|auto-372|<tuple|F.1.1|135|af-legacyhostapi.tm>>
    <associate|auto-373|<tuple|F.1.2|135|af-legacyhostapi.tm>>
    <associate|auto-374|<tuple|F.1.3|136|af-legacyhostapi.tm>>
    <associate|auto-375|<tuple|F.1.4|136|af-legacyhostapi.tm>>
    <associate|auto-376|<tuple|F.1.5|136|af-legacyhostapi.tm>>
    <associate|auto-377|<tuple|F.1.6|137|af-legacyhostapi.tm>>
    <associate|auto-378|<tuple|F.1.7|137|af-legacyhostapi.tm>>
    <associate|auto-379|<tuple|F.1.8|137|af-legacyhostapi.tm>>
    <associate|auto-38|<tuple|3.1|23|c03-transition.tm>>
    <associate|auto-380|<tuple|F.1.9|138|af-legacyhostapi.tm>>
    <associate|auto-381|<tuple|F.1.10|138|af-legacyhostapi.tm>>
    <associate|auto-382|<tuple|F.1.11|139|af-legacyhostapi.tm>>
    <associate|auto-383|<tuple|F.1.12|139|af-legacyhostapi.tm>>
    <associate|auto-384|<tuple|F.1.13|140|af-legacyhostapi.tm>>
    <associate|auto-385|<tuple|F.1.14|140|af-legacyhostapi.tm>>
    <associate|auto-386|<tuple|F.1.15|141|af-legacyhostapi.tm>>
    <associate|auto-387|<tuple|F.1.15.1|141|af-legacyhostapi.tm>>
    <associate|auto-388|<tuple|F.1.15.2|141|af-legacyhostapi.tm>>
    <associate|auto-389|<tuple|F.1.15.3|141|af-legacyhostapi.tm>>
    <associate|auto-39|<tuple|3.1.1|23|c03-transition.tm>>
    <associate|auto-390|<tuple|F.1.16|141|af-legacyhostapi.tm>>
    <associate|auto-391|<tuple|F.1.16.1|141|af-legacyhostapi.tm>>
    <associate|auto-392|<tuple|F.1.16.2|142|af-legacyhostapi.tm>>
    <associate|auto-393|<tuple|F.1.16.3|142|af-legacyhostapi.tm>>
    <associate|auto-394|<tuple|F.1.16.4|142|af-legacyhostapi.tm>>
    <associate|auto-395|<tuple|F.1.16.5|143|af-legacyhostapi.tm>>
    <associate|auto-396|<tuple|F.1.16.6|143|af-legacyhostapi.tm>>
    <associate|auto-397|<tuple|F.1.17|143|af-legacyhostapi.tm>>
    <associate|auto-398|<tuple|F.1.17.1|144|af-legacyhostapi.tm>>
    <associate|auto-399|<tuple|F.1.17.2|144|af-legacyhostapi.tm>>
    <associate|auto-4|<tuple|1.2|14|c01-background.tm>>
    <associate|auto-40|<tuple|3.1.2|24|c03-transition.tm>>
    <associate|auto-400|<tuple|F.1.17.3|145|af-legacyhostapi.tm>>
    <associate|auto-401|<tuple|F.1.17.4|145|af-legacyhostapi.tm>>
    <associate|auto-402|<tuple|F.1.17.5|145|af-legacyhostapi.tm>>
    <associate|auto-403|<tuple|F.1.17.6|146|af-legacyhostapi.tm>>
    <associate|auto-404|<tuple|F.1.17.7|146|af-legacyhostapi.tm>>
    <associate|auto-405|<tuple|F.1.17.8|146|af-legacyhostapi.tm>>
    <associate|auto-406|<tuple|F.1.17.9|147|af-legacyhostapi.tm>>
    <associate|auto-407|<tuple|F.1.17.10|147|af-legacyhostapi.tm>>
    <associate|auto-408|<tuple|F.1.17.11|148|af-legacyhostapi.tm>>
    <associate|auto-409|<tuple|F.1.17.12|148|af-legacyhostapi.tm>>
    <associate|auto-41|<tuple|3.1.2.1|24|c03-transition.tm>>
    <associate|auto-410|<tuple|F.1.17.13|148|af-legacyhostapi.tm>>
    <associate|auto-411|<tuple|F.1.17.14|149|af-legacyhostapi.tm>>
    <associate|auto-412|<tuple|F.1.17.15|149|af-legacyhostapi.tm>>
    <associate|auto-413|<tuple|F.1.18|150|af-legacyhostapi.tm>>
    <associate|auto-414|<tuple|F.1.18.1|150|af-legacyhostapi.tm>>
    <associate|auto-415|<tuple|F.1.19|150|af-legacyhostapi.tm>>
    <associate|auto-416|<tuple|F.1.19.1|150|af-legacyhostapi.tm>>
    <associate|auto-417|<tuple|F.1.19.2|150|af-legacyhostapi.tm>>
    <associate|auto-418|<tuple|F.1.20|151|af-legacyhostapi.tm>>
    <associate|auto-419|<tuple|F.1.20.1|151|af-legacyhostapi.tm>>
    <associate|auto-42|<tuple|3.1.2.2|24|c03-transition.tm>>
    <associate|auto-420|<tuple|F.1.21|151|af-legacyhostapi.tm>>
    <associate|auto-421|<tuple|F.2|151|af-legacyhostapi.tm>>
    <associate|auto-422|<tuple|G|153|ag-runtimeentries.tm>>
    <associate|auto-423|<tuple|G.1|153|ag-runtimeentries.tm>>
    <associate|auto-424|<tuple|G.1|153|ag-runtimeentries.tm>>
    <associate|auto-425|<tuple|G.2|154|ag-runtimeentries.tm>>
    <associate|auto-426|<tuple|G.2.1|154|ag-runtimeentries.tm>>
    <associate|auto-427|<tuple|G.1|154|ag-runtimeentries.tm>>
    <associate|auto-428|<tuple|G.2.2|154|ag-runtimeentries.tm>>
    <associate|auto-429|<tuple|G.2.3|155|ag-runtimeentries.tm>>
    <associate|auto-43|<tuple|3.1.2.3|25|c03-transition.tm>>
    <associate|auto-430|<tuple|G.2.4|155|ag-runtimeentries.tm>>
    <associate|auto-431|<tuple|G.2.5|155|ag-runtimeentries.tm>>
    <associate|auto-432|<tuple|G.2|156|ag-runtimeentries.tm>>
    <associate|auto-433|<tuple|G.2.6|156|ag-runtimeentries.tm>>
    <associate|auto-434|<tuple|G.2.7|156|ag-runtimeentries.tm>>
    <associate|auto-435|<tuple|G.3|157|ag-runtimeentries.tm>>
    <associate|auto-436|<tuple|G.4|157|ag-runtimeentries.tm>>
    <associate|auto-437|<tuple|G.5|157|ag-runtimeentries.tm>>
    <associate|auto-438|<tuple|G.6|158|ag-runtimeentries.tm>>
    <associate|auto-439|<tuple|G.2.8|158|ag-runtimeentries.tm>>
    <associate|auto-44|<tuple|3.1.2.4|25|c03-transition.tm>>
    <associate|auto-440|<tuple|G.7|158|ag-runtimeentries.tm>>
    <associate|auto-441|<tuple|G.8|159|ag-runtimeentries.tm>>
    <associate|auto-442|<tuple|G.9|159|ag-runtimeentries.tm>>
    <associate|auto-443|<tuple|G.10|159|ag-runtimeentries.tm>>
    <associate|auto-444|<tuple|G.11|159|ag-runtimeentries.tm>>
    <associate|auto-445|<tuple|G.12|160|ag-runtimeentries.tm>>
    <associate|auto-446|<tuple|G.13|160|ag-runtimeentries.tm>>
    <associate|auto-447|<tuple|G.2.9|160|ag-runtimeentries.tm>>
    <associate|auto-448|<tuple|G.2.10|161|ag-runtimeentries.tm>>
    <associate|auto-449|<tuple|G.2.10|163>>
    <associate|auto-45|<tuple|3.2|25|c03-transition.tm>>
    <associate|auto-450|<tuple|G.2.10|165>>
    <associate|auto-451|<tuple|Tec19|167>>
    <associate|auto-46|<tuple|3.2.1|25|c03-transition.tm>>
    <associate|auto-47|<tuple|3.2.2|26|c03-transition.tm>>
    <associate|auto-48|<tuple|3.2.2.1|26|c03-transition.tm>>
    <associate|auto-49|<tuple|3.2.3|26|c03-transition.tm>>
    <associate|auto-5|<tuple|1.4|14|c01-background.tm>>
    <associate|auto-50|<tuple|3.2.3|26|c03-transition.tm>>
    <associate|auto-51|<tuple|3.2.3|26|c03-transition.tm>>
    <associate|auto-52|<tuple|3.2.3|26|c03-transition.tm>>
    <associate|auto-53|<tuple|3.2.3.1|27|c03-transition.tm>>
    <associate|auto-54|<tuple|3.1|27|c03-transition.tm>>
    <associate|auto-55|<tuple|3.3|28|c03-transition.tm>>
    <associate|auto-56|<tuple|3.3.1|28|c03-transition.tm>>
    <associate|auto-57|<tuple|3.3.1.1|28|c03-transition.tm>>
    <associate|auto-58|<tuple|3.2|29|c03-transition.tm>>
    <associate|auto-59|<tuple|3.3.1.2|29|c03-transition.tm>>
    <associate|auto-6|<tuple|1.7|14|c01-background.tm>>
    <associate|auto-60|<tuple|3.3.1.3|29|c03-transition.tm>>
    <associate|auto-61|<tuple|3.3.2|30|c03-transition.tm>>
    <associate|auto-62|<tuple|3.3.3|31|c03-transition.tm>>
    <associate|auto-63|<tuple|3.3.4|31|c03-transition.tm>>
    <associate|auto-64|<tuple|3.3|32|c03-transition.tm>>
    <associate|auto-65|<tuple|3.3.4.1|32|c03-transition.tm>>
    <associate|auto-66|<tuple|3.3.4.2|32|c03-transition.tm>>
    <associate|auto-67|<tuple|3.3.4.3|33|c03-transition.tm>>
    <associate|auto-68|<tuple|4|35|c04-networking.tm>>
    <associate|auto-69|<tuple|4.1|35|c04-networking.tm>>
    <associate|auto-7|<tuple|1.7|14|c01-background.tm>>
    <associate|auto-70|<tuple|4.1.1|35|c04-networking.tm>>
    <associate|auto-71|<tuple|4.1.2|35|c04-networking.tm>>
    <associate|auto-72|<tuple|4.1.3|36|c04-networking.tm>>
    <associate|auto-73|<tuple|4.1.4|36|c04-networking.tm>>
    <associate|auto-74|<tuple|4.2|36|c04-networking.tm>>
    <associate|auto-75|<tuple|4.2.1|36|c04-networking.tm>>
    <associate|auto-76|<tuple|4.2.1.1|36|c04-networking.tm>>
    <associate|auto-77|<tuple|4.2.1.2|37|c04-networking.tm>>
    <associate|auto-78|<tuple|4.2.2|38|c04-networking.tm>>
    <associate|auto-79|<tuple|4.2.2.1|38|c04-networking.tm>>
    <associate|auto-8|<tuple|1.7|14|c01-background.tm>>
    <associate|auto-80|<tuple|4.2.2.2|38|c04-networking.tm>>
    <associate|auto-81|<tuple|4.2.2.3|39|c04-networking.tm>>
    <associate|auto-82|<tuple|4.2.2.4|39|c04-networking.tm>>
    <associate|auto-83|<tuple|4.2.2.5|39|c04-networking.tm>>
    <associate|auto-84|<tuple|4.2.2.6|39|c04-networking.tm>>
    <associate|auto-85|<tuple|4.2.2.7|40|c04-networking.tm>>
    <associate|auto-86|<tuple|4.2.2.8|40|c04-networking.tm>>
    <associate|auto-87|<tuple|4.2.2.9|40|c04-networking.tm>>
    <associate|auto-88|<tuple|4.2.2.10|40|c04-networking.tm>>
    <associate|auto-89|<tuple|4.2.2.11|41|c04-networking.tm>>
    <associate|auto-9|<tuple|1.9|15|c01-background.tm>>
    <associate|auto-90|<tuple|4.2.3|41|c04-networking.tm>>
    <associate|auto-91|<tuple|4.2.3.1|42|c04-networking.tm>>
    <associate|auto-92|<tuple|4.2.3.2|42|c04-networking.tm>>
    <associate|auto-93|<tuple|4.3|42|c04a-networking.tm>>
    <associate|auto-94|<tuple|4.3.1|42|c04a-networking.tm>>
    <associate|auto-95|<tuple|4.3.2|43|c04a-networking.tm>>
    <associate|auto-96|<tuple|4.3.3|43|c04a-networking.tm>>
    <associate|auto-97|<tuple|4.3.3.1|43|c04a-networking.tm>>
    <associate|auto-98|<tuple|4.3.3.2|44|c04a-networking.tm>>
    <associate|auto-99|<tuple|4.3.4|44|c04a-networking.tm>>
    <associate|bib-burdges_schnorr_2019|<tuple|Bur19|165>>
    <associate|bib-collet_extremely_2019|<tuple|Col19|165>>
    <associate|bib-david_ouroboros_2018|<tuple|DGKR18|165>>
    <associate|bib-josefsson_edwards-curve_2017|<tuple|JL17|165>>
    <associate|bib-liusvaara_edwards-curve_2017|<tuple|LJ17|165>>
    <associate|bib-parity_technologies_substrate_2019|<tuple|Tec19|165>>
    <associate|bib-perrin_noise_2018|<tuple|Per18|165>>
    <associate|bib-protocol_labs_libp2p_2019|<tuple|lab19|165>>
    <associate|bib-saarinen_blake2_2015|<tuple|SA15|165>>
    <associate|bib-stewart_grandpa:_2019|<tuple|Ste19|165>>
    <associate|bib-w3f_research_group_blind_2019|<tuple|Gro19|165>>
    <associate|bib-web3.0_technologies_foundation_polkadot_2020|<tuple|Fou20|165>>
    <associate|block|<tuple|3.3.1.1|28|c03-transition.tm>>
    <associate|chap-bootstrapping|<tuple|5|45|c05-bootstrapping.tm>>
    <associate|chap-consensu|<tuple|6|47|c06-consensus.tm>>
    <associate|chap-state-spec|<tuple|2|17|c02-state.tm>>
    <associate|chap-state-transit|<tuple|3|23|c03-transition.tm>>
    <associate|defn-account-key|<tuple|A.1|95|aa-cryptoalgorithms.tm>>
    <associate|defn-approval-attestation-transaction|<tuple|7.29|81|c07-anv.tm>>
    <associate|defn-authority-list|<tuple|6.1|47|c06-consensus.tm>>
    <associate|defn-authority-set-id|<tuple|6.15|54|c06-consensus.tm>>
    <associate|defn-availability-bitfield|<tuple|7.22|77|c07-anv.tm>>
    <associate|defn-availability-vote-message|<tuple|7.21|76|c07-anv.tm>>
    <associate|defn-available-parablock-proposal|<tuple|7.23|77|c07-anv.tm>>
    <associate|defn-babe-header|<tuple|6.12|51|c06-consensus.tm>>
    <associate|defn-babe-seal|<tuple|6.13|51|c06-consensus.tm>>
    <associate|defn-bit-rep|<tuple|1.6|14|c01-background.tm>>
    <associate|defn-blob|<tuple|7.10|68|c07-anv.tm>>
    <associate|defn-block-body|<tuple|3.9|29|c03-transition.tm>>
    <associate|defn-block-data|<tuple|D.2|105|ad-netmessages.tm>>
    <associate|defn-block-header|<tuple|3.6|28|c03-transition.tm>>
    <associate|defn-block-header-hash|<tuple|3.8|29|c03-transition.tm>>
    <associate|defn-block-signature|<tuple|6.13|51|c06-consensus.tm>>
    <associate|defn-block-time|<tuple|6.10|50|c06-consensus.tm>>
    <associate|defn-block-tree|<tuple|1.11|15|c01-background.tm>>
    <associate|defn-candidate|<tuple|7.11|70|c07-anv.tm>>
    <associate|defn-candidate-commitments|<tuple|7.14|71|c07-anv.tm>>
    <associate|defn-candidate-receipt|<tuple|7.13|71|c07-anv.tm>>
    <associate|defn-chain-subchain|<tuple|1.13|15|c01-background.tm>>
    <associate|defn-child-storage-type|<tuple|E.4|111|ae-hostapi.tm>>
    <associate|defn-children-bitmap|<tuple|2.10|21|c02-state.tm>>
    <associate|defn-collator-invalidity-transaction|<tuple|7.30|81|c07-anv.tm>>
    <associate|defn-collator-unavailability-transaction|<tuple|7.31|81|c07-anv.tm>>
    <associate|defn-consensus-message-digest|<tuple|6.2|47|c06-consensus.tm>>
    <associate|defn-controller-key|<tuple|A.3|96|aa-cryptoalgorithms.tm>>
    <associate|defn-digest|<tuple|3.7|28|c03-transition.tm>>
    <associate|defn-ecdsa-verify-error|<tuple|E.6|115|ae-hostapi.tm>>
    <associate|defn-epoch-slot|<tuple|6.5|49|c06-consensus.tm>>
    <associate|defn-epoch-subchain|<tuple|6.7|49|c06-consensus.tm>>
    <associate|defn-erasure-coded-chunks|<tuple|7.19|76|c07-anv.tm>>
    <associate|defn-erasure-coded-chunks-request|<tuple|7.26|80|c07-anv.tm>>
    <associate|defn-erasure-coded-chunks-response|<tuple|7.27|80|c07-anv.tm>>
    <associate|defn-erasure-encoder-decoder|<tuple|7.18|74|c07-anv.tm>>
    <associate|defn-extra-validation-data|<tuple|7.6|67|c07-anv.tm>>
    <associate|defn-finalized-block|<tuple|6.33|61|c06-consensus.tm>>
    <associate|defn-genesis-header|<tuple|C.1|101|ac-genesis.tm>>
    <associate|defn-global-validation-parameters|<tuple|7.7|67|c07-anv.tm>>
    <associate|defn-gossip-message|<tuple|6.26|56|c06-consensus.tm>>
    <associate|defn-gossip-statement|<tuple|7.16|72|c07-anv.tm>>
    <associate|defn-grandpa-catchup-request-msg|<tuple|6.30|58|c06-consensus.tm>>
    <associate|defn-grandpa-catchup-response-msg|<tuple|6.31|58|c06-consensus.tm>>
    <associate|defn-grandpa-completable|<tuple|6.25|56|c06-consensus.tm>>
    <associate|defn-grandpa-justification|<tuple|6.28|57|c06-consensus.tm>>
    <associate|defn-grandpa-voter|<tuple|6.14|54|c06-consensus.tm>>
    <associate|defn-head-data|<tuple|7.12|70|c07-anv.tm>>
    <associate|defn-hex-encoding|<tuple|B.12|99|ab-encodings.tm>>
    <associate|defn-http-error|<tuple|E.10|124|ae-hostapi.tm>>
    <associate|defn-http-return-value|<tuple|F.3|144|af-legacyhostapi.tm>>
    <associate|defn-http-status-codes|<tuple|E.9|124|ae-hostapi.tm>>
    <associate|defn-index-function|<tuple|2.7|19|c02-state.tm>>
    <associate|defn-inherent-data|<tuple|3.5|28|c03-transition.tm>>
    <associate|defn-invalid-transaction|<tuple|G.4|157|ag-runtimeentries.tm>>
    <associate|defn-key-type-id|<tuple|E.5|114|ae-hostapi.tm>>
    <associate|defn-lexicographic-ordering|<tuple|E.3|107|ae-hostapi.tm>>
    <associate|defn-little-endian|<tuple|1.7|14|c01-background.tm>>
    <associate|defn-local-storage|<tuple|E.8|124|ae-hostapi.tm>>
    <associate|defn-local-validation-parameters|<tuple|7.8|67|c07-anv.tm>>
    <associate|defn-logging-log-level|<tuple|E.11|133|ae-hostapi.tm>>
    <associate|defn-longest-chain|<tuple|1.14|15|c01-background.tm>>
    <associate|defn-merkle-value|<tuple|2.12|21|c02-state.tm>>
    <associate|defn-node-header|<tuple|2.9|19|c02-state.tm>>
    <associate|defn-node-key|<tuple|2.6|18|c02-state.tm>>
    <associate|defn-node-subvalue|<tuple|2.11|21|c02-state.tm>>
    <associate|defn-node-value|<tuple|2.8|19|c02-state.tm>>
    <associate|defn-nodetype|<tuple|2.4|18|c02-state.tm>>
    <associate|defn-offchain-local-storage|<tuple|F.2|144|af-legacyhostapi.tm>>
    <associate|defn-offchain-persistent-storage|<tuple|F.1|144|af-legacyhostapi.tm>>
    <associate|defn-option-type|<tuple|B.4|97|ab-encodings.tm>>
    <associate|defn-para-proposal|<tuple|7.17|74|c07-anv.tm>>
    <associate|defn-path-graph|<tuple|1.2|14|c01-background.tm>>
    <associate|defn-persistent-storage|<tuple|E.7|124|ae-hostapi.tm>>
    <associate|defn-pov-block|<tuple|7.15|72|c07-anv.tm>>
    <associate|defn-pov-block-response|<tuple|7.25|80|c07-anv.tm>>
    <associate|defn-pov-erasure-chunk-message|<tuple|7.20|76|c07-anv.tm>>
    <associate|defn-pruned-tree|<tuple|1.12|15|c01-background.tm>>
    <associate|defn-radix-tree|<tuple|1.3|14|c01-background.tm>>
    <associate|defn-result-type|<tuple|B.5|98|ab-encodings.tm>>
    <associate|defn-rt-apisvec|<tuple|G.1|154|ag-runtimeentries.tm>>
    <associate|defn-rt-blockbuilder-finalize-block|<tuple|G.2.10|161|ag-runtimeentries.tm>>
    <associate|defn-rt-core-version|<tuple|G.2.1|154|ag-runtimeentries.tm>>
    <associate|defn-rte-apply-extrinsic-result|<tuple|G.6|158|ag-runtimeentries.tm>>
    <associate|defn-rte-custom-module-error|<tuple|G.9|159|ag-runtimeentries.tm>>
    <associate|defn-rte-dispatch-error|<tuple|G.8|159|ag-runtimeentries.tm>>
    <associate|defn-rte-dispatch-outcome|<tuple|G.7|158|ag-runtimeentries.tm>>
    <associate|defn-rte-invalid-transaction|<tuple|G.11|159|ag-runtimeentries.tm>>
    <associate|defn-rte-transaction-validity-error|<tuple|G.10|159|ag-runtimeentries.tm>>
    <associate|defn-rte-unknown-transaction|<tuple|G.12|160|ag-runtimeentries.tm>>
    <associate|defn-runtime|<tuple|<with|mode|<quote|math>|\<bullet\>>|14|c01-background.tm>>
    <associate|defn-runtime-pointer|<tuple|E.2|107|ae-hostapi.tm>>
    <associate|defn-sc-len-encoding|<tuple|B.11|99|ab-encodings.tm>>
    <associate|defn-scale-byte-array|<tuple|B.1|97|ab-encodings.tm>>
    <associate|defn-scale-codec|<tuple|7.1|66|c07-anv.tm>>
    <associate|defn-scale-empty|<tuple|B.10|98|ab-encodings.tm>>
    <associate|defn-scale-fixed-length|<tuple|B.9|98|ab-encodings.tm>>
    <associate|defn-scale-list|<tuple|B.7|98|ab-encodings.tm>>
    <associate|defn-scale-tuple|<tuple|B.2|97|ab-encodings.tm>>
    <associate|defn-scale-variable-type|<tuple|B.6|98|ab-encodings.tm>>
    <associate|defn-secondary-appoval-attestation|<tuple|7.28|81|c07-anv.tm>>
    <associate|defn-session-key|<tuple|A.4|96|aa-cryptoalgorithms.tm>>
    <associate|defn-set-state-at|<tuple|3.10|31|c03-transition.tm>>
    <associate|defn-slot-offset|<tuple|6.11|50|c06-consensus.tm>>
    <associate|defn-stash-key|<tuple|A.2|95|aa-cryptoalgorithms.tm>>
    <associate|defn-state-machine|<tuple|1.1|13|c01-background.tm>>
    <associate|defn-stored-value|<tuple|2.1|17|c02-state.tm>>
    <associate|defn-total-potential-votes|<tuple|6.23|56|c06-consensus.tm>>
    <associate|defn-transaction-queue|<tuple|3.4|26|c03-transition.tm>>
    <associate|defn-transaction-validity-error|<tuple|G.3|157|ag-runtimeentries.tm>>
    <associate|defn-unavailable-parachain-block|<tuple|7.24|77|c07-anv.tm>>
    <associate|defn-unix-time|<tuple|1.10|15|c01-background.tm>>
    <associate|defn-unknown-transaction|<tuple|G.5|158|ag-runtimeentries.tm>>
    <associate|defn-upgrade-indicator|<tuple|7.5|66|c07-anv.tm>>
    <associate|defn-valid-transaction|<tuple|G.2|157|ag-runtimeentries.tm>>
    <associate|defn-varrying-data-type|<tuple|B.3|97|ab-encodings.tm>>
    <associate|defn-vote|<tuple|6.17|55|c06-consensus.tm>>
    <associate|defn-winning-threshold|<tuple|6.8|49|c06-consensus.tm>>
    <associate|defn-witness-proof|<tuple|7.3|66|c07-anv.tm>>
    <associate|diag-anv-overall|<tuple|7.1|69|c07-anv.tm>>
    <associate|escalation|<tuple|7.12.3|81|c07-anv.tm>>
    <associate|exmp-candid-unfinalized|<tuple|6.32|61|c06-consensus.tm>>
    <associate|key-encode-in-trie|<tuple|2.1|18|c02-state.tm>>
    <associate|network-protocol|<tuple|4.3|42|c04a-networking.tm>>
    <associate|nota-call-into-runtime|<tuple|3.2|24|c03-transition.tm>>
    <associate|nota-re-api-at-state|<tuple|E.1|107|ae-hostapi.tm>>
    <associate|nota-runtime-code-at-state|<tuple|3.1|24|c03-transition.tm>>
    <associate|note-slot|<tuple|6.6|49|c06-consensus.tm>>
    <associate|part:aa-cryptoalgorithms.tm|<tuple|8.5|95>>
    <associate|part:ab-encodings.tm|<tuple|A.5.5|97>>
    <associate|part:ac-genesis.tm|<tuple|B.12|101>>
    <associate|part:ad-netmessages.tm|<tuple|C.1|103>>
    <associate|part:ae-hostapi.tm|<tuple|D.1.7|107>>
    <associate|part:af-legacyhostapi.tm|<tuple|<with|mode|<quote|math>|\<bullet\>>|135>>
    <associate|part:ag-runtimeentries.tm|<tuple|F.2|153>>
    <associate|part:c01-background.tm|<tuple|?|13>>
    <associate|part:c02-state.tm|<tuple|1.16|17>>
    <associate|part:c03-transition.tm|<tuple|2.2.1|23>>
    <associate|part:c04-networking.tm|<tuple|3.3.4.3|35>>
    <associate|part:c04a-networking.tm|<tuple|4.2.3.2|42>>
    <associate|part:c05-bootstrapping.tm|<tuple|<with|mode|<quote|math>|\<bullet\>>|45>>
    <associate|part:c06-consensus.tm|<tuple|5|47>>
    <associate|part:c07-anv.tm|<tuple|19|65>>
    <associate|part:c08-messaging.tm|<tuple|7.12.3|82>>
    <associate|sect-approval-checking|<tuple|7.11|78|c07-anv.tm>>
    <associate|sect-authority-set|<tuple|6.1.1|47|c06-consensus.tm>>
    <associate|sect-babe|<tuple|6.2|49|c06-consensus.tm>>
    <associate|sect-blake2|<tuple|A.2|95|aa-cryptoalgorithms.tm>>
    <associate|sect-block-body|<tuple|3.3.1.3|29|c03-transition.tm>>
    <associate|sect-block-building|<tuple|6.2.7|53|c06-consensus.tm>>
    <associate|sect-block-finalization|<tuple|6.4|61|c06-consensus.tm>>
    <associate|sect-block-format|<tuple|3.3.1|28|c03-transition.tm>>
    <associate|sect-block-production|<tuple|6.2|49|c06-consensus.tm>>
    <associate|sect-block-submission|<tuple|3.3.2|30|c03-transition.tm>>
    <associate|sect-block-validation|<tuple|3.3.2|30|c03-transition.tm>>
    <associate|sect-certifying-keys|<tuple|A.5.5|96|aa-cryptoalgorithms.tm>>
    <associate|sect-changes-trie|<tuple|3.3.4|31|c03-transition.tm>>
    <associate|sect-changes-trie-block-pairs|<tuple|3.3.4.2|32|c03-transition.tm>>
    <associate|sect-changes-trie-child-trie-pair|<tuple|3.3.4.3|33|c03-transition.tm>>
    <associate|sect-changes-trie-extrinsics-pairs|<tuple|3.3.4.1|32|c03-transition.tm>>
    <associate|sect-child-storage-api|<tuple|E.2|111|ae-hostapi.tm>>
    <associate|sect-child-storages|<tuple|2.2|21|c02-state.tm>>
    <associate|sect-child-trie-structure|<tuple|2.2.1|22|c02-state.tm>>
    <associate|sect-consensus-message-digest|<tuple|6.1.2|47|c06-consensus.tm>>
    <associate|sect-controller-settings|<tuple|A.5.4|96|aa-cryptoalgorithms.tm>>
    <associate|sect-creating-controller-key|<tuple|A.5.2|96|aa-cryptoalgorithms.tm>>
    <associate|sect-cryptographic-keys|<tuple|A.5|95|aa-cryptoalgorithms.tm>>
    <associate|sect-defn-conv|<tuple|1.2|13|c01-background.tm>>
    <associate|sect-designating-proxy|<tuple|A.5.3|96|aa-cryptoalgorithms.tm>>
    <associate|sect-distribute-chunks|<tuple|7.8|76|c07-anv.tm>>
    <associate|sect-encoding|<tuple|B|97|ab-encodings.tm>>
    <associate|sect-entries-into-runtime|<tuple|3.1|23|c03-transition.tm>>
    <associate|sect-epoch-randomness|<tuple|6.2.5|52|c06-consensus.tm>>
    <associate|sect-equivocation-case|<tuple|7.11.5|79|c07-anv.tm>>
    <associate|sect-ext-crypto-ecdsa-verify|<tuple|E.3.12|119|ae-hostapi.tm>>
    <associate|sect-ext-crypto-ed25519-verify|<tuple|E.3.4|116|ae-hostapi.tm>>
    <associate|sect-ext-crypto-finish-batch-verify|<tuple|E.3.16|121|ae-hostapi.tm>>
    <associate|sect-ext-crypto-sr25519-verify|<tuple|E.3.8|118|ae-hostapi.tm>>
    <associate|sect-ext-crypto-start-batch-verify|<tuple|E.3.15|121|ae-hostapi.tm>>
    <associate|sect-ext-storage-changes-root|<tuple|E.1.9|110|ae-hostapi.tm>>
    <associate|sect-ext-storage-commit-transaction|<tuple|E.1.13|111|ae-hostapi.tm>>
    <associate|sect-ext-storage-rollback-transaction|<tuple|E.1.12|111|ae-hostapi.tm>>
    <associate|sect-ext-storage-start-transaction|<tuple|E.1.11|110|ae-hostapi.tm>>
    <associate|sect-extra-validation|<tuple|7.11.4|79|c07-anv.tm>>
    <associate|sect-extrinsics|<tuple|3.2|25|c03-transition.tm>>
    <associate|sect-finality|<tuple|6.3|54|c06-consensus.tm>>
    <associate|sect-genesis-block|<tuple|C|101|ac-genesis.tm>>
    <associate|sect-grandpa-catchup|<tuple|6.4.1|62|c06-consensus.tm>>
    <associate|sect-grandpa-catchup-messages|<tuple|6.3.2.3|58|c06-consensus.tm>>
    <associate|sect-handling-runtime-state-update|<tuple|3.1.2.4|25|c03-transition.tm>>
    <associate|sect-hash-functions|<tuple|A.1|95|aa-cryptoalgorithms.tm>>
    <associate|sect-inclusion-of-candidate-receipt|<tuple|7.5.1|74|c07-anv.tm>>
    <associate|sect-inherents|<tuple|3.2.3.1|27|c03-transition.tm>>
    <associate|sect-int-encoding|<tuple|B.1.1|99|ab-encodings.tm>>
    <associate|sect-justified-block-header|<tuple|3.3.1.2|29|c03-transition.tm>>
    <associate|sect-list-of-runtime-entries|<tuple|G.1|153|ag-runtimeentries.tm>>
    <associate|sect-loading-runtime-code|<tuple|3.1.1|23|c03-transition.tm>>
    <associate|sect-managing-multiple-states|<tuple|3.3.3|31|c03-transition.tm>>
    <associate|sect-merkl-proof|<tuple|2.1.4|20|c02-state.tm>>
    <associate|sect-message-detail|<tuple|D.1|103|ad-netmessages.tm>>
    <associate|sect-msg-block-announce|<tuple|D.1.4|105|ad-netmessages.tm>>
    <associate|sect-msg-block-request|<tuple|D.1.2|104|ad-netmessages.tm>>
    <associate|sect-msg-block-response|<tuple|D.1.3|105|ad-netmessages.tm>>
    <associate|sect-msg-consensus|<tuple|D.1.6|106|ad-netmessages.tm>>
    <associate|sect-msg-neighbor-packet|<tuple|D.1.7|106|ad-netmessages.tm>>
    <associate|sect-msg-status|<tuple|D.1.1|103|ad-netmessages.tm>>
    <associate|sect-msg-transactions|<tuple|D.1.5|105|ad-netmessages.tm>>
    <associate|sect-network-interactions|<tuple|4.3|42|c04a-networking.tm>>
    <associate|sect-network-messages|<tuple|D|103|ad-netmessages.tm>>
    <associate|sect-primary-validation|<tuple|7.4|70|c07-anv.tm>>
    <associate|sect-primary-validation-disagreemnt|<tuple|7.6.1|74|c07-anv.tm>>
    <associate|sect-primary-validaty-announcement|<tuple|7.5|71|c07-anv.tm>>
    <associate|sect-publishing-attestations|<tuple|7.10|78|c07-anv.tm>>
    <associate|sect-randomness|<tuple|A.3|95|aa-cryptoalgorithms.tm>>
    <associate|sect-re-api|<tuple|F|135|af-legacyhostapi.tm>>
    <associate|sect-retrieval-of-erasure-chunks|<tuple|7.12.0.1|80|c07-anv.tm>>
    <associate|sect-rte-apply-extrinsic|<tuple|G.2.8|158|ag-runtimeentries.tm>>
    <associate|sect-rte-babeapi-epoch|<tuple|G.2.5|155|ag-runtimeentries.tm>>
    <associate|sect-rte-core-execute-block|<tuple|G.2.2|154|ag-runtimeentries.tm>>
    <associate|sect-rte-grandpa-auth|<tuple|G.2.6|156|ag-runtimeentries.tm>>
    <associate|sect-rte-hash-and-length|<tuple|G.2.4|155|ag-runtimeentries.tm>>
    <associate|sect-rte-validate-transaction|<tuple|G.2.7|156|ag-runtimeentries.tm>>
    <associate|sect-runtime-entries|<tuple|G|153|ag-runtimeentries.tm>>
    <associate|sect-runtime-return-value|<tuple|3.1.2.3|25|c03-transition.tm>>
    <associate|sect-runtime-send-args-to-runtime-enteries|<tuple|3.1.2.2|24|c03-transition.tm>>
    <associate|sect-scale-codec|<tuple|B.1|97|ab-encodings.tm>>
    <associate|sect-sending-catchup-request|<tuple|6.4.1.1|62|c06-consensus.tm>>
    <associate|sect-set-storage|<tuple|F.1.1|135|af-legacyhostapi.tm>>
    <associate|sect-shot-assignment|<tuple|7.11.3|78|c07-anv.tm>>
    <associate|sect-staking-funds|<tuple|A.5.1|96|aa-cryptoalgorithms.tm>>
    <associate|sect-state-replication|<tuple|3.3|28|c03-transition.tm>>
    <associate|sect-state-storage|<tuple|2.1|17|c02-state.tm>>
    <associate|sect-state-storage-trie-structure|<tuple|2.1.3|18|c02-state.tm>>
    <associate|sect-verifying-authorship|<tuple|6.2.6|52|c06-consensus.tm>>
    <associate|sect-voting-on-availability|<tuple|7.9|76|c07-anv.tm>>
    <associate|sect-vrf|<tuple|A.4|95|aa-cryptoalgorithms.tm>>
    <associate|sect-vrf-comp|<tuple|7.11.2|78|c07-anv.tm>>
    <associate|sect_polkadot_communication_substream|<tuple|4.3.4.2|44|c04a-networking.tm>>
    <associate|sect_transport_protocol|<tuple|4.3.3|43|c04a-networking.tm>>
    <associate|slot-time-cal-tail|<tuple|6.9|50|c06-consensus.tm>>
    <associate|snippet-runtime-enteries|<tuple|G.1|153|ag-runtimeentries.tm>>
    <associate|tabl-account-key-schemes|<tuple|A.1|95|aa-cryptoalgorithms.tm>>
    <associate|tabl-block-attributes|<tuple|D.3|104|ad-netmessages.tm>>
    <associate|tabl-consensus-messages|<tuple|6.1|48|c06-consensus.tm>>
    <associate|tabl-digest-items|<tuple|3.2|29|c03-transition.tm>>
    <associate|tabl-genesis-header|<tuple|C.1|101|ac-genesis.tm>>
    <associate|tabl-inherent-data|<tuple|3.1|27|c03-transition.tm>>
    <associate|tabl-message-types|<tuple|D.1|103|ad-netmessages.tm>>
    <associate|tabl-node-role|<tuple|D.2|104|ad-netmessages.tm>>
    <associate|tabl-session-keys|<tuple|A.2|96|aa-cryptoalgorithms.tm>>
    <associate|table-changes-trie-key-types|<tuple|3.3|32|c03-transition.tm>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|bib>
      parity_technologies_substrate_2019

      protocol_labs_libp2p_2019

      liusvaara_edwards-curve_2017

      protocol_labs_libp2p_2019

      protocol_labs_libp2p_2019

      perrin_noise_2018

      protocol_labs_libp2p_2019

      protocol_labs_libp2p_2019

      protocol_labs_libp2p_2019

      w3f_research_group_blind_2019

      david_ouroboros_2018

      stewart_grandpa:_2019

      ??

      ??

      polkadot-crypto-spec

      saarinen_blake2_2015

      burdges_schnorr_2019

      josefsson_edwards-curve_2017

      web3.0_technologies_foundation_polkadot_2020

      collet_extremely_2019
    </associate>
    <\associate|figure>
      <tuple|normal|<surround|<hidden-binding|<tuple>|7.1>||Overall process
      to acheive availability and validity in Polkadot>|<pageref|auto-136>>

      <tuple|normal|<surround|<hidden-binding|<tuple>|8.1>||Parachain Message
      Passing Overview>|<pageref|auto-161>>

      <tuple|normal|<surround|<hidden-binding|<tuple>|8.2>||MQC
      Overview>|<pageref|auto-163>>

      <tuple|normal|<surround|<hidden-binding|<tuple>|8.3>||Parachain XCMP
      Overview>|<pageref|auto-175>>

      <tuple|normal|<surround|<hidden-binding|<tuple>|G.1>||Snippet to export
      entries into tho Wasm runtime module.>|<pageref|auto-424>>
    </associate>
    <\associate|gly>
      <tuple|normal|<with|font-series|<quote|bold>|math-font-series|<quote|bold>|<with|mode|<quote|math>|P<rsub|n>>>|a
      path graph or a path of n nodes, can be represented by sequences of
      <with|mode|<quote|math>|<around|(|v<rsub|1>,\<ldots\>,v<rsub|n>|)>>
      where <with|mode|<quote|math>|e<rsub|i>=<around|(|v<rsub|i>,v<rsub|i+1>|)>>
      for <with|mode|<quote|math>|1\<leqslant\>i\<leqslant\>n-1> is the edge
      which connect <with|mode|<quote|math>|v<rsub|i>> and
      <with|mode|<quote|math>|v<rsub|i+1>>|<pageref|auto-4>>

      <tuple|normal|<with|mode|<quote|math>|\<bbb-B\><rsub|n>>|a set of all
      byte arrays of length n|<pageref|auto-5>>

      <tuple|normal|I|the little-endian representation of a non-negative
      interger, represented as <with|mode|<quote|math>|I=<around*|(|B<rsub|n>\<ldots\>B<rsub|0>|)><rsub|256>>|<pageref|auto-6>>

      <tuple|normal|<with|mode|<quote|math>|B>|a byte array
      <with|mode|<quote|math>|B=<around*|(|b<rsub|0>,b<rsub|1>,\<ldots\>,b<rsub|n>|)>>
      such that <with|mode|<quote|math>|b<rsub|i>\<assign\>B<rsub|i>>|<pageref|auto-7>>

      <tuple|normal|<with|mode|<quote|math>|Enc<rsub|LE>>|<with|mode|<quote|math>|<tformat|<tformat|<table|<row|<cell|\<bbb-Z\><rsup|+>>|<cell|\<rightarrow\>>|<cell|\<bbb-B\>>>|<row|<cell|<around*|(|B<rsub|n>\<ldots\>B<rsub|0>|)><rsub|256>>|<cell|\<mapsto\>>|<cell|<around*|(|B<rsub|0,>B<rsub|1>,\<ldots\><rsub|>,B<rsub|n>|)>>>>>>>|<pageref|auto-8>>

      <tuple|normal|C, blockchain|a blockchain C is a directed path
      graph.|<pageref|auto-9>>

      <tuple|normal|Block|a node of the graph in blockchain C and indicated
      by <with|mode|<quote|math>|B>|<pageref|auto-10>>

      <tuple|normal|Genesis Block|the unique sink of blockchain
      C|<pageref|auto-11>>

      <tuple|normal|Head|the source of blockchain C|<pageref|auto-12>>

      <tuple|normal|P|for any vertex <with|mode|<quote|math>|<around*|(|B<rsub|1>,B<rsub|2>|)>>
      where <with|mode|<quote|math>|B<rsub|1>\<rightarrow\>B<rsub|2>> we say
      <with|mode|<quote|math>|B<rsub|2>> is the parent of
      <with|mode|<quote|math>|B<rsub|1>> and we indicate it by
      <with|mode|<quote|math>|B<rsub|2>\<assign\>P<around*|(|B<rsub|1>|)>>|<pageref|auto-13>>

      <tuple|normal|BT, block tree|is the union of all different versions of
      the blockchain observed by all the nodes in the system such as every
      such block is a node in the graph and
      <with|mode|<quote|math>|B<rsub|1>> is connected to
      <with|mode|<quote|math>|B<rsub|2>> if
      <with|mode|<quote|math>|B<rsub|1>> is a parent of
      <with|mode|<quote|math>|B<rsub|2>>|<pageref|auto-15>>

      <tuple|normal|PBT, Pruned BT|Pruned Block Tree refers to a subtree of
      the block tree obtained by eliminating all branches which do not
      contain the most recent finalized blocks, as defined in Definition
      <reference|defn-finalized-block>.|<pageref|auto-16>>

      <tuple|normal|pruning||<pageref|auto-17>>

      <tuple|normal|G|is the root of the block tree and B is one of its
      nodes.|<pageref|auto-18>>

      <tuple|normal|CHAIN(B)|refers to the path graph from
      <with|mode|<quote|math>|G> to <with|mode|<quote|math>|B> in
      (P)<with|mode|<quote|math>|BT>.|<pageref|auto-19>>

      <tuple|normal|head of C|defines the head of C to be
      <with|mode|<quote|math>|B>, formally noted as
      <with|mode|<quote|math>|B\<assign\>><with|font-shape|<quote|small-caps>|Head(<with|mode|<quote|math>|C>)>.|<pageref|auto-20>>

      <tuple|normal|<with|mode|<quote|math>|<around*|\||C|\|>>|defines he
      length of <with|mode|<quote|math>|C >as a path graph|<pageref|auto-21>>

      <tuple|normal|SubChain(<with|mode|<quote|math>|B<rprime|'>,B>)|If
      <with|mode|<quote|math>|B<rprime|'>> is another node on
      <with|font-shape|<quote|small-caps>|Chain(<with|mode|<quote|math>|B>)>,
      then by <with|font-shape|<quote|small-caps>|SubChain(<with|mode|<quote|math>|B<rprime|'>,B>)>
      we refer to the subgraph of <with|mode|<quote|math>|><with|font-shape|<quote|small-caps>|Chain(<with|mode|<quote|math>|B>)>
      path graph which contains both <with|mode|<quote|math>|B> and
      <with|mode|<quote|math>|B<rprime|'>>.|<pageref|auto-22>>

      <tuple|normal|<with|mode|<quote|math>|\<bbb-C\><rsub|B<rprime|'>><around*|(|<around*|(|P|)>BT|)>>|is
      the set of all subchains of <with|mode|<quote|math>|<around*|(|P|)>BT>
      rooted at <with|mode|<quote|math>|B<rprime|'>>.|<pageref|auto-23>>

      <tuple|normal|<with|mode|<quote|math>|\<bbb-C\>>|the set of all chains
      of <with|mode|<quote|math>|<around*|(|P|)>BT>,
      <with|mode|<quote|math>|\<bbb-C\><rsub|G><around*|(|<around*|(|*P|)>BT|)>>
      is denoted by <with|mode|<quote|math>|\<bbb-C\>>((P)BT) or simply
      <with|mode|<quote|math>|\<bbb-C\>>|<pageref|auto-24>>

      <tuple|normal|LONGEST-CHAIN(BT)|the maximum chain given by the complete
      order over <with|mode|<quote|math>|\<bbb-C\>>|<pageref|auto-25>>

      <tuple|normal|LONGEST-PATH(BT)|the path graph of
      <with|mode|<quote|math>|<around*|(|P|)>BT> which is the longest among
      all paths in <with|mode|<quote|math>|<around*|(|P|)>BT> and has the
      earliest block arrival time as defined in Definition
      <reference|defn-block-time>.|<pageref|auto-26>>

      <tuple|normal|DEEPEST-LEAF(BT)|the head of
      LONGEST-PATH(BT)|<pageref|auto-27>>

      <tuple|normal|StoredValue|the function retrieves the value stored under
      a specific key in the state storage and is formally defined as
      <with|mode|<quote|math>|<tformat|<tformat|<table|<row|<cell|\<cal-K\>\<rightarrow\>\<cal-V\>>>|<row|<cell|k\<mapsto\><around*|{|<tformat|<cwith|1|-1|1|-1|cell-halign|c>|<tformat|<table|<row|<cell|v>|<cell|<with|mode|<quote|text>|if
      (k,v) exists in state storage>>>|<row|<cell|\<phi\>>|<cell|otherwise>>>>>|\<nobracket\>>>>>>>>.
      Here <with|mode|<quote|math>|\<cal-K\>\<subset\>\<bbb-B\>> and
      <with|mode|<quote|math>|\<cal-V\>\<subset\>\<bbb-B\>> are respectively
      the set of all keys and values stored in the state
      storage.|<pageref|auto-31>>
    </associate>
    <\associate|idx>
      <tuple|<tuple|Transaction Message>|<pageref|auto-50>>

      <tuple|<tuple|transaction pool>|<pageref|auto-51>>

      <tuple|<tuple|transaction queue>|<pageref|auto-52>>
    </associate>
    <\associate|parts>
      <tuple|c01-background.tm|chapter-nr|0|section-nr|0<uninit>|subsection-nr|0>

      <tuple|c02-state.tm|chapter-nr|1|section-nr|2<uninit>|subsection-nr|1>

      <tuple|c03-transition.tm|chapter-nr|2|section-nr|2<uninit>|subsection-nr|1>

      <tuple|c04-networking.tm|chapter-nr|3|section-nr|3<uninit>|subsection-nr|4>

      <tuple|c04a-networking.tm|chapter-nr|4|section-nr|2<uninit>|subsection-nr|3>

      <tuple|c05-bootstrapping.tm|chapter-nr|4|section-nr|3<uninit>|subsection-nr|4>

      <tuple|c06-consensus.tm|chapter-nr|5|section-nr|0<uninit>|subsection-nr|4>

      <tuple|c07-anv.tm|chapter-nr|6|section-nr|4<uninit>|subsection-nr|1>

      <tuple|c08-messaging.tm|chapter-nr|7|section-nr|12<uninit>|subsection-nr|3>

      <tuple|aa-cryptoalgorithms.tm|chapter-nr|8|section-nr|5<uninit>|subsection-nr|0>

      <tuple|ab-encodings.tm|chapter-nr|8|section-nr|5<uninit>|subsection-nr|5>

      <tuple|ac-genesis.tm|chapter-nr|8|section-nr|2<uninit>|subsection-nr|0>

      <tuple|ad-netmessages.tm|chapter-nr|8|section-nr|0<uninit>|subsection-nr|0>

      <tuple|ae-hostapi.tm|chapter-nr|8|section-nr|1<uninit>|subsection-nr|7>

      <tuple|af-legacyhostapi.tm|chapter-nr|8|section-nr|9<uninit>|subsection-nr|1>

      <tuple|ag-runtimeentries.tm|chapter-nr|8|section-nr|2<uninit>|subsection-nr|0>
    </associate>
    <\associate|table>
      <tuple|normal|<\surround|<hidden-binding|<tuple>|3.1>|>
        List of inherent data
      </surround>|<pageref|auto-54>>

      <tuple|normal|<surround|<hidden-binding|<tuple>|3.2>||The detail of the
      varying type that a digest item can hold.>|<pageref|auto-58>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|3.3>|>
        Possible types of keys of mappings in the Changes Trie
      </surround>|<pageref|auto-64>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|6.1>|>
        The consensus digest item for GRANDPA authorities
      </surround>|<pageref|auto-107>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|6.2>|>
        \;
      </surround>|<pageref|auto-119>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|A.1>|>
        List of public key scheme which can be used for an account key
      </surround>|<pageref|auto-186>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|A.2>|>
        List of key schemes which are used for session keys depending on the
        protocol
      </surround>|<pageref|auto-187>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|C.1>|>
        Genesis header values
      </surround>|<pageref|auto-198>>

      <tuple|normal|<surround|<hidden-binding|<tuple>|D.1>||List of possible
      network message types.>|<pageref|auto-200>>

      <tuple|normal|<surround|<hidden-binding|<tuple>|D.2>||Node role
      representation in the status message.>|<pageref|auto-203>>

      <tuple|normal|<surround|<hidden-binding|<tuple>|D.3>||Bit values for
      block attribute <with|mode|<quote|math>|A<rsub|B>>, to indicate the
      requested parts of the data.>|<pageref|auto-205>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|E.1>|>
        Table of known key type identifiers
      </surround>|<pageref|auto-259>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|E.2>|>
        Table of error types in ECDSA recovery
      </surround>|<pageref|auto-260>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|E.3>|>
        Table of possible HTTP error types
      </surround>|<pageref|auto-310>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|E.4>|>
        Log Levels for the logging interface
      </surround>|<pageref|auto-367>>

      <tuple|normal|<surround|<hidden-binding|<tuple>|G.1>||Detail of the
      version data type returns from runtime
      <with|font-family|<quote|tt>|language|<quote|verbatim>|version>
      function.>|<pageref|auto-427>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|G.2>|>
        The tuple provided by <with|font-series|<quote|bold>|math-font-series|<quote|bold>|BabeApi_configuration>.
      </surround>|<pageref|auto-432>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|G.3>|>
        The tuple provided by <with|font-family|<quote|tt>|language|<quote|verbatim>|TaggedTransactionQueue_transaction_validity>

        in the case the transaction is judged to be valid.
      </surround>|<pageref|auto-435>>

      <tuple|normal|<surround|<hidden-binding|<tuple>|G.4>||Type variation
      for the return value of <with|font-family|<quote|tt>|language|<quote|verbatim>|TaggedTransactionQueue_transaction_validity>.>|<pageref|auto-436>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|G.5>|>
        Type variant whichs gets appended to Id 0 of
        <with|font-series|<quote|bold>|math-font-series|<quote|bold>|TransactionValidityError>.
      </surround>|<pageref|auto-437>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|G.6>|>
        Type variant whichs gets appended to Id 1 of
        <with|font-series|<quote|bold>|math-font-series|<quote|bold>|TransactionValidityError>.
      </surround>|<pageref|auto-438>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|G.7>|>
        Possible values of varying data type
        <with|font-series|<quote|bold>|math-font-series|<quote|bold>|ApplyExtrinsicResult>.
      </surround>|<pageref|auto-440>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|G.8>|>
        Possible values of varying data type
        <with|font-series|<quote|bold>|math-font-series|<quote|bold>|DispatchOutcome>.
      </surround>|<pageref|auto-441>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|G.9>|>
        Possible values of varying data type
        <with|font-series|<quote|bold>|math-font-series|<quote|bold>|DispatchError>.
      </surround>|<pageref|auto-442>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|G.10>|>
        Possible values of varying data type
        <with|font-series|<quote|bold>|math-font-series|<quote|bold>|CustomModuleError>.
      </surround>|<pageref|auto-443>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|G.11>|>
        Possible values of varying data type
        <with|font-series|<quote|bold>|math-font-series|<quote|bold>|TransactionValidityError>.
      </surround>|<pageref|auto-444>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|G.12>|>
        Possible values of varying data type
        <with|font-series|<quote|bold>|math-font-series|<quote|bold>|InvalidTransaction>.
      </surround>|<pageref|auto-445>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|G.13>|>
        Possible values of varying data type
        <with|font-series|<quote|bold>|math-font-series|<quote|bold>|UnknownTransaction>.
      </surround>|<pageref|auto-446>>
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|1.<space|2spc>Background>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-1><vspace|0.5fn>

      1.1.<space|2spc>Introduction <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>

      1.2.<space|2spc>Definitions and Conventions
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>

      <with|par-left|<quote|1tab>|1.2.1.<space|2spc>Block Tree
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-14>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|2.<space|2spc>State
      Specification> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-28><vspace|0.5fn>

      2.1.<space|2spc>State Storage and Storage Trie
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-29>

      <with|par-left|<quote|1tab>|2.1.1.<space|2spc>Accessing System Storage
      \ <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-30>>

      <with|par-left|<quote|1tab>|2.1.2.<space|2spc>The General Tree
      Structure <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-32>>

      <with|par-left|<quote|1tab>|2.1.3.<space|2spc>Trie Structure
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-33>>

      <with|par-left|<quote|1tab>|2.1.4.<space|2spc>Merkle Proof
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-34>>

      2.2.<space|2spc>Child Storage <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-35>

      <with|par-left|<quote|1tab>|2.2.1.<space|2spc>Child Tries
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-36>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|3.<space|2spc>State
      Transition> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-37><vspace|0.5fn>

      3.1.<space|2spc>Interactions with Runtime
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-38>

      <with|par-left|<quote|1tab>|3.1.1.<space|2spc>Loading the Runtime Code
      \ \ \ <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-39>>

      <with|par-left|<quote|1tab>|3.1.2.<space|2spc>Code Executor
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-40>>

      <with|par-left|<quote|2tab>|3.1.2.1.<space|2spc>Access to Runtime API
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-41>>

      <with|par-left|<quote|2tab>|3.1.2.2.<space|2spc>Sending Arguments to
      Runtime \ <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-42>>

      <with|par-left|<quote|2tab>|3.1.2.3.<space|2spc>The Return Value from a
      Runtime Entry <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-43>>

      <with|par-left|<quote|2tab>|3.1.2.4.<space|2spc>Handling Runtimes
      update to the State <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-44>>

      3.2.<space|2spc>Extrinsics <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-45>

      <with|par-left|<quote|1tab>|3.2.1.<space|2spc>Preliminaries
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-46>>

      <with|par-left|<quote|1tab>|3.2.2.<space|2spc>Transactions
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-47>>

      <with|par-left|<quote|2tab>|3.2.2.1.<space|2spc>Transaction Submission
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-48>>

      <with|par-left|<quote|1tab>|3.2.3.<space|2spc>Transaction Queue
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-49>>

      <with|par-left|<quote|2tab>|3.2.3.1.<space|2spc>Inherents
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-53>>

      3.3.<space|2spc>State Replication <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-55>

      <with|par-left|<quote|1tab>|3.3.1.<space|2spc>Block Format
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-56>>

      <with|par-left|<quote|2tab>|3.3.1.1.<space|2spc>Block Header
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-57>>

      <with|par-left|<quote|2tab>|3.3.1.2.<space|2spc>Justified Block Header
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-59>>

      <with|par-left|<quote|2tab>|3.3.1.3.<space|2spc>Block Body
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-60>>

      <with|par-left|<quote|1tab>|3.3.2.<space|2spc>Importing and Validating
      Block <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-61>>

      <with|par-left|<quote|1tab>|3.3.3.<space|2spc>Managaing Multiple
      Variants of State <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-62>>

      <with|par-left|<quote|1tab>|3.3.4.<space|2spc>Changes Trie
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-63>>

      <with|par-left|<quote|2tab>|3.3.4.1.<space|2spc>Key to extrinsics pairs
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-65>>

      <with|par-left|<quote|2tab>|3.3.4.2.<space|2spc>Key to block pairs
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-66>>

      <with|par-left|<quote|2tab>|3.3.4.3.<space|2spc>Key to Child Changes
      Trie pairs <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-67>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|4.<space|2spc>Networking>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-68><vspace|0.5fn>

      4.1.<space|2spc>Introduction <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-69>

      <with|par-left|<quote|1tab>|4.1.1.<space|2spc>External Documentation
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-70>>

      <with|par-left|<quote|1tab>|4.1.2.<space|2spc>Discovery mechanism
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-71>>

      <with|par-left|<quote|1tab>|4.1.3.<space|2spc>Connection establishment
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-72>>

      <with|par-left|<quote|1tab>|4.1.4.<space|2spc>Substreams
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-73>>

      4.2.<space|2spc>Network Messages <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-74>

      <with|par-left|<quote|1tab>|4.2.1.<space|2spc>API Package
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-75>>

      <with|par-left|<quote|2tab>|4.2.1.1.<space|2spc>BlockRequest
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-76>>

      <with|par-left|<quote|2tab>|4.2.1.2.<space|2spc>BlockResponse
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-77>>

      <with|par-left|<quote|1tab>|4.2.2.<space|2spc>Light Package
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-78>>

      <with|par-left|<quote|2tab>|4.2.2.1.<space|2spc>Request
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-79>>

      <with|par-left|<quote|2tab>|4.2.2.2.<space|2spc>Response
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-80>>

      <with|par-left|<quote|2tab>|4.2.2.3.<space|2spc>RemoteCallRequest
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-81>>

      <with|par-left|<quote|2tab>|4.2.2.4.<space|2spc>RemoteCallResponse
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-82>>

      <with|par-left|<quote|2tab>|4.2.2.5.<space|2spc>RemoteReadRequest
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-83>>

      <with|par-left|<quote|2tab>|4.2.2.6.<space|2spc>RemoteReadResponse
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-84>>

      <with|par-left|<quote|2tab>|4.2.2.7.<space|2spc>RemoteReadChildRequest
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-85>>

      <with|par-left|<quote|2tab>|4.2.2.8.<space|2spc>RemoteHeaderRequest
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-86>>

      <with|par-left|<quote|2tab>|4.2.2.9.<space|2spc>RemoteHeaderResponse
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-87>>

      <with|par-left|<quote|2tab>|4.2.2.10.<space|2spc>RemoteChangesRequest
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-88>>

      <with|par-left|<quote|2tab>|4.2.2.11.<space|2spc>RemoteChangesResponse
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-89>>

      <with|par-left|<quote|1tab>|4.2.3.<space|2spc>Finality Package
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-90>>

      <with|par-left|<quote|2tab>|4.2.3.1.<space|2spc>FinalityProofRequest
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-91>>

      <with|par-left|<quote|2tab>|4.2.3.2.<space|2spc>FinalityProofResponse
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-92>>

      4.3.<space|2spc> To be migrated <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-93>

      <with|par-left|<quote|1tab>|4.3.1.<space|2spc>Node Identities and
      Addresses <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-94>>

      <with|par-left|<quote|1tab>|4.3.2.<space|2spc>Discovery Mechanisms
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-95>>

      <with|par-left|<quote|1tab>|4.3.3.<space|2spc>Transport Protocol
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-96>>

      <with|par-left|<quote|2tab>|4.3.3.1.<space|2spc>Encryption
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-97>>

      <with|par-left|<quote|2tab>|4.3.3.2.<space|2spc>Multiplexing
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-98>>

      <with|par-left|<quote|1tab>|4.3.4.<space|2spc>Substreams
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-99>>

      <with|par-left|<quote|2tab>|4.3.4.1.<space|2spc>Periodic Ephemeral
      Substreams <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-100>>

      <with|par-left|<quote|2tab>|4.3.4.2.<space|2spc>Polkadot Communication
      Substream <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-101>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|5.<space|2spc>Bootstrapping>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-102><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|6.<space|2spc>Consensus>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-103><vspace|0.5fn>

      6.1.<space|2spc>Common Consensus Structures
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-104>

      <with|par-left|<quote|1tab>|6.1.1.<space|2spc>Consensus Authority Set
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-105>>

      <with|par-left|<quote|1tab>|6.1.2.<space|2spc>Runtime-to-Consensus
      Engine Message <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-106>>

      6.2.<space|2spc>Block Production <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-108>

      <with|par-left|<quote|1tab>|6.2.1.<space|2spc>Preliminaries
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-109>>

      <with|par-left|<quote|1tab>|6.2.2.<space|2spc>Block Production Lottery
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-110>>

      <with|par-left|<quote|1tab>|6.2.3.<space|2spc>Slot Number Calculation
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-111>>

      <with|par-left|<quote|1tab>|6.2.4.<space|2spc>Block Production
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-112>>

      <with|par-left|<quote|1tab>|6.2.5.<space|2spc>Epoch Randomness
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-113>>

      <with|par-left|<quote|1tab>|6.2.6.<space|2spc>Verifying Authorship
      Right <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-114>>

      <with|par-left|<quote|1tab>|6.2.7.<space|2spc>Block Building Process
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-115>>

      6.3.<space|2spc>Finality <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-116>

      <with|par-left|<quote|1tab>|6.3.1.<space|2spc>Preliminaries
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-117>>

      <with|par-left|<quote|1tab>|6.3.2.<space|2spc>GRANDPA Messages
      Specification <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-118>>

      <with|par-left|<quote|2tab>|6.3.2.1.<space|2spc>Vote Messages
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-120>>

      <with|par-left|<quote|2tab>|6.3.2.2.<space|2spc>Finalizing Message
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-121>>

      <with|par-left|<quote|2tab>|6.3.2.3.<space|2spc>Catch-up Messages
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-122>>

      <with|par-left|<quote|1tab>|6.3.3.<space|2spc>Initiating the GRANDPA
      State <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-123>>

      <with|par-left|<quote|2tab>|6.3.3.1.<space|2spc>Voter Set Changes
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-124>>

      <with|par-left|<quote|1tab>|6.3.4.<space|2spc>Voting Process in Round
      <with|mode|<quote|math>|r> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-125>>

      6.4.<space|2spc>Block Finalization <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-126>

      <with|par-left|<quote|1tab>|6.4.1.<space|2spc>Catching up
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-127>>

      <with|par-left|<quote|2tab>|6.4.1.1.<space|2spc>Sending catch-up
      requests <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-128>>

      <with|par-left|<quote|2tab>|6.4.1.2.<space|2spc>Processing catch-up
      requests <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-129>>

      <with|par-left|<quote|2tab>|6.4.1.3.<space|2spc>Processing catch-up
      responses <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-130>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|7.<space|2spc>Availability
      & Validity> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-131><vspace|0.5fn>

      7.1.<space|2spc>Introduction <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-132>

      7.2.<space|2spc>Preliminaries <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-133>

      <with|par-left|<quote|1tab>|7.2.1.<space|2spc>Extra Validation Data
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-134>>

      7.3.<space|2spc>Overal process <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-135>

      7.4.<space|2spc>Candidate Selection
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-137>

      7.5.<space|2spc>Candidate Backing <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-138>

      <with|par-left|<quote|1tab>|7.5.1.<space|2spc>Inclusion of candidate
      receipt on the relay chain <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-139>>

      7.6.<space|2spc>PoV Distribution <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-140>

      <with|par-left|<quote|1tab>|7.6.1.<space|2spc>Primary Validation
      Disagreement <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-141>>

      7.7.<space|2spc>Availability <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-142>

      7.8.<space|2spc>Distribution of Chunks
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-143>

      7.9.<space|2spc>Announcing Availability
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-144>

      <with|par-left|<quote|1tab>|7.9.1.<space|2spc>Processing on-chain
      availability data <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-145>>

      7.10.<space|2spc>Publishing Attestations
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-146>

      7.11.<space|2spc>Secondary Approval checking
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-147>

      <with|par-left|<quote|1tab>|7.11.1.<space|2spc>Approval Checker
      Assignment <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-148>>

      <with|par-left|<quote|1tab>|7.11.2.<space|2spc>VRF computation
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-149>>

      <with|par-left|<quote|1tab>|7.11.3.<space|2spc>One-Shot Approval
      Checker Assignemnt <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-150>>

      <with|par-left|<quote|1tab>|7.11.4.<space|2spc>Extra Approval Checker
      Assigment <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-151>>

      <with|par-left|<quote|1tab>|7.11.5.<space|2spc>Additional Checking in
      Case of Equivocation <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-152>>

      7.12.<space|2spc>The Approval Check
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-153>

      <with|par-left|<quote|2tab>|7.12.0.1.<space|2spc>Retrieval
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-154>>

      <with|par-left|<quote|2tab>|7.12.0.2.<space|2spc>Reconstruction
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-155>>

      <with|par-left|<quote|1tab>|7.12.1.<space|2spc>Verification
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-156>>

      <with|par-left|<quote|1tab>|7.12.2.<space|2spc>Process validity and
      invalidity messages <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-157>>

      <with|par-left|<quote|1tab>|7.12.3.<space|2spc>Invalidity Escalation
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-158>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|8.<space|2spc>Message
      Passing> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-159><vspace|0.5fn>

      8.1.<space|2spc>Overview <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-160>

      8.2.<space|2spc>Message Queue Chain (MQC)
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-162>

      8.3.<space|2spc>HRMP <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-164>

      <with|par-left|<quote|1tab>|8.3.1.<space|2spc>Channels
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-165>>

      <with|par-left|<quote|1tab>|8.3.2.<space|2spc>Opening Channels
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-166>>

      <with|par-left|<quote|2tab>|8.3.2.1.<space|2spc>Workflow
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-167>>

      <with|par-left|<quote|1tab>|8.3.3.<space|2spc>Accepting Channels
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-168>>

      <with|par-left|<quote|2tab>|8.3.3.1.<space|2spc>Workflow
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-169>>

      <with|par-left|<quote|1tab>|8.3.4.<space|2spc>Closing Channels
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-170>>

      <with|par-left|<quote|1tab>|8.3.5.<space|2spc>Workflow
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-171>>

      <with|par-left|<quote|1tab>|8.3.6.<space|2spc>Sending messages
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-172>>

      <with|par-left|<quote|1tab>|8.3.7.<space|2spc>Receiving Messages
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-173>>

      8.4.<space|2spc>XCMP <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-174>

      <with|par-left|<quote|1tab>|8.4.1.<space|2spc>CST: Channel State Table
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-176>>

      <with|par-left|<quote|1tab>|8.4.2.<space|2spc>Message content
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-177>>

      <with|par-left|<quote|1tab>|8.4.3.<space|2spc>Watermark
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-178>>

      8.5.<space|2spc>SPREE <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-179>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Appendix
      A.<space|2spc>Cryptographic Algorithms>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-180><vspace|0.5fn>

      A.1.<space|2spc>Hash Functions <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-181>

      A.2.<space|2spc>BLAKE2 <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-182>

      A.3.<space|2spc>Randomness <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-183>

      A.4.<space|2spc>VRF <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-184>

      A.5.<space|2spc>Cryptographic Keys <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-185>

      <with|par-left|<quote|1tab>|A.5.1.<space|2spc>Holding and staking funds
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-188>>

      <with|par-left|<quote|1tab>|A.5.2.<space|2spc>Creating a Controller key
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-189>>

      <with|par-left|<quote|1tab>|A.5.3.<space|2spc>Designating a proxy for
      voting <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-190>>

      <with|par-left|<quote|1tab>|A.5.4.<space|2spc>Controller settings
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-191>>

      <with|par-left|<quote|1tab>|A.5.5.<space|2spc>Certifying keys
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-192>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Appendix
      B.<space|2spc>Auxiliary Encodings> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-193><vspace|0.5fn>

      B.1.<space|2spc>SCALE Codec <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-194>

      <with|par-left|<quote|1tab>|B.1.1.<space|2spc>Length and Compact
      Encoding <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-195>>

      B.2.<space|2spc>Hex Encoding <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-196>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Appendix
      C.<space|2spc>Genesis State Specification>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-197><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Appendix
      D.<space|2spc>Network Messages> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-199><vspace|0.5fn>

      D.1.<space|2spc>Detailed Message Structure
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-201>

      <with|par-left|<quote|1tab>|D.1.1.<space|2spc>Status Message
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-202>>

      <with|par-left|<quote|1tab>|D.1.2.<space|2spc>Block Request Message
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-204>>

      <with|par-left|<quote|1tab>|D.1.3.<space|2spc>Block Response Message
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-206>>

      <with|par-left|<quote|1tab>|D.1.4.<space|2spc>Block Announce Message
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-207>>

      <with|par-left|<quote|1tab>|D.1.5.<space|2spc>Transactions
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-208>>

      <with|par-left|<quote|1tab>|D.1.6.<space|2spc>Consensus Message
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-209>>

      <with|par-left|<quote|1tab>|D.1.7.<space|2spc>Neighbor Packet
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-210>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Appendix
      E.<space|2spc>Polkadot Host API> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-211><vspace|0.5fn>

      E.1.<space|2spc>Storage <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-212>

      <with|par-left|<quote|1tab>|E.1.1.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_set>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-213>>

      <with|par-left|<quote|2tab>|E.1.1.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-214>>

      <with|par-left|<quote|1tab>|E.1.2.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_get>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-215>>

      <with|par-left|<quote|2tab>|E.1.2.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-216>>

      <with|par-left|<quote|1tab>|E.1.3.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_read>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-217>>

      <with|par-left|<quote|2tab>|E.1.3.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-218>>

      <with|par-left|<quote|1tab>|E.1.4.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_clear>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-219>>

      <with|par-left|<quote|2tab>|E.1.4.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-220>>

      <with|par-left|<quote|1tab>|E.1.5.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_exists>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-221>>

      <with|par-left|<quote|2tab>|E.1.5.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-222>>

      <with|par-left|<quote|1tab>|E.1.6.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_clear_prefix>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-223>>

      <with|par-left|<quote|2tab>|E.1.6.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-224>>

      <with|par-left|<quote|1tab>|E.1.7.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_append>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-225>>

      <with|par-left|<quote|2tab>|E.1.7.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-226>>

      <with|par-left|<quote|1tab>|E.1.8.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_root>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-227>>

      <with|par-left|<quote|2tab>|E.1.8.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-228>>

      <with|par-left|<quote|1tab>|E.1.9.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_changes_root>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-229>>

      <with|par-left|<quote|2tab>|E.1.9.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-230>>

      <with|par-left|<quote|1tab>|E.1.10.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_next_key>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-231>>

      <with|par-left|<quote|2tab>|E.1.10.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-232>>

      <with|par-left|<quote|1tab>|E.1.11.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_start_transaction>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-233>>

      <with|par-left|<quote|2tab>|E.1.11.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-234>>

      <with|par-left|<quote|1tab>|E.1.12.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_rollback_transaction>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-235>>

      <with|par-left|<quote|2tab>|E.1.12.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-236>>

      <with|par-left|<quote|1tab>|E.1.13.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_commit_transaction>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-237>>

      <with|par-left|<quote|2tab>|E.1.13.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-238>>

      E.2.<space|2spc>Child Storage <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-239>

      <with|par-left|<quote|1tab>|E.2.1.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_default_child_storage_set>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-240>>

      <with|par-left|<quote|2tab>|E.2.1.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-241>>

      <with|par-left|<quote|1tab>|E.2.2.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_default_child_storage_get>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-242>>

      <with|par-left|<quote|2tab>|E.2.2.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-243>>

      <with|par-left|<quote|1tab>|E.2.3.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_default_child_storage_read>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-244>>

      <with|par-left|<quote|2tab>|E.2.3.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-245>>

      <with|par-left|<quote|1tab>|E.2.4.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_default_child_storage_clear>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-246>>

      <with|par-left|<quote|2tab>|E.2.4.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-247>>

      <with|par-left|<quote|1tab>|E.2.5.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_default_child_storage_storage_kill>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-248>>

      <with|par-left|<quote|2tab>|E.2.5.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-249>>

      <with|par-left|<quote|1tab>|E.2.6.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_default_child_storage_exists>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-250>>

      <with|par-left|<quote|2tab>|E.2.6.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-251>>

      <with|par-left|<quote|1tab>|E.2.7.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_default_child_storage_clear_prefix>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-252>>

      <with|par-left|<quote|2tab>|E.2.7.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-253>>

      <with|par-left|<quote|1tab>|E.2.8.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_default_child_storage_root>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-254>>

      <with|par-left|<quote|2tab>|E.2.8.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-255>>

      <with|par-left|<quote|1tab>|E.2.9.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_default_child_storage_next_key>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-256>>

      <with|par-left|<quote|2tab>|E.2.9.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-257>>

      E.3.<space|2spc>Crypto <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-258>

      <with|par-left|<quote|1tab>|E.3.1.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_ed25519_public_keys>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-261>>

      <with|par-left|<quote|2tab>|E.3.1.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-262>>

      <with|par-left|<quote|1tab>|E.3.2.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_ed25519_generate>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-263>>

      <with|par-left|<quote|2tab>|E.3.2.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-264>>

      <with|par-left|<quote|1tab>|E.3.3.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_ed25519_sign>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-265>>

      <with|par-left|<quote|2tab>|E.3.3.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-266>>

      <with|par-left|<quote|1tab>|E.3.4.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_ed25519_verify>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-267>>

      <with|par-left|<quote|2tab>|E.3.4.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-268>>

      <with|par-left|<quote|1tab>|E.3.5.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_sr25519_public_keys>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-269>>

      <with|par-left|<quote|2tab>|E.3.5.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-270>>

      <with|par-left|<quote|1tab>|E.3.6.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_sr25519_generate>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-271>>

      <with|par-left|<quote|2tab>|E.3.6.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-272>>

      <with|par-left|<quote|1tab>|E.3.7.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_sr25519_sign>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-273>>

      <with|par-left|<quote|2tab>|E.3.7.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-274>>

      <with|par-left|<quote|1tab>|E.3.8.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_sr25519_verify>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-275>>

      <with|par-left|<quote|2tab>|E.3.8.1.<space|2spc>Version 2 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-276>>

      <with|par-left|<quote|2tab>|E.3.8.2.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-277>>

      <with|par-left|<quote|1tab>|E.3.9.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_ecdsa_public_keys>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-278>>

      <with|par-left|<quote|2tab>|E.3.9.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-279>>

      <with|par-left|<quote|1tab>|E.3.10.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_ecdsa_generate>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-280>>

      <with|par-left|<quote|2tab>|E.3.10.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-281>>

      <with|par-left|<quote|1tab>|E.3.11.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_ecdsa_sign>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-282>>

      <with|par-left|<quote|2tab>|E.3.11.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-283>>

      <with|par-left|<quote|1tab>|E.3.12.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_ecdsa_verify>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-284>>

      <with|par-left|<quote|2tab>|E.3.12.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-285>>

      <with|par-left|<quote|1tab>|E.3.13.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_secp256k1_ecdsa_recover>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-286>>

      <with|par-left|<quote|2tab>|E.3.13.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-287>>

      <with|par-left|<quote|1tab>|E.3.14.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_secp256k1_ecdsa_recover_compressed>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-288>>

      <with|par-left|<quote|2tab>|E.3.14.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-289>>

      <with|par-left|<quote|1tab>|E.3.15.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_start_batch_verify>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-290>>

      <with|par-left|<quote|2tab>|E.3.15.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-291>>

      <with|par-left|<quote|1tab>|E.3.16.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_crypto_finish_batch_verify>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-292>>

      <with|par-left|<quote|2tab>|E.3.16.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-293>>

      E.4.<space|2spc>Hashing <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-294>

      <with|par-left|<quote|1tab>|E.4.1.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_hashing_keccak_256>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-295>>

      <with|par-left|<quote|2tab>|E.4.1.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-296>>

      <with|par-left|<quote|1tab>|E.4.2.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_hashing_sha2_256>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-297>>

      <with|par-left|<quote|2tab>|E.4.2.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-298>>

      <with|par-left|<quote|1tab>|E.4.3.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_hashing_blake2_128>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-299>>

      <with|par-left|<quote|2tab>|E.4.3.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-300>>

      <with|par-left|<quote|1tab>|E.4.4.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_hashing_blake2_256>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-301>>

      <with|par-left|<quote|2tab>|E.4.4.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-302>>

      <with|par-left|<quote|1tab>|E.4.5.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_hashing_twox_64>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-303>>

      <with|par-left|<quote|2tab>|E.4.5.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-304>>

      <with|par-left|<quote|1tab>|E.4.6.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_hashing_twox_128>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-305>>

      <with|par-left|<quote|2tab>|E.4.6.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-306>>

      <with|par-left|<quote|1tab>|E.4.7.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_hashing_twox_256>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-307>>

      <with|par-left|<quote|2tab>|E.4.7.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-308>>

      E.5.<space|2spc>Offchain <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-309>

      <with|par-left|<quote|1tab>|E.5.1.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_is_validator>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-311>>

      <with|par-left|<quote|2tab>|E.5.1.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-312>>

      <with|par-left|<quote|1tab>|E.5.2.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_submit_transaction>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-313>>

      <with|par-left|<quote|2tab>|E.5.2.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-314>>

      <with|par-left|<quote|1tab>|E.5.3.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_network_state>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-315>>

      <with|par-left|<quote|2tab>|E.5.3.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-316>>

      <with|par-left|<quote|1tab>|E.5.4.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_timestamp>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-317>>

      <with|par-left|<quote|2tab>|E.5.4.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-318>>

      <with|par-left|<quote|1tab>|E.5.5.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_sleep_until>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-319>>

      <with|par-left|<quote|2tab>|E.5.5.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-320>>

      <with|par-left|<quote|1tab>|E.5.6.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_random_seed>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-321>>

      <with|par-left|<quote|2tab>|E.5.6.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-322>>

      <with|par-left|<quote|1tab>|E.5.7.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_local_storage_set>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-323>>

      <with|par-left|<quote|2tab>|E.5.7.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-324>>

      <with|par-left|<quote|1tab>|E.5.8.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_local_storage_compare_and_set>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-325>>

      <with|par-left|<quote|2tab>|E.5.8.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-326>>

      <with|par-left|<quote|1tab>|E.5.9.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_local_storage_get>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-327>>

      <with|par-left|<quote|2tab>|E.5.9.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-328>>

      <with|par-left|<quote|1tab>|E.5.10.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_http_request_start>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-329>>

      <with|par-left|<quote|2tab>|E.5.10.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-330>>

      <with|par-left|<quote|1tab>|E.5.11.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_http_request_add_header>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-331>>

      <with|par-left|<quote|2tab>|E.5.11.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-332>>

      <with|par-left|<quote|1tab>|E.5.12.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_http_request_write_body>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-333>>

      <with|par-left|<quote|2tab>|E.5.12.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-334>>

      <with|par-left|<quote|1tab>|E.5.13.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_http_response_wait>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-335>>

      <with|par-left|<quote|2tab>|E.5.13.1.<space|2spc>Version 1- Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-336>>

      <with|par-left|<quote|1tab>|E.5.14.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_http_response_headers>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-337>>

      <with|par-left|<quote|2tab>|E.5.14.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-338>>

      <with|par-left|<quote|1tab>|E.5.15.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_offchain_http_response_read_body>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-339>>

      <with|par-left|<quote|2tab>|E.5.15.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-340>>

      E.6.<space|2spc>Trie <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-341>

      <with|par-left|<quote|1tab>|E.6.1.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_trie_blake2_256_root>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-342>>

      <with|par-left|<quote|2tab>|E.6.1.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-343>>

      <with|par-left|<quote|1tab>|E.6.2.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_trie_blake2_256_ordered_root>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-344>>

      <with|par-left|<quote|2tab>|E.6.2.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-345>>

      <with|par-left|<quote|1tab>|E.6.3.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_trie_keccak_256_root>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-346>>

      <with|par-left|<quote|2tab>|E.6.3.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-347>>

      <with|par-left|<quote|1tab>|E.6.4.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_trie_keccak_256_ordered_root>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-348>>

      <with|par-left|<quote|2tab>|E.6.4.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-349>>

      E.7.<space|2spc>Miscellaneous <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-350>

      <with|par-left|<quote|1tab>|E.7.1.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_misc_chain_id>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-351>>

      <with|par-left|<quote|2tab>|E.7.1.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-352>>

      <with|par-left|<quote|1tab>|E.7.2.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_misc_print_num>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-353>>

      <with|par-left|<quote|2tab>|E.7.2.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-354>>

      <with|par-left|<quote|1tab>|E.7.3.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_misc_print_utf8>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-355>>

      <with|par-left|<quote|2tab>|E.7.3.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-356>>

      <with|par-left|<quote|1tab>|E.7.4.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_misc_print_hex>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-357>>

      <with|par-left|<quote|2tab>|E.7.4.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-358>>

      <with|par-left|<quote|1tab>|E.7.5.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_misc_runtime_version>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-359>>

      <with|par-left|<quote|2tab>|E.7.5.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-360>>

      E.8.<space|2spc>Allocator <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-361>

      <with|par-left|<quote|1tab>|E.8.1.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_allocator_malloc>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-362>>

      <with|par-left|<quote|2tab>|E.8.1.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-363>>

      <with|par-left|<quote|1tab>|E.8.2.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_allocator_free>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-364>>

      <with|par-left|<quote|2tab>|E.8.2.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-365>>

      E.9.<space|2spc>Logging <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-366>

      <with|par-left|<quote|1tab>|E.9.1.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_logging_log>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-368>>

      <with|par-left|<quote|2tab>|E.9.1.1.<space|2spc>Version 1 - Prototype
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-369>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Appendix
      F.<space|2spc>Legacy Polkadot Host API>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-370><vspace|0.5fn>

      F.1.<space|2spc>Storage <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-371>

      <with|par-left|<quote|1tab>|F.1.1.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_set_storage>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-372>>

      <with|par-left|<quote|1tab>|F.1.2.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_storage_root>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-373>>

      <with|par-left|<quote|1tab>|F.1.3.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_blake2_256_enumerated_trie_root>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-374>>

      <with|par-left|<quote|1tab>|F.1.4.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_clear_prefix>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-375>>

      <with|par-left|<quote|1tab>|F.1.5.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_clear_storage>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-376>>

      <with|par-left|<quote|1tab>|F.1.6.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_exists_storage>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-377>>

      <with|par-left|<quote|1tab>|F.1.7.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_get_allocated_storage>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-378>>

      <with|par-left|<quote|1tab>|F.1.8.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_get_storage_into>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-379>>

      <with|par-left|<quote|1tab>|F.1.9.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_set_child_storage>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-380>>

      <with|par-left|<quote|1tab>|F.1.10.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_clear_child_storage>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-381>>

      <with|par-left|<quote|1tab>|F.1.11.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_exists_child_storage>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-382>>

      <with|par-left|<quote|1tab>|F.1.12.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_get_allocated_child_storage>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-383>>

      <with|par-left|<quote|1tab>|F.1.13.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_get_child_storage_into>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-384>>

      <with|par-left|<quote|1tab>|F.1.14.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_kill_child_storage>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-385>>

      <with|par-left|<quote|1tab>|F.1.15.<space|2spc>Memory
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-386>>

      <with|par-left|<quote|2tab>|F.1.15.1.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_malloc>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-387>>

      <with|par-left|<quote|2tab>|F.1.15.2.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_free>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-388>>

      <with|par-left|<quote|2tab>|F.1.15.3.<space|2spc>Input/Output
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-389>>

      <with|par-left|<quote|1tab>|F.1.16.<space|2spc>Cryptograhpic Auxiliary
      Functions <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-390>>

      <with|par-left|<quote|2tab>|F.1.16.1.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_blake2_256>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-391>>

      <with|par-left|<quote|2tab>|F.1.16.2.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_keccak_256>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-392>>

      <with|par-left|<quote|2tab>|F.1.16.3.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_twox_128>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-393>>

      <with|par-left|<quote|2tab>|F.1.16.4.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_ed25519_verify>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-394>>

      <with|par-left|<quote|2tab>|F.1.16.5.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_sr25519_verify>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-395>>

      <with|par-left|<quote|2tab>|F.1.16.6.<space|2spc>To be Specced
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-396>>

      <with|par-left|<quote|1tab>|F.1.17.<space|2spc>Offchain Worker
      \ <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-397>>

      <with|par-left|<quote|2tab>|F.1.17.1.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_is_validator>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-398>>

      <with|par-left|<quote|2tab>|F.1.17.2.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_submit_transaction>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-399>>

      <with|par-left|<quote|2tab>|F.1.17.3.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_network_state>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-400>>

      <with|par-left|<quote|2tab>|F.1.17.4.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_timestamp>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-401>>

      <with|par-left|<quote|2tab>|F.1.17.5.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_sleep_until>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-402>>

      <with|par-left|<quote|2tab>|F.1.17.6.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_random_seed>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-403>>

      <with|par-left|<quote|2tab>|F.1.17.7.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_local_storage_set>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-404>>

      <with|par-left|<quote|2tab>|F.1.17.8.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_local_storage_compare_and_set>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-405>>

      <with|par-left|<quote|2tab>|F.1.17.9.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_local_storage_get>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-406>>

      <with|par-left|<quote|2tab>|F.1.17.10.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_http_request_start>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-407>>

      <with|par-left|<quote|2tab>|F.1.17.11.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_http_request_add_header>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-408>>

      <with|par-left|<quote|2tab>|F.1.17.12.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_http_request_write_body>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-409>>

      <with|par-left|<quote|2tab>|F.1.17.13.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_http_response_wait>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-410>>

      <with|par-left|<quote|2tab>|F.1.17.14.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_http_response_headers>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-411>>

      <with|par-left|<quote|2tab>|F.1.17.15.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_http_response_read_body>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-412>>

      <with|par-left|<quote|1tab>|F.1.18.<space|2spc>Sandboxing
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-413>>

      <with|par-left|<quote|2tab>|F.1.18.1.<space|2spc>To be Specced
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-414>>

      <with|par-left|<quote|1tab>|F.1.19.<space|2spc>Auxillary Debugging API
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-415>>

      <with|par-left|<quote|2tab>|F.1.19.1.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_print_hex>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-416>>

      <with|par-left|<quote|2tab>|F.1.19.2.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|ext_print_utf8>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-417>>

      <with|par-left|<quote|1tab>|F.1.20.<space|2spc>Misc
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-418>>

      <with|par-left|<quote|2tab>|F.1.20.1.<space|2spc>To be Specced
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-419>>

      <with|par-left|<quote|1tab>|F.1.21.<space|2spc>Block Production
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-420>>

      F.2.<space|2spc>Validation <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-421>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Appendix
      G.<space|2spc>Runtime Entries> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-422><vspace|0.5fn>

      G.1.<space|2spc>List of Runtime Entries
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-423>

      G.2.<space|2spc>Argument Specification
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-425>

      <with|par-left|<quote|1tab>|G.2.1.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|Core_version>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-426>>

      <with|par-left|<quote|1tab>|G.2.2.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|Core_execute_block>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-428>>

      <with|par-left|<quote|1tab>|G.2.3.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|Core_initialize_block>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-429>>

      <with|par-left|<quote|1tab>|G.2.4.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|hash_and_length>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-430>>

      <with|par-left|<quote|1tab>|G.2.5.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|BabeApi_configuration>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-431>>

      <with|par-left|<quote|1tab>|G.2.6.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|GrandpaApi_grandpa_authorities>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-433>>

      <with|par-left|<quote|1tab>|G.2.7.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|TaggedTransactionQueue_validate_transaction>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-434>>

      <with|par-left|<quote|1tab>|G.2.8.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|BlockBuilder_apply_extrinsic>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-439>>

      <with|par-left|<quote|1tab>|G.2.9.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|BlockBuilder_inherent_extrinsics>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-447>>

      <with|par-left|<quote|1tab>|G.2.10.<space|2spc><with|font-family|<quote|tt>|language|<quote|verbatim>|BlockBuilder_finalize_block>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-448>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Glossary>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-449><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Bibliography>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-450><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Index>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-451><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>