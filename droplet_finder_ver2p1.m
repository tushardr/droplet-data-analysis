function [droplet_location_data,corrected_channel_data]= ...
			droplet_finder_ver2p1(all_channel_data,data_processing_options,expt_conditions_sample_desc,bin_time_in_msec,varargin)

        
        
%****************************************************************************************************        
% define some convenient variables or rearrange the data        
droplet_location_data.timeline=all_channel_data(:,1);
total_no_of_time_pts=length(droplet_location_data.timeline);
% column number now corresponds to the channel number in all_channel_data
all_channel_data=all_channel_data(:,2:end);
no_of_channels=size(all_channel_data,2);
% store the droplet reference channels in a convenient variable
reference_channel=data_processing_options.Droplet_reference_channel;

data_corrected=0; % a flag to keep track of any modifications made to raw data
%****************************************************************************************************        



%****************************************************************************************************
% APD correction
if isfield(data_processing_options,'APD_correction')
	if ~isempty(regexp(data_processing_options.APD_correction,'Yes','ignorecase'))
        % correct the data for all channels using the APD_correction_function
        for channel=1:no_of_channels            
            % current channel is not the same as actual data channel. So find out what the real data channel is.
            actual_data_channel=data_processing_options.data_channels(channel);
            %eval(['actual_data_channel=expt_conditions_sample_desc.channel_order_ch' num2str(channel) ';']);
            % Save the APD_serial_number and emission band center in convenient variables
            eval(['APD_serial_num=expt_conditions_sample_desc.Ch' num2str(actual_data_channel) '_APD;']);
            eval(['emission_band_center=expt_conditions_sample_desc.bandpass' num2str(actual_data_channel) '_center;']);
            corrected_channel_data(:,channel)=APD_correction_function_ver2p1(APD_serial_num,bin_time_in_msec,all_channel_data(:,channel),emission_band_center);
        end    
        % write code to do the correction and produce corrected_channel_data
        data_corrected=1;
	end
end

%****************************************************************************************************



%****************************************************************************************************
% Data smoothing
if isfield(data_processing_options,'Data_smoothing')
	if ~isempty(regexp(data_processing_options.Data_smoothing,'Lee','ignorecase'))
		data_corrected=1;
		% write code to smooth APD_corrected data here
			
	elseif ~isempty(regexp(data_processing_options.Data_smoothing,'Moving_avg','ignorecase'))
		% write code to smooth APD_corrected data using 'Moving_avg' filter here
		data_corrected=1;
	end
end
%****************************************************************************************************



%****************************************************************************************************
% Save a copy of the all_channel_data in corrected_channel_data, if no modifications were done to the
% data
if ~data_corrected
	corrected_channel_data=all_channel_data;
end	
clear all_channel_data
%****************************************************************************************************



%****************************************************************************************************
% calculate or set the baselines for droplet counting here 
if ~isempty(regexp(data_processing_options.Droplet_counting_threshold,'Manual','ignorecase'))
	if nargin>3
		threshold_struct=varargin{1}; % additional argument is included in function call only for manual thresholding
	else
		sprintf('Manual threshold selected for peak counting but threshold data not included in function call')
		return;
	end
	droplet_baseline=threshold_struct.droplet_baseline;

elseif ~isempty(regexp(data_processing_options.Droplet_counting_threshold,'Auto','ignorecase'))
	% calculate the baselines for separating background from signal here
	corrected_channel_signal_means=mean(corrected_channel_data(:,reference_channel),1);
	corrected_channel_signal_stdev=std(corrected_channel_data(:,reference_channel),0,1);
	droplet_baseline=(corrected_channel_signal_means+data_processing_options.Droplet_counting_baseline*corrected_channel_signal_stdev);	
end

% store the baselines used for calculating the peaks in the peak_location_data structure
droplet_location_data.droplet_baseline=droplet_baseline;
%****************************************************************************************************



%****************************************************************************************************
% calculate the number of peaks in each channel, based on the baselines here
% peak counting logic  
% potential_peaks:0011001111000110011
% potential_peaks_shifted_by_1_step:0001100111100011001 (added a zero at start for the missing number)
% potential_peaks-potential_peaks_shifted_by_1_step = 0010-101000-10010-1010
% finding number of 1's in this result gives you the number of peaks
%   1001100111100011001101
% - 01001100111100011001101
%   1|010|01000|0010|010|1

potential_gaps=corrected_channel_data(:,reference_channel)<repmat(droplet_baseline,total_no_of_time_pts,1);
% gaps between droplets
potential_gaps_shifted_by_1_step=circshift(potential_gaps,1);
potential_gaps_shifted_by_1_step(1,:)=0; % set the additional bit at start to be zero as shown in e.g.
potential_gaps_difference=potential_gaps-potential_gaps_shifted_by_1_step;

% we will store the gap locations first, to filter out the small gaps which are too small to be true
% and after filtering out those, we can replace the gap locations with droplet locations
droplet_location_data.gap_start_loc=find(potential_gaps_difference==1);
droplet_location_data.gap_end_loc=find(potential_gaps_difference==(-1))-1;
if length(droplet_location_data.gap_end_loc)<length(droplet_location_data.gap_start_loc)
	% the droplet end location of last droplet is absent if the last data point is '1'
	droplet_location_data.gap_end_loc(end+1,1)=total_no_of_time_pts;
end	 
%****************************************************************************************************



%****************************************************************************************************
% filter out the gaps which are too small to be true (i.e. fluctuations within the droplet)
% Make sure the Minimum gap parameter is in the units of the data time step
if isfield(data_processing_options,'Min_gap_betn_droplets')
    % Do this only if there are gaps found in the data trace
    if ~isempty(droplet_location_data.gap_start_loc)
        % calculate the gap width for each gap
        gap_width=droplet_location_data.gap_end_loc-droplet_location_data.gap_start_loc+1;
        % only gaps greater than a certain size are thought to be real gaps
        % Min_gap_betn_droplets is in msec. So divide by bin time in msec
        % to get the Min_gap_betn_droplets in number of bins, which is the
        % unit of gap width
        real_gaps=find(gap_width>(data_processing_options.Min_gap_betn_droplets/bin_time_in_msec));
        % remove all the gaps that are smaller than the minimum gap size allowed

        % But if the trace starts with a gap, we want to include it as a real
        % gap no matter what length it is
        if (droplet_location_data.gap_start_loc(1)==1)&(real_gaps(1)~=1)
            real_gaps=[1; real_gaps];
        end
        % similarly if the trace ends with a gap, we want to include the last
        % gap as a real gap no matter what length it is
        % length(gap_width)= last gap 
        if (droplet_location_data.gap_end_loc(end)==total_no_of_time_pts)&(real_gaps(end)~=length(gap_width))
            real_gaps=[real_gaps; length(gap_width)];
        end

        droplet_location_data.gap_start_loc=droplet_location_data.gap_start_loc(real_gaps);
        droplet_location_data.gap_end_loc=droplet_location_data.gap_end_loc(real_gaps);
    end
end	
%****************************************************************************************************



%****************************************************************************************************
% Obtain the droplet start and end locations from the gap location data
% DO this only if gap_start_loc is not empty
if ~isempty(droplet_location_data.gap_start_loc)
	% convert the gap locations into droplet locations
	if droplet_location_data.gap_start_loc(1)==1 & droplet_location_data.gap_end_loc(end)==total_no_of_time_pts
		% in this case, the no of droplets is 1 less than no of gaps
        % changed droplet start and end loc to overlap with gap end and gap start loc respectively on 07-27-10
        droplet_location_data.droplet_start_loc=droplet_location_data.gap_end_loc(1:end-1);
		droplet_location_data.droplet_end_loc=droplet_location_data.gap_start_loc(2:end);
        %droplet_location_data.droplet_start_loc=droplet_location_data.gap_end_loc(1:end-1)+1;
        %droplet_location_data.droplet_end_loc=droplet_location_data.gap_start_loc(2:end)-1;
	elseif droplet_location_data.gap_start_loc(1)==1 | droplet_location_data.gap_end_loc(end)==total_no_of_time_pts
		if droplet_location_data.gap_start_loc(1)==1		 
        % changed droplet start and end loc to overlap with gap end and gap start loc respectively on 07-27-10
            droplet_location_data.droplet_start_loc=droplet_location_data.gap_end_loc;
			droplet_location_data.droplet_end_loc=[droplet_location_data.gap_start_loc(2:end);total_no_of_time_pts];
% 			droplet_location_data.droplet_start_loc=droplet_location_data.gap_end_loc+1;
% 			droplet_location_data.droplet_end_loc=[droplet_location_data.gap_start_loc(2:end)-1;total_no_of_time_pts];
		elseif droplet_location_data.gap_end_loc(end)==total_no_of_time_pts
            % changed droplet start and end loc to overlap with gap end and gap start loc respectively on 07-27-10
            droplet_location_data.droplet_start_loc=[1;droplet_location_data.gap_end_loc(1:end-1)];
			droplet_location_data.droplet_end_loc=droplet_location_data.gap_start_loc;
% 			droplet_location_data.droplet_start_loc=[1;droplet_location_data.gap_end_loc(1:end-1)+1];
% 			droplet_location_data.droplet_end_loc=droplet_location_data.gap_start_loc-1;
		end
    else
        % changed droplet start and end loc to overlap with gap end and gap start loc respectively on 07-27-10
        droplet_location_data.droplet_start_loc=[1;droplet_location_data.gap_end_loc];
		droplet_location_data.droplet_end_loc=[droplet_location_data.gap_start_loc;total_no_of_time_pts];
% 		droplet_location_data.droplet_start_loc=[1;droplet_location_data.gap_end_loc+1];
% 		droplet_location_data.droplet_end_loc=[droplet_location_data.gap_start_loc-1;total_no_of_time_pts];
	end 

else
	droplet_location_data.droplet_start_loc=[];
	droplet_location_data.droplet_end_loc=[];
end
%****************************************************************************************************



%****************************************************************************************************
% A HACK TO TAKE CARE OF SINGULARITIES WHEN THEN ARE NO DROPLETS FOUND 
% have to think of a better way to handle this
if isempty(droplet_location_data.droplet_start_loc)&isempty(droplet_location_data.droplet_end_loc)
    droplet_location_data.droplet_start_loc=total_no_of_time_pts;
    droplet_location_data.droplet_end_loc=total_no_of_time_pts;
end	
%****************************************************************************************************



%****************************************************************************************************
droplet_location_data.droplet_width_data=droplet_location_data.droplet_end_loc-droplet_location_data.droplet_start_loc;
% convert this data in msecs
droplet_location_data.droplet_width_data=droplet_location_data.droplet_width_data*bin_time_in_msec;

droplet_location_data.total_no_of_droplets=length(droplet_location_data.droplet_width_data);


% Find the max and average height for each droplet
for droplet=1:droplet_location_data.total_no_of_droplets
    for channel=1:no_of_channels
        droplet_location_data.max_drop_height(droplet,channel)=max(corrected_channel_data(droplet_location_data.droplet_start_loc(droplet):droplet_location_data.droplet_end_loc(droplet),channel));
        droplet_location_data.avg_drop_height(droplet,channel)=mean(corrected_channel_data(droplet_location_data.droplet_start_loc(droplet):droplet_location_data.droplet_end_loc(droplet),channel));
        droplet_location_data.std_drop_height(droplet,channel)=std(corrected_channel_data(droplet_location_data.droplet_start_loc(droplet):droplet_location_data.droplet_end_loc(droplet),channel));
        droplet_location_data.cv_drop_height(droplet,channel)=droplet_location_data.std_drop_height(droplet,channel)/droplet_location_data.avg_drop_height(droplet,channel);
    end
end
%****************************************************************************************************    
    

%****************************************************************************************************
% Filter droplets to include only certain length or height droplets in the analysis
if (isfield(data_processing_options,'Droplet_Time_filtering'))|(isfield(data_processing_options,'Droplet_Height_filtering'))
    % store the unfiltered droplet locations and other stats for later review.                                                
    droplet_location_data.unfiltered_droplet_start_loc=droplet_location_data.droplet_start_loc;
    droplet_location_data.unfiltered_droplet_end_loc=droplet_location_data.droplet_end_loc;
    droplet_location_data.unfiltered_droplet_width_data=droplet_location_data.droplet_width_data;
    droplet_location_data.unfiltered_total_no_of_droplets=droplet_location_data.total_no_of_droplets;
    droplet_location_data.unfiltered_max_drop_height=droplet_location_data.max_drop_height;
    droplet_location_data.unfiltered_avg_drop_height=droplet_location_data.avg_drop_height;
    droplet_location_data.unfiltered_std_drop_height=droplet_location_data.std_drop_height;
    droplet_location_data.unfiltered_cv_drop_height=droplet_location_data.cv_drop_height;
    
    if isfield(data_processing_options,'Droplet_Time_filtering')
        if ~isempty(regexp(data_processing_options.Droplet_Time_filtering,'Yes','ignorecase'))
            droplets_within_allowed_width_range=find((droplet_location_data.droplet_width_data<=data_processing_options.droplet_width_max)&...
                                                     (droplet_location_data.droplet_width_data>=data_processing_options.droplet_width_min));
            % store the filtered data in the original variables
            droplet_location_data.droplet_start_loc=droplet_location_data.droplet_start_loc(droplets_within_allowed_width_range);
            droplet_location_data.droplet_end_loc=droplet_location_data.droplet_end_loc(droplets_within_allowed_width_range);
            droplet_location_data.droplet_width_data=droplet_location_data.droplet_width_data(droplets_within_allowed_width_range);
            droplet_location_data.total_no_of_droplets=length(droplet_location_data.droplet_width_data);
            droplet_location_data.max_drop_height=droplet_location_data.max_drop_height(droplets_within_allowed_width_range,:);
            droplet_location_data.avg_drop_height=droplet_location_data.avg_drop_height(droplets_within_allowed_width_range,:);
            droplet_location_data.std_drop_height=droplet_location_data.std_drop_height(droplets_within_allowed_width_range,:);
            droplet_location_data.cv_drop_height=droplet_location_data.cv_drop_height(droplets_within_allowed_width_range,:);
        end
    end    	
    
    if isfield(data_processing_options,'Droplet_Height_filtering')
        if ~isempty(regexp(data_processing_options.Droplet_Height_filtering,'Yes','ignorecase'))
            
            if strcmpi('Max',data_processing_options.Droplet_Height_filtering_type)
                droplets_within_allowed_height_range=find((droplet_location_data.max_drop_height(:,reference_channel)<=data_processing_options.droplet_height_max)&...
                                                      (droplet_location_data.max_drop_height(:,reference_channel)>=data_processing_options.droplet_height_min));  
            elseif strcmpi('Avg',data_processing_options.Droplet_Height_filtering_type)
                droplets_within_allowed_height_range=find((droplet_location_data.avg_drop_height(:,reference_channel)<=data_processing_options.droplet_height_max)&...
                                      (droplet_location_data.avg_drop_height(:,reference_channel)>=data_processing_options.droplet_height_min));
            elseif strcmpi('Std',data_processing_options.Droplet_Height_filtering_type)
                droplets_within_allowed_height_range=find((droplet_location_data.std_drop_height(:,reference_channel)<=data_processing_options.droplet_height_max)&...
                                      (droplet_location_data.std_drop_height(:,reference_channel)>=data_processing_options.droplet_height_min));
            elseif strcmpi('CV',data_processing_options.Droplet_Height_filtering_type)
                droplets_within_allowed_height_range=find((droplet_location_data.cv_drop_height(:,reference_channel)<=data_processing_options.droplet_height_max)&...
                                      (droplet_location_data.cv_drop_height(:,reference_channel)>=data_processing_options.droplet_height_min));
            end
                                                  
%             droplets_within_allowed_height_range=[];
%             for droplet=1:droplet_location_data.total_no_of_droplets
%                 max_drop_height=max(corrected_channel_data(droplet_location_data.droplet_start_loc(droplet):droplet_location_data.droplet_end_loc(droplet),reference_channel));
%                 if (max_drop_height>=data_processing_options.droplet_height_min) & (max_drop_height<=data_processing_options.droplet_height_max)
%                     droplets_within_allowed_height_range(end+1)=droplet;
%                 end
%             end
            
            droplet_location_data.droplet_start_loc=droplet_location_data.droplet_start_loc(droplets_within_allowed_height_range);
            droplet_location_data.droplet_end_loc=droplet_location_data.droplet_end_loc(droplets_within_allowed_height_range);
            droplet_location_data.droplet_width_data=droplet_location_data.droplet_width_data(droplets_within_allowed_height_range);
            droplet_location_data.total_no_of_droplets=length(droplet_location_data.droplet_width_data);
            
            droplet_location_data.max_drop_height=droplet_location_data.max_drop_height(droplets_within_allowed_height_range,:);
            droplet_location_data.avg_drop_height=droplet_location_data.avg_drop_height(droplets_within_allowed_height_range,:);
            droplet_location_data.std_drop_height=droplet_location_data.std_drop_height(droplets_within_allowed_height_range,:);
            droplet_location_data.std_drop_height=droplet_location_data.cv_drop_height(droplets_within_allowed_height_range,:);
        end
    end
end    
%****************************************************************************************************



%**************************************************************************************************************
% A HACK TO TAKE CARE OF SINGULARITIES WHEN THEN ARE NO DROPLETS FOUND 
% have to think of a better way to handle this
if isempty(droplet_location_data.droplet_start_loc)&isempty(droplet_location_data.droplet_end_loc)
    droplet_location_data.droplet_start_loc=total_no_of_time_pts;
    droplet_location_data.droplet_end_loc=total_no_of_time_pts;
end	
%**************************************************************************************************************

%**************************************************************************************************************
% Generate an array with 1s at droplet locations and 0s at oil locations

    droplet_location_array=zeros(total_no_of_time_pts,1);

    %	droplet_location_string=strcat(num2str(droplet_location_data.droplet_start_loc),':',...
    %					num2str(droplet_location_data.droplet_end_loc),',');
    %	droplet_location_string=droplet_location_string';
    %	droplet_location_string=droplet_location_string(:); % convert the concatenated matrix to a vector
        % to avoid the problem created by zero number of droplets
    %	if ~strcmp(droplet_location_string',':,')
            % last character in the string is an extra ',', which is not needed
    %		droplet_location_array(eval(['[' droplet_location_string(1:end-1)' ']']),1)=1;
    %	end


    % try the loop instead of vectorizing this operation
    % THIS loop is incredibly fast compared to the vectorized operation before!
    for droplet=1:droplet_location_data.total_no_of_droplets
        droplet_location_array(droplet_location_data.droplet_start_loc(droplet):droplet_location_data.droplet_end_loc(droplet))=1;
    end		

    % Store the droplet_location_array for easy access in other functions
    droplet_location_data.droplet_location_array=droplet_location_array;
%**************************************************************************************************************



%**************************************************************************************************************     
if ~isempty(regexp(data_processing_options.count_peaks,'Yes','ignorecase'))    
     % Read or generate peak counting baselines if required
    if ~isempty(regexp(data_processing_options.Peak_counting_threshold,'Manual','ignorecase'))
        if nargin>3 
            threshold_struct=varargin{1}; % additional argument is included in function call only for manual thresholding
        else
            sprintf('Manual threshold selected for peak counting but threshold data not included in function call')
            return;
        end
        baselines=threshold_struct.baselines;

    elseif ~isempty(regexp(data_processing_options.Peak_counting_threshold,'Auto','ignorecase'))
        % calculate the baselines for separating background from signal here
        corrected_channel_signal_means=mean(corrected_channel_data,1)
        corrected_channel_signal_stdev=std(corrected_channel_data,0,1)
        baselines=(corrected_channel_signal_means+data_processing_options.Peak_counting_baseline*corrected_channel_signal_stdev);	
    end

    droplet_location_data.baselines=baselines;
end
%**************************************************************************************************************


%**************************************************************************************************************
if ~isempty(regexp(data_processing_options.count_peaks,'Yes','ignorecase'))&isempty(regexp(data_processing_options.droplet_data_synchronized,'Yes','ignorecase'))
    % Now find out the shift required for other channels to maximize the number of peaks coincident with the droplets
    % calculate or set the baselines for peak counting here 
    % THIS IS DONE ONLY IF PEAK COUNTING IS ENABLED
    
    %**************************************************************************************************************
    % Generate an array with ones for data points above baselines and 0s for data points below baseline
    % for each channel
    potential_peaks=corrected_channel_data>=repmat(baselines,size(corrected_channel_data,1),1);

    shift_range_max=data_processing_options.Shift_range_max;
    % Shift array arranged this way so that the default shift is 0 if shifting isnt found to increase coincidence
    shift_array=[0 1:shift_range_max -1:-1:-shift_range_max];
    for shift=shift_array

        shifted_potential_peaks=circshift(potential_peaks,shift);
        % circshift is convenient, but we don't want the data from the bottom of the time trace
        % to replace the data on top...so set all the time traces to zero upto the point of shift
        if shift<0
            shifted_potential_peaks(end-abs(shift)+1:end,:)=0;
        elseif shift>0
            shifted_potential_peaks(1:shift,:)=0;
        end

        for channel=1:no_of_channels
            if channel~=reference_channel
                total_peak_data_points_in_droplets=sum(shifted_potential_peaks(:,channel).*droplet_location_array);	
                if shift==0
                    total_peak_count(channel)=total_peak_data_points_in_droplets;
                    droplet_location_data.optimum_channel_shift(channel)=shift;
                else
                    if total_peak_data_points_in_droplets>total_peak_count(channel)
                        total_peak_count(channel)=total_peak_data_points_in_droplets;
                        droplet_location_data.optimum_channel_shift(channel)=shift;
                    end
                end
            end	
        end
    end

    total_peak_count(reference_channel)=sum(droplet_location_array);
    droplet_location_data.optimum_channel_shift(reference_channel)=0;

else %(data synchronized condition)
    droplet_location_data.optimum_channel_shift(1:no_of_channels)=0;
end  %(data synchronized condition)
%**************************************************************************************************************


%**************************************************************************************************************
% Now that we have the optimum shifts for all channels, lets calculate the droplet_burst_energy data
% for each droplet for each channel
if ~isempty(regexp(data_processing_options.Burst_analysis,'Yes','ignorecase'))
    for channel=1:no_of_channels
        shift=droplet_location_data.optimum_channel_shift(channel);
        shifted_corrected_channel_data=circshift(corrected_channel_data(:,channel),shift);

        if shift<0
            shifted_corrected_channel_data(end-abs(shift)+1:end,:)=0;
        elseif shift>0
            shifted_corrected_channel_data(1:shift,:)=0;
        end

        %************************************************************************************************
        % permanently shift the corrected channel data so that we dont have to do it again while plotting
        corrected_channel_data(:,channel)=shifted_corrected_channel_data;
        %************************************************************************************************


        % Convert shifted_corrected_channel_data to contain SMD data corresponding to droplets only
        shifted_corrected_channel_data=shifted_corrected_channel_data.*droplet_location_array;

        % A weird way to vectorize the burst energy calculation
        % Cumsum ensures that at the peak end locations you have the sum of burst energies 
        % for all peaks upto the current peak
        shifted_corrected_channel_data=cumsum(shifted_corrected_channel_data);
        % so now if all the peak end location sums are collected and then cumulative difference is calculated
        % then burst_energy_data will contain the burst energy for respective peaks
        droplet_burst_energy_data=shifted_corrected_channel_data(droplet_location_data.droplet_end_loc);
        shifted_droplet_burst_energy_data=circshift(droplet_burst_energy_data,1);
        shifted_droplet_burst_energy_data(1)=0;
        droplet_burst_energy_data=droplet_burst_energy_data-shifted_droplet_burst_energy_data;

        %**************************************************************************************************************
        % Following two operations needed only if burst energy is
        % normalized to a standard drop size
            % Burst energy depends on the time resolution at which the data was collected
            %droplet_burst_energy_data=droplet_burst_energy_data.*bin_time_in_msec;

            % normalize droplet burst energy with droplet width and find burst energy data for reference width droplet 
            %droplet_burst_energy_data=droplet_burst_energy_data./droplet_location_data.droplet_width_data*data_processing_options.Reference_drop_size_in_msec;
        %**************************************************************************************************************    

        % store droplet burst energy for all channels in a single array
        droplet_burst_energy(:,channel)=droplet_burst_energy_data;

        %????????????????/ Should we subtract background from the burst energy????????????

    end
    clear droplet_burst_energy_data
    % save the droplet burst energy data with the droplet_location_data structure
    droplet_location_data.droplet_burst_energy=droplet_burst_energy;		
end % Conduct burst analysis condition
%**************************************************************************************************************



%**************************************************************************************************************
% Find peak locations in all channels here
% doing this operation here so that we don't have to worry about
% channel shift for each channel
if ~isempty(regexp(data_processing_options.count_peaks,'Yes','ignorecase'))
    potential_peaks=corrected_channel_data>=repmat(baselines,size(corrected_channel_data,1),1);
    potential_peaks_shifted_by_1_step=circshift(potential_peaks,1);
    potential_peaks_shifted_by_1_step(1,:)=0;
    potential_peaks_difference=potential_peaks-potential_peaks_shifted_by_1_step;
    % store peak locations in all channels here
    for channel=1:no_of_channels
        peak_location_data.channel(channel).peak_start_loc=find(potential_peaks_difference(:,channel)==1);
        peak_location_data.channel(channel).peak_end_loc=find(potential_peaks_difference(:,channel)==(-1))-1;
        if length(peak_location_data.channel(channel).peak_end_loc)<length(peak_location_data.channel(channel).peak_start_loc)
            % the peak end location of last peak is absent if the last data point is '1'
            peak_location_data.channel(channel).peak_end_loc(end+1)=size(corrected_channel_data,1);
        end	 
    end

    % Now find the peaks within the droplet region for all channels
    for droplet=1:droplet_location_data.total_no_of_droplets
        for channel=1:no_of_channels
            % find the peaks starting after the droplet starting location
            peaks_within_droplet=find((peak_location_data.channel(channel).peak_end_loc>droplet_location_data.droplet_start_loc(droplet))&...
                                                (peak_location_data.channel(channel).peak_start_loc<droplet_location_data.droplet_end_loc(droplet)));

            if ~isempty(peaks_within_droplet)
                % The first peak from these peaks is the first peak within the droplet boundary
                %peaks_within_droplet_start_peak=peaks_within_droplet(1);
                % find all the peaks occuring before the droplet ending location
                %peaks_within_droplet_end_peak=peaks_within_droplet(end);
                %peaks_within_droplet_end_peak=find(peak_location_data.channel(channel).peak_start_loc<droplet_location_data.droplet_end_loc(droplet));
                % The last peak amongst these peaks is the last peak starting within the droplet boundary. We will assume the
                % last peak to be a part of the droplet even if it doesnt end within the droplet boundary
                %peaks_within_droplet_end_peak=peaks_within_droplet_end_peak(end);
                % store the 'peak within droplet data' into the droplet_location_data structure 
                %droplet_location_data.channel(channel).droplet(droplet).peak_data.peak_start_loc=...
                %    peak_location_data.channel(channel).peak_start_loc(peaks_within_droplet_start_peak:peaks_within_droplet_end_peak);
                droplet_location_data.channel(channel).droplet(droplet).peak_data.peak_start_loc=...
                    peak_location_data.channel(channel).peak_start_loc(peaks_within_droplet);
                droplet_location_data.channel(channel).droplet(droplet).peak_data.peak_end_loc=...
                    peak_location_data.channel(channel).peak_end_loc(peaks_within_droplet);
                %droplet_location_data.channel(channel).droplet(droplet).peak_data.peak_end_loc=...
                %    peak_location_data.channel(channel).peak_end_loc(peaks_within_droplet_start_peak:peaks_within_droplet_end_peak);
                droplet_location_data.channel(channel).droplet_peak_count(droplet,1)=length(peaks_within_droplet);
            else
                droplet_location_data.channel(channel).droplet_peak_count(droplet,1)=0;
            end   
        end   
    end		
    % Store average and std of droplet peak count
    for channel=1:no_of_channels
            % Average peak count for a standard transit time droplet 
            % specified in the data processing options
            % (Reference_drop_size_in_msec)
            droplet_location_data.average_peak_count_per_drop(channel)=mean((droplet_location_data.channel(channel).droplet_peak_count)...
                ./droplet_location_data.droplet_width_data*data_processing_options.Reference_drop_size_in_msec);
            droplet_location_data.stdev_peak_count_per_drop(channel)=std(((droplet_location_data.channel(channel).droplet_peak_count)...
                ./droplet_location_data.droplet_width_data)*data_processing_options.Reference_drop_size_in_msec);
    end        
end % Count peaks? condition
%**************************************************************************************************************
   

        
%**************************************************************************************************************        
% Generate the FRET efficiencies for the FRET pairs specified 
if isfield(data_processing_options,'FRET_donor')
    if ~isempty(data_processing_options.FRET_donor)
        no_of_FRET_pairs=length(data_processing_options.FRET_donor);
        fret_donor=data_processing_options.FRET_donor;
        fret_acceptor=data_processing_options.FRET_acceptor;		
        droplet_location_data.FRET_efficiency=droplet_burst_energy(:,fret_acceptor)./(droplet_burst_energy(:,fret_acceptor)+...
                            droplet_burst_energy(:,fret_donor)); 
    end
end
%**************************************************************************************************************        