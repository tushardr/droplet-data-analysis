function save_manual_threshold_data_v2p1(manual_thresholds_initialization_data)

input_valid=false;

initial_setup_function;

    function initial_setup_function(manual_thresholds_initialization_data)
% Generate a gui for the user to modify default thresholds for each sample
man_thresh_fig=figure;
% With normalized units, the range of the figure (width and height) goes
% from 0 to 1. 1 being width/height of the screen
set(man_thresh_fig,'Units','normalized')
% Position = [(left bottom x,y),width,height) 
set(man_thresh_fig,'Position',[.25 .25 .5 .5])

threshold_table=uitable(man_thresh_fig,'Data',manual_thresholds_initialization_data);
set(threshold_table,'Units','normalized')
set(threshold_table,'Position',[.25 .25 .5 .5])
manual_threshold_filename=strcat('manual_thresholds_file.xlsx');
save_button=uicontrol(man_thresh_fig,'Style','pushbutton','String','Save manual threshold data?','Callback',{@save_manual_threshold_data_v2p1,get(threshold_table,'Data'),manual_threshold_filename})
set(save_button,'Units','normalized')
set(save_button,'Position',[.25 .1 .5 .1])
end


sprintf('here')