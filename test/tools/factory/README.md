# Toolkit

This toolkit is a work-in-progress utility in order to create a script polkadot transactions and test cases.

## Building

```console
$ cargo build --bin toolkit
```

## Usage

The toolkit can either be used directly via the command line or by using scriptable workflows defined in YAML files.

### CLI

```console
$ toolkit pallet-balances transfer --from alice --to bob --balance 100
```

Output:

```console
{
  "module": "pallet_balances",
  "function": "transfer",
  "data": "250284c81ebbec0559a6acf184535eb19da51ed3ed8c4ac65323999482aaf9b6696e2701a0465d3e48c35b8d02127fad5ae17d9076a61e74790637034049dabdd5476c0d015f433e86d50d08b925d7be9c78865620248041f8b464f13c7e685eb0366e84000000050080402e69a3fc09da233b5332f5a8c50a0175a3641a690d25d1107467717fff0e9101"
}
```

More docs to come.

### YAML

In the YAML file:

```yaml
- vars:
    balance: 100

- name: Extrinsic with variable
  pallet_balances:
    transfer:
      from: alice
      to: bob
      balance: "{{ balance }}"

- name: Extrinsics with loops
  pallet_balances:
    transfer:
      from: "{{ item.from }}"
      to: "{{ item.to }}"
      balance: "{{ item.balance }}"
  loop:
    - { from: alice, to: bob, balance: 100 }
    - { from: alice, to: dave, balance: 200 }
    - { from: bob, to: alice, balance: 300 }
    - { from: dave, to: bob, balance: 400 }
```

In order to execute it:

```console
$ toolkit path/to/file.yml
```

Output:

```console
{
  "task_name": "Extrinsic with variable",
  "module": "pallet_balances",
  "function": "transfer",
  "data": [
    "250284c81ebbec0559a6acf184535eb19da51ed3ed8c4ac65323999482aaf9b6696e27018044d857e5bf5410d83fba26f2eddb9f2672b532221caaf1cfcbcd1c6e5b694c565985b3cd1d4b4ccb2ebfb2cb3887d3110c086b2663aa0bdd5d6cba5d0ec08b000000050080402e69a3fc09da233b5332f5a8c50a0175a3641a690d25d1107467717fff0e9101"
  ]
}
{
  "task_name": "Extrinsics with loops",
  "module": "pallet_balances",
  "function": "transfer",
  "data": [
    "250284c81ebbec0559a6acf184535eb19da51ed3ed8c4ac65323999482aaf9b6696e2701a4d77ba72ba37e97b8a411921902857ae0b4a5c63b3fcb87170380e54c5ac0152a49ede0b3abbefa29246cd49b6b699b60c4be2b6b0b06935ad9f794f4b3de87000000050080402e69a3fc09da233b5332f5a8c50a0175a3641a690d25d1107467717fff0e9101",
    "250284c81ebbec0559a6acf184535eb19da51ed3ed8c4ac65323999482aaf9b6696e2701ca8fd66230311e06fd044f2a735e59830fdaa6e2a45d3909ec0d9ae8c15b7f0787d66441f93b9286902615ef591f6b0a8e5fd415bced26e64c7b002ff62ad08d00000005001c2dac79386d508db8cb56b9332c25bed7e6b72db6bd0274eddefb615e45e8722103",
    "25028480402e69a3fc09da233b5332f5a8c50a0175a3641a690d25d1107467717fff0e01bae04e95301f224ce3953ac1be7bba38218794c9f3788e79fd7358cfdca3357e574da79f055ed35737dddbf4ebda51c53d2fb58a7046a7d8ffa58ba1e400a7870000000500c81ebbec0559a6acf184535eb19da51ed3ed8c4ac65323999482aaf9b6696e27b104",
    "2502841c2dac79386d508db8cb56b9332c25bed7e6b72db6bd0274eddefb615e45e872018c269e609bc511e54387a39f636d78dc71aa927560cb95f740d3281fac4a4474fd677470c088eb3924e8d6ba0433dd2b69890fc6f19bb85c2af8c9d89a25c880000000050080402e69a3fc09da233b5332f5a8c50a0175a3641a690d25d1107467717fff0e4106"
  ]
}
```

See `examples/` directory. More docs to come.
