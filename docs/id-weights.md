---
title: -chap-num- Weights
---

import Pseudocode from '@site/src/components/Pseudocode';
import requestJudgementRuntimeFunctionBenchmark from '!!raw-loader!@site/src/algorithms/requestJudgementRuntimeFunctionBenchmark.tex';
import payoutStakersRuntimeFunctionBenchmark from '!!raw-loader!@site/src/algorithms/payoutStakersRuntimeFunctionBenchmark.tex';
import transferRuntimeFunctionBenchmark from '!!raw-loader!@site/src/algorithms/transferRuntimeFunctionBenchmark.tex';
import withdrawUnbondedRuntimeFunctionBenchmark from '!!raw-loader!@site/src/algorithms/withdrawUnbondedRuntimeFunctionBenchmark.tex';

## -sec-num- Motivation {#id-motivation}

The Polkadot network, like any other permissionless system, needs to implement a mechanism to measure and limit the usage in order to establish an economic incentive structure, prevent network overload, and mitigate DoS vulnerabilities. In particular, Polkadot enforces a limited time window for block producers to create a block, including limitations on block size, which can make the selection and execution of certain extrinsics too expensive and decelerate the network.

In contrast to some other systems, such as Ethereum, which implement fine measurement for each executed low-level operation by smart contracts, known as gas metering, Polkadot takes a more relaxed approach by implementing a measuring system where the cost of the transactions (referred to as ’extrinsics’) are determined before execution and are known as the weight system.

The Polkadot weight system introduces a mechanism for block producers to measure the cost of running the extrinsics and determine how "heavy" it is in terms of execution time. Within this mechanism, block producers can select a set of extrinsics and saturate the block to its fullest potential without exceeding any limitations (as described in [Section -sec-num-ref-](id-weights#sect-limitations)). Moreover, the weight system can be used to calculate a fee for executing each extrinsics according to its weight (as described in [Section -sec-num-ref-](id-weights#sect-fee-calculation)).

Additionally, Polkadot introduces a specified block ratio (as defined in [Section -sec-num-ref-](id-weights#sect-limitations)), ensuring that only a certain portion of the total block size gets used for regular extrinsics. The remaining space is reserved for critical, operational extrinsics required for the functionality of Polkadot itself.

To begin, we introduce in [Section -sec-num-ref-](id-weights#sect-assumptions) the assumption upon which the Polkadot transaction weight system is designed. In [Section -sec-num-ref-](id-weights#sect-limitations), we discuss the limitation Polkadot needs to enforce on the block size. In [Section -sec-num-ref-](id-weights#sect-runtime-primitives), we describe in detail the procedure upon which the weight of any transaction should be calculated. In [Section -sec-num-ref-](id-weights#sect-practical-examples), we present how we apply this procedure to compute the weight of particular runtime functions.

## -sec-num- Assumptions {#sect-assumptions}

In this section, we define the concept of weight, and we discuss the considerations that need to be accounted for when assigning weight to transactions. These considerations are essential in order for the weight system to deliver its fundamental mission, i.e. the fair distribution of network resources and preventing a network overload. In this regard, weights serve as an indicator on whether a block is considered full and how much space is left for remaining, pending extrinsics. Extrinsics that require too many resources are discarded. More formally, the weight system should:

- prevent the block from being filled with too many extrinsics

- avoid extrinsics where its execution takes too long, by assigning a transaction fee to each extrinsic proportional to their resource consumption.

These concepts are formalized in [Definition -def-num-ref-](id-weights#defn-block-length) and [Definition -def-num-ref-](id-weights#defn-polkadot-block-limits):

###### Definition -def-num- Block Length {#defn-block-length}
:::definition

For a block ${B}$ with ${H}{e}{a}{d}{\left({B}\right)}$ and ${B}{o}{\left.{d}{y}\right.}{\left({B}\right)}$ the block length of ${B}$,${L}{e}{n}{\left({B}\right)}$, is defined as the amount of raw bytes of ${B}$.

:::
###### Definition -def-num- Target Time per Block {#defn-target-time-per-block}
:::definition

Ṯargeted time per block denoted by ${T}{\left({B}\right)}$ implies the amount of seconds that a new block should be produced by a validator. The transaction weights must consider ${T}{\left({B}\right)}$ in order to set restrictions on time-intensive transactions in order to saturate the block to its fullest potential until ${T}{\left({B}\right)}$ is reached.

:::
###### Definition -def-num- Block Target Time {#defn-block-target-time}
:::definition

Available block ration reserved for normal, noted by ${R}{\left({B}\right)}$, is defined as the maximum weight of none-operational transactions in the Body of ${B}$ divided by ${L}{e}{n}{\left({B}\right)}$.

:::
###### Definition -def-num- Block Limits {#defn-polkadot-block-limits}
:::definition

P̱olkadot block limits, as defined here, should be respected by each block producer for the produced block ${B}$ to be deemed valid:

- ${L}{e}{n}{\left({B}\right)}\le{5}\times{1}'{024}\times{1}'{024}={5}'{242}'{880}$ Bytes

- ${T}{\left({B}\right)}={6}$ seconds

- ${R}{\left({B}\right)}\le{0.75}$

:::
###### Definition -def-num- Weight Function {#defn-weight-function}
:::definition

The P̱olkadot transaction weight function denoted by ${\mathcal{{{W}}}}$ as follows:

$$
\begin{aligned}
\mathcal{W} &: \mathcal{E} \rightarrow \mathbb{N} \\
\mathcal{W} &: E \mapsto w
\end{aligned}
$$

where ${w}$ is a non-negative integer representing the weight of the extrinsic ${E}$. We define the weight of all inherent extrinsics as defined in the [Section -sec-num-ref-](chap-state#sect-inherents) to be equal to 0. We extend the definition of ${\mathcal{{{W}}}}$ function to compute the weight of the block as sum of weight of all extrinsics it includes:

$$
\begin{aligned}
\mathcal{W} &: \mathcal{B} \rightarrow \mathbb{N} \\
\mathcal{W} &: B \mapsto \sum_{E\in B}(W(E))
\end{aligned}
$$

In the remainder of this section, we discuss the requirements to which the weight function needs to comply to.

- Computations of function ${\mathcal{{{W}}}}{\left({E}\right)}$ must be determined before execution of that ${E}$.

- Due to the limited time window, computations of ${\mathcal{{{W}}}}$ must be done quickly and consume few resources themselves.

- ${\mathcal{{{W}}}}$ must be self contained and must not require I/O on the chain state. ${\mathcal{{{W}}}}{\left({E}\right)}$ must depend solely on the Runtime function representing ${E}$ and its parameters.

Heuristically, "heaviness" corresponds to the execution time of an extrinsic. In that way, the ${\mathcal{{{W}}}}$ value for various extrinsics should be proportional to their execution time. For example, if Extrinsic A takes three times longer to execute than Extrinsic B, then Extrinsic A should roughly weighs 3 times of Extrinsic B. Or:

$$
{\mathcal{{{W}}}}{\left({A}\right)}\approx{3}\times{\mathcal{{{W}}}}{\left({B}\right)}
$$

Nonetheless, ${\mathcal{{{W}}}}{\left({E}\right)}$ can be manipulated depending on the priority of ${E}$ the chain is supposed to endorse.

:::
### -sec-num- Limitations {#sect-limitations}

In this section, we discuss how applying the limitation defined in [Definition -def-num-ref-](id-weights#defn-polkadot-block-limits) can be translated to limitation ${\mathcal{{{W}}}}$. In order to be able to translate those into concrete numbers, we need to identify an arbitrary maximum weight to which we scale all other computations. For that, we first define the block weight and then assume a maximum on its block length in [Definition -def-num-ref-](id-weights#defn-block-weight):

###### Definition -def-num- Block Weight {#defn-block-weight}
:::definition

We define the block weight of block ${B}$, formally denoted as ${\mathcal{{{W}}}}{\left({B}\right)}$, to be:

$$
{\mathcal{{{W}}}}{\left({B}\right)}=\sum^{{{\left|{\mathcal{{{E}}}}\right|}}}_{\left\lbrace{n}={0}\right\rbrace}{\left({W}{\left({E}_{{n}}\right)}\right)}
$$

We require that:

$$
{\mathcal{{{W}}}}{\left({B}\right)}<{2}'{000}'{000}'{000}'{000}
$$
:::

The weights must fulfill the requirements as noted by the fundamentals and limitations and can be assigned as the author sees fit. As a simple example, consider a maximum block weight of 1’000’000’000, an available ratio of 75%, and a targeted transaction throughput of 500 transactions. We could assign the (average) weight for each transaction at about 1’500’000. Block producers have an economic incentive to include as many extrinsics as possible (without exceeding limitations) into a block before reaching the targeted block time. Weights give indicators to block producers on which extrinsics to include in order to reach the blocks fullest potential.

## -sec-num- Calculation of the weight function {#sect-runtime-primitives}

In order to calculate weight of block ${B}$, ${\mathcal{{{W}}}}{\left({B}\right)}$, one needs to evaluate the weight of each transaction included in the block. Each transaction causes the execution of certain Runtime functions. As such, to calculate the weight of a transaction, those functions must be analyzed in order to determine parts of the code which can significantly contribute to the execution time and consume resources such as loops, I/O operations, and data manipulation. Subsequently, the performance and execution time of each part will be evaluated based on variety of input parameters. Based on those observations, weights are assigned Runtime functions or parameters which contribute to long execution times. These sub component of the code are discussed in [Section -sec-num-ref-](id-weights#sect-primitive-types).

The general algorithm to calculate ${\mathcal{{{W}}}}{\left({E}\right)}$ is described in the [Section -sec-num-ref-](id-weights#sect-benchmarking).

## -sec-num- Benchmarking {#sect-benchmarking}

Calculating the extrinsic weight solely based on the theoretical complexity of the underlying implementation proves to be too complicated and unreliable at the same time. Certain decisions in the source code architecture, internal communication within the Runtime or other design choices could add enough overhead to make the asymptotic complexity practically meaningless.

On the other hand, benchmarking an extrinsics in a black-box fashion could (using random parameters) most certainly results in missing corner cases and worst case scenarios. Instead, we benchmark all available Runtime functions which are invoked in the course of execution of extrinsics with a large collection of carefully selected input parameters and use the result of the benchmarking process to evaluate ${\mathcal{{{W}}}}{\left({E}\right)}$.

In order to select useful parameters, the Runtime functions have to be analyzed to fully understand which behaviors or conditions can result in expensive execution times, which is described closer in [Section -sec-num-ref-](id-weights#sect-primitive-types). Not every possible benchmarking outcome can be invoked by varying input parameters of the Runtime function. In some circumstances, preliminary work is required before a specific benchmark can be reliably measured, such as creating certain preexisting entries in the storage or other changes to the environment.

The Practical Examples ([Section -sec-num-ref-](id-weights#sect-practical-examples)) covers the analysis process and the implementation of preliminary work in more detail.

### -sec-num- Primitive Types {#sect-primitive-types}

The Runtime reuses components, known as "primitives", to interact with the state storage. The execution cost of those primitives can be measured and a weight should be applied for each occurrence within the Runtime code.

For storage, Polkadot uses three different types of storage types across its modules, depending on the context:

- **Value**: Operations on a single value. The final key-value pair is stored under the key:

          hash(module_prefix) + hash(storage_prefix)

- **Map**: Operations on multiple values, datasets, where each entry has its corresponding, unique key. The final key-value pair is stored under the key:

          hash(module_prefix) + hash(storage_prefix) + hash(encode(key))

- **Double map**: Just like **Map**, but uses two keys instead of one. This type is also known as "child storage", where the first key is the "parent key" and the second key is the "child key". This is useful in order to scope storage entries (child keys) under a certain `context` (parent key), which is arbitrary. Therefore, one can have separated storage entries based on the context. The final key-value pair is stored under the key:

          hash(module_prefix) + hash(storage_prefix)
            + hash(encode(key1)) + hash(encode(key2))

It depends on the functionality of the Runtime module (or its sub-processes, rather) which storage type to use. In some cases, only a single value is required. In others, multiple values need to be fetched or inserted from/into the database.

Those lower-level types get abstracted over in each individual Runtime module using the `decl_storage!` macro. Therefore, each module specifies its own types that are used as input and output values. The abstractions do give indicators on what operations must be closely observed and where potential performance penalties and attack vectors are possible.

#### -sec-num- Considerations {#sect-primitive-types-considerations}

The storage layout is mostly the same for every primitive type, primarily differentiated by using special prefixes for the storage key. Big differences arise on how the primitive types are used in the Runtime function, on whether single values or entire datasets are being worked on. Single value operations are generally quite cheap and its execution time does not vary depending on the data that’s being processed. However, excessive overhead can appear when I/O operations are executed repeatedly, such as in loops. Especially, when the amount of loop iterations can be influenced by the caller of the function or by certain conditions in the state storage.

Maps, in contrast, have additional overhead when inserting or retrieving datasets, which vary in sizes. Additionally, the Runtime function has to process each item inside that list.

Indicators for performance penalties:

- **Fixed iterations and datasets** - Fixed iterations and datasets can increase the overall cost of the Runtime functions, but the execution time does not vary depending on the input parameters or storage entries. A base Weight is appropriate in this case.

- **Adjustable iterations and datasets** - If the amount of iterations or datasets depends on the input parameters of the caller or specific entries in storage, then a certain weight should be applied for each (additional) iteration or item. The Runtime defines the maximum value for such cases. If it doesn’t, it unconditionally has to and the Runtime module must be adjusted. When selecting parameters for benchmarking, the benchmarks should range from the minimum value to the maximum value, as described in [Definition -def-num-ref-](id-weights#defn-max-value).

- **Input parameters** - Input parameters that users pass on to the Runtime function can result in expensive operations. Depending on the data type, it can be appropriate to add additional weights based on certain properties, such as data size, assuming the data type allows varying sizes. The Runtime must define limits on those properties. If it doesn’t, it unconditionally has to, and the Runtime module must be adjusted. When selecting parameters for benchmarking, the benchmarks should range from the minimum values to the maximum value, as described in paragraph [Definition -def-num-ref-](id-weights#defn-max-value).

###### Definition -def-num- Maximum Value {#defn-max-value}
:::definition

What the maximum value should be really depends on the functionality that the Runtime function is trying to provide. If the choice for that value is not obvious, then it’s advised to run benchmarks on a big range of values and pick a conservative value below the `targeted time per block` limit as described in section [Section -sec-num-ref-](id-weights#sect-limitations).

:::
### -sec-num- Parameters {#id-parameters}

The input parameters highly vary depending on the Runtime function and must therefore be carefully selected. The benchmarks should use input parameters which will most likely be used in regular cases, as intended by the authors, but must also consider worst-case scenarios and inputs that might decelerate or heavily impact the performance of the function. The input parameters should be randomized in order to cause various effects in behaviors on certain values, such as memory relocations and other outcomes that can impact performance.

It’s not possible to benchmark every single value. However, one should select a range of inputs to benchmark, spanning from the minimum value to the maximum value, which will most likely exceed the expected usage of that function. This is described in more detail in [Section -sec-num-ref-](id-weights#sect-primitive-types-considerations). The benchmarks should run individual executions/iterations within that range, where the chosen parameters should give insight on the execution time. Selecting imprecise parameters or too extreme ranges might indicate an inaccurate result of the function as it will be used in production. Therefore, when a range of input parameters gets benchmarked, the result of each individual parameter should be recorded and optionally visualized, then the necessary adjustment can be made. Generally, the worst-case scenario should be assigned as the weight value for the corresponding runtime function.

Additionally, given the distinction between theoretical and practical usage, the author reserves the right to make adjustments to the input parameters and assign weights according to the observed behavior of the actual, real-world network.

#### -sec-num- Weight Refunds {#id-weight-refunds}

When assigning the final weight, the worst-case scenario of each runtime function should be used. The runtime can then additional "refund" the amount of weights which were overestimated once the runtime function is actually executed.

The Polkadot runtime only returns weights if the difference between the assigned weight and the actual weight calculated during execution is greater than 20%.

### -sec-num- Storage I/O cost {#id-storage-io-cost}

It is advised to benchmark the raw I/O operations of the database and assign "base weights" for each I/O operation type, such as insertion, deletion, querying, etc. When a runtime function is executed, the runtime can then add those base weights of each used operation in order to calculate the final weight.

### -sec-num- Environment {#id-environment}

The benchmarks should be executed on clean systems without interference of other processes or software. Additionally, the benchmarks should be executed on multiple machines with different system resources, such as CPU performance, CPU cores, RAM, and storage speed.

## -sec-num- Practical examples {#sect-practical-examples}

This section walks through Runtime functions available in the Polkadot Runtime to demonstrate the analysis process as described in [Section -sec-num-ref-](id-weights#sect-primitive-types).

In order for certain benchmarks to produce conditions where resource heavy computation or excessive I/O can be observed, the benchmarks might require some preliminary work on the environment, since those conditions cannot be created with simply selected parameters. The analysis process shows indicators on how the preliminary work should be implemented.

### -sec-num- Practical Example \#1: `request_judgement` {#id-practical-example-1-request_judgement}

In Polkadot, accounts can save information about themselves on-chain, known as the "Identity Info". This includes information such as display name, legal name, email address and so on. Polkadot offers a set of trusted registrars, entities elected by a Polkadot public referendum, which can verify the specified contact addresses of the identities, such as Email, and vouch on whether the identity actually owns those accounts. This can be achieved, for example, by sending a challenge to the specified address and requesting a signature as a response. The verification is done off-chain, while the final judgement is saved on-chain, directly in the corresponding Identity Info. It’s also noteworthy that Identity Info can contain additional fields, set manually by the corresponding account holder.

Information such as legal name must be verified by ID card or passport submission.

The function `request_judgement` from the `identity` pallet allows users to request judgment from a specific registrar.

```
(func $request_judgement (param $req_index int) (param $max_fee int))
```

- `req_index`: the index which is assigned to the registrar.

- `max_fee`: the maximum fee the requester is willing to pay. The judgment fee varies for each registrar.

Studying this function reveals multiple design choices that can impact performance, as it will be revealed by this analysis.

#### -sec-num- Analysis {#id-analysis}

First, it fetches a list of current registrars from storage and then searches that list for the specified registrar index.

```rust
let registrars = <Registrars<T>>::get();
let registrar = registrars.get(reg_index as usize).and_then(Option::as_ref)
  .ok_or(Error::<T>::EmptyIndex)?;
```

Then, it searches for the Identity Info from storage, based on the sender of the transaction.

```rust
let mut id = <IdentityOf<T>>::get(&sender).ok_or(Error::<T>::NoIdentity)?;
```

The Identity Info contains all fields that have a data in them, set by the corresponding owner of the identity, in an ordered form. It then proceeds to search for the specific field type that will be inserted or updated, such as email address. If the entry can be found, the corresponding value is to the value passed on as the function parameters (assuming the registrar is not "stickied", which implies it cannot be changed). If the entry cannot be found, the value is inserted into the index where a matching element can be inserted while maintaining sorted order. This results in memory reallocation, which increases resource consumption.

```rust
match id.judgements.binary_search_by_key(&reg_index, |x| x.0) {
  Ok(i) => if id.judgements[i].1.is_sticky() {
    Err(Error::<T>::StickyJudgement)?
  } else {
    id.judgements[i] = item
  },
  Err(i) => id.judgements.insert(i, item),
}
```

In the end, the function deposits the specified `max_fee` balance, which can later be redeemed by the registrar. Then, an event is created to insert the Identity Info into storage. The creation of events is lightweight, but its execution is what will actually commit the state changes.

```rust
T::Currency::reserve(&sender, registrar.fee)?;
<IdentityOf<T>>::insert(&sender, id);
Self::deposit_event(RawEvent::JudgementRequested(sender, reg_index));
```

#### -sec-num- Considerations {#sect-considerations}

The following points must be considered:

- Varying count of registrars.

- Varying count of preexisting accounts in storage.

- The specified registrar is searched for in the Identity Info. An identity can be judged by as many registrars as the identity owner issues requests, therefore increasing its footprint in the state storage. Additionally, if a new value gets inserted into the byte array, memory gets reallocated. Depending on the size of the Identity Info, the execution time can vary.

- The Identity-Info can contain only a few fields or many. It is legitimate to introduce additional weights for changes the owner/sender has influence over, such as the additional fields in the Identity-Info.

#### -sec-num- Benchmarking Framework {#id-benchmarking-framework}

The Polkadot Runtime specifies the `MaxRegistrars` constant, which will prevent the list of registrars of reaching an undesired length. This value should have some influence on the benchmarking process.

The benchmarking implementation of for the function ${request}$ ${judgement}$ can be defined as follows:

###### Algorithm -algo-num- `request_judgement` Runtime Function Benchmark {#algo-benchmark-request-judgement}
:::algorithm
<Pseudocode
    content={requestJudgementRuntimeFunctionBenchmark}
    algID="requestJudgementRuntimeFunctionBenchmark"
    options={{ "lineNumber": true }}
/>

**where**  
- Generate-Registrars(${amount}$)

  Creates a number of registrars and inserts those records into storage.

- Create-Account(${name}$, ${index}$)

  Creates a Blake2 hash of the concatenated input of name and index represent- ing the address of an account. This function only creates an address and does not conduct any I/O.

- Set-Balance(${amount}$, ${balance}$)

  Sets an initial balance for the specified account in the storage state.

- Timer(${function}$)

  Measures the time from the start of the specified function to its completion.

- Request-Judgement(${registrar}$ ${index}$, ${max}$ ${fee}$)

  Calls the corresponding request_judgement Runtime function and passes on the required parameters.

- Random(${num}$)

  Picks a random number between 0 and num. This should be used when the benchmark should account for unpredictable values.

- Add-To(${collection}$, ${time}$)

  Adds a returned time measurement (time) to collection.

- Compute-Weight(${collection}$)

  Computes the resulting weight based on the time measurements in the collection. The worst-case scenario should be chosen (the highest value).
:::

### -sec-num- Practical Example \#2: `payout_stakers` {#sect-practical-example-payout-stakers}

#### -sec-num- Analysis {#id-analysis-2}

The function `payout_stakers` from the `staking` Pallet can be called by a single account in order to payout the reward for all nominators who back a particular validator. The reward also covers the validator’s share. This function is interesting because it iterates over a range of nominators, which varies, and does I/O operations for each of them.

First, this function makes a few basic checks to verify if the specified era is not higher then the current era (as it is not in the future) and is within the allowed range also known as "history depth", as specified by the Runtime. After that, it fetches the era payout from storage and additionally verifies whether the specified account is indeed a validator and receives the corresponding "Ledger". The Ledger keeps information about the stash key, controller key, and other information such as actively bonded balance and a list of tracked rewards. The function only retains the entries of the history depth and conducts a binary search for the specified era.

```rust
let era_payout = <ErasValidatorReward<T>>::get(&era)
  .ok_or_else(|| Error::<T>::InvalidEraToReward)?;

let controller = Self::bonded(&validator_stash).ok_or(Error::<T>::NotStash)?;
let mut ledger = <Ledger<T>>::get(&controller).ok_or_else(|| Error::<T>::NotController)?;
```

```rust
ledger.claimed_rewards.retain(|&x| x >= current_era.saturating_sub(history_depth));
match ledger.claimed_rewards.binary_search(&era) {
  Ok(_) => Err(Error::<T>::AlreadyClaimed)?,
  Err(pos) => ledger.claimed_rewards.insert(pos, era),
}
```

The retained claimed rewards are inserted back into storage.

```rust
<Ledger<T>>::insert(&controller, &ledger);
```

As an optimization, Runtime only fetches a list of the 64 highest-staked nominators, although this might be changed in the future. Accordingly, any lower-staked nominator gets no reward.

```rust
let exposure = <ErasStakersClipped<T>>::get(&era, &ledger.stash);
```

Next, the function gets the era reward points from storage.

```rust
let era_reward_points = <ErasRewardPoints<T>>::get(&era);
```

After that, the payout is split among the validator and its nominators. The validators receive the payment first, creating an insertion into storage and sending a deposit event to the scheduler.

```rust
if let Some(imbalance) = Self::make_payout(
  &ledger.stash,
  validator_staking_payout + validator_commission_payout
) {
  Self::deposit_event(RawEvent::Reward(ledger.stash, imbalance.peek()));
}
```

Then, the nominators receive their payout rewards. The functions loop over the nominator list, conducting an insertion into storage and a creation of a deposit event for each of the nominators.

```rust
for nominator in exposure.others.iter() {
  let nominator_exposure_part = Perbill::from_rational_approximation(
    nominator.value,
    exposure.total,
  );

  let nominator_reward: BalanceOf<T> = nominator_exposure_part * validator_leftover_payout;
  // We can now make nominator payout:
  if let Some(imbalance) = Self::make_payout(&nominator.who, nominator_reward) {
    Self::deposit_event(RawEvent::Reward(nominator.who.clone(), imbalance.peek()));
  }
}
```

#### -sec-num- Considerations {#considerations-1}

The following points must be considered:

- The Ledger contains a varying list of claimed rewards. Fetching, retaining, and searching through it can affect execution time. The retained list is inserted back into storage.

- Looping through a list of nominators and creating I/O operations for each increases execution time. The Runtime fetches up to 64 nominators.

#### -sec-num- Benchmarking Framework {#id-benchmarking-framework-2}

###### Definition -def-num- History Depth {#defn-history-depth}
:::definition

H̱istory Depth indicated as `MaxNominatorRewardedPerValidator` is a fixed constant specified by the Polkadot Runtime which dictates the number of Eras the Runtime will reward nominators and validators for.

:::
###### Definition -def-num- Maximum Nominator Reward {#defn-max-nominator-reward}
:::definition

M̱aximum Nominator Rewarded Per Validator indicated as `MaxNominatorRewardedPerValidator`, specifies the maximum amount of the highest-staked nominators which will get a reward. Those values should have some influence in the benchmarking process.
:::

The benchmarking implementation for the function ${payout}$ ${stakers}$ can be defined as follows:

###### Algorithm -algo-num- `payout_stakers` Runtime Function Benchmark {#algo-benchmark-payout-stakers}
:::algorithm
<Pseudocode
    content={payoutStakersRuntimeFunctionBenchmark}
    algID="{payoutStakersRuntimeFunctionBenchmark"
    options={{ "lineNumber": true }}
/>

**where**  
- Generate-Validator()

  Creates a validator with some unbonded balances.

- Validate(${validator}$)

  Bonds balances of validator and bonds balances.

- Generate-Nominators(${amount}$)

  Creates the amount of nominators with some unbonded balances.

- Nominate(${validator}$, ${nominator}$)

  Starts nomination of nominator for validator by bonding balances.

- Create-Rewards(${validator}$, ${nominators}$, ${era}$ ${depth}$)

  Starts an Era and creates pending rewards for validator and nominators.

- Timer(${function}$)

  Measures the time from the start of the specified function to its completion.

- Add-To(${collection}$, ${time}$)

  Adds a returned time measurement (time) to collection.

- Compute-Weight(${collection}$)

  Computes the resulting weight based on the time measurements in the collection. The worst-case scenario should be chosen (the highest value).
:::

### -sec-num- Practical Example \#3: `transfer` {#id-practical-example-3-transfer}

The ${transfer}$ function of the `balances` module is designed to move the specified balance by the sender to the receiver.

#### -sec-num- Analysis {#id-analysis-3}

The source code of this function is quite short:

```rust
let transactor = ensure_signed(origin)?;
let dest = T::Lookup::lookup(dest)?;
<Self as Currency<_>>::transfer(
  &transactor,
  &dest,
  value,
  ExistenceRequirement::AllowDeath
)?;
```

However, one needs to pay close attention to the property `AllowDeath` and to how the function treats existings and non-existing accounts differently. Two types of behaviors are to consider:

- If the transfer completely depletes the sender account balance to zero (or below the minimum "keep-alive" requirement), it removes the address and all associated data from storage.

- If the recipient account has no balance, the transfer also needs to create the recipient account.

#### -sec-num- Considerations {#considerations-2}

Specific parameters can could have a significant impact for this specific function. In order to trigger the two behaviors mentioned above, the following parameters are selected:

| **Type**      |               | **From** | **To** | **Description**                     |
|---------------|---------------|----------|--------|-------------------------------------|
| Account index | `index` in…​   | 1        | 1000   | Used as a seed for account creation |
| Balance       | `balance` in…​ | 2        | 1000   | Sender balance and transfer amount  |

Executing a benchmark for each balance increment within the balance range for each index increment within the index range will generate too many variants (${1000}\times{999}$) and highly increase execution time. Therefore, this benchmark is configured to first set the balance at value 1’000 and then to iterate from 1 to 1’000 for the index value. Once the index value reaches 1’000, the balance value will reset to 2 and iterate to 1’000 (see ["transfer" Runtime function benchmark](id-weights#algo-benchmark-transfer) for more detail):

- `index`: 1, `balance`: 1000

- `index`: 2, `balance`: 1000

- `index`: 3, `balance`: 1000

- …​

- `index`: 1000, `balance`: 1000

- `index`: 1000, `balance`: 2

- `index`: 1000, `balance`: 3

- `index`: 1000, `balance`: 4

- …​

The parameters themselves do not influence or trigger the two worst conditions and must be handled by the implemented benchmarking tool. The ${transfer}$ benchmark is implemented as defined in ["transfer" Runtime function benchmark](id-weights#algo-benchmark-transfer).

#### -sec-num- Benchmarking Framework {#id-benchmarking-framework-3}

The benchmarking implementation for the Polkadot Runtime function ${transfer}$ is defined as follows (starting with the Main function):

###### Algorithm -algo-num- `transfer` Runtime Function Benchmark {#algo-benchmark-transfer}
:::algorithm
<Pseudocode
    content={transferRuntimeFunctionBenchmark}
    algID="{trasnferRuntimeFunctionBenchmark"
    options={{ "lineNumber": true }}
/>

**where**  
- Create-Account(${name}$, ${index}$)

  Creates a Blake2 hash of the concatenated input of name and index representing the address of a account. This function only creates an address and does not conduct any I/O.

- Set-Balance(${account}$, ${balance}$)

  Sets a initial balance for the specified account in the storage state.

- Transfer(${sender}$, ${recipient}$, ${balance}$)

  Transfers the specified balance from sender to recipient by calling the corresponding Runtime function. This represents the target Runtime function to be benchmarked.

- Add-To(${collection}$, ${time}$)

  Adds a returned time measurement (time) to collection.

- Timer(${function}$)

  Adds a returned time measurement (time) to collection.

- Compute-Weight(${collection}$)

  Computes the resulting weight based on the time measurements in the collection. The worst case scenario should be chosen (the highest value).
:::

### -sec-num- Practical Example \#4: `withdraw_unbonded` {#id-practical-example-4-withdraw_unbonded}

The `withdraw_unbonded` function of the `staking` module is designed to move any unlocked funds from the staking management system to be ready for transfer. It contains some operations which have some I/O overhead.

#### -sec-num- Analysis {#id-analysis-4}

Similarly to the `payout_stakers` function ([Section -sec-num-ref-](id-weights#sect-practical-example-payout-stakers)), this function fetches the Ledger which contains information about the stash, such as bonded balance and unlocking balance (balance that will eventually be freed and can be withdrawn).

```rust
if let Some(current_era) = Self::current_era() {
  ledger = ledger.consolidate_unlocked(current_era)
}
```

The function `consolidate_unlocked` does some cleaning up on the ledger, where it removes outdated entries from the unlocking balance (which implies that balance is now free and is no longer awaiting unlock).

```rust
let mut total = self.total;
let unlocking = self.unlocking.into_iter()
  .filter(|chunk| if chunk.era > current_era {
    true
  } else {
    total = total.saturating_sub(chunk.value);
    false
  })
  .collect();
```

This function does a check on wether the updated ledger has any balance left in regards to staking, both in terms of locked, staking balance and unlocking balance. If not amount is left, the all information related to the stash will be deleted. This results in multiple I/O calls.

```rust
if ledger.unlocking.is_empty() && ledger.active.is_zero() {
  // This account must have called `unbond()` with some value that caused the active
  // portion to fall below existential deposit + will have no more unlocking chunks
  // left. We can now safely remove all staking-related information.
  Self::kill_stash(&stash, num_slashing_spans)?;
  // remove the lock.
  T::Currency::remove_lock(STAKING_ID, &stash);
  // This is worst case scenario, so we use the full weight and return None
  None
}
```

The resulting call to `Self::kill_stash()` triggers:

```rust
slashing::clear_stash_metadata::<T>(stash, num_slashing_spans)?;
<Bonded<T>>::remove(stash);
<Ledger<T>>::remove(&controller);
<Payee<T>>::remove(stash);
<Validators<T>>::remove(stash);
<Nominators<T>>::remove(stash);
```

Alternatively, if there’s some balance left, the adjusted ledger simply gets updated back into storage.

```rust
// This was the consequence of a partial unbond. just update the ledger and move on.
Self::update_ledger(&controller, &ledger);
```

Finally, it withdraws the unlocked balance, making it ready for transfer:

```rust
let value = old_total - ledger.total;
Self::deposit_event(RawEvent::Withdrawn(stash, value));
```

#### -sec-num- Parameters {#id-parameters-2}

The following parameters are selected:

| **Type**      |             | **From** | **To** | **Description**                     |
|---------------|-------------|----------|--------|-------------------------------------|
| Account index | `index` in…​ | 0        | 1000   | Used as a seed for account creation |

This benchmark does not require complex parameters. The values are used solely for account generation.

#### -sec-num- Considerations {#considerations-3}

Two important points in the `withdraw_unbonded` function must be considered. The benchmarks should trigger both conditions

- The updated ledger is inserted back into storage.

- If the stash gets killed, then multiple, repetitive deletion calls are performed in the storage.

#### -sec-num- Benchmarking Framework {#id-benchmarking-framework-4}

The benchmarking implementation for the Polkadot Runtime function `withdraw_unbonded` is defined as follows:

###### Algorithm -algo-num- `withdraw_unbonded` Runtime Function Benchmark {#algo-benchmark-withdraw}
:::algorithm
<Pseudocode
    content={withdrawUnbondedRuntimeFunctionBenchmark}
    algID="{withdrawUnbondedRuntimeFunctionBenchmark"
    options={{ "lineNumber": true }}
/>

**where**  
- Create-Account(${name}$, $index$)

  Creates a Blake2 hash of the concatenated input of name and index representing the address of a account. This function only creates an address and does not conduct any I/O.

- Set-Balance(${amount}$, ${balance}$)

  Sets a initial balance for the specified account in the storage state.

- Bond(${stash}$, ${controller}$, ${amount}$)

  Bonds the specified amount for the stash and controller pair.

- UnBond(${account}$, ${amount}$)

  Unbonds the specified amount for the given account.

- Pass-Era()

  Pass one era. Forces the function `withdraw_unbonded` to update the ledger and eventually delete information.

- Withdraw-Unbonded(${controller}$)

  Withdraws the the full unbonded amount of the specified controller account. This represents the target Runtime function to be benchmarked.

- Add-To(${collection}$, ${time}$)

  Adds a returned time measurement (time) to collection.

- Timer(${function}$)

  Measures the time from the start of the specified f unction to its completion.

- Compute-Weight(${collection}$)

  Computes the resulting weight based on the time measurements in the collection. The worst case scenario should be chosen (the highest value).
:::

## -sec-num- Fees {#id-fees}

Block producers charge a fee in order to be economically sustainable. That fee must always be covered by the sender of the transaction. Polkadot has a flexible mechanism to determine the minimum cost to include transactions in a block.

### -sec-num- Fee Calculation {#sect-fee-calculation}

Polkadot fees consists of three parts:

- Base fee: a fixed fee that is applied to every transaction and set by the Runtime.

- Length fee: a fee that gets multiplied by the length of the transaction, in bytes.

- Weight fee: a fee for each, varying Runtime function. Runtime implementers need to implement a conversion mechanism which determines the corresponding currency amount for the calculated weight.

The final fee can be summarized as:

$$
\begin{aligned}
fee &= base\ fee \\
&{} + \text{length of transaction in bytes} \times \text{length fee} \\
&{} + \text{weight to fee}
\end{aligned}
$$

### -sec-num- Definitions in Polkadot {#id-definitions-in-polkadot}

The Polkadot Runtime defines the following values:

- Base fee: 1 mDOTs $(10^{-3}DOT)$. Base Fee is defined as the fee for a No-op extrinsic (for e.g., an empty System::Remark call, currently with a weight of 126 micro Seconds).   

- Length fee: 0.1 uDOTs

- Weight to fee conversion:

  ${weight}$ fee = weight \times (100${u}{D}{O}{T}{s}\div{\left({10}\times{10}'{000}\right)}{)}$

  A weight of 126’000 nS is mapped to 1 mDOT. This fee will never exceed the max size of an unsigned 128 bit integer.

### -sec-num- Fee Multiplier {#id-fee-multiplier}

Polkadot can add a additional fee to transactions if the network becomes too busy and starts to decelerate the system. This fee can create an incentive to avoid the production of low priority or insignificant transactions. In contrast, those additional fees will decrease if the network calms down and it can execute transactions without much difficulties.

That additional fee is known as the `Fee Multiplier` and its value is defined by the Polkadot Runtime. The multiplier works by comparing the saturation of blocks; if the previous block is less saturated than the current block (implying an uptrend), the fee is slightly increased. Similarly, if the previous block is more saturated than the current block (implying a downtrend), the fee is slightly decreased.

The final fee is calculated as:

$$
final fee = fee \times Fee Multiplier
$$

#### -sec-num- Update Multiplier {#id-update-multiplier}

The `Update Multiplier` defines how the multiplier can change. The Polkadot Runtime internally updates the multiplier after each block according the following formula:

$$
\begin{aligned}
diff &=& (target\ weight - previous\ block\ weight) \\
v &=& 0.00004 \\
next\ weight &=& weight \times (1 + (v \times diff) + (v \times diff)^2 / 2)
\end{aligned}
$$

Polkadot defines the `target_weight` as 0.25 (25%). More information about this algorithm is described in the [Web3 Foundation research paper](https://research.web3.foundation/Polkadot/overview/token-economics#relay-chain-transaction-fees-and-per-block-transaction-limits).
