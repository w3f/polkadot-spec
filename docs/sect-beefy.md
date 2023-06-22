---
title: -chap-num- BEEFY
---

## Structure of BEEFY Specifications

- Overview
    1. Motivation (aka why not just use GRANDPA)
    2. Protocol overview 

    (Can reuse texts from HackMD [here](https://hackmd.io/UsPqx0IATX6yFSxcBLIhHQ?view) )
- Consensus layer for Node 
    1. Core Consensus for following Grandpa:
        - Initial sync/ bootstrap
        - Next Beefy Round selection
        - Playing a Beefy Round (simpler following a chain without forks)
        - Beefy Justifications
    2. MMR
    3. Runtime Pallets and interactions
- Relayer:
    1. Fetching Beefy finalised blocks
    2. Initial commit of payload and bitfield (>⅔rd signed Beefy justification) and sending to target bridge
    3. Second round of sending signatures
- Verification by Light Client
    1. Receiving the initial commit with bitfield
    2. Using RANDAO to subsample the signatures to verify
    3. Checking the signatures 
    4. querying state
- Slashing Mechanism
    1. Slashing Conditions
    2. Severity of slashing

Security arguments flow from top to bottom: 
- Specify and prove soundness and completeness of BEEFY assuming guarantees from GRANDPA.
- Define the behavior of relayer and assumptions on the latency/concurrency etc. 
- Assume guarantees on BEEFY, prove the soundness, completeness, and succinctness of the random sampling light client. 
- Derive the relevant Parameters like sub-sampling size, slashing penalty, etc. fixing a security budget. 
