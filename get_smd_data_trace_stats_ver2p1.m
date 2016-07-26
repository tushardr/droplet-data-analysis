function [bin_time,duration,first_time_point]=get_smd_data_trace_stats_ver2p1(data_file)

bin_time_precision_required=-10; %to remove multiple unique entries identified by unique function due to roundoff errors

data=load(data_file);

time_points=data(:,1);
first_time_point=time_points(1,1);
bin_time=time_points(2:end)-time_points(1:end-1);
bin_time=roundn(bin_time,bin_time_precision_required);
bin_time=unique(bin_time);

if length(bin_time)>1 %&(max(bin_time)-min(bin_time))>bin_time_precision_required
    errordlg('bin time is not constant in the data file');
    return;
else
    duration=length(data(:,1))*bin_time/1000  % data duration in secs
    % in this case the small round off error in bin time calculation is
    % negligible so pick the first bin time number to data trace duration
end

