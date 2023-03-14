---
title: "Appendix A: Cryptography & Encoding"
---

Appendix chapter containing various protocol details

## [](#chapter-crypto-algos)[A.1. Cryptographic Algorithms](#chapter-crypto-algos)

### [](#sect-hash-functions)[A.1.1. Hash Functions](#sect-hash-functions)

#### [](#sect-blake2)[A.1.1.1. BLAKE2](#sect-blake2)

BLAKE2 is a collection of cryptographic hash functions known for their high speed. Their design closely resembles BLAKE which has been a finalist in the SHA-3 competition.

Polkadot is using the Blake2b variant which is optimized for 64-bit platforms. Unless otherwise specified, the Blake2b hash function with a 256-bit output is used whenever Blake2b is invoked in this document. The detailed specification and sample implementations of all variants of Blake2 hash functions can be found in RFC 7693 cite:\[saarinen_blake2_2015\].

### [](#sect-randomness)[A.1.2. Randomness](#sect-randomness)

|     |     |
|-----|-----|
|     | TBH |

### [](#sect-vrf)[A.1.3. VRF](#sect-vrf)

A Verifiable Random Function (VRF) is a mathematical operation that takes some input and produces a random number using a secret key along with a proof of authenticity that this random number was generated using the submitter’s secret key and the given input. The proof can be verified by any challenger to ensure the random number generation is valid and has not been tampered with (for example to the benfit of submitter).

In Polkadot, VRFs are used for the BABE block production lottery by [Block-Production-Lottery](sect-block-production.html#algo-block-production-lottery) and the parachain approval voting mechanism ([Section 8.5](chapter-anv.html#sect-approval-voting)). The VRF uses mechanism similar to algorithms introduced in the following papers:

- [Making NSEC5 Practical for DNSSEC](https://eprint.iacr.org/2017/099.pdf) cite:\[papadopoulos17\]

- [DLEQ Proofs](https://blog.cloudflare.com/privacy-pass-the-math/#dleqproofs)

- [Verifiable Random Functions (VRFs)](https://tools.ietf.org/id/draft-goldbe-vrf-01.html) cite:\[goldberg17\]

It essentially generates a deterministic elliptic curve based Schnorr signature as a verifiable random value. The elliptic curve group used in the VRF function is the Ristretto group specified in:

- [ristretto.group/](https://ristretto.group/)

Definition 171. [VRF Proof](id-cryptography-encoding.html#defn-vrf-proof)

The **VRF proof** proves the correctness for an associated VRF output. The VRF proof, $P$, is a datastructure of the following format:

$P = (C,S)$ $S = (b_0, ... b_31)$

where $C$ is the challenge and $S$ is the 32-byte Schnorr poof. Both are expressed as Curve25519 scalars as defined in Definition [Definition 172](id-cryptography-encoding.html#defn-vrf-dleq-prove).

Definition 172. [`DLEQ Prove`](id-cryptography-encoding.html#defn-vrf-dleq-prove)

The $"dleq_prove"(t, i)$ function creates a proof for a given input, $i$, based on the provided transcript, $T$.

First:

$t_1 = "append"(t, "'proto-name'", "'DLEQProof'")$ $t_2 = "append"(t_1, "'vrf:h'", i)$

Then the witness scalar is calculated, $s_w$, where $w$ is the 32-byte secret seed used for nonce generation in the context of sr25519.

$t_3 = "meta-AD"(t_2, "'proving$00'", "more=False")$ $t_4 = "meta-AD"(t_3, w_l, "more=True")$ $t_5 = "KEY"(t_4, w, "more=False")$ $t_6 = "meta-AD"(t_5, "'rng'", "more=False")$ $t_7 = "KEY"(t_6, r, "more=False")$ $t_8 = "meta-AD"(t_7, e\_(64), "more=False")$ $(phi, s_w) = "PRF"(t_8, "more=False")$

where $w_l$ is length of the witness, encoded as a 32-bit little-endian integer. $r$ is a 32-byte array containing the secret witness scalar.

$l_1 = "append"(t_2, "'vrf:R=g^r'", s_w)$ $l_2 = "append"(l_1, "'vrf:h^r'", s_i)$ $l_3 = "append"(l_2, "'vrf:pk'", s_p)$ $l_4 = "append"(l_3, "'vrf:h^sk'", "vrf"\_o)$

where

- $s_i$ is the compressed Ristretto point of the scalar input.

- $s_p$ is the compressed Ristretto point of the public key.

- $s_w$ is the compressed Ristretto point of the wittness:

For the 64-byte challenge:

$l_5 = "meta-AD"(l_4, "'prove'", "more=False")$ $l_6 = "meta-AD"(l_5, e\_(64), "more=True")$ $C = "PRF"(l_6, "more=False")$

And the Schnorr proof:

$S = s_w - (C \* p)$

where $p$ is the secret key.

Definition 173. [`DLEQ Verify`](id-cryptography-encoding.html#defn-vrf-dleq-verify)

The $"dleq_verify"(i, o, P, p_k)$ function verifiers the VRF input, $i$ against the output, $o$, with the associated proof ([Definition 171](id-cryptography-encoding.html#defn-vrf-proof)) and public key, $p_k$.

$t_1 = "append"(t, "'proto-name'", "'DLEQProof'")$ $t_2 = "append"(t_1, "'vrf:h'", s_i)$ $t_3 = "append"(t_2, "'vrf:R=g^r'", R)$ $t_4 = "append"(t_3, "'vrf:h^r'", H)$ $t_5 = "append"(t_4, "'vrf:pk'", p_k)$ $t_6 = "append"(t_5, "'vrf:h^sk'", o)$

where

- $R$ is calculated as:

  $R = C in P xx p_k + S in P + B$

  where $B$ is the Ristretto basepoint.

- $H$ is calculated as:

  $H = C in P xx o + S in P xx i$

The challenge is valid if $C in P$ equals $y$:

$t_7 = "meta-AD"(t_6, "'prove'", "more=False")$ $t_8 = "meta-AD"(t_7, e\_(64), "more=True")$ $y = "PRF"(t_8, "more=False")$

#### [](#id-transcript)[A.1.3.1. Transcript](#id-transcript)

A VRF transcript serves as a domain-specific separator of cryptographic protocols and is represented as a mathematical object, as defined by Merlin, which defines how that object is generated and encoded. The usage of the transcript is implementation specific, such as for certain mechanisms in the Availability & Validity chapter ([Chapter 8](chapter-anv.html)), and is therefore described in more detail in those protocols. The input value used to initiate the transcript is referred to as a *context* ([Definition 174](id-cryptography-encoding.html#defn-vrf-context)).

Definition 174. [VRF Contex](id-cryptography-encoding.html#defn-vrf-context)

The **VRF context** is a constant byte array used to initiate VRF transcript. The VRF context is constant for all users of the VRF for the specific context for which the VRF function is used. Context prevents VRF values generated by the same nodes for other purposes to be reused for purposes not meant to. For example, the VRF context for BABE Production lottery defined in [Section 5.2](sect-block-production.html#sect-block-production-lottery) is set to be "substrate-babe-vrf".

Definition 175. [VRF Transcript](id-cryptography-encoding.html#defn-vrf-transcript)

A **transcript**, or VRF transcript, is a STROBE object, $"obj"$, as defined in the STROBE documentation, respectively section ["5. State of a STROBE object"](https://strobe.sourceforge.io/specs/#object).

$"obj" = ("st","pos","pos"\_("begin"),I_0)$

where:

- The duplex state, $"st"$, is a 200-byte array created by the [keccak-f1600 sponge function](https://keccak.team/keccak_specs_summary.html) on the [initial STROBE state](https://strobe.sourceforge.io/specs/#object.initial). Specifically, `R` is of value `166` and `X.Y.Z` is of value `1.0.2`.

- $"pos"$ has the initial value of `0`.

- $"pos"\_("begin")$ has the initial value of `0`.

- $I_0$ has the initial value of `0`.

Then, the `meta-AD` operation ([Definition 176](id-cryptography-encoding.html#defn-strobe-operations)) (where `more=False`) is used to add the protocol label `Merlin v1.0` to $"obj"$ followed by *appending* ([Section A.1.3.1.1](id-cryptography-encoding.html#sect-vrf-appending-messages)) label `dom-step` and its corresponding context, $ctx$, resulting in the final transcript, $T$.

$t = "meta-AD"(obj, "'Merlin v1.0'", "False")$ $T = "append"(t, "'dom-step'", "ctx")$

$"ctx"$ serves as an arbitrary identifier/separator and its value is defined by the protocol specification individually. This transcript is treated just like a STROBE object, wherein any operations ([Definition 176](id-cryptography-encoding.html#defn-strobe-operations)) on it modify the values such as $"pos"$ and $"pos"\_("begin")$.

Formally, when creating a transcript we refer to it as $"Transcript"(ctx)$.

Definition 176. [STROBE Operations](id-cryptography-encoding.html#defn-strobe-operations)

STROBE operations are described in the [STROBE specification](https://strobe.sourceforge.io/specs/), respectively section ["6. Strobe operations"](https://strobe.sourceforge.io/specs/#ops). Operations are indicated by their corresponding bitfield, as described in section ["6.2. Operations and flags"](https://strobe.sourceforge.io/specs/#ops.flags) and implemented as described in section ["7. Implementation of operations"](https://strobe.sourceforge.io/specs/#ops.impl)

##### [](#sect-vrf-appending-messages)[Appending Messages](#sect-vrf-appending-messages)

Appending messages, or "data", to the transcript ([Definition 175](id-cryptography-encoding.html#defn-vrf-transcript)) first requires `meta-AD` operations for a given label of the messages, including the size of the message, followed by an `AD` operation on the message itself. The size of the message is a 4-byte, little-endian encoded integer.

$T_0 = "meta-AD"(T, l, "False")$ $T_1 = "meta-AD"(T_0, m_l, "True")$ $T_2 = "AD"(T_1, m, "False")$

where $T$ is the transcript ([Definition 175](id-cryptography-encoding.html#defn-vrf-transcript)), $l$ is the given label and $m$ the message, respectively $m_l$ representing its size. $T_2$ is the resulting transcript with the appended data. STROBE operations are described in [Definition 176](id-cryptography-encoding.html#defn-strobe-operations).

Formally, when appending a message we refer to it as $"append"(T, l, m)$.

### [](#sect-cryptographic-keys)[A.1.4. Cryptographic Keys](#sect-cryptographic-keys)

Various types of keys are used in Polkadot to prove the identity of the actors involved in the Polkadot Protocols. To improve the security of the users, each key type has its own unique function and must be treated differently, as described by this Section.

Definition 177. [Account Key](id-cryptography-encoding.html#defn-account-key)

**Account key $(sk^a,pk^a)$** is a key pair of type of either of the schemes in the following table:

| Key Scheme | Description                                                                                                                                                                                                                                                                                                                                                                                                       |
|------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| sr25519    | Schnorr signature on Ristretto compressed ed25519 points as implemented in TODO                                                                                                                                                                                                                                                                                                                                   |
| ed25519    | The ed25519 signature complies with cite:\[josefsson_edwards-curve_2017\] except for the verification process which adhere to Ed25519 Zebra variant specified in cite:\[devalence_ed25519zebra_2020\]. In short, the signature point is not assumed to be on in the prime ordered subgroup group. As such, the verifier must explicitly clear the cofactor during the course of verifying the signature equation. |
| secp256k1  | Only for outgoing transfer transactions.                                                                                                                                                                                                                                                                                                                                                                          |

Table 2. List of the public key scheme which can be used for an account key

An account key can be used to sign transactions among other accounts and balance-related functions. There are two prominent subcategories of account keys namely "stash keys" and "controller keys", each being used for a different function. Keys defined in [Definition 177](id-cryptography-encoding.html#defn-account-key), [Definition 178](id-cryptography-encoding.html#defn-stash-key) and [Definition 179](id-cryptography-encoding.html#defn-controller-key) are created and managed by the user independent of the Polkadot implementation. The user notifies the network about the used keys by submitting a transaction, as defined in [Section A.1.4.2](id-cryptography-encoding.html#sect-creating-controller-key) and [Section A.1.4.5](id-cryptography-encoding.html#sect-certifying-keys) respectively.

Definition 178. [Stash Key](id-cryptography-encoding.html#defn-stash-key)

The **Stash key** is a type of account key that holds funds bonded for staking (described in [Section A.1.4.1](id-cryptography-encoding.html#sect-staking-funds)) to a particular controller key (defined in [Definition 179](id-cryptography-encoding.html#defn-controller-key)). As a result, one may actively participate with a stash key keeping the stash key offline in a secure location. It can also be used to designate a Proxy account to vote in governance proposals, as described in [Section A.1.4.2](id-cryptography-encoding.html#sect-creating-controller-key). The Stash key holds the majority of the users’ funds and should neither be shared with anyone, saved on an online device, nor used to submit extrinsics.

Definition 179. [Controller Key](id-cryptography-encoding.html#defn-controller-key)

The **Controller key** is a type of account key that acts on behalf of the Stash account. It signs transactions that make decisions regarding the nomination and the validation of the other keys. It is a key that will be in direct control of a user and should mostly be kept offline, used to submit manual extrinsics. It sets preferences like payout account and commission, as described in [Section A.1.4.4](id-cryptography-encoding.html#sect-controller-settings). If used for a validator, it certifies the session keys, as described in [Section A.1.4.5](id-cryptography-encoding.html#sect-certifying-keys). It only needs the required funds to pay transaction fees \[TODO: key needing fund needs to be defined\].

Definition 180. [Session Keys](id-cryptography-encoding.html#defn-session-key)

**Session keys** are short-lived keys that are used to authenticate validator operations. Session keys are generated by the Polkadot Host and should be changed regularly due to security reasons. Nonetheless, no validity period is enforced by the Polkadot protocol on session keys. Various types of keys used by the Polkadot Host are presented in [Table 3](id-cryptography-encoding.html#tabl-session-keys):

| Protocol   | Key scheme |
|------------|------------|
| GRANDPA    | ED25519    |
| BABE       | SR25519    |
| I’m Online | SR25519    |
| Parachain  | SR25519    |

Table 3. List of key schemes which are used for session keys depending on the protocol

Session keys must be accessible by certain Polkadot Host APIs defined in Appendix [Appendix B](chap-host-api.html). Session keys are *not* meant to control the majority of the users’ funds and should only be used for their intended purpose.

#### [](#sect-staking-funds)[A.1.4.1. Holding and staking funds](#sect-staking-funds)

|     |     |
|-----|-----|
|     | TBH |

#### [](#sect-creating-controller-key)[A.1.4.2. Creating a Controller key](#sect-creating-controller-key)

|     |     |
|-----|-----|
|     | TBH |

#### [](#sect-designating-proxy)[A.1.4.3. Designating a proxy for voting](#sect-designating-proxy)

|     |     |
|-----|-----|
|     | TBH |

#### [](#sect-controller-settings)[A.1.4.4. Controller settings](#sect-controller-settings)

|     |     |
|-----|-----|
|     | TBH |

#### [](#sect-certifying-keys)[A.1.4.5. Certifying keys](#sect-certifying-keys)

Due to security considerations and Runtime upgrades, the session keys are supposed to  be changed regularly. As such, the new session keys need to be certified by a controller key before putting them in use. The controller only needs to create a certificate by signing a session public key and broadcasting this certificate via an extrinsic. \[TODO: spec the detail of the data structure of the certificate etc.\]

## [](#chapter-encoding)[A.2. Auxiliary Encodings](#chapter-encoding)

Definition 181. [Unix Time](id-cryptography-encoding.html#defn-unix-time)

By **Unix time**, we refer to the unsigned, little-endian encoded 64-bit integer which stores the number of **milliseconds** that have elapsed since the Unix epoch, that is the time 00:00:00 UTC on 1 January 1970, minus leap seconds. Leap seconds are ignored, and every day is treated as if it contained exactly 86’400 seconds.

### [](#id-binary-enconding)[A.2.1. Binary Enconding](#id-binary-enconding)

Definition 182. [Sequence of Bytes](id-cryptography-encoding.html#defn-byte-sequence)

By a **sequences of bytes** or a **byte array**, $b$, of length $n$, we refer to

$b := (b_0, b_1, ..., b\_{n - 1}) " such that " 0 \<= b_i \<= 255$

We define $\mathbb B_n$ to be the **set of all byte arrays of length $n$**. Furthermore, we define:

$\mathbb B := uuu\_(i=0)^infty \mathbb B_i$

We represent the concatenation of byte arrays $a :=(a_0, ..., a_n)$ and $b :=(b_0, ..., b_m)$ by:

$a \|$ b :=(a_0, ..., a_n, b_0, ..., b_m)$

Definition 183. [Bitwise Representation](id-cryptography-encoding.html#defn-bit-rep)

For a given byte $0 \<= b \<= 255$ the **bitwise representation** in bits $b_i in {0, 1}$ is defined as:

$b := b_7 ... b_0$

where

$b = 2^7 b_7 + 2^6 b_6 + ... + 2^0 b_0$

Definition 184. [Little Endian](id-cryptography-encoding.html#defn-little-endian)

By the **little-endian** representation of a non-negative integer, $I$, represented as

$I = (B_n ... B_0)\_256$

in base 256, we refer to a byte array $B = (b_0, b_1, ..., b_n)$ such that

$b_i :=B_i$

Accordingly, we define the function $sf "Enc"\_(sf "LE")$:

$sf "Enc"\_(sf "LE"): \mathbb Z^+ -\> \mathbb B; (B_n ... B_0)\_256 \|-\> (B\_{0,} B_1, ... , B_n)$

Definition 185. [UINT32](id-cryptography-encoding.html#defn-uint32)

By **UINT32** we refer to a non-negative integer stored in a byte array of length $4$ using little-endian encoding format.

### [](#sect-scale-codec)[A.2.2. SCALE Codec](#sect-scale-codec)

The Polkadot Host uses *Simple Concatenated Aggregate Little-Endian” (SCALE) codec* to encode byte arrays as well as other data structures. SCALE provides a canonical encoding to produce consistent hash values across their implementation, including the Merkle hash proof for the State Storage.

Definition 186. [Decoding](id-cryptography-encoding.html#defn-scale-decoding)

$"Dec"\_("SC")(d)$ refers to the decoding of a blob of data. Since the SCALE codec is not self-describing, it’s up to the decoder to validate whether the blob of data can be deserialized into the given type or data structure.

It’s accepted behavior for the decoder to partially decode the blob of data. Meaning, any additional data that does not fit into a datastructure can be ignored.

|     |                                                                                                                                                                                                                                                                                                                                                                                             |
|-----|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     | Considering that the decoded data is never larger than the encoded message, this information can serve as a way to validate values that can vary in sizes, such as sequences ([Definition 192](id-cryptography-encoding.html#defn-scale-list)). The decoder should strictly use the size of the encoded data as an upper bound when decoding in order to prevent denial of service attacks. |

Definition 187. [Tuple](id-cryptography-encoding.html#defn-scale-tuple)

The **SCALE codec** for **Tuple**, $T$, such that:

$T := (A_1,... A_n)$

Where $A_i$’s are values of **different types**, is defined as:

$"Enc"\_("SC")(T) := "Enc"\_("SC")(A_1) "\|\|" "Enc"\_("SC")(A_2) "\|\|" ... "\|\|" "Enc"\_("SC")(A_n)$

In case of a tuple (or a structure), the knowledge of the shape of data is not encoded even though it is necessary for decoding. The decoder needs to derive that information from the context where the encoding/decoding is happening.

Definition 188. [Varying Data Type](id-cryptography-encoding.html#defn-varrying-data-type)

We define a **varying data** type to be an ordered set of data types.

$\mathcal T = {T_1, ..., T_n}$

A value $A$ of varying date type is a pair $(A\_("Type"),A\_("Value"))$ where $A\_("Type") = T_i$ for some $T_i \in \mathcal T$ and $A\_("Value")$ is its value of type $T_i$, which can be empty. We define $"idx"(T_i) = i - 1$, unless it is explicitly defined as another value in the definition of a particular varying data type.

In particular, we define two specific varying data which are frequently used in various part of Polkadot protocol: *Option* ([Definition 190](id-cryptography-encoding.html#defn-option-type)) and *Result* ([Definition 191](id-cryptography-encoding.html#defn-result-type)).

Definition 189. [Encoding of Varying Data Type](id-cryptography-encoding.html#defn-scale-variable-type)

The SCALE codec for value $A = (A\_("Type"), A\_("Value"))$ of varying data type $\mathcal T = {T_i, ... T_n}$, formally referred to as $"Enc"\_("SC")(A)$ is defined as follows:

$"Enc"\_("SC")(A) := "Enc"\_("SC")("idx"(A\_("Type")) "\|\|" "Enc"\_("SC")(A\_("Value")))$

Where $"idx"$ is a 8-bit integer determining the type of $A$. In particular, for the optional type defined in [Definition 188](id-cryptography-encoding.html#defn-varrying-data-type), we have:

$"Enc"\_("SC")("None", phi) := 0\_(\mathbb B_1)$

The SCALE codec does not encode the correspondence between the value and the data type it represents; the decoder needs prior knowledge of such correspondence to decode the data.

Definition 190. [Option Type](id-cryptography-encoding.html#defn-option-type)

The **Option** type is a varying data type of ${"None",T_2}$ which indicates if data of $T_2$ type is available (referred to as *some* state) or not (referred to as *empty*, *none* or *null* state). The presence of type *none*, indicated by $"idx"(T\_("None")) = 0$, implies that the data corresponding to $T_2$ type is not available and contains no additional data. Where as the presence of type $T_2$ indicated by $"idx"(T_2) = 1$ implies that the data is available.

Definition 191. [Result Type](id-cryptography-encoding.html#defn-result-type)

The **Result** type is a varying data type of ${T_1, T_2}$ which is used to indicate if a certain operation or function was executed successfully (referred to as "ok" state) or not (referred to as "error" state). $T_1$ implies success, $T_2$ implies failure. Both types can either contain additional data or are defined as empty type otherwise.

Definition 192. [Sequence](id-cryptography-encoding.html#defn-scale-list)

The **SCALE codec** for **sequence** $S$ such that:

$S := A_1, ... A_n$

where $A_i$’s are values of **the same type** (and the decoder is unable to infer value of $n$ from the context) is defined as:

$"Enc"\_("SC")(S) := "Enc"\_("SC")^("Len")(abs(S)) "\|\|" "Enc"\_("SC")(A_2) "\|\|" ... "\|\|" "Enc"\_("SC")(A_n)$

where $"Enc"\_("SC")^("Len")$ is defined in [Definition 198](id-cryptography-encoding.html#defn-sc-len-encoding).

In some cases, the length indicator $"Enc"\_("SC")^("Len")(abs(S))$ is omitted if the length of the sequence is fixed and known by the decoder upfront. Such cases are explicitly stated by the definition of the corresponding type.

Definition 193. [Dictionary](id-cryptography-encoding.html#defn-scale-dictionary)

SCALE codec for **dictionary** or **hashtable** D with key-value pairs $(k_i, v_i)$s such that:

$D := {(k_1, v_1), ... (k_n, v_n)}$

is defined the SCALE codec of $D$ as a sequence of key value pairs (as tuples):

$"Enc"\_("SC")(D) := "Enc"\_("SC")^("Size")(abs(D)) "\|\|" "Enc"\_("SC")(k_1, v_1) "\|\|"..."\|\|" "Enc"\_("SC")(k_n, v_n)$

where $"Enc"\_("SC")^("Size")$ is encoded the same way as $"Enc"\_("SC")^("Len")$ but argument $"Size"$ refers to the number of key-value pairs rather than the length.

Definition 194. [Boolean](id-cryptography-encoding.html#defn-scale-boolean)

The SCALE codec for a **boolean value** $b$ defined as a byte as follows:

$"Enc"\_("SC"): {"False", "True"} -\> \mathbb B_1$ $b -\> {(0, b="False"),(1, b="True"):}$

Definition 195. [String](id-cryptography-encoding.html#defn-scale-string)

The SCALE codec for a **string value** is an encoded sequence ([Definition 192](id-cryptography-encoding.html#defn-scale-list)) consisting of UTF-8 encoded bytes.

Definition 196. [Fixed Length](id-cryptography-encoding.html#defn-scale-fixed-length)

The SCALE codec, $"Enc"\_("SC")$, for other types such as fixed length integers not defined here otherwise, is equal to little endian encoding of those values defined in [Definition 184](id-cryptography-encoding.html#defn-little-endian).

Definition 197. [Empty](id-cryptography-encoding.html#defn-scale-empty)

The SCALE codec, $"Enc"\_("SC")$, for an empty type is defined to a byte array of zero length and depicted as $phi$.

#### [](#sect-sc-length-and-compact-encoding)[A.2.2.1. Length and Compact Encoding](#sect-sc-length-and-compact-encoding)

SCALE Length encoding is used to encode integer numbers of variying sizes prominently in an encoding length of arrays:

Definition 198. [Length Encoding](id-cryptography-encoding.html#defn-sc-len-encoding)

**SCALE Length encoding**, $"Enc"\_("SC")^("Len")$, also known as a *compact encoding*, of a non-negative number $n$ is defined as follows:

$"Enc"\_("SC")^("Len"): \mathbb N -\> \mathbb B$ $n -\> b := {(l_1, 0 \<= n \< 2^6),(i_1 i_2, 2^6 \<= n \< 2^14),(j_1 j_2 j_3, 2^14 \<= n \< 2^30),(k_1 k_2 ... k_m, 2^30\<=n):}$

in where the least significant bits of the first byte of byte array b are defined as follows:

$l_1^1 l_1^0 = 00$ $i_1^1 i_1^0 = 01$ $j_1^1 j_1^0 = 10$ $k_1^1 k_1^0 = 11$

and the rest of the bits of $b$ store the value of $n$ in little-endian format in base-2 as follows:

$n := { (l_1^7 ... l_1^3 l_1^2, n \< 2^6), (i_2^7 ... i_2^0 i_1^7 .. i_1^2, 2^6 \<= n \< 2^14), (j_4^7 ... j_4^0 j_3^7 ... j_1^7 ... j_1^2, 2^14 \<= n \< 2^30), (k_2 + k_3 2^8 + k_4 2^(2 xx 8)+...+k_m2^((m-2)8),2^30 \<= n) :}$

such that:

$k_1^7 ... k_1^3 k_1^2 := m-4$

### [](#id-hex-encoding)[A.2.3. Hex Encoding](#id-hex-encoding)

Practically, it is more convenient and efficient to store and process data which is stored in a byte array. On the other hand, the trie keys are broken into 4-bits nibbles. Accordingly, we need a method to encode sequences of 4-bits nibbles into byte arrays canonically. To this aim, we define hex encoding function $"Enc" ("HE")("PK")$ as follows:

Definition 199. [Hex Encoding](id-cryptography-encoding.html#defn-hex-encoding)

Suppose that $"PK" = (k_1, ... k_n)$ is a sequence of nibbles, then:

$"Enc"\_("HE")("PK") := {("Nibbles"\_4,-\>, \mathbb B),("PK" = (k_1, ... k_n),-\>,{((16k_1+k_2,...,16k\_(2i-1)+k\_(2i)),n=2i),((k_1,16k_2+k_3,...,16k\_(2i)+k\_(2i+1)),n = 2i+1):}):}$

## [](#chapter-genesis)[A.3. Genesis State](#chapter-genesis)

The genesis state is a set of key-value pairs representing the initial state of the Polkadot state storage. It can be retrieved from [the Polkadot repository](https://github.com/paritytech/polkadot/tree/master/node/service/chain-specs). While each of those key-value pairs offers important identifiable information to the Runtime, to the Polkadot Host they are a transparent set of arbitrary chain- and network-dependent keys and values. The only exception to this are the `:code` ([Section 2.6.2](chap-state.html#sect-loading-runtime-code)) and `:heappages` ([Section 2.6.3.1](chap-state.html#sect-memory-management)) keys, which are used by the Polkadot Host to initialize the WASM environment and its Runtime. The other keys and values are unspecified and solely depend on the chain and respectively its corresponding Runtime. On initialization the data should be inserted into the state storage with the Host API ([Section B.2.1](chap-host-api.html#sect-storage-set)).

As such, Polkadot does not define a formal genesis block. Nonetheless for the compatibility reasons in several algorithms, the Polkadot Host defines the *genesis header* ([Definition 200](id-cryptography-encoding.html#defn-genesis-header)). By the abuse of terminology, "genesis block" refers to the hypothetical parent of block number *1* which holds genesis header as its header.

Definition 200. [Genesis Header](id-cryptography-encoding.html#defn-genesis-header)

The Polkadot genesis header is a data structure conforming to block header format ([Definition 10](chap-state.html#defn-block-header)). It contains the following values:

| Block header field | Genesis Header Value                                                                                                                |
|--------------------|-------------------------------------------------------------------------------------------------------------------------------------|
| `parent_hash`      | *0*                                                                                                                                 |
| `number`           | *0*                                                                                                                                 |
| `state_root`       | Merkle hash of the state storage trie ([Definition 29](chap-state.html#defn-merkle-value)) after inserting the genesis state in it. |
| `extrinsics_root`  | *0*                                                                                                                                 |
| `digest`           | *0*                                                                                                                                 |

## [](#chapter-erasure-encoding)[A.4. Erasure Encoding](#chapter-erasure-encoding)

### [](#sect-erasure-encoding)[A.4.1. Erasure Encoding](#sect-erasure-encoding)

|     |                                               |
|-----|-----------------------------------------------|
|     | Erasure Encoding has not been documented yet. |
