---
title: "Appendix A: Cryptography & Encoding"
---

The appendix chapter contains various protocol details.

## -sec-num- Cryptographic Algorithms {#chapter-crypto-algos}

### -sec-num- Hash Functions {#sect-hash-functions}

#### -sec-num- BLAKE2 {#sect-blake2}

BLAKE2 is a collection of cryptographic hash functions known for their high speed. Their design closely resembles BLAKE which has been a finalist in the SHA-3 competition.

Polkadot is using the Blake2b variant, which is optimized for 64-bit platforms. Unless otherwise specified, the Blake2b hash function with a 256-bit output is used whenever Blake2b is invoked in this document. The detailed specification and sample implementations of all variants of Blake2 hash functions can be found in RFC 7693 [@saarinen_blake2_2015].

### -sec-num- Randomness {#sect-randomness}

:::info
TBH
:::

### -sec-num- VRF {#sect-vrf}

A Verifiable Random Function (VRF) is a mathematical operation that takes some input and produces a random number using a secret key along with a proof of authenticity that this random number was generated using the submitter’s secret key and the given input. Any challenger can verify the proof to ensure the random number generation is valid and has not been tampered with (for example, to the benefit of the submitter).

In Polkadot, VRFs are used for the BABE block production lottery by [Block-Production-Lottery](sect-block-production#algo-block-production-lottery) and the parachain approval voting mechanism ([Section -sec-num-ref-](chapter-anv#sect-approval-voting)). The VRF uses a mechanism similar to algorithms introduced in the following papers:

- [Making NSEC5 Practical for DNSSEC](https://eprint.iacr.org/2017/099.pdf) [@papadopoulos17]

- [DLEQ Proofs](https://blog.cloudflare.com/privacy-pass-the-math/#dleqproofs)

- [Verifiable Random Functions (VRFs)](https://tools.ietf.org/id/draft-goldbe-vrf-01) [@goldberg17]

It essentially generates a deterministic elliptic curve based on Schnorr signature as a verifiable random value. The elliptic curve group used in the VRF function is the Ristretto group specified in:

- [ristretto.group/](https://ristretto.group/)

###### Definition -def-num- VRF Proof {#defn-vrf-proof}
:::definition

The **VRF proof** proves the correctness of an associated VRF output. The VRF proof, ${P}$, is a data structure of the following format:

$$
{P}={\left({C},{S}\right)}
$$
$$
{S}={\left({b}_{{0}},\ldots{b}_{{31}}\right)}
$$

where ${C}$ is the challenge and ${S}$ is the 32-byte Schnorr poof. Both are expressed as Curve25519 scalars as defined in Definition [Definition -def-num-ref-](id-cryptography-encoding#defn-vrf-dleq-prove).

:::
###### Definition -def-num- `DLEQ Prove` {#defn-vrf-dleq-prove}
:::definition

The $\text{dleq\_prove}{\left({t},{i}\right)}$ function creates a proof for a given input, ${i}$, based on the provided transcript, ${T}$.

First:

$$
{t}_{{1}}=\text{append}{\left({t},\text{'proto-name'},\text{'DLEQProof'}\right)}
$$
$$
{t}_{{2}}=\text{append}{\left({t}_{{1}},\text{'vrf:h'},{i}\right)}
$$

Then the witness scalar is calculated, ${s}_{{w}}$, where ${w}$ is the 32-byte secret seed used for nonce generation in the context of sr25519.

$$
\begin{aligned}
t_3 &= \text{meta-AD}(t_2, \text{'proving\\00'}, \text{more=False}) \\
t_4 &= \text{meta-AD}(t_3, w_l, \text{more=True}) \\
t_5 &= \text{KEY}(t_4, w, \text{more=False}) \\
t_6 &= \text{meta-AD}(t_5, \text{'rng'}, \text{more=False}) \\
t_7 &= \text{KEY}(t_6, r, \text{more=False}) \\
t_8 &= \text{meta-AD}(t_7, e\_(64), \text{more=False}) \\
(\phi, s_w) &= \text{PRF}(t_8, \text{more=False})
\end{aligned}
$$

where ${w}_{{l}}$ is the length of the witness, encoded as a 32-bit little-endian integer. ${r}$ is a 32-byte array containing the secret witness scalar.

$$
\begin{aligned}
l_1 &= \text{append}(t_2, \text{'}\text{vrf:R=g}^r\text{'}, s_w) \\
l_2 &= \text{append}(l_1, \text{'}\text{vrf:h}^r\text{'}, s_i) \\
l_3 &= \text{append}(l_2, \text{'}\text{vrf:pk}\text{'}, s_p) \\
l_4 &= \text{append}(l_3, \text{'}\text{vrf:h}^{sk}\text{'}, \text{vrf}_{o})
\end{aligned}
$$


**where**

- ${s}_{{i}}$ is the compressed Ristretto point of the scalar input.

- ${s}_{{p}}$ is the compressed Ristretto point of the public key.

- ${s}_{{w}}$ is the compressed Ristretto point of the wittness:

For the 64-byte challenge:

$$
{l}_{{5}}=\text{meta-AD}{\left({l}_{{4}},\text{'prove'},\text{more=False}\right)}
$$
$$
{l}_{{6}}=\text{meta-AD}{\left({l}_{{5}},{e}_{{{64}}},\text{more=True}\right)}
$$
$$
{C}=\text{PRF}{\left({l}_{{6}},\text{more=False}\right)}
$$

And the Schnorr proof:

$$
{S}={s}_{{w}}-{\left({C}\cdot{p}\right)}
$$

where ${p}$ is the secret key.

:::
###### Definition -def-num- `DLEQ Verify` {#defn-vrf-dleq-verify}
:::definition

The $\text{dleq\_verify}{\left({i},{o},{P},{p}_{{k}}\right)}$ function verifiers the VRF input, ${i}$ against the output, ${o}$, with the associated proof ([Definition -def-num-ref-](id-cryptography-encoding#defn-vrf-proof)) and public key, ${p}_{{k}}$.

$$
\begin{aligned}
t_1 &= \text{append}(t, \text{'}\text{proto-name}\text{'}, \text{'}\text{DLEQProof}\text{'}) \\
t_2 &= \text{append}(t_1, \text{'}\text{vrf:h}\text{'}, s_i) \\
t_3 &= \text{append}(t_2, \text{'}\text{vrf:R=g}^r\text{'}, R) \\
t_4 &= \text{append}(t_3, \text{'}\text{vrf:h}^r\text{'}, H) \\
t_5 &= \text{append}(t_4, \text{'}\text{vrf:pk}\text{'}, p_k) \\
t_6 &= \text{append}(t_5, \text{'}\text{vrf:h}^{sk}\text{'}, o)
\end{aligned}
$$


**where**

- ${R}$ is calculated as:

  ${R}={C}\in{P}\times{p}_{{k}}+{S}\in{P}+{B}$

  where ${B}$ is the Ristretto basepoint.

- ${H}$ is calculated as:

  ${H}={C}\in{P}\times{o}+{S}\in{P}\times{i}$

The challenge is valid if ${C}\in{P}$ equals ${y}$:

$$
{t}_{{7}}=\text{meta-AD}{\left({t}_{{6}},\text{'prove'},\text{more=False}\right)}
$$
$$
{t}_{{8}}=\text{meta-AD}{\left({t}_{{7}},{e}_{{{64}}},\text{more=True}\right)}
$$
$$
{y}=\text{PRF}{\left({t}_{{8}},\text{more=False}\right)}
$$

:::
#### -sec-num- Transcript {#id-transcript}

A VRF transcript serves as a domain-specific separator of cryptographic protocols and is represented as a mathematical object, as defined by Merlin, which defines how that object is generated and encoded. The usage of the transcript is implementation specific, such as for certain mechanisms in the Availability & Validity chapter ([Chapter -chap-num-ref-](chapter-anv)), and is therefore described in more detail in those protocols. The input value used to initiate the transcript is referred to as a *context* ([Definition -def-num-ref-](id-cryptography-encoding#defn-vrf-context)).

###### Definition -def-num- VRF Context {#defn-vrf-context}
:::definition

The **VRF context** is a constant byte array used to initiate the VRF transcript. The VRF context is constant for all users of the VRF for the specific context for which the VRF function is used. Context prevents VRF values generated by the same nodes for other purposes to be reused for purposes not meant to. For example, the VRF context for the BABE Production lottery defined in [Section -sec-num-ref-](sect-block-production#sect-block-production-lottery) is set to be "substrate-babe-vrf".

:::
###### Definition -def-num- VRF Transcript {#defn-vrf-transcript}
:::definition

A **transcript**, or VRF transcript, is a STROBE object, $\text{obj}$, as defined in the STROBE documentation, respectively section ["5. State of a STROBE object"](https://strobe.sourceforge.io/specs/#object).

$$
\text{obj}={\left(\text{st},\text{pos},\text{pos}_{{\text{begin}}},{I}_{{0}}\right)}
$$

**where**

- The duplex state, $\text{st}$, is a 200-byte array created by the [keccak-f1600 sponge function](https://keccak.team/keccak_specs_summary) on the [initial STROBE state](https://strobe.sourceforge.io/specs/#object.initial). Specifically, `R` is of value `166`, and `X.Y.Z` is of value `1.0.2`.

- $\text{pos}$ has the initial value of `0`.

- $\text{pos}_{{\text{begin}}}$ has the initial value of `0`.

- ${I}_{{0}}$ has the initial value of `0`.

Then, the `meta-AD` operation ([Definition -def-num-ref-](id-cryptography-encoding#defn-strobe-operations)) (where `more=False`) is used to add the protocol label `Merlin v1.0` to $\text{obj}$ followed by *appending* ([Section -sec-num-ref-](id-cryptography-encoding#sect-vrf-appending-messages)) label `dom-step` and its corresponding context, ${c}{t}{x}$, resulting in the final transcript, ${T}$.

$$
{t}=\text{meta-AD}{\left({o}{b}{j},\text{'Merlin v1.0'},\text{False}\right)}
$$
$$
{T}=\text{append}{\left({t},\text{'dom-step'},\text{ctx}\right)}
$$

$\text{ctx}$ serves as an arbitrary identifier/separator and its value is defined by the protocol specification individually. This transcript is treated just like a STROBE object, wherein any operations ([Definition -def-num-ref-](id-cryptography-encoding#defn-strobe-operations)) on it modify the values such as $\text{pos}$ and $\text{pos}_{{\text{begin}}}$.

Formally, when creating a transcript, we refer to it as $\text{Transcript}{\left({c}{t}{x}\right)}$.

:::
###### Definition -def-num- STROBE Operations {#defn-strobe-operations}
:::definition

STROBE operations are described in the [STROBE specification](https://strobe.sourceforge.io/specs/), respectively section ["6. Strobe operations"](https://strobe.sourceforge.io/specs/#ops). Operations are indicated by their corresponding bitfield, as described in section ["6.2. Operations and flags"](https://strobe.sourceforge.io/specs/#ops.flags) and implemented as described in section ["7. Implementation of operations"](https://strobe.sourceforge.io/specs/#ops.impl)

:::
##### -sec-num- Messages {#sect-vrf-appending-messages}

Appending messages, or "data," to the transcript ([Definition -def-num-ref-](id-cryptography-encoding#defn-vrf-transcript)) first requires `meta-AD` operations for a given label of the messages, including the size of the message, followed by an `AD` operation on the message itself. The size of the message is a 4-byte, little-endian encoded integer.

$$
{T}_{{0}}=\text{meta-AD}{\left({T},{l},\text{False}\right)}
$$
$$
{T}_{{1}}=\text{meta-AD}{\left({T}_{{0}},{m}_{{l}},\text{True}\right)}
$$
$$
{T}_{{2}}=\text{AD}{\left({T}_{{1}},{m},\text{False}\right)}
$$

where ${T}$ is the transcript ([Definition -def-num-ref-](id-cryptography-encoding#defn-vrf-transcript)), ${l}$ is the given label and ${m}$ the message, respectively ${m}_{{l}}$ representing its size. ${T}_{{2}}$ is the resulting transcript with the appended data. STROBE operations are described in [Definition -def-num-ref-](id-cryptography-encoding#defn-strobe-operations).

Formally, when appending a message, we refer to it as $\text{append}{\left({T},{l},{m}\right)}$.

### -sec-num- Cryptographic Keys {#sect-cryptographic-keys}

Various types of keys are used in Polkadot to prove the identity of the actors involved in the Polkadot Protocols. To improve the security of the users, each key type has its own unique function and must be treated differently, as described in this Section.

###### Definition -def-num- Account Key {#defn-account-key}
:::definition

**Account key ${\left({s}{k}^{{a}},{p}{k}^{{a}}\right)}$** is a key pair of type of either of the schemes in the following table:

###### Table -tab-num- List of the public key scheme that can be used for an account key {#tabl-account-key-scheme}

| Key Scheme | Description |
|------------|-------------|
| sr25519    | Schnorr signature on Ristretto compressed ed25519 points as implemented in TODO|
| ed25519    | The ed25519 signature complies with [@josefsson_edwards-curve_2017] except for the verification process which adhere to Ed25519 Zebra variant specified in [@devalence_ed25519zebra_2020]. In short, the signature point is not assumed to be in the prime-ordered subgroup group. As such, the verifier must explicitly clear the cofactor during the course of verifying the signature equation. |
| secp256k1  | Only for outgoing transfer transactions. |

An account key can be used to sign transactions among other accounts and balance-related functions. Keys defined in [Definition -def-num-ref-](id-cryptography-encoding#defn-account-key) and [Definition -def-num-ref-](id-cryptography-encoding#defn-stash-key) are created and managed by the user independent of the Polkadot implementation. The user notifies the network about the used keys by submitting a transaction.
:::

###### Definition -def-num- Stash Key {#defn-stash-key}
:::definition

The **Stash key** is a type of account that is intended to hold a large amount of funds. As a result, one may actively participate with a stash key, keeping the stash key offline in a secure location. It can also be used to designate a Proxy account to vote in governance proposals. 
:::

:::info Controller accounts are deprecated
Controller accounts and controller keys are no longer supported. 
For more information about the deprecation, see the [Polkadot wiki](https://wiki.polkadot.network/docs/learn-controller) or a more detailed discussion in the
[Polkadot forum](https://forum.polkadot.network/t/staking-controller-deprecation-plan-staking-ui-leads-comms/2748).
If you want to know how to set up Stash and Staking Proxy Keys, you can also check the[Polkadot wiki](https://wiki.polkadot.network/docs/maintain-guides-how-to-nominate-kusama#setting-up-stash-and-staking-proxy-keys)
The following definition will be removed soon.
:::

###### Definition -def-num- Controller Key {#defn-controller-key}
:::definition

The **Controller key** is a type of account key that acts on behalf of the Stash account. It signs transactions that make decisions regarding the nomination and the validation of the other keys. It is a key that will be in direct control of a user and should mostly be kept offline, used to submit manual extrinsics. It sets preferences like payout account and commission. If used for a validator, it certifies the session keys. It only needs the required funds to pay transaction fees \[TODO: key needing fund needs to be defined\].

:::
###### Definition -def-num- Session Keys {#defn-session-key}
:::definition

**Session keys** are short-lived keys that are used to authenticate validator operations. Session keys are generated by the Polkadot Host and should be changed regularly due to security reasons. Nonetheless, no validity period is enforced by the Polkadot protocol on session keys. Various types of keys used by the Polkadot Host are presented in [Table -tab-num-ref-](id-cryptography-encoding#tabl-session-keys):

###### Table -tab-num- List of key schemes which are used for session keys depending on the protocol {#tabl-session-keys}

| Protocol   | Key scheme |
|------------|------------|
| GRANDPA    | ED25519    |
| BABE       | SR25519    |
| I’m Online | SR25519    |
| Parachain  | SR25519    |
| BEEFY      | secp256k1  |

Session keys must be accessible by certain Polkadot Host APIs defined in [Appendix -chap-num-ref-](chap-host-api). Session keys are *not* meant to control the majority of the users’ funds and should only be used for their intended purpose.
:::

#### -sec-num- Holding and staking funds {#sect-staking-funds}

:::info
TBH
:::

#### -sec-num- Designating a proxy for voting {#sect-designating-proxy}

:::info
TBH
:::



## -sec-num- Auxiliary Encodings {#chapter-encoding}

###### Definition -def-num- Unix Time {#defn-unix-time}
:::definition

By **Unix time**, we refer to the unsigned, little-endian encoded 64-bit integer which stores the number of **milliseconds** that have elapsed since the Unix epoch, that is the time 00:00:00 UTC on 1 January 1970, minus leap seconds. Leap seconds are ignored, and every day is treated as if it contained exactly 86’400 seconds.

:::
### -sec-num- Binary Enconding {#id-binary-enconding}

###### Definition -def-num- Sequence of Bytes {#defn-byte-sequence}
:::definition

By a **sequences of bytes** or a **byte array**, ${b}$, of length ${n}$, we refer to

$$
{b}\:={\left({b}_{{0}},{b}_{{1}},\ldots,{b}_{{{n}-{1}}}\right)}\ \text{ such that }\ {0}\le{b}_{{i}}\le{255}
$$

We define ${\mathbb{{B}}}_{{n}}$ to be the **set of all byte arrays of length ${n}$**. Furthermore, we define:

$$
{\mathbb{{B}}}\:={\bigcup_{{{i}={0}}}^{\infty}}{\mathbb{{B}}}_{{i}}
$$

We represent the concatenation of byte arrays ${a}\:={\left({a}_{{0}},\ldots,{a}_{{n}}\right)}$ and ${b}\:={\left({b}_{{0}},\ldots,{b}_{{m}}\right)}$ by:

$$
{a}{\mid} b :=(a_0, ..., a_n, b_0, ..., b_m)
$$

:::
###### Definition -def-num- Bitwise Representation {#defn-bit-rep}
:::definition

For a given byte ${0}\le{b}\le{255}$ the **bitwise representation** in bits ${b}_{{i}}\in{\left\lbrace{0},{1}\right\rbrace}$ is defined as:

$$
{b}\:={b}_{{7}}\ldots{b}_{{0}}
$$

**where**

$$
{b}={2}^{{7}}{b}_{{7}}+{2}^{{6}}{b}_{{6}}+\ldots+{2}^{{0}}{b}_{{0}}
$$

:::
###### Definition -def-num- Little Endian {#defn-little-endian}
:::definition

By the **little-endian** representation of a non-negative integer, ${I}$, represented as

$$
{I}={\left({B}_{{n}}\ldots{B}_{{0}}\right)}_{{256}}
$$

in base 256, we refer to a byte array ${B}={\left({b}_{{0}},{b}_{{1}},\ldots,{b}_{{n}}\right)}$ such that

$$
{b}_{{i}}\:={B}_{{i}}
$$

Accordingly, we define the function ${\mathsf{\text{Enc}}}_{{{\mathsf{\text{LE}}}}}$:

$$
{\mathsf{\text{Enc}}}_{{{\mathsf{\text{LE}}}}}:{\mathbb{{Z}}}^{+}\rightarrow{\mathbb{{B}}};{\left({B}_{{n}}\ldots{B}_{{0}}\right)}_{{256}}{\mid}\rightarrow{\left({B}_{{{0},}}{B}_{{1}},\ldots,{B}_{{n}}\right)}
$$

:::
###### Definition -def-num- UINT32 {#defn-uint32}
:::definition

By **UINT32**, we refer to a non-negative integer stored in a byte array of length ${4}$ using little-endian encoding format.

:::
### -sec-num- SCALE Codec {#sect-scale-codec}

The Polkadot Host uses *Simple Concatenated Aggregate Little-Endian” (SCALE) codec* to encode byte arrays as well as other data structures. SCALE provides a canonical encoding to produce consistent hash values across their implementation, including the Merkle hash proof for the State Storage.

###### Definition -def-num- Decoding {#defn-scale-decoding}
::::definition

$\text{Dec}_{{\text{SC}}}{\left({d}\right)}$ refers to the decoding of a blob of data. Since the SCALE codec is not self-describing, it’s up to the decoder to validate whether the blob of data can be deserialized into the given type or data structure.

It’s accepted behavior for the decoder to partially decode the blob of data. This means any additional data that does not fit into a data structure can be ignored.

:::caution
Considering that the decoded data is never larger than the encoded message, this information can serve as a way to validate values that can vary in size, such as sequences ([Definition -def-num-ref-](id-cryptography-encoding#defn-scale-list)). The decoder should strictly use the size of the encoded data as an upper bound when decoding in order to prevent denial of service attacks.
:::

::::
###### Definition -def-num- Tuple {#defn-scale-tuple}
:::definition

The **SCALE codec** for **Tuple**, ${T}$, such that:

$$
{T}\:={\left({A}_{{1}},\ldots{A}_{{n}}\right)}
$$

Where ${A}_{{i}}$’s are values of **different types**, is defined as:

$$
\text{Enc}_{{\text{SC}}}{\left({T}\right)}\:=\text{Enc}_{{\text{SC}}}{\left({A}_{{1}}\right)}\text{||}\text{Enc}_{{\text{SC}}}{\left({A}_{{2}}\right)}\text{||}\ldots\text{||}\text{Enc}_{{\text{SC}}}{\left({A}_{{n}}\right)}
$$
:::

In the case of a tuple (or a structure), the knowledge of the shape of data is not encoded even though it is necessary for decoding. The decoder needs to derive that information from the context where the encoding/decoding is happening.

###### Definition -def-num- Varying Data Type {#defn-varrying-data-type}
:::definition

We define a **varying data** type to be an ordered set of data types.

$$
{\mathcal{{T}}}={\left\lbrace{T}_{{1}},\ldots,{T}_{{n}}\right\rbrace}
$$

A value ${A}$ of varying data type is a pair ${\left({A}_{{\text{Type}}},{A}_{{\text{Value}}}\right)}$ where ${A}_{{\text{Type}}}={T}_{{i}}$ for some ${T}_{{i}}\in{\mathcal{{T}}}$ and ${A}_{{\text{Value}}}$ is its value of type ${T}_{{i}}$, which can be empty. We define $\text{idx}{\left({T}_{{i}}\right)}={i}-{1}$, unless it is explicitly defined as another value in the definition of a particular varying data type.

In particular, we define two specific varying data which are frequently used in various parts of the Polkadot protocol: *Option* ([Definition -def-num-ref-](id-cryptography-encoding#defn-option-type)) and *Result* ([Definition -def-num-ref-](id-cryptography-encoding#defn-result-type)).

:::
###### Definition -def-num- Encoding of Varying Data Type {#defn-scale-variable-type}
:::definition

The SCALE codec for value ${A}={\left({A}_{{\text{Type}}},{A}_{{\text{Value}}}\right)}$ of varying data type ${\mathcal{{T}}}={\left\lbrace{T}_{{i}},\ldots{T}_{{n}}\right\rbrace}$, formally referred to as $\text{Enc}_{{\text{SC}}}{\left({A}\right)}$ is defined as follows:

$$
\text{Enc}_{{\text{SC}}}{\left({A}\right)}\:=\text{Enc}_{{\text{SC}}}{\left(\text{idx}{\left({A}_{{\text{Type}}}\right)}\text{||}\text{Enc}_{{\text{SC}}}{\left({A}_{{\text{Value}}}\right)}\right)}
$$

Where $\text{idx}$ is an 8-bit integer determining the type of ${A}$. In particular, for the optional type defined in [Definition -def-num-ref-](id-cryptography-encoding#defn-varrying-data-type), we have:

$$
\text{Enc}_{{\text{SC}}}{\left(\text{None},\phi\right)}\:={0}_{{{\mathbb{{B}}}_{{1}}}}
$$

The SCALE codec does not encode the correspondence between the value and the data type it represents; the decoder needs prior knowledge of such correspondence to decode the data.

:::
###### Definition -def-num- Option Type {#defn-option-type}
:::definition

The **Option** type is a varying data type of ${\left\lbrace\text{None},{T}_{{2}}\right\rbrace}$ which indicates if data of ${T}_{{2}}$ type is available (referred to as *some* state) or not (referred to as *empty*, *none* or *null* state). The presence of type *none*, indicated by $\text{idx}{\left({T}_{{\text{None}}}\right)}={0}$, implies that the data corresponding to ${T}_{{2}}$ type is not available and contains no additional data. Where as the presence of type ${T}_{{2}}$ indicated by $\text{idx}{\left({T}_{{2}}\right)}={1}$ implies that the data is available.

:::
###### Definition -def-num- Result Type {#defn-result-type}
:::definition

The **Result** type is a varying data type of ${\left\lbrace{T}_{{1}},{T}_{{2}}\right\rbrace}$ which is used to indicate if a certain operation or function was executed successfully (referred to as "ok" state) or not (referred to as "error" state). ${T}_{{1}}$ implies success, ${T}_{{2}}$ implies failure. Both types can either contain additional data or are defined as empty types otherwise.

:::
###### Definition -def-num- Sequence {#defn-scale-list}
:::definition

The **SCALE codec** for **sequence** ${S}$ such that:

$$
{S}\:={A}_{{1}},\ldots{A}_{{n}}
$$

where ${A}_{{i}}$’s are values of **the same type** (and the decoder is unable to infer value of ${n}$ from the context) is defined as:

$$
\text{Enc}_{{\text{SC}}}{\left({S}\right)}\:={\text{Enc}_{{\text{SC}}}^{{\text{Len}}}}{\left({\left|{{S}}\right|}\right)}\text{||}\text{Enc}_{{\text{SC}}}{\left({A}_{{2}}\right)}\text{||}\ldots\text{||}\text{Enc}_{{\text{SC}}}{\left({A}_{{n}}\right)}
$$

where ${\text{Enc}_{{\text{SC}}}^{{\text{Len}}}}$ is defined in [Definition -def-num-ref-](id-cryptography-encoding#defn-sc-len-encoding).

In some cases, the length indicator ${\text{Enc}_{{\text{SC}}}^{{\text{Len}}}}{\left({\left|{{S}}\right|}\right)}$ is omitted if the length of the sequence is fixed and known by the decoder upfront. Such cases are explicitly stated by the definition of the corresponding type.

:::
###### Definition -def-num- Dictionary {#defn-scale-dictionary}
:::definition

SCALE codec for **dictionary** or **hashtable** D with key-value pairs ${\left({k}_{{i}},{v}_{{i}}\right)}$s such that:

$$
{D}\:={\left\lbrace{\left({k}_{{1}},{v}_{{1}}\right)},\ldots{\left({k}_{{n}},{v}_{{n}}\right)}\right\rbrace}
$$

is defined as the SCALE codec of ${D}$ as a sequence of key-value pairs (as tuples):

$$
\text{Enc}_{{\text{SC}}}{\left({D}\right)}\:={\text{Enc}_{{\text{SC}}}^{{\text{Size}}}}{\left({\left|{{D}}\right|}\right)}\text{||}\text{Enc}_{{\text{SC}}}{\left({k}_{{1}},{v}_{{1}}\right)}\text{||}\ldots\text{||}\text{Enc}_{{\text{SC}}}{\left({k}_{{n}},{v}_{{n}}\right)}
$$

where ${\text{Enc}_{{\text{SC}}}^{{\text{Size}}}}$ is encoded the same way as ${\text{Enc}_{{\text{SC}}}^{{\text{Len}}}}$ but argument $\text{Size}$ refers to the number of key-value pairs rather than the length.

:::
###### Definition -def-num- Boolean {#defn-scale-boolean}
:::definition

The SCALE codec for a **boolean value** ${b}$ defined as a byte as follows:

$$
\text{Enc}_{{\text{SC}}}:{\left\lbrace\text{False},\text{True}\right\rbrace}\rightarrow{\mathbb{{B}}}_{{1}}
$$
$$
{b}\rightarrow{\left\lbrace\begin{matrix}{0}&{b}=\text{False}\\{1}&{b}=\text{True}\end{matrix}\right.}
$$

:::
###### Definition -def-num- String {#defn-scale-string}
:::definition

The SCALE codec for a **string value** is an encoded sequence ([Definition -def-num-ref-](id-cryptography-encoding#defn-scale-list)) consisting of UTF-8 encoded bytes.

:::
###### Definition -def-num- Fixed Length {#defn-scale-fixed-length}
:::definition

The SCALE codec, $\text{Enc}_{{\text{SC}}}$, for other types such as fixed length integers not defined here otherwise, is equal to little-endian encoding of those values defined in [Definition -def-num-ref-](id-cryptography-encoding#defn-little-endian).

:::
###### Definition -def-num- Empty {#defn-scale-empty}
:::definition

The SCALE codec, $\text{Enc}_{{\text{SC}}}$, for an empty type, is defined as a byte array of zero length and depicted as $\phi$.

:::
#### -sec-num- Length and Compact Encoding {#sect-sc-length-and-compact-encoding}

SCALE Length encoding is used to encode integer numbers of varying sizes prominently in an encoding length of arrays:

###### Definition -def-num- Length Encoding {#defn-sc-len-encoding}
:::definition

**SCALE Length encoding**, ${\text{Enc}_{{\text{SC}}}^{{\text{Len}}}}$, also known as a *compact encoding*, of a non-negative number ${n}$ is defined as follows:

$$
{\text{Enc}_{{\text{SC}}}^{{\text{Len}}}}:{\mathbb{{N}}}\rightarrow{\mathbb{{B}}}
$$
$$
{n}\rightarrow{b}\:={\left\lbrace\begin{matrix}{l}_{{1}}&{0}\le{n}<{2}^{{6}}\\{i}_{{1}}{i}_{{2}}&{2}^{{6}}\le{n}<{2}^{{14}}\\{j}_{{1}}{j}_{{2}}{j}_{{3}}{j}_{{4}}&{2}^{{14}}\le{n}<{2}^{{30}}\\{k}_{{1}}{k}_{{2}}\ldots{k}_{{m}+{1}}&{2}^{{30}}\le{n}\end{matrix}\right.}
$$

in where the least significant bits of the first byte of byte array b are defined as follows:

$$
{{l}_{{1}}^{{1}}}{{l}_{{1}}^{{0}}}={00}
$$
$$
{{i}_{{1}}^{{1}}}{{i}_{{1}}^{{0}}}={01}
$$
$$
{{j}_{{1}}^{{1}}}{{j}_{{1}}^{{0}}}={10}
$$
$$
{{k}_{{1}}^{{1}}}{{k}_{{1}}^{{0}}}={11}
$$

and the rest of the bits of ${b}$ store the value of ${n}$ in little-endian format in base-2 as follows:

$$
{n}\:={\left\lbrace\begin{matrix}{{l}_{{1}}^{{7}}}\ldots{{l}_{{1}}^{{3}}}{{l}_{{1}}^{{2}}}&{n}<{2}^{{6}}\\{{i}_{{2}}^{{7}}}\ldots{{i}_{{2}}^{{0}}}{{i}_{{1}}^{{7}}}..{{i}_{{1}}^{{2}}}&{2}^{{6}}\le{n}<{2}^{{14}}\\{{j}_{{4}}^{{7}}}\ldots{{j}_{{4}}^{{0}}}{{j}_{{3}}^{{7}}}\ldots{{j}_{{1}}^{{7}}}\ldots{{j}_{{1}}^{{2}}}&{2}^{{14}}\le{n}<{2}^{{30}}\\{k}_{{2}}+{k}_{{3}}{2}^{{8}}+{k}_{{4}}{2}^{{{2}\times{8}}}+\ldots+{k}_{{m}+{1}}{2}^{{{\left({m}-{1}\right)}{8}}}&{2}^{{30}}\le{n}\end{matrix}\right.}
$$

such that:

$$
{{k}_{{1}}^{{7}}}\ldots{{k}_{{1}}^{{3}}}{{k}_{{1}}^{{2}}}\:={m}-{4}
$$

Note that ${m}$ denotes the length of the original integer being encoded and does not include the extra byte describing the length. The encoding can be used for integers up to $$2^{(63+4)8} -1 = 2^{536} -1$$.


:::
### -sec-num- Hex Encoding {#id-hex-encoding}

Practically, it is more convenient and efficient to store and process data which is stored in a byte array. On the other hand, the trie keys are broken into 4-bits nibbles. Accordingly, we need a method to encode sequences of 4-bits nibbles into byte arrays canonically. To this aim, we define hex encoding function $\text{Enc}{\left(\text{HE}\right)}{\left(\text{PK}\right)}$ as follows:

###### Definition -def-num- Hex Encoding {#defn-hex-encoding}
:::definition

Suppose that $\text{PK}={\left({k}_{{1}},\ldots{k}_{{n}}\right)}$ is a sequence of nibbles, then:

$$
\text{Enc}_{{\text{HE}}}{\left(\text{PK}\right)}\:={\left\lbrace\begin{matrix}\text{Nibbles}_{{4}}&\rightarrow&{\mathbb{{B}}}\\\text{PK}={\left({k}_{{1}},\ldots{k}_{{n}}\right)}&\rightarrow&{\left\lbrace\begin{matrix}{\left({16}{k}_{{1}}+{k}_{{2}},\ldots,{16}{k}_{{{2}{i}-{1}}}+{k}_{{{2}{i}}}\right)}&{n}={2}{i}\\{\left({k}_{{1}},{16}{k}_{{2}}+{k}_{{3}},\ldots,{16}{k}_{{{2}{i}}}+{k}_{{{2}{i}+{1}}}\right)}&{n}={2}{i}+{1}\end{matrix}\right.}\end{matrix}\right.}
$$

:::
## -sec-num- Chain Specification {#chapter-chainspec}
Chain Specification (chainspec) is a collection of information that describes the blockchain network. It includes information required for a host to connect and sync with the Polakdot network, for example, the initial nodes to communicate with, protocol identifier, initial state that the hosts agree, etc. There are a set of core fields required by the Host and a set of extensions that are used by optionally implemented features of the Host. The fields of chain specification are categorized in three parts:
1. [ChainSpec](#sec-num--chain-spec-section-chainspec)
2. [ChainSpec Extensions](#sec-num--chain-spec-extensions-section-chain-spec-extensions)
3. [Genesis State](#sec-num--genesis-state-section-genesis) which is the only mandatory part of the chainspec. 

### -sec-num- Chain Spec {#section-chainspec}

Chain specification contains information used by the Host to communicate with network participants and optionally send data to telemetry endpoints. 

:::definition

The **client specification** contains the fields below. The values for the Polkadot chain are specified:

- _name_: The human-readable name of the chain.
  ```
  "name": "Polkadot"
  ```
- _id_: The id of the chain.
  ```
  "id": "polkadot"
  ```

- _chainType_: Possible values are `Live`, `Development`, `Local`.
  ```
  "chainType": "Live"
  ```

- _bootNodes_: A list of [MultiAddress](https://github.com/libp2p/specs/blob/master/addressing/README.md#multiaddr-in-libp2p) that belong to boot nodes of the chain. 
The list of boot nodes for Polkadot can be found [here](https://raw.githubusercontent.com/paritytech/polkadot/master/node/service/chain-specs/polkadot.json)

- _telemetryEndpoints_: Optional list of "(_multiaddress_, _verbosity_)" pairs of telemetry endpoints. The verbosity goes from `0` to `9`. With `0` being the mode with the lowest verbosity. 

- _forkId_: Optional fork id. Should most likely be left empty. Can be used to signal a fork on the network level when two chains have the same genesis hash. 

```
"forkId": {}
```

- _properties_: Optional additional properties of the chain as subfields including token symbol, token decimals, and address formats.

```
  "properties": {
    "ss58Format": 0,
    "tokenDecimals": 10,
    "tokenSymbol": "DOT"
  }
```

:::


### -sec-num- Chain Spec Extensions {#section-chain-spec-extensions}
ChainSpec Extensions are additional parameters customizable from the chainspec and correspond to optional features implemented in the Host. 

###### Definition -def-num- Bad Blocks Header {#defn-bad-blocks}

:::definition

**BadBlocks** describes a list of block header hashes that are known a priori to be bad (not belonging to the canonical chain) by the host, so that the host can explicitly avoid importing them. These block headers are always considered invalid and filtered out before importing the block:

$$
{badBlocks}={\left({b}_{{0}},\ldots{b}_{{n}}\right)}
$$

where ${b_i}$ is a known invalid [block header hash](#definition--def-num--block-header-hash).

:::

###### Definition -def-num- Fork Blocks {#defn-fork-blocks}

:::definition

**ForkBlocks** describes a list of expected block header hashes at certain block heights. They are used to set trusted checkpoints, i.e., the host will refuse to import a block with a different hash at the given height. Forkblocks are useful mechanisms to guide the Host to the right fork in instances where the chain is bricked (possibly due to issues in runtime upgrades).
$$
{forkBlocks}={\left(<{b}_{{0}},{H}_{{0}}>,\ldots<{b}_{{n}},{H}_{{n}} >\right)}
$$

where ${b_i}$ is an apriori known valid [block header hash](#definition--def-num--block-header-hash) at [block height](#definition--def-num--block-header) ${H_i}$. The host is expected to accept no other block except ${b_i}$ at height ${H_i}$. 

:::

:::info

**lightSyncState** describes a check-pointing format for light clients. Its specification is currently Work-In-Progress. 

:::


### -sec-num- Genesis State {#section-genesis}

The genesis state is a set of key-value pairs representing the initial state of the Polkadot state storage. It can be retrieved from [the Polkadot repository](https://github.com/paritytech/polkadot/tree/master/node/service/chain-specs). While each of those key-value pairs offers important identifiable information to the Runtime, to the Polkadot Host they are a transparent set of arbitrary chain- and network-dependent keys and values. The only exception to this are the `:code` ([Section -sec-num-ref-](chap-state#sect-loading-runtime-code)) and `:heappages` ([Section -sec-num-ref-](chap-state#sect-memory-management)) keys, which are used by the Polkadot Host to initialize the WASM environment and its Runtime. The other keys and values are unspecified and solely depend on the chain and respectively its corresponding Runtime. On initialization, the data should be inserted into the state storage with the Host API ([Section -sec-num-ref-](chap-host-api#sect-storage-set)).

As such, Polkadot does not define a formal genesis block. Nonetheless, for compatibility reasons in several algorithms, the Polkadot Host defines the *genesis header* ([Definition -def-num-ref-](id-cryptography-encoding#defn-genesis-header)). By the abuse of terminology, "genesis block" refers to the hypothetical parent of block number *1* which holds the genesis header as its header.

###### Definition -def-num- Genesis Header {#defn-genesis-header}
:::definition

The Polkadot genesis header is a data structure conforming to block header format ([Definition -def-num-ref-](chap-state#defn-block-header)). It contains the following values:

###### Table -tab-num- Table of Genesis Header Values {#tab-genesis-header-values}
| Block header field | Genesis Header Value                                                                                                                |
|--------------------|-------------------------------------------------------------------------------------------------------------------------------------|
| `parent_hash`      | $0_{\mathbb{B}_{32}}$                                                                                                               |
| `number`           | $0$                                                                                                                                 |
| `state_root`       | Merkle hash of the state storage trie ([Definition -def-num-ref-](chap-state#defn-merkle-value)) after inserting the genesis state in it. |
| `extrinsics_root`  | Merkle hash of an empty trie: $\text{Blake2b}{\left(0_{\mathbb{B}_1}\right)}$                                                       |
| `digest`           | $0$                                                                                                                                 |

:::


###### Definition -def-num- Code Substitutes {#defn-code-substitutes}

:::definition

**Code Substitutes** is a list of pairs of the block numbers and `wasm_code`. The given WASM code will be used to substitute the on-chain WASM code starting with the given block number until the [`spec_version`](chap-runtime-api#defn-rt-core-version) on-chain changes. The substitute code should be as close as possible to the on-chain wasm code. A substitute should be used to fix a bug that can not be fixed with a runtime upgrade if, for example, the runtime is constantly panicking. Introducing new runtime apis isn't supported, because the node will read the runtime version from the on-chain wasm code. Use this functionality only when there is no other way around and to only patch the problematic bug, the rest should be done with an on-chain runtime upgrade.

:::

## -sec-num- Erasure Encoding {#chapter-erasure-encoding}

### -sec-num- Erasure Encoding {#sect-erasure-encoding}

:::info
Erasure Encoding has not been documented yet.
:::
