function varargout = Auroral_Event_Observe_Tool(varargin)
%      Auroral_Event_Observe_Tool MATLAB code for Auroral_Event_Observe_Tool.fig
%      Auroral_Event_Observe_Tool, by itself, creates a new Auroral_Event_Observe_Tool or raises the existing
%      singleton*.
%
%      H = Auroral_Event_Observe_Tool returns the handle to a new Auroral_Event_Observe_Tool or the handle to
%      the existing singleton*.
%
%      Auroral_Event_Observe_Tool('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Auroral_Event_Observe_Tool.M with the given input arguments.
%
%      Auroral_Event_Observe_Tool('Property','Value',...) creates a new Auroral_Event_Observe_Tool or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Auroral_Event_Observe_Tool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Auroral_Event_Observe_Tool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help video_extractor_app

% Last Modified by GUIDE v2.5 07-Jul-2023 10:37:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Auroral_Event_Observe_Tool_OpeningFcn, ...
                   'gui_OutputFcn',  @Auroral_Event_Observe_Tool_OutputFcn, ...
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


% --- Executes just before video_extractor_app is made visible.
function Auroral_Event_Observe_Tool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to video_extractor_app (see VARARGIN)

handles.annotatedImageNames = {};

% Choose default command line output for video_extractor_app
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes video_extractor_app wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Auroral_Event_Observe_Tool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


%Get UserData for LoadButton and slider
data = get(handles.LoadButton, 'UserData');
data1 = get(hObject, 'UserData');

%Get the current frame to display
frame = round(get(hObject, 'Value'));
file_names = data.file_names;

%Display the corresponding frame
axes(handles.ASI_Axes);
imshow(data.images{frame});

%Update the current frame text box
set(handles.current_frame_number, 'String', frame);
set(handles.current_frame_name, 'String', file_names{frame});
filename=file_names{frame};

axes(handles.KeogramAxes);
col = (str2num(filename(11:12)))*360+str2num(filename(13:14))*6+str2num(filename(15))+1-1080;
delete(handles.h)
handles.h=xline(col ,'--w','LineWidth',1.5); 


%Update the UserData for slider
set(hObject, 'UserData', data1);
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end





%Load button
% --- Executes on button press in LoadButton.
function LoadButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get UserData for LoadButton anf slider
data = get(hObject, 'UserData');
data1 = get(handles.slider, 'UserData');

%Prompt user to choose folder
folder = uigetdir();

%Only proceeds if folder is selected
if(folder ~= 0)
    %Get file names of all image files in the folder
    files = dir(fullfile(folder, '*.bmp'));
    file_names = {files.name};
    
    number_of_files = numel(file_names);

    file_prefix = file_names{1}(1:10);
    handles.filePrefix = file_prefix;

    %Read the images and store them in the data structure
    data.images = cell(1, number_of_files);
    for i = 1:number_of_files
        image_path = fullfile(folder, file_names{i});
        data.images{i} = imread(image_path);
    end
    
    %Set the necessary data fields for the loaded images
    data.file_names = file_names;
    data.folder = folder;
    data.current_frame = 1;
    data.number_of_frames = number_of_files;
    
    %Display the first frame
    axes(handles.ASI_Axes);
    imshow(data.images{data.current_frame}); hold on
    
    %Update the slider range and value
    set(handles.slider, 'Min', 1);
    set(handles.slider, 'Max', number_of_files);
    set(handles.slider, 'SliderStep', [1/(number_of_files-1), 1/(number_of_files-1)]);
    set(handles.slider, 'Value', 1);
    
    %Update the current frame text box
    set(handles.current_frame_number, 'String', data.current_frame);
    set(handles.current_frame_name, 'String', file_names{data.current_frame});

    
    
    %Set UserData for LoadButton and slider
    set(hObject,'UserData', data);
    set(handles.slider, 'UserData', data1);

    % Load the keogram image
    keogram_folder =  '.\Keogram\'; % Replace 'KeogramFolder' with the actual folder name
    keogram_file = fullfile(keogram_folder, ['Keogram_' file_names{1}(1:10) '.bmp']); % Adjust the filename pattern if needed
    keogram_image = imread(keogram_file);

    

    % Display the keogram image
    axes(handles.KeogramAxes);
    imagesc(keogram_image);
    colormap(handles.KeogramAxes,'jet'); 

    set(gca,'XLim',[0,4320],'YLim',[0,440],'XTick',[0,60*6:60*6:12*60*6],'XTickLabel',...
        ['03:00';'04:00';'05:00';'06:00';'07:00';'08:00';'09:00';'10:00';'11:00';'12:00';'13:00';'14:00';'15:00'],...
        'YTick',[0:73:440],'YTickLabel',['-90';'-60';'-30';'  0';' 30';' 60';' 90'],'YGrid','on');
    set(gca,'FontName', 'Times New Roman','Fontsize',12,'FontWeight', 'Bold');
 
%     set(gca,'Position',[0.0513,0.1456,0.9254,0.7739],'OuterPosition',[-0.10,0.000,1.19,0.99])
    axis on;
    xlabel('Time (UT)');
    ylabel('Keogram');

axes(handles.KeogramAxes);
filename=file_names{data.current_frame};
col = (str2num(filename(11:12)))*360+str2num(filename(13:14))*6+str2num(filename(15))+1-1080;

handles.h=xline(col ,'--w','LineWidth',1.5); 
guidata(hObject, handles);
end



% --- Executes on button press in AnnotateButton.
function AnnotateButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentImageName = get(handles.current_frame_name, 'String');
col = str2double(get(handles.current_frame_number, 'String'));

if isempty(handles.annotatedImageNames)
    % 
    handles.annotatedImageNames{1, 1} = currentImageName;
    handles.annotatedImageNames{1, 2} = col;
else
    %annotatedImageNames 
    existingImageNames = handles.annotatedImageNames(:, 1);
    if ~ismember(currentImageName, existingImageNames)
        handles.annotatedImageNames{end+1, 1} = currentImageName;
        handles.annotatedImageNames{end, 2} = col;

        %  annotatedImageNames
        handles.annotatedImageNames = sortrows(handles.annotatedImageNames, 2);
    end
end
% 
annotationData = handles.annotatedImageNames(:, [1 2]);  % 
set(handles.AnnotationTable, 'Data', annotationData);

disp(handles.annotatedImageNames);
guidata(hObject, handles);





%Save button
% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 
currentImageName = get(handles.current_frame_name, 'String');
datePart = currentImageName(2:9);

% 
txtFileName = [datePart '_Annotation.txt'];

%  annotatedImageNames ¶
txtFilePath = fullfile(pwd, txtFileName);
fileID = fopen(txtFilePath, 'w');
for i = 1:size(handles.annotatedImageNames, 1)
    imageName = handles.annotatedImageNames{i, 1};
    fprintf(fileID, '%s\n', imageName);
end
fclose(fileID);






% --- Executes on button press in DeleteButton.
function DeleteButton_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 
prompt = 'Input the index of the fram to be deleted ';
dlgtitle = 'Delete the frame';
dims = [1 35];
definput = {''};
answer = inputdlg(prompt, dlgtitle, dims, definput);

% 
if isempty(answer)
    return; 
end

colToDelete = str2double(answer{1});

if isempty(handles.annotatedImageNames)
    return; 
end

% •
rowsToDelete = find([handles.annotatedImageNames{:, 2}] == colToDelete);
% ·
handles.annotatedImageNames(rowsToDelete, :) = [];
% 
annotationData = handles.annotatedImageNames(:, [1 2]);  % æ³¨é‡Šä¿¡æ?¯æ•°æ?®
set(handles.AnnotationTable, 'Data', annotationData);

disp(handles.annotatedImageNames);
guidata(hObject, handles);






% --- Executes during object creation, after setting all properties.
function ASI_Axes_CreateFcn(hObject, ~, handles)
% hObject    handle to ASI_Axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate ASI_Axes


% --- Executes during object creation, after setting all properties.
function KeogramAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KeogramAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate KeogramAxes




% --- Executes during object creation, after setting all properties.
function current_frame_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to current_frame_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function current_frame_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to current_frame_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
data1 = get(handles.LoadButton, 'UserData');

global ButtonDown;
ButtonDown = 0;
if strcmp(get(gcf,'SelectionType'),'normal')
    ButtonDown = 1;
    pos1 = get(handles.KeogramAxes,'CurrentPoint');

    % Get the line handle
    hLine = handles.h;

    % Remove the old line
    delete(hLine);

    % Add a new line at the new position
    axes(handles.KeogramAxes);
    frame_number = round(pos1(1,1));
    hLine = xline(frame_number, '--w');

    filename = data1.file_names{frame_number};

    axes(handles.ASI_Axes);
    imshow(data1.images{frame_number});

    set(handles.current_frame_number, 'String', frame_number);
    set(handles.current_frame_name, 'String', filename);
    set(handles.slider, 'Value', frame_number);

    handles.h = hLine;
    guidata(hObject, handles);
end
