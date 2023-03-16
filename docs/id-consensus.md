---
title: Consensus
---

## 11.1. BABE digest messages {#id-babe-digest-messages}

The Runtime is required to provide the BABE authority list and randomness to the host via a consensus message in the header of the first block of each epoch.

The digest published in Epoch ${\mathcal{{{E}}}}_{{n}}$ is enacted in ${\mathcal{{{E}}}}_{{{n}+{1}}}$. The randomness in this digest is computed based on the all the VRF outputs up to including Epoch ${\mathcal{{{E}}}}_{{{n}-{2}}}$ while the authority set is based on all transaction included up to Epoch ${\mathcal{{{E}}}}_{{{n}-{1}}}$.

The computation of the randomeness seed is described in [Epoch-Randomness](id-consensus.html#algo-epoch-randomness) which uses the concept of epoch subchain as described in host specification and the value ${d}_{{B}}$, which is the VRF output computed for slot ${s}_{{B}}$.

\Require ${n}>{2}$ \State \textbf{init} $\rho\leftarrow\phi$ \For{${B}$ in \call{SubChain}{${\mathcal{{{E}}}}_{{{n}-{2}}}$}} \State $\rho\leftarrow\rho{\mid}{\mid}{d}_{{B}}$ \EndFor \Return \call{Blake2b}{\call{Epoch-Randomness}{${n}-{1}$}${\left|{\left|{n}\right|}\right|}\rho$}

where ${n}$ is the epoch index.
