%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                           auroActMonitor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       This code is used to monitor auroral activities.
%
%       We use sparse and low-rank decomposition theory to process auroral 
%       morphological and motion information at both pixel level and sequence 
%       level, which ensures that both macroscopic variations in auroral sequences 
%       and local key structures in auroral images can be taken into account in 
%       calculating the difference between consecutive sequences. 
%
%       Version 1.0
%       Author: Qian Wang, Rui Yang, Shaorui Guo, Jing Wei and Yao Tang
%       Cited as: Automatic Auroral Event Segmentation Based on Ground-based Observation
%
% %   Example:
%
%       % Read images from an ASI image file
%       datapath='F:\auroralData\AuroraData2021\'; %File ASI image

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



clear
clc
% datapath='D:\paper\paper\paper_LRChange\LR_atterntion_code\data\data\';
datapath='C:\Users\÷Ï–¿–¿\Desktop\1\';
days=dir([datapath '\N*']);


    mask_in=zeros(440,440);
    for j=1:440
        for k=1:440
            if (j-220)^2+(k-220)^2<220^2
                mask_in(j,k)=1;
            end
        end
    end
    mask1=uint8(mask_in);
    idex = find(mask1 == 1);


for numDay=1:length(days)
    
    imgpath =[ datapath days(numDay).name];
    files = dir([imgpath,'\N*.bmp']);
    length_ = length(files);
    
    
    %% mask 
    XO = [];
    for i = 1:length_
        fileName = fullfile(imgpath,files(i).name);
        I = imread(fileName);
        pixel_num = numel(I);%
        %pixel_num = numel(I)/3;  for 
        %I = rgb2gray(I);
        select = randsample(pixel_num,round(pixel_num*0.02));
        noise = randi([0,1],round(pixel_num*0.02),1)*255;
        I = double(I);
        I=I(idex);
        XO = [XO,I(:)];
    end
    
    %% spacial low-rank attention
    r = 1;
    [m,n]=size(XO);
    tau = 20;
    q = 0;
    sigma = 1e+4;
    epsilon = 1e-7;
    
    L3 = [];
    for i = 1 : (length_-2)
        Xi = XO(:,i:i+2);
        [Li,RMSE2,~,~,iter]=lowrank_corr(Xi,r,sigma,epsilon,q);
        L_next = Li(:,3);
        L3 = [L3,L_next];
        %     changA(i+2)=sum(abs(Li(:,3)-Li(:,2)).*(S>200));
    end
    L3 = [L3(:,1),L3(:,1),L3];
    S3 = abs(XO-L3);
    S3(:,1) = S3(:,3);
    S3(:,2) = S3(:,3);
    
    L3_S=S3.*L3;%attention
    XO_S=S3.*XO;%attention
    
    
    %% temporal godec
    r = 7;
    q = 0;
    sigma = 1e+4;
    epsilon = 1e-7;
    tau = 20;
%     [L_L3S_r7,RMSE2,~,~,iter]=lowrank_corr(L3_S,r,sigma,epsilon,q);
    [L_XOS_r7,RMSE2,~,~,iter]=lowrank_corr(XO_S,r,sigma,epsilon,q);
    [L_XO_r7,RMSE2,~,~,iter]=lowrank_corr(XO,r,sigma,epsilon,q);
    
    %%% space_scale  average filter
    space_scale=2;
    A=fspecial('average',[space_scale,space_scale]);
    isize = [440,440];
    for i = 1:size(L_XOS_r7,2)
        L_XOS_r7_img = zeros(440,440);
        L_XOS_r7_img(idex) = L_XOS_r7(:,i);
        L_XOS_r7_img = imfilter(L_XOS_r7_img,A);
        L_XOS_r7_img =  L_XOS_r7_img(idex);
        L_XOS_r7(:,i) = L_XOS_r7_img(:);
    end
    for i = 1:size(L_XO_r7,2)
        L_XO_r7_img = zeros(440,440);
        L_XO_r7_img(idex) = L_XO_r7(:,i);
        L_XO_r7_img = imfilter(L_XO_r7_img,A);
        L_XO_r7_img = L_XO_r7_img(idex);
        L_XO_r7(:,i) = L_XO_r7_img(:);
    end
    
    
    
    %%% emission_scale
    emission_scale=2;

    L_XOS_r7 = round(L_XOS_r7/emission_scale)*emission_scale;
    L_XO_r7  = round(L_XO_r7/emission_scale)*emission_scale;
    
    changeA2 = zeros(1,length_);
    changeB2 = zeros(1,length_);
    changeC  = zeros(1,length_);
    changeD  = zeros(1,length_);
%     changeE  = zeros(1,1139);
    leg12=12;
    leg1=1;
    leg3=3;
    leg6=6;
    leg60=60;
    
    for i =1+ leg60:length_-(leg60-1)
        %   change lines
        changeA2(i)=sum(abs(sum(L_XOS_r7(:,i:i+(leg60-1))')-sum(L_XOS_r7(:,i-leg60:i-1)')));% %our method
        
        %   change lines
        changeB2(i)=sum(abs(sum(XO_S(:,i:i+(leg60-1))')-sum(XO_S(:,i-leg60:i-1)')));% % local
        
        changeC(i)=sum(abs(sum(L_XO_r7(:,i:i+(leg60-1))')-sum(L_XO_r7(:,i-leg60:i-1)')));% %global
        
        changeD(i)=sum(abs(sum(XO(:,i:i+(leg12-1))')-sum(XO(:,i-leg12:i-1)')));%shape-constrained
        
    end
     save(['.\result\changeLine_' days(numDay).name], 'changeA2', 'changeB2', 'changeC', 'changeD')
    
%     plot([1:1139],changA2/max(changA2)*440,'g'); % 
%     plot([1:1139],changB2/max(changB2)*440,'b'); % 
%     plot([1:1139],changC/max(changC)*440,'c');  % 
%     plot([1:1139],changD/max(changD)*440,'m');  % 
%     % plot([1:1139],changE/max(changE)*440,'y');  % yellow %spacial attention constrained L1
%     % legend('L*S3 -> L1139','XO*S3 -> L1139','L*S3','XO*S3','XO->L1139','XO','spacial attention');
%     legend('L*S3 -> L1139','XO*S3 -> L1139','L*S3','XO*S3','XO->L1139','XO');
end