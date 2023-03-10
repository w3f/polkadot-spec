---
title: Consensus
---

## [](#id-babe-digest-messages)[11.1. BABE digest messages](#id-babe-digest-messages)

The Runtime is required to provide the BABE authority list and randomness to the host via a consensus message in the header of the first block of each epoch.

The digest published in Epoch $\mathcal{E}\_n$ is enacted in $\mathcal{E}\_{n+1}$. The randomness in this digest is computed based on the all the VRF outputs up to including Epoch $\mathcal{E}\_{n-2}$ while the authority set is based on all transaction included up to Epoch $\mathcal{E}\_{n-1}$.

The computation of the randomeness seed is described in [Epoch-Randomness](id-consensus.html#algo-epoch-randomness) which uses the concept of epoch subchain as described in host specification and the value $d_B$, which is the VRF output computed for slot $s_B$.

\Require \$n \> 2\$ \State \textbf{init} \$\rho \leftarrow \phi\$ \For{\$B\$ in \call{SubChain}{\$\mathcal{E}\_{n-2}\$}} \State \$\rho \leftarrow \rho \|\| d_B\$ \EndFor \Return \call{Blake2b}{\call{Epoch-Randomness}{\$n-1\$}\$\|\|n\|\|\rho\$}

where $n$ is the epoch index.
