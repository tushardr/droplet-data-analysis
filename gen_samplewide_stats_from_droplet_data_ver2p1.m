function [samplewide_stats]=gen_samplewide_stats_from_droplet_data_ver2p1(data_file,extended_sample_names)

load(data_file,'-mat','data_processing_options')
no_of_channels=length(data_processing_options.data_channels);

count_peaks=strcmpi(data_processing_options.count_peaks,'yes');
Burst_analysis=strcmpi(data_processing_options.Burst_analysis,'yes');

for extended_sample=1:length(extended_sample_names)
    
    load(data_file,'-mat',extended_sample_names{extended_sample});
    eval(['extended_sample_struct=' extended_sample_names{extended_sample} ';'])
    clear(extended_sample_names{extended_sample})
    
    total_no_of_time_traces=length(extended_sample_struct.data_traces_read);
    %eval(['total_no_of_time_traces=length(' extended_sample_names{extended_sample} '.data_traces_read);']);
    for time_trace=1:total_no_of_time_traces
        for channel=1:no_of_channels
            if count_peaks
                temp_peak_count(:,channel)=extended_sample_struct.time_trace(time_trace).droplet_location_data.channel(channel).droplet_peak_count;
            end
            if Burst_analysis
                temp_burst_energy(:,channel)=extended_sample_struct.time_trace(time_trace).droplet_location_data.droplet_burst_energy(:,channel);
            end
        end     
        if extended_sample==1&time_trace==1
            droplet_width_data=extended_sample_struct.time_trace(time_trace).droplet_location_data.droplet_width_data;
            if count_peaks           
                droplet_peak_count=temp_peak_count;
            end
            if Burst_analysis
                droplet_burst_energy=temp_burst_energy;
            end
        else
            droplet_width_data=vertcat(droplet_width_data,extended_sample_struct.time_trace(time_trace).droplet_location_data.droplet_width_data);
            if count_peaks           
                droplet_peak_count=vertcat(droplet_peak_count,temp_peak_count);
            end
            if Burst_analysis
                droplet_burst_energy=vertcat(droplet_burst_energy,temp_burst_energy);
            end
        end
        clear('temp_peak_count','temp_burst_energy')
    end
    clear('extended_sample_struct')
end
       
% Calculate samplewide stats from the data stored above
samplewide_stats.mean_droplet_width=mean(droplet_width_data);
samplewide_stats.std_droplet_width=std(droplet_width_data);
if count_peaks
    samplewide_stats.mean_droplet_peak_count=mean(droplet_peak_count./repmat(droplet_width_data,1,no_of_channels)*data_processing_options.Reference_drop_size_in_msec,1);
    samplewide_stats.std_droplet_peak_count=std(droplet_peak_count./repmat(droplet_width_data,1,no_of_channels)*data_processing_options.Reference_drop_size_in_msec,0,1);
end
if Burst_analysis
    samplewide_stats.mean_droplet_burst_energy=mean(droplet_burst_energy,1);
    samplewide_stats.std_droplet_burst_energy=std(droplet_burst_energy,0,1);
end
