<TeXmacs|1.99.12>

<project|host-spec.tm>

<style|book>

<\body>
  <appendix|Cryptographic Algorithms>

  <section|Hash Functions><label|sect-hash-functions>

  <section|BLAKE2><label|sect-blake2>

  BLAKE2 is a collection of cryptographic hash functions known for their high
  speed. their design closely resembles BLAKE which has been a finalist in
  SHA-3 competition.

  Polkadot is using Blake2b variant which is optimized for 64bit platforms.
  Unless otherwise specified, Blake2b hash function with 256bit output is
  used whenever Blake2b is invoked in this document. The detailed
  specification and sample implementations of all variants of Blake2 hash
  functions can be found in RFC 7693 <cite|saarinen_blake2_2015>.

  <section|Randomness><label|sect-randomness>

  <section|VRF><label|sect-vrf>

  <section|Cryptographic Keys><label|sect-cryptographic-keys>

  Various types of keys are used in Polkadot to prove the identity of the
  actors involved in Polkadot Protocols. To improve the security of the
  users, each key type has its own unique function and must be treated
  differently, as described by this section.

  <\definition>
    <label|defn-account-key><strong|Account key
    <math|<around*|(|sk<rsup|a>,pk<rsup|a>|)>>> is a key pair of type of
    either of schemes listed in Table <reference|tabl-account-key-schemes>:

    <\center>
      <\big-table|<tabular|<tformat|<cwith|1|-1|1|-1|cell-tborder|0ln>|<cwith|1|-1|1|-1|cell-bborder|0ln>|<cwith|1|-1|1|-1|cell-lborder|0ln>|<cwith|1|-1|1|-1|cell-rborder|0ln>|<cwith|4|4|1|-1|cell-bborder|1ln>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-rborder|0ln>|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|2|2|cell-rborder|0ln>|<twith|table-halign|l>|<table|<row|<cell|Key
      scheme>|<cell|Description>>|<row|<cell|SR25519>|<cell|Schnorr signature
      on Ristretto compressed Ed25519 points as implemented in
      <cite|burdges_schnorr_2019>>>|<row|<cell|ED25519>|<cell|The standard
      ED25519 signature complying with <cite|josefsson_edwards-curve_2017>>>|<row|<cell|secp256k1>|<cell|Only
      for outgoing transfer transactions>>>>>>
        <label|tabl-account-key-schemes>List of public key scheme which can
        be used for an account key
      </big-table>
    </center>

    Account key can be used to sign transactions among other accounts and
    blance-related functions.
  </definition>

  There are two prominent subcategories of account keys namely \Pstash keys\Q
  and \Pcontroller keys\Q, each being used for a different function as
  described below.

  <\definition>
    The <label|defn-stash-key><strong|Stash key> is a type of an account key
    that holds funds bonded for staking (described in Section
    <reference|sect-staking-funds>) to a particular controller key (defined
    in Definition <reference|defn-controller-key>). As a result, one may
    actively participate with a stash key keeping the stash key offline in a
    secure location. It can also be used to designate a Proxy account to vote
    in governance proposals, as described in
    <reference|sect-creating-controller-key>. The Stash key holds the
    majority of the users' funds and should neither be shared with anyone,
    saved on an online device, nor used to submit extrinsics.
  </definition>

  <\definition>
    <label|defn-controller-key>The <strong|Controller key> is a type of
    account key that acts on behalf of the Stash account. It signs
    transactions that make decisions regarding the nomination and the
    validation of other keys. It is a key that will be in the direct control
    of a user and should mostly be kept offline, used to submit manual
    extrinsics. It sets preferences like payout account and commission, as
    described in <reference|sect-controller-settings>. If used for a
    validator, it certifies the session keys, as described in
    <reference|sect-certifying-keys>. It only needs the required funds to pay
    transaction fees <todo|key needing fund needs to be defined>.
  </definition>

  \ Keys defined in Definitions <reference|defn-account-key>,
  <reference|defn-stash-key> and <reference|defn-controller-key> are created
  and managed by the user independent of the Polkadot implementation. The
  user notifies the network about the used keys by submitting a transaction,
  as defined in <reference|sect-creating-controller-key> and
  <reference|sect-certifying-keys> respectively.

  <\definition>
    <label|defn-session-key><strong|Session keys> are short-lived keys that
    are used to authenticate validator operations. Session keys are generated
    by the Polkadot Host and should be changed regularly due to security
    reasons. Nonetheless, no validity period is enforced by Polkadot protocol
    on session keys. Various types of keys used by the Polkadot Host are
    presented in Table <reference|tabl-session-keys><em|:>

    <\big-table|<tabular|<tformat|<cwith|5|5|1|-1|cell-tborder|0ln>|<cwith|4|4|1|-1|cell-bborder|0ln>|<cwith|5|5|1|-1|cell-bborder|1ln>|<cwith|5|5|1|1|cell-lborder|0ln>|<cwith|5|5|2|2|cell-rborder|0ln>|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-lborder|0ln>|<cwith|1|1|2|2|cell-rborder|0ln>|<cwith|1|1|2|2|cell-width|100>|<cwith|1|1|2|2|cell-hmode|max>|<table|<row|<cell|Protocol>|<cell|Key
    scheme>>|<row|<cell|GRANDPA>|<cell|ED25519>>|<row|<cell|BABE>|<cell|SR25519>>|<row|<cell|I'm
    Online>|<cell|SR25519>>|<row|<cell|Parachain>|<cell|SR25519>>>>>>
      <label|tabl-session-keys>List of key schemes which are used for session
      keys depending on the protocol
    </big-table>
  </definition>

  Session keys must be accessible by certain Polkadot Host APIs defined in
  Appendix <reference|sect-re-api>. Session keys are <em|not> meant to
  control the majority of the users' funds and should only be used for their
  intended purpose. <todo|key managing fund need to be defined>

  <subsection|Holding and staking funds><label|sect-staking-funds>

  To be specced

  <subsection|Creating a Controller key><label|sect-creating-controller-key>

  To be specced

  <subsection|Designating a proxy for voting><label|sect-designating-proxy>

  To be specced

  <subsection|Controller settings><label|sect-controller-settings>

  To be specced

  <subsection|Certifying keys><label|sect-certifying-keys>

  Session keys should be changed regularly. As such, new session keys need to
  be certified by a controller key before putting in use. The controller only
  needs to create a certificate by signing a session public key and
  broadcastg this certificate via an extrinsic. <todo|spec the detail of the
  data structure of the certificate etc.>

 \;
 
 <\with|par-mode|right>
    <qed>
  </with>

  \;
</body>

<\initial>
  <\collection>
    <associate|page-height|auto>
    <associate|page-type|letter>
    <associate|page-width|auto>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|A|?|c01-background.tm>>
    <associate|auto-10|<tuple|A.5.2|?|c01-background.tm>>
    <associate|auto-11|<tuple|A.5.3|?|c01-background.tm>>
    <associate|auto-12|<tuple|A.5.4|?|c01-background.tm>>
    <associate|auto-13|<tuple|A.5.5|?|c01-background.tm>>
    <associate|auto-2|<tuple|A.1|?|c01-background.tm>>
    <associate|auto-3|<tuple|A.2|?|c01-background.tm>>
    <associate|auto-4|<tuple|A.3|?|c01-background.tm>>
    <associate|auto-5|<tuple|A.4|?|c01-background.tm>>
    <associate|auto-6|<tuple|A.5|?|c01-background.tm>>
    <associate|auto-7|<tuple|A.1|?|c01-background.tm>>
    <associate|auto-8|<tuple|A.2|?|c01-background.tm>>
    <associate|auto-9|<tuple|A.5.1|?|c01-background.tm>>
    <associate|defn-account-key|<tuple|A.1|?|c01-background.tm>>
    <associate|defn-controller-key|<tuple|A.3|?|c01-background.tm>>
    <associate|defn-session-key|<tuple|A.4|?|c01-background.tm>>
    <associate|defn-stash-key|<tuple|A.2|?|c01-background.tm>>
    <associate|sect-blake2|<tuple|A.2|?|c01-background.tm>>
    <associate|sect-certifying-keys|<tuple|A.5.5|?|c01-background.tm>>
    <associate|sect-controller-settings|<tuple|A.5.4|?|c01-background.tm>>
    <associate|sect-creating-controller-key|<tuple|A.5.2|?|c01-background.tm>>
    <associate|sect-cryptographic-keys|<tuple|A.5|?|c01-background.tm>>
    <associate|sect-designating-proxy|<tuple|A.5.3|?|c01-background.tm>>
    <associate|sect-hash-functions|<tuple|A.1|?|c01-background.tm>>
    <associate|sect-randomness|<tuple|A.3|?|c01-background.tm>>
    <associate|sect-staking-funds|<tuple|A.5.1|?|c01-background.tm>>
    <associate|sect-vrf|<tuple|A.4|?|c01-background.tm>>
    <associate|tabl-account-key-schemes|<tuple|A.1|?|c01-background.tm>>
    <associate|tabl-session-keys|<tuple|A.2|?|c01-background.tm>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|bib>
      saarinen_blake2_2015

      burdges_schnorr_2019

      josefsson_edwards-curve_2017
    </associate>
    <\associate|table>
      <tuple|normal|<\surround|<hidden-binding|<tuple>|A.1>|>
        List of public key scheme which can be used for an account key
      </surround>|<pageref|auto-7>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|A.2>|>
        List of key schemes which are used for session keys depending on the
        protocol
      </surround>|<pageref|auto-8>>
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Appendix
      A<space|2spc>Cryptographic Algorithms>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      A.1<space|2spc>Hash Functions <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>

      A.2<space|2spc>BLAKE2 <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>

      A.3<space|2spc>Randomness <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>

      A.4<space|2spc>VRF <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5>

      A.5<space|2spc>Cryptographic Keys <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>

      <with|par-left|<quote|1tab>|A.5.1<space|2spc>Holding and staking funds
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>>

      <with|par-left|<quote|1tab>|A.5.2<space|2spc>Creating a Controller key
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10>>

      <with|par-left|<quote|1tab>|A.5.3<space|2spc>Designating a proxy for
      voting <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-11>>

      <with|par-left|<quote|1tab>|A.5.4<space|2spc>Controller settings
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-12>>

      <with|par-left|<quote|1tab>|A.5.5<space|2spc>Certifying keys
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-13>>
    </associate>
  </collection>
</auxiliary>