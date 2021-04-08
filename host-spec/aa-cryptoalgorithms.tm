<TeXmacs|1.99.18>

<project|host-spec.tm>

<style|<tuple|tmbook|algorithmacs-style>>

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
  Appendix <reference|sect-host-api>. Session keys are <em|not> meant to
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
