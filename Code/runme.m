function varargout = runme(varargin)
% RUNME MATLAB code for runme.fig
%      RUNME, by itself, creates a new RUNME or raises the existing
%      singleton*.
%
%      H = RUNME returns the handle to a new RUNME or the handle to
%      the existing singleton*.
%
%      RUNME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUNME.M with the given input arguments.
%
%      RUNME('Property','Value',...) creates a new RUNME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before runme_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to runme_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help runme

% Last Modified by GUIDE v2.5 01-Jul-2015 08:26:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @runme_OpeningFcn, ...
    'gui_OutputFcn',  @runme_OutputFcn, ...
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


% --- Executes just before runme is made visible.
function runme_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to runme (see VARARGIN)

% Choose default command line output for runme
handles.output = hObject;

% Update handles structure

handles.OutputFolder   =0;

handles.operation=0;
guidata(hObject, handles);
set(handles.of_BTN,'String','Output Folder') ;
set(handles.OpBtn,'Visible','off') ;
set(handles.DefCL,'Visible','off') ;
axes(handles.axes1);
text(0,0.5,strcat(['please define an output folder output folder first or choose using default files name']),'FontSize',30);
set(handles.DefCL,'Visible','off') ;
set(handles.StabRB,'String','Stabilization') ;
set(handles.bgRB,'String','Background Subtract') ;
set(handles.matRB,'String','Matting') ;
set(handles.trkRB,'String','Tracking') ;
set(handles.binRB,'String','Binary') ;
set(handles.inRB,'String','Input') ;


set(handles.StabRB,'Visible','off') ;
set(handles.bgRB,'Visible','off') ;
set(handles.matRB,'Visible','off') ;
set(handles.trkRB,'Visible','off') ;
set(handles.param1L,'Visible','off') ;
set(handles.param2L,'Visible','off') ;
set(handles.param3L,'Visible','off') ;
set(handles.param4L,'Visible','off') ;
set(handles.param1V,'Visible','off') ;
set(handles.param2V,'Visible','off') ;
set(handles.param3V,'Visible','off') ;
set(handles.param4V,'Visible','off') ;
set(handles.param1B,'Visible','off') ;
set(handles.param2B,'Visible','off') ;
set(handles.param3B,'Visible','off') ;
set(handles.param4B,'Visible','off') ;
set(handles.axes2,'Visible','off');
set(handles.progress,'Visible','off');
set(handles.inRB,'Visible','off');
set(handles.binRB,'Visible','off');
set(handles.qBTN,'Visible','on');
set(handles.qBTN,'String','Exit');


set(handles.VidCL,'Value',0)
% UIWAIT makes runme wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = runme_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in OpBtn.
function OpBtn_Callback(hObject, eventdata, handles)
% hObject    handle to OpBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    axes(handles.axes1);
    cla(handles.axes1);
    guidata(hObject, handles);
    if (handles.OutputFolder==0 | exist(handles.OutputFolder,'dir') ~= 7)
        set(hObject,'Visible','off');
        text(0,0.5,strcat(['there is no output folder']),'FontSize',50);
        return;
    end
    set(handles.axes2,'Visible','on');
    set(handles.progress,'Visible','on');
    %set(handles.text10,'String','complete');
    set(handles.progress,'String','');
    set(hObject,'Visible','off');
    set(handles.WatchBtn,'Visible','off');
    
    switch (handles.operation)
        
        case {1}
            if (get(handles.VidCL,'Value')==0)
                [FileName,PathName] = uigetfile({'*.*'}, 'Plesae choose an input video');
                inputVid_fN=strcat([PathName,'\\',FileName]);
            else
                inputVid_fN='..\\Input\\INPUT.avi';
            end
            L=str2double(get(handles.param1V,'String'));
            Stabilize_function(inputVid_fN,handles.OutputFolder,L,handles);
        case {2}
            if (get(handles.VidCL,'Value')==0)
                
                [FileName,PathName] =uigetfile({'*.*'}, 'Plesae choose a stabilized video');
                StabVid_fn=strcat([PathName,'\\',FileName]);
            else
                StabVid_fn='..\\Output\\stabilized.avi';
            end
            thH=str2double(get(handles.param1V,'String'));
            thS=str2double(get(handles.param2V,'String'));
            thV=str2double(get(handles.param3V,'String'));
            WinSize=str2double(get(handles.param2V,'String'));
            BG_sub_function(StabVid_fn,handles.OutputFolder,thH,thS,thV,handles);
        case {3}
            if (get(handles.VidCL,'Value')==0)
                
                [FileName,PathName]=uigetfile({'*.*'}, 'Plesae choose a stabilized video');
                StabVid_fn=strcat([PathName,'\\',FileName]);
                
                [FileName,PathName]=uigetfile({'*.*'}, 'Plesae choose a binary mask video');
                MaskVid_fn=strcat([PathName,'\\',FileName]);
                [FileName,PathName]=uigetfile({'*.*'}, 'Plesae choose a new background image');
                newBG=strcat([PathName,'\\',FileName]);
            else
                StabVid_fn='..\\Output\\stabilized.avi';
                MaskVid_fn='..\\Output\\binary.avi';
                newBG='..\\Input\\background.jpg';
            end
            WinSizeBG=str2double(get(handles.param1V,'String'));
            Rho4Undecided=str2double(get(handles.param2V,'String'));
            r=str2double(get(handles.param3V,'String'));
            Def_NumberOfScribllePoints=str2double(get(handles.param4V,'String'));
            MattingFunction(StabVid_fn,MaskVid_fn,newBG,handles.OutputFolder,...
                WinSizeBG,r,Rho4Undecided,Def_NumberOfScribllePoints,handles);
        case {4}
            if (get(handles.VidCL,'Value')==0)
                [FileName,PathName]=uigetfile({'*.*'}, 'Plesae choose a matting video');
                MatVid_fN=strcat([PathName,'\\',FileName]);
            else
                MatVid_fN='..\\Output\\matted.avi';
            end
            N=str2double(get(handles.param1V,'String'));
            TrackingFunction(MatVid_fN,handles.OutputFolder,N,handles);
    end
catch  ex
    disp(ex)
end
set(handles.axes2,'Visible','off');
set(handles.progress,'Visible','off');
axes(handles.axes2);
text(0,0.5,'complete');
set(hObject,'Visible','on');
set(handles.WatchBtn,'Visible','on');


% --- Executes on button press in WatchBtn.
function WatchBtn_Callback(hObject, eventdata, handles)
% hObject    handle to WatchBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    set(hObject,'Visible','off');
    set(handles.OpBtn,'Visible','off');
    if (get(handles.VidCL,'Value')==0)
        [videoFN,path]=uigetfile({'*.*'}, 'Plesae choose a stabilized video');
        videoFN=strcat(path,videoFN);
        if (~videoFN)
            return;
        end
        
    else
        switch (handles.operation)
            case {1}
                videoFN='..\\Input\\stabilized.avi';
            case {2}
                videoFN='..\\Output\\extracted.avi';
            case {3}
                videoFN='..\\Output\\matted.avi';
            case {4}
                videoFN='..\\Output\\OUTPUT.avi';
        end
        if (get(handles.inRB,'Value'))
            videoFN='..\\Input\\INPUT.avi';
        end
        if(get(handles.binRB,'Value'))
            videoFN='..\\Output\\binary.avi';
        end
        
    end
    axes(handles.axes1)
    if (exist(videoFN, 'file') == 2)
        set(handles.param1B,'Visible','off') ;
        set(handles.param2B,'Visible','off') ;
        set(handles.param3B,'Visible','off') ;
        set(handles.param4B,'Visible','off') ;
        inputVid=VideoReader(videoFN);
        fps=120;
        for ii=1:inputVid.NumberOfFrames
            imshow(inputVid.read(ii));
            pause(1/fps);
        end
    else
        axes(handles.axes1);
        text(0,0.5,strcat(['there is no file as ',videoFN]),'FontSize',50);
    end
    set(hObject,'Visible','on');
    set(handles.OpBtn,'Visible','on');
catch
end

% --- Executes on button press in StabRB.
function StabRB_Callback(hObject, eventdata, handles)
% hObject    handle to StabRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of StabRB
set(handles.OpBtn,'String','Stablization') ;
set(handles.OpBtn,'Visible','on') ;
handles.operation=1 ;

set(handles.StabRB,'Value',1) ;
set(handles.bgRB,'Value',0) ;
set(handles.matRB,'Value',0) ;
set(handles.trkRB,'Value',0) ;
set(handles.inRB,'Value',0) ;
set(handles.binRB,'Value',0) ;
set(handles.param1L,'Visible','on') ;
set(handles.param2L,'Visible','off') ;
set(handles.param3L,'Visible','off') ;
set(handles.param4L,'Visible','off') ;
set(handles.param1V,'Visible','on') ;
set(handles.param2V,'Visible','off') ;
set(handles.param3V,'Visible','off') ;
set(handles.param4V,'Visible','off') ;

set(handles.param1V,'String','5') ;
%set(handles.param2V,'String','80') ;

if (get(handles.DefCL,'Value')==0)
    set(handles.param1B,'Visible','on') ;
    set(handles.param2B,'Visible','off') ;
    set(handles.param3B,'Visible','off') ;
    set(handles.param4B,'Visible','off') ;
    
    set(handles.param1B,'Value',str2double(get(handles.param1V,'String'))) ;
    set(handles.param1B,'Min',1) ;
    set(handles.param1B,'Max',10)
    set(handles.param1B,'SliderStep',[1/9 1]) ;
    
    
    %     set(handles.param2B,'Value',str2double(get(handles.param2V,'String'))) ;
    %     set(handles.param2B,'Min',0) ;
    %     set(handles.param2B,'Max',100) ;
    %     set(handles.param2B,'SliderStep',[0.1 1]) ;
    
else
    set(handles.param1B,'Visible','off') ;
    set(handles.param2B,'Visible','off') ;
    set(handles.param3B,'Visible','off') ;
    set(handles.param4B,'Visible','off') ;
    set(handles.param1V,'Enable','off') ;
    set(handles.param2V,'Enable','off') ;
    set(handles.param3V,'Enable','off') ;
    set(handles.param4V,'Enable','off') ;
end
set(handles.param1L,'String','LK Levels');
% set(handles.param2L,'String','Match Features TH');
guidata(hObject, handles);


% --- Executes on button press in bgRB.
function bgRB_Callback(hObject, eventdata, handles)
% hObject    handle to bgRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bgRB
set(handles.OpBtn,'String','Background Subtraction') ;
set(handles.OpBtn,'Visible','on') ;
handles.operation=2 ;

set(handles.StabRB,'Value',0) ;
set(handles.bgRB,'Value',1) ;
set(handles.matRB,'Value',0) ;
set(handles.trkRB,'Value',0) ;
set(handles.inRB,'Value',0) ;
set(handles.binRB,'Value',0) ;
set(handles.param1L,'Visible','on') ;
set(handles.param2L,'Visible','on') ;
set(handles.param3L,'Visible','on') ;
set(handles.param4L,'Visible','off') ;
set(handles.param1V,'Visible','on') ;
set(handles.param2V,'Visible','on') ;
set(handles.param3V,'Visible','on') ;
set(handles.param4V,'Visible','off') ;

set(handles.param1V,'String','0.8') ;
set(handles.param2V,'String','0.6') ;
set(handles.param3V,'String','0.35') ;

if (get(handles.DefCL,'Value')==0)
    set(handles.param1B,'Visible','on') ;
    set(handles.param2B,'Visible','on') ;
    set(handles.param3B,'Visible','on') ;
    set(handles.param4B,'Visible','off') ;
    
    set(handles.param1B,'Value',str2double(get(handles.param1V,'String'))) ;
    set(handles.param1B,'Min',0) ;
    set(handles.param1B,'Max',1)
    set(handles.param1B,'SliderStep',[0.1 1]) ;
    
    set(handles.param2B,'Value',str2double(get(handles.param2V,'String'))) ;
    set(handles.param2B,'Min',0) ;
    set(handles.param2B,'Max',1)
    set(handles.param2B,'SliderStep',[0.1 1]) ;
    
    set(handles.param3B,'Value',str2double(get(handles.param3V,'String'))) ;
    set(handles.param3B,'Min',0) ;
    set(handles.param3B,'Max',1)
    set(handles.param3B,'SliderStep',[0.1 1]) ;
else
    set(handles.param1B,'Visible','off') ;
    set(handles.param2B,'Visible','off') ;
    set(handles.param3B,'Visible','off') ;
    set(handles.param4B,'Visible','off') ;
    set(handles.param1V,'Enable','off') ;
    set(handles.param2V,'Enable','off') ;
    set(handles.param3V,'Enable','off') ;
    set(handles.param4V,'Enable','off') ;
end
set(handles.param1L,'String','H th');
set(handles.param2L,'String','S th');
set(handles.param3L,'String','V th');
guidata(hObject, handles);

% --- Executes on button press in matRB.
function matRB_Callback(hObject, eventdata, handles)
% hObject    handle to matRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of matRB
set(handles.OpBtn,'String','Matting') ;
set(handles.OpBtn,'Visible','on') ;
handles.operation=3;

set(handles.StabRB,'Value',0) ;
set(handles.bgRB,'Value',0) ;
set(handles.matRB,'Value',1) ;
set(handles.trkRB,'Value',0) ;
set(handles.inRB,'Value',0) ;
set(handles.binRB,'Value',0) ;
set(handles.param1L,'Visible','on') ;
set(handles.param2L,'Visible','on') ;
set(handles.param3L,'Visible','on') ;
set(handles.param4L,'Visible','on') ;
set(handles.param1V,'Visible','on') ;
set(handles.param2V,'Visible','on') ;
set(handles.param3V,'Visible','on') ;
set(handles.param4V,'Visible','on') ;

set(handles.param1V,'String','2') ;
set(handles.param2V,'String','25') ;
set(handles.param3V,'String','2') ;
set(handles.param4V,'String','1000') ;

if (get(handles.DefCL,'Value')==0)
    set(handles.param1B,'Visible','on') ;
    set(handles.param2B,'Visible','on') ;
    set(handles.param3B,'Visible','on') ;
    set(handles.param4B,'Visible','on') ;
    
    set(handles.param1B,'Min',0) ;
    set(handles.param1B,'Max',50);
    set(handles.param1B,'Value',str2double(get(handles.param1V,'String'))) ;
    set(handles.param1B,'SliderStep',[1/50 10/50]) ;
    
    set(handles.param2B,'Min',0) ;
    set(handles.param2B,'Max',50) ;
    set(handles.param2B,'Value',str2double(get(handles.param2V,'String'))) ;
    set(handles.param2B,'SliderStep',[1/50 10/50]) ;
    
    set(handles.param3B,'Min',0) ;
    set(handles.param3B,'Max',5) ;
    set(handles.param3B,'SliderStep',[0.01 0.1]) ;
    set(handles.param3B,'Value',str2double(get(handles.param3V,'String'))) ;
    
    set(handles.param4B,'Min',500) ;
    set(handles.param4B,'Max',5000) ;
    set(handles.param4B,'SliderStep',[10/4500 100/4500]) ;
    set(handles.param4B,'Value',str2double(get(handles.param4V,'String'))) ;
    
    
else
    set(handles.param1B,'Visible','off') ;
    set(handles.param2B,'Visible','off') ;
    set(handles.param3B,'Visible','off') ;
    set(handles.param4B,'Visible','off') ;
    set(handles.param1V,'Enable','off') ;
    set(handles.param2V,'Enable','off') ;
    set(handles.param3V,'Enable','off') ;
    set(handles.param4V,'Enable','off') ;
    
end
set(handles.param1L,'String','BG WinSize');
set(handles.param2L,'String','Undecide WinSize');
set(handles.param3L,'String','gamma paramater');
set(handles.param4L,'String','Number Scribbles');
guidata(hObject, handles);

% --- Executes on button press in trkRB.
function trkRB_Callback(hObject, eventdata, handles)
% hObject    handle to trkRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of trkRB
set(handles.OpBtn,'String','Tracking') ;
set(handles.OpBtn,'Visible','on') ;
handles.operation=4 ;

set(handles.StabRB,'Value',0) ;
set(handles.bgRB,'Value',0) ;
set(handles.matRB,'Value',0) ;
set(handles.trkRB,'Value',1) ;
set(handles.inRB,'Value',0) ;
set(handles.binRB,'Value',0) ;
set(handles.param1L,'Visible','on') ;
set(handles.param2L,'Visible','off') ;
set(handles.param3L,'Visible','off') ;
set(handles.param4L,'Visible','off') ;
set(handles.param1V,'Visible','on') ;
set(handles.param2V,'Visible','off') ;
set(handles.param3V,'Visible','off') ;
set(handles.param4V,'Visible','off') ;

set(handles.param1V,'String','100') ;

if (get(handles.DefCL,'Value')==0)
    
    set(handles.param1B,'Visible','on') ;
    set(handles.param2B,'Visible','off') ;
    set(handles.param3B,'Visible','off') ;
    set(handles.param4B,'Visible','off') ;
    
    set(handles.param1B,'Value',str2double(get(handles.param1V,'String'))) ;
    
    set(handles.param1B,'SliderStep',[10/450 10/45]) ;
    
    set(handles.param1B,'Min',50) ;
    set(handles.param1B,'Max',500)
    
    
    
else
    set(handles.param1B,'Visible','off') ;
    set(handles.param2B,'Visible','off') ;
    set(handles.param3B,'Visible','off') ;
    set(handles.param4B,'Visible','off') ;
    set(handles.param1V,'Enable','off') ;
    set(handles.param2V,'Enable','off') ;
    set(handles.param3V,'Enable','off') ;
    set(handles.param4V,'Enable','off') ;
end
set(handles.param1L,'String','Number of Particles');
guidata(hObject, handles);



% --- Executes on button press in DefCL.
function DefCL_Callback(hObject, eventdata, handles)
% hObject    handle to DefCL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DefCL
if (get(handles.StabRB,'Value'))
    StabRB_Callback(handles.StabRB, eventdata, handles);
end
if (get(handles.bgRB,'Value'))
    bgRB_Callback(handles.bgRB, eventdata, handles);
end
if (get(handles.matRB,'Value'))
    matRB_Callback(handles.matRB, eventdata, handles);
end
if (get(handles.trkRB,'Value'))
    trkRB_Callback(handles.trkRB, eventdata, handles);
end


% --- Executes on selection change in outFol.
function outFol_Callback(hObject, eventdata, handles)
% hObject    handle to outFol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns outFol contents as cell array
%        contents{get(hObject,'Value')} returns selected item from outFol



% --- Executes during object creation, after setting all properties.
function outFol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outFol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RUNbtn.
function RUNbtn_Callback(hObject, eventdata, handles)
% hObject    handle to RUNbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on slider movement.
function param1B_Callback(hObject, eventdata, handles)
% hObject    handle to param1B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.param1V,'String',get(hObject,'Value'));

% --- Executes during object creation, after setting all properties.
function param1B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param1B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on slider movement.
function param2B_Callback(hObject, eventdata, handles)
% hObject    handle to param2B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.param2V,'String',get(hObject,'Value'));


% --- Executes during object creation, after setting all properties.
function param2B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param2B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function param3B_Callback(hObject, eventdata, handles)
% hObject    handle to param3B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.param3V,'String',get(hObject,'Value'));


% --- Executes during object creation, after setting all properties.
function param3B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param3B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function param1V_Callback(hObject, eventdata, handles)
% hObject    handle to param1V (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of param1V as text
%        str2double(get(hObject,'String')) returns contents of param1V as a double
set(handles.param1V,'String',get(hObject,'Value'));


% --- Executes during object creation, after setting all properties.
function param1V_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param1V (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function param2V_Callback(hObject, eventdata, handles)
% hObject    handle to param2V (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of param2V as text
%        str2double(get(hObject,'String')) returns contents of param2V as a double
set(handles.param2V,'String',get(hObject,'Value'));


% --- Executes during object creation, after setting all properties.
function param2V_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param2V (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function param3V_Callback(hObject, eventdata, handles)
% hObject    handle to param3V (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of param3V as text
%        str2double(get(hObject,'String')) returns contents of param3V as a double
set(handles.param3V,'String',get(hObject,'Value'));


% --- Executes during object creation, after setting all properties.
function param3V_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param3V (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function param4B_Callback(hObject, eventdata, handles)
% hObject    handle to param4B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.param4V,'String',get(hObject,'Value'));


% --- Executes during object creation, after setting all properties.
function param4B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param4B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function param4V_Callback(hObject, eventdata, handles)
% hObject    handle to param4V (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of param4V as text
%        str2double(get(hObject,'String')) returns contents of param4V as a double
set(handles.param4V,'String',get(hObject,'Value'));


% --- Executes during object creation, after setting all properties.
function param4V_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param4V (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in exitBtn.
function exitBtn_Callback(hObject, eventdata, handles)
% hObject    handle to exitBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ofBtn.
function of_BTN_Callback(hObject, eventdata, handles)
% hObject    handle to ofBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OutputFolder  = uigetdir('Please choose output folder');
if (~OutputFolder )
    if (strcmp('No',...
            questdlg('Output Folder will be the current dir?',' Are you Sure','Yes','No','No')))
        return;
    else
        OutputFolder='.\\';
    end
end
handles.OutputFolder  = strcat(OutputFolder,'\\');
guidata(hObject,handles);
set(handles.OpBtn,'Visible','on') ;

set(handles.DefCL,'Visible','on') ;
set(handles.StabRB,'Visible','on') ;
set(handles.bgRB,'Visible','on') ;
set(handles.matRB,'Visible','on') ;
set(handles.trkRB,'Visible','on') ;
set(handles.inRB,'Visible','on') ;
set(handles.binRB,'Visible','on') ;
set(handles.binRB,'Value',0) ;
set(handles.inRB,'Value',0) ;
set(handles.DefCL,'Value',1) ;
set(handles.StabRB,'Value',0) ;
set(handles.bgRB,'Value',0) ;
set(handles.matRB,'Value',0) ;
set(handles.trkRB,'Value',0) ;



% --- Executes on button press in VidCL.
function VidCL_Callback(hObject, eventdata, handles)
% hObject    handle to VidCL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VidCL
axes(handles.axes1);
cla(handles.axes1);

if (get(hObject,'Value')==1)
    set(handles.DefCL,'Visible','on') ;
    set(handles.StabRB,'Visible','on') ;
    set(handles.bgRB,'Visible','on') ;
    set(handles.matRB,'Visible','on') ;
    set(handles.trkRB,'Visible','on') ;
    set(handles.binRB,'Visible','on') ;
    set(handles.inRB,'Visible','on') ;
    set(handles.inRB,'Visible','on') ;
    set(handles.binRB,'Visible','on') ;
    set(handles.binRB,'Value',0) ;
    set(handles.inRB,'Value',0) ;
    
    set(handles.DefCL,'Value',1) ;
    set(handles.StabRB,'Value',0) ;
    set(handles.bgRB,'Value',0) ;
    set(handles.matRB,'Value',0) ;
    set(handles.trkRB,'Value',0) ;
    set(handles.OpBtn,'Visible','on') ;
    
    handles.OutputFolder  = '..\\Output\\';
    guidata(hObject,handles);
else
    axes(handles.axes1);
    
    text(0,0.5,strcat(['please define an output folder output folder first or choose using default files name']),'FontSize',30);
    set(handles.DefCL,'Visible','off') ;
    set(handles.StabRB,'Visible','off') ;
    set(handles.bgRB,'Visible','off') ;
    set(handles.matRB,'Visible','off') ;
    set(handles.trkRB,'Visible','off') ;
    set(handles.param1L,'Visible','off') ;
    set(handles.param2L,'Visible','off') ;
    set(handles.param3L,'Visible','off') ;
    set(handles.param4L,'Visible','off') ;
    set(handles.param1V,'Visible','off') ;
    set(handles.param2V,'Visible','off') ;
    set(handles.param3V,'Visible','off') ;
    set(handles.param4V,'Visible','off') ;
    set(handles.param1B,'Visible','off') ;
    set(handles.param2B,'Visible','off') ;
    set(handles.param3B,'Visible','off') ;
    set(handles.param4B,'Visible','off') ;
    set(handles.axes2,'Visible','off');
    set(handles.progress,'Visible','off');
    set(handles.inRB,'Visible','off');
    set(handles.binRB,'Visible','off');
end


% --- Executes on button press in binRB.
function binRB_Callback(hObject, eventdata, handles)
% hObject    handle to binRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of binRB
set(handles.StabRB,'Value',0) ;
set(handles.bgRB,'Value',0) ;
set(handles.matRB,'Value',0) ;
set(handles.trkRB,'Value',0) ;
set(handles.inRB,'Value',0) ;
set(handles.binRB,'Value',1) ;
set(handles.OpBtn,'Visible','off');
set(handles.param1B,'Visible','off') ;
set(handles.param2B,'Visible','off') ;
set(handles.param3B,'Visible','off') ;
set(handles.param4B,'Visible','off') ;
set(handles.param1V,'Visible','off') ;
set(handles.param2V,'Visible','off') ;
set(handles.param3V,'Visible','off') ;
set(handles.param4V,'Visible','off') ;
set(handles.param1L,'Visible','off') ;
set(handles.param2L,'Visible','off') ;
set(handles.param3L,'Visible','off') ;
set(handles.param4L,'Visible','off') ;

% --- Executes on button press in inRB.
function inRB_Callback(hObject, eventdata, handles)
% hObject    handle to inRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of inRB
set(handles.StabRB,'Value',0) ;
set(handles.bgRB,'Value',0) ;
set(handles.matRB,'Value',0) ;
set(handles.trkRB,'Value',0) ;
set(handles.inRB,'Value',1) ;
set(handles.binRB,'Value',0) ;
set(handles.OpBtn,'Visible','off');
set(handles.param1B,'Visible','off') ;
set(handles.param2B,'Visible','off') ;
set(handles.param3B,'Visible','off') ;
set(handles.param4B,'Visible','off') ;
set(handles.param1V,'Visible','off') ;
set(handles.param2V,'Visible','off') ;
set(handles.param3V,'Visible','off') ;
set(handles.param4V,'Visible','off') ;
set(handles.param1L,'Visible','off') ;
set(handles.param2L,'Visible','off') ;
set(handles.param3L,'Visible','off') ;
set(handles.param4L,'Visible','off') ;

% --- Executes on button press in qBTN.
function qBTN_Callback(hObject, eventdata, handles)
% hObject    handle to qBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all
