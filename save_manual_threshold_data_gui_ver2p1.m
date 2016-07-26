function varargout = save_manual_threshold_data_gui_ver2p1(varargin)
% SAVE_MANUAL_THRESHOLD_DATA_GUI_VER2P1 MATLAB code for save_manual_threshold_data_gui_ver2p1.fig
%      SAVE_MANUAL_THRESHOLD_DATA_GUI_VER2P1, by itself, creates a new SAVE_MANUAL_THRESHOLD_DATA_GUI_VER2P1 or raises the existing
%      singleton*.
%
%      H = SAVE_MANUAL_THRESHOLD_DATA_GUI_VER2P1 returns the handle to a new SAVE_MANUAL_THRESHOLD_DATA_GUI_VER2P1 or the handle to
%      the existing singleton*.
%
%      SAVE_MANUAL_THRESHOLD_DATA_GUI_VER2P1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAVE_MANUAL_THRESHOLD_DATA_GUI_VER2P1.M with the given input arguments.
%
%      SAVE_MANUAL_THRESHOLD_DATA_GUI_VER2P1('Property','Value',...) creates a new SAVE_MANUAL_THRESHOLD_DATA_GUI_VER2P1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before save_manual_threshold_data_gui_ver2p1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to save_manual_threshold_data_gui_ver2p1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help save_manual_threshold_data_gui_ver2p1

% Last Modified by GUIDE v2.5 05-Aug-2013 01:47:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @save_manual_threshold_data_gui_ver2p1_OpeningFcn, ...
                   'gui_OutputFcn',  @save_manual_threshold_data_gui_ver2p1_OutputFcn, ...
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


% --- Executes just before save_manual_threshold_data_gui_ver2p1 is made visible.
function save_manual_threshold_data_gui_ver2p1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to save_manual_threshold_data_gui_ver2p1 (see VARARGIN)

manual_thresholds_initialization_data=varargin{1};
% With normalized units, the range of the figure (width and height) goes
% from 0 to 1. 1 being width/height of the screen
set(handles.figure1,'Units','normalized')
% Position = [(left bottom x,y),width,height) 
set(handles.figure1,'Position',[.25 .25 .5 .5])

% Initialize the threshold table
set(handles.threshold_table,'Data',manual_thresholds_initialization_data)
set(handles.threshold_table,'Units','normalized')

columneditable_array=true(1,size(manual_thresholds_initialization_data,2)); % This makes all columns editable
columneditable_array(1)=false; % This makes first column non editable
set(handles.threshold_table,'ColumnEditable',columneditable_array)
set(handles.threshold_table,'Position',[.25 .25 .5 .5])

set(handles.save_button,'Units','normalized')
set(handles.save_button,'Position',[.25 .1 .5 .1])

% Choose default command line output for save_manual_threshold_data_gui_ver2p1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes save_manual_threshold_data_gui_ver2p1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = save_manual_threshold_data_gui_ver2p1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

manual_threshold_filename=strcat('manual_thresholds_file.xlsx');
threshold_data=get(handles.threshold_table,'Data');
xlswrite(manual_threshold_filename,threshold_data);
% Generate manual_thresholds structure in the memory, containing the manual
% threshold data for use during further data analysis
setappdata(0,'manual_thresholds',threshold_data);
