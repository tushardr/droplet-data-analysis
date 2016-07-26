function varargout = process_droplet_data_ver2p1(varargin)
% PROCESS_DROPLET_DATA_VER2P1 MATLAB code for process_droplet_data_ver2p1.fig
%      PROCESS_DROPLET_DATA_VER2P1, by itself, creates a new PROCESS_DROPLET_DATA_VER2P1 or raises the existing
%      singleton*.
%
%      H = PROCESS_DROPLET_DATA_VER2P1 returns the handle to a new PROCESS_DROPLET_DATA_VER2P1 or the handle to
%      the existing singleton*.
%
%      PROCESS_DROPLET_DATA_VER2P1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROCESS_DROPLET_DATA_VER2P1.M with the given input arguments.
%
%      PROCESS_DROPLET_DATA_VER2P1('Property','Value',...) creates a new PROCESS_DROPLET_DATA_VER2P1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before process_droplet_data_ver2p1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to process_droplet_data_ver2p1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help process_droplet_data_ver2p1

% Last Modified by GUIDE v2.5 07-Feb-2013 14:26:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @process_droplet_data_ver2p1_OpeningFcn, ...
                   'gui_OutputFcn',  @process_droplet_data_ver2p1_OutputFcn, ...
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


% --- Executes just before process_droplet_data_ver2p1 is made visible.
function process_droplet_data_ver2p1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to process_droplet_data_ver2p1 (see VARARGIN)

% Choose default command line output for process_droplet_data_ver2p1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes process_droplet_data_ver2p1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = process_droplet_data_ver2p1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes on button press in call_expt_condn_gui.
function call_expt_condn_gui_Callback(hObject, eventdata, handles)
% hObject    handle to call_expt_condn_gui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
expt_condn_sample_desc_gui_ver2p1;

% --- Executes on button press in call_data_processing_gui.
function call_data_processing_gui_Callback(hObject, eventdata, handles)
% hObject    handle to call_data_processing_gui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
droplet_data_processing_options_gui_ver2p1;


% --- Executes on button press in call_sample_time_point_gui.
function call_sample_time_point_gui_Callback(hObject, eventdata, handles)
% hObject    handle to call_sample_time_point_gui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sample_times_to_process_gui_ver2p1;

% --- Executes on button press in call_analyse_droplet_data_gui.
function call_analyse_droplet_data_gui_Callback(hObject, eventdata, handles)
% hObject    handle to call_analyse_droplet_data_gui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

analyse_droplet_data_gui_ver2p1;
%rmappdata(0,'expt_conditions_sample_desc')
%rmappdata(0,'data_processing_options')
%rmappdata(0,'manual_thresholds')
% --- Executes on button press in call_droplet_data_plots_gui.
function call_droplet_data_plots_gui_Callback(hObject, eventdata, handles)
% hObject    handle to call_droplet_data_plots_gui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gen_droplet_data_plots_gui_ver2p4;

% --- Executes on button press in call_expt_report_gui.
function call_expt_report_gui_Callback(hObject, eventdata, handles)
% hObject    handle to call_expt_report_gui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
