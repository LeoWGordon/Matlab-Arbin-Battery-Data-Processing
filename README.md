# Matlab-Arbin-Battery-Data-Processing
Generate plots of: all cycles, specific cycles, and Coulombic efficiency/capacity per cycle. Code runs through Matlab, definitively on the 2018 version. On the 2019 version, the indexing is different from the xlsread function.

User inputs of filepath, channel number (found in default filepath typically), and current density (for calculation of specific gravimetric capacity) are required for the code to run correctly. These inputs are promted through dialogue boxes.

Note: Code implies that steps 2 and 4 are discharge and charge in the cycle sequence respectively. To change, alter the equalities of the step indices (si, si1, si2, and si3) from lines 61-110 to the appropriate step indices.
