---
title: Metadata
---

The runtime metadata structure contains all the information necessary on how to interact with the Polkadot runtime. Considering that Polkadot runtimes are upgradable and therefore any interfaces are subject to change, the metadata allows developers to structure any extrinsics or storage entries accordingly.

The metadata of a runtime is provided by a call to `Metadata_metadata` ([Section C.5.1](chap-runtime-api#sect-rte-metadata-metadata)) and is returned as a scale encoded ([Section A.2.2](id-cryptography-encoding#sect-scale-codec)) binary blob. How to interpret and decode this data is described in this chapter.

## 12.1. Structure {#sect-rtm-structure}

The Runtime Metadata is a datastructure of the following format:

$$
{\left({M},{v}_{{m}},{R},{P},{t}_{{e}},{v}_{{e}},{E},{t}_{{r}}\right)}
$$
$$
{R}={\left({r}_{{0}},\ldots,{r}_{{n}}\right)}
$$
$$
{P}={\left({p}_{{0}},\ldots,{p}_{{n}}\right)}
$$
$$
{E}={\left({e}_{{0}},\ldots,{e}_{{n}}\right)}
$$

where  
- ${M}$ are the first four constant bytes, spelling "meta" in ASCII.

- ${v}_{{m}}$ is an unsigned 8-bit integer indicating the format version of the metadata structure (currently the value of `14`).

- ${R}$ is a sequence ([Definition -def-num-ref-](id-cryptography-encoding#defn-scale-list)) of type definitions ${r}_{{i}}$ ([Definition -def-num-ref-](sect-metadata#defn-rtm-registry-entry)).

- ${P}$ is a sequence ([Definition -def-num-ref-](id-cryptography-encoding#defn-scale-list)) of pallet metadata ${p}_{{i}}$ ([Section 12.2](sect-metadata#sect-rtm-pallet-metadata)).

- ${t}_{{e}}$ is the type Id ([Definition -def-num-ref-](sect-metadata#defn-rtm-type-id)) of the extrinsics.

- ${v}_{{e}}$ is an unsigned 8-bit integer indicating the format version of the extrinsics (implying a possible breaking change).

- ${E}$ is a sequence ([Definition -def-num-ref-](id-cryptography-encoding#defn-scale-list)) of extrinsics metadata ${e}_{{i}}$ ([Definition -def-num-ref-](sect-metadata#defn-rtm-signed-extension-metadata)).

- ${t}_{{r}}$ is the type Id ([Definition -def-num-ref-](sect-metadata#defn-rtm-type-id)) of the runtime.

###### Image: Metadata {#img-metadata}
import Metadata from '/static/img/kaitai_render/metadata.svg';

<Metadata className="graphviz" />

###### Definition -def-num- Runtime Registry Type Entry {#defn-rtm-registry-entry}

A registry entry contains information about a type in its portable form for serialization. The entry is a datastructure of the following format:

$$
{r}_{{i}}={\left(\text{id}_{{t}},{p},{T},{D},{c}\right)}
$$
$$
{T}={\left({t}_{{0}},\ldots,{t}_{{n}}\right)}
$$
$$
{t}_{{i}}={\left({n},{y}\right)}
$$

where  
- $\text{id}_{{t}}$ is a compact integer indicating the identifier of the type.

- ${p}$ is the path of the type, optional and based on source file location. Encoded as a sequence ([Definition -def-num-ref-](id-cryptography-encoding#defn-scale-list)) of strings.

- ${T}$ is a sequence ([Definition -def-num-ref-](id-cryptography-encoding#defn-scale-list)) of generic parameters (empty for non-generic types).

  - ${n}$ is the name string of the generic type parameter

  - ${y}$ is a *Option* type containing a type Id ([Definition -def-num-ref-](sect-metadata#defn-rtm-type-id)).

- ${D}$ is the type definition ([Definition -def-num-ref-](sect-metadata#defn-rtm-type-definition)).

- ${c}$ is the documentation as sequence ([Definition -def-num-ref-](id-cryptography-encoding#defn-scale-list)) of strings.

###### Image: Metadata Type {#img-metadata-type}
import MetadataType from '/static/img/kaitai_render/metadata_type.svg';

<MetadataType className="graphviz" /> 

###### Definition -def-num- Runtime Type Id {#defn-rtm-type-id}

The **runtime type Id** is a compact integer representing the index of the entry ([Definition -def-num-ref-](sect-metadata#defn-rtm-registry-entry)) in ${R},{P}$ or ${E}$ of the runtime metadata structure ([Section 12.1](sect-metadata#sect-rtm-structure)), depending on context (starting at ${0}$).

###### Definition -def-num- Type Variant {#defn-rtm-type-definition}

The type definition ${D}$ is a varying datatype ([Definition -def-num-ref-](id-cryptography-encoding#defn-varrying-data-type)) and indicates all the possible types of encodable values a type can have.

$$
{D}={\left\lbrace\begin{matrix}{0}&->&{C}&\text{composite type (e.g. structure or tuple)}\\{1}&->&{V}&\text{variant type}\\{2}&->&{s}_{{v}}&\text{sequence type varying length}\\{3}&->&{S}&\text{sequence with fixed length}\\{4}&->&{T}&\text{tuple type}\\{5}&->&{P}&\text{primitive type}\\{6}&->&{e}&\text{compact encoded type}\\{7}&->&{B}&\text{sequence of bits}\end{matrix}\right.}
$$

where  
- ${C}$ is a sequence of the following format:

  ${C}={\left({{f}_{{0}},}\ldots,{f}_{{n}}\right)}$

  - ${f_i}$ is a field ([Definition -def-num-ref-](sect-metadata#defn-rtm-field)).

- ${V}$ is a sequence of the following format:

  ${V}={\left({v}_{{0}},\ldots,{v}_{{n}}\right)}$

  - ${v}_{{i}}$ is a variant ([Definition -def-num-ref-](sect-metadata#defn-rtm-variant)).

- ${s}_{{v}}$ is a type Id ([Definition -def-num-ref-](sect-metadata#defn-rtm-type-id)).

- ${S}$ is of the following format:

  ${S}={\left({l},{y}\right)}$

  - ${l}$ is a unsigned 32-bit integer indicating the length

  - ${y}$ is a type Id ([Definition -def-num-ref-](sect-metadata#defn-rtm-type-id)).

- ${T}$ is a sequence ([Definition -def-num-ref-](id-cryptography-encoding#defn-scale-list)) of type Ids ([Definition -def-num-ref-](sect-metadata#defn-rtm-type-id)).

- ${P}$ is a varying datatype ([Definition -def-num-ref-](id-cryptography-encoding#defn-varrying-data-type)) of the following structure:

  $$
  {P}={\left\lbrace\begin{matrix}{0}&\text{boolean}\\{1}&\text{char}\\{2}&\text{string}\\{3}&\text{unsigned 8-bit integer}\\{4}&\text{unsigned 16-bit integer}\\{5}&\text{unsigned 32-bit integer}\\{6}&\text{unsigned 64-bit integer}\\{7}&\text{unsigned 128-bit integer}\\{8}&\text{unsigned 256-bit integer}\\{9}&\text{signed 8-bit integer}\\{10}&\text{signed 16-bit integer}\\{11}&\text{signed 32-bit integer}\\{12}&\text{signed 64-bit integer}\\{13}&\text{signed 128-bit integer}\\{14}&\text{signed 256-bit integer}\end{matrix}\right.}
  $$

- ${e}$ is a type Id ([Definition -def-num-ref-](sect-metadata#defn-rtm-type-id)).

- ${B}$ is a datastructure of the following format:

  ${B}={\left({s},{o}\right)}$

  - ${s}$ is a type Id ([Definition -def-num-ref-](sect-metadata#defn-rtm-type-id)) representing the bit store order ([external reference](https://docs.rs/bitvec/latest/bitvec/store/trait.BitStore))

  - ${o}$ is a type Id ([Definition -def-num-ref-](sect-metadata#defn-rtm-type-id)) the bit order type ([external reference](https://docs.rs/bitvec/latest/bitvec/order/trait.BitOrder)).

###### Image: Metadata Type Definition {#img-metadata-type-definition}
import MetadataTypeDefinition from '/static/img/kaitai_render/metadata_type_definition.svg';

<MetadataTypeDefinition className="graphviz"  />

###### Definition -def-num- Field {#defn-rtm-field}

A field of a datastructure of the following format:

$$
{{f}_{{i}}=}{\left({n},{y},{y}_{{n}},{C}\right)}
$$

where

- ${n}$ is an *Option* type containing the string that indicates the field name.

- ${y}$ is a type Id ([Definition -def-num-ref-](sect-metadata#defn-rtm-type-id)).

- ${y}_{{n}}$ is an *Option* type containing a string that indicates the name of the type as it appears in the source code.

- ${C}$ is a sequence of varying length containing strings of documentation.

###### Image: Metadata Type Fields {#img-metadata-type-fields}
import MetadataTypeFields from '/static/img/kaitai_render/metadata_type_fields.svg';

<MetadataTypeFields className="graphviz" />

###### Definition -def-num- Variant {#defn-rtm-variant}

A struct variant of the following format:

$$
{v}_{{i}}={\left({n},{F},{k},{C}\right)}
$$

where

- ${n}$ is a string representing the name of the variant.

- ${F}$ is a possible empty array of varying length containing field ([Definition -def-num-ref-](sect-metadata#defn-rtm-field)) elements.

- ${k}$ is an unsigned 8-bit integer indicating the index of the variant.

- ${C}$ is a sequence of strings containing the documentation.

###### Image: Metadata Type Variants {#img-metadata-type-variants}
import MetadataTypeVariants from '/static/img/kaitai_render/metadata_type_variants.svg';

<MetadataTypeVariants className="graphviz" />

## 12.2. Pallet Metadata {#sect-rtm-pallet-metadata}

All the metadata about a pallet, part of the main structure ([Section 12.1](sect-metadata#sect-rtm-structure)) and of the following format:

$$
{p}_{{i}}={\left({n},{S},{a},{e},{C},{e},{i}\right)}
$$

where

- ${n}$ is a string representing the pallet name.

- ${S}$ is an *Option* type containing the pallet storage metadata ([Definition -def-num-ref-](sect-metadata#defn-rtm-pallet-storage-metadata)).

- ${a}$ is an *Option* type ([Definition -def-num-ref-](id-cryptography-encoding#defn-option-type)) containing the type Id ([Definition -def-num-ref-](sect-metadata#defn-rtm-type-id)) of pallet calls.

- ${e}$ is an *Option* type ([Definition -def-num-ref-](id-cryptography-encoding#defn-option-type)) containing the type Id ([Definition -def-num-ref-](sect-metadata#defn-rtm-type-id)) of pallet events.

- ${C}$ is an *Sequence* ([Definition -def-num-ref-](id-cryptography-encoding#defn-scale-list)) of all pallet constant metadata ([Definition -def-num-ref-](sect-metadata#defn-rtm-pallet-constants)).

- ${e}$ is an *Option* type ([Definition -def-num-ref-](id-cryptography-encoding#defn-option-type)) containing the type Id ([Definition -def-num-ref-](sect-metadata#defn-rtm-type-id)) of the pallet error.

- ${i}$ is an unsigned 8-bit integers indicating the index of the pallet, which is used for encoding pallet events and calls.

###### Image: Metadata Pallet {#img-metadata-pallet}
import MetadataPallet from '/static/img/kaitai_render/metadata_pallet.svg';

<MetadataPallet className="graphviz" />

###### Definition -def-num- Pallet Storage Metadata {#defn-rtm-pallet-storage-metadata}

The metadata about a pallets storage.

$$
{S}={\left({p},{E}\right)}
$$
$$
{E}={\left({e}_{{0}},\ldots,{e}_{{n}}\right)}
$$

where

- ${p}$ is the string representing the common prefix used by all storage entries.

- ${E}$ is an array of varying length containing elements of storage entries ([Definition -def-num-ref-](sect-metadata#defn-rtm-storage-entry-metadata)).

###### Definition -def-num- Storage Entry Metadata {#defn-rtm-storage-entry-metadata}

The metadata about a pallets storage entry.

$$
{e}_{{i}}={\left({n},{m},{y},{d},{C}\right)}
$$
$$
{C}={\left({c}_{{0}},\ldots,{c}_{{n}}\right)}
$$

where

- ${n}$ is the string representing the variable name of the storage entry.

- ${m}$ is an enum type determining the storage entry modifier ([Definition -def-num-ref-](sect-metadata#defn-rtm-storage-entry-modifier)).

- ${y}$ is the type of the value stored in the entry ([Definition -def-num-ref-](sect-metadata#defn-rtm-storage-entry-type)).

- ${d}$ is an byte array containing the default value.

- ${C}$ is an array of varying length of strings containing the documentation.

###### Image: Pallet Storage {#img-pallet-storage}
import PalletStorage from '/static/img/kaitai_render/pallet_storage.svg';

<PalletStorage className="graphviz" />

###### Definition -def-num- Storage Entry Modifier {#defn-rtm-storage-entry-modifier}

|     |                                                 |
|-----|-------------------------------------------------|
|     | This might be incorrect and has to be reviewed. |

The storage entry modifier is a varying datatype ([Definition -def-num-ref-](id-cryptography-encoding#defn-varrying-data-type)) and indicates how the storage entry is returned and how it behaves if the entry is not present.

$$
{m}={\left\lbrace\begin{matrix}{0}&\text{optional}\\{1}&\text{default}\end{matrix}\right.}
$$

where *0* indicates that the entry returns an *Option* type and therefore *None* if the storage entry is not present. *1* indicates that the entry returns the type ${y}$ with default value ${d}$ (in [Definition -def-num-ref-](sect-metadata#defn-rtm-storage-entry-metadata)) if the entry is not present.

###### Definition -def-num- Storage Entry Type {#defn-rtm-storage-entry-type}

The type of the storage value is a varying datatype ([Definition -def-num-ref-](id-cryptography-encoding#defn-varrying-data-type)) that indicates how the entry is stored.

$$
{y}={\left\lbrace\begin{matrix}{0}&->&{t}&\text{plain type}\\{1}&->&{\left({H},{k},{v}\right)}&\text{storage map}\end{matrix}\right.}
$$

where ${t}$, ${k}$ (key) and ${v}$ (value) are all of type Ids ([Definition -def-num-ref-](sect-metadata#defn-rtm-type-id)). ${H}$ is an array of varying length containing the storage hasher ([Definition -def-num-ref-](sect-metadata#defn-rtm-storage-hasher)).

###### Image: Storage Definition {#img-storage-definition}
import StorageDefinition from '/static/img/kaitai_render/storage_definition.svg';

<StorageDefinition className="graphviz" />

###### Definition -def-num- Storage Hasher {#defn-rtm-storage-hasher}

The hashing algorithm used by storage maps.

$$
{\left\lbrace\begin{matrix}{0}&\text{128-bit Blake2 hash}\\{1}&\text{256-bit Blake2 hash}\\{2}&\text{Multiple 128-bit Blake2 hashes concatenated}\\{3}&\text{128-bit XX hash}\\{4}&\text{256-bit XX hash}\\{5}&\text{Multiple 64-bit XX hashes concatenated}\\{6}&\text{Identity hashing}\end{matrix}\right.}
$$

###### Definition -def-num- Pallet Constants {#defn-rtm-pallet-constants}

The metadata about the pallets constants.

$$
{c}_{{i}}={\left({n},{y},{v},{C}\right)}
$$

where  
- ${n}$ is a string representing the name of the pallet constant.

- ${y}$ is the type Id ([Definition -def-num-ref-](sect-metadata#defn-rtm-type-id)) of the pallet constant.

- ${v}$ is a byte array containing the value of the constant.

- ${C}$ is an array of varying length containing string with the documentation.

###### Image: Pallet Constant {#img-pallet-constant}
import PalletConstant from '/static/img/kaitai_render/pallet_constant.svg';

<PalletConstant className="graphviz" />

## 12.3. Extrinsic Metadata {#sect-rtm-extrinsic-metadata}

The metadata about a pallets extrinsics, part of the main structure ([Section 12.1](sect-metadata#sect-rtm-structure)) and of the following format:

###### Definition -def-num- Signed Extension Metadata {#defn-rtm-signed-extension-metadata}

The metadata about the additional, signed data required to execute an extrinsic.

$$
{e}_{{i}}={\left({n},{y},{a}\right)}
$$

where  
- ${n}$ is a string representing the unique signed extension identifier, which may be different from the type name.

- ${y}$ is a type Id ([Definition -def-num-ref-](sect-metadata#defn-rtm-type-id)) of the signed extension, with the data to be included in the extrinsic.

- ${a}$ is the type Id ([Definition -def-num-ref-](sect-metadata#defn-rtm-type-id)) of the additional signed data, with the data to be included in the signed payload.

###### Image: Metadata Extrinsic {#img-metadata-extrinsic}
import MetadataExtrinsic from '/static/img/kaitai_render/metadata_extrinsic.svg';

<MetadataExtrinsic className="graphviz" />
