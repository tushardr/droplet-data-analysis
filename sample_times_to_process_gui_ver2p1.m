function varargout = sample_times_to_process_gui_ver2p1(varargin)
% SAMPLE_TIMES_TO_PROCESS_GUI_VER2P1 MATLAB code for sample_times_to_process_gui_ver2p1.fig
%      SAMPLE_TIMES_TO_PROCESS_GUI_VER2P1, by itself, creates a new SAMPLE_TIMES_TO_PROCESS_GUI_VER2P1 or raises the existing
%      singleton*.
%
%      H = SAMPLE_TIMES_TO_PROCESS_GUI_VER2P1 returns the handle to a new SAMPLE_TIMES_TO_PROCESS_GUI_VER2P1 or the handle to
%      the existing singleton*.
%
%      SAMPLE_TIMES_TO_PROCESS_GUI_VER2P1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAMPLE_TIMES_TO_PROCESS_GUI_VER2P1.M with the given input arguments.
%
%      SAMPLE_TIMES_TO_PROCESS_GUI_VER2P1('Property','Value',...) creates a new SAMPLE_TIMES_TO_PROCESS_GUI_VER2P1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sample_times_to_process_gui_ver2p1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sample_times_to_process_gui_ver2p1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sample_times_to_process_gui_ver2p1

% Last Modified by GUIDE v2.5 22-Jul-2013 14:59:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sample_times_to_process_gui_ver2p1_OpeningFcn, ...
                   'gui_OutputFcn',  @sample_times_to_process_gui_ver2p1_OutputFcn, ...
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


% --- Executes just before sample_times_to_process_gui_ver2p1 is made visible.
function sample_times_to_process_gui_ver2p1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sample_times_to_process_gui_ver2p1 (see VARARGIN)

% Choose default command line output for sample_times_to_process_gui_ver2p1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sample_times_to_process_gui_ver2p1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
expt_conditions_sample_desc=getappdata(0,'expt_conditions_sample_desc');
table_length=length(expt_conditions_sample_desc.sample_names);
table_initialization_data=cell(table_length,2);
table_initialization_data(:,1)=expt_conditions_sample_desc.sample_names';
table_initialization_data(:,2)={'[0-10];[10-20]'};
set(handles.sample_table,'Data',table_initialization_data)


% --- Outputs from this function are returned to the command line.
function varargout = sample_times_to_process_gui_ver2p1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in save_data.
function save_data_Callback(hObject, eventdata, handles)
% hObject    handle to save_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
expt_conditions_sample_desc=getappdata(0,'expt_conditions_sample_desc');
table_length=length(expt_conditions_sample_desc.sample_names);
table_data=get(handles.sample_table,'Data');

expt_conditions_sample_desc.extended_sample_names={}

for sample=1:table_length
    % separate different time ranges entered by the user for each sample
    sample_time_range=my_strtok(table_data{sample,2},';');
    % the time range variable stores the number of different data time ranges
    % processed for a particular sample
    expt_conditions_sample_desc.time_range(sample)=length(sample_time_range);
    % Strip the time range strings of brackets
    sample_time_range=regexprep(sample_time_range,'[','');
    sample_time_range=regexprep(sample_time_range,']','');
    % replace '-' with underscore since matlab doesn't allow '-' in
    % structure names
    sample_time_range=regexprep(sample_time_range,'-','_');
    for time_range=1:length(sample_time_range)
        expt_conditions_sample_desc.extended_sample_names(end+1)={strcat(expt_conditions_sample_desc.sample_names{sample},'_',sample_time_range{time_range})};
    end
end

setappdata(0,'expt_conditions_sample_desc',expt_conditions_sample_desc)
data_processing_options=getappdata(0,'data_processing_options');

% Generate a manual thresholds file if manual thresholding is requested
manual_thresholding_required=0; % Use this variable to decide if the call to the manual threshold data gui is necessary

manual_thresholds_initialization_data=cell(length(expt_conditions_sample_desc.extended_sample_names)+1,1);
manual_thresholds_initialization_data(1,1)={'Sample Names'};
manual_thresholds_initialization_data(2:end,1)=expt_conditions_sample_desc.extended_sample_names;

if strcmpi(data_processing_options.Droplet_counting_threshold,'manual')
    manual_thresholds_initialization_data(1,2)={'droplet baseline'};
    manual_thresholds_initialization_data(2:end,2)={0};
    manual_thresholding_required=1;
end

if strcmpi(data_processing_options.count_peaks,'yes')
    if strcmpi(data_processing_options.Peak_counting_threshold,'manual')
        for channel=1:length(data_processing_options.data_channels)
            current_column=size(manual_thresholds_initialization_data,2)+channel;
            manual_thresholds_initialization_data(1,current_column)={strcat('Ch',num2str(data_processing_options.data_channels(channel)))};
            manual_thresholds_initialization_data(2:end,current_column)={0};
        end
        manual_thresholding_required=1;
    end
end

if manual_thresholding_required
    save_manual_threshold_data_gui_ver2p1(manual_thresholds_initialization_data);
end
