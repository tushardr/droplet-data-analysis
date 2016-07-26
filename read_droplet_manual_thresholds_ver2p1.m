function manual_thresholds=...
		read_manual_thresholds_ver2p1(data_dir,expt_date,expt_num,expt_conditions_sample_desc,data_processing_options)
% Store no_of_channels in a convenient short variable name
no_of_channels=expt_conditions_sample_desc.no_of_channels;

% Move to the directory containing experimental data
% Kinda redundant but useful for running the function independent of 'process_smd_data_new.m'
eval(['cd(''' data_dir '/' expt_date '/expt' num2str(expt_num) ''')']);
%*****************************************************************************************************************
% Read the excel file containing the manual thresholding data
% xlsread reads numerical data in the form of a matrix in threshold_num_read
% it reads all the strings in the form of a cell matrix with empty strings replacing numerical data (threshold_string_data)
%[threshold_num_data,threshold_string_data]= ...
%			xlsread(strcat('manual_thresholds_expt',num2str(expt_num),'_',expt_date,'.xls'),1,'basic');

[threshold_num_data,threshold_string_data]= ...
			xlsread(strcat('manual_thresholds_expt',num2str(expt_num),'_',expt_date,'.xls'),1,'a1:z100','basic');


%*****************************************************************************************************************


%*****************************************************************************************************************
% Determine if it is necessary to read manual thresholds for all the channels
if ~isempty(regexp(data_processing_options.Peak_counting_threshold,'Manual','ignorecase'))
	Read_channel_baselines=1; % a flag to know if manual thresholds for each channel are to be read
else
	Read_channel_baselines=1;
end
%*****************************************************************************************************************

%*****************************************************************************************************************
% Determine if it is necessary to read manual thresholds for droplet reference channel
if ~isempty(regexp(data_processing_options.Droplet_counting_threshold,'Manual','ignorecase'))
	Read_droplet_baseline=1; % a flag to know if manual thresholds for each channel are to be read
else
	Read_droplet_baseline=1;
end
%*****************************************************************************************************************

%*****************************************************************************************************************
for data_line=2:size(threshold_string_data,1)

	if Read_channel_baselines
		% generate a structure manual_thresholds with fields containing sample names and index as the time_trace number
		% the field baselines contains the manual_thresholds for all channels for that particular time trace
		% the field duplicate_removal_baselines (if applicable) contains the manual thresholds for duplicate removal
		% for that particular time trace
		% format manual_thresholds.sample_name(time_trace).baselines or .duplicate_removal_baselines 	
		eval(['manual_thresholds.' char(threshold_string_data(data_line)) '(' num2str(threshold_num_data(data_line-1,1)) ...
						').baselines=[' num2str(threshold_num_data(data_line-1,2:no_of_channels+1)) '];']);
	end
	
	if ~Read_channel_baselines & Read_droplet_baseline
		eval(['manual_thresholds.' char(threshold_string_data(data_line)) '(' num2str(threshold_num_data(data_line-1,1)) ...
						').droplet_baseline=[' num2str(threshold_num_data(data_line-1,2)) '];'])
	elseif	Read_droplet_baseline
		eval(['manual_thresholds.' char(threshold_string_data(data_line)) '(' num2str(threshold_num_data(data_line-1,1)) ...
						').droplet_baseline=[' num2str(threshold_num_data(data_line-1,no_of_channels+2)) '];'])
	end

end
%*****************************************************************************************************************
