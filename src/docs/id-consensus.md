---
title: -chap-num- Consensus
---

import Pseudocode from '@site/src/components/Pseudocode';
import epochRandomness from '!!raw-loader!@site/src/algorithms/epochRandomness.tex';

## -sec-num- BABE digest messages {#id-babe-digest-messages}

The Runtime is required to provide the BABE authority list and randomness to the host via a consensus message in the header of the first block of each epoch.

The digest published in Epoch ${\mathcal{{{E}}}}_{{n}}$ is enacted in ${\mathcal{{{E}}}}_{{{n}+{1}}}$. The randomness in this digest is computed based on the all the VRF outputs up to including Epoch ${\mathcal{{{E}}}}_{{{n}-{2}}}$ while the authority set is based on all transaction included up to Epoch ${\mathcal{{{E}}}}_{{{n}-{1}}}$.

The computation of the randomeness seed is described in [Epoch-Randomness](id-consensus#algo-epoch-randomness) which uses the concept of epoch subchain as described in host specification and the value ${d}_{{B}}$, which is the VRF output computed for slot ${s}_{{B}}$.

###### Algorithm -algo-num- Epoch Randomness {#algo-epoch-randomness}
:::algorithm
<Pseudocode
    content={epochRandomness}
    algID="epochRandomness"
    options={{ "lineNumber": true }}
/>

where ${n}$ is the epoch index.
:::
