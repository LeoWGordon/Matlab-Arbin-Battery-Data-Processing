## Matlab-Arbin-Battery-Data-Processing

# For Arbin_Cycle_Data.m
Generate plots of: all cycles, specific cycles, and Coulombic efficiency/capacity vs. cycle number. Code runs through Matlab, definitively on the 2018 version. On the 2019 version the indexing is different using the xlsread function, therefore a minor change must be made to read the spreadsheets appropriately in the newer versions - comment out xlsread and use readmatrix instead (this is in code comments).

User inputs of filepath, channel number (found in default filepath typically), and current density (for calculation of specific gravimetric capacity) are required for the code to run correctly. These inputs are promted through dialogue boxes.

Note: Code implies that steps 2 and 4 are discharge and charge in the cycle sequence respectively. To change, alter the equalities of the step indices (si, si1, si2, and si3) from lines 61-110 to the appropriate step indices. If the sequence charges first and discharges second, the appropriate changes will need to be made.

# For Arbin_Variable_Rate_Cycling_Code.m
Generates plots of Coulombic efficiency/capacity vs. cycle number and plots the last cycle of every different rate step.
Code runs on 2019, and also on previous versions through changing readmatrix to xlsread (this is in code comments).

User inputs of filepath, channel number (found in default filepath typically), active material mass (mg), and number of cycles per rate are required for the code to run correctly. These inputs are promted through a dialogue box.
