---
title: Extrinsics
---

## [](#id-introduction-5)[9.1. Introduction](#id-introduction-5)

An extrinsic is a SCALE encoded array consisting of a version number, signature, and varying data types indicating the resulting Runtime function to be called, including the parameters required for that function to be executed.

## [](#id-preliminaries-3)[9.2. Preliminaries](#id-preliminaries-3)

Definition 142. Extrinsic

An extrinsic , ${t}{x}$, is a tuple consisting of the extrinsic version, ${T}_{{v}}$ ([Definition 143](id-extrinsics.html#defn-extrinsic-version)), and the body of the extrinsic, ${T}_{{b}}$.

$$
{t}{x}\:={\left({T}_{{v}},{T}_{{b}}\right)}
$$

The value of ${T}_{{b}}$ varies for each version. The current version 4 is described in [Section 9.3.1](id-extrinsics.html#sect-version-four).

Definition 143. Extrinsic Version

${T}_{{v}}$ is a 8-bit bitfield and defines the extrinsic version. The required format of an extrinsic body, ${T}_{{b}}$, is dictated by the Runtime. Older or unsupported version are rejected.

The most significant bit of ${T}_{{v}}$ indicates whether the transaction is **signed** (${1}$) or **unsigned** (${0}$). The remaining 7-bits represent the version number. As an example, for extrinsic format version 4, an signed extrinsic represents ${T}_{{v}}$ as `132` while a unsigned extrinsic represents it as `4`.

## [](#id-extrinsics-body)[9.3. Extrinsics Body](#id-extrinsics-body)

### [](#sect-version-four)[9.3.1. Version 4](#sect-version-four)

Version 4 of the Polkadot extrinsic format is defined as follows:

$$
{T}_{{b}}\:={\left({A}_{{i}},{S}{i}{g},{E},{M}_{{i}},{F}_{{i}}{\left({m}\right)}\right)}
$$

where  
- ${A}_{{i}}$: the 32-byte address of the sender ([Definition 144](id-extrinsics.html#defn-extrinsic-address)).

- ${S}{i}{g}$: the signature of the sender ([Definition 145](id-extrinsics.html#defn-extrinsic-signature)).

- ${E}$: the extra data for the extrinsic ([Definition 146](id-extrinsics.html#defn-extra-data)).

- ${M}_{{i}}$: the indicator of the Polkadot module ([Definition 147](id-extrinsics.html#defn-module-indicator)).

- ${F}_{{i}}{\left({m}\right)}$: the indicator of the function of the Polkadot module ([Definition 148](id-extrinsics.html#defn-function-indicator)).

Definition 144. Extrinsic Address

Account Id, ${A}_{{i}}$, is the 32-byte address of the sender of the extrinsic as described in the [external SS58 address format](https://github.com/paritytech/substrate/wiki/External-Address-Format-(SS58)).

Definition 145. Extrinsic Signature

The signature, ${S}{i}{g}$, is a varying data type indicating the used signature type, followed by the signature created by the extrinsic author. The following types are supported:

${S}{i}{g}\:={b}{e}{g}\in{\left\lbrace{c}{a}{s}{e}{s}\right\rbrace}{0},&\text{Ed25519, followed by: }\ {\left({b}_{{0}},\ldots,{b}_{{{63}}}\right)}$ 1, & \text{Sr25519, followed by: } (b_0, ...,b\_{63}) ${2},&\text{Ecdsa, followed by: }\ {\left({b}_{{0}},\ldots,{b}_{{{64}}}\right)}{e}{n}{d}{\left\lbrace{c}{a}{s}{e}{s}\right\rbrace}$

Signature types vary in sizes, but each individual type is always fixed-size and therefore does not contain a length prefix. `Ed25519` and `Sr25519` signatures are 512-bit while `Ecdsa` is 520-bit, where the last 8 bits are the recovery ID.

The signature is created by signing payload ${P}$.

${b}{e}{g}\in{\left\lbrace{a}{l}{i}{g}\ne{d}\right\rbrace}{P}&\:={b}{e}{g}\in{\left\lbrace{c}{a}{s}{e}{s}\right\rbrace}{R}{a}{w},&\text{if }\ {\left|{R}{a}{w}\right|}\leq{256}$ Blake2(Raw), & \text{if } \|Raw\| \> 256 ${e}{n}{d}{\left\lbrace{c}{a}{s}{e}{s}\right\rbrace}$ Raw &:= (M_i, F_i(m), E, R_v, F_v, H_h(G), H_h(B)) ${e}{n}{d}{\left\lbrace{a}{l}{i}{g}\ne{d}\right\rbrace}$

where  
- ${M}_{{i}}$: the module indicator ([Definition 147](id-extrinsics.html#defn-module-indicator)).

- ${F}_{{i}}{\left({m}\right)}$: the function indicator of the module ([Definition 148](id-extrinsics.html#defn-function-indicator)).

- ${E}$: the extra data ([Definition 146](id-extrinsics.html#defn-extra-data)).

- ${R}_{{v}}$: a UINT32 containing the specification version (`spec_version`) of the Runtime ([Section C.4.1](chap-runtime-api.html#defn-rt-core-version)), which can be updated and is therefore subject to change.

- ${F}_{{v}}$: a UINT32 containing the transaction version (`transaction_version`) of the Runtime ([Section C.4.1](chap-runtime-api.html#defn-rt-core-version)), which can be updated and is therefore subject to change.

- ${H}_{{h}}{\left({G}\right)}$: a 32-byte array containing the genesis hash.

- ${H}_{{h}}{\left({B}\right)}$: a 32-byte array containing the hash of the block which starts the mortality period, as described in [Definition 149](id-extrinsics.html#defn-extrinsic-mortality).

Definition 146. Extra Data

Extra data, ${E}$, is a tuple containing additional meta data about the extrinsic and the system it is meant to be executed in.

$$
{E}\:={\left({T}_{mor},{N},{P}_{{t}}\right)}
$$

where  
- ${T}_{mor}$: contains the SCALE encoded mortality of the extrinsic ([Definition 149](id-extrinsics.html#defn-extrinsic-mortality)).

- ${N}$: a compact integer containing the nonce of the sender. The nonce must be incremented by one for each extrinsic created, otherwise the Polkadot network will reject the extrinsic.

- ${P}_{{t}}$: a compact integer containing the transactor pay including tip.

Definition 147. Module Indicator

${M}_{{i}}$ is an indicator for the Runtime to which Polkadot *module*, ${m}$, the extrinsic should be forwarded to.

${M}_{{i}}$ is a varying data type pointing to every module exposed to the network.

${M}_{{i}}\:={b}{e}{g}\in{\left\lbrace{c}{a}{s}{e}{s}\right\rbrace}{0},&\text{System}$ 1, & \text{Utility} $\ldots&$ 7, & \text{Balances} $\ldots&{e}{n}{d}{\left\lbrace{c}{a}{s}{e}{s}\right\rbrace}$

Definition 148. Function Indicator

${F}_{{i}}{\left({m}\right)}$ is a tuple which contains an indicator, ${m}_{{i}}$, for the Runtime to which *function* within the Polkadot *module*, ${m}$, the extrinsic should be forwarded to. This indicator is followed by the concatenated and SCALE encoded parameters of the corresponding function, ${p}{a}{r}{a}{m}{s}$.

$$
{F}_{{i}}{\left({m}\right)}\:={\left({m}_{{i}},{p}{a}{r}{a}{m}{s}\right)}
$$

The value of ${m}_{{i}}$ varies for each Polkadot module, since every module offers different functions. As an example, the `Balances` module has the following functions:

${B}{a}{l}{a}{n}{c}{e}{s}_{{i}}\:={b}{e}{g}\in{\left\lbrace{c}{a}{s}{e}{s}\right\rbrace}{0},&\text{transfer}$ 1, & \text{set_balance} ${2},&\text{force_transfer}$ 3, & \text{transfer_keep_alive} $\ldots&{e}{n}{d}{\left\lbrace{c}{a}{s}{e}{s}\right\rbrace}$

### [](#id-mortality)[9.3.2. Mortality](#id-mortality)

Definition 149. Extrinsic Mortality

Extrinsic **mortality** is a mechanism which ensures that an extrinsic is only valid within a certain period of the ongoing Polkadot lifetime. Extrinsics can also be immortal, as clarified in [Section 9.3.2.2](id-extrinsics.html#sect-mortality-encoding).

The mortality mechanism works with two related values:

- ${M}_{{{p}{e}{r}}}$: the period of validity in terms of block numbers from the block hash specified as ${H}_{{h}}{\left({B}\right)}$ in the payload ([Definition 145](id-extrinsics.html#defn-extrinsic-signature)). The requirement is ${M}_{{{p}{e}{r}}}\geq{4}$ and ${M}_{{{p}{e}{r}}}$ must be the power of two, such as `32`, `64`, `128`, etc.

- ${M}_{{{p}{h}{a}}}$: the phase in the period that this extrinsic’s lifetime begins. This value is calculated with a formula and validators can use this value in order to determine which block hash is included in the payload. The requirement is ${M}_{{{p}{h}{a}}}<{M}_{{{p}{e}{r}}}$.

In order to tie a transaction’s lifetime to a certain block (${H}_{{i}}{\left({B}\right)}$) after it was issued, without wasting precious space for block hashes, block numbers are divided into regular periods and the lifetime is instead expressed as a "phase" (${M}_{{{p}{h}{a}}}$) from these regular boundaries:

$$
{M}_{pha}={H}_{{i}}{\left({B}\right)} \; mod \; {M}_{{{p}{e}{r}}}
$$

${M}_{{{p}{e}{r}}}$ and ${M}_{{{p}{h}{a}}}$ are then included in the extrinsic, as clarified in [Definition 146](id-extrinsics.html#defn-extra-data), in the SCALE encoded form of ${T}_{mor}$ ([Section 9.3.2.2](id-extrinsics.html#sect-mortality-encoding)). Polkadot validators can use ${M}_{{{p}{h}{a}}}$ to figure out the block hash included in the payload, which will therefore result in a valid signature if the extrinsic is within the specified period or an invalid signature if the extrinsic "died".

#### [](#id-example)[9.3.2.1. Example](#id-example)

The extrinsic author choses ${M}_{{{p}{e}{r}}}={256}$ at block `10'000`, resulting with ${M}_{{{p}{h}{a}}}={16}$. The extrinsic is then valid for blocks ranging from `10'000` to `10'256`.

#### [](#sect-mortality-encoding)[9.3.2.2. Encoding](#sect-mortality-encoding)

${T}_{mor}$ refers to the SCALE encoded form of type ${M}_{{{p}{e}{r}}}$ and ${M}_{{{p}{h}{a}}}$. ${T}_{mor}$ is the size of two bytes if the extrinsic is considered mortal, or simply one bytes with the value equal to zero if the extrinsic is considered immortal.

$$
{T}_{mor}\:={E}{n}{c}_{{{S}{C}}}{\left({M}_{{{p}{e}{r}}},{M}_{{{p}{h}{a}}}\right)}
$$

The SCALE encoded representation of mortality ${T}_{mor}$ deviates from most other types, as it’s specialized to be the smallest possible value, as described in [Encode Mortality](id-extrinsics.html#algo-mortality-encode) and [Decode Mortality](id-extrinsics.html#algo-mortality-decode).

If the extrinsic is immortal, specify a single byte with the value equal to zero.

\Require{${M}_{{{p}{e}{r}}},{M}_{{{p}{h}{a}}}$} \Return ${0}{e}{n}{s}{p}{a}{c}{e}\text{}{f}{\left\lbrace{\quad\text{if}\quad}\right\rbrace}{e}{n}{s}{p}{a}{c}{e}\text{}{t}{\left\lbrace{e}{x}{t}{r}\in{s}{i}{c}{i}{s}{i}{m}{mor}{t}{a}{l}\right\rbrace}$ \State \textbf{init} ${f}{a}{c}\to{r}=$\call{Limit}{${M}_{{{p}{e}{r}}}>>{12},{1},\phi$} \State \textbf{init} $\le{f}{t}=$\call{Limit}{\call{TZ}{${M}_{{{p}{e}{r}}}$}$-{1},{1},{15}$} \State \textbf{init} ${r}{i}{g}{h}{t}={\frac{{{M}_{{{p}{h}{a}}}}}{{{f}{a}{c}\to{r}}}}<<{4}$ \Return $\le{f}{t}{\mid}{r}{i}{g}{h}{t}$ \Require{${T}_{mor}$} \Return $\text{}{t}{\left\lbrace{I}{m}{mor}{t}{a}{l}\right\rbrace}{e}{n}{s}{p}{a}{c}{e}\text{}{f}{\left\lbrace{\quad\text{if}\quad}\right\rbrace}{e}{n}{s}{p}{a}{c}{e}{T}^{{{b}{0}}}_{\left\lbrace{mor}\right\rbrace}={0}$ \State \textbf{init} ${e}{n}{c}={T}^{{{b}{0}}}_{\left\lbrace{mor}\right\rbrace}+{\left({T}^{{{b}{1}}}_{\left\lbrace{mor}\right\rbrace}<<{8}\right)}$ \State \textbf{init} ${M}_{{{p}{e}{r}}}={2}<<{\left({e}{n}{c}$\right.} mod${\left({1}<<{4}\right)}{)}$ \State \textbf{init} ${f}{a}{c}\to{r}=$ \call{Limit}{${M}_{{{p}{e}{r}}}>>{12},{1},\phi$} \State \textbf{init} ${M}_{{{p}{h}{a}}}={\left({e}{n}{c}>>{4}\right)}\cdot{f}{a}{c}\to{r}$ \Return ${\left({M}_{{{p}{e}{r}}},{M}_{{{p}{h}{a}}}\right)}$

where  
- ${T}^{{{b}{0}}}_{\left\lbrace{mor}\right\rbrace}$: the first byte of ${T}_{mor}$.

- ${T}^{{{b}{1}}}_{\left\lbrace{mor}\right\rbrace}$: the second byte of ${T}_{mor}$.

- Limit($\nu{m}$, $\min$, $\max$): Ensures that $\nu{m}$ is between $\min$ and $\max$. If $\min$ or $\max$ is defined as $\phi$, then there is no requirement for the specified minimum/maximum.

- TZ($\nu{m}$): returns the number of trailing zeros in the binary representation of $\nu{m}$. For example, the binary representation of `40` is `0010 1000`, which has three trailing zeros.

- $>>$: performs a binary right shift operation.

- $<<$: performs a binary left shift operation.

- ${\mid}$ : performs a bitwise OR operation.
