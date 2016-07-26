function gen_droplet_data_plots_ver2p1(data_dir, expt_date, expt_num, varargin)

expt_date_with_underscores=regexprep(expt_date,'-','_');
%************************************************************************************************
% Go to the data directory for the specified expt 
	eval(['cd(''' data_dir '/' expt_date '/expt' num2str(expt_num) ''')']);
	if nargin<4
		% Ask the user for the data file to be used for plotting data
		data_file=input('Which processed data file should I use for the plot data?(pressing enter selects the default file)','s');
		if isempty(data_file)
			% if no data filename entered, use the default data file for that expt
			data_file=strcat(['processed_data_expt' num2str(expt_num) '_' expt_date '.mat']);
		end
	else
		data_file=varargin{1};
	end

	% try to load the expt description and sample names from the processed data file
	expt_desc_struct_name=strcat(['expt_conditions_sample_desc_expt' num2str(expt_num) '_' expt_date_with_underscores]);		
	% same struct loaded with its original name to add the plot types field, later on
	% to be used for reference in the report generator function 
	load(data_file,expt_desc_struct_name); 
	eval(['expt_conditions_sample_desc=' expt_desc_struct_name ';'])

	load(data_file,'data_processing_options');	
	% load all the information that might be necessary for the plots later on
	bin_time_in_sec=expt_conditions_sample_desc.Bin_time_in_msec*0.001;
%************************************************************************************************
	% load the default and any sample specific plotting options specified by the user
	eval(['droplet_plotting_options_script_expt' num2str(expt_num) '_' expt_date_with_underscores]);
%************************************************************************************************
% Generate a figure to be used for all the plotting commands	
	figure(1)
	% Iterate through all the samples to be plotted 
	for sample=1:length(sample_names)
		
		% load the sample data from data file
		load(data_file,sample_names{sample});
		eval(['sample_data_struct=' sample_names{sample} ';']);
		clear(sample_names{sample})
		% assign default options to all the plotting options
		plotting_options=default_plotting_options;
		
		% check if there are any sample specific options we need to change
		%***************************************************************************************************
		try 
		% Do further processing only if the user actually provided some sample specific plotting options
		
			if isfield(sample_plotting_options,sample_names{sample})
				sample_specific_options_struct=strcat('sample_plotting_options.',sample_names{sample});
				sample_specific_fields=get_complete_field_hierarchy(sample_specific_options_struct,...
								eval([sample_specific_options_struct]));
				fields_to_change=regexprep(sample_specific_fields,strcat('sample_plotting_options.',...
						sample_names{sample}),'plotting_options');
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
			% Iterate through all the repetitions of data collection for the current sample
			for time_trace=1:length(sample_data_struct.time_trace)
				no_of_channels=size(sample_data_struct.time_trace(time_trace).corrected_channel_data,2);
				% Calculate the number of time points for which the data was collected for each channel
				no_of_data_points=size(sample_data_struct.time_trace(time_trace).corrected_channel_data,1);
				% Iterate through all channels used to collect data
				for channel=1:no_of_channels
					subplot(no_of_channels,1,channel)
						plot([1:no_of_data_points]*bin_time_in_sec,sample_data_struct.time_trace(time_trace)...
						.corrected_channel_data(:,channel),color_palette(mod(channel,no_of_colors)));
				
						hold on
						% plot the baseline here
						plot([1,no_of_data_points]*bin_time_in_sec,[1,1]*sample_data_struct.time_trace(time_trace)...
						.droplet_location_data.baselines(channel),baseline_color);
						
						% Highlight all the droplets with a different color 
						plot([1:no_of_data_points]*bin_time_in_sec,sample_data_struct.time_trace(time_trace)...
						.corrected_channel_data(:,channel).*sample_data_struct.time_trace(time_trace)...
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
					set(gcf,'PaperPosition',paperposition);
					saveas(gcf,strcat([sample_names{sample} '_smd_plot_time_trace' num2str(time_trace)])...
							,global_plotting_options.save_plot_formats{plot_format});
				end

				% Just use the already plotted smd traces to generate a closeup view of data to judge backgrd
				% level
				for channel=1:no_of_channels
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
					set(gcf,'PaperPosition',paperposition);
					saveas(gcf,strcat([sample_names{sample} '_backgrd_plot_time_trace' num2str(time_trace)])...
							,global_plotting_options.save_plot_formats{plot_format});
				end
							
				% Clear all the plots from the figure to use it again for new plots
				clf;
			end	
			cd('../../')
		end
		%***************************************************************************************************

		% Generate droplet inspection figures (figures with a certain number of droplets for each channel)
		if ~isempty(regexp(plotting_options.plot_types,'droplet_inspection','ignorecase'))
			% generate a directory to store the smd_plots
			mkdir('results/droplet_inspection_plots')
			cd('results/droplet_inspection_plots')
			% Iterate through all the repetitions of data collection for the current sample
			for time_trace=1:length(sample_data_struct.time_trace)
				no_of_channels=size(sample_data_struct.time_trace(time_trace).corrected_channel_data,2);
				% Calculate the number of time points for which the data was collected for each channel
				no_of_data_points=size(sample_data_struct.time_trace(time_trace).corrected_channel_data,1);
				% Iterate through all channels used to collect data
				for channel=1:no_of_channels
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
						plot([limit_xmin:limit_xmax]*bin_time_in_sec,sample_data_struct.time_trace(time_trace)...
										.corrected_channel_data(limit_xmin:limit_xmax,channel),...
										color_palette(mod(channel,no_of_colors)));
						hold on
						% Highlight all the droplets with a different color 
						plot([limit_xmin:limit_xmax]*bin_time_in_sec,sample_data_struct.time_trace(time_trace)...
						.corrected_channel_data(limit_xmin:limit_xmax,channel).*sample_data_struct...
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

							plot([random_limit_xmin:limit_xmax]*bin_time_in_sec,sample_data_struct...
							    .time_trace(time_trace).corrected_channel_data...
							    (random_limit_xmin:limit_xmax,channel),color_palette(mod(channel,no_of_colors)));

							hold on
							% Highlight all the droplets with a different color 
							plot([random_limit_xmin:limit_xmax]*bin_time_in_sec,sample_data_struct...
							    	.time_trace(time_trace).corrected_channel_data...
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

							plot([limit_xmax:random_limit_xmin]*bin_time_in_sec,sample_data_struct...
							    .time_trace(time_trace).corrected_channel_data...
							    (limit_xmax:random_limit_xmin,channel),color_palette(mod(channel,no_of_colors)));
							hold on
							% Highlight all the droplets with a different color 
							plot([limit_xmax:random_limit_xmin]*bin_time_in_sec,sample_data_struct...
							    	.time_trace(time_trace).corrected_channel_data...
							    	(limit_xmax:random_limit_xmin,channel).*sample_data_struct...
							 	.time_trace(time_trace).droplet_location_data.droplet_location_array...
								(limit_xmax:random_limit_xmin),droplet_color);
							
							if length(droplet_inspect_axis_options)==3	
								axis([[limit_xmax random_limit_xmin]*bin_time_in_sec,...
									droplet_inspect_axis_options(2:3)]);
							end
						    end
						else
						    plot([1:no_of_data_points]*bin_time_in_sec,sample_data_struct.time_trace(time_trace)...
						    .corrected_channel_data(:,channel),color_palette(mod(channel,no_of_colors)));
				
						    hold on
					            % Highlight all the droplets with a different color 
						    plot([1:no_of_data_points]*bin_time_in_sec,sample_data_struct.time_trace(time_trace)...
						    .corrected_channel_data(:,channel).*sample_data_struct.time_trace(time_trace)...
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
					set(gcf,'PaperPosition',paperposition);
					saveas(gcf,strcat([sample_names{sample} '_droplet_inspect_plot_time_trace' num2str(time_trace)])...
							,global_plotting_options.save_plot_formats{plot_format});
				end

				% Clear all the plots from the figure to use it again for new plots
				clf;
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
			% Iterate through all the repetitions of data collection for the current sample	
			for time_trace=1:length(sample_data_struct.time_trace)
				channel=data_processing_options.Droplet_reference_channel;
				try 
					hist(sample_data_struct.time_trace(time_trace).droplet_location_data.droplet_width_data,...
						plotting_options.droplet_width_hist.nbins_or_range);
				catch
					hist(sample_data_struct.time_trace(time_trace).droplet_location_data.droplet_width_data);
				end
				
				set(findobj(gca,'Type','patch'),'FaceColor',color_palette(mod(channel,no_of_colors)));
				xlabel(plotting_options.droplet_width_hist.xlabel)
				ylabel(plotting_options.droplet_width_hist.ylabel)
				title(plotting_options.droplet_width_hist.title)

				% Save the current plot in all requested plot formats
				% Filename: sample_name_burst_width_hist_combined_time_trace1
				for plot_format=1:length(global_plotting_options.save_plot_formats)
					set(gcf,'PaperPosition',paperposition);
					saveas(gcf,strcat([sample_names{sample} '_droplet_width_hist_time_trace' ...
						num2str(time_trace)]),global_plotting_options.save_plot_formats{plot_format});
				end
				% Clear all the plots from the figure to use it again for new plots
				clf;
			end	
			cd('../../')
		end
		%***************************************************************************************************

		%***************************************************************************************************
		% Generate droplet burst energy histograms here if requested
		if ~isempty(regexp(plotting_options.plot_types,'droplet_burst_energy_hist','ignorecase'))
			% generate a directory to store the smd_plots
			mkdir('results/droplet_burst_energy_histograms')
			cd('results/droplet_burst_energy_histograms')
			% Iterate through all the repetitions of data collection for the current sample	
			for time_trace=1:length(sample_data_struct.time_trace)
				no_of_channels=size(sample_data_struct.time_trace(time_trace).corrected_channel_data,2);
				% Calculate the number of time points for which the data was collected for each channel
				no_of_data_points=size(sample_data_struct.time_trace(time_trace).corrected_channel_data,1);
				
				if ~isempty(regexp(plotting_options.plot_types,'droplet_burst_energy_hist_combined','ignorecase'))	
					% Iterate through all channels used to collect data
					for channel=1:no_of_channels
						
						subplot(no_of_channels,1,channel)	
							% Use the number of bins option only if explicitly specified by the user	
							% If absent, matlab default for number of bins will be used	
							try
								hist(sample_data_struct.time_trace(time_trace).droplet_location_data...
								.droplet_burst_energy(:,channel),eval([...
								'plotting_options.droplet_burst_energy_hist.ch' num2str(channel) ...
								'.nbins_or_range;']));

							catch
								hist(sample_data_struct.time_trace(time_trace).droplet_location_data...
								.droplet_burst_energy(:,channel));
							end

							set(findobj(gca,'Type','patch'),'FaceColor',color_palette(mod(channel,no_of_colors)));
	
						xlabel(eval(['plotting_options.droplet_burst_energy_hist.ch' num2str(channel) '.xlabel']))
						ylabel(eval(['plotting_options.droplet_burst_energy_hist.ch' num2str(channel) '.ylabel']))
						title (eval(['plotting_options.droplet_burst_energy_hist.ch' num2str(channel) '.title']))

					end
					% Save the current plot in all requested plot formats
					% Filename: sample_name_burst_energy_hist_combined_time_trace1
					for plot_format=1:length(global_plotting_options.save_plot_formats)
						set(gcf,'PaperPosition',paperposition);
						saveas(gcf,strcat([sample_names{sample} '_droplet_burst_energy_hist_combined_time_trace' ...
							num2str(time_trace)]),global_plotting_options.save_plot_formats{plot_format});
					end
					% Clear all the plots from the figure to use it again for new plots
					clf;
				end


				if ~isempty(regexp(plotting_options.plot_types,'droplet_burst_energy_hist_sep','ignorecase'))	
					% Iterate through all channels used to collect data
					for channel=1:no_of_channels	
						% Use the number of bins option only if explicitly specified by the user	
						% If absent, matlab default for number of bins will be used	
						try
							hist(sample_data_struct.time_trace(time_trace).droplet_location_data...
							.droplet_burst_energy(:,channel),eval([...
							'plotting_options.droplet_burst_energy_hist.ch' num2str(channel) '.nbins_or_range;']));

						catch
							hist(sample_data_struct.time_trace(time_trace).droplet_location_data...
							.droplet_burst_energy(:,channel));
						end

						set(findobj(gca,'Type','patch'),'FaceColor',color_palette(mod(channel,no_of_colors)));
	
						xlabel(eval(['plotting_options.droplet_burst_energy_hist.ch' num2str(channel) '.xlabel']))
						ylabel(eval(['plotting_options.droplet_burst_energy_hist.ch' num2str(channel) '.ylabel']))
						title (eval(['plotting_options.droplet_burst_energy_hist.ch' num2str(channel) '.title']))
					
						% Save the current plot in all requested plot formats
						% Filename: sample_name_burst_energy_hist_time_trace1_ch2
						for plot_format=1:length(plotting_options.save_plot_formats)
							set(gcf,'PaperPosition',paperposition);
							saveas(gcf,strcat([sample_names{sample} '_droplet_burst_energy_hist_time_trace' ...
							num2str(time_trace) '_ch' num2str(channel)]),plotting_options...
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
		% Generate droplet peak count plots here
		if ~isempty(regexp(plotting_options.plot_types,'droplet_peak_count','ignorecase'))
			% generate a directory to store the smd_plots
			mkdir('results/droplet_peak_count_plots')
			cd('results/droplet_peak_count_plots')
			% Iterate through all the repetitions of data collection for the current sample	
			for time_trace=1:length(sample_data_struct.time_trace)
				no_of_channels=size(sample_data_struct.time_trace(time_trace).corrected_channel_data,2);
				% Calculate the number of time points for which the data was collected for each channel
				no_of_data_points=size(sample_data_struct.time_trace(time_trace).corrected_channel_data,1);
				
				if ~isempty(regexp(plotting_options.plot_types,'droplet_peak_count_combined','ignorecase'))	
					% Iterate through all channels used to collect data
					for channel=1:no_of_channels
						
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
                        set(gcf,'PaperPosition',paperposition);
                        saveas(gcf,strcat([sample_names{sample} '_droplet_peak_count_time_trace' num2str(time_trace)])...
							,global_plotting_options.save_plot_formats{plot_format});
                    end
							
    				% Clear all the plots from the figure to use it again for new plots
        			clf;
            	end	
			                    
                if ~isempty(regexp(plotting_options.plot_types,'droplet_peak_count_sep','ignorecase'))	
					% Iterate through all channels used to collect data
					for channel=1:no_of_channels
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
                            set(gcf,'PaperPosition',paperposition);
                            saveas(gcf,strcat([sample_names{sample} '_droplet_peak_count_time_trace' num2str(time_trace) ...
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
			total_FRET_pairs=length(data_processing_options.FRET_donor);

			% Iterate through all the repetitions of data collection for the current sample	
			for time_trace=1:length(sample_data_struct.time_trace)
				for fret_pair=1:total_FRET_pairs
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
						set(gcf,'PaperPosition',paperposition);
						saveas(gcf,strcat([sample_names{sample} '_droplet_FRET_efficiency_hist_time_trace' ...
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
	        for sample_counter=1:eval(['length(' expt_desc_struct_name '.sample_names);'])
			current_sample=eval([expt_desc_struct_name '.sample_names{sample_counter};']);
			if ~isempty(regexp(current_sample,sample_names{sample}))
				try
					eval([expt_desc_struct_name '.plot_types{' num2str(sample_counter) ...
						'}=strcat(' expt_desc_struct_name '.plot_types{' num2str(sample_counter) ...	
						'},plotting_options.plot_types);']);
				catch
					eval([expt_desc_struct_name '.plot_types{' num2str(sample_counter) ...
						'}=plotting_options.plot_types;']);
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
		
	end % Sample loop

	save(data_file,expt_desc_struct_name,'-append')

