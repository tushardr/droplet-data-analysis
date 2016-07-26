function varargout = expt_condn_sample_desc_gui_ver2p1(varargin)
% EXPT_CONDN_SAMPLE_DESC_GUI_VER2P1 MATLAB code for expt_condn_sample_desc_gui_ver2p1.fig
%      EXPT_CONDN_SAMPLE_DESC_GUI_VER2P1, by itself, creates a new EXPT_CONDN_SAMPLE_DESC_GUI_VER2P1 or raises the existing
%      singleton*.
%
%      H = EXPT_CONDN_SAMPLE_DESC_GUI_VER2P1 returns the handle to a new EXPT_CONDN_SAMPLE_DESC_GUI_VER2P1 or the handle to
%      the existing singleton*.
%
%      EXPT_CONDN_SAMPLE_DESC_GUI_VER2P1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPT_CONDN_SAMPLE_DESC_GUI_VER2P1.M with the given input arguments.
%
%      EXPT_CONDN_SAMPLE_DESC_GUI_VER2P1('Property','Value',...) creates a new EXPT_CONDN_SAMPLE_DESC_GUI_VER2P1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before expt_condn_sample_desc_gui_ver2p1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to expt_condn_sample_desc_gui_ver2p1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help expt_condn_sample_desc_gui_ver2p1

% Last Modified by GUIDE v2.5 08-Feb-2013 18:02:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @expt_condn_sample_desc_gui_ver2p1_OpeningFcn, ...
                   'gui_OutputFcn',  @expt_condn_sample_desc_gui_ver2p1_OutputFcn, ...
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


% --- Executes just before expt_condn_sample_desc_gui_ver2p1 is made visible.
function expt_condn_sample_desc_gui_ver2p1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to expt_condn_sample_desc_gui_ver2p1 (see VARARGIN)


% Set some defaults for the mini optical setup
set(handles.Laser1,'value',1)  %488nm
set(handles.Laser2,'value',3)  %552nm
set(handles.Laser3,'value',7)  % NA

set(handles.Ch1_APD,'value',3)  %8501_9280 Green channel APD on mini optical setup
set(handles.Ch2_APD,'value',9)  %24214_C8831 Orange channel APD on mini optical setup
set(handles.Ch3_APD,'value',10)  %NA Red channel APD on mini optical setup


% Choose default command line output for expt_condn_sample_desc_gui_ver2p1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes expt_condn_sample_desc_gui_ver2p1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = expt_condn_sample_desc_gui_ver2p1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in Laser1.
function Laser1_Callback(hObject, eventdata, handles)
% hObject    handle to Laser1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Laser1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Laser1


% --- Executes during object creation, after setting all properties.
function Laser1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Laser1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Laser2.
function Laser2_Callback(hObject, eventdata, handles)
% hObject    handle to Laser2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Laser2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Laser2


% --- Executes during object creation, after setting all properties.
function Laser2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Laser2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Laser3.
function Laser3_Callback(hObject, eventdata, handles)
% hObject    handle to Laser3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Laser3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Laser3


% --- Executes during object creation, after setting all properties.
function Laser3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Laser3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Main_dichroic_Callback(hObject, eventdata, handles)
% hObject    handle to Main_dichroic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Main_dichroic as text
%        str2double(get(hObject,'String')) returns contents of Main_dichroic as a double


% --- Executes during object creation, after setting all properties.
function Main_dichroic_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Main_dichroic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Emission_dichroic1_Callback(hObject, eventdata, handles)
% hObject    handle to Emission_dichroic1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Emission_dichroic1 as text
%        str2double(get(hObject,'String')) returns contents of Emission_dichroic1 as a double


% --- Executes during object creation, after setting all properties.
function Emission_dichroic1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Emission_dichroic1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Emission_dichroic2_Callback(hObject, eventdata, handles)
% hObject    handle to Emission_dichroic2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Emission_dichroic2 as text
%        str2double(get(hObject,'String')) returns contents of Emission_dichroic2 as a double


% --- Executes during object creation, after setting all properties.
function Emission_dichroic2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Emission_dichroic2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Ch1_APD.
function Ch1_APD_Callback(hObject, eventdata, handles)
% hObject    handle to Ch1_APD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Ch1_APD contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Ch1_APD


% --- Executes during object creation, after setting all properties.
function Ch1_APD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ch1_APD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Ch2_APD.
function Ch2_APD_Callback(hObject, eventdata, handles)
% hObject    handle to Ch2_APD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Ch2_APD contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Ch2_APD


% --- Executes during object creation, after setting all properties.
function Ch2_APD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ch2_APD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Ch3_APD.
function Ch3_APD_Callback(hObject, eventdata, handles)
% hObject    handle to Ch3_APD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Ch3_APD contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Ch3_APD


% --- Executes during object creation, after setting all properties.
function Ch3_APD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ch3_APD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bandpass1_center_Callback(hObject, eventdata, handles)
% hObject    handle to bandpass1_center (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bandpass1_center as text
%        str2double(get(hObject,'String')) returns contents of bandpass1_center as a double


% --- Executes during object creation, after setting all properties.
function bandpass1_center_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bandpass1_center (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bandpass2_center_Callback(hObject, eventdata, handles)
% hObject    handle to bandpass2_center (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bandpass2_center as text
%        str2double(get(hObject,'String')) returns contents of bandpass2_center as a double


% --- Executes during object creation, after setting all properties.
function bandpass2_center_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bandpass2_center (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bandpass3_center_Callback(hObject, eventdata, handles)
% hObject    handle to bandpass3_center (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bandpass3_center as text
%        str2double(get(hObject,'String')) returns contents of bandpass3_center as a double


% --- Executes during object creation, after setting all properties.
function bandpass3_center_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bandpass3_center (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bandpass1_bandwidth_Callback(hObject, eventdata, handles)
% hObject    handle to bandpass1_bandwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bandpass1_bandwidth as text
%        str2double(get(hObject,'String')) returns contents of bandpass1_bandwidth as a double


% --- Executes during object creation, after setting all properties.
function bandpass1_bandwidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bandpass1_bandwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bandpass2_bandwidth_Callback(hObject, eventdata, handles)
% hObject    handle to bandpass2_bandwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bandpass2_bandwidth as text
%        str2double(get(hObject,'String')) returns contents of bandpass2_bandwidth as a double


% --- Executes during object creation, after setting all properties.
function bandpass2_bandwidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bandpass2_bandwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bandpass3_bandwidth_Callback(hObject, eventdata, handles)
% hObject    handle to bandpass3_bandwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bandpass3_bandwidth as text
%        str2double(get(hObject,'String')) returns contents of bandpass3_bandwidth as a double


% --- Executes during object creation, after setting all properties.
function bandpass3_bandwidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bandpass3_bandwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Expt_title_Callback(hObject, eventdata, handles)
% hObject    handle to Expt_title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Expt_title as text
%        str2double(get(hObject,'String')) returns contents of Expt_title as a double


% --- Executes during object creation, after setting all properties.
function Expt_title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Expt_title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_data.
function save_data_Callback(hObject, eventdata, handles)
% hObject    handle to save_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% data from drop_down_menus
laser_menu={'488nm','532nm','552nm','561nm','633nm','640nm','NA'};
APD_menu={'18558_C1911','13793_B1633','8501_9280','6886_7592','9913_A6602','9328_A1476','10103_A6906','10282_A7169','24214_C8831','NA'};

expt_conditions_sample_desc.Laser1=laser_menu{get(handles.Laser1,'value')};
expt_conditions_sample_desc.Laser2=laser_menu{get(handles.Laser2,'value')};
expt_conditions_sample_desc.Laser3=laser_menu{get(handles.Laser3,'value')};

expt_conditions_sample_desc.Ch1_APD=APD_menu{get(handles.Ch1_APD,'value')};
expt_conditions_sample_desc.Ch2_APD=APD_menu{get(handles.Ch2_APD,'value')};
expt_conditions_sample_desc.Ch3_APD=APD_menu{get(handles.Ch3_APD,'value')};

expt_conditions_sample_desc.bandpass1_center=str2double(get(handles.bandpass1_center,'string'));
expt_conditions_sample_desc.bandpass1_bandwidth=str2double(get(handles.bandpass1_bandwidth,'string'));
expt_conditions_sample_desc.bandpass2_center=str2double(get(handles.bandpass2_center,'string'));
expt_conditions_sample_desc.bandpass2_bandwidth=str2double(get(handles.bandpass2_bandwidth,'string'));
expt_conditions_sample_desc.bandpass3_center=str2double(get(handles.bandpass3_center,'string'));
expt_conditions_sample_desc.bandpass3_bandwidth=str2double(get(handles.bandpass3_bandwidth,'string'));

expt_conditions_sample_desc.Main_dichroic=get(handles.Main_dichroic,'string');
expt_conditions_sample_desc.Emission_dichroic1=get(handles.Emission_dichroic1,'string');
expt_conditions_sample_desc.Emission_dichroic2=get(handles.Emission_dichroic2,'string');

expt_conditions_sample_desc.Expt_title=get(handles.Expt_title,'string');
expt_conditions_sample_desc.data_directory=get(handles.data_dir_text,'string');

sample_names_desc=get(handles.sample_table,'data');
non_empty_samples=find(~strcmp('',sample_names_desc(:,1)));

% replace all '-' in sample names to underscores since matlab doesn't allow
% '-' in structure names
sample_names_desc(non_empty_samples,1)=regexprep(sample_names_desc(non_empty_samples,1),'-','_');

expt_conditions_sample_desc.sample_names=sample_names_desc(non_empty_samples,1);
expt_conditions_sample_desc.sample_desc=sample_names_desc(non_empty_samples,2);
setappdata(0,'expt_conditions_sample_desc',expt_conditions_sample_desc)

expt_conditions_sample_desc_fields=fieldnames(expt_conditions_sample_desc);

% Remove sample_names and sample_desc from the fields since they cant be
% written to file in a loop
expt_conditions_sample_desc_fields(strcmpi('sample_names',expt_conditions_sample_desc_fields))=[];
expt_conditions_sample_desc_fields(strcmpi('sample_desc',expt_conditions_sample_desc_fields))=[];


ecs_fid=fopen(get(handles.ecs_file,'string'),'w+');

for field=1:length(expt_conditions_sample_desc_fields)
    if isnumeric(expt_conditions_sample_desc.(expt_conditions_sample_desc_fields{field}))
        fprintf(ecs_fid,strcat(expt_conditions_sample_desc_fields{field},' : ',num2str(expt_conditions_sample_desc.(expt_conditions_sample_desc_fields{field})),'\n'));        
    else
        fprintf(ecs_fid,strcat(expt_conditions_sample_desc_fields{field},' : ',expt_conditions_sample_desc.(expt_conditions_sample_desc_fields{field}),'\n'));
    end
end

fprintf(ecs_fid,'\n \n')
for sample=1:length(expt_conditions_sample_desc.sample_names)
    fprintf(ecs_fid,strcat(expt_conditions_sample_desc.sample_names{sample},'\n'));
    fprintf(ecs_fid,strcat(expt_conditions_sample_desc.sample_desc{sample},'\n \n'));
end    

fclose(ecs_fid)

close(gcf)


% --- Executes on button press in data_dir.
function data_dir_Callback(hObject, eventdata, handles)
% hObject    handle to data_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data_dir=uigetdir('D:\mini optical setup data','Please pick the data directory');
%unique_sample_names=identify_unique_sample_names_ver2p1(data_dir,'*.txt','-\d*-\d*-ch\d*-\d*.txt');
unique_sample_names=identify_unique_sample_names_ver2p1(data_dir,'*.txt','-ch\d*-\d*.txt');
table_length=length(unique_sample_names);
table_initialization_data=cell(table_length,2);
table_initialization_data(:,1)=unique_sample_names';
table_initialization_data(:,2)=unique_sample_names';
set(handles.sample_table,'Data',table_initialization_data)
set(handles.data_dir_text,'string',data_dir)



function ecs_file_Callback(hObject, eventdata, handles)
% hObject    handle to ecs_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ecs_file as text
%        str2double(get(hObject,'String')) returns contents of ecs_file as a double


% --- Executes during object creation, after setting all properties.
function ecs_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ecs_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
