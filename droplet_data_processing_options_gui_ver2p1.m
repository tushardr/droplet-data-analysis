function varargout = droplet_data_processing_options_gui_ver2p1(varargin)
% DROPLET_DATA_PROCESSING_OPTIONS_GUI_VER2P1 MATLAB code for droplet_data_processing_options_gui_ver2p1.fig
%      DROPLET_DATA_PROCESSING_OPTIONS_GUI_VER2P1, by itself, creates a new DROPLET_DATA_PROCESSING_OPTIONS_GUI_VER2P1 or raises the existing
%      singleton*.
%
%      H = DROPLET_DATA_PROCESSING_OPTIONS_GUI_VER2P1 returns the handle to a new DROPLET_DATA_PROCESSING_OPTIONS_GUI_VER2P1 or the handle to
%      the existing singleton*.
%
%      DROPLET_DATA_PROCESSING_OPTIONS_GUI_VER2P1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DROPLET_DATA_PROCESSING_OPTIONS_GUI_VER2P1.M with the given input arguments.
%
%      DROPLET_DATA_PROCESSING_OPTIONS_GUI_VER2P1('Property','Value',...) creates a new DROPLET_DATA_PROCESSING_OPTIONS_GUI_VER2P1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before droplet_data_processing_options_gui_ver2p1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to droplet_data_processing_options_gui_ver2p1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help droplet_data_processing_options_gui_ver2p1

% Last Modified by GUIDE v2.5 05-Sep-2013 15:20:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @droplet_data_processing_options_gui_ver2p1_OpeningFcn, ...
                   'gui_OutputFcn',  @droplet_data_processing_options_gui_ver2p1_OutputFcn, ...
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


% --- Executes just before droplet_data_processing_options_gui_ver2p1 is made visible.
function droplet_data_processing_options_gui_ver2p1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to droplet_data_processing_options_gui_ver2p1 (see VARARGIN)

% Set some defaults on the GUI
set(handles.APD_correction,'value',1) % Set APD correction to 'yes'
set(handles.Droplet_Height_filtering,'value',2) % Set droplet height filtering to 'no'
set(handles.Droplet_Height_filtering_type,'value',1) % Set droplet height filtering type to 'Avg'
set(handles.Droplet_Time_filtering,'value',2) % Set droplet time filtering to 'no'
set(handles.count_peaks,'value',2) %Set count_peaks to 'no'
set(handles.Burst_analysis,'value',1) % Set burst analysis to 'yes'
set(handles.droplet_data_synchronized,'value',1) % Set droplet data synchronized to 'yes'
set(handles.Droplet_counting_threshold,'value',2) % Set droplet counting threshold to 'manual'
set(handles.Droplet_reference_channel,'value',2) % Set droplet reference channel to channel number 2

% Choose default command line output for droplet_data_processing_options_gui_ver2p1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes droplet_data_processing_options_gui_ver2p1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = droplet_data_processing_options_gui_ver2p1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.data_processing_options;


% --- Executes on selection change in APD_correction.
function APD_correction_Callback(hObject, eventdata, handles)
% hObject    handle to APD_correction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns APD_correction contents as cell array
%        contents{get(hObject,'Value')} returns selected item from APD_correction


% --- Executes during object creation, after setting all properties.
function APD_correction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to APD_correction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Droplet_Time_filtering.
function Droplet_Time_filtering_Callback(hObject, eventdata, handles)
% hObject    handle to Droplet_Time_filtering (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Droplet_Time_filtering contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Droplet_Time_filtering


% --- Executes during object creation, after setting all properties.
function Droplet_Time_filtering_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Droplet_Time_filtering (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Droplet_Height_filtering.
function Droplet_Height_filtering_Callback(hObject, eventdata, handles)
% hObject    handle to Droplet_Height_filtering (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Droplet_Height_filtering contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Droplet_Height_filtering


% --- Executes during object creation, after setting all properties.
function Droplet_Height_filtering_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Droplet_Height_filtering (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Peak_counting_threshold.
function Peak_counting_threshold_Callback(hObject, eventdata, handles)
% hObject    handle to Peak_counting_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Peak_counting_threshold contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Peak_counting_threshold


% --- Executes during object creation, after setting all properties.
function Peak_counting_threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Peak_counting_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Burst_analysis.
function Burst_analysis_Callback(hObject, eventdata, handles)
% hObject    handle to Burst_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Burst_analysis contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Burst_analysis


% --- Executes during object creation, after setting all properties.
function Burst_analysis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Burst_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function droplet_width_min_Callback(hObject, eventdata, handles)
% hObject    handle to droplet_width_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of droplet_width_min as text
%        str2double(get(hObject,'String')) returns contents of droplet_width_min as a double


% --- Executes during object creation, after setting all properties.
function droplet_width_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to droplet_width_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function droplet_width_max_Callback(hObject, eventdata, handles)
% hObject    handle to droplet_width_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of droplet_width_max as text
%        str2double(get(hObject,'String')) returns contents of droplet_width_max as a double


% --- Executes during object creation, after setting all properties.
function droplet_width_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to droplet_width_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function droplet_height_min_Callback(hObject, eventdata, handles)
% hObject    handle to droplet_height_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of droplet_height_min as text
%        str2double(get(hObject,'String')) returns contents of droplet_height_min as a double


% --- Executes during object creation, after setting all properties.
function droplet_height_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to droplet_height_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function droplet_height_max_Callback(hObject, eventdata, handles)
% hObject    handle to droplet_height_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of droplet_height_max as text
%        str2double(get(hObject,'String')) returns contents of droplet_height_max as a double


% --- Executes during object creation, after setting all properties.
function droplet_height_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to droplet_height_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Peak_counting_baseline_Callback(hObject, eventdata, handles)
% hObject    handle to Peak_counting_baseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Peak_counting_baseline as text
%        str2double(get(hObject,'String')) returns contents of Peak_counting_baseline as a double


% --- Executes during object creation, after setting all properties.
function Peak_counting_baseline_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Peak_counting_baseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_data.
function save_data_Callback(hObject, eventdata, handles)
% hObject    handle to save_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.APD_correction,'value')==1
    data_processing_options.APD_correction='yes';
else
    data_processing_options.APD_correction='no';
end

if get(handles.Droplet_Height_filtering,'value')==1
    data_processing_options.Droplet_Height_filtering='yes';

    droplet_height_filtering_height_type_strings=get(handles.Droplet_Height_filtering_type,'String');
    data_processing_options.Droplet_Height_filtering_type=droplet_height_filtering_height_type_strings{get(handles.Droplet_Height_filtering_type,'value')};

    data_processing_options.droplet_height_min=str2double(get(handles.droplet_height_min,'string'));
    data_processing_options.droplet_height_max=str2double(get(handles.droplet_height_max,'string'));
else
    data_processing_options.Droplet_Height_filtering='no';
end

if get(handles.Droplet_Time_filtering,'value')==1
    data_processing_options.Droplet_Time_filtering='yes';
    data_processing_options.droplet_width_min=str2double(get(handles.droplet_width_min,'string'));
    data_processing_options.droplet_width_max=str2double(get(handles.droplet_width_max,'string'));
else
    data_processing_options.Droplet_Time_filtering='no';
end

if get(handles.count_peaks,'value')==1
    data_processing_options.count_peaks='yes';
    if get(handles.Peak_counting_threshold,'value')==1
        data_processing_options.Peak_counting_threshold='Auto';
        data_processing_options.Peak_counting_baseline=str2double(get(handles.Peak_counting_baseline,'string'));
    else
        data_processing_options.Peak_counting_threshold='Manual';
    end    
else
    data_processing_options.count_peaks='no';
end

if get(handles.Burst_analysis,'value')==1
    data_processing_options.Burst_analysis='yes';
else
    data_processing_options.Burst_analysis='no';
end

if get(handles.droplet_data_synchronized,'value')==1
    data_processing_options.droplet_data_synchronized='yes';
else
    data_processing_options.droplet_data_synchronized='no';
end

data_processing_options.data_channels=str2num(get(handles.data_channels_string,'string'));

if get(handles.Droplet_counting_threshold,'value')==1
    data_processing_options.Droplet_counting_threshold='Auto';
    data_processing_options.Droplet_counting_baseline=str2double(get(handles.Droplet_counting_baseline,'string'));
else
    data_processing_options.Droplet_counting_threshold='Manual';
end

data_processing_options.Min_gap_betn_droplets=str2double(get(handles.Min_gap_betn_droplets,'string'));
data_processing_options.Droplet_reference_channel=get(handles.Droplet_reference_channel,'value');
data_processing_options.Reference_drop_size_in_msec=str2double(get(handles.Reference_drop_size_in_msec,'string'));

setappdata(0,'data_processing_options',data_processing_options);

data_processing_options_fields=fieldnames(data_processing_options);

dpo_fid=fopen(get(handles.dpo_file,'string'),'w+');

for field=1:length(data_processing_options_fields)
    fprintf(dpo_fid,strcat(data_processing_options_fields{field},' : ',num2str(data_processing_options.(data_processing_options_fields{field})),'\n'));
end

fclose(dpo_fid)

% --- Executes on selection change in Droplet_counting_threshold.
function Droplet_counting_threshold_Callback(hObject, eventdata, handles)
% hObject    handle to Droplet_counting_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Droplet_counting_threshold contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Droplet_counting_threshold


% --- Executes during object creation, after setting all properties.
function Droplet_counting_threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Droplet_counting_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Min_gap_betn_droplets_Callback(hObject, eventdata, handles)
% hObject    handle to Min_gap_betn_droplets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Min_gap_betn_droplets as text
%        str2double(get(hObject,'String')) returns contents of Min_gap_betn_droplets as a double


% --- Executes during object creation, after setting all properties.
function Min_gap_betn_droplets_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Min_gap_betn_droplets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Droplet_reference_channel.
function Droplet_reference_channel_Callback(hObject, eventdata, handles)
% hObject    handle to Droplet_reference_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Droplet_reference_channel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Droplet_reference_channel


% --- Executes during object creation, after setting all properties.
function Droplet_reference_channel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Droplet_reference_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Droplet_counting_baseline_Callback(hObject, eventdata, handles)
% hObject    handle to Droplet_counting_baseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Droplet_counting_baseline as text
%        str2double(get(hObject,'String')) returns contents of Droplet_counting_baseline as a double


% --- Executes during object creation, after setting all properties.
function Droplet_counting_baseline_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Droplet_counting_baseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Reference_drop_size_in_msec_Callback(hObject, eventdata, handles)
% hObject    handle to Reference_drop_size_in_msec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Reference_drop_size_in_msec as text
%        str2double(get(hObject,'String')) returns contents of Reference_drop_size_in_msec as a double


% --- Executes during object creation, after setting all properties.
function Reference_drop_size_in_msec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Reference_drop_size_in_msec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in old_data_options_file.
function old_data_options_file_Callback(hObject, eventdata, handles)
% hObject    handle to old_data_options_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Choose a data processing options file and read the data processing
% options from it
data_processing_options_file=uigetfile('Pick a data options file');
data_processing_options=read_droplet_data_processing_options_ver2p1(data_processing_options_file)

% Updata all the data processing options on the gui one by one
if isfield(data_processing_options,'APD_correction')
    if strcmpi(data_processing_options.APD_correction,'yes')
        set(handles.APD_correction,'value',1);
    else
        set(handles.APD_correction,'value',2);
    end
end

if isfield(data_processing_options,'Droplet_Height_filtering')
    if strcmpi(data_processing_options.Droplet_Height_filtering,'yes')
        set(handles.Droplet_Height_filtering,'value',1);
        
        droplet_height_filtering_height_type_strings=get(handles.Droplet_Height_filtering_type,'String');
        set(handles.Droplet_Height_filtering_type,'value',strcmp(data_processing_options.Droplet_Height_filtering_type,droplet_height_filtering_height_type_strings))
        
        
        set(handles.droplet_height_min,'string',num2str(data_processing_options.droplet_height_min))
        set(handles.droplet_height_max,'string',num2str(data_processing_options.droplet_height_max))
    else
        set(handles.Droplet_Height_filtering,'value',2);
    end
end

if isfield(data_processing_options,'Droplet_Time_filtering')
    if strcmpi(data_processing_options.Droplet_Time_filtering,'yes')
        set(handles.Droplet_Time_filtering,'value',1);
        set(handles.droplet_width_min,'string',num2str(data_processing_options.droplet_width_min))
        set(handles.droplet_width_max,'string',num2str(data_processing_options.droplet_width_max))
    else
        set(handles.Droplet_Time_filtering,'value',2);
    end
end

if isfield(data_processing_options,'count_peaks')
    if strcmpi(data_processing_options.count_peaks,'yes')
        set(handles.count_peaks,'value',1);
        if strcmpi(data_processing_options.Peak_counting_threshold,'auto')
            set(handles.Peak_counting_threshold,'value',1);
            set(handles.Peak_counting_baseline,'string',num2str(data_processing_options.Peak_counting_baseline))
        else
            set(handles.Peak_counting_threshold,'value',2);
        end
    else
        set(handles.count_peaks,'value',2);
    end
end

if isfield(data_processing_options,'Burst_analysis')
    if strcmpi(data_processing_options.Burst_analysis,'yes')
        set(handles.Burst_analysis,'value',1);
    else
        set(handles.Burst_analysis,'value',2);
    end
end

if isfield(data_processing_options,'droplet_data_synchronized')
    if strcmpi(data_processing_options.droplet_data_synchronized,'yes')
        set(handles.droplet_data_synchronized,'value',1);
    else
        set(handles.droplet_data_synchronized,'value',2);
    end
end

if isfield(data_processing_options,'data_channels')
    set(handles.data_channels_string,'String',num2str(data_processing_options.data_channels));
end

if isfield(data_processing_options,'Droplet_counting_threshold')
    if strcmpi(data_processing_options.Droplet_counting_threshold,'auto')
        set(handles.Droplet_counting_threshold,'value',1);
        set(handles.Droplet_counting_baseline,'string',num2str(data_processing_options.Droplet_counting_baseline))
    else
        set(handles.Droplet_counting_threshold,'value',2);
    end
end

if isfield(data_processing_options,'Droplet_reference_channel')
         set(handles.Droplet_reference_channel,'value',data_processing_options.Droplet_reference_channel);
end

if isfield(data_processing_options,'Min_gap_betn_droplets')
         set(handles.Min_gap_betn_droplets,'string',num2str(data_processing_options.Min_gap_betn_droplets));
end

if isfield(data_processing_options,'Reference_drop_size_in_msec')
         set(handles.Reference_drop_size_in_msec,'string',num2str(data_processing_options.Reference_drop_size_in_msec));
end

% --- Executes on selection change in droplet_data_synchronized.
function droplet_data_synchronized_Callback(hObject, eventdata, handles)
% hObject    handle to droplet_data_synchronized (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns droplet_data_synchronized contents as cell array
%        contents{get(hObject,'Value')} returns selected item from droplet_data_synchronized


% --- Executes during object creation, after setting all properties.
function droplet_data_synchronized_CreateFcn(hObject, eventdata, handles)
% hObject    handle to droplet_data_synchronized (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in count_peaks.
function count_peaks_Callback(hObject, eventdata, handles)
% hObject    handle to count_peaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns count_peaks contents as cell array
%        contents{get(hObject,'Value')} returns selected item from count_peaks


% --- Executes during object creation, after setting all properties.
function count_peaks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to count_peaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dpo_file_Callback(hObject, eventdata, handles)
% hObject    handle to dpo_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dpo_file as text
%        str2double(get(hObject,'String')) returns contents of dpo_file as a double


% --- Executes during object creation, after setting all properties.
function dpo_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dpo_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function data_channels_string_Callback(hObject, eventdata, handles)
% hObject    handle to data_channels_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of data_channels_string as text
%        str2double(get(hObject,'String')) returns contents of data_channels_string as a double


% --- Executes during object creation, after setting all properties.
function data_channels_string_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data_channels_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Droplet_Height_filtering_type.
function Droplet_Height_filtering_type_Callback(hObject, eventdata, handles)
% hObject    handle to Droplet_Height_filtering_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Droplet_Height_filtering_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Droplet_Height_filtering_type


% --- Executes during object creation, after setting all properties.
function Droplet_Height_filtering_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Droplet_Height_filtering_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
