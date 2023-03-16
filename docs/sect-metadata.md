---
title: Metadata
---

The runtime metadata structure contains all the information necessary on how to interact with the Polkadot runtime. Considering that Polkadot runtimes are upgradable and therefore any interfaces are subject to change, the metadata allows developers to structure any extrinsics or storage entries accordingly.

The metadata of a runtime is provided by a call to `Metadata_metadata` ([Section C.5.1](chap-runtime-api.html#sect-rte-metadata-metadata)) and is returned as a scale encoded ([Section A.2.2](id-cryptography-encoding.html#sect-scale-codec)) binary blob. How to interpret and decode this data is described in this chapter.

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

- ${R}$ is a sequence ([Definition 192](id-cryptography-encoding.html#defn-scale-list)) of type definitions ${r}_{{i}}$ ([Definition 159](sect-metadata.html#defn-rtm-registry-entry)).

- ${P}$ is a sequence ([Definition 192](id-cryptography-encoding.html#defn-scale-list)) of pallet metadata ${p}_{{i}}$ ([Section 12.2](sect-metadata.html#sect-rtm-pallet-metadata)).

- ${t}_{{e}}$ is the type Id ([Definition 160](sect-metadata.html#defn-rtm-type-id)) of the extrinsics.

- ${v}_{{e}}$ is an unsigned 8-bit integer indicating the format version of the extrinsics (implying a possible breaking change).

- ${E}$ is a sequence ([Definition 192](id-cryptography-encoding.html#defn-scale-list)) of extrinsics metadata ${e}_{{i}}$ ([Definition 170](sect-metadata.html#defn-rtm-signed-extension-metadata)).

- ${t}_{{r}}$ is the type Id ([Definition 160](sect-metadata.html#defn-rtm-type-id)) of the runtime.

seq: - id: magic contents: meta - id: metadata_version type: u1 - id: num_types type: scale::compact_int - id: types type: metadata_type repeat: expr repeat-expr: num_types.value - id: num_pallets type: scale::compact_int - id: pallets type: metadata_pallet repeat: expr repeat-expr: num_pallets.value - id: extrinsic_type type: scale::compact_int - id: extrinsic_version type: u1 - id: num_extrinsics type: scale::compact_int - id: extrinsics type: metadata_extrinsic repeat: expr repeat-expr: num_extrinsics.value - id: runtime_type type: scale::compact_int

Definition 159. [Runtime Registry Type Entry](sect-metadata.html#defn-rtm-registry-entry)

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

- ${p}$ is the path of the type, optional and based on source file location. Encoded as a sequence ([Definition 192](id-cryptography-encoding.html#defn-scale-list)) of strings.

- ${T}$ is a sequence ([Definition 192](id-cryptography-encoding.html#defn-scale-list)) of generic parameters (empty for non-generic types).

  - ${n}$ is the name string of the generic type parameter

  - ${y}$ is a *Option* type containing a type Id ([Definition 160](sect-metadata.html#defn-rtm-type-id)).

- ${D}$ is the type definition ([Definition 161](sect-metadata.html#defn-rtm-type-definition)).

- ${c}$ is the documentation as sequence ([Definition 192](id-cryptography-encoding.html#defn-scale-list)) of strings.

seq: - id: id type: scale::compact_int - id: path type: scale::string_list - id: num_params type: scale::compact_int - id: params repeat: expr repeat-expr: num_params.value type: param - id: definition type: metadata_type_definition - id: docs type: scale::string_list types: param: seq: - id: name type: scale::string - id: type type: scale::maybe_compact_int

Definition 160. [Runtime Type Id](sect-metadata.html#defn-rtm-type-id)

The **runtime type Id** is a compact integer representing the index of the entry ([Definition 159](sect-metadata.html#defn-rtm-registry-entry)) in ${R},{P}$ or ${E}$ of the runtime metadata structure ([Section 12.1](sect-metadata.html#sect-rtm-structure)), depending on context (starting at ${0}$).

Definition 161. [Type Variant](sect-metadata.html#defn-rtm-type-definition)

The type definition ${D}$ is a varying datatype ([Definition 188](id-cryptography-encoding.html#defn-varrying-data-type)) and indicates all the possible types of encodable values a type can have.

$$
{D}={\left\lbrace\begin{matrix}{0}&->&{C}&\text{composite type (e.g. structure or tuple)}\\{1}&->&{V}&\text{variant type}\\{2}&->&{s}_{{v}}&\text{sequence type varying length}\\{3}&->&{S}&\text{sequence with fixed length}\\{4}&->&{T}&\text{tuple type}\\{5}&->&{P}&\text{primitive type}\\{6}&->&{e}&\text{compact encoded type}\\{7}&->&{B}&\text{sequence of bits}\end{matrix}\right.}
$$

where  
- ${C}$ is a sequence of the following format:

  ${C}={\left({{f}_{{0}},}\ldots,{f}_{{n}}\right)}$

  - ${f_i}$ is a field ([Definition 162](sect-metadata.html#defn-rtm-field)).

- ${V}$ is a sequence of the following format:

  ${V}={\left({v}_{{0}},\ldots,{v}_{{n}}\right)}$

  - ${v}_{{i}}$ is a variant ([Definition 163](sect-metadata.html#defn-rtm-variant)).

- ${s}_{{v}}$ is a type Id ([Definition 160](sect-metadata.html#defn-rtm-type-id)).

- ${S}$ is of the following format:

  ${S}={\left({l},{y}\right)}$

  - ${l}$ is a unsigned 32-bit integer indicating the length

  - ${y}$ is a type Id ([Definition 160](sect-metadata.html#defn-rtm-type-id)).

- ${T}$ is a sequence ([Definition 192](id-cryptography-encoding.html#defn-scale-list)) of type Ids ([Definition 160](sect-metadata.html#defn-rtm-type-id)).

- ${P}$ is a varying datatype ([Definition 188](id-cryptography-encoding.html#defn-varrying-data-type)) of the following structure:

  $$
  {P}={\left\lbrace\begin{matrix}{0}&\text{boolean}\\{1}&\text{char}\\{2}&\text{string}\\{3}&\text{unsigned 8-bit integer}\\{4}&\text{unsigned 16-bit integer}\\{5}&\text{unsigned 32-bit integer}\\{6}&\text{unsigned 64-bit integer}\\{7}&\text{unsigned 128-bit integer}\\{8}&\text{unsigned 256-bit integer}\\{9}&\text{signed 8-bit integer}\\{10}&\text{signed 16-bit integer}\\{11}&\text{signed 32-bit integer}\\{12}&\text{signed 64-bit integer}\\{13}&\text{signed 128-bit integer}\\{14}&\text{signed 256-bit integer}\end{matrix}\right.}
  $$

- ${e}$ is a type Id ([Definition 160](sect-metadata.html#defn-rtm-type-id)).

- ${B}$ is a datastructure of the following format:

  ${B}={\left({s},{o}\right)}$

  - ${s}$ is a type Id ([Definition 160](sect-metadata.html#defn-rtm-type-id)) representing the bit store order ([external reference](https://docs.rs/bitvec/latest/bitvec/store/trait.BitStore.html))

  - ${o}$ is a type Id ([Definition 160](sect-metadata.html#defn-rtm-type-id)) the bit order type ([external reference](https://docs.rs/bitvec/latest/bitvec/order/trait.BitOrder.html)).

seq: - id: type type: u1 enum: type - id: details type: switch-on: type cases: "type::composite": metadata_type_fields "type::variant": metadata_type_variants "type::sequence": sequence "type::array": array "type::tuple": tuple "type::primitive": primitive "type::compact": compact "type::bits": bits enums: type: 0: composite 1: variant 2: sequence 3: array 4: tuple 5: primitive 6: compact 7: bits types: sequence: seq: - id: type type: scale::compact_int array: seq: - id: length type: u4 - id: type type: scale::compact_int tuple: seq: - id: num_types type: scale::compact_int - id: types type: scale::compact_int repeat: expr repeat-expr: num_types.value primitive: seq: - id: id type: u1 enum: pid enums: pid: 0: bool 1: char 2: str 3: uint8 4: uint16 5: uint32 6: uint64 7: uint128 8: uint256 9: int8 10: int16 11: int32 12: int64 13: int128 14: int256 compact: seq: - id: type type: scale::compact_int bits: seq: - id: type type: scale::compact_int - id: order type: scale::compact_int

Definition 162. [Field](sect-metadata.html#defn-rtm-field)

A field of a datastructure of the following format:

$$
{{f}_{{i}}=}{\left({n},{y},{y}_{{n}},{C}\right)}
$$

where

- ${n}$ is an *Option* type containing the string that indicates the field name.

- ${y}$ is a type Id ([Definition 160](sect-metadata.html#defn-rtm-type-id)).

- ${y}_{{n}}$ is an *Option* type containing a string that indicates the name of the type as it appears in the source code.

- ${C}$ is a sequence of varying length containing strings of documentation.

seq: - id: num_fields type: scale::compact_int - id: fields type: field repeat: expr repeat-expr: num_fields.value types: field: seq: - id: name type: scale::maybe_string - id: type type: scale::compact_int - id: typename type: scale::maybe_string - id: docs type: scale::string_list

Definition 163. [Variant](sect-metadata.html#defn-rtm-variant)

A struct variant of the following format:

$$
{v}_{{i}}={\left({n},{F},{k},{C}\right)}
$$

where

- ${n}$ is a string representing the name of the variant.

- ${F}$ is a possible empty array of varying length containing field ([Definition 162](sect-metadata.html#defn-rtm-field)) elements.

- ${k}$ is an unsigned 8-bit integer indicating the index of the variant.

- ${C}$ is a sequence of strings containing the documentation.

seq: - id: num_variants type: scale::compact_int - id: variants type: variant repeat: expr repeat-expr: num_variants.value types: variant: seq: - id: name type: scale::string - id: composite type: metadata_type_fields - id: index type: u1 - id: docs type: scale::string_list

## 12.2. Pallet Metadata {#sect-rtm-pallet-metadata}

All the metadata about a pallet, part of the main structure ([Section 12.1](sect-metadata.html#sect-rtm-structure)) and of the following format:

$$
{p}_{{i}}={\left({n},{S},{a},{e},{C},{e},{i}\right)}
$$

where

- ${n}$ is a string representing the pallet name.

- ${S}$ is an *Option* type containing the pallet storage metadata ([Definition 164](sect-metadata.html#defn-rtm-pallet-storage-metadata)).

- ${a}$ is an *Option* type ([Definition 190](id-cryptography-encoding.html#defn-option-type)) containing the type Id ([Definition 160](sect-metadata.html#defn-rtm-type-id)) of pallet calls.

- ${e}$ is an *Option* type ([Definition 190](id-cryptography-encoding.html#defn-option-type)) containing the type Id ([Definition 160](sect-metadata.html#defn-rtm-type-id)) of pallet events.

- ${C}$ is an *Sequence* ([Definition 192](id-cryptography-encoding.html#defn-scale-list)) of all pallet constant metadata ([Definition 169](sect-metadata.html#defn-rtm-pallet-constants)).

- ${e}$ is an *Option* type ([Definition 190](id-cryptography-encoding.html#defn-option-type)) containing the type Id ([Definition 160](sect-metadata.html#defn-rtm-type-id)) of the pallet error.

- ${i}$ is an unsigned 8-bit integers indicating the index of the pallet, which is used for encoding pallet events and calls.

seq: - id: name type: scale::string - id: has_storage type: u1 - id: storage type: pallet_storage if: has_storage != 0 - id: has_calls type: u1 - id: calls type: calls if: has_calls != 0 - id: has_events type: u1 - id: events type: events if: has_events != 0 - id: num_constants type: scale::compact_int - id: constants type: pallet_constant repeat: expr repeat-expr: num_constants.value - id: has_errors type: u1 - id: errors type: errors if: has_errors != 0 - id: index type: u1 types: calls: seq: - id: type type: scale::compact_int events: seq: - id: type type: scale::compact_int errors: seq: - id: type type: scale::compact_int

Definition 164. [Pallet Storage Metadata](sect-metadata.html#defn-rtm-pallet-storage-metadata)

The metadata about a pallets storage.

$$
{S}={\left({p},{E}\right)}
$$
$$
{E}={\left({e}_{{0}},\ldots,{e}_{{n}}\right)}
$$

where

- ${p}$ is the string representing the common prefix used by all storage entries.

- ${E}$ is an array of varying length containing elements of storage entries ([Definition 165](sect-metadata.html#defn-rtm-storage-entry-metadata)).

Definition 165. [Storage Entry Metadata](sect-metadata.html#defn-rtm-storage-entry-metadata)

The metadata about a pallets storage entry.

$$
{e}_{{i}}={\left({n},{m},{y},{d},{C}\right)}
$$
$$
{C}={\left({c}_{{0}},\ldots,{c}_{{n}}\right)}
$$

where

- ${n}$ is the string representing the variable name of the storage entry.

- ${m}$ is an enum type determining the storage entry modifier ([Definition 166](sect-metadata.html#defn-rtm-storage-entry-modifier)).

- ${y}$ is the type of the value stored in the entry ([Definition 167](sect-metadata.html#defn-rtm-storage-entry-type)).

- ${d}$ is an byte array containing the default value.

- ${C}$ is an array of varying length of strings containing the documentation.

seq: - id: prefix type: scale::string - id: num_items type: scale::compact_int - id: items type: item repeat: expr repeat-expr: num_items.value types: item: seq: - id: name type: scale::string - id: modifier type: u1 enum: storage_modifier - id: definition type: storage_definition - id: fallback type: scale::bytes - id: docs type: scale::string_list enums: storage_modifier: 0: optional 1: default

Definition 166. [Storage Entry Modifier](sect-metadata.html#defn-rtm-storage-entry-modifier)

|     |                                                 |
|-----|-------------------------------------------------|
|     | This might be incorrect and has to be reviewed. |

The storage entry modifier is a varying datatype ([Definition 188](id-cryptography-encoding.html#defn-varrying-data-type)) and indicates how the storage entry is returned and how it behaves if the entry is not present.

$$
{m}={\left\lbrace\begin{matrix}{0}&\text{optional}\\{1}&\text{default}\end{matrix}\right.}
$$

where *0* indicates that the entry returns an *Option* type and therefore *None* if the storage entry is not present. *1* indicates that the entry returns the type ${y}$ with default value ${d}$ (in [Definition 165](sect-metadata.html#defn-rtm-storage-entry-metadata)) if the entry is not present.

Definition 167. [Storage Entry Type](sect-metadata.html#defn-rtm-storage-entry-type)

The type of the storage value is a varying datatype ([Definition 188](id-cryptography-encoding.html#defn-varrying-data-type)) that indicates how the entry is stored.

$$
{y}={\left\lbrace\begin{matrix}{0}&->&{t}&\text{plain type}\\{1}&->&{\left({H},{k},{v}\right)}&\text{storage map}\end{matrix}\right.}
$$

where ${t}$, ${k}$ (key) and ${v}$ (value) are all of type Ids ([Definition 160](sect-metadata.html#defn-rtm-type-id)). ${H}$ is an array of varying length containing the storage hasher ([Definition 168](sect-metadata.html#defn-rtm-storage-hasher)).

seq: - id: type type: u1 enum: storage_type - id: details type: switch-on: type cases: 'storage_type::plain': plain 'storage_type::map': map enums: storage_type: 0: plain 1: map types: plain: seq: - id: type type: scale::compact_int map: seq: - id: num_hasher type: scale::compact_int - id: hasher type: u1 enum: hasher_type repeat: expr repeat-expr: num_hasher.value - id: key type: scale::compact_int - id: value type: scale::compact_int enums: hasher_type: 0: blake2_128 1: blake2_256 2: blake2_128_128 3: xxhash_128 4: xxhash_256 5: xxhahs_64_64 6: idhash

Definition 168. [Storage Hasher](sect-metadata.html#defn-rtm-storage-hasher)

The hashing algorithm used by storage maps.

$$
{\left\lbrace\begin{matrix}{0}&\text{128-bit Blake2 hash}\\{1}&\text{256-bit Blake2 hash}\\{2}&\text{Multiple 128-bit Blake2 hashes concatenated}\\{3}&\text{128-bit XX hash}\\{4}&\text{256-bit XX hash}\\{5}&\text{Multiple 64-bit XX hashes concatenated}\\{6}&\text{Identity hashing}\end{matrix}\right.}
$$

Definition 169. [Pallet Constants](sect-metadata.html#defn-rtm-pallet-constants)

The metadata about the pallets constants.

$$
{c}_{{i}}={\left({n},{y},{v},{C}\right)}
$$

where  
- ${n}$ is a string representing the name of the pallet constant.

- ${y}$ is the type Id ([Definition 160](sect-metadata.html#defn-rtm-type-id)) of the pallet constant.

- ${v}$ is a byte array containing the value of the constant.

- ${C}$ is an array of varying length containing string with the documentation.

seq: - id: name type: scale::string - id: type type: scale::compact_int - id: value type: scale::bytes - id: docs type: scale::string_list

## 12.3. Extrinsic Metadata {#sect-rtm-extrinsic-metadata}

The metadata about a pallets extrinsics, part of the main structure ([Section 12.1](sect-metadata.html#sect-rtm-structure)) and of the following format:

Definition 170. [Signed Extension Metadata](sect-metadata.html#defn-rtm-signed-extension-metadata)

The metadata about the additional, signed data required to execute an extrinsic.

$$
{e}_{{i}}={\left({n},{y},{a}\right)}
$$

where  
- ${n}$ is a string representing the unique signed extension identifier, which may be different from the type name.

- ${y}$ is a type Id ([Definition 160](sect-metadata.html#defn-rtm-type-id)) of the signed extension, with the data to be included in the extrinsic.

- ${a}$ is the type Id ([Definition 160](sect-metadata.html#defn-rtm-type-id)) of the additional signed data, with the data to be included in the signed payload.

seq: - id: name type: scale::string - id: type type: scale::compact_int - id: additional type: scale::compact_int
