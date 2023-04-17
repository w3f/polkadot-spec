---
title: Extrinsics
---

## -sec-num- Introduction {#id-introduction-5}

An extrinsic is a SCALE encoded array consisting of a version number, signature, and varying data types indicating the resulting Runtime function to be called, including the parameters required for that function to be executed.

## -sec-num- Preliminaries {#id-preliminaries-3}

###### Definition -def-num- Extrinsic {#defn-extrinsic}
:::definition

An extrinsic , ${t}{x}$, is a tuple consisting of the extrinsic version, ${T}_{{v}}$ ([Definition -def-num-ref-](id-extrinsics#defn-extrinsic-version)), and the body of the extrinsic, ${T}_{{b}}$.

$$
{t}{x}\:={\left({T}_{{v}},{T}_{{b}}\right)}
$$

The value of ${T}_{{b}}$ varies for each version. The current version 4 is described in [Section -sec-num-ref-](id-extrinsics#sect-version-four).

:::
###### Definition -def-num- Extrinsic Version {#defn-extrinsic-version}
:::definition

${T}_{{v}}$ is a 8-bit bitfield and defines the extrinsic version. The required format of an extrinsic body, ${T}_{{b}}$, is dictated by the Runtime. Older or unsupported version are rejected.

The most significant bit of ${T}_{{v}}$ indicates whether the transaction is **signed** (${1}$) or **unsigned** (${0}$). The remaining 7-bits represent the version number. As an example, for extrinsic format version 4, an signed extrinsic represents ${T}_{{v}}$ as `132` while a unsigned extrinsic represents it as `4`.

:::
## -sec-num- Extrinsics Body {#id-extrinsics-body}

### -sec-num- Version 4 {#sect-version-four}

Version 4 of the Polkadot extrinsic format is defined as follows:

$$
{T}_{{b}}\:={\left({A}_{{i}},{Sig},{E},{M}_{{i}},{F}_{{i}}{\left({m}\right)}\right)}
$$

**where**  
- ${A}_{{i}}$: the 32-byte address of the sender ([Definition -def-num-ref-](id-extrinsics#defn-extrinsic-address)).

- ${Sig}$: the signature of the sender ([Definition -def-num-ref-](id-extrinsics#defn-extrinsic-signature)).

- ${E}$: the extra data for the extrinsic ([Definition -def-num-ref-](id-extrinsics#defn-extra-data)).

- ${M}_{{i}}$: the indicator of the Polkadot module ([Definition -def-num-ref-](id-extrinsics#defn-module-indicator)).

- ${F}_{{i}}{\left({m}\right)}$: the indicator of the function of the Polkadot module ([Definition -def-num-ref-](id-extrinsics#defn-function-indicator)).

###### Definition -def-num- Extrinsic Address {#defn-extrinsic-address}
:::definition

Account Id, ${A}_{{i}}$, is the 32-byte address of the sender of the extrinsic as described in the [external SS58 address format](https://github.com/paritytech/substrate/wiki/External-Address-Format-(SS58)).

:::
###### Definition -def-num- Extrinsic Signature {#defn-extrinsic-signature}
:::definition

The signature, ${Sig}$, is a varying data type indicating the used signature type, followed by the signature created by the extrinsic author. The following types are supported:

$$
Sig :=
\begin{cases}
0, & \text{Ed25519, followed by: } (b_0, \ldots,b_{63}) \\
1, & \text{Sr25519, followed by: } (b_0, \ldots,b_{63}) \\
2, & \text{Ecdsa, followed by: } (b_0, \ldots,b_{64})
\end{cases}
$$


Signature types vary in sizes, but each individual type is always fixed-size and therefore does not contain a length prefix. `Ed25519` and `Sr25519` signatures are 512-bit while `Ecdsa` is 520-bit, where the last 8 bits are the recovery ID.

The signature is created by signing payload ${P}$.

$$
\begin{aligned}
P &:= \begin{cases}
Raw, & \text{if } \|Raw\| \leq 256 \\
\text{Blake2}(Raw), & \text{if } \|Raw\| > 256 \\
\end{cases} \\
Raw &:= (M_i, F_i(m), E, R_v, F_v, H_h(G), H_h(B))
\end{aligned}
$$

**where**  
- ${M}_{{i}}$: the module indicator ([Definition -def-num-ref-](id-extrinsics#defn-module-indicator)).

- ${F}_{{i}}{\left({m}\right)}$: the function indicator of the module ([Definition -def-num-ref-](id-extrinsics#defn-function-indicator)).

- ${E}$: the extra data ([Definition -def-num-ref-](id-extrinsics#defn-extra-data)).

- ${R}_{{v}}$: a UINT32 containing the specification version (`spec_version`) of the Runtime ([Section -sec-num-ref-](chap-runtime-api#defn-rt-core-version)), which can be updated and is therefore subject to change.

- ${F}_{{v}}$: a UINT32 containing the transaction version (`transaction_version`) of the Runtime ([Section -sec-num-ref-](chap-runtime-api#defn-rt-core-version)), which can be updated and is therefore subject to change.

- ${H}_{{h}}{\left({G}\right)}$: a 32-byte array containing the genesis hash.

- ${H}_{{h}}{\left({B}\right)}$: a 32-byte array containing the hash of the block which starts the mortality period, as described in [Definition -def-num-ref-](id-extrinsics#defn-extrinsic-mortality).

:::
###### Definition -def-num- Extra Data {#defn-extra-data}
:::definition

Extra data, ${E}$, is a tuple containing additional meta data about the extrinsic and the system it is meant to be executed in.

$$
{E}\:={\left({T}_{mor},{N},{P}_{{t}}\right)}
$$

**where**  
- ${T}_{mor}$: contains the SCALE encoded mortality of the extrinsic ([Definition -def-num-ref-](id-extrinsics#defn-extrinsic-mortality)).

- ${N}$: a compact integer containing the nonce of the sender. The nonce must be incremented by one for each extrinsic created, otherwise the Polkadot network will reject the extrinsic.

- ${P}_{{t}}$: a compact integer containing the transactor pay including tip.

:::
###### Definition -def-num- Module Indicator {#defn-module-indicator}
:::definition

${M}_{{i}}$ is an indicator for the Runtime to which Polkadot *module*, ${m}$, the extrinsic should be forwarded to.

${M}_{{i}}$ is a varying data type pointing to every module exposed to the network.

$$
M_i := \begin{cases}
0, & \text{System} \\
1, & \text{Utility} \\
\ldots & \\
7, & \text{Balances} \\
\ldots &
\end{cases}
$$

:::
###### Definition -def-num- Function Indicator {#defn-function-indicator}
:::definition

${F}_{{i}}{\left({m}\right)}$ is a tuple which contains an indicator, ${m}_{{i}}$, for the Runtime to which *function* within the Polkadot *module*, ${m}$, the extrinsic should be forwarded to. This indicator is followed by the concatenated and SCALE encoded parameters of the corresponding function, ${p}{a}{r}{a}{m}{s}$.

$$
{F}_{{i}}{\left({m}\right)}\:={\left({m}_{{i}},{p}{a}{r}{a}{m}{s}\right)}
$$

The value of ${m}_{{i}}$ varies for each Polkadot module, since every module offers different functions. As an example, the `Balances` module has the following functions:

$$
Balances_i := \begin{cases}
0, & \text{transfer} \\
1, & \text{set\_balance} \\
2, & \text{force\_transfer} \\
3, & \text{transfer\_keep\_alive} \\
\ldots &
\end{cases}
$$

:::
### -sec-num- Mortality {#id-mortality}

###### Definition -def-num- Extrinsic Mortality {#defn-extrinsic-mortality}
:::definition

Extrinsic **mortality** is a mechanism which ensures that an extrinsic is only valid within a certain period of the ongoing Polkadot lifetime. Extrinsics can also be immortal, as clarified in [Section -sec-num-ref-](id-extrinsics#sect-mortality-encoding).

The mortality mechanism works with two related values:

- ${M}_{{{per}}}$: the period of validity in terms of block numbers from the block hash specified as ${H}_{{h}}{\left({B}\right)}$ in the payload ([Definition -def-num-ref-](id-extrinsics#defn-extrinsic-signature)). The requirement is ${M}_{{{per}}}\geq{4}$ and ${M}_{{{per}}}$ must be the power of two, such as `32`, `64`, `128`, etc.

- ${M}_{{{pha}}}$: the phase in the period that this extrinsic’s lifetime begins. This value is calculated with a formula and validators can use this value in order to determine which block hash is included in the payload. The requirement is ${M}_{{{pha}}}<{M}_{{{per}}}$.

In order to tie a transaction’s lifetime to a certain block (${H}_{{i}}{\left({B}\right)}$) after it was issued, without wasting precious space for block hashes, block numbers are divided into regular periods and the lifetime is instead expressed as a "phase" (${M}_{{{pha}}}$) from these regular boundaries:

$$
{M}_{pha}={H}_{{i}}{\left({B}\right)} \; mod \; {M}_{{{per}}}
$$

${M}_{{{per}}}$ and ${M}_{{{pha}}}$ are then included in the extrinsic, as clarified in [Definition -def-num-ref-](id-extrinsics#defn-extra-data), in the SCALE encoded form of ${T}_{mor}$ ([Section -sec-num-ref-](id-extrinsics#sect-mortality-encoding)). Polkadot validators can use ${M}_{{{pha}}}$ to figure out the block hash included in the payload, which will therefore result in a valid signature if the extrinsic is within the specified period or an invalid signature if the extrinsic "died".

:::
#### -sec-num- Example {#id-example}

The extrinsic author choses ${M}_{{{per}}}={256}$ at block `10'000`, resulting with ${M}_{{{pha}}}={16}$. The extrinsic is then valid for blocks ranging from `10'000` to `10'256`.

#### -sec-num- Encoding {#sect-mortality-encoding}

${T}_{mor}$ refers to the SCALE encoded form of type ${M}_{{{per}}}$ and ${M}_{{{pha}}}$. ${T}_{mor}$ is the size of two bytes if the extrinsic is considered mortal, or simply one bytes with the value equal to zero if the extrinsic is considered immortal.

$$
{T}_{mor}\:={E}{n}{c}_{{{S}{C}}}{\left({M}_{{{per}}},{M}_{{{pha}}}\right)}
$$

The SCALE encoded representation of mortality ${T}_{mor}$ deviates from most other types, as it’s specialized to be the smallest possible value, as described in [Encode Mortality](id-extrinsics#algo-mortality-encode) and [Decode Mortality](id-extrinsics#algo-mortality-decode).

If the extrinsic is immortal, specify a single byte with the value equal to zero.

\Require{${M}_{{{per}}},{M}_{{{pha}}}$} \Return ${0}{e}{n}{s}{p}{a}{c}{e}\text{}{f}{\left\lbrace{\quad\text{if}\quad}\right\rbrace}{e}{n}{s}{p}{a}{c}{e}\text{}{t}{\left\lbrace{e}{x}{t}{r}\in{s}{i}{c}{i}{s}{i}{m}{mor}{t}{a}{l}\right\rbrace}$ \State \textbf{init} ${f}{a}{c}\to{r}=$\call{Limit}{${M}_{{{per}}}>>{12},{1},\phi$} \State \textbf{init} $\le{f}{t}=$\call{Limit}{\call{TZ}{${M}_{{{per}}}$}$-{1},{1},{15}$} \State \textbf{init} ${r}{i}{g}{h}{t}={\frac{{{M}_{{{pha}}}}}{{{f}{a}{c}\to{r}}}}<<{4}$ \Return $\le{f}{t}{\mid}{r}{i}{g}{h}{t}$ \Require{${T}_{mor}$} \Return $\text{}{t}{\left\lbrace{I}{m}{mor}{t}{a}{l}\right\rbrace}{e}{n}{s}{p}{a}{c}{e}\text{}{f}{\left\lbrace{\quad\text{if}\quad}\right\rbrace}{e}{n}{s}{p}{a}{c}{e}{T}^{{{b}{0}}}_{\left\lbrace{mor}\right\rbrace}={0}$ \State \textbf{init} ${e}{n}{c}={T}^{{{b}{0}}}_{\left\lbrace{mor}\right\rbrace}+{\left({T}^{{{b}{1}}}_{\left\lbrace{mor}\right\rbrace}<<{8}\right)}$ \State \textbf{init} ${M}_{{{per}}}={2}<<{\left({e}{n}{c}$\right.} mod${\left({1}<<{4}\right)}{)}$ \State \textbf{init} ${f}{a}{c}\to{r}=$ \call{Limit}{${M}_{{{per}}}>>{12},{1},\phi$} \State \textbf{init} ${M}_{{{pha}}}={\left({e}{n}{c}>>{4}\right)}\cdot{f}{a}{c}\to{r}$ \Return ${\left({M}_{{{per}}},{M}_{{{pha}}}\right)}$

**where**  
- ${T}^{{{b}{0}}}_{\left\lbrace{mor}\right\rbrace}$: the first byte of ${T}_{mor}$.

- ${T}^{{{b}{1}}}_{\left\lbrace{mor}\right\rbrace}$: the second byte of ${T}_{mor}$.

- Limit(${num}$, ${min}$, ${max}$): Ensures that ${num}$ is between ${min}$ and ${max}$. If ${min}$ or ${max}$ is defined as $\phi$, then there is no requirement for the specified minimum/maximum.

- TZ(${num}$): returns the number of trailing zeros in the binary representation of ${num}$. For example, the binary representation of `40` is `0010 1000`, which has three trailing zeros.

- $>>$: performs a binary right shift operation.

- $<<$: performs a binary left shift operation.

- ${\mid}$ : performs a bitwise OR operation.
