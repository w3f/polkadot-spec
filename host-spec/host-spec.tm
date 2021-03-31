<TeXmacs|1.99.18>

<style|<tuple|tmbook|algorithmacs-style|old-dots|old-lengths>>

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
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-39>>

    <with|par-left|1tab|3.1.2.<space|2spc>Code Executor
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-40>>

    <with|par-left|2tab|3.1.2.1.<space|2spc>Access to Runtime API
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-41>>

    <with|par-left|2tab|3.1.2.2.<space|2spc>Memory Management
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-42>>

    <with|par-left|2tab|3.1.2.3.<space|2spc>Sending Arguments to Runtime
    \ <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-43>>

    <with|par-left|2tab|3.1.2.4.<space|2spc>The Return Value from a Runtime
    Entry <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-44>>

    <with|par-left|2tab|3.1.2.5.<space|2spc>Handling Runtimes update to the
    State <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-45>>

    3.2.<space|2spc>Extrinsics <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-46>

    <with|par-left|1tab|3.2.1.<space|2spc>Preliminaries
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-47>>

    <with|par-left|1tab|3.2.2.<space|2spc>Transactions
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-48>>

    <with|par-left|2tab|3.2.2.1.<space|2spc>Transaction Submission
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-49>>

    <with|par-left|1tab|3.2.3.<space|2spc>Transaction Queue
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-50>>

    <with|par-left|2tab|3.2.3.1.<space|2spc>Inherents
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-54>>

    3.3.<space|2spc>State Replication <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-56>

    <with|par-left|1tab|3.3.1.<space|2spc>Block Format
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-57>>

    <with|par-left|2tab|3.3.1.1.<space|2spc>Block Header
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-58>>

    <with|par-left|2tab|3.3.1.2.<space|2spc>Justified Block Header
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-60>>

    <with|par-left|2tab|3.3.1.3.<space|2spc>Block Body
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-61>>

    <with|par-left|1tab|3.3.2.<space|2spc>Importing and Validating Block
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-62>>

    <with|par-left|1tab|3.3.3.<space|2spc>Managaing Multiple Variants of
    State <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-63>>

    <with|par-left|1tab|3.3.4.<space|2spc>Changes Trie
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-64>>

    <with|par-left|2tab|3.3.4.1.<space|2spc>Key to extrinsics pairs
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-66>>

    <with|par-left|2tab|3.3.4.2.<space|2spc>Key to block pairs
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-67>>

    <with|par-left|2tab|3.3.4.3.<space|2spc>Key to Child Changes Trie pairs
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-68>>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|4.<space|2spc>Networking>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-69><vspace|0.5fn>

    4.1.<space|2spc>Introduction <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-70>

    <with|par-left|1tab|4.1.1.<space|2spc>External Documentation
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-71>>

    <with|par-left|1tab|4.1.2.<space|2spc>Node Identities
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-72>>

    <with|par-left|1tab|4.1.3.<space|2spc>Discovery mechanism
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-73>>

    <with|par-left|1tab|4.1.4.<space|2spc>Connection establishment
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-74>>

    <with|par-left|1tab|4.1.5.<space|2spc>Encryption Layer
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-75>>

    <with|par-left|1tab|4.1.6.<space|2spc>Protocols and Substreams
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-76>>

    <with|par-left|1tab|4.1.7.<space|2spc>Network Messages
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-77>>

    <with|par-left|2tab|4.1.7.1.<space|2spc>Announcing blocks
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-78>>

    <with|par-left|2tab|4.1.7.2.<space|2spc>Requesting blocks
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-79>>

    <with|par-left|2tab|4.1.7.3.<space|2spc>Transactions
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-86>>

    <with|par-left|2tab|4.1.7.4.<space|2spc>GRANDPA Votes
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-87>>

    <with|par-left|2tab|4.1.7.5.<space|2spc>GRANDPA Equivocation Proof
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-88>>

    <with|par-left|2tab|4.1.7.6.<space|2spc>BABE Equivocation Proof
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-89>>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|5.<space|2spc>Bootstrapping>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-90><vspace|0.5fn>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|6.<space|2spc>Consensus>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-91><vspace|0.5fn>

    6.1.<space|2spc>Common Consensus Structures
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-92>

    <with|par-left|1tab|6.1.1.<space|2spc>Consensus Authority Set
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-93>>

    <with|par-left|1tab|6.1.2.<space|2spc>Runtime-to-Consensus Engine Message
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-94>>

    6.2.<space|2spc>Block Production <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-97>

    <with|par-left|1tab|6.2.1.<space|2spc>Preliminaries
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-98>>

    <with|par-left|1tab|6.2.2.<space|2spc>Block Production Lottery
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-99>>

    <with|par-left|1tab|6.2.3.<space|2spc>Slot Number Calculation
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-100>>

    <with|par-left|1tab|6.2.4.<space|2spc>Block Production
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-102>>

    <with|par-left|1tab|6.2.5.<space|2spc>Epoch Randomness
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-103>>

    <with|par-left|1tab|6.2.6.<space|2spc>Verifying Authorship Right
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-104>>

    <with|par-left|1tab|6.2.7.<space|2spc>Block Building Process
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-105>>

    6.3.<space|2spc>Finality <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-106>

    <with|par-left|1tab|6.3.1.<space|2spc>Preliminaries
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-107>>

    <with|par-left|1tab|6.3.2.<space|2spc>GRANDPA Messages Specification
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-108>>

    <with|par-left|2tab|6.3.2.1.<space|2spc>Vote Messages
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-110>>

    <with|par-left|2tab|6.3.2.2.<space|2spc>Finalizing Message
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-112>>

    <with|par-left|2tab|6.3.2.3.<space|2spc>Catch-up Messages
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-113>>

    <with|par-left|1tab|6.3.3.<space|2spc>Initiating the GRANDPA State
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-114>>

    <with|par-left|2tab|6.3.3.1.<space|2spc>Voter Set Changes
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-115>>

    <with|par-left|1tab|6.3.4.<space|2spc>Voting Process in Round
    <with|mode|math|r> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-116>>

    6.4.<space|2spc>Block Finalization <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-117>

    <with|par-left|1tab|6.4.1.<space|2spc>Catching up
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-118>>

    <with|par-left|2tab|6.4.1.1.<space|2spc>Sending catch-up requests
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-119>>

    <with|par-left|2tab|6.4.1.2.<space|2spc>Processing catch-up requests
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-120>>

    <with|par-left|2tab|6.4.1.3.<space|2spc>Processing catch-up responses
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-121>>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|7.<space|2spc>Availability
    & Validity> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-122><vspace|0.5fn>

    7.1.<space|2spc>Introduction <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-123>

    7.2.<space|2spc>Preliminaries <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-124>

    <with|par-left|1tab|7.2.1.<space|2spc>Extra Validation Data
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-125>>

    7.3.<space|2spc>Overal process <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-126>

    7.4.<space|2spc>Candidate Selection <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-128>

    7.5.<space|2spc>Candidate Backing <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-129>

    <with|par-left|1tab|7.5.1.<space|2spc>Inclusion of candidate receipt on
    the relay chain <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-130>>

    7.6.<space|2spc>PoV Distribution <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-131>

    <with|par-left|1tab|7.6.1.<space|2spc>Primary Validation Disagreement
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-132>>

    7.7.<space|2spc>Availability <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-133>

    7.8.<space|2spc>Distribution of Chunks
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-134>

    7.9.<space|2spc>Announcing Availability
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-135>

    <with|par-left|1tab|7.9.1.<space|2spc>Processing on-chain availability
    data <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-136>>

    7.10.<space|2spc>Publishing Attestations
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-137>

    7.11.<space|2spc>Secondary Approval checking
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-138>

    <with|par-left|1tab|7.11.1.<space|2spc>Approval Checker Assignment
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-139>>

    <with|par-left|1tab|7.11.2.<space|2spc>VRF computation
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-140>>

    <with|par-left|1tab|7.11.3.<space|2spc>One-Shot Approval Checker
    Assignment <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-141>>

    <with|par-left|1tab|7.11.4.<space|2spc>Extra Approval Checker Assigment
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-142>>

    <with|par-left|1tab|7.11.5.<space|2spc>Additional Checking in Case of
    Equivocation <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-143>>

    7.12.<space|2spc>The Approval Check <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-144>

    <with|par-left|2tab|7.12.0.1.<space|2spc>Retrieval
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-145>>

    <with|par-left|2tab|7.12.0.2.<space|2spc>Reconstruction
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-146>>

    <with|par-left|1tab|7.12.1.<space|2spc>Verification
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-147>>

    <with|par-left|1tab|7.12.2.<space|2spc>Process validity and invalidity
    messages <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-148>>

    <with|par-left|1tab|7.12.3.<space|2spc>Invalidity Escalation
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-149>>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|8.<space|2spc>Message
    Passing> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-150><vspace|0.5fn>

    8.1.<space|2spc>Overview <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-151>

    8.2.<space|2spc>Message Queue Chain (MQC)
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-153>

    8.3.<space|2spc>HRMP <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-155>

    <with|par-left|1tab|8.3.1.<space|2spc>Channels
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-156>>

    <with|par-left|1tab|8.3.2.<space|2spc>Opening Channels
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-157>>

    <with|par-left|2tab|8.3.2.1.<space|2spc>Workflow
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-158>>

    <with|par-left|1tab|8.3.3.<space|2spc>Accepting Channels
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-159>>

    <with|par-left|2tab|8.3.3.1.<space|2spc>Workflow
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-160>>

    <with|par-left|1tab|8.3.4.<space|2spc>Closing Channels
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-161>>

    <with|par-left|1tab|8.3.5.<space|2spc>Workflow
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-162>>

    <with|par-left|1tab|8.3.6.<space|2spc>Sending messages
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-163>>

    <with|par-left|1tab|8.3.7.<space|2spc>Receiving Messages
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-164>>

    8.4.<space|2spc>XCMP <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-165>

    <with|par-left|1tab|8.4.1.<space|2spc>CST: Channel State Table
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-167>>

    <with|par-left|1tab|8.4.2.<space|2spc>Message content
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-168>>

    <with|par-left|1tab|8.4.3.<space|2spc>Watermark
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-169>>

    8.5.<space|2spc>SPREE <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-170>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|Appendix
    A.<space|2spc>Cryptographic Algorithms>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-171><vspace|0.5fn>

    A.1.<space|2spc>Hash Functions <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-172>

    A.2.<space|2spc>BLAKE2 <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-173>

    A.3.<space|2spc>Randomness <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-174>

    A.4.<space|2spc>VRF <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-175>

    A.5.<space|2spc>Cryptographic Keys <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-176>

    <with|par-left|1tab|A.5.1.<space|2spc>Holding and staking funds
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-179>>

    <with|par-left|1tab|A.5.2.<space|2spc>Creating a Controller key
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-180>>

    <with|par-left|1tab|A.5.3.<space|2spc>Designating a proxy for voting
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-181>>

    <with|par-left|1tab|A.5.4.<space|2spc>Controller settings
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-182>>

    <with|par-left|1tab|A.5.5.<space|2spc>Certifying keys
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-183>>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|Appendix
    B.<space|2spc>Auxiliary Encodings> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-184><vspace|0.5fn>

    B.1.<space|2spc>SCALE Codec <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-185>

    <with|par-left|1tab|B.1.1.<space|2spc>Length and Compact Encoding
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-186>>

    B.2.<space|2spc>Hex Encoding <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-187>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|Appendix
    C.<space|2spc>Genesis State Specification>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-188><vspace|0.5fn>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|Glossary>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-190><vspace|0.5fn>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|Bibliography>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-191><vspace|0.5fn>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|font-shape|small-caps|Index>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <pageref|auto-192><vspace|0.5fn>
  </table-of-contents>

  \;

  <include|c01-background.tm>

  <include|c02-state.tm>

  <include|c03-transition.tm>

  <include|c04-networking.tm>

  <include|c05-bootstrapping.tm>

  <include|c06-consensus.tm>

  <include|c07-anv.tm>

  <include|c08-messaging.tm>

  \;

  <include|aa-cryptoalgorithms.tm>

  <include|ab-encodings.tm>

  <include|ac-genesis.tm>

  <include|ad-hostapi.tm>

  <include|ae-runtimeapi.tm>

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
    <\bib-list|7>
      <bibitem*|Bur19><label|bib-burdges_schnorr_2019>Jeff Burdges.
      <newblock>Schnorr VRFs and signatures on the Ristretto group.
      <newblock><localize|Technical Report>, 2019.<newblock>

      <bibitem*|DGKR18><label|bib-david_ouroboros_2018>Bernardo David, Peter
      Gaºi, Aggelos Kiayias<localize|, and >Alexander Russell.
      <newblock>Ouroboros praos: An adaptively-secure, semi-synchronous
      proof-of-stake blockchain. <newblock><localize|In
      ><with|font-shape|italic|Annual International Conference on the Theory
      and Applications of Cryptographic Techniques>, <localize|pages >66\U98.
      Springer, 2018.<newblock>

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

      <bibitem*|SA15><label|bib-saarinen_blake2_2015>Markku<nbsp>Juhani
      Saarinen<localize| and >Jean-Philippe Aumasson. <newblock>The BLAKE2
      cryptographic hash and message authentication code (MAC).
      <newblock><keepcase|RFC> 7693, -, <slink|https://tools.ietf.org/html/rfc7693>,
      2015.<newblock>

      <bibitem*|Ste19><label|bib-stewart_grandpa:_2019>Alistair Stewart.
      <newblock>GRANDPA: A Byzantine Finality Gadget.
      <newblock>2019.<newblock>

      <bibitem*|Tec20><label|bib-paritytech_genesis_state>Parity Tech.
      <newblock>Polkadot Genisis State. <newblock><localize|Technical
      Report>, <slink|https://github.com/paritytech/polkadot/tree/master/node/service/res/>,
      2020.<newblock>
    </bib-list>
  </bibliography>

  <\the-index|idx>
    <index+1|Transaction Message|<pageref|auto-51>>

    <index+1|transaction pool|<pageref|auto-52>>

    <index+1|transaction queue|<pageref|auto-53>>
  </the-index>
</body>

<\initial>
  <\collection>
    <associate|page-medium|paper>
    <associate|preamble|false>
  </collection>
</initial>

<\references>
  <\collection>
    <associate||<tuple|7.12.0.2|70|c07-anv.tm>>
    <associate|algo-aggregate-key|<tuple|2.1|15|c02-state.tm>>
    <associate|algo-attempt-to\Ufinalize|<tuple|6.15|53|c06-consensus.tm>>
    <associate|algo-block-production|<tuple|6.4|45|c06-consensus.tm>>
    <associate|algo-block-production-lottery|<tuple|6.1|42|c06-consensus.tm>>
    <associate|algo-build-block|<tuple|6.7|46|c06-consensus.tm>>
    <associate|algo-checker-vrf|<tuple|7.10|68|c07-anv.tm>>
    <associate|algo-derive-primary|<tuple|6.10|52|c06-consensus.tm>>
    <associate|algo-endorse-candidate-receipt|<tuple|7.4|63|c07-anv.tm>>
    <associate|algo-equivocation-assigment|<tuple|7.13|69|c07-anv.tm>>
    <associate|algo-erasure-encode|<tuple|7.7|65|c07-anv.tm>>
    <associate|algo-extra-assignment|<tuple|7.12|69|c07-anv.tm>>
    <associate|algo-finalizable|<tuple|6.14|53|c06-consensus.tm>>
    <associate|algo-grandpa-best-candidate|<tuple|6.11|52|c06-consensus.tm>>
    <associate|algo-grandpa-ghost|<tuple|6.12|53|c06-consensus.tm>>
    <associate|algo-grandpa-round|<tuple|6.9|52|c06-consensus.tm>>
    <associate|algo-import-and-validate-block|<tuple|3.4|25|c03-transition.tm>>
    <associate|algo-include-parachain-proposal|<tuple|7.5|64|c07-anv.tm>>
    <associate|algo-initiate-grandpa|<tuple|6.8|51|c06-consensus.tm>>
    <associate|algo-maintain-transaction-pool|<tuple|3.3|23|c03-transition.tm>>
    <associate|algo-make-shards|<tuple|7.8|65|c07-anv.tm>>
    <associate|algo-one-shot-assignment|<tuple|7.11|69|c07-anv.tm>>
    <associate|algo-pk-length|<tuple|2.2|15|c02-state.tm>>
    <associate|algo-primary-validation|<tuple|7.1|61|c07-anv.tm>>
    <associate|algo-primary-validation-announcement|<tuple|7.3|63|c07-anv.tm>>
    <associate|algo-primary-validation-disagreemnt|<tuple|7.6|64|c07-anv.tm>>
    <associate|algo-process-catchup-request|<tuple|6.16|55|c06-consensus.tm>>
    <associate|algo-process-catchup-response|<tuple|6.17|55|c06-consensus.tm>>
    <associate|algo-reconstruct-pov|<tuple|7.14|70|c07-anv.tm>>
    <associate|algo-revalidating-reconstructed-pov|<tuple|7.15|70|c07-anv.tm>>
    <associate|algo-runtime-interaction|<tuple|3.1|19|c03-transition.tm>>
    <associate|algo-signature-processing|<tuple|7.9|67|c07-anv.tm>>
    <associate|algo-slot-time|<tuple|6.3|44|c06-consensus.tm>>
    <associate|algo-validate-block|<tuple|7.2|61|c07-anv.tm>>
    <associate|algo-validate-transactions|<tuple|3.2|22|c03-transition.tm>>
    <associate|algo-verify-approval-attestation|<tuple|7.16|71|c07-anv.tm>>
    <associate|algo-verify-authorship-right|<tuple|6.5|46|c06-consensus.tm>>
    <associate|algo-verify-slot-winner|<tuple|6.6|46|c06-consensus.tm>>
    <associate|appendix-e|<tuple|D|89|ae-hostapi.tm>>
    <associate|auto-1|<tuple|1|9|c01-background.tm>>
    <associate|auto-10|<tuple|Block|10|c01-background.tm>>
    <associate|auto-100|<tuple|6.2.3|43|c06-consensus.tm>>
    <associate|auto-101|<tuple|6.1|44|c06-consensus.tm>>
    <associate|auto-102|<tuple|6.2.4|44|c06-consensus.tm>>
    <associate|auto-103|<tuple|6.2.5|45|c06-consensus.tm>>
    <associate|auto-104|<tuple|6.2.6|45|c06-consensus.tm>>
    <associate|auto-105|<tuple|6.2.7|46|c06-consensus.tm>>
    <associate|auto-106|<tuple|6.3|47|c06-consensus.tm>>
    <associate|auto-107|<tuple|6.3.1|47|c06-consensus.tm>>
    <associate|auto-108|<tuple|6.3.2|49|c06-consensus.tm>>
    <associate|auto-109|<tuple|6.3|49|c06-consensus.tm>>
    <associate|auto-11|<tuple|Genesis Block|10|c01-background.tm>>
    <associate|auto-110|<tuple|6.3.2.1|49|c06-consensus.tm>>
    <associate|auto-111|<tuple|6.4|49|c06-consensus.tm>>
    <associate|auto-112|<tuple|6.3.2.2|50|c06-consensus.tm>>
    <associate|auto-113|<tuple|6.3.2.3|50|c06-consensus.tm>>
    <associate|auto-114|<tuple|6.3.3|51|c06-consensus.tm>>
    <associate|auto-115|<tuple|6.3.3.1|51|c06-consensus.tm>>
    <associate|auto-116|<tuple|6.3.4|52|c06-consensus.tm>>
    <associate|auto-117|<tuple|6.4|54|c06-consensus.tm>>
    <associate|auto-118|<tuple|6.4.1|55|c06-consensus.tm>>
    <associate|auto-119|<tuple|6.4.1.1|55|c06-consensus.tm>>
    <associate|auto-12|<tuple|Head|10|c01-background.tm>>
    <associate|auto-120|<tuple|6.4.1.2|55|c06-consensus.tm>>
    <associate|auto-121|<tuple|6.4.1.3|55|c06-consensus.tm>>
    <associate|auto-122|<tuple|7|57|c07-anv.tm>>
    <associate|auto-123|<tuple|7.1|57|c07-anv.tm>>
    <associate|auto-124|<tuple|7.2|57|c07-anv.tm>>
    <associate|auto-125|<tuple|7.2.1|58|c07-anv.tm>>
    <associate|auto-126|<tuple|7.3|59|c07-anv.tm>>
    <associate|auto-127|<tuple|7.1|60|c07-anv.tm>>
    <associate|auto-128|<tuple|7.4|61|c07-anv.tm>>
    <associate|auto-129|<tuple|7.5|61|c07-anv.tm>>
    <associate|auto-13|<tuple|P|10|c01-background.tm>>
    <associate|auto-130|<tuple|7.5.1|64|c07-anv.tm>>
    <associate|auto-131|<tuple|7.6|64|c07-anv.tm>>
    <associate|auto-132|<tuple|7.6.1|64|c07-anv.tm>>
    <associate|auto-133|<tuple|7.7|65|c07-anv.tm>>
    <associate|auto-134|<tuple|7.8|66|c07-anv.tm>>
    <associate|auto-135|<tuple|7.9|66|c07-anv.tm>>
    <associate|auto-136|<tuple|7.9.1|67|c07-anv.tm>>
    <associate|auto-137|<tuple|7.10|68|c07-anv.tm>>
    <associate|auto-138|<tuple|7.11|68|c07-anv.tm>>
    <associate|auto-139|<tuple|7.11.1|68|c07-anv.tm>>
    <associate|auto-14|<tuple|1.2.1|11|c01-background.tm>>
    <associate|auto-140|<tuple|7.11.2|68|c07-anv.tm>>
    <associate|auto-141|<tuple|7.11.3|68|c07-anv.tm>>
    <associate|auto-142|<tuple|7.11.4|69|c07-anv.tm>>
    <associate|auto-143|<tuple|7.11.5|69|c07-anv.tm>>
    <associate|auto-144|<tuple|7.12|69|c07-anv.tm>>
    <associate|auto-145|<tuple|7.12.0.1|70|c07-anv.tm>>
    <associate|auto-146|<tuple|7.12.0.2|70|c07-anv.tm>>
    <associate|auto-147|<tuple|7.12.1|70|c07-anv.tm>>
    <associate|auto-148|<tuple|7.12.2|71|c07-anv.tm>>
    <associate|auto-149|<tuple|7.12.3|71|c07-anv.tm>>
    <associate|auto-15|<tuple|BT, block tree|11|c01-background.tm>>
    <associate|auto-150|<tuple|8|73|c08-messaging.tm>>
    <associate|auto-151|<tuple|8.1|73|c08-messaging.tm>>
    <associate|auto-152|<tuple|8.1|73|c08-messaging.tm>>
    <associate|auto-153|<tuple|8.2|74|c08-messaging.tm>>
    <associate|auto-154|<tuple|8.2|74|c08-messaging.tm>>
    <associate|auto-155|<tuple|8.3|74|c08-messaging.tm>>
    <associate|auto-156|<tuple|8.3.1|74|c08-messaging.tm>>
    <associate|auto-157|<tuple|8.3.2|75|c08-messaging.tm>>
    <associate|auto-158|<tuple|8.3.2.1|75|c08-messaging.tm>>
    <associate|auto-159|<tuple|8.3.3|76|c08-messaging.tm>>
    <associate|auto-16|<tuple|PBT, Pruned BT|11|c01-background.tm>>
    <associate|auto-160|<tuple|8.3.3.1|76|c08-messaging.tm>>
    <associate|auto-161|<tuple|8.3.4|76|c08-messaging.tm>>
    <associate|auto-162|<tuple|8.3.5|76|c08-messaging.tm>>
    <associate|auto-163|<tuple|8.3.6|77|c08-messaging.tm>>
    <associate|auto-164|<tuple|8.3.7|78|c08-messaging.tm>>
    <associate|auto-165|<tuple|8.4|78|c08-messaging.tm>>
    <associate|auto-166|<tuple|8.3|78|c08-messaging.tm>>
    <associate|auto-167|<tuple|8.4.1|79|c08-messaging.tm>>
    <associate|auto-168|<tuple|8.4.2|79|c08-messaging.tm>>
    <associate|auto-169|<tuple|8.4.3|79|c08-messaging.tm>>
    <associate|auto-17|<tuple|pruning|11|c01-background.tm>>
    <associate|auto-170|<tuple|8.5|80|c08-messaging.tm>>
    <associate|auto-171|<tuple|A|81|aa-cryptoalgorithms.tm>>
    <associate|auto-172|<tuple|A.1|81|aa-cryptoalgorithms.tm>>
    <associate|auto-173|<tuple|A.2|81|aa-cryptoalgorithms.tm>>
    <associate|auto-174|<tuple|A.3|81|aa-cryptoalgorithms.tm>>
    <associate|auto-175|<tuple|A.4|81|aa-cryptoalgorithms.tm>>
    <associate|auto-176|<tuple|A.5|81|aa-cryptoalgorithms.tm>>
    <associate|auto-177|<tuple|A.1|81|aa-cryptoalgorithms.tm>>
    <associate|auto-178|<tuple|A.2|82|aa-cryptoalgorithms.tm>>
    <associate|auto-179|<tuple|A.5.1|82|aa-cryptoalgorithms.tm>>
    <associate|auto-18|<tuple|G|11|c01-background.tm>>
    <associate|auto-180|<tuple|A.5.2|82|aa-cryptoalgorithms.tm>>
    <associate|auto-181|<tuple|A.5.3|82|aa-cryptoalgorithms.tm>>
    <associate|auto-182|<tuple|A.5.4|82|aa-cryptoalgorithms.tm>>
    <associate|auto-183|<tuple|A.5.5|82|aa-cryptoalgorithms.tm>>
    <associate|auto-184|<tuple|B|83|ab-encodings.tm>>
    <associate|auto-185|<tuple|B.1|83|ab-encodings.tm>>
    <associate|auto-186|<tuple|B.1.1|84|ab-encodings.tm>>
    <associate|auto-187|<tuple|B.2|85|ab-encodings.tm>>
    <associate|auto-188|<tuple|C|87|ac-genesis.tm>>
    <associate|auto-189|<tuple|C.1|87|ac-genesis.tm>>
    <associate|auto-19|<tuple|CHAIN(B)|11|c01-background.tm>>
    <associate|auto-190|<tuple|C.1|89>>
    <associate|auto-191|<tuple|C.1|91>>
    <associate|auto-192|<tuple|Tec20|93>>
    <associate|auto-193|<tuple|D.1.2|89|ae-hostapi.tm>>
    <associate|auto-194|<tuple|D.1.2.1|89|ae-hostapi.tm>>
    <associate|auto-195|<tuple|D.1.3|90|ae-hostapi.tm>>
    <associate|auto-196|<tuple|D.1.3.1|90|ae-hostapi.tm>>
    <associate|auto-197|<tuple|D.1.4|90|ae-hostapi.tm>>
    <associate|auto-198|<tuple|D.1.4.1|90|ae-hostapi.tm>>
    <associate|auto-199|<tuple|D.1.5|90|ae-hostapi.tm>>
    <associate|auto-2|<tuple|1.1|9|c01-background.tm>>
    <associate|auto-20|<tuple|head of C|11|c01-background.tm>>
    <associate|auto-200|<tuple|D.1.5.1|90|ae-hostapi.tm>>
    <associate|auto-201|<tuple|D.1.6|90|ae-hostapi.tm>>
    <associate|auto-202|<tuple|D.1.6.1|90|ae-hostapi.tm>>
    <associate|auto-203|<tuple|D.1.7|91|ae-hostapi.tm>>
    <associate|auto-204|<tuple|D.1.7.1|91|ae-hostapi.tm>>
    <associate|auto-205|<tuple|D.1.8|91|ae-hostapi.tm>>
    <associate|auto-206|<tuple|D.1.8.1|91|ae-hostapi.tm>>
    <associate|auto-207|<tuple|D.1.9|91|ae-hostapi.tm>>
    <associate|auto-208|<tuple|D.1.9.1|91|ae-hostapi.tm>>
    <associate|auto-209|<tuple|D.1.10|91|ae-hostapi.tm>>
    <associate|auto-21|<tuple|<with|mode|<quote|math>|<around*|\||C|\|>>|11|c01-background.tm>>
    <associate|auto-210|<tuple|D.1.10.1|91|ae-hostapi.tm>>
    <associate|auto-211|<tuple|D.1.11|92|ae-hostapi.tm>>
    <associate|auto-212|<tuple|D.1.11.1|92|ae-hostapi.tm>>
    <associate|auto-213|<tuple|D.1.12|92|ae-hostapi.tm>>
    <associate|auto-214|<tuple|D.1.12.1|92|ae-hostapi.tm>>
    <associate|auto-215|<tuple|D.1.13|92|ae-hostapi.tm>>
    <associate|auto-216|<tuple|D.1.13.1|92|ae-hostapi.tm>>
    <associate|auto-217|<tuple|D.2|92|ae-hostapi.tm>>
    <associate|auto-218|<tuple|D.2.1|93|ae-hostapi.tm>>
    <associate|auto-219|<tuple|D.2.1.1|93|ae-hostapi.tm>>
    <associate|auto-22|<tuple|SubChain(<with|mode|<quote|math>|B<rprime|'>,B>)|11|c01-background.tm>>
    <associate|auto-220|<tuple|D.2.2|93|ae-hostapi.tm>>
    <associate|auto-221|<tuple|D.2.2.1|93|ae-hostapi.tm>>
    <associate|auto-222|<tuple|D.2.3|93|ae-hostapi.tm>>
    <associate|auto-223|<tuple|D.2.3.1|93|ae-hostapi.tm>>
    <associate|auto-224|<tuple|D.2.4|93|ae-hostapi.tm>>
    <associate|auto-225|<tuple|D.2.4.1|94|ae-hostapi.tm>>
    <associate|auto-226|<tuple|D.2.5|94|ae-hostapi.tm>>
    <associate|auto-227|<tuple|D.2.5.1|94|ae-hostapi.tm>>
    <associate|auto-228|<tuple|D.2.6|94|ae-hostapi.tm>>
    <associate|auto-229|<tuple|D.2.6.1|94|ae-hostapi.tm>>
    <associate|auto-23|<tuple|<with|mode|<quote|math>|\<bbb-C\><rsub|B<rprime|'>><around*|(|<around*|(|P|)>BT|)>>|11|c01-background.tm>>
    <associate|auto-230|<tuple|D.2.7|94|ae-hostapi.tm>>
    <associate|auto-231|<tuple|D.2.7.1|94|ae-hostapi.tm>>
    <associate|auto-232|<tuple|D.2.8|94|ae-hostapi.tm>>
    <associate|auto-233|<tuple|D.2.8.1|94|ae-hostapi.tm>>
    <associate|auto-234|<tuple|D.2.9|95|ae-hostapi.tm>>
    <associate|auto-235|<tuple|D.2.9.1|95|ae-hostapi.tm>>
    <associate|auto-236|<tuple|D.3|95|ae-hostapi.tm>>
    <associate|auto-237|<tuple|D.1|95|ae-hostapi.tm>>
    <associate|auto-238|<tuple|D.2|95|ae-hostapi.tm>>
    <associate|auto-239|<tuple|D.3.1|95|ae-hostapi.tm>>
    <associate|auto-24|<tuple|<with|mode|<quote|math>|\<bbb-C\>>|11|c01-background.tm>>
    <associate|auto-240|<tuple|D.3.1.1|96|ae-hostapi.tm>>
    <associate|auto-241|<tuple|D.3.2|96|ae-hostapi.tm>>
    <associate|auto-242|<tuple|D.3.2.1|96|ae-hostapi.tm>>
    <associate|auto-243|<tuple|D.3.3|96|ae-hostapi.tm>>
    <associate|auto-244|<tuple|D.3.3.1|96|ae-hostapi.tm>>
    <associate|auto-245|<tuple|D.3.4|96|ae-hostapi.tm>>
    <associate|auto-246|<tuple|D.3.4.1|97|ae-hostapi.tm>>
    <associate|auto-247|<tuple|D.3.5|97|ae-hostapi.tm>>
    <associate|auto-248|<tuple|D.3.5.1|97|ae-hostapi.tm>>
    <associate|auto-249|<tuple|D.3.6|97|ae-hostapi.tm>>
    <associate|auto-25|<tuple|LONGEST-CHAIN(BT)|11|c01-background.tm>>
    <associate|auto-250|<tuple|D.3.6.1|97|ae-hostapi.tm>>
    <associate|auto-251|<tuple|D.3.7|97|ae-hostapi.tm>>
    <associate|auto-252|<tuple|D.3.7.1|97|ae-hostapi.tm>>
    <associate|auto-253|<tuple|D.3.8|98|ae-hostapi.tm>>
    <associate|auto-254|<tuple|D.3.8.1|98|ae-hostapi.tm>>
    <associate|auto-255|<tuple|D.3.8.2|98|ae-hostapi.tm>>
    <associate|auto-256|<tuple|D.3.9|98|ae-hostapi.tm>>
    <associate|auto-257|<tuple|D.3.9.1|98|ae-hostapi.tm>>
    <associate|auto-258|<tuple|D.3.10|99|ae-hostapi.tm>>
    <associate|auto-259|<tuple|D.3.10.1|99|ae-hostapi.tm>>
    <associate|auto-26|<tuple|LONGEST-PATH(BT)|11|c01-background.tm>>
    <associate|auto-260|<tuple|D.3.11|99|ae-hostapi.tm>>
    <associate|auto-261|<tuple|D.3.11.1|99|ae-hostapi.tm>>
    <associate|auto-262|<tuple|D.3.12|99|ae-hostapi.tm>>
    <associate|auto-263|<tuple|D.3.12.1|99|ae-hostapi.tm>>
    <associate|auto-264|<tuple|D.3.13|100|ae-hostapi.tm>>
    <associate|auto-265|<tuple|D.3.13.1|100|ae-hostapi.tm>>
    <associate|auto-266|<tuple|D.3.14|100|ae-hostapi.tm>>
    <associate|auto-267|<tuple|D.3.14.1|100|ae-hostapi.tm>>
    <associate|auto-268|<tuple|D.3.15|100|ae-hostapi.tm>>
    <associate|auto-269|<tuple|D.3.15.1|100|ae-hostapi.tm>>
    <associate|auto-27|<tuple|DEEPEST-LEAF(BT)|11|c01-background.tm>>
    <associate|auto-270|<tuple|D.3.16|101|ae-hostapi.tm>>
    <associate|auto-271|<tuple|D.3.16.1|101|ae-hostapi.tm>>
    <associate|auto-272|<tuple|D.4|101|ae-hostapi.tm>>
    <associate|auto-273|<tuple|D.4.1|101|ae-hostapi.tm>>
    <associate|auto-274|<tuple|D.4.1.1|101|ae-hostapi.tm>>
    <associate|auto-275|<tuple|D.4.2|101|ae-hostapi.tm>>
    <associate|auto-276|<tuple|D.4.2.1|101|ae-hostapi.tm>>
    <associate|auto-277|<tuple|D.4.3|101|ae-hostapi.tm>>
    <associate|auto-278|<tuple|D.4.3.1|101|ae-hostapi.tm>>
    <associate|auto-279|<tuple|D.4.4|102|ae-hostapi.tm>>
    <associate|auto-28|<tuple|2|13|c02-state.tm>>
    <associate|auto-280|<tuple|D.4.4.1|102|ae-hostapi.tm>>
    <associate|auto-281|<tuple|D.4.5|102|ae-hostapi.tm>>
    <associate|auto-282|<tuple|D.4.5.1|102|ae-hostapi.tm>>
    <associate|auto-283|<tuple|D.4.6|102|ae-hostapi.tm>>
    <associate|auto-284|<tuple|D.4.6.1|102|ae-hostapi.tm>>
    <associate|auto-285|<tuple|D.4.7|102|ae-hostapi.tm>>
    <associate|auto-286|<tuple|D.4.7.1|102|ae-hostapi.tm>>
    <associate|auto-287|<tuple|D.4.8|102|ae-hostapi.tm>>
    <associate|auto-288|<tuple|D.4.8.1|103|ae-hostapi.tm>>
    <associate|auto-289|<tuple|D.5|103|ae-hostapi.tm>>
    <associate|auto-29|<tuple|2.1|13|c02-state.tm>>
    <associate|auto-290|<tuple|D.3|103|ae-hostapi.tm>>
    <associate|auto-291|<tuple|D.5.1|103|ae-hostapi.tm>>
    <associate|auto-292|<tuple|D.5.1.1|104|ae-hostapi.tm>>
    <associate|auto-293|<tuple|D.5.2|104|ae-hostapi.tm>>
    <associate|auto-294|<tuple|D.5.2.1|104|ae-hostapi.tm>>
    <associate|auto-295|<tuple|D.5.3|104|ae-hostapi.tm>>
    <associate|auto-296|<tuple|D.5.3.1|104|ae-hostapi.tm>>
    <associate|auto-297|<tuple|D.5.4|104|ae-hostapi.tm>>
    <associate|auto-298|<tuple|D.5.4.1|104|ae-hostapi.tm>>
    <associate|auto-299|<tuple|D.5.5|105|ae-hostapi.tm>>
    <associate|auto-3|<tuple|1.2|9|c01-background.tm>>
    <associate|auto-30|<tuple|2.1.1|13|c02-state.tm>>
    <associate|auto-300|<tuple|D.5.5.1|105|ae-hostapi.tm>>
    <associate|auto-301|<tuple|D.5.6|105|ae-hostapi.tm>>
    <associate|auto-302|<tuple|D.5.6.1|105|ae-hostapi.tm>>
    <associate|auto-303|<tuple|D.5.7|105|ae-hostapi.tm>>
    <associate|auto-304|<tuple|D.5.7.1|105|ae-hostapi.tm>>
    <associate|auto-305|<tuple|D.5.8|105|ae-hostapi.tm>>
    <associate|auto-306|<tuple|D.5.8.1|105|ae-hostapi.tm>>
    <associate|auto-307|<tuple|D.5.9|106|ae-hostapi.tm>>
    <associate|auto-308|<tuple|D.5.9.1|106|ae-hostapi.tm>>
    <associate|auto-309|<tuple|D.5.10|106|ae-hostapi.tm>>
    <associate|auto-31|<tuple|StoredValue|13|c02-state.tm>>
    <associate|auto-310|<tuple|D.5.10.1|106|ae-hostapi.tm>>
    <associate|auto-311|<tuple|D.5.11|106|ae-hostapi.tm>>
    <associate|auto-312|<tuple|D.5.11.1|106|ae-hostapi.tm>>
    <associate|auto-313|<tuple|D.5.12|107|ae-hostapi.tm>>
    <associate|auto-314|<tuple|D.5.12.1|107|ae-hostapi.tm>>
    <associate|auto-315|<tuple|D.5.13|107|ae-hostapi.tm>>
    <associate|auto-316|<tuple|D.5.13.1|107|ae-hostapi.tm>>
    <associate|auto-317|<tuple|D.5.14|107|ae-hostapi.tm>>
    <associate|auto-318|<tuple|D.5.14.1|107|ae-hostapi.tm>>
    <associate|auto-319|<tuple|D.5.15|108|ae-hostapi.tm>>
    <associate|auto-32|<tuple|2.1.2|13|c02-state.tm>>
    <associate|auto-320|<tuple|D.5.15.1|108|ae-hostapi.tm>>
    <associate|auto-321|<tuple|D.5.16|108|ae-hostapi.tm>>
    <associate|auto-322|<tuple|D.5.16.1|108|ae-hostapi.tm>>
    <associate|auto-323|<tuple|D.5.17|108|ae-hostapi.tm>>
    <associate|auto-324|<tuple|D.5.17.1|109|ae-hostapi.tm>>
    <associate|auto-325|<tuple|D.6|109|ae-hostapi.tm>>
    <associate|auto-326|<tuple|D.6.1|109|ae-hostapi.tm>>
    <associate|auto-327|<tuple|D.6.1.1|109|ae-hostapi.tm>>
    <associate|auto-328|<tuple|D.6.2|109|ae-hostapi.tm>>
    <associate|auto-329|<tuple|D.6.2.1|109|ae-hostapi.tm>>
    <associate|auto-33|<tuple|2.1.3|14|c02-state.tm>>
    <associate|auto-330|<tuple|D.6.3|109|ae-hostapi.tm>>
    <associate|auto-331|<tuple|D.6.3.1|109|ae-hostapi.tm>>
    <associate|auto-332|<tuple|D.6.4|110|ae-hostapi.tm>>
    <associate|auto-333|<tuple|D.6.4.1|110|ae-hostapi.tm>>
    <associate|auto-334|<tuple|D.7|110|ae-hostapi.tm>>
    <associate|auto-335|<tuple|D.7.1|110|ae-hostapi.tm>>
    <associate|auto-336|<tuple|D.7.1.1|110|ae-hostapi.tm>>
    <associate|auto-337|<tuple|D.7.2|110|ae-hostapi.tm>>
    <associate|auto-338|<tuple|D.7.2.1|110|ae-hostapi.tm>>
    <associate|auto-339|<tuple|D.7.3|110|ae-hostapi.tm>>
    <associate|auto-34|<tuple|2.1.4|16|c02-state.tm>>
    <associate|auto-340|<tuple|D.7.3.1|110|ae-hostapi.tm>>
    <associate|auto-341|<tuple|D.7.4|111|ae-hostapi.tm>>
    <associate|auto-342|<tuple|D.7.4.1|111|ae-hostapi.tm>>
    <associate|auto-343|<tuple|D.7.5|111|ae-hostapi.tm>>
    <associate|auto-344|<tuple|D.7.5.1|111|ae-hostapi.tm>>
    <associate|auto-345|<tuple|D.8|111|ae-hostapi.tm>>
    <associate|auto-346|<tuple|D.8.1|111|ae-hostapi.tm>>
    <associate|auto-347|<tuple|D.8.1.1|111|ae-hostapi.tm>>
    <associate|auto-348|<tuple|D.8.2|111|ae-hostapi.tm>>
    <associate|auto-349|<tuple|D.8.2.1|111|ae-hostapi.tm>>
    <associate|auto-35|<tuple|2.2|17|c02-state.tm>>
    <associate|auto-350|<tuple|D.9|112|ae-hostapi.tm>>
    <associate|auto-351|<tuple|D.4|112|ae-hostapi.tm>>
    <associate|auto-352|<tuple|D.9.1|112|ae-hostapi.tm>>
    <associate|auto-353|<tuple|D.9.1.1|112|ae-hostapi.tm>>
    <associate|auto-354|<tuple|E|113|af-legacyhostapi.tm>>
    <associate|auto-355|<tuple|E.1|113|af-legacyhostapi.tm>>
    <associate|auto-356|<tuple|E.1.1|113|af-legacyhostapi.tm>>
    <associate|auto-357|<tuple|E.1.2|113|af-legacyhostapi.tm>>
    <associate|auto-358|<tuple|E.1.3|113|af-legacyhostapi.tm>>
    <associate|auto-359|<tuple|E.1.4|114|af-legacyhostapi.tm>>
    <associate|auto-36|<tuple|2.2.1|17|c02-state.tm>>
    <associate|auto-360|<tuple|E.1.5|114|af-legacyhostapi.tm>>
    <associate|auto-361|<tuple|E.1.6|114|af-legacyhostapi.tm>>
    <associate|auto-362|<tuple|E.1.7|115|af-legacyhostapi.tm>>
    <associate|auto-363|<tuple|E.1.8|115|af-legacyhostapi.tm>>
    <associate|auto-364|<tuple|E.1.9|115|af-legacyhostapi.tm>>
    <associate|auto-365|<tuple|E.1.10|116|af-legacyhostapi.tm>>
    <associate|auto-366|<tuple|E.1.11|116|af-legacyhostapi.tm>>
    <associate|auto-367|<tuple|E.1.12|117|af-legacyhostapi.tm>>
    <associate|auto-368|<tuple|E.1.13|117|af-legacyhostapi.tm>>
    <associate|auto-369|<tuple|E.1.14|118|af-legacyhostapi.tm>>
    <associate|auto-37|<tuple|3|19|c03-transition.tm>>
    <associate|auto-370|<tuple|E.1.15|118|af-legacyhostapi.tm>>
    <associate|auto-371|<tuple|E.1.15.1|118|af-legacyhostapi.tm>>
    <associate|auto-372|<tuple|E.1.15.2|118|af-legacyhostapi.tm>>
    <associate|auto-373|<tuple|E.1.15.3|118|af-legacyhostapi.tm>>
    <associate|auto-374|<tuple|E.1.16|118|af-legacyhostapi.tm>>
    <associate|auto-375|<tuple|E.1.16.1|118|af-legacyhostapi.tm>>
    <associate|auto-376|<tuple|E.1.16.2|119|af-legacyhostapi.tm>>
    <associate|auto-377|<tuple|E.1.16.3|119|af-legacyhostapi.tm>>
    <associate|auto-378|<tuple|E.1.16.4|119|af-legacyhostapi.tm>>
    <associate|auto-379|<tuple|E.1.16.5|120|af-legacyhostapi.tm>>
    <associate|auto-38|<tuple|3.1|19|c03-transition.tm>>
    <associate|auto-380|<tuple|E.1.16.6|120|af-legacyhostapi.tm>>
    <associate|auto-381|<tuple|E.1.17|120|af-legacyhostapi.tm>>
    <associate|auto-382|<tuple|E.1.17.1|121|af-legacyhostapi.tm>>
    <associate|auto-383|<tuple|E.1.17.2|121|af-legacyhostapi.tm>>
    <associate|auto-384|<tuple|E.1.17.3|121|af-legacyhostapi.tm>>
    <associate|auto-385|<tuple|E.1.17.4|122|af-legacyhostapi.tm>>
    <associate|auto-386|<tuple|E.1.17.5|122|af-legacyhostapi.tm>>
    <associate|auto-387|<tuple|E.1.17.6|122|af-legacyhostapi.tm>>
    <associate|auto-388|<tuple|E.1.17.7|122|af-legacyhostapi.tm>>
    <associate|auto-389|<tuple|E.1.17.8|123|af-legacyhostapi.tm>>
    <associate|auto-39|<tuple|3.1.1|19|c03-transition.tm>>
    <associate|auto-390|<tuple|E.1.17.9|123|af-legacyhostapi.tm>>
    <associate|auto-391|<tuple|E.1.17.10|123|af-legacyhostapi.tm>>
    <associate|auto-392|<tuple|E.1.17.11|124|af-legacyhostapi.tm>>
    <associate|auto-393|<tuple|E.1.17.12|124|af-legacyhostapi.tm>>
    <associate|auto-394|<tuple|E.1.17.13|125|af-legacyhostapi.tm>>
    <associate|auto-395|<tuple|E.1.17.14|125|af-legacyhostapi.tm>>
    <associate|auto-396|<tuple|E.1.17.15|125|af-legacyhostapi.tm>>
    <associate|auto-397|<tuple|E.1.18|126|af-legacyhostapi.tm>>
    <associate|auto-398|<tuple|E.1.18.1|126|af-legacyhostapi.tm>>
    <associate|auto-399|<tuple|E.1.19|126|af-legacyhostapi.tm>>
    <associate|auto-4|<tuple|<with|font-series|<quote|bold>|math-font-series|<quote|bold>|<with|mode|<quote|math>|P<rsub|n>>>|10|c01-background.tm>>
    <associate|auto-40|<tuple|3.1.2|20|c03-transition.tm>>
    <associate|auto-400|<tuple|E.1.19.1|126|af-legacyhostapi.tm>>
    <associate|auto-401|<tuple|E.1.19.2|126|af-legacyhostapi.tm>>
    <associate|auto-402|<tuple|E.1.20|126|af-legacyhostapi.tm>>
    <associate|auto-403|<tuple|E.1.20.1|126|af-legacyhostapi.tm>>
    <associate|auto-404|<tuple|E.1.21|126|af-legacyhostapi.tm>>
    <associate|auto-405|<tuple|E.2|126|af-legacyhostapi.tm>>
    <associate|auto-406|<tuple|F|127|ag-runtimeentries.tm>>
    <associate|auto-407|<tuple|F.1|127|ag-runtimeentries.tm>>
    <associate|auto-408|<tuple|F.1|127|ag-runtimeentries.tm>>
    <associate|auto-409|<tuple|F.2|128|ag-runtimeentries.tm>>
    <associate|auto-41|<tuple|3.1.2.1|20|c03-transition.tm>>
    <associate|auto-410|<tuple|F.3|128|ag-runtimeentries.tm>>
    <associate|auto-411|<tuple|F.3.1|128|ag-runtimeentries.tm>>
    <associate|auto-412|<tuple|F.1|128|ag-runtimeentries.tm>>
    <associate|auto-413|<tuple|F.3.2|129|ag-runtimeentries.tm>>
    <associate|auto-414|<tuple|F.3.3|129|ag-runtimeentries.tm>>
    <associate|auto-415|<tuple|F.3.4|129|ag-runtimeentries.tm>>
    <associate|auto-416|<tuple|F.3.5|129|ag-runtimeentries.tm>>
    <associate|auto-417|<tuple|F.2|130|ag-runtimeentries.tm>>
    <associate|auto-418|<tuple|F.3|130|ag-runtimeentries.tm>>
    <associate|auto-419|<tuple|F.4|130|ag-runtimeentries.tm>>
    <associate|auto-42|<tuple|3.1.2.2|20|c03-transition.tm>>
    <associate|auto-420|<tuple|F.5|130|ag-runtimeentries.tm>>
    <associate|auto-421|<tuple|F.6|131|ag-runtimeentries.tm>>
    <associate|auto-422|<tuple|F.7|131|ag-runtimeentries.tm>>
    <associate|auto-423|<tuple|F.8|131|ag-runtimeentries.tm>>
    <associate|auto-424|<tuple|F.3.6|131|ag-runtimeentries.tm>>
    <associate|auto-425|<tuple|F.3.7|132|ag-runtimeentries.tm>>
    <associate|auto-426|<tuple|F.3.8|132|ag-runtimeentries.tm>>
    <associate|auto-427|<tuple|F.3.9|132|ag-runtimeentries.tm>>
    <associate|auto-428|<tuple|F.3.10|132|ag-runtimeentries.tm>>
    <associate|auto-429|<tuple|F.9|133|ag-runtimeentries.tm>>
    <associate|auto-43|<tuple|3.1.2.3|20|c03-transition.tm>>
    <associate|auto-430|<tuple|F.3.11|133|ag-runtimeentries.tm>>
    <associate|auto-431|<tuple|F.3.12|133|ag-runtimeentries.tm>>
    <associate|auto-432|<tuple|F.3.13|133|ag-runtimeentries.tm>>
    <associate|auto-433|<tuple|F.3.14|133|ag-runtimeentries.tm>>
    <associate|auto-434|<tuple|F.3.15|133|ag-runtimeentries.tm>>
    <associate|auto-435|<tuple|F.3.16|134|ag-runtimeentries.tm>>
    <associate|auto-436|<tuple|F.3.17|134|ag-runtimeentries.tm>>
    <associate|auto-437|<tuple|F.3.18|134|ag-runtimeentries.tm>>
    <associate|auto-438|<tuple|F.3.19|134|ag-runtimeentries.tm>>
    <associate|auto-439|<tuple|F.3.20|134|ag-runtimeentries.tm>>
    <associate|auto-44|<tuple|3.1.2.4|21|c03-transition.tm>>
    <associate|auto-440|<tuple|F.3.21|134|ag-runtimeentries.tm>>
    <associate|auto-441|<tuple|F.3.22|134|ag-runtimeentries.tm>>
    <associate|auto-442|<tuple|F.3.23|134|ag-runtimeentries.tm>>
    <associate|auto-443|<tuple|F.3.24|134|ag-runtimeentries.tm>>
    <associate|auto-444|<tuple|F.3.25|134|ag-runtimeentries.tm>>
    <associate|auto-445|<tuple|F.3.26|134|ag-runtimeentries.tm>>
    <associate|auto-446|<tuple|F.3.27|135|ag-runtimeentries.tm>>
    <associate|auto-447|<tuple|F.3.28|135|ag-runtimeentries.tm>>
    <associate|auto-448|<tuple|F.10|135|ag-runtimeentries.tm>>
    <associate|auto-449|<tuple|F.3.29|135|ag-runtimeentries.tm>>
    <associate|auto-45|<tuple|3.1.2.5|21|c03-transition.tm>>
    <associate|auto-450|<tuple|F.3.30|136|ag-runtimeentries.tm>>
    <associate|auto-451|<tuple|F.3.31|136|ag-runtimeentries.tm>>
    <associate|auto-452|<tuple|F.3.32|136|ag-runtimeentries.tm>>
    <associate|auto-453|<tuple|F.3.33|137|ag-runtimeentries.tm>>
    <associate|auto-454|<tuple|F.3.34|137|ag-runtimeentries.tm>>
    <associate|auto-455|<tuple|F.3.35|137|ag-runtimeentries.tm>>
    <associate|auto-456|<tuple|F.3.36|137|ag-runtimeentries.tm>>
    <associate|auto-457|<tuple|F.3.37|137|ag-runtimeentries.tm>>
    <associate|auto-458|<tuple|F.3.38|138|ag-runtimeentries.tm>>
    <associate|auto-459|<tuple|F.3.39|138|ag-runtimeentries.tm>>
    <associate|auto-46|<tuple|3.2|21|c03-transition.tm>>
    <associate|auto-460|<tuple|<with|mode|<quote|math>|\<bullet\>>|141>>
    <associate|auto-461|<tuple|<with|mode|<quote|math>|\<bullet\>>|143>>
    <associate|auto-462|<tuple|Ste19|145>>
    <associate|auto-47|<tuple|3.2.1|21|c03-transition.tm>>
    <associate|auto-48|<tuple|3.2.2|21|c03-transition.tm>>
    <associate|auto-49|<tuple|3.2.2.1|21|c03-transition.tm>>
    <associate|auto-5|<tuple|<with|mode|<quote|math>|\<bbb-B\><rsub|n>>|10|c01-background.tm>>
    <associate|auto-50|<tuple|3.2.3|22|c03-transition.tm>>
    <associate|auto-51|<tuple|Transaction Message|22|c03-transition.tm>>
    <associate|auto-52|<tuple|transaction pool|22|c03-transition.tm>>
    <associate|auto-53|<tuple|transaction queue|22|c03-transition.tm>>
    <associate|auto-54|<tuple|3.2.3.1|23|c03-transition.tm>>
    <associate|auto-55|<tuple|3.1|23|c03-transition.tm>>
    <associate|auto-56|<tuple|3.3|23|c03-transition.tm>>
    <associate|auto-57|<tuple|3.3.1|23|c03-transition.tm>>
    <associate|auto-58|<tuple|3.3.1.1|23|c03-transition.tm>>
    <associate|auto-59|<tuple|3.2|24|c03-transition.tm>>
    <associate|auto-6|<tuple|I|10|c01-background.tm>>
    <associate|auto-60|<tuple|3.3.1.2|24|c03-transition.tm>>
    <associate|auto-61|<tuple|3.3.1.3|25|c03-transition.tm>>
    <associate|auto-62|<tuple|3.3.2|25|c03-transition.tm>>
    <associate|auto-63|<tuple|3.3.3|26|c03-transition.tm>>
    <associate|auto-64|<tuple|3.3.4|26|c03-transition.tm>>
    <associate|auto-65|<tuple|3.3|27|c03-transition.tm>>
    <associate|auto-66|<tuple|3.3.4.1|27|c03-transition.tm>>
    <associate|auto-67|<tuple|3.3.4.2|27|c03-transition.tm>>
    <associate|auto-68|<tuple|3.3.4.3|28|c03-transition.tm>>
    <associate|auto-69|<tuple|4|29|c04-networking.tm>>
    <associate|auto-7|<tuple|<with|mode|<quote|math>|B>|10|c01-background.tm>>
    <associate|auto-70|<tuple|4.1|29|c04-networking.tm>>
    <associate|auto-71|<tuple|4.1.1|29|c04-networking.tm>>
    <associate|auto-72|<tuple|4.1.2|29|c04-networking.tm>>
    <associate|auto-73|<tuple|4.1.3|30|c04-networking.tm>>
    <associate|auto-74|<tuple|4.1.4|30|c04-networking.tm>>
    <associate|auto-75|<tuple|4.1.5|31|c04-networking.tm>>
    <associate|auto-76|<tuple|4.1.6|31|c04-networking.tm>>
    <associate|auto-77|<tuple|4.1.7|32|c04-networking.tm>>
    <associate|auto-78|<tuple|4.1.7.1|32|c04-networking.tm>>
    <associate|auto-79|<tuple|4.1.7.2|33|c04-networking.tm>>
    <associate|auto-8|<tuple|<with|mode|<quote|math>|Enc<rsub|LE>>|10|c01-background.tm>>
    <associate|auto-80|<tuple|4.1|33|c04-networking.tm>>
    <associate|auto-81|<tuple|4.2|33|c04-networking.tm>>
    <associate|auto-82|<tuple|4.3|33|c04-networking.tm>>
    <associate|auto-83|<tuple|4.4|33|c04-networking.tm>>
    <associate|auto-84|<tuple|4.5|34|c04-networking.tm>>
    <associate|auto-85|<tuple|4.6|34|c04-networking.tm>>
    <associate|auto-86|<tuple|4.1.7.3|34|c04-networking.tm>>
    <associate|auto-87|<tuple|4.1.7.4|34|c04-networking.tm>>
    <associate|auto-88|<tuple|4.1.7.5|34|c04-networking.tm>>
    <associate|auto-89|<tuple|4.1.7.6|35|c04-networking.tm>>
    <associate|auto-9|<tuple|C, blockchain|10|c01-background.tm>>
    <associate|auto-90|<tuple|5|37|c05-bootstrapping.tm>>
    <associate|auto-91|<tuple|6|39|c06-consensus.tm>>
    <associate|auto-92|<tuple|6.1|39|c06-consensus.tm>>
    <associate|auto-93|<tuple|6.1.1|39|c06-consensus.tm>>
    <associate|auto-94|<tuple|6.1.2|39|c06-consensus.tm>>
    <associate|auto-95|<tuple|6.1|39|c06-consensus.tm>>
    <associate|auto-96|<tuple|6.2|40|c06-consensus.tm>>
    <associate|auto-97|<tuple|6.2|41|c06-consensus.tm>>
    <associate|auto-98|<tuple|6.2.1|41|c06-consensus.tm>>
    <associate|auto-99|<tuple|6.2.2|42|c06-consensus.tm>>
    <associate|bib-burdges_schnorr_2019|<tuple|Bur19|91>>
    <associate|bib-collet_extremely_2019|<tuple|Col19|95>>
    <associate|bib-david_ouroboros_2018|<tuple|DGKR18|91>>
    <associate|bib-josefsson_edwards-curve_2017|<tuple|JL17|91>>
    <associate|bib-paritytech_genesis_state|<tuple|Tec20|91>>
    <associate|bib-saarinen_blake2_2015|<tuple|SA15|91>>
    <associate|bib-stewart_grandpa:_2019|<tuple|Ste19|91>>
    <associate|bib-w3f_research_group_blind_2019|<tuple|Gro19|91>>
    <associate|bib-web3.0_technologies_foundation_polkadot_2020|<tuple|Fou20|95>>
    <associate|block|<tuple|3.3.1.1|23|c03-transition.tm>>
    <associate|chap-bootstrapping|<tuple|5|37|c05-bootstrapping.tm>>
    <associate|chap-consensu|<tuple|6|39|c06-consensus.tm>>
    <associate|chap-state-spec|<tuple|2|13|c02-state.tm>>
    <associate|chap-state-transit|<tuple|3|19|c03-transition.tm>>
    <associate|defn-account-key|<tuple|A.1|81|aa-cryptoalgorithms.tm>>
    <associate|defn-approval-attestation-transaction|<tuple|7.30|71|c07-anv.tm>>
    <associate|defn-authority-list|<tuple|6.1|39|c06-consensus.tm>>
    <associate|defn-authority-set-id|<tuple|6.24|47|c06-consensus.tm>>
    <associate|defn-availability-bitfield|<tuple|7.22|67|c07-anv.tm>>
    <associate|defn-availability-vote-message|<tuple|7.21|66|c07-anv.tm>>
    <associate|defn-available-parablock-proposal|<tuple|7.23|67|c07-anv.tm>>
    <associate|defn-babe-constant|<tuple|6.11|42|c06-consensus.tm>>
    <associate|defn-babe-header|<tuple|6.20|44|c06-consensus.tm>>
    <associate|defn-babe-seal|<tuple|6.21|45|c06-consensus.tm>>
    <associate|defn-bit-rep|<tuple|1.6|10|c01-background.tm>>
    <associate|defn-blob|<tuple|7.10|59|c07-anv.tm>>
    <associate|defn-block-announce|<tuple|4.3|32|c04-networking.tm>>
    <associate|defn-block-announce-handshake|<tuple|4.2|32|c04-networking.tm>>
    <associate|defn-block-body|<tuple|3.9|25|c03-transition.tm>>
    <associate|defn-block-header|<tuple|3.6|23|c03-transition.tm>>
    <associate|defn-block-header-hash|<tuple|3.8|24|c03-transition.tm>>
    <associate|defn-block-signature|<tuple|6.21|45|c06-consensus.tm>>
    <associate|defn-block-time|<tuple|6.18|43|c06-consensus.tm>>
    <associate|defn-block-tree|<tuple|1.11|11|c01-background.tm>>
    <associate|defn-candidate|<tuple|7.11|61|c07-anv.tm>>
    <associate|defn-candidate-commitments|<tuple|7.14|62|c07-anv.tm>>
    <associate|defn-candidate-receipt|<tuple|7.13|62|c07-anv.tm>>
    <associate|defn-chain-quality|<tuple|6.17|43|c06-consensus.tm>>
    <associate|defn-chain-subchain|<tuple|1.13|11|c01-background.tm>>
    <associate|defn-child-storage-type|<tuple|D.4|92|ae-hostapi.tm>>
    <associate|defn-children-bitmap|<tuple|2.10|16|c02-state.tm>>
    <associate|defn-collator-invalidity-transaction|<tuple|7.31|71|c07-anv.tm>>
    <associate|defn-collator-unavailability-transaction|<tuple|7.32|71|c07-anv.tm>>
    <associate|defn-consensus-message-digest|<tuple|6.3|39|c06-consensus.tm>>
    <associate|defn-controller-key|<tuple|A.3|81|aa-cryptoalgorithms.tm>>
    <associate|defn-digest|<tuple|3.7|24|c03-transition.tm>>
    <associate|defn-ecdsa-verify-error|<tuple|D.6|95|ae-hostapi.tm>>
    <associate|defn-epoch-randomness|<tuple|6.22|45|c06-consensus.tm>>
    <associate|defn-epoch-slot|<tuple|6.6|41|c06-consensus.tm>>
    <associate|defn-epoch-subchain|<tuple|6.9|42|c06-consensus.tm>>
    <associate|defn-equivocation|<tuple|6.27|48|c06-consensus.tm>>
    <associate|defn-erasure-coded-chunks|<tuple|7.19|66|c07-anv.tm>>
    <associate|defn-erasure-coded-chunks-request|<tuple|7.27|70|c07-anv.tm>>
    <associate|defn-erasure-coded-chunks-response|<tuple|7.28|70|c07-anv.tm>>
    <associate|defn-erasure-encoder-decoder|<tuple|7.18|65|c07-anv.tm>>
    <associate|defn-extra-validation-data|<tuple|7.6|58|c07-anv.tm>>
    <associate|defn-finalized-block|<tuple|6.43|54|c06-consensus.tm>>
    <associate|defn-finalizing-justification|<tuple|6.38|50|c06-consensus.tm>>
    <associate|defn-genesis-header|<tuple|C.1|87|ac-genesis.tm>>
    <associate|defn-global-validation-parameters|<tuple|7.7|58|c07-anv.tm>>
    <associate|defn-gossip-message|<tuple|6.34|49|c06-consensus.tm>>
    <associate|defn-gossip-pov-block|<tuple|7.15|62|c07-anv.tm>>
    <associate|defn-gossip-statement|<tuple|7.16|63|c07-anv.tm>>
    <associate|defn-grandpa-catchup-request-msg|<tuple|6.40|51|c06-consensus.tm>>
    <associate|defn-grandpa-catchup-response-msg|<tuple|6.41|51|c06-consensus.tm>>
    <associate|defn-grandpa-completable|<tuple|6.33|49|c06-consensus.tm>>
    <associate|defn-grandpa-justification|<tuple|6.37|50|c06-consensus.tm>>
    <associate|defn-grandpa-voter|<tuple|6.23|47|c06-consensus.tm>>
    <associate|defn-head-data|<tuple|7.12|61|c07-anv.tm>>
    <associate|defn-hex-encoding|<tuple|B.14|85|ab-encodings.tm>>
    <associate|defn-http-error|<tuple|D.10|103|ae-hostapi.tm>>
    <associate|defn-http-return-value|<tuple|E.3|121|af-legacyhostapi.tm>>
    <associate|defn-http-status-codes|<tuple|D.9|103|ae-hostapi.tm>>
    <associate|defn-index-function|<tuple|2.7|14|c02-state.tm>>
    <associate|defn-inherent-data|<tuple|3.5|23|c03-transition.tm>>
    <associate|defn-key-type-id|<tuple|D.5|95|ae-hostapi.tm>>
    <associate|defn-lexicographic-ordering|<tuple|D.3|89|ae-hostapi.tm>>
    <associate|defn-little-endian|<tuple|1.7|10|c01-background.tm>>
    <associate|defn-local-storage|<tuple|D.8|103|ae-hostapi.tm>>
    <associate|defn-local-validation-parameters|<tuple|7.8|59|c07-anv.tm>>
    <associate|defn-logging-log-level|<tuple|D.12|112|ae-hostapi.tm>>
    <associate|defn-longest-chain|<tuple|1.14|11|c01-background.tm>>
    <associate|defn-merkle-value|<tuple|2.12|17|c02-state.tm>>
    <associate|defn-msg-request-whole-block|<tuple|7.25|70|c07-anv.tm>>
    <associate|defn-node-header|<tuple|2.9|15|c02-state.tm>>
    <associate|defn-node-key|<tuple|2.6|14|c02-state.tm>>
    <associate|defn-node-subvalue|<tuple|2.11|16|c02-state.tm>>
    <associate|defn-node-value|<tuple|2.8|15|c02-state.tm>>
    <associate|defn-nodetype|<tuple|2.4|14|c02-state.tm>>
    <associate|defn-observed-votes|<tuple|6.30|48|c06-consensus.tm>>
    <associate|defn-offchain-local-storage|<tuple|E.2|120|af-legacyhostapi.tm>>
    <associate|defn-offchain-persistent-storage|<tuple|E.1|120|af-legacyhostapi.tm>>
    <associate|defn-opaque-network-state|<tuple|D.11|104|ae-hostapi.tm>>
    <associate|defn-option-type|<tuple|B.5|83|ab-encodings.tm>>
    <associate|defn-para-proposal|<tuple|7.17|64|c07-anv.tm>>
    <associate|defn-path-graph|<tuple|1.2|10|c01-background.tm>>
    <associate|defn-peer-id|<tuple|4.1|30|c04-networking.tm>>
    <associate|defn-persistent-storage|<tuple|D.7|103|ae-hostapi.tm>>
    <associate|defn-pov-block|<tuple|7.4|58|c07-anv.tm>>
    <associate|defn-pov-block-response|<tuple|7.26|70|c07-anv.tm>>
    <associate|defn-pov-erasure-chunk-message|<tuple|7.20|66|c07-anv.tm>>
    <associate|defn-pruned-tree|<tuple|1.12|11|c01-background.tm>>
    <associate|defn-prunned-best|<tuple|6.16|43|c06-consensus.tm>>
    <associate|defn-radix-tree|<tuple|1.3|10|c01-background.tm>>
    <associate|defn-relative-syncronization|<tuple|6.14|43|c06-consensus.tm>>
    <associate|defn-result-type|<tuple|B.6|83|ab-encodings.tm>>
    <associate|defn-rt-apisvec|<tuple|F.1|128|ag-runtimeentries.tm>>
    <associate|defn-rt-blockbuilder-finalize-block|<tuple|F.3.6|131|ag-runtimeentries.tm>>
    <associate|defn-rt-core-version|<tuple|F.3.1|128|ag-runtimeentries.tm>>
    <associate|defn-rte-apply-extrinsic-result|<tuple|F.2|130|ag-runtimeentries.tm>>
    <associate|defn-rte-custom-module-error|<tuple|F.5|130|ag-runtimeentries.tm>>
    <associate|defn-rte-dispatch-error|<tuple|F.4|130|ag-runtimeentries.tm>>
    <associate|defn-rte-dispatch-outcome|<tuple|F.3|130|ag-runtimeentries.tm>>
    <associate|defn-rte-invalid-transaction|<tuple|F.7|131|ag-runtimeentries.tm>>
    <associate|defn-rte-transaction-validity-error|<tuple|F.6|131|ag-runtimeentries.tm>>
    <associate|defn-rte-unknown-transaction|<tuple|F.8|131|ag-runtimeentries.tm>>
    <associate|defn-runtime|<tuple|1.1|9|c01-background.tm>>
    <associate|defn-runtime-pointer|<tuple|D.2|89|ae-hostapi.tm>>
    <associate|defn-sc-len-encoding|<tuple|B.13|84|ab-encodings.tm>>
    <associate|defn-scale-byte-array|<tuple|B.1|83|ab-encodings.tm>>
    <associate|defn-scale-codec|<tuple|7.1|57|c07-anv.tm>>
    <associate|defn-scale-empty|<tuple|B.12|84|ab-encodings.tm>>
    <associate|defn-scale-fixed-length|<tuple|B.11|84|ab-encodings.tm>>
    <associate|defn-scale-list|<tuple|B.8|84|ab-encodings.tm>>
    <associate|defn-scale-tuple|<tuple|B.2|83|ab-encodings.tm>>
    <associate|defn-scale-variable-type|<tuple|B.7|84|ab-encodings.tm>>
    <associate|defn-secondary-appoval-attestation|<tuple|7.29|71|c07-anv.tm>>
    <associate|defn-session-key|<tuple|A.4|82|aa-cryptoalgorithms.tm>>
    <associate|defn-set-state-at|<tuple|3.10|26|c03-transition.tm>>
    <associate|defn-sign-round-vote|<tuple|6.35|49|c06-consensus.tm>>
    <associate|defn-slot-offset|<tuple|6.13|43|c06-consensus.tm>>
    <associate|defn-stash-key|<tuple|A.2|81|aa-cryptoalgorithms.tm>>
    <associate|defn-state-machine|<tuple|1.1|9|c01-background.tm>>
    <associate|defn-stored-value|<tuple|2.1|13|c02-state.tm>>
    <associate|defn-sync-period|<tuple|6.19|43|c06-consensus.tm>>
    <associate|defn-total-potential-votes|<tuple|6.31|49|c06-consensus.tm>>
    <associate|defn-transaction-queue|<tuple|3.4|22|c03-transition.tm>>
    <associate|defn-transactions-message|<tuple|4.6|34|c04-networking.tm>>
    <associate|defn-unavailable-parablock-proposal|<tuple|7.24|68|c07-anv.tm>>
    <associate|defn-unix-time|<tuple|1.10|10|c01-background.tm>>
    <associate|defn-upgrade-indicator|<tuple|7.5|58|c07-anv.tm>>
    <associate|defn-valid-transaction|<tuple|F.9|133|ag-runtimeentries.tm>>
    <associate|defn-varrying-data-type|<tuple|B.4|83|ab-encodings.tm>>
    <associate|defn-vote|<tuple|6.25|52|c06-consensus.tm>>
    <associate|defn-winning-threshold|<tuple|6.12|42|c06-consensus.tm>>
    <associate|defn-witness-proof|<tuple|7.3|58|c07-anv.tm>>
    <associate|diag-anv-overall|<tuple|7.1|60|c07-anv.tm>>
    <associate|exmp-candid-unfinalized|<tuple|6.42|54|c06-consensus.tm>>
    <associate|key-encode-in-trie|<tuple|2.1|13|c02-state.tm>>
    <associate|nota-call-into-runtime|<tuple|3.2|20|c03-transition.tm>>
    <associate|nota-re-api-at-state|<tuple|D.1|89|ae-hostapi.tm>>
    <associate|nota-runtime-code-at-state|<tuple|3.1|20|c03-transition.tm>>
    <associate|note-slot|<tuple|6.8|42|c06-consensus.tm>>
    <associate|part:aa-cryptoalgorithms.tm|<tuple|8.5|81>>
    <associate|part:ab-encodings.tm|<tuple|A.5.5|83>>
    <associate|part:ac-genesis.tm|<tuple|B.14|87>>
    <associate|part:ad-netmessages.tm|<tuple|C.1|87>>
    <associate|part:ae-hostapi.tm|<tuple|C.1|87>>
    <associate|part:af-legacyhostapi.tm|<tuple|C.1|87>>
    <associate|part:ag-runtimeentries.tm|<tuple|C.1|87>>
    <associate|part:c01-background.tm|<tuple|?|9>>
    <associate|part:c02-state.tm|<tuple|1.16|13>>
    <associate|part:c03-transition.tm|<tuple|2.2.1|19>>
    <associate|part:c04-networking.tm|<tuple|3.3.4.3|29>>
    <associate|part:c04a-networking.tm|<tuple|<with|mode|<quote|math>|\<bullet\>>|35>>
    <associate|part:c05-bootstrapping.tm|<tuple|<with|mode|<quote|math>|\<bullet\>>|37>>
    <associate|part:c06-consensus.tm|<tuple|5|39>>
    <associate|part:c07-anv.tm|<tuple|19|56>>
    <associate|part:c08-messaging.tm|<tuple|7.12.3|73>>
    <associate|sect-accountnonceapi-account-nonce|<tuple|F.3.37|137|ag-runtimeentries.tm>>
    <associate|sect-approval-checking|<tuple|7.11|68|c07-anv.tm>>
    <associate|sect-authority-set|<tuple|6.1.1|39|c06-consensus.tm>>
    <associate|sect-babe|<tuple|6.2|41|c06-consensus.tm>>
    <associate|sect-babe-equivocation-proof|<tuple|4.1.7.6|35|c04-networking.tm>>
    <associate|sect-babeapi_current_epoch|<tuple|F.3.30|136|ag-runtimeentries.tm>>
    <associate|sect-babeapi_generate_key_ownership_proof|<tuple|F.3.32|136|ag-runtimeentries.tm>>
    <associate|sect-babeapi_submit_report_equivocation_unsigned_extrinsic|<tuple|F.3.33|137|ag-runtimeentries.tm>>
    <associate|sect-blake2|<tuple|A.2|81|aa-cryptoalgorithms.tm>>
    <associate|sect-block-body|<tuple|3.3.1.3|25|c03-transition.tm>>
    <associate|sect-block-building|<tuple|6.2.7|46|c06-consensus.tm>>
    <associate|sect-block-finalization|<tuple|6.4|54|c06-consensus.tm>>
    <associate|sect-block-format|<tuple|3.3.1|23|c03-transition.tm>>
    <associate|sect-block-production|<tuple|6.2|41|c06-consensus.tm>>
    <associate|sect-block-submission|<tuple|3.3.2|25|c03-transition.tm>>
    <associate|sect-block-validation|<tuple|3.3.2|25|c03-transition.tm>>
    <associate|sect-certifying-keys|<tuple|A.5.5|82|aa-cryptoalgorithms.tm>>
    <associate|sect-changes-trie|<tuple|3.3.4|26|c03-transition.tm>>
    <associate|sect-changes-trie-block-pairs|<tuple|3.3.4.2|27|c03-transition.tm>>
    <associate|sect-changes-trie-child-trie-pair|<tuple|3.3.4.3|28|c03-transition.tm>>
    <associate|sect-changes-trie-extrinsics-pairs|<tuple|3.3.4.1|27|c03-transition.tm>>
    <associate|sect-child-storage-api|<tuple|D.2|92|ae-hostapi.tm>>
    <associate|sect-child-storages|<tuple|2.2|17|c02-state.tm>>
    <associate|sect-child-trie-structure|<tuple|2.2.1|17|c02-state.tm>>
    <associate|sect-code-executor|<tuple|3.1.2|20|c03-transition.tm>>
    <associate|sect-connection-establishment|<tuple|4.1.4|30|c04-networking.tm>>
    <associate|sect-consensus-message-digest|<tuple|6.1.2|39|c06-consensus.tm>>
    <associate|sect-controller-settings|<tuple|A.5.4|82|aa-cryptoalgorithms.tm>>
    <associate|sect-creating-controller-key|<tuple|A.5.2|82|aa-cryptoalgorithms.tm>>
    <associate|sect-cryptographic-keys|<tuple|A.5|81|aa-cryptoalgorithms.tm>>
    <associate|sect-defn-conv|<tuple|1.2|9|c01-background.tm>>
    <associate|sect-designating-proxy|<tuple|A.5.3|82|aa-cryptoalgorithms.tm>>
    <associate|sect-discovery-mechanism|<tuple|4.1.3|30|c04-networking.tm>>
    <associate|sect-distribute-chunks|<tuple|7.8|66|c07-anv.tm>>
    <associate|sect-encoding|<tuple|B|83|ab-encodings.tm>>
    <associate|sect-encryption-layer|<tuple|4.1.5|31|c04-networking.tm>>
    <associate|sect-entries-into-runtime|<tuple|3.1|19|c03-transition.tm>>
    <associate|sect-epoch-randomness|<tuple|6.2.5|45|c06-consensus.tm>>
    <associate|sect-equivocation-case|<tuple|7.11.5|69|c07-anv.tm>>
    <associate|sect-escalation|<tuple|7.12.3|71|c07-anv.tm>>
    <associate|sect-ext-crypto-ecdsa-verify|<tuple|D.3.12|99|ae-hostapi.tm>>
    <associate|sect-ext-crypto-ed25519-verify|<tuple|D.3.4|96|ae-hostapi.tm>>
    <associate|sect-ext-crypto-finish-batch-verify|<tuple|D.3.16|101|ae-hostapi.tm>>
    <associate|sect-ext-crypto-sr25519-verify|<tuple|D.3.8|98|ae-hostapi.tm>>
    <associate|sect-ext-crypto-start-batch-verify|<tuple|D.3.15|100|ae-hostapi.tm>>
    <associate|sect-ext-offchain-submit-transaction|<tuple|D.5.2|104|ae-hostapi.tm>>
    <associate|sect-ext-storage-changes-root|<tuple|D.1.9|91|ae-hostapi.tm>>
    <associate|sect-ext-storage-commit-transaction|<tuple|D.1.13|92|ae-hostapi.tm>>
    <associate|sect-ext-storage-rollback-transaction|<tuple|D.1.12|92|ae-hostapi.tm>>
    <associate|sect-ext-storage-start-transaction|<tuple|D.1.11|92|ae-hostapi.tm>>
    <associate|sect-extra-validation|<tuple|7.11.4|69|c07-anv.tm>>
    <associate|sect-extrinsics|<tuple|3.2|21|c03-transition.tm>>
    <associate|sect-finality|<tuple|6.3|47|c06-consensus.tm>>
    <associate|sect-genesis-block|<tuple|C|87|ac-genesis.tm>>
    <associate|sect-grandpa-catchup|<tuple|6.4.1|55|c06-consensus.tm>>
    <associate|sect-grandpa-catchup-messages|<tuple|6.3.2.3|50|c06-consensus.tm>>
    <associate|sect-grandpa-equivocation-proof|<tuple|4.1.7.5|34|c04-networking.tm>>
    <associate|sect-grandpaapi_generate_key_ownership_proof|<tuple|F.3.27|135|ag-runtimeentries.tm>>
    <associate|sect-grandpaapi_submit_report_equivocation_unsigned_extrinsic|<tuple|F.3.26|134|ag-runtimeentries.tm>>
    <associate|sect-handling-runtime-state-update|<tuple|3.1.2.5|21|c03-transition.tm>>
    <associate|sect-hash-functions|<tuple|A.1|81|aa-cryptoalgorithms.tm>>
    <associate|sect-inclusion-of-candidate-receipt|<tuple|7.5.1|64|c07-anv.tm>>
    <associate|sect-inherents|<tuple|3.2.3.1|23|c03-transition.tm>>
    <associate|sect-int-encoding|<tuple|B.1.1|84|ab-encodings.tm>>
    <associate|sect-json-rpc-api|<tuple|F.2|128|ag-runtimeentries.tm>>
    <associate|sect-justified-block-header|<tuple|3.3.1.2|24|c03-transition.tm>>
    <associate|sect-list-of-runtime-entries|<tuple|F.1|127|ag-runtimeentries.tm>>
    <associate|sect-loading-runtime-code|<tuple|3.1.1|19|c03-transition.tm>>
    <associate|sect-managing-multiple-states|<tuple|3.3.3|26|c03-transition.tm>>
    <associate|sect-memory-management|<tuple|3.1.2.2|20|c03-transition.tm>>
    <associate|sect-merkl-proof|<tuple|2.1.4|16|c02-state.tm>>
    <associate|sect-msg-announcing-blocks|<tuple|4.1.7.1|36|c04-networking.tm>>
    <associate|sect-msg-block-announce|<tuple|4.1.7.1|32|c04-networking.tm>>
    <associate|sect-msg-block-request|<tuple|4.1.7.2|33|c04-networking.tm>>
    <associate|sect-msg-grandpa|<tuple|4.1.7.4|34|c04-networking.tm>>
    <associate|sect-msg-requesting-blocks|<tuple|4.1.7.2|37|c04-networking.tm>>
    <associate|sect-msg-transactions|<tuple|4.1.7.3|34|c04-networking.tm>>
    <associate|sect-network-messages|<tuple|4.1.7|32|c04-networking.tm>>
    <associate|sect-networking|<tuple|4|29|c04-networking.tm>>
    <associate|sect-networking-external-docs|<tuple|4.1.1|29|c04-networking.tm>>
    <associate|sect-primary-validation|<tuple|7.4|61|c07-anv.tm>>
    <associate|sect-primary-validation-disagreemnt|<tuple|7.6.1|64|c07-anv.tm>>
    <associate|sect-primary-validaty-announcement|<tuple|7.5|61|c07-anv.tm>>
    <associate|sect-processing-availability|<tuple|7.9.1|67|c07-anv.tm>>
    <associate|sect-protocols-substreams|<tuple|4.1.6|31|c04-networking.tm>>
    <associate|sect-publishing-attestations|<tuple|7.10|68|c07-anv.tm>>
    <associate|sect-randomness|<tuple|A.3|81|aa-cryptoalgorithms.tm>>
    <associate|sect-re-api|<tuple|Ste19|113>>
    <associate|sect-retrieval|<tuple|7.12.0.1|70|c07-anv.tm>>
    <associate|sect-rte-apply-extrinsic|<tuple|F.3.5|129|ag-runtimeentries.tm>>
    <associate|sect-rte-babeapi-epoch|<tuple|F.3.28|135|ag-runtimeentries.tm>>
    <associate|sect-rte-core-execute-block|<tuple|F.3.2|129|ag-runtimeentries.tm>>
    <associate|sect-rte-grandpa-auth|<tuple|F.3.25|134|ag-runtimeentries.tm>>
    <associate|sect-rte-validate-transaction|<tuple|F.3.10|132|ag-runtimeentries.tm>>
    <associate|sect-runtime-entries|<tuple|F|127|ag-runtimeentries.tm>>
    <associate|sect-runtime-return-value|<tuple|3.1.2.4|21|c03-transition.tm>>
    <associate|sect-runtime-send-args-to-runtime-enteries|<tuple|3.1.2.3|20|c03-transition.tm>>
    <associate|sect-scale-codec|<tuple|B.1|83|ab-encodings.tm>>
    <associate|sect-sending-catchup-request|<tuple|6.4.1.1|55|c06-consensus.tm>>
    <associate|sect-set-storage|<tuple|E.1.1|113|af-legacyhostapi.tm>>
    <associate|sect-shot-assignment|<tuple|7.11.3|68|c07-anv.tm>>
    <associate|sect-slot-number-calculation|<tuple|6.2.3|43|c06-consensus.tm>>
    <associate|sect-staking-funds|<tuple|A.5.1|82|aa-cryptoalgorithms.tm>>
    <associate|sect-state-replication|<tuple|3.3|23|c03-transition.tm>>
    <associate|sect-state-storage|<tuple|2.1|13|c02-state.tm>>
    <associate|sect-state-storage-trie-structure|<tuple|2.1.3|14|c02-state.tm>>
    <associate|sect-verifying-authorship|<tuple|6.2.6|45|c06-consensus.tm>>
    <associate|sect-voting-on-availability|<tuple|7.9|66|c07-anv.tm>>
    <associate|sect-vrf|<tuple|A.4|81|aa-cryptoalgorithms.tm>>
    <associate|sect-vrf-comp|<tuple|7.11.2|68|c07-anv.tm>>
    <associate|snippet-runtime-enteries|<tuple|F.1|127|ag-runtimeentries.tm>>
    <associate|tabl-account-key-schemes|<tuple|A.1|81|aa-cryptoalgorithms.tm>>
    <associate|tabl-consensus-messages-babe|<tuple|6.1|39|c06-consensus.tm>>
    <associate|tabl-consensus-messages-grandpa|<tuple|6.2|40|c06-consensus.tm>>
    <associate|tabl-digest-items|<tuple|3.2|24|c03-transition.tm>>
    <associate|tabl-genesis-header|<tuple|C.1|87|ac-genesis.tm>>
    <associate|tabl-inherent-data|<tuple|3.1|23|c03-transition.tm>>
    <associate|tabl-session-keys|<tuple|A.2|82|aa-cryptoalgorithms.tm>>
    <associate|table-changes-trie-key-types|<tuple|3.3|27|c03-transition.tm>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|bib>
      paritytech_genesis_state

      w3f_research_group_blind_2019

      david_ouroboros_2018

      stewart_grandpa:_2019

      ??

      ??

      polkadot-crypto-spec

      saarinen_blake2_2015

      burdges_schnorr_2019

      josefsson_edwards-curve_2017

      paritytech_genesis_state
    </associate>
    <\associate|figure>
      <tuple|normal|<\surround|<hidden-binding|<tuple>|6.1>|>
        Examplary result of Median Algorithm in first sync epoch with
        <with|mode|<quote|math>|s<rsub|cq>=9> and
        <with|mode|<quote|math>|k=1>.
      </surround>|<pageref|auto-101>>

      <tuple|normal|<surround|<hidden-binding|<tuple>|7.1>||Overall process
      to acheive availability and validity in Polkadot>|<pageref|auto-127>>

      <tuple|normal|<surround|<hidden-binding|<tuple>|8.1>||Parachain Message
      Passing Overview>|<pageref|auto-152>>

      <tuple|normal|<surround|<hidden-binding|<tuple>|8.2>||Message Queue
      Chain Overview>|<pageref|auto-154>>

      <tuple|normal|<surround|<hidden-binding|<tuple>|8.3>||Parachain XCMP
      Overview>|<pageref|auto-166>>
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
      <tuple|<tuple|Transaction Message>|<pageref|auto-51>>

      <tuple|<tuple|transaction pool>|<pageref|auto-52>>

      <tuple|<tuple|transaction queue>|<pageref|auto-53>>
    </associate>
    <\associate|parts>
      <tuple|c01-background.tm|chapter-nr|0|section-nr|0|subsection-nr|0>

      <tuple|c02-state.tm|chapter-nr|1|section-nr|2|subsection-nr|1>

      <tuple|c03-transition.tm|chapter-nr|2|section-nr|2|subsection-nr|1>

      <tuple|c04-networking.tm|chapter-nr|3|section-nr|3|subsection-nr|4>

      <tuple|c04a-networking.tm|chapter-nr|4|section-nr|1|subsection-nr|7>

      <tuple|c05-bootstrapping.tm|chapter-nr|4|section-nr|1|subsection-nr|7>

      <tuple|c06-consensus.tm|chapter-nr|5|section-nr|0|subsection-nr|7>

      <tuple|c07-anv.tm|chapter-nr|6|section-nr|4|subsection-nr|1>

      <tuple|c08-messaging.tm|chapter-nr|7|section-nr|12|subsection-nr|3>

      <tuple|aa-cryptoalgorithms.tm|chapter-nr|8|section-nr|5|subsection-nr|0>

      <tuple|ab-encodings.tm|chapter-nr|8|section-nr|5|subsection-nr|5>

      <tuple|ac-genesis.tm|chapter-nr|8|section-nr|2|subsection-nr|0>

      <tuple|ad-netmessages.tm|chapter-nr|8|section-nr|0|subsection-nr|0>

      <tuple|ae-hostapi.tm|chapter-nr|8|section-nr|0|subsection-nr|0>

      <tuple|af-legacyhostapi.tm|chapter-nr|8|section-nr|0|subsection-nr|0>

      <tuple|ag-runtimeentries.tm|chapter-nr|8|section-nr|0|subsection-nr|0>
    </associate>
    <\associate|table>
      <tuple|normal|<\surround|<hidden-binding|<tuple>|3.1>|>
        List of inherent data
      </surround>|<pageref|auto-55>>

      <tuple|normal|<surround|<hidden-binding|<tuple>|3.2>||The detail of the
      varying type that a digest item can hold.>|<pageref|auto-59>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|3.3>|>
        Possible types of keys of mappings in the Changes Trie
      </surround>|<pageref|auto-65>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|4.1>|>
        <with|font-family|<quote|tt>|language|<quote|verbatim>|BlockRequest>
        Protobuf message.
      </surround>|<pageref|auto-80>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|4.2>|>
        Bits of block data to be requested.
      </surround>|<pageref|auto-81>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|4.3>|>
        Protobuf message indicating the block to start from.
      </surround>|<pageref|auto-82>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|4.4>|>
        <with|font-family|<quote|tt>|language|<quote|verbatim>|Direction>
        Protobuf structure.
      </surround>|<pageref|auto-83>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|4.5>|>
        <with|font-family|<quote|tt>|language|<quote|verbatim>|BlockResponse>
        Protobuf message.
      </surround>|<pageref|auto-84>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|4.6>|>
        <with|font-series|<quote|bold>|math-font-series|<quote|bold>|BlockData>
        Protobuf structure.
      </surround>|<pageref|auto-85>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|6.1>|>
        The consensus digest item for BABE authorities
      </surround>|<pageref|auto-95>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|6.2>|>
        The consensus digest item for GRANDPA authorities
      </surround>|<pageref|auto-96>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|6.3>|>
        \;
      </surround>|<pageref|auto-109>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|6.4>|>
        Signature for a message in a round.
      </surround>|<pageref|auto-111>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|A.1>|>
        List of public key scheme which can be used for an account key
      </surround>|<pageref|auto-177>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|A.2>|>
        List of key schemes which are used for session keys depending on the
        protocol
      </surround>|<pageref|auto-178>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|C.1>|>
        Genesis header values
      </surround>|<pageref|auto-189>>
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
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-39>>

      <with|par-left|<quote|1tab>|3.1.2.<space|2spc>Code Executor
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-40>>

      <with|par-left|<quote|2tab>|3.1.2.1.<space|2spc>Access to Runtime API
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-41>>

      <with|par-left|<quote|2tab>|3.1.2.2.<space|2spc>Memory Management
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-42>>

      <with|par-left|<quote|2tab>|3.1.2.3.<space|2spc>Sending Arguments to
      Runtime \ <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-43>>

      <with|par-left|<quote|2tab>|3.1.2.4.<space|2spc>The Return Value from a
      Runtime Entry <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-44>>

      <with|par-left|<quote|2tab>|3.1.2.5.<space|2spc>Handling Runtimes
      update to the State <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-45>>

      3.2.<space|2spc>Extrinsics <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-46>

      <with|par-left|<quote|1tab>|3.2.1.<space|2spc>Preliminaries
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-47>>

      <with|par-left|<quote|1tab>|3.2.2.<space|2spc>Transactions
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-48>>

      <with|par-left|<quote|2tab>|3.2.2.1.<space|2spc>Transaction Submission
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-49>>

      <with|par-left|<quote|1tab>|3.2.3.<space|2spc>Transaction Queue
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-50>>

      <with|par-left|<quote|2tab>|3.2.3.1.<space|2spc>Inherents
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-54>>

      3.3.<space|2spc>State Replication <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-56>

      <with|par-left|<quote|1tab>|3.3.1.<space|2spc>Block Format
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-57>>

      <with|par-left|<quote|2tab>|3.3.1.1.<space|2spc>Block Header
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-58>>

      <with|par-left|<quote|2tab>|3.3.1.2.<space|2spc>Justified Block Header
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-60>>

      <with|par-left|<quote|2tab>|3.3.1.3.<space|2spc>Block Body
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-61>>

      <with|par-left|<quote|1tab>|3.3.2.<space|2spc>Importing and Validating
      Block <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-62>>

      <with|par-left|<quote|1tab>|3.3.3.<space|2spc>Managaing Multiple
      Variants of State <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-63>>

      <with|par-left|<quote|1tab>|3.3.4.<space|2spc>Changes Trie
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-64>>

      <with|par-left|<quote|2tab>|3.3.4.1.<space|2spc>Key to extrinsics pairs
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-66>>

      <with|par-left|<quote|2tab>|3.3.4.2.<space|2spc>Key to block pairs
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-67>>

      <with|par-left|<quote|2tab>|3.3.4.3.<space|2spc>Key to Child Changes
      Trie pairs <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-68>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|4.<space|2spc>Networking>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-69><vspace|0.5fn>

      4.1.<space|2spc>Introduction <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-70>

      <with|par-left|<quote|1tab>|4.1.1.<space|2spc>External Documentation
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-71>>

      <with|par-left|<quote|1tab>|4.1.2.<space|2spc>Node Identities
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-72>>

      <with|par-left|<quote|1tab>|4.1.3.<space|2spc>Discovery mechanism
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-73>>

      <with|par-left|<quote|1tab>|4.1.4.<space|2spc>Connection establishment
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-74>>

      <with|par-left|<quote|1tab>|4.1.5.<space|2spc>Encryption Layer
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-75>>

      <with|par-left|<quote|1tab>|4.1.6.<space|2spc>Protocols and Substreams
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-76>>

      <with|par-left|<quote|1tab>|4.1.7.<space|2spc>Network Messages
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-77>>

      <with|par-left|<quote|2tab>|4.1.7.1.<space|2spc>Announcing blocks
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-78>>

      <with|par-left|<quote|2tab>|4.1.7.2.<space|2spc>Requesting blocks
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-79>>

      <with|par-left|<quote|2tab>|4.1.7.3.<space|2spc>Transactions
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-86>>

      <with|par-left|<quote|2tab>|4.1.7.4.<space|2spc>GRANDPA Votes
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-87>>

      <with|par-left|<quote|2tab>|4.1.7.5.<space|2spc>GRANDPA Equivocation
      Proof <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-88>>

      <with|par-left|<quote|2tab>|4.1.7.6.<space|2spc>BABE Equivocation Proof
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-89>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|5.<space|2spc>Bootstrapping>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-90><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|6.<space|2spc>Consensus>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-91><vspace|0.5fn>

      6.1.<space|2spc>Common Consensus Structures
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-92>

      <with|par-left|<quote|1tab>|6.1.1.<space|2spc>Consensus Authority Set
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-93>>

      <with|par-left|<quote|1tab>|6.1.2.<space|2spc>Runtime-to-Consensus
      Engine Message <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-94>>

      6.2.<space|2spc>Block Production <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-97>

      <with|par-left|<quote|1tab>|6.2.1.<space|2spc>Preliminaries
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-98>>

      <with|par-left|<quote|1tab>|6.2.2.<space|2spc>Block Production Lottery
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-99>>

      <with|par-left|<quote|1tab>|6.2.3.<space|2spc>Slot Number Calculation
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-100>>

      <with|par-left|<quote|1tab>|6.2.4.<space|2spc>Block Production
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-102>>

      <with|par-left|<quote|1tab>|6.2.5.<space|2spc>Epoch Randomness
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-103>>

      <with|par-left|<quote|1tab>|6.2.6.<space|2spc>Verifying Authorship
      Right <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-104>>

      <with|par-left|<quote|1tab>|6.2.7.<space|2spc>Block Building Process
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-105>>

      6.3.<space|2spc>Finality <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-106>

      <with|par-left|<quote|1tab>|6.3.1.<space|2spc>Preliminaries
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-107>>

      <with|par-left|<quote|1tab>|6.3.2.<space|2spc>GRANDPA Messages
      Specification <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-108>>

      <with|par-left|<quote|2tab>|6.3.2.1.<space|2spc>Vote Messages
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-110>>

      <with|par-left|<quote|2tab>|6.3.2.2.<space|2spc>Finalizing Message
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-112>>

      <with|par-left|<quote|2tab>|6.3.2.3.<space|2spc>Catch-up Messages
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-113>>

      <with|par-left|<quote|1tab>|6.3.3.<space|2spc>Initiating the GRANDPA
      State <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-114>>

      <with|par-left|<quote|2tab>|6.3.3.1.<space|2spc>Voter Set Changes
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-115>>

      <with|par-left|<quote|1tab>|6.3.4.<space|2spc>Voting Process in Round
      <with|mode|<quote|math>|r> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-116>>

      6.4.<space|2spc>Block Finalization <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-117>

      <with|par-left|<quote|1tab>|6.4.1.<space|2spc>Catching up
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-118>>

      <with|par-left|<quote|2tab>|6.4.1.1.<space|2spc>Sending catch-up
      requests <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-119>>

      <with|par-left|<quote|2tab>|6.4.1.2.<space|2spc>Processing catch-up
      requests <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-120>>

      <with|par-left|<quote|2tab>|6.4.1.3.<space|2spc>Processing catch-up
      responses <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-121>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|7.<space|2spc>Availability
      & Validity> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-122><vspace|0.5fn>

      7.1.<space|2spc>Introduction <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-123>

      7.2.<space|2spc>Preliminaries <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-124>

      <with|par-left|<quote|1tab>|7.2.1.<space|2spc>Extra Validation Data
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-125>>

      7.3.<space|2spc>Overal process <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-126>

      7.4.<space|2spc>Candidate Selection
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-128>

      7.5.<space|2spc>Candidate Backing <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-129>

      <with|par-left|<quote|1tab>|7.5.1.<space|2spc>Inclusion of candidate
      receipt on the relay chain <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-130>>

      7.6.<space|2spc>PoV Distribution <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-131>

      <with|par-left|<quote|1tab>|7.6.1.<space|2spc>Primary Validation
      Disagreement <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-132>>

      7.7.<space|2spc>Availability <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-133>

      7.8.<space|2spc>Distribution of Chunks
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-134>

      7.9.<space|2spc>Announcing Availability
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-135>

      <with|par-left|<quote|1tab>|7.9.1.<space|2spc>Processing on-chain
      availability data <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-136>>

      7.10.<space|2spc>Publishing Attestations
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-137>

      7.11.<space|2spc>Secondary Approval checking
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-138>

      <with|par-left|<quote|1tab>|7.11.1.<space|2spc>Approval Checker
      Assignment <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-139>>

      <with|par-left|<quote|1tab>|7.11.2.<space|2spc>VRF computation
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-140>>

      <with|par-left|<quote|1tab>|7.11.3.<space|2spc>One-Shot Approval
      Checker Assignment <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-141>>

      <with|par-left|<quote|1tab>|7.11.4.<space|2spc>Extra Approval Checker
      Assigment <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-142>>

      <with|par-left|<quote|1tab>|7.11.5.<space|2spc>Additional Checking in
      Case of Equivocation <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-143>>

      7.12.<space|2spc>The Approval Check
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-144>

      <with|par-left|<quote|2tab>|7.12.0.1.<space|2spc>Retrieval
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-145>>

      <with|par-left|<quote|2tab>|7.12.0.2.<space|2spc>Reconstruction
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-146>>

      <with|par-left|<quote|1tab>|7.12.1.<space|2spc>Verification
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-147>>

      <with|par-left|<quote|1tab>|7.12.2.<space|2spc>Process validity and
      invalidity messages <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-148>>

      <with|par-left|<quote|1tab>|7.12.3.<space|2spc>Invalidity Escalation
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-149>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|8.<space|2spc>Message
      Passing> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-150><vspace|0.5fn>

      8.1.<space|2spc>Overview <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-151>

      8.2.<space|2spc>Message Queue Chain (MQC)
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-153>

      8.3.<space|2spc>HRMP <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-155>

      <with|par-left|<quote|1tab>|8.3.1.<space|2spc>Channels
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-156>>

      <with|par-left|<quote|1tab>|8.3.2.<space|2spc>Opening Channels
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-157>>

      <with|par-left|<quote|2tab>|8.3.2.1.<space|2spc>Workflow
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-158>>

      <with|par-left|<quote|1tab>|8.3.3.<space|2spc>Accepting Channels
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-159>>

      <with|par-left|<quote|2tab>|8.3.3.1.<space|2spc>Workflow
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-160>>

      <with|par-left|<quote|1tab>|8.3.4.<space|2spc>Closing Channels
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-161>>

      <with|par-left|<quote|1tab>|8.3.5.<space|2spc>Workflow
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-162>>

      <with|par-left|<quote|1tab>|8.3.6.<space|2spc>Sending messages
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-163>>

      <with|par-left|<quote|1tab>|8.3.7.<space|2spc>Receiving Messages
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-164>>

      8.4.<space|2spc>XCMP <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-165>

      <with|par-left|<quote|1tab>|8.4.1.<space|2spc>CST: Channel State Table
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-167>>

      <with|par-left|<quote|1tab>|8.4.2.<space|2spc>Message content
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-168>>

      <with|par-left|<quote|1tab>|8.4.3.<space|2spc>Watermark
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-169>>

      8.5.<space|2spc>SPREE <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-170>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Appendix
      A.<space|2spc>Cryptographic Algorithms>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-171><vspace|0.5fn>

      A.1.<space|2spc>Hash Functions <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-172>

      A.2.<space|2spc>BLAKE2 <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-173>

      A.3.<space|2spc>Randomness <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-174>

      A.4.<space|2spc>VRF <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-175>

      A.5.<space|2spc>Cryptographic Keys <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-176>

      <with|par-left|<quote|1tab>|A.5.1.<space|2spc>Holding and staking funds
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-179>>

      <with|par-left|<quote|1tab>|A.5.2.<space|2spc>Creating a Controller key
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-180>>

      <with|par-left|<quote|1tab>|A.5.3.<space|2spc>Designating a proxy for
      voting <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-181>>

      <with|par-left|<quote|1tab>|A.5.4.<space|2spc>Controller settings
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-182>>

      <with|par-left|<quote|1tab>|A.5.5.<space|2spc>Certifying keys
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-183>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Appendix
      B.<space|2spc>Auxiliary Encodings> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-184><vspace|0.5fn>

      B.1.<space|2spc>SCALE Codec <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-185>

      <with|par-left|<quote|1tab>|B.1.1.<space|2spc>Length and Compact
      Encoding <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-186>>

      B.2.<space|2spc>Hex Encoding <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-187>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Appendix
      C.<space|2spc>Genesis State Specification>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-188><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Glossary>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-190><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Bibliography>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-191><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Index>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-192><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>