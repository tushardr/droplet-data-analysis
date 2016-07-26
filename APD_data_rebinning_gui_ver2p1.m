function varargout = APD_data_rebinning_gui_ver2p1(varargin)
% APD_DATA_REBINNING_GUI_VER2P1 MATLAB code for APD_data_rebinning_gui_ver2p1.fig
%      APD_DATA_REBINNING_GUI_VER2P1, by itself, creates a new APD_DATA_REBINNING_GUI_VER2P1 or raises the existing
%      singleton*.
%
%      H = APD_DATA_REBINNING_GUI_VER2P1 returns the handle to a new APD_DATA_REBINNING_GUI_VER2P1 or the handle to
%      the existing singleton*.
%
%      APD_DATA_REBINNING_GUI_VER2P1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in APD_DATA_REBINNING_GUI_VER2P1.M with the given input arguments.
%
%      APD_DATA_REBINNING_GUI_VER2P1('Property','Value',...) creates a new APD_DATA_REBINNING_GUI_VER2P1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before APD_data_rebinning_gui_ver2p1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to APD_data_rebinning_gui_ver2p1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help APD_data_rebinning_gui_ver2p1

% Last Modified by GUIDE v2.5 23-Oct-2013 14:45:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @APD_data_rebinning_gui_ver2p1_OpeningFcn, ...
                   'gui_OutputFcn',  @APD_data_rebinning_gui_ver2p1_OutputFcn, ...
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


% --- Executes just before APD_data_rebinning_gui_ver2p1 is made visible.
function APD_data_rebinning_gui_ver2p1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to APD_data_rebinning_gui_ver2p1 (see VARARGIN)

% Choose default command line output for APD_data_rebinning_gui_ver2p1
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes APD_data_rebinning_gui_ver2p1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = APD_data_rebinning_gui_ver2p1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in old_data_dir.
function old_data_dir_Callback(hObject, eventdata, handles)
% hObject    handle to old_data_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get the data directory with the data to be rebinned
handles.data.old_data_dir=uigetdir('Pick data directory');
guidata(hObject,handles) % save the data directory in guidata

% Show old data directory name on the gui
set(handles.old_data_dir_text,'string',handles.data.old_data_dir)

% initialize the sample table with unique sample names obtained from the
% filenames in the data directory
unique_sample_names=identify_unique_sample_names_ver2p1(handles.data.old_data_dir);
table_length=length(unique_sample_names);
table_initialization_data=cell(table_length,6);
table_initialization_data(:,1)=unique_sample_names';
table_initialization_data(:,2)=num2cell(ones(table_length,1));
table_initialization_data(:,3)=num2cell(zeros(table_length,1));
table_initialization_data(:,4)=num2cell(120*ones(table_length,1));
table_initialization_data(:,5)={'1,2'};
table_initialization_data(:,6)=num2cell(60*ones(table_length,1));
set(handles.sample_table,'Data',table_initialization_data)

% --- Executes on button press in new_data_dir.
function new_data_dir_Callback(hObject, eventdata, handles)
% hObject    handle to new_data_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Obtain the data directory to save the rebinned data
handles.data.new_data_dir=uigetdir('Pick directory to save rebinned data');
cd(handles.data.new_data_dir);
guidata(hObject,handles)

% Show new data directory name on the gui
set(handles.new_data_dir_text,'string',handles.data.new_data_dir)


% --- Executes on button press in convert_data.
function convert_data_Callback(hObject, eventdata, handles)
% hObject    handle to convert_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% disable the buttons and table on the gui during data processing
set(handles.old_data_dir,'Enable','Off')
set(handles.new_data_dir,'Enable','Off')
set(handles.sample_table,'Enable','Off')

cd(handles.data.old_data_dir);
table_data=get(handles.sample_table,'Data');
% identify the rows in the table containing sample names by removing all
% the non empty rows
non_empty_samples=find(~strcmp('',table_data(:,1)));
sample_names=table_data(non_empty_samples,1);
new_bin=cell2mat(table_data(non_empty_samples,2));
start_time=cell2mat(table_data(non_empty_samples,3)); % exclude the start time bin i.e. 10 sec means start at the next bin after 10sec.
duration_to_convert=cell2mat(table_data(non_empty_samples,4))
channels_to_convert=table_data(non_empty_samples,5);
new_trace_duration=cell2mat(table_data(non_empty_samples,6))
% Check that the duration to convert is an integer multiple of new trace
% duration before proceeding
if ~isempty(find(rem(duration_to_convert,new_trace_duration)))
    errordlg('duration to convert must be an integer multiple of new trace duration')
    set(handles.old_data_dir,'Enable','On')
    set(handles.new_data_dir,'Enable','On')            
    set(handles.sample_table,'Enable','On')
    return;
end

% Rebin data from different samples one by one
for sample=1:length(sample_names)
    current_channels_to_convert=str2num(channels_to_convert{sample})
    %use the get_smd_data_trace_stats_ver2p1 function to get bin time and
    %trace duration for data to be rebinned using 1st data trace for the
    %first channel to convert
    [old_bin_time,old_data_trace_duration]=get_smd_data_trace_stats_ver2p1(strcat(handles.data.old_data_dir,'\',sample_names{sample},'-ch',num2str(current_channels_to_convert(1)),'-1.txt'));    
    
    % Check that the new data bin time is an integer multiple of old data
    % bin time
    if ~isempty(find(rem(new_bin(sample),old_bin_time)))
        errordlg('new data bin time must be an integer multiple of old data bin time')
        set(handles.old_data_dir,'Enable','On')
        set(handles.new_data_dir,'Enable','On')            
        set(handles.sample_table,'Enable','On')
        return;
    end
    
    
    number_of_new_data_traces=floor(duration_to_convert(sample)/new_trace_duration(sample))
    % collect data for each new data trace
    for data_trace=1:number_of_new_data_traces
        % starting_time_point and ending_time_point are in secs for each
        % new data trace.
        starting_time_point=start_time(sample)+(data_trace-1)*new_trace_duration(sample);
        ending_time_point=starting_time_point+new_trace_duration(sample);
        % if the starting point is an integer multiple of old trace
        % duration, start reading from the next old data trace as the
        % quotient of starting point/old trace duration
        if rem(starting_time_point/old_data_trace_duration,1)==0
            old_data_traces_to_read=[ceil(starting_time_point/old_data_trace_duration)+1:ceil(ending_time_point/old_data_trace_duration)]        
        else
            old_data_traces_to_read=[ceil(starting_time_point/old_data_trace_duration):ceil(ending_time_point/old_data_trace_duration)]
        end
        
        for channel=1:length(current_channels_to_convert)
            for trace_to_read=old_data_traces_to_read
                read_data=load(strcat(sample_names{sample},'-ch',num2str(current_channels_to_convert(channel)),'-',num2str(trace_to_read),'.txt'));
                % Remove the timepoints from the 2D data array, retaining
                % only photon counts
                read_data=read_data(:,2); 
                if trace_to_read==old_data_traces_to_read(1)
                    % while reading the first old data trace only retain
                    % the data from the starting time point
                    read_data=read_data(rem(starting_time_point,old_data_trace_duration)*1000/old_bin_time+1:end);
                    data_to_rebin=read_data;
                elseif trace_to_read==old_data_traces_to_read(end)
                    % while reading the last old data trace only retain
                    % data till the ending time point
                    if rem(ending_time_point,old_data_trace_duration)~=0
                        read_data=read_data(1:rem(ending_time_point,old_data_trace_duration)*1000/old_bin_time);
                    end
                    data_to_rebin(end+1:end+length(read_data))=read_data;
                else
                    data_to_rebin(end+1:end+length(read_data))=read_data;
                end
            end
            
            
            if new_bin(sample)~=old_bin_time
                % generate new data by reshaping old collected data such that
                % each column has data to be summed for a new bin and then
                % sum each column
                rebinned_data=sum(reshape(data_to_rebin,new_bin(sample)/old_bin_time,length(data_to_rebin)/(new_bin(sample)/old_bin_time)));
            else
                rebinned_data=data_to_rebin; % same bin just different data trace size
            end
            rebinned_data_filename=strcat(sample_names{sample},'-',num2str(start_time(sample)),'-',num2str(duration_to_convert(sample)),'-ch',num2str(current_channels_to_convert(channel)),'-',num2str(data_trace),'.txt');
            cd(handles.data.new_data_dir);
            dlmwrite(rebinned_data_filename,[[starting_time_point*1000+new_bin(sample):new_bin(sample):ending_time_point*1000]' rebinned_data'],'precision',10);
            cd(handles.data.old_data_dir);
        end
    end
end
                
set(handles.old_data_dir,'Enable','On')
set(handles.new_data_dir,'Enable','On')            
set(handles.sample_table,'Enable','On')
sprintf('data rebinning finished')
