## Matlab-Arbin-Battery-Data-Processing

# For Arbin_Cycle_Data_All.m
Generate plots of: all cycles, specific cycles, and Coulombic efficiency/capacity vs. cycle number. Code runs using MatLab 2019, for use in 2018 and previous, use xlsread instead of readmatrix and ensure the columns are appropriately identified.

User inputs of filepath, channel number (found in default filepath typically), and current density (for calculation of specific gravimetric capacity) are required for the code to run correctly. These inputs are promted through dialogue boxes. The user is also prompted to choose 3 cycles to plot on a separate figure.

Code works whether charge or discharge step comes first, as long as those steps are 2 and 4.

Scripts required: saveloc.m, figure_param.m, paper_settings_figure.m

# For Arbin_Variable_Rate_Cycling_Code_All.m
Generates plots of Coulombic efficiency/capacity vs. cycle number and plots the last cycle of every different rate step.
Code runs on MatLab 2019, also on previous versions through changing readmatrix to xlsread (this is in code comments).

User inputs of filepath, channel number (found in default filepath typically), active material mass (mg), and number of cycles per rate are required for the code to run correctly. These inputs are promted through a dialogue box.

Code works whether charge or discharge step comes first, as long as the sequence is the same as described in the comments.

Scripts required: saveloc.m, colourmapfigure.m, figure_param.m, paper_settings_figure.m

# For dQdV_All.m
Generates plot of dQdV for galvanostatic cycling data. Code runs on MatLab 2019, also on previous versions through changing readmatrix to xlsread.

User inputs of filepath, channel number, and current density are required and are prompted through dialogue boxes.
Ensure the axis settings are appropriate for your system.

Code works whether charge or discharge step comes first, as long as those steps are 2 and 4.

Scripts required: saveloc.m, figure_param.m, paper_settings_figure.m

# For CV_processing.m
Generates a plot of cyclic voltammograms from the .txt file. Code runs on MatLab 2019.

User inputs of filepath and scan rate are required and are prompted through dialogue boxes.

Scripts required: saveloc.m, figure_param.m, colourmapfigure.m

# For Variable_Rate_CV_Processing.m
Generates a plot of variable rate cyclic voltammograms from the .txt file. Code runs on MatLab 2019.

User inputs of filepath and number of cycles per rate are required and are prompted through dialogue boxes.

Scripts required: saveloc.m, figure_param.m

# Auxiliary Scripts
saveloc.m: specifies file path for saving figures generated by these codes.

figure_param.m: augments plots for more publishible quality - edit this code as required to change appearance of plots.

colourmapfigure.m: creates a colour vector for use in plotting - ensures the colours are consistent and appropriate for publication (no yellows etc.).

paper_settings_figure.m: sets the paper size to US letter size - ensures uniformity in plots. Change or omit to suit.
