# droplet-data-analysis

A matlab suite for analysis of droplet fluorescence data. The suite assumes that the fluorescence data comes from APDs operating in Geiger mode 

To run this suite, start by downloading all the files into a directory and then running the file 'process_droplet_data_ver2p1.m'

Use the buttons on the GUI that opens in sequence from top to bottom to enter information about experimental conditions and the samples to analyze

In addition to entering information using the buttons in the GUI, the final plot generation requires a plotting options script file. The repository contains a sample file titled 'droplet_plotting_options_script_ver2p1.m'. This file can be modified to change various parameters used for plot generation. 

The software assumes that all the data files are text files in the same folder and are named samplename-chx-y.txt where x is the number of the fluorescence channel and y is the data file number
