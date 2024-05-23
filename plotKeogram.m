%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                           plotKeogram
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       This code is used to plot keogram for untrimmed auroral sequences of any length.
%
%
%       Version 1.0
%       Author: Qian Wang, Rui Yang, Shaorui Guo, Jing Wei and Yao Tang
%       Cited as: Automatic Auroral Event Segmentation Based on Ground-based Observation
%
% %   Example:
%
%       % Read auroral change curvees from an auroral activity file
%       imgDatapath='F:\auroralData\AuroraData2003\';
%
%       % save path
%       keogramPath='.\keo\';
%
% 
%       % Name of ASI image
%       filename='N20031221G081212.bmp'; % AuroSS name
%       Data naming convention:
%       Each auroral data has a unique file name that contains the N/S, date, band, and time information.
%       Filename example: N20031221G081212.
%           N: North pole
%           20031221: December 21, 2003
%       	G: G-band
% 	        081212: 8:12:12 UT?



clear all

imgDatapath='F:\auroralData\AuroraData2003\';

files=dir([imgDatapath 'N*']);
for ii=1:length(files)
    imgList=dir([imgDatapath  files(ii).name '\N*']);
    keogram=zeros(440,size(imgList,1));
    for i=1:size(imgList,1)
        filename = imgList(i).name;
        img   =  imread([imgDatapath files(ii).name '\' filename]);
        
        col = (str2num(filename(11:12)))*360+str2num(filename(13:14))*6+str2num(filename(15))+1;
        keogram(:,i) = img(:,220);
    end
    
    figure; imagesc(keogram);
    colormap('jet');
    %     imwrite(keogram, ['.\keo\Keogram_' imgList(1).name(1:end-4)  '_'  imgList(i).name(1:end-4) '.bmp'], 'bmp');
    save(['.\keo1\Keogram_' imgList(1).name(1:end-10) ], 'keogram');
end