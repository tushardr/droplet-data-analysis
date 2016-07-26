	
% if you do not want to plot all the samples, enter the names of the
% samples to be plotted here.
% leave the list empty if you want to plot all the samples (sample_names={};)
sample_names={};
%*************************************************************************************
% If no specific samples asked to be plotted, plot the results for all the samples 
	if isempty(sample_names)
		sample_names=expt_conditions_sample_desc.sample_names;
	end				
	
% Global plotting options go here. These options will be the same for all the samples 
	global_plotting_options.save_plot_formats={'png','fig'};
	% color palette will be used for data from different channels in the order ch1='b' ch2='g' etc
	% coin_color is used to highlight the coincident peaks between two channels
	color_palette=['b' 'g' 'r' 'c' 'm' 'y'];
	coin_color='k';
	baseline_color='m';
	droplet_color='k';
	no_of_colors=length(color_palette);
	paperposition=[2 1 6 9/2]; % required to set the size of the figures to be saved by matlab
				   % [starting point on screen(x,y) height width] normal(8,6)  	
%************************************************************************************************
	
%************************************************************************************************
% Default plotting options are specified here. If you leave an option for a particular sample empty, 
% these will be used instead (if specified). If an option isn't included in the default section as well
% as the section for that particular sample, it will be automatically computed

	default_plotting_options.plot_types=...
				'smd droplet_inspection droplet_width_hist droplet_burst_energy_hist_combined droplet_FRET_efficiency_hist';
%					'smd coin_2ch   intensity_hist_combined   burst_width_hist_combined   burst_energy_hist_combined';
	
	% SMD results default plotting options go here
	% Add another channel by simply copying one of the channels here and changing the values of the variables
	
            %*********************************************************************************************************
            % Channel1
            default_plotting_options.smd.ch1.axis_options=[0 25 0 100]; % {'xmin' 'xmax' 'ymin' ymax'} x in secs, y in counts

            default_plotting_options.smd.backgrd.ch1.axis_options=[0.3 0 100]; % {'time_interval' 'ymin' ymax'} x in secs, y in counts
        %	default_plotting_options.smd.backgrd.ch1.axis_options=[10 15 0 40]; % {'xmin' 'xmax' 'ymin' ymax'} x in secs, y in counts

            default_plotting_options.smd.ch1.xlabel='Time (msec)';
            default_plotting_options.smd.ch1.ylabel='Photon Counts';
            default_plotting_options.smd.ch1.title='FAM Channel';
            %*********************************************************************************************************

            %*********************************************************************************************************
            % Channel 2
            default_plotting_options.smd.ch2.axis_options=[0 25 0 500]; % {'xmin' 'xmax' 'ymin' ymax'}

            default_plotting_options.smd.backgrd.ch2.axis_options=[0.3 0 100]; % {'time_interval' 'ymin' ymax'} x in secs, y in counts
        %	default_plotting_options.smd.backgrd.ch2.axis_options=[10 15 0 40]; % {'xmin' 'xmax' 'ymin' ymax'} x in secs, y in counts

            default_plotting_options.smd.ch2.xlabel='Time (msec)';
            default_plotting_options.smd.ch2.ylabel='Photon Counts';
            default_plotting_options.smd.ch2.title='ROX channel';
            %*********************************************************************************************************

            %*********************************************************************************************************
            % Channel 3
            default_plotting_options.smd.ch3.axis_options=[0 25 0 300]; % {'xmin' 'xmax' 'ymin' ymax'}

            default_plotting_options.smd.backgrd.ch3.axis_options=[0.3 0 100]; % {'time_interval' 'ymin' ymax'} x in secs, y in counts
        %	default_plotting_options.smd.backgrd.ch3.axis_options=[10 15 0 40]; % {'xmin' 'xmax' 'ymin' ymax'} x in secs, y in counts

            default_plotting_options.smd.ch3.xlabel='Time (msec)';
            default_plotting_options.smd.ch3.ylabel='Photon Counts';
            default_plotting_options.smd.ch3.title='Cy5 Channel';
            %*********************************************************************************************************
	
	% Droplet inspection results default plotting options go here
	% Add another channel by simply copying one of the channels here and changing the values of the variables
	
            %*********************************************************************************************************
            % Channel1
            default_plotting_options.droplet_inspect.ch1.axis_options=[25]; % {'xmin' 'xmax' 'ymin' ymax'} x in secs, y in counts
                                                % OR {'no_of_droplets' 'ymin' ymax'}
                                                % OR {'no of droplets'} for autoscaling of Y axis

            default_plotting_options.droplet_inspect.ch1.xlabel='Time (msec)';
            default_plotting_options.droplet_inspect.ch1.ylabel='Photon Counts';
            default_plotting_options.droplet_inspect.ch1.title='FAM Channel';
            %*********************************************************************************************************

            %*********************************************************************************************************
            % Channel 2
            default_plotting_options.droplet_inspect.ch2.axis_options=[25]; % {'xmin' 'xmax' 'ymin' ymax'} x in secs, y in counts
                                                % OR {'no_of_droplets' 'ymin' ymax'}
                                                % OR {'no of droplets'} for autoscaling of Y axis

            default_plotting_options.droplet_inspect.ch2.xlabel='Time (sec)';
            default_plotting_options.droplet_inspect.ch2.ylabel='Counts';
            default_plotting_options.droplet_inspect.ch2.title='ROX channel';
            %*********************************************************************************************************

            %*********************************************************************************************************
            % Channel 3

            default_plotting_options.droplet_inspect.ch2.axis_options=[25]; % {'xmin' 'xmax' 'ymin' ymax'} x in secs, y in counts
                                                % OR {'no_of_droplets' 'ymin' ymax'}
                                                % OR {'no of droplets'} for autoscaling of Y axis

            default_plotting_options.droplet_inspect.ch3.xlabel='Time (sec)';
            default_plotting_options.droplet_inspect.ch3.ylabel='Counts';
            default_plotting_options.droplet_inspect.ch3.title='Cy5 Channel';
            %*********************************************************************************************************



	% Default options for the droplet width histograms go here
            %*********************************************************************************************************
            default_plotting_options.droplet_width_hist.nbins_or_range=50; % enter an array [xmin:step:xmax] or a single number(nbin)

            default_plotting_options.droplet_width_hist.xlabel='Droplet width (msec)';
            default_plotting_options.droplet_width_hist.ylabel='Frequency';
            default_plotting_options.droplet_width_hist.title='Droplet Width Histogram';



	% Default options for droplet burst energy histograms go here	
            %*********************************************************************************************************
            % Channel 1
            default_plotting_options.droplet_burst_energy_hist.ch1.nbins_or_range=50; % enter an array [xmin:step:xmax] or a single number(nbin)

            default_plotting_options.droplet_burst_energy_hist.ch1.xlabel='Burst Energy';
            default_plotting_options.droplet_burst_energy_hist.ch1.ylabel='Frequency';
            default_plotting_options.droplet_burst_energy_hist.ch1.title='FAM Channel';
            %*********************************************************************************************************

            %*********************************************************************************************************
            % Channel 2
            default_plotting_options.droplet_burst_energy_hist.ch2.nbins_or_range=50; % enter an array [xmin:step:xmax] or a single number(nbin)

            default_plotting_options.droplet_burst_energy_hist.ch2.xlabel='Burst energy';
            default_plotting_options.droplet_burst_energy_hist.ch2.ylabel='Frequency';
            default_plotting_options.droplet_burst_energy_hist.ch2.title='ROX channel';
            %*********************************************************************************************************

            %*********************************************************************************************************
            % Channel 3
            default_plotting_options.droplet_burst_energy_hist.ch3.nbins_or_range=50; % enter an array [xmin:step:xmax] or a single number(nbin)

            default_plotting_options.droplet_burst_energy_hist.ch3.xlabel='Burst energy';
            default_plotting_options.droplet_burst_energy_hist.ch3.ylabel='Frequency';
            default_plotting_options.droplet_burst_energy_hist.ch3.title='Cy5 Channel';
            %*********************************************************************************************************

        % Default options for droplet peak count plots 
            %*********************************************************************************************************
            % Channel 1
            default_plotting_options.droplet_peak_count.ch1.droplet_width.nbins_or_range=[50]; % enter an array [xmin:step:xmax] or a single number(nbin)
            default_plotting_options.droplet_peak_count.ch1.peak_count.nbins_or_range=[10]; % enter an array [xmin:step:xmax] or a single number(nbin)
            default_plotting_options.droplet_peak_count.ch1.scatter_marker='*';
            default_plotting_options.droplet_peak_count.ch1.xlabel='Droplet size (msec)';
            default_plotting_options.droplet_peak_count.ch1.ylabel='Peak count/droplet';
            default_plotting_options.droplet_peak_count.ch1.title='FAM Channel';
            %*********************************************************************************************************

            %*********************************************************************************************************
            % Channel 2
            default_plotting_options.droplet_peak_count.ch2.droplet_width.nbins_or_range=[50]; % enter an array [xmin:step:xmax] or a single number(nbin)
            default_plotting_options.droplet_peak_count.ch2.peak_count.nbins_or_range=[10]; % enter an array [xmin:step:xmax] or a single number(nbin)
            default_plotting_options.droplet_peak_count.ch2.scatter_marker='.';
            default_plotting_options.droplet_peak_count.ch2.xlabel='Droplet size (msec)';
            default_plotting_options.droplet_peak_count.ch2.ylabel='Peak count/droplet';
            default_plotting_options.droplet_peak_count.ch2.title='ROX channel';
            %*********************************************************************************************************

            %*********************************************************************************************************
            % Channel 3
            default_plotting_options.droplet_peak_count.ch3.droplet_width.nbins_or_range=[50]; % enter an array [xmin:step:xmax] or a single number(nbin)
            default_plotting_options.droplet_peak_count.ch3.peak_count.nbins_or_range=[10]; % enter an array [xmin:step:xmax] or a single number(nbin)    
            default_plotting_options.droplet_peak_count.ch3.scatter_marker='o';
            default_plotting_options.droplet_peak_count.ch3.xlabel='Droplet size (msec)';
            default_plotting_options.droplet_peak_count.ch3.ylabel='Peak count/droplet';
            default_plotting_options.droplet_peak_count.ch3.title='Red Channel';
            %*********************************************************************************************************
    
    % Default options for droplet average height histograms  
            %*********************************************************************************************************
            % Channel 1
            default_plotting_options.droplet_avg_height_hist.ch1.nbins_or_range=50; % enter an array [xmin:step:xmax] or a single number(nbin)

            default_plotting_options.droplet_avg_height_hist.ch1.xlabel='Burst Energy';
            default_plotting_options.droplet_avg_height_hist.ch1.ylabel='Frequency';
            default_plotting_options.droplet_avg_height_hist.ch1.title='FAM Channel';
            %*********************************************************************************************************

            %*********************************************************************************************************
            % Channel 2
            default_plotting_options.droplet_avg_height_hist.ch2.nbins_or_range=50; % enter an array [xmin:step:xmax] or a single number(nbin)

            default_plotting_options.droplet_avg_height_hist.ch2.xlabel='Burst energy';
            default_plotting_options.droplet_avg_height_hist.ch2.ylabel='Frequency';
            default_plotting_options.droplet_avg_height_hist.ch2.title='ROX channel';
            %*********************************************************************************************************

            %*********************************************************************************************************
            % Channel 3
            default_plotting_options.droplet_avg_height_hist.ch3.nbins_or_range=50; % enter an array [xmin:step:xmax] or a single number(nbin)

            default_plotting_options.droplet_avg_height_hist.ch3.xlabel='Burst energy';
            default_plotting_options.droplet_avg_height_hist.ch3.ylabel='Frequency';
            default_plotting_options.droplet_avg_height_hist.ch3.title='Cy5 Channel';
            %*********************************************************************************************************
    
     % Default options for droplet height histograms  
     
            %*********************************************************************************************************
            % Channel 1
            default_plotting_options.droplet_height_hist.ch1.nbins_or_range=50; % enter an array [xmin:step:xmax] or a single number(nbin)

            default_plotting_options.droplet_height_hist.ch1.xlabel='Burst Energy';
            default_plotting_options.droplet_height_hist.ch1.ylabel='Frequency';
            default_plotting_options.droplet_height_hist.ch1.title='FAM Channel';
            %*********************************************************************************************************

            %*********************************************************************************************************
            % Channel 2
            default_plotting_options.droplet_height_hist.ch2.nbins_or_range=50; % enter an array [xmin:step:xmax] or a single number(nbin)

            default_plotting_options.droplet_height_hist.ch2.xlabel='Burst energy';
            default_plotting_options.droplet_height_hist.ch2.ylabel='Frequency';
            default_plotting_options.droplet_height_hist.ch2.title='ROX channel';
            %*********************************************************************************************************

            %*********************************************************************************************************
            % Channel 3
            default_plotting_options.droplet_height_hist.ch3.nbins_or_range=50; % enter an array [xmin:step:xmax] or a single number(nbin)

            default_plotting_options.droplet_height_hist.ch3.xlabel='Burst energy';
            default_plotting_options.droplet_height_hist.ch3.ylabel='Frequency';
            default_plotting_options.droplet_height_hist.ch3.title='Cy5 Channel';
            %*********************************************************************************************************
    
     % Default options for the scatter plots
            plotting_options.droplet_scatter_plots.scatter_only_plot.xlabel='FAM Channel';
            plotting_options.droplet_scatter_plots.scatter_only_plot.ylabel='ROX channel';
            %zlabel(plotting_options.droplet_scatter_plots.scatter_only_plot.zlabel);
            
            %*********************************************************************************************************
            % Channel 1
            default_plotting_options.droplet_scatter_plots.scatter_time_plot.ch1.xlabel='Time (msec)';
            default_plotting_options.droplet_scatter_plots.scatter_time_plot.ch1.ylabel='Droplet height';
            default_plotting_options.droplet_scatter_plots.scatter_time_plot.ch1.title='FAM Channel';
            %*********************************************************************************************************

            %*********************************************************************************************************
            % Channel 2
            default_plotting_options.droplet_scatter_plots.scatter_time_plot.ch2.xlabel='Time (msec)';
            default_plotting_options.droplet_scatter_plots.scatter_time_plot.ch2.ylabel='Droplet height';
            default_plotting_options.droplet_scatter_plots.scatter_time_plot.ch2.title='ROX channel';
            %*********************************************************************************************************

            %*********************************************************************************************************
            % Channel 3
            default_plotting_options.droplet_scatter_plots.scatter_time_plot.ch3.xlabel='Time (msec)';
            default_plotting_options.droplet_scatter_plots.scatter_time_plot.ch3.ylabel='Droplet height';
            default_plotting_options.droplet_scatter_plots.scatter_time_plot.ch3.title='Cy5 Channel';
            %*********************************************************************************************************
    
    
    
	% Default options for droplet FRET efficiency histograms go here	
	%*********************************************************************************************************
	% FRET pair 1
	default_plotting_options.droplet_FRET_efficiency_hist.fret_pair1.nbins_or_range=50; 
								% enter an array [xmin:step:xmax] or a single number(nbin)
	
	default_plotting_options.droplet_FRET_efficiency_hist.fret_pair1.color='r';
	default_plotting_options.droplet_FRET_efficiency_hist.fret_pair1.xlabel='FRET efficiency';
	default_plotting_options.droplet_FRET_efficiency_hist.fret_pair1.ylabel='Frequency';
	default_plotting_options.droplet_FRET_efficiency_hist.fret_pair1.title='QD-Cy5 FRET';
	%*********************************************************************************************************
	%*********************************************************************************************************
	% FRET pair 2
	default_plotting_options.droplet_FRET_efficiency_hist.fret_pair2.nbins_or_range=50; 
								% enter an array [xmin:step:xmax] or a single number(nbin)
	
	default_plotting_options.droplet_FRET_efficiency_hist.fret_pair2.color='g';
	default_plotting_options.droplet_FRET_efficiency_hist.fret_pair2.xlabel='FRET efficiency';
	default_plotting_options.droplet_FRET_efficiency_hist.fret_pair2.ylabel='Frequency';
	default_plotting_options.droplet_FRET_efficiency_hist.fret_pair2.title='QD-Green channel FRET';
	%*********************************************************************************************************

    
    
    
	%************************************************************************************************
	% plotting options for individual samples go here
%		sample_name='A01_ND1_1ulmin_'
	
%		eval(['sample_plotting_options.' sample_name '.smd.ch1.axis_options=[0 100 0 100];'])

%		sample_name='B01_ND1_1ulmin_'
	
%		eval(['sample_plotting_options.' sample_name '.smd.ch2.axis_options=[0 100 0 100];'])
	

