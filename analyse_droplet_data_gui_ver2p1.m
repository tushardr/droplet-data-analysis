
function varargout = analyse_droplet_data_gui_ver2p1(varargin)
% ANALYSE_DROPLET_DATA_GUI_VER2P1 MATLAB code for analyse_droplet_data_gui_ver2p1.fig
%      ANALYSE_DROPLET_DATA_GUI_VER2P1, by itself, creates a new ANALYSE_DROPLET_DATA_GUI_VER2P1 or raises the existing
%      singleton*.
%
%      H = ANALYSE_DROPLET_DATA_GUI_VER2P1 returns the handle to a new ANALYSE_DROPLET_DATA_GUI_VER2P1 or the handle to
%      the existing singleton*.
%
%      ANALYSE_DROPLET_DATA_GUI_VER2P1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALYSE_DROPLET_DATA_GUI_VER2P1.M with the given input arguments.
%
%      ANALYSE_DROPLET_DATA_GUI_VER2P1('Property','Value',...) creates a new ANALYSE_DROPLET_DATA_GUI_VER2P1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before analyse_droplet_data_gui_ver2p1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to analyse_droplet_data_gui_ver2p1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help analyse_droplet_data_gui_ver2p1

% Last Modified by GUIDE v2.5 21-Aug-2013 15:44:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @analyse_droplet_data_gui_ver2p1_OpeningFcn, ...
                   'gui_OutputFcn',  @analyse_droplet_data_gui_ver2p1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before analyse_droplet_data_gui_ver2p1 is made visible.
function analyse_droplet_data_gui_ver2p1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to analyse_droplet_data_gui_ver2p1 (see VARARGIN)

% Choose default command line output for analyse_droplet_data_gui_ver2p1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes analyse_droplet_data_gui_ver2p1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Executes on button press in start_button.
function start_button_Callback(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


expt_conditions_sample_desc=getappdata(0,'expt_conditions_sample_desc');
data_processing_options=getappdata(0,'data_processing_options');
manual_thresholds=getappdata(0,'manual_thresholds');
channels_to_process=data_processing_options.data_channels;
data_dir=expt_conditions_sample_desc.data_directory;
% save a copy of sample names in a separate var for shorter code later on 
sample_names=expt_conditions_sample_desc.sample_names; 
extended_sample_names=expt_conditions_sample_desc.extended_sample_names;


% Obtain the matlab data filename and location to save the
% processed data
[results_data_file,dir]=uiputfile('results.mat','Pick a mat file to save the processed droplet data');

% generate another filename to store raw data only
results_raw_data_file=strcat(results_data_file(1:regexp(results_data_file,'.mat')-1),'_raw_data.mat');

% Merge filename and directory to not worry about changing
% directories
results_data_file=strcat(dir,results_data_file);

results_raw_data_file=strcat(dir,results_raw_data_file)
% Save the experimental conditions and data processing options
% to the file
save(results_data_file,'expt_conditions_sample_desc','data_processing_options');

save(results_raw_data_file,'expt_conditions_sample_desc','data_processing_options');

%Cycle through all the samples in the expt to process their data one by one
for sample=1:length(sample_names)
    % Let user know the current sample being processed
    set(handles.current_sample,'String',sample_names{sample});    
    drawnow;
    % find the duration(secs) and bin time(msec) of the time traces
    % replace all '_' in sample names with '-' again to read the right
    % files 
    % THIS MEANS ALL DATA FILENAMES EITHER HAVE TO HAVE ALL UNDERSCORES OR
    % DASHES BUT NOT BOTH
    [bin_time,data_trace_duration,first_time_point]=get_smd_data_trace_stats_ver2p1(strcat(data_dir,'\',regexprep(sample_names{sample},'_','-'),'-ch',num2str(channels_to_process(1)),'-1.txt'));
    
    % Find different time ranges to process for this sample
    extended_sample_names_to_process=extended_sample_names(~cellfun(@isempty,strfind(extended_sample_names,sample_names{sample})));
    
    
    for extended_sample=1:length(extended_sample_names_to_process)
        
        time_range=strrep(extended_sample_names_to_process{extended_sample},sample_names{sample},'');
        time_range=time_range(2:end); %Remove first character in the string which is a '_'
        [time_range_start,time_range_end]=strtok(time_range,'_');
        time_range_end=time_range_end(2:end); %Remove first character in the string which is a '_'
        time_range_start=str2num(time_range_start);
        time_range_end=str2num(time_range_end);
        
        % if the starting point is an integer multiple of data trace
        % duration, start reading from the next data trace as the
        % quotient of starting point/data trace duration
        if rem(time_range_start/data_trace_duration,1)==0
            data_traces_to_read=[ceil(time_range_start/data_trace_duration)+1:ceil(time_range_end/data_trace_duration)];        
        else
            data_traces_to_read=[ceil(time_range_start/data_trace_duration):ceil(time_range_end/data_trace_duration)];
        end
	
        % Read manual threshold data if required for processing current
        % sample
        if isfield(data_processing_options,'Peak_counting_threshold')
            if ~isempty(regexp(data_processing_options.Droplet_counting_threshold,'Manual','ignorecase'))|...
                    ~isempty(regexp(data_processing_options.Peak_counting_threshold,'Manual','ignorecase'))
                % Find the row number of the extended sample in the
                % manual_thresholds structure
                extended_sample_loc=find(strcmp(manual_thresholds(:,1),extended_sample_names_to_process{extended_sample}));
                % If both droplet and peak counting baselines are to be read
                if ~isempty(regexp(data_processing_options.Droplet_counting_threshold,'Manual','ignorecase'))&~isempty(regexp(data_processing_options.Peak_counting_threshold,'Manual','ignorecase'))
                    current_manual_thresholds.droplet_baseline=manual_thresholds{extended_sample_loc,2};
                    current_manual_thresholds.baselines=manual_thresholds{extended_sample_loc,3:end};
                    % If only droplet baseline is to be read
                elseif ~isempty(regexp(data_processing_options.Droplet_counting_threshold,'Manual','ignorecase'))&isempty(regexp(data_processing_options.Peak_counting_threshold,'Manual','ignorecase'))
                    current_manual_thresholds.droplet_baseline=manual_thresholds{extended_sample_loc,2};
                    % If only peak counting baselines are to be read
                elseif isempty(regexp(data_processing_options.Droplet_counting_threshold,'Manual','ignorecase'))&~isempty(regexp(data_processing_options.Peak_counting_threshold,'Manual','ignorecase'))
                    current_manual_thresholds.baselines=manual_thresholds{extended_sample_loc,2:end};
                end
            end
        else
            if ~isempty(regexp(data_processing_options.Droplet_counting_threshold,'Manual','ignorecase'))
                extended_sample_loc=find(strcmp(manual_thresholds(:,1),extended_sample_names_to_process{extended_sample}));
                current_manual_thresholds.droplet_baseline=manual_thresholds{extended_sample_loc,2};
            end
        end
        %****************************************************************************************************
        % loop through all the time traces collected for the current sample here
        for time_trace=1:length(data_traces_to_read)
            
            %****************************************************************************************************
            % loop through all the data channels collected for the current sample and time trace here
            for channel=1:length(channels_to_process)
                
                % use the common data file format sample_namech1-1.txt to find the data file for the current
                % sample, time trace and channel number
                data_file_name=strcat([regexprep(sample_names{sample},'_','-') '-ch' num2str(channels_to_process(channel)) '-' num2str(data_traces_to_read(time_trace)) '.txt']);
                
                % Let user know the current data file being processed
                set(handles.sample_data_file,'String',data_file_name);   
                drawnow;
                
                read_data=load(data_file_name);			
                if channel==1
                    % first column in all channel data contains the time point counts for reference later on
                    % Instead of time points for a particular trace, save
                    % the absolute time points for that particular sample
                    % time points in a 10 sec time trace go from 0 to 9999.
                    % So add 1 bin time to the time points to make the
                    % range to go from 1 to 10000
                    %BUT APD data rebinning gui does this already. So do
                    %this only if required
                    if ~first_time_point
                        all_channel_data(:,1)=(data_traces_to_read(time_trace)-1)*data_trace_duration*1000+read_data(:,1)+bin_time;
                    else
                        all_channel_data(:,1)=(data_traces_to_read(time_trace)-1)*data_trace_duration*1000+read_data(:,1);
                    end
                end			
                all_channel_data(:,channel+1)=read_data(:,2);
            end % channel loop
            clear read_data
            %****************************************************************************************************
            
            % For the first and last time trace, read only the data points
            % either starting from the time_range_start or ending at
            % time_range_end
            if time_trace==1
                    if time_range_start~=0
                        % while reading the first time trace only retain
                        % the data from the starting time point
                        all_channel_data=all_channel_data(find(all_channel_data(:,1)==(time_range_start*1000+bin_time)):end,:);
                    else
                        % Since we shifted all data timelines to move from
                        % 0-999 to 1-1000, we need to use this condition
                        % when user specifies time to start from 0
                        all_channel_data=all_channel_data(find(all_channel_data(:,1)==bin_time):end,:);
                    end
            end
            
            % Modification done on 09/26/2013 to take care of the case when
            % a single data trace is read i.e. the same trace is first and
            % last trace
            if time_trace==length(data_traces_to_read)
                    % while reading the last time trace only retain
                    % data till the ending time point
                    all_channel_data=all_channel_data(1:find(all_channel_data(:,1)==time_range_end*1000),:);
            end
            
                
            % conduct all the requested analysis on the data here
            % peak_counts contains no of peaks from all channels in the order of channel no
            % coin_counts contains coincident counts in the order of combinations 1:2, 1:3 ...1:n,2:3,...2:n...n-1:n
            % peak_location_data contains peak start and end locations stored for all channels along with baselines 
            % used for separating peaks from background for all channels
            % coin_peak_location_data contains coin_peak_start and end loc, two channel combinations and optimum_shift
            % between 1st and 2nd channels found by the program within the limits of +-shift_range_max

            % find the position of droplets using data from the reference channel
            % call the droplet_finder function with manual thresholds if manual thresholding was selected else call droplet_finder without thresholding information.
            %if ~isempty(regexp(data_processing_options.Droplet_counting_threshold,'Manual','ignorecase'))|...
            %    ~isempty(regexp(data_processing_options.Peak_counting_threshold,'Manual','ignorecase'))

            
            if exist('current_manual_thresholds')
            
                [droplet_location_data,corrected_channel_data]=droplet_finder_ver2p1(all_channel_data,data_processing_options,...
                    expt_conditions_sample_desc,bin_time,current_manual_thresholds);

            else 

                [droplet_location_data,corrected_channel_data]=droplet_finder_ver2p1(all_channel_data,data_processing_options,...
                            expt_conditions_sample_desc,bin_time);

            end	

            clear all_channel_data 
            
            droplet_location_data.bin_time_in_msec=bin_time;
            % Save all the analysis results from droplet finder into a structure for the current sample
            % Save the actual data trace numbers read from a sample in the
            % data_traces_read variable
            eval([extended_sample_names_to_process{extended_sample} '.data_traces_read(' num2str(time_trace) ')=data_traces_to_read(' num2str(time_trace) ');'])
            % Save the channel data and the droplet data corresponding to
            % the data traces read. Note that the index is not the same as
            % the actual trace number since traces can be read from a
            % random starting point
            eval([extended_sample_names_to_process{extended_sample} '_tt_' num2str(time_trace) '_corrected_channel_data=corrected_channel_data;']);
            eval([extended_sample_names_to_process{extended_sample} '.time_trace(' num2str(time_trace) ').droplet_location_data=droplet_location_data;']);

            % save a few important results in a struct summary_results for easy access in the expt report
            % generator function				
            if isfield(data_processing_options,'FRET_donor')
                if ~isempty(data_processing_options.FRET_donor)
                    eval(['summary_results.' extended_sample_names_to_process{extended_sample} '.time_trace(' num2str(time_trace) ').FRET_pairs=' ...
                        '[data_processing_options.FRET_donor;data_processing_options.FRET_acceptor];']);

                    eval(['summary_results.' extended_sample_names_to_process{extended_sample} '.time_trace(' num2str(time_trace) ').mean_FRET_efficiency=' ...
                        'mean(droplet_location_data.FRET_efficiency,1);']);

                    eval(['summary_results.' extended_sample_names_to_process{extended_sample} '.time_trace(' num2str(time_trace) ').std_FRET_efficiency=' ...
                        'std(droplet_location_data.FRET_efficiency,0,1);']);				
                end
            end

            eval(['summary_results.' extended_sample_names_to_process{extended_sample} '.time_trace(' num2str(time_trace) ').optimum_channel_shift=' ...
                'droplet_location_data.optimum_channel_shift;']);

            eval(['summary_results.' extended_sample_names_to_process{extended_sample} '.time_trace(' num2str(time_trace) ').droplet_baseline=' ...
                'droplet_location_data.droplet_baseline;']);

            if ~isempty((regexp(data_processing_options.count_peaks,'Yes','ignorecase')))
                eval(['summary_results.' extended_sample_names_to_process{extended_sample} '.time_trace(' num2str(time_trace) ').baselines=' ...
                    'droplet_location_data.baselines;']);

                eval(['summary_results.' extended_sample_names_to_process{extended_sample} '.time_trace(' num2str(time_trace) ').average_peak_count_per_droplet=' ...
                    'droplet_location_data.average_peak_count_per_drop;']);

                eval(['summary_results.' extended_sample_names_to_process{extended_sample} '.time_trace(' num2str(time_trace) ').stdev_peak_count_per_droplet=' ...
                    'droplet_location_data.stdev_peak_count_per_drop;']);
            end

            eval(['summary_results.' extended_sample_names_to_process{extended_sample} '.time_trace(' num2str(time_trace) ').total_no_of_droplets=' ...
                'droplet_location_data.total_no_of_droplets;']);

            if ~isempty((regexp(data_processing_options.Burst_analysis,'Yes','ignorecase')))
                eval(['summary_results.' extended_sample_names_to_process{extended_sample} '.time_trace(' num2str(time_trace) ').mean_burst_energy=' ...
                    'mean(droplet_location_data.droplet_burst_energy,1);']);
            
                eval(['summary_results.' extended_sample_names_to_process{extended_sample} '.time_trace(' num2str(time_trace) ').std_burst_energy=' ...
                    'std(droplet_location_data.droplet_burst_energy,0,1);']);
            end
            
            eval(['summary_results.' extended_sample_names_to_process{extended_sample} '.time_trace(' num2str(time_trace) ').mean_droplet_width=' ...
                'mean(droplet_location_data.droplet_width_data,1);']);

            eval(['summary_results.' extended_sample_names_to_process{extended_sample} '.time_trace(' num2str(time_trace) ').std_droplet_width=' ...
                'std(droplet_location_data.droplet_width_data,0,1);']);            
            
            
            % Save the raw data in the raw data file
            save(results_raw_data_file,[extended_sample_names_to_process{extended_sample} '_tt_' num2str(time_trace) '_corrected_channel_data'],'-append');
            clear([extended_sample_names_to_process{extended_sample} '_tt_' num2str(time_trace) '_corrected_channel_data'])
            
        end % time trace loop
        %****************************************************************************************************

        
        
        % append data from each extended sample in a separate structure to the matlab file here
        save(results_data_file,extended_sample_names_to_process{extended_sample},'-append');
        %**************************************************************************************************		
        eval(['clear ' extended_sample_names_to_process{extended_sample}])
        
        clear current_manual_thresholds
    end % Extended sample loop
    extended_sample_names_to_process{extended_sample}
	% save any samplewide statistics (if any!!) here
    [samplewide_stats]=gen_samplewide_stats_from_droplet_data_ver2p1(results_data_file,extended_sample_names_to_process);
    eval(['summary_results.' sample_names{sample} '.samplewide_stats=samplewide_stats;'])
    
end  % sample loop
%**************************************************************************************************		

save(results_data_file,'summary_results','-append');

close(hObject);
% --- Outputs from this function are returned to the command line.
function varargout = analyse_droplet_data_gui_ver2p1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;


