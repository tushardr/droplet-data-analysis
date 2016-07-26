function varargout = gen_droplet_data_plots_gui_ver2p3(varargin)
% GEN_DROPLET_DATA_PLOTS_GUI_VER2P2 MATLAB code for gen_droplet_data_plots_gui_ver2p2.fig
%      GEN_DROPLET_DATA_PLOTS_GUI_VER2P2, by itself, creates a new GEN_DROPLET_DATA_PLOTS_GUI_VER2P2 or raises the existing
%      singleton*.
%
%      H = GEN_DROPLET_DATA_PLOTS_GUI_VER2P2 returns the handle to a new GEN_DROPLET_DATA_PLOTS_GUI_VER2P2 or the handle to
%      the existing singleton*.
%
%      GEN_DROPLET_DATA_PLOTS_GUI_VER2P2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GEN_DROPLET_DATA_PLOTS_GUI_VER2P2.M with the given input arguments.
%
%      GEN_DROPLET_DATA_PLOTS_GUI_VER2P2('Property','Value',...) creates a new GEN_DROPLET_DATA_PLOTS_GUI_VER2P2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gen_droplet_data_plots_gui_ver2p2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gen_droplet_data_plots_gui_ver2p2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gen_droplet_data_plots_gui_ver2p2

% Last Modified by GUIDE v2.5 13-Dec-2013 23:06:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gen_droplet_data_plots_gui_ver2p2_OpeningFcn, ...
                   'gui_OutputFcn',  @gen_droplet_data_plots_gui_ver2p2_OutputFcn, ...
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


% --- Executes just before gen_droplet_data_plots_gui_ver2p2 is made visible.
function gen_droplet_data_plots_gui_ver2p2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gen_droplet_data_plots_gui_ver2p2 (see VARARGIN)

% Choose default command line output for gen_droplet_data_plots_gui_ver2p2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gen_droplet_data_plots_gui_ver2p2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

if nargin>3
    data_file=varargin{1};
else
    [data_file,data_file_dir]=uigetfile('Pick the mat file containing the data analysis results');
    % make sure data filename includes complete path to prevent any
    % problems due to directory changing
    data_file=strcat(data_file_dir,data_file);
    load(data_file,'expt_conditions_sample_desc');
    load(data_file,'data_processing_options');    
end

raw_data_file=strcat(data_file(1:regexp(data_file,'.mat')-1),'_raw_data.mat');
%expt_conditions_sample_desc=getappdata(0,'expt_conditions_sample_desc');
%data_processing_options=getappdata(0,'data_processing_options');

channels_to_process=data_processing_options.data_channels;
no_of_channels=length(data_processing_options.data_channels);

data_dir=expt_conditions_sample_desc.data_directory;
% save a copy of sample names in a separate var for shorter code later on 
sample_names=expt_conditions_sample_desc.sample_names; 
extended_sample_names=expt_conditions_sample_desc.extended_sample_names;


%*********************************
% Go to the data directory in case control is at some other directory
cd(expt_conditions_sample_desc.data_directory)


% load all the information that might be necessary for the plots later on
% bin_time_in_sec=expt_conditions_sample_desc.Bin_time_in_msec*0.001;

%************************************************************************************************
[droplet_plotting_options_script_file,plotting_options_dir]=uigetfile('*.m','Pick the droplet plotting options script file');
droplet_plotting_options_script_file=strcat(plotting_options_dir,droplet_plotting_options_script_file)
run(droplet_plotting_options_script_file)

cd(data_dir)
%************************************************************************************************
% Generate a new figure to plot any plots 
% since subplot doesn't work with single set of axes
plots_figure_handle=figure;

% Iterate through all the extended samples to be plotted 
	for extended_sample=1:length(extended_sample_names)
        % Display current sample being processed on the GUI
        %set(handles.current_sample,'String',extended_sample_names{extended_sample});
        sprintf(extended_sample_names{extended_sample})
		% load the sample data from data file
		load(data_file,extended_sample_names{extended_sample});
		eval(['sample_data_struct=' extended_sample_names{extended_sample} ';']);
		clear(extended_sample_names{extended_sample})
		% assign default options to all the plotting options
		plotting_options=default_plotting_options;
		
		% check if there are any sample specific options we need to change
		%***************************************************************************************************
		try 
		% Do further processing only if the user actually provided some sample specific plotting options
			if isfield(sample_plotting_options,extended_sample_names{extended_sample})
				sample_specific_options_struct=strcat('sample_plotting_options.',extended_sample_names{extended_sample});
				sample_specific_fields=get_complete_field_hierarchy(sample_specific_options_struct,...
								eval([sample_specific_options_struct]));
				fields_to_change=regexprep(sample_specific_fields,strcat('sample_plotting_options.',...
						extended_sample_names{extended_sample}),'plotting_options');
				eval([fields_to_change{:} '=' sample_specific_fields{:} ';']);
			end
		catch
			lasterr
		end
		%***************************************************************************************************
			
		%***************************************************************************************************
		% Generate the smd plots if requested here
		if ~isempty(regexp(plotting_options.plot_types,'smd','ignorecase'))
            
			% generate a directory to store the smd_plots
			mkdir('results/smd_plots')
			cd('results/smd_plots')
            fprintf('\n smd_plots \n')
			% Iterate through all the repetitions of data collection for the current sample
			for time_trace=1:length(sample_data_struct.time_trace)                
                fprintf('.')  % command line figure processing progress indicator
                if rem(time_trace,100)==0
                    fprintf('\n')
                end
                bin_time_in_sec=sample_data_struct.time_trace(time_trace).droplet_location_data.bin_time_in_msec*0.001;
                
                
                % Load smd data for the current trace
                load(raw_data_file,[extended_sample_names{extended_sample},'_tt_',num2str(time_trace),'_corrected_channel_data']);
                eval(['smd_data=' extended_sample_names{extended_sample},'_tt_',num2str(time_trace),'_corrected_channel_data;'])
                clear([extended_sample_names{extended_sample},'_tt_',num2str(time_trace),'_corrected_channel_data'])
                
				% Calculate the number of time points for which the data was collected for each channel
				no_of_data_points=size(smd_data,1);

                figure(plots_figure_handle) % make plots figure current just in case control has moved to the main gui. otherwise matlab will start plotting in main gui window
                
                % Iterate through all channels used to collect data
				for channel=1:no_of_channels
					subplot(no_of_channels,1,channel)
						plot([1:no_of_data_points]*bin_time_in_sec,smd_data(:,channel)...
						,color_palette(mod(channel,no_of_colors)));
				
						hold on
						% plot the baseline here if available
                        if strcmpi(data_processing_options.count_peaks,'yes')
                            plot([1,no_of_data_points]*bin_time_in_sec,[1,1]*sample_data_struct.time_trace(time_trace)...
                            .droplet_location_data.baselines(channel),baseline_color);
                        elseif channel==data_processing_options.Droplet_reference_channel
                            plot([1,no_of_data_points]*bin_time_in_sec,[1,1]*sample_data_struct.time_trace(time_trace)...
                            .droplet_location_data.droplet_baseline,baseline_color);
                        end
						% Highlight all the droplets with a different color 
						plot([1:no_of_data_points]*bin_time_in_sec,smd_data(:,channel)...
						.*sample_data_struct.time_trace(time_trace)...
						.droplet_location_data.droplet_location_array,droplet_color);
						
						% Use the axis option only if explicitly specified by the user
						% If absent, matlab autoscaling of the axes will be used	
						try
							axis(eval(['plotting_options.smd.ch' num2str(channel) '.axis_options']));
						catch
						end
						
						% labels must be provided for each axis						
						xlabel(eval(['plotting_options.smd.ch' num2str(channel) '.xlabel']))
						ylabel(eval(['plotting_options.smd.ch' num2str(channel) '.ylabel']))
						title (eval(['plotting_options.smd.ch' num2str(channel) '.title']))

				end
				% Save the current plot in all requested plot formats
				% Filename: sample_name_smd_plot_time_trace1
				for plot_format=1:length(global_plotting_options.save_plot_formats)
					set(plots_figure_handle,'PaperPosition',paperposition);
					saveas(plots_figure_handle,strcat([extended_sample_names{extended_sample} '_smd_plot_time_trace' num2str(time_trace)])...
							,global_plotting_options.save_plot_formats{plot_format});
				end

				% Just use the already plotted smd traces to generate a closeup view of data to judge backgrd
				% level
				for channel=1:no_of_channels

                    figure(plots_figure_handle) % make plots figure current just in case control has moved to the main gui. otherwise matlab will start plotting in main gui window
                    subplot(no_of_channels,1,channel)
						backgrd_axis_options=eval(['plotting_options.smd.backgrd.ch' num2str(channel) ...
												'.axis_options;']);
						if length(backgrd_axis_options)==4
							axis(backgrd_axis_options)
						else
						    if channel==1
                                random_limit_xmin=round(rand*no_of_data_points)*bin_time_in_sec;
						    end	
							if round(random_limit_xmin+backgrd_axis_options(1))<no_of_data_points*bin_time_in_sec
								limit_xmax=random_limit_xmin+backgrd_axis_options(1);
								axis([random_limit_xmin limit_xmax backgrd_axis_options(2:3)])
							else
								limit_xmax=random_limit_xmin-backgrd_axis_options(1);
								axis([limit_xmax random_limit_xmin backgrd_axis_options(2:3)])
							end
						end
							
						title('');
				end

				% Save the current plot in all requested plot formats
				% Filename: sample_name_backgrd_plot_time_trace1
				for plot_format=1:length(global_plotting_options.save_plot_formats)
					set(plots_figure_handle,'PaperPosition',paperposition);
					saveas(plots_figure_handle,strcat([extended_sample_names{extended_sample} '_backgrd_plot_time_trace' num2str(time_trace)])...
							,global_plotting_options.save_plot_formats{plot_format});
				end
							
				% Clear all the plots from the figure to use it again for new plots
				clf;
                clear smd_data
			end	
			cd('../../')
		end
		%***************************************************************************************************

		% Generate droplet inspection figures (figures with a certain number of droplets for each channel)
		if ~isempty(regexp(plotting_options.plot_types,'droplet_inspection','ignorecase'))
			% generate a directory to store the smd_plots
			mkdir('results/droplet_inspection_plots')
			cd('results/droplet_inspection_plots')
            fprintf('\n droplet_inspection_plots \n')
			% Iterate through all the repetitions of data collection for the current sample
			for time_trace=1:length(sample_data_struct.time_trace)
                fprintf('.')  % command line figure processing progress indicator
                if rem(time_trace,100)==0
                    fprintf('\n')
                end
                bin_time_in_sec=sample_data_struct.time_trace(time_trace).droplet_location_data.bin_time_in_msec*0.001;

                % Load smd data for the current trace
                load(raw_data_file,[extended_sample_names{extended_sample},'_tt_',num2str(time_trace),'_corrected_channel_data']);
                eval(['smd_data=' extended_sample_names{extended_sample},'_tt_',num2str(time_trace),'_corrected_channel_data;'])
                clear([extended_sample_names{extended_sample},'_tt_',num2str(time_trace),'_corrected_channel_data'])
                
                % Calculate the number of time points for which the data was collected for each channel
				no_of_data_points=size(smd_data,1);
				% Iterate through all channels used to collect data
				for channel=1:no_of_channels
                    
                    figure(plots_figure_handle) % make plots figure current just in case control has moved to the main gui. otherwise matlab will start plotting in main gui window
                    subplot(no_of_channels,1,channel)

					try
    					droplet_inspect_axis_options=eval(['plotting_options.droplet_inspect.ch' num2str(channel)...
										'.axis_options;']);
                    catch
    					keyboard
					end
					% Generate the X axis limits depending on how many droplets to be plotted
					if length(droplet_inspect_axis_options)==4
						limit_xmin=droplet_inspect_axis_options(1)/bin_time_in_sec;
						limit_xmax=droplet_inspect_axis_options(2)/bin_time_in_sec;
						plot([limit_xmin:limit_xmax]*bin_time_in_sec,smd_data...
										(limit_xmin:limit_xmax,channel),color_palette(mod(channel,no_of_colors)));
						hold on
						% Highlight all the droplets with a different color 
						plot([limit_xmin:limit_xmax]*bin_time_in_sec,smd_data...
						(limit_xmin:limit_xmax,channel).*sample_data_struct...
						.time_trace(time_trace).droplet_location_data.droplet_location_array(limit_xmin:limit_xmax)...
						,droplet_color);

						axis(droplet_inspect_axis_options);
					elseif length(droplet_inspect_axis_options)==3|length(droplet_inspect_axis_options)==1
						no_of_droplets_to_plot=droplet_inspect_axis_options(1);
						total_no_of_droplets=sample_data_struct.time_trace(time_trace).droplet_location_data...
									.total_no_of_droplets; 	
						% Can fulfill this request only if we have enough droplets to begin with
						% else just plot all the data
						if total_no_of_droplets>no_of_droplets_to_plot*2
						    % Find a random droplet number, from which to start plotting 
						  if channel==1  % keep the droplets the same for all the channels
						    random_droplet=round(rand*total_no_of_droplets);	
						  end
						    random_limit_xmin=random_droplet;
						    if round(random_limit_xmin+no_of_droplets_to_plot)<total_no_of_droplets
                                % find out the starting time point for this randomly chosen droplet
    %							size(sample_data_struct.time_trace(time_trace).droplet_location_data...
    %									.droplet_end_loc)
    %							keyboard
                                limit_xmax=sample_data_struct.time_trace(time_trace).droplet_location_data...
                                        .droplet_end_loc(random_limit_xmin+no_of_droplets_to_plot);

                                random_limit_xmin=sample_data_struct.time_trace(time_trace).droplet_location_data...
                                        .droplet_start_loc(random_limit_xmin);

                                plot([random_limit_xmin:limit_xmax]*bin_time_in_sec,smd_data...
                                    (random_limit_xmin:limit_xmax,channel),color_palette(mod(channel,no_of_colors)));

                                hold on
                                % Highlight all the droplets with a different color 
                                plot([random_limit_xmin:limit_xmax]*bin_time_in_sec,smd_data...
                                        (random_limit_xmin:limit_xmax,channel).*sample_data_struct...
                                    .time_trace(time_trace).droplet_location_data.droplet_location_array...
                                    (random_limit_xmin:limit_xmax),droplet_color);

                                if length(droplet_inspect_axis_options)==3	
                                    axis([[random_limit_xmin limit_xmax]*bin_time_in_sec,...
                                        droplet_inspect_axis_options(2:3)]);
                                end
						    else
                                try
                                limit_xmax=sample_data_struct.time_trace(time_trace).droplet_location_data...
                                        .droplet_start_loc(random_limit_xmin-no_of_droplets_to_plot);
                                catch
                                keyboard
                                end
                                random_limit_xmin=sample_data_struct.time_trace(time_trace).droplet_location_data...
                                        .droplet_end_loc(random_limit_xmin);

                                plot([limit_xmax:random_limit_xmin]*bin_time_in_sec,smd_data...
                                    (limit_xmax:random_limit_xmin,channel),color_palette(mod(channel,no_of_colors)));
                                hold on
                                % Highlight all the droplets with a different color 
                                plot([limit_xmax:random_limit_xmin]*bin_time_in_sec,smd_data...
                                        (limit_xmax:random_limit_xmin,channel).*sample_data_struct...
                                    .time_trace(time_trace).droplet_location_data.droplet_location_array...
                                    (limit_xmax:random_limit_xmin),droplet_color);

                                if length(droplet_inspect_axis_options)==3	
                                    axis([[limit_xmax random_limit_xmin]*bin_time_in_sec,...
                                        droplet_inspect_axis_options(2:3)]);
                                end
						    end
						else
						    plot([1:no_of_data_points]*bin_time_in_sec,smd_data(:,channel),color_palette(mod(channel,no_of_colors)));
				
						    hold on
					            % Highlight all the droplets with a different color 
						    plot([1:no_of_data_points]*bin_time_in_sec,smd_data...
						    (:,channel).*sample_data_struct.time_trace(time_trace)...
						    .droplet_location_data.droplet_location_array,droplet_color);
						end	
					end
						
					% labels must be provided for each axis						
					xlabel(eval(['plotting_options.droplet_inspect.ch' num2str(channel) '.xlabel']))
					ylabel(eval(['plotting_options.droplet_inspect.ch' num2str(channel) '.ylabel']))
					title (eval(['plotting_options.droplet_inspect.ch' num2str(channel) '.title']))
				end
				% Save the current plot in all requested plot formats
				% Filename: sample_name_smd_plot_time_trace1
				for plot_format=1:length(global_plotting_options.save_plot_formats)
					set(plots_figure_handle,'PaperPosition',paperposition);
					saveas(plots_figure_handle,strcat([extended_sample_names{extended_sample} '_droplet_inspect_plot_time_trace' num2str(time_trace)])...
							,global_plotting_options.save_plot_formats{plot_format});
				end

				% Clear all the plots from the figure to use it again for new plots
				clf;
                clear smd_data
			end	
			cd('../../')
		end
		%***************************************************************************************************
		
		%***************************************************************************************************
		% Generate droplet width histograms here if requested
		if ~isempty(regexp(plotting_options.plot_types,'droplet_width_hist','ignorecase'))
			% generate a directory to store the smd_plots
			mkdir('results/droplet_width_histograms')
			cd('results/droplet_width_histograms')
            fprintf('\n droplet_width_histograms \n')
			
			% Iterate through all the repetitions of data collection for the current sample	
            combined_droplet_width_data=[];
			for time_trace=1:length(sample_data_struct.time_trace)
                % Collect droplet width data from all traces for this
                % extended sample into one array
                combined_droplet_width_data=[combined_droplet_width_data;sample_data_struct.time_trace(time_trace).droplet_location_data.droplet_width_data];
            end    
            
            total_no_of_drops=length(combined_droplet_width_data);
            drops_per_width_plot=plotting_options.droplet_width_hist.drops_per_plot;
            no_of_width_plots=floor(total_no_of_drops/drops_per_width_plot);
            % if the total number of drops for sample is smaller than the
            % droplets per width plot then plot all the drops
            if no_of_width_plots==0
                no_of_width_plots=1;
            end
            
            for width_plot=1:no_of_width_plots                

                figure(plots_figure_handle) % make plots figure current just in case control has moved to the main gui. otherwise matlab will start plotting in main gui window
                fprintf('.')  % command line figure processing progress indicator
                if rem(width_plot,50)==0
                    fprintf('\n')
                end
                channel=data_processing_options.Droplet_reference_channel;

                if no_of_width_plots>1
                    try 
                        histfit(combined_droplet_width_data((width_plot-1)*drops_per_width_plot+1:width_plot*drops_per_width_plot),...
                            plotting_options.droplet_width_hist.nbins_or_range);
                    catch
                        histfit(combined_droplet_width_data((width_plot-1)*drops_per_width_plot+1:width_plot*drops_per_width_plot));
                    end
                else
                    try 
                        histfit(combined_droplet_width_data,...
                            plotting_options.droplet_width_hist.nbins_or_range);
                    catch
                        histfit(combined_droplet_width_data);
                    end                    
                end
				
				set(findobj(gca,'Type','patch'),'FaceColor',color_palette(mod(channel,no_of_colors)));
				xlabel(plotting_options.droplet_width_hist.xlabel)
				ylabel(plotting_options.droplet_width_hist.ylabel)
				title(plotting_options.droplet_width_hist.title)

				% Save the current plot in all requested plot formats
				% Filename: sample_name_burst_width_hist_combined_time_trace1
				for plot_format=1:length(global_plotting_options.save_plot_formats)
					set(plots_figure_handle,'PaperPosition',paperposition);
					saveas(plots_figure_handle,strcat([extended_sample_names{extended_sample} '_droplet_width_hist_plot' ...
						num2str(width_plot)]),global_plotting_options.save_plot_formats{plot_format});
				end
				% Clear all the plots from the figure to use it again for new plots
				clf;
			end	
			cd('../../')
            clear combined_droplet_width_data
		end
		%***************************************************************************************************

		%***************************************************************************************************
		% Generate droplet burst energy histograms here if requested
		if ~isempty(regexp(plotting_options.plot_types,'droplet_burst_energy_hist','ignorecase'))
			% generate a directory to store the smd_plots
			mkdir('results/droplet_burst_energy_histograms')
			cd('results/droplet_burst_energy_histograms')
            fprintf('\n droplet_burst_energy_histograms \n')
            
			% Iterate through all the repetitions of data collection for the current sample	
            combined_droplet_burst_energy_data=[];
            for time_trace=1:length(sample_data_struct.time_trace)
                % Collect droplet burst energy data from all traces for this
                % extended sample into one array
                combined_droplet_burst_energy_data=[combined_droplet_burst_energy_data;sample_data_struct.time_trace(time_trace).droplet_location_data.droplet_burst_energy];
            end
            
            total_no_of_drops=size(combined_droplet_burst_energy_data,1);
            drops_per_burst_energy_plot=plotting_options.droplet_burst_energy_hist.drops_per_plot;
            no_of_burst_energy_plots=floor(total_no_of_drops/drops_per_burst_energy_plot);
            % if the total number of drops for sample is smaller than the
            % droplets per width plot then plot all the drops
            if no_of_burst_energy_plots==0
                no_of_burst_energy_plots=1;
            end
            
            for burst_energy_plot=1:no_of_burst_energy_plots
                figure(plots_figure_handle) % make plots figure current just in case control has moved to the main gui. otherwise matlab will start plotting in main gui window
                fprintf('.') % command line figure processing progress indicator
                if rem(burst_energy_plot,100)==0
                    fprintf('\n')
                end    
                
				
				if ~isempty(regexp(plotting_options.plot_types,'droplet_burst_energy_hist_combined','ignorecase'))	
					% Iterate through all channels used to collect data
					for channel=1:no_of_channels
						
						subplot(no_of_channels,1,channel)	

                            if no_of_burst_energy_plots>1
                                % Use the number of bins option only if explicitly specified by the user	
                                % If absent, matlab default for number of bins will be used	
                                try
                                    hist(combined_droplet_burst_energy_data((burst_energy_plot-1)*drops_per_burst_energy_plot+1:burst_energy_plot*drops_per_burst_energy_plot,channel),...
                                    eval(['plotting_options.droplet_burst_energy_hist.ch' num2str(channel) '.nbins_or_range;']));

                                catch
                                    hist(combined_droplet_burst_energy_data((burst_energy_plot-1)*drops_per_burst_energy_plot+1:burst_energy_plot*drops_per_burst_energy_plot,channel));
                                end
                            else
                                try
                                    hist(combined_droplet_burst_energy_data(:,channel),eval(['plotting_options.droplet_burst_energy_hist.ch' num2str(channel) '.nbins_or_range;']));

                                catch
                                    hist(combined_droplet_burst_energy_data(:,channel));
                                end
                                
                            end

							set(findobj(gca,'Type','patch'),'FaceColor',color_palette(mod(channel,no_of_colors)));
	
						xlabel(eval(['plotting_options.droplet_burst_energy_hist.ch' num2str(channel) '.xlabel']))
						ylabel(eval(['plotting_options.droplet_burst_energy_hist.ch' num2str(channel) '.ylabel']))
						title (eval(['plotting_options.droplet_burst_energy_hist.ch' num2str(channel) '.title']))

					end
					% Save the current plot in all requested plot formats
					% Filename: sample_name_burst_energy_hist_combined_time_trace1
					for plot_format=1:length(global_plotting_options.save_plot_formats)
						set(plots_figure_handle,'PaperPosition',paperposition);
						saveas(plots_figure_handle,strcat([extended_sample_names{extended_sample} '_droplet_burst_energy_hist_combined_plot' ...
							num2str(burst_energy_plot)]),global_plotting_options.save_plot_formats{plot_format});
					end
					% Clear all the plots from the figure to use it again for new plots
					clf;
				end


				if ~isempty(regexp(plotting_options.plot_types,'droplet_burst_energy_hist_sep','ignorecase'))	
					% Iterate through all channels used to collect data
					for channel=1:no_of_channels	
                        
                        figure(plots_figure_handle) % make plots figure current just in case control has moved to the main gui. otherwise matlab will start plotting in main gui window	
                        if no_of_burst_energy_plots>1
                            % Use the number of bins option only if explicitly specified by the user	
                            % If absent, matlab default for number of bins will be used	
                            try
                                hist(combined_droplet_burst_energy_data((burst_energy_plot-1)*drops_per_burst_energy_plot+1:burst_energy_plot*drops_per_burst_energy_plot,channel),...
                                eval(['plotting_options.droplet_burst_energy_hist.ch' num2str(channel) '.nbins_or_range;']));

                            catch
                                hist(combined_droplet_burst_energy_data((burst_energy_plot-1)*drops_per_burst_energy_plot+1:burst_energy_plot*drops_per_burst_energy_plot,channel));
                            end
                        else
                            try
                                hist(combined_droplet_burst_energy_data(:,channel),eval(['plotting_options.droplet_burst_energy_hist.ch' num2str(channel) '.nbins_or_range;']));

                            catch
                                hist(combined_droplet_burst_energy_data(:,channel));
                            end

                        end

						set(findobj(gca,'Type','patch'),'FaceColor',color_palette(mod(channel,no_of_colors)));
	
						xlabel(eval(['plotting_options.droplet_burst_energy_hist.ch' num2str(channel) '.xlabel']))
						ylabel(eval(['plotting_options.droplet_burst_energy_hist.ch' num2str(channel) '.ylabel']))
						title (eval(['plotting_options.droplet_burst_energy_hist.ch' num2str(channel) '.title']))
					
						% Save the current plot in all requested plot formats
						% Filename: sample_name_burst_energy_hist_time_trace1_ch2
						for plot_format=1:length(plotting_options.save_plot_formats)
							set(plots_figure_handle,'PaperPosition',paperposition);
							saveas(plots_figure_handle,strcat([extended_sample_names{extended_sample} '_droplet_burst_energy_hist_plot' ...
							num2str(burst_energy_plot) '_ch' num2str(channel)]),plotting_options...
							.save_plot_formats{plot_format});
						end
						% Clear all the plots from the figure to use it again for new plots
						clf;
					end
				end
			end	
			cd('../../')
		end
		%***************************************************************************************************
        
        %***************************************************************************************************
		% Generate average droplet height histograms here if requested
		if ~isempty(regexp(plotting_options.plot_types,'droplet_avg_height_hist','ignorecase'))
			% generate a directory to store the smd_plots
			mkdir('results/droplet_avg_height_histograms')
			cd('results/droplet_avg_height_histograms')
            fprintf('\n droplet_avg_height_histograms \n')

            % Iterate through all the repetitions of data collection for the current sample	
            combined_droplet_avg_height_data=[];
            for time_trace=1:length(sample_data_struct.time_trace)
                % Collect droplet burst energy data from all traces for this
                % extended sample into one array
                combined_droplet_avg_height_data=[combined_droplet_avg_height_data;sample_data_struct.time_trace(time_trace).droplet_location_data.avg_drop_height];
            end
            
            total_no_of_drops=size(combined_droplet_avg_height_data,1);
            drops_per_avg_height_plot=plotting_options.droplet_avg_height_hist.drops_per_plot;
            no_of_avg_height_plots=floor(total_no_of_drops/drops_per_avg_height_plot);
            % if the total number of drops for sample is smaller than the
            % droplets per plot then plot all the drops
            if no_of_avg_height_plots==0
                no_of_avg_height_plots=1;
            end
            
            for avg_height_plot=1:no_of_avg_height_plots                

                figure(plots_figure_handle) % make plots figure current just in case control has moved to the main gui. otherwise matlab will start plotting in main gui window
                fprintf('.') % command line figure processing progress indicator
                if rem(avg_height_plot,100)==0
                    fprintf('\n')
                end
				
				if ~isempty(regexp(plotting_options.plot_types,'droplet_avg_height_hist_combined','ignorecase'))	
					% Iterate through all channels used to collect data
					for channel=1:no_of_channels
						
						subplot(no_of_channels,1,channel)	
							
                            if no_of_avg_height_plots>1
                                % Use the number of bins option only if explicitly specified by the user	
                                % If absent, matlab default for number of bins will be used	
                                try
                                    hist(combined_droplet_avg_height_data((avg_height_plot-1)*drops_per_avg_height_plot+1:avg_height_plot*drops_per_avg_height_plot,channel),...
                                    eval(['plotting_options.droplet_burst_energy_hist.ch' num2str(channel) '.nbins_or_range;']));

                                catch
                                    hist(combined_droplet_avg_height_data((avg_height_plot-1)*drops_per_avg_height_plot+1:avg_height_plot*drops_per_avg_height_plot,channel));
                                end
                            else
                                try
                                    hist(combined_droplet_avg_height_data(:,channel),eval(['plotting_options.droplet_burst_energy_hist.ch' num2str(channel) '.nbins_or_range;']));

                                catch
                                    hist(combined_droplet_avg_height_data(:,channel));
                                end
                                
                            end
                        

							set(findobj(gca,'Type','patch'),'FaceColor',color_palette(mod(channel,no_of_colors)));
	
                            xlabel(eval(['plotting_options.droplet_avg_height_hist.ch' num2str(channel) '.xlabel']))
                            ylabel(eval(['plotting_options.droplet_avg_height_hist.ch' num2str(channel) '.ylabel']))
                            title (eval(['plotting_options.droplet_avg_height_hist.ch' num2str(channel) '.title']))

					end
					% Save the current plot in all requested plot formats
					% Filename: sample_name_burst_energy_hist_combined_time_trace1
					for plot_format=1:length(global_plotting_options.save_plot_formats)
						set(plots_figure_handle,'PaperPosition',paperposition);
						saveas(plots_figure_handle,strcat([extended_sample_names{extended_sample} '_droplet_avg_height_hist_combined_plot' ...
							num2str(avg_height_plot)]),global_plotting_options.save_plot_formats{plot_format});
					end
					% Clear all the plots from the figure to use it again for new plots
					clf;
				end


				if ~isempty(regexp(plotting_options.plot_types,'droplet_avg_height_hist_sep','ignorecase'))	
					% Iterate through all channels used to collect data
					for channel=1:no_of_channels	
                        figure(plots_figure_handle) % make plots figure current just in case control has moved to the main gui. otherwise matlab will start plotting in main gui window	
                        if no_of_avg_height_plots>1
                            % Use the number of bins option only if explicitly specified by the user	
                            % If absent, matlab default for number of bins will be used	
                            try
                                hist(combined_droplet_avg_height_data((avg_height_plot-1)*drops_per_avg_height_plot+1:avg_height_plot*drops_per_avg_height_plot,channel),...
                                eval(['plotting_options.droplet_avg_height_hist.ch' num2str(channel) '.nbins_or_range;']));

                            catch
                                hist(combined_droplet_avg_height_data((avg_height_plot-1)*drops_per_avg_height_plot+1:avg_height_plot*drops_per_avg_height_plot,channel));
                            end
                        else
                            try
                                hist(combined_droplet_avg_height_data(:,channel),eval(['plotting_options.droplet_avg_height_hist.ch' num2str(channel) '.nbins_or_range;']));

                            catch
                                hist(combined_droplet_avg_height_data(:,channel));
                            end

                        end

						set(findobj(gca,'Type','patch'),'FaceColor',color_palette(mod(channel,no_of_colors)));
	
						xlabel(eval(['plotting_options.droplet_avg_height_hist.ch' num2str(channel) '.xlabel']))
						ylabel(eval(['plotting_options.droplet_avg_height_hist.ch' num2str(channel) '.ylabel']))
						title (eval(['plotting_options.droplet_avg_height_hist.ch' num2str(channel) '.title']))
					
						% Save the current plot in all requested plot formats
						% Filename: sample_name_burst_energy_hist_time_trace1_ch2
						for plot_format=1:length(plotting_options.save_plot_formats)
							set(plots_figure_handle,'PaperPosition',paperposition);
							saveas(plots_figure_handle,strcat([extended_sample_names{extended_sample} '_droplet_avg_height_hist_plot' ...
							num2str(avg_height_plot) '_ch' num2str(channel)]),plotting_options...
							.save_plot_formats{plot_format});
						end
						% Clear all the plots from the figure to use it again for new plots
						clf;
					end
				end
			end	
			cd('../../')
		end
		%***************************************************************************************************
        
        
        %***************************************************************************************************
		% Generate droplet height (without averaging) histograms here if requested
		if ~isempty(regexp(plotting_options.plot_types,'droplet_height_hist','ignorecase'))
			% generate a directory to store the smd_plots
			mkdir('results/droplet_height_histograms')
			cd('results/droplet_height_histograms')
            fprintf('\n droplet_height_histograms \n')

            % Iterate through all the repetitions of data collection for the current sample	
            combined_droplet_height_data=[];
            for time_trace=1:length(sample_data_struct.time_trace)
                % Collect droplet height data from all traces for this
                % extended sample into one array
                combined_droplet_height_data=[combined_droplet_height_data;sample_data_struct.time_trace(time_trace).droplet_location_data.max_drop_height];
            end
            
            total_no_of_drops=size(combined_droplet_height_data,1);
            drops_per_height_plot=plotting_options.droplet_height_hist.drops_per_plot;
            no_of_height_plots=floor(total_no_of_drops/drops_per_height_plot);
            % if the total number of drops for sample is smaller than the
            % droplets per plot then plot all the drops
            if no_of_height_plots==0
                no_of_height_plots=1;
            end
            
            for height_plot=1:no_of_height_plots                

                figure(plots_figure_handle) % make plots figure current just in case control has moved to the main gui. otherwise matlab will start plotting in main gui window            
                fprintf('.') % command line figure processing progress indicator
                if rem(height_plot,100)==0
                    fprintf('\n')
                end

				
				if ~isempty(regexp(plotting_options.plot_types,'droplet_height_hist_combined','ignorecase'))	
					% Iterate through all channels used to collect data
					for channel=1:no_of_channels
						
						subplot(no_of_channels,1,channel)	
							if no_of_height_plots>1
                                % Use the number of bins option only if explicitly specified by the user	
                                % If absent, matlab default for number of bins will be used	
                                try
                                    hist(combined_droplet_height_data((height_plot-1)*drops_per_height_plot+1:height_plot*drops_per_height_plot,channel),...
                                    eval(['plotting_options.droplet_height_hist.ch' num2str(channel) '.nbins_or_range;']));

                                catch
                                    hist(combined_droplet_height_data((height_plot-1)*drops_per_height_plot+1:height_plot*drops_per_height_plot,channel));
                                end
                            else
                                try
                                    hist(combined_droplet_height_data(:,channel),eval(['plotting_options.droplet_height_hist.ch' num2str(channel) '.nbins_or_range;']));

                                catch
                                    hist(combined_droplet_height_data(:,channel));
                                end
                                
                            end

						set(findobj(gca,'Type','patch'),'FaceColor',color_palette(mod(channel,no_of_colors)));
	
						xlabel(eval(['plotting_options.droplet_height_hist.ch' num2str(channel) '.xlabel']))
						ylabel(eval(['plotting_options.droplet_height_hist.ch' num2str(channel) '.ylabel']))
						title (eval(['plotting_options.droplet_height_hist.ch' num2str(channel) '.title']))

					end
					% Save the current plot in all requested plot formats
					% Filename: sample_name_burst_energy_hist_combined_time_trace1
					for plot_format=1:length(global_plotting_options.save_plot_formats)
						set(plots_figure_handle,'PaperPosition',paperposition);
						saveas(plots_figure_handle,strcat([extended_sample_names{extended_sample} '_droplet_height_hist_combined_plot' ...
							num2str(height_plot)]),global_plotting_options.save_plot_formats{plot_format});
					end
					% Clear all the plots from the figure to use it again for new plots
					clf;
				end


				if ~isempty(regexp(plotting_options.plot_types,'droplet_height_hist_sep','ignorecase'))	
					% Iterate through all channels used to collect data
					for channel=1:no_of_channels	
                        
                        figure(plots_figure_handle) % make plots figure current just in case control has moved to the main gui. otherwise matlab will start plotting in main gui window	        
                        if no_of_height_plots>1
                            % Use the number of bins option only if explicitly specified by the user	
                            % If absent, matlab default for number of bins will be used	
                            try
                                hist(combined_droplet_height_data((height_plot-1)*drops_per_height_plot+1:height_plot*drops_per_height_plot,channel),...
                                eval(['plotting_options.droplet_height_hist.ch' num2str(channel) '.nbins_or_range;']));

                            catch
                                hist(combined_droplet_height_data((height_plot-1)*drops_per_height_plot+1:height_plot*drops_per_height_plot,channel));
                            end
                        else
                            try
                                hist(combined_droplet_height_data(:,channel),eval(['plotting_options.droplet_height_hist.ch' num2str(channel) '.nbins_or_range;']));

                            catch
                                hist(combined_droplet_height_data(:,channel));
                            end

                        end
						set(findobj(gca,'Type','patch'),'FaceColor',color_palette(mod(channel,no_of_colors)));
	
						xlabel(eval(['plotting_options.droplet_height_hist.ch' num2str(channel) '.xlabel']))
						ylabel(eval(['plotting_options.droplet_height_hist.ch' num2str(channel) '.ylabel']))
						title (eval(['plotting_options.droplet_height_hist.ch' num2str(channel) '.title']))
					
						% Save the current plot in all requested plot formats
						% Filename: sample_name_burst_energy_hist_time_trace1_ch2
						for plot_format=1:length(plotting_options.save_plot_formats)
							set(plots_figure_handle,'PaperPosition',paperposition);
							saveas(plots_figure_handle,strcat([extended_sample_names{extended_sample} '_droplet_height_hist_plot' ...
							num2str(height_plot) '_ch' num2str(channel)]),plotting_options...
							.save_plot_formats{plot_format});
						end
						% Clear all the plots from the figure to use it again for new plots
						clf;
					end
				end
			end	
			cd('../../')
		end
		%***************************************************************************************************
        
        
        %***************************************************************************************************
		% Generate droplet scatter plots here if requested
		if ~isempty(regexp(plotting_options.plot_types,'droplet_scatter_plots','ignorecase'))
			% generate a directory to store the smd_plots
			mkdir('results/droplet_scatter_plots')
			cd('results/droplet_scatter_plots')
			% Iterate through all the repetitions of data collection for the current sample	
            avg_drop_height=[];
            drop_width=[];
            drop_time=[];
			for time_trace=1:length(sample_data_struct.time_trace)
                % collect average drop height and droplet width from all droplets in all
                % traces for this sample in a single var
                avg_drop_height=[avg_drop_height;sample_data_struct.time_trace(time_trace).droplet_location_data.avg_drop_height];
                drop_width=[drop_width;sample_data_struct.time_trace(time_trace).droplet_location_data.droplet_width_data];
                % Time to use for the scatter plots is the starting time
                % point of each droplet
                drop_time=[drop_time;sample_data_struct.time_trace(time_trace).droplet_location_data.timeline(sample_data_struct.time_trace(time_trace).droplet_location_data.droplet_start_loc)];
            end
            
            total_no_of_drops=length(avg_drop_height)
            
            plotting_options.droplet_scatter_plots.marker

            figure(plots_figure_handle) % make plots figure current just in case control has moved to the main gui. otherwise matlab will start plotting in main gui window            
            if no_of_channels==1
                % Useless plot but will be easier to manage reports this
                % way
                plot(avg_drop_height,plotting_options.droplet_scatter_plots.marker)
                ylabel(plotting_options.droplet_scatter_plots.scatter_only_plot.xlabel);
            elseif no_of_channels==2
                plot(avg_drop_height(:,1),avg_drop_height(:,2),plotting_options.droplet_scatter_plots.marker);
                xlabel(plotting_options.droplet_scatter_plots.scatter_only_plot.xlabel);
                ylabel(plotting_options.droplet_scatter_plots.scatter_only_plot.ylabel);                                
            elseif no_of_channels==3
                plot3(avg_drop_height(:,1),avg_drop_height(:,2),avg_drop_height(:,3),plotting_options.droplet_scatter_plots.marker);
                xlabel(plotting_options.droplet_scatter_plots.scatter_only_plot.xlabel);
                ylabel(plotting_options.droplet_scatter_plots.scatter_only_plot.ylabel);                                
                zlabel(plotting_options.droplet_scatter_plots.scatter_only_plot.zlabel);                                                
            end
            
            % this will be used for the distribution plots below
            hold on
            
            % Save the current plot in all requested plot formats
            % Filename: sample_name_burst_energy_hist_combined_time_trace1
            for plot_format=1:length(global_plotting_options.save_plot_formats)
                set(plots_figure_handle,'PaperPosition',paperposition);
                saveas(plots_figure_handle,strcat([extended_sample_names{extended_sample} '_droplet_scatter_only_plot']),global_plotting_options.save_plot_formats{plot_format});
            end

            
            
            
            if no_of_channels==2
                
                % Cluster the average drop height data here and plot using 2,3 and 4 clusters
                % Do this only for two channel data
                                
                no_of_clusters=default_plotting_options.droplet_scatter_plots.no_of_clusters;
            
                % Find the channel which contains assay output data, to use
                % for 1D fitting
                data_channel=find(channels_to_process~=data_processing_options.Droplet_reference_channel);
                
                
                for clustergroup=1:length(no_of_clusters)
                    fitobj=gmdistribution.fit(avg_drop_height,no_of_clusters(clustergroup));
                    
                    %obtain 1D datafit for the assay output channel only
                    %i.e. ignore variation in the indicator dye channel
                    
                    fitobj1D=gmdistribution.fit(avg_drop_height(:,data_channel),no_of_clusters(clustergroup));
                    
                    
                    % Obtain current X and Y limits for the scatter plot
                    current_xlim=xlim;
                    current_ylim=ylim;
                    
                    contourobj=ezcontour(@(x,y)pdf(fitobj,[x,y]),[current_xlim(1),current_xlim(2),current_ylim(1),current_ylim(2)]);
                    xlim('auto')
                    ylim('auto')
                    [clusters(clustergroup).IDX,clusters(clustergroup).NLOGL,clusters(clustergroup).POST,clusters(clustergroup).LOGPDF] = cluster(fitobj,avg_drop_height);
                    clusters(clustergroup).datafit=fitobj;                                        
                    clusters(clustergroup).datafit1D=fitobj1D
                    [clusters(clustergroup).IDX1D,clusters(clustergroup).NLOGL1D,clusters(clustergroup).POST1D,clusters(clustergroup).LOGPDF1D] = cluster(fitobj1D,avg_drop_height(:,data_channel));
                    clusters(clustergroup).no_of_clusters=no_of_clusters(clustergroup);
                    
                    title(['Log likelihood:' num2str(clusters(clustergroup).NLOGL)])
                     
                    % Save the current plot in all requested plot formats
                    % Filename: sample_name_scatter_countour_X
                    for plot_format=1:length(global_plotting_options.save_plot_formats)
                        set(plots_figure_handle,'PaperPosition',paperposition);
                        saveas(plots_figure_handle,strcat([extended_sample_names{extended_sample} '_scatter_contour_' num2str(no_of_clusters(clustergroup))]),global_plotting_options.save_plot_formats{plot_format});
                    end
                    
                    delete(contourobj);                    
                end
                
                clusterplot_handle=figure;
                
                % Plot 2D clusters in scatter plots
                for clustergroup=1:length(no_of_clusters)
                    titlestring='';
                    for mycluster=1:no_of_clusters(clustergroup)
                        myclusteridx=[clusters(clustergroup).IDX==mycluster];
                        plot(avg_drop_height(myclusteridx,1),avg_drop_height(myclusteridx,2),[color_palette(mod(mycluster,no_of_colors)) plotting_options.droplet_scatter_plots.marker]);
                        hold on
                        titlestring=[titlestring 'cluster' num2str(mycluster) color_palette(mod(mycluster,no_of_colors)) ':' num2str(length(find(myclusteridx))) ', '];
                        clear myclusteridx
                    end
                    
                    % Show number of drops in each cluster in the title of
                    % the figure
                    title(titlestring)
                        
                    % Save the current plot in all requested plot formats
                    % Filename: sample_name_scatter_countour_X
                    for plot_format=1:length(global_plotting_options.save_plot_formats)
                        set(clusterplot_handle,'PaperPosition',paperposition);
                        saveas(clusterplot_handle,strcat([extended_sample_names{extended_sample} '_cluster_' num2str(no_of_clusters(clustergroup))]),global_plotting_options.save_plot_formats{plot_format});
                    end
                    % Clear all the plots from the figure to use it again for new plots
                    clf;    
                end
                
                
                
                
                % Plot 1D clusters in histograms
                % First find the bin locations from the average droplet height
                % histogram. 
                [~,bin_locations]=hist(avg_drop_height(:,data_channel),eval(['plotting_options.droplet_height_hist.ch' num2str(data_channel) '.nbins_or_range;']));
                
                for clustergroup=1:length(no_of_clusters)
                    titlestring='';
                    for mycluster=1:no_of_clusters(clustergroup)
                        myclusteridx=[clusters(clustergroup).IDX1D==mycluster];
                        hist(avg_drop_height(myclusteridx,data_channel),bin_locations)
                        
                        % Note that findobj will find handles to all
                        % histograms overlaid on top of each other. The
                        % first handles in the handles array is the handle
                        % to the last histogram plotted. 
                        hist_handle=findobj(gca,'Type','patch');
                        
                        set(hist_handle(1),'FaceColor',color_palette(mod(mycluster,no_of_colors)),'FaceAlpha',0.5);                        
                        hold on
                        titlestring=[titlestring 'cluster' num2str(mycluster) color_palette(mod(mycluster,no_of_colors)) ':' num2str(length(find(myclusteridx))) ', '];
                        clear myclusteridx
                    end
                    
                    titlestring=[titlestring '  negative Log likelihood: ' num2str(clusters(clustergroup).NLOGL1D)];
                    
                    % Show number of drops in each cluster in the title of
                    % the figure
                    title(titlestring)
                        
                    % Save the current plot in all requested plot formats
                    % Filename: sample_name_scatter_countour_X
                    for plot_format=1:length(global_plotting_options.save_plot_formats)
                        set(clusterplot_handle,'PaperPosition',paperposition);
                        saveas(clusterplot_handle,strcat([extended_sample_names{extended_sample} '_1Dcluster_' num2str(no_of_clusters(clustergroup))]),global_plotting_options.save_plot_formats{plot_format});
                    end
                    % Clear all the plots from the figure to use it again for new plots
                    clf;
                end
                
                
                
                
                % Plot histograms of droplet data with thresholding
                thresholds_to_analyze=default_plotting_options.droplet_scatter_plots.thresholds;
                threshold_data=[];
                
                for threshold=1:length(thresholds_to_analyze)
                    titlestring='';
                    threshold_data(threshold).thresh_value=thresholds_to_analyze(threshold);
                    
                    for mycluster=1:2
                        if mycluster==1
                            myclusteridx=[avg_drop_height(:,data_channel)<=thresholds_to_analyze(threshold)];
                            threshold_data(threshold).neg_drop_count=length(find(myclusteridx));
                        elseif mycluster==2
                            myclusteridx=[avg_drop_height(:,data_channel)>thresholds_to_analyze(threshold)];
                            threshold_data(threshold).pos_drop_count=length(find(myclusteridx));
                        end
                        
                        hist(avg_drop_height(myclusteridx,data_channel),bin_locations)
                                                
                        % Note that findobj will find handles to all
                        % histograms overlaid on top of each other. The
                        % first handles in the handles array is the handle
                        % to the last histogram plotted. 
                        hist_handle=findobj(gca,'Type','patch');
                        
                        set(hist_handle(1),'FaceColor',color_palette(mod(mycluster,no_of_colors)),'FaceAlpha',0.5);                        
                        hold on
                        titlestring=[titlestring 'cluster' num2str(mycluster) color_palette(mod(mycluster,no_of_colors)) ':' num2str(length(find(myclusteridx))) ', '];
                        clear myclusteridx
                    end
                    
                    titlestring=[titlestring '  threshold: ' num2str(thresholds_to_analyze(threshold))];
                    
                    % Show number of drops in each cluster in the title of
                    % the figure
                    title(titlestring)
                        
                    % Save the current plot in all requested plot formats
                    % Filename: sample_name_scatter_countour_X
                    for plot_format=1:length(global_plotting_options.save_plot_formats)
                        set(clusterplot_handle,'PaperPosition',paperposition);
                        saveas(clusterplot_handle,strcat([extended_sample_names{extended_sample} '_thresh_' num2str(thresholds_to_analyze(threshold))]),global_plotting_options.save_plot_formats{plot_format});
                    end
                    % Clear all the plots from the figure to use it again for new plots
                    clf;
                end
                
                
                
                eval([extended_sample_names{extended_sample} '_clusterdata.clusters=clusters;'])                 
                eval([extended_sample_names{extended_sample} '_threshold_data=threshold_data;'])                 
                close(clusterplot_handle)
                
                
                % Save all the data in a new mat file
                stripped_data_filename=strtok(data_file,'.');
                new_filename=[stripped_data_filename '_clusterdata.mat'];
                if exist(new_filename,'file')
                    save(new_filename,[extended_sample_names{extended_sample} '_clusterdata'],'-append')
                    save(new_filename,[extended_sample_names{extended_sample} '_threshold_data'],'-append')
                else
                    save(new_filename,[extended_sample_names{extended_sample} '_clusterdata'])
                    save(new_filename,[extended_sample_names{extended_sample} '_threshold_data'],'-append')
                end
                
                clear('clusters',[extended_sample_names{extended_sample} '_clusterdata'],[extended_sample_names{extended_sample} '_threshold_data'])
                
            end
            
            % Clear all the plots from the figure to use it again for new plots
            clf;            
            
            figure(plots_figure_handle) % make plots figure current just in case control has moved to the main gui. otherwise matlab will start plotting in main gui window            
            
            for channel=1:no_of_channels
                subplot(no_of_channels,1,channel)
                plot(drop_width,avg_drop_height(:,channel),strcat(color_palette(mod(channel,no_of_colors)),plotting_options.droplet_scatter_plots.marker))
                xlabel(eval(['plotting_options.droplet_scatter_plots.width_vs_height_plot.ch' num2str(channel) '.xlabel']))
                ylabel(eval(['plotting_options.droplet_scatter_plots.width_vs_height_plot.ch' num2str(channel) '.ylabel']))
                title(eval(['plotting_options.droplet_scatter_plots.width_vs_height_plot.ch' num2str(channel) '.title']))
            end
            
            % Save the current plot in all requested plot formats
            % Filename: sample_name_burst_energy_hist_combined_time_trace1
            for plot_format=1:length(global_plotting_options.save_plot_formats)
                set(plots_figure_handle,'PaperPosition',paperposition);
                saveas(plots_figure_handle,strcat([extended_sample_names{extended_sample} '_droplet_width_vs_height_plot' ...
                    ]),global_plotting_options.save_plot_formats{plot_format});
            end
            % Clear all the plots from the figure to use it again for new plots
            clf;

            
            
            drops_per_scatter_time_plot=plotting_options.droplet_scatter_plots.scatter_time_plot.no_of_drops;
            
            number_of_scatter_time_plots=floor(total_no_of_drops/drops_per_scatter_time_plot);
            if number_of_scatter_time_plots==0
                number_of_scatter_time_plots=1; % make atleast one plot with all available droplets
            end
            
            for scatter_time_plot=1:number_of_scatter_time_plots

                figure(plots_figure_handle) % make plots figure current just in case control has moved to the main gui. otherwise matlab will start plotting in main gui window
                if number_of_scatter_time_plots==1
                    current_drop_range=[1:total_no_of_drops];
                else
                    current_drop_range=[(scatter_time_plot-1)*drops_per_scatter_time_plot+1:scatter_time_plot*drops_per_scatter_time_plot];
                end
                
                % Iterate through all channels used to collect data
                for channel=1:no_of_channels
                    subplot(no_of_channels,1,channel)	
                    plot(drop_time(current_drop_range),avg_drop_height(current_drop_range,channel),strcat(color_palette(mod(channel,no_of_colors)),plotting_options.droplet_scatter_plots.marker));
                    
                    xlabel(eval(['plotting_options.droplet_scatter_plots.scatter_time_plot.ch' num2str(channel) '.xlabel']))
                    ylabel(eval(['plotting_options.droplet_scatter_plots.scatter_time_plot.ch' num2str(channel) '.ylabel']))
                    title(eval(['plotting_options.droplet_scatter_plots.scatter_time_plot.ch' num2str(channel) '.title']))
                end    
                
                % Save the current plot in all requested plot formats
                % Filename: sample_name_burst_energy_hist_combined_time_trace1
                for plot_format=1:length(global_plotting_options.save_plot_formats)
                    set(plots_figure_handle,'PaperPosition',paperposition);
                    saveas(plots_figure_handle,strcat([extended_sample_names{extended_sample} '_droplet_scatter_time_plot_' ...
                        num2str(scatter_time_plot)]),global_plotting_options.save_plot_formats{plot_format});
                end
                % Clear all the plots from the figure to use it again for new plots
                clf;
            end
            
            cd('../../')
		end
		%***************************************************************************************************
        
        
        
        %***************************************************************************************************
		% Generate droplet peak count plots here
		if ~isempty(regexp(plotting_options.plot_types,'droplet_peak_count','ignorecase'))
			% generate a directory to store the smd_plots
			mkdir('results/droplet_peak_count_plots')
			cd('results/droplet_peak_count_plots')
            fprintf('\n droplet_peak_count_plots \n')
            % Iterate through all the repetitions of data collection for the current sample	
			for time_trace=1:length(sample_data_struct.time_trace)
                fprintf('.')
                if rem(time_trace,100)==0
                    fprintf('\n')
                end
					
				if ~isempty(regexp(plotting_options.plot_types,'droplet_peak_count_combined','ignorecase'))	
					% Iterate through all channels used to collect data
					for channel=1:no_of_channels
        
                        figure(plots_figure_handle) % make plots figure current just in case control has moved to the main gui. otherwise matlab will start plotting in main gui window						
						subplot(no_of_channels,1,channel)	
							% collect the peak count and droplet size data
                            droplet_size=sample_data_struct.time_trace(time_trace).droplet_location_data.droplet_width_data;
                            droplet_peak_count=sample_data_struct.time_trace(time_trace).droplet_location_data.channel(channel).droplet_peak_count;
                            
                            % must provide no of bins or range for droplet width and droplet peak count
                            eval(['droplet_size_nbins_or_range=default_plotting_options.droplet_peak_count.ch' num2str(channel) '.droplet_width.nbins_or_range;'])
                            eval(['droplet_peak_count_nbins_or_range=default_plotting_options.droplet_peak_count.ch' num2str(channel) '.peak_count.nbins_or_range;'])
                            
                            if length(droplet_size_nbins_or_range)~=1
                                hist_co_ord_array{1}=droplet_size_nbins_or_range;
                            else
                                hist_co_ord_array{1}=linspace(min(droplet_size),max(droplet_size),droplet_size_nbins_or_range);
                            end
                            
                            if length(droplet_peak_count_nbins_or_range)~=1
                                hist_co_ord_array{2}=droplet_peak_count_nbins_or_range;
                            else
                                hist_co_ord_array{2}=linspace(min(droplet_peak_count),max(droplet_peak_count),droplet_peak_count_nbins_or_range);
                            end
                                                                
                            frequency_data=hist3([droplet_size,droplet_peak_count],hist_co_ord_array);
                            pcolor(hist_co_ord_array{1},hist_co_ord_array{2},frequency_data');
                            colorbar;
                            
%                             eval(['scatter_marker=plotting_options.droplet_peak_count.ch' num2str(channel) '.scatter_marker;'])
%                             plot(droplet_size,droplet_peak_count,strcat(color_palette(mod(channel,no_of_colors)),scatter_marker))                            
%                                 
%                             % Use the axis option only if explicitly specified by the user
%     						% If absent, matlab autoscaling of the axes will be used	
%         					try
%             					axis(eval(['plotting_options.droplet_peak_count.ch' num2str(channel) '.axis_options']));
%                             catch
%                             end
						
                        	% labels must be provided for each axis						
                            xlabel(eval(['plotting_options.droplet_peak_count.ch' num2str(channel) '.xlabel']))
    						ylabel(eval(['plotting_options.droplet_peak_count.ch' num2str(channel) '.ylabel']))
        					title (eval(['plotting_options.droplet_peak_count.ch' num2str(channel) '.title']))    
                            clear droplet_size droplet_peak_count
                    end

                    % Save the current plot in all requested plot formats
                    % Filename: sample_name_backgrd_plot_time_trace1
                    for plot_format=1:length(global_plotting_options.save_plot_formats)
                        set(plots_figure_handle,'PaperPosition',paperposition);
                        saveas(plots_figure_handle,strcat([extended_sample_names{extended_sample} '_droplet_peak_count_time_trace' num2str(time_trace)])...
							,global_plotting_options.save_plot_formats{plot_format});
                    end
							
    				% Clear all the plots from the figure to use it again for new plots
        			clf;
            	end	
			                    
                if ~isempty(regexp(plotting_options.plot_types,'droplet_peak_count_sep','ignorecase'))	
					% Iterate through all channels used to collect data
					for channel=1:no_of_channels
                            
                            figure(plots_figure_handle) % make plots figure current just in case control has moved to the main gui. otherwise matlab will start plotting in main gui window	                    
                            % collect the peak count and droplet size data
                            droplet_size=sample_data_struct.time_trace(time_trace).droplet_location_data.droplet_width_data;
                            droplet_peak_count=sample_data_struct.time_trace(time_trace).droplet_location_data.channel(channel).droplet_peak_count;
                         
                            % must provide no of bins or range for droplet width and droplet peak count
                            eval(['droplet_size_nbins_or_range=default_plotting_options.droplet_peak_count.ch' num2str(channel) '.droplet_width.nbins_or_range;'])
                            eval(['droplet_peak_count_nbins_or_range=default_plotting_options.droplet_peak_count.ch' num2str(channel) '.peak_count.nbins_or_range;'])
                            
                            if length(droplet_size_nbins_or_range)~=1
                                hist_co_ord_array{1}=droplet_size_nbins_or_range;
                            else
                                hist_co_ord_array{1}=linspace(min(droplet_size),max(droplet_size),droplet_size_nbins_or_range);
                            end
                            
                            if length(droplet_peak_count_nbins_or_range)~=1
                                hist_co_ord_array{2}=droplet_peak_count_nbins_or_range;
                            else
                                hist_co_ord_array{2}=linspace(min(droplet_peak_count),max(droplet_peak_count),droplet_peak_count_nbins_or_range);
                            end
                                                                
                            frequency_data=hist3([droplet_size,droplet_peak_count],hist_co_ord_array);
                            pcolor(hist_co_ord_array{1},hist_co_ord_array{2},frequency_data);
                            colorbar;
                            
%                             scatter_marker=plotting_options.droplet_peak_count.channel(channel).scatter_marker;
%                             plot(droplet_size,droplet_peak_count,strcat(color_palette(mod(channel,no_of_colors)),scatter_marker))
%                                 
%                             % Use the axis option only if explicitly specified by the user
%     						% If absent, matlab autoscaling of the axes will be used	
%         					try
%             					axis(eval(['plotting_options.droplet_peak_count.ch' num2str(channel) '.axis_options']));
%                             catch
%                             end
% 						
                        	% labels must be provided for each axis						
                            xlabel(eval(['plotting_options.droplet_peak_count.ch' num2str(channel) '.xlabel']))
    						ylabel(eval(['plotting_options.droplet_peak_count.ch' num2str(channel) '.ylabel']))
        					title (eval(['plotting_options.droplet_peak_count.ch' num2str(channel) '.title']))    
                            % Save the current plot in all requested plot formats
                        % Filename: sample_name_backgrd_plot_time_trace1
                        for plot_format=1:length(global_plotting_options.save_plot_formats)
                            set(plots_figure_handle,'PaperPosition',paperposition);
                            saveas(plots_figure_handle,strcat([extended_sample_names{extended_sample} '_droplet_peak_count_time_trace' num2str(time_trace) ...
                                '_ch' num2str(channel)]),global_plotting_options.save_plot_formats{plot_format});
                        end
							
        				% Clear all the plots from the figure to use it again for new plots
            			clf;
                        clear droplet_size droplet_peak_count
                    end

                end                
            end
            cd('../../')                    
        end
        %***************************************************************************************************                                
                                
      
        
		%***************************************************************************************************
		% Generate droplet FRET efficency histograms here if requested
		if ~isempty(regexp(plotting_options.plot_types,'droplet_FRET_efficiency_hist','ignorecase'))
			% generate a directory to store the smd_plots
			mkdir('results/droplet_FRET_efficiency_histograms')
			cd('results/droplet_FRET_efficiency_histograms')
            fprintf('\n droplet_FRET_efficiency_histograms \n')
			total_FRET_pairs=length(data_processing_options.FRET_donor);

			% Iterate through all the repetitions of data collection for the current sample	
			for time_trace=1:length(sample_data_struct.time_trace)
                fprintf('.')
                if rem(time_trace,100)==0
                    fprintf('\n')
                end
				for fret_pair=1:total_FRET_pairs
                    
                    figure(plots_figure_handle) % make plots figure current just in case control has moved to the main gui. otherwise matlab will start plotting in main gui window	                
                    channel1=data_processing_options.FRET_donor(fret_pair);
					channel2=data_processing_options.FRET_acceptor(fret_pair);
					try 
						hist(sample_data_struct.time_trace(time_trace).droplet_location_data.FRET_efficiency...
							(:,fret_pair),eval(['plotting_options.droplet_FRET_efficiency_hist.fret_pair' ...
							num2str(fret_pair) '.nbins_or_range;']));
					catch
						hist(sample_data_struct.time_trace(time_trace).droplet_location_data.FRET_efficiency...
							(:,fret_pair));
					end
				
					set(findobj(gca,'Type','patch'),'FaceColor',eval([...
					'plotting_options.droplet_FRET_efficiency_hist.fret_pair' num2str(fret_pair) '.color;']));			
					xlabel(eval(['plotting_options.droplet_FRET_efficiency_hist.fret_pair' num2str(fret_pair) '.xlabel']))
					ylabel(eval(['plotting_options.droplet_FRET_efficiency_hist.fret_pair' num2str(fret_pair) '.ylabel']))
					title(eval(['plotting_options.droplet_FRET_efficiency_hist.fret_pair' num2str(fret_pair) '.title']))

					% Save the current plot in all requested plot formats
					% Filename: sample_name_burst_width_hist_combined_time_trace1
					for plot_format=1:length(global_plotting_options.save_plot_formats)
						set(plots_figure_handle,'PaperPosition',paperposition);
						saveas(plots_figure_handle,strcat([extended_sample_names{extended_sample} '_droplet_FRET_efficiency_hist_time_trace' ...
						num2str(time_trace) '_fret_pair_' num2str(fret_pair)]),global_plotting_options...
						.save_plot_formats{plot_format});
					end
					% Clear all the plots from the figure to use it again for new plots
					clf;
				end
			end	
			cd('../../')
		end
		%***************************************************************************************************

		% load the sample_data structure again and save the information about the plot types generated
		% a small price to pay for not risking altering the data in the plotting function! 
		% the information stored is used by the report generator function
	        for sample_counter=1:length(expt_conditions_sample_desc.extended_sample_names)
    			current_sample=expt_conditions_sample_desc.extended_sample_names{sample_counter};
                if ~isempty(regexp(current_sample,extended_sample_names{extended_sample}))
                    try
                        expt_conditions_sample_desc.plot_types{sample_counter}=strcat(expt_conditions_sample_desc.plot_types{sample_counter},plotting_options.plot_types);
                    catch
                        expt_conditions_sample_desc.plot_types{sample_counter}=plotting_options.plot_types;
                    end	
                    break;		
                end
    		end


%		if isfield(eval([sample_names{sample}]),'plot_types') 
%			eval([sample_names{sample} '.plot_types=strcat(' sample_names{sample} ...
%					'.plot_types,plotting_options.plot_types);'])
%		else
%			eval([sample_names{sample} '.plot_types=plotting_options.plot_types;'])
%		end			
%		save(data_file,sample_names{sample},'-append')
%		%***************************************************************************************************
	
    % Save memory by clearing the data structure which we don't need
    % anymore
    clear sample_data_struct    
    
    end % Extended Sample loop

	save(data_file,'expt_conditions_sample_desc','-append')


%*********************************    
    
 close(plots_figure_handle)
 close(hObject)
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

% --- Outputs from this function are returned to the command line.
function varargout = gen_droplet_data_plots_gui_ver2p2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;
