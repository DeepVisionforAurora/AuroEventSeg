%% ---------------------------------------------------------------
% 程序说明：
% 自动从选定的目录中的全天空极光图像制成keogram的.mat文件，适用于2003年12月之后的数据
% 文件名：
% keo_N061031G_1031_173740_1101_073705_1.m
%     目录名_开始日期_开始时间_结束日期_结束时间_
% 文件变量：
% keo_data（437,n):磁子午线上的极光强度，count
% keo_time(n,1):每一列数据的时间数(matlab格式)
% DarkKeo(426,2):暗电流文件1和2
%% ---------------------------------------------------------------
% 作者：胡泽骏 (huzejun@pric.gov.cn)
% 日期：2008年4月23日
% 版本：2008.04.23.001
%% ---------------------------------------------------------------
% 修改版本：2008.04.24.001
% 增加对数据处理目录的选择。
% 1.指定数据处理的目录，该目录下直接存放全天空的.img文件。该选择可以便于单独处理几个数据目录
% 2.指定数据处理的总目录，该总目录下存放有n个数据子目录，而这些子目录下存放全天空的.img文件
% 例：E:\data\N2007R\N20071105R\*.img
%     E:\data\N2007R\N20071106R\*.img
%     N20071105R,N20071106R:数据子目录(方法1)
%     N2007R:数据总目录(方法2）
%% ---------------------------------------------------------------
% 修改版本：2008.04.25.001
% 对处理方法一进行修改，获取文件子目录的方式，采用uigetfile.原先采用的uigetdir获取子目录的速度太慢
%% ---------------------------------------------------------------
clear;clc;
%% ---------------------------------------------------------------
% 参数输入
savepath=input('请输入保存.mat文件的目录:(例如 E:\\keodata)','s');
disp('输入制作keogram的.mat文件的方式:');
disp('说明：E:\data\N2007R\N20071105R\*.img');
disp('N20071105R:数据处理子目录');
disp('N2007R:数据处理总目录');
disp('1.指定数据处理子目录（可指定多个）');
disp('2.指定处理一个数据总目录（该总目录下所包含的所有数据子目录都将被处理）');
disp('3.读入目录清单文件（Dir_Name_temp.mat)');
Batch_n=input('请输入您的选择[1/2/3]');

% Batch_n=1; % 1：选择批量处理n个数据目录；2：自动处理一个数据总目录下的所有数据子目录中的数据
%% ---------------------------------------------------------------
 switch Batch_n
     case 1
         %----------------------------------------------------------------------
         % 选择需要进行批量处理的目录
         dir_n=0;   % 子目录数量初始为0
         cc='n'
         dir_name=cell(2,1); % 数据子目录
         % dir_name
         while cc=='n'
             %     if dir_n==0
             dir_n=dir_n+1;
%              dir_name(dir_n,1)={uigetdir}; %   目录输入对话框
            [filename_temp,dir_temp]=uigetfile('*.img','open IMG files'); % 输入文件对话框
            [temp_m,temp_n]=size(dir_temp);
            dir_name(dir_n,1)={dir_temp(1,1:temp_n-1)};
             %     else
             %         dir_name(dir_n,:)=uigetdir(dir_n-1); %   目录输入对话框
             %     end
             cc=input('是否结束子目录的选择?[y/n]','s')
%              cc=input('Finish the selecting for working dir?[y/n]','s')
         end
         save('DirName.mat','dir_name','dir_n'); % 保存处理目录
     case 2
         dirpath=input('请输入一个数据总目录的路径:(例如 E:\\N2007G)','s');
         dir_temp=dir(dirpath); % 获取数据总目录下的所有子目录
         [m_dir,n_dir]=size(dir_temp);
         dir_n=m_dir-2; % 子目录数量
         dir_name=cell(2,1); % 数据子目录
         for i=3:m_dir
             dir_name(i-2,1)={strcat(dirpath,'\',dir_temp(i).name)}; % 子目录名的cell数组
         end
         save('Dir_Name_temp.mat','dir_name','dir_n');  % 保存处理目录
     case 3
         load('Dir_Name_temp.mat'); % 读入须处理的目录
                 
 end
%% ---------------------------------------------------------------
% 读入每个目录中的文件，并做成keogram
for i=1:dir_n
    temp_dirname=char(dir_name(i));
    [tempdir_m,tempdir_n]=size(temp_dirname);
    addpath(strcat(temp_dirname)); % 把路径加入到工作目录中
    temp_ind=find(temp_dirname=='\');
    [tempind_m,tempind_n]=size(temp_ind);
    DirName=temp_dirname(1,temp_ind(tempind_n)+1:tempdir_n) % 目录名
    disp(strcat('Working document:',DirName)); % 显示当前工作目录
    
    file=dir(temp_dirname);
    [file_m,file_n]=size(file);
    
    keo_data=nan*zeros(437,1);
    keo_time=nan*zeros(1,1);
    keo_n=0;    % 文件数量（不含暗电流文件）
    
    DarkKeo=nan*zeros(437,3); % 暗电流文件
    dark_n=0;   % 文件数量（不含暗电流文件）
    %--------------------------------------
    % 读入目录中文件的keo数据
    for j=3:file_m
        filename=file(j).name;
        disp(strcat('filename:',DirName,'\',filename)); % 显示当前工作文件
        if filename(1)=='N' % 文件名有“N”则读入
            [Image_1,Date_1,Time_1,Tag_1]=OpenImg2004(filename); % 读入数据
            
            find_D=find(filename=='D'); % 寻找文件名中是否有暗电流的标记,"D"
            [find_D_m,find_D_n]=size(find_D);
            if find_D_n==0  % 非暗电流文件
                Band=filename(8);   % 获取观测波段
                %             [Image_1,Date_1,Time_1,Tag_1]=OpenImg2004(filename); % 读入数据
                MagNS=MagMeridian2004(Image_1,Band); % 获取图像中的磁子午线向量
                keo_n=keo_n+1;
                keo_data(:,keo_n)=MagNS;
                keo_time(keo_n,1)=datenum(str2num(Date_1(1:4)),str2num(Date_1(6:7)),str2num(Date_1(9:10)),...
                    str2num(Time_1(1:2)),str2num(Time_1(4:5)),str2num(Time_1(7:8)));
            else
                Band=filename(10);   % 获取观测波段
                %             [Image_1,Date_1,Time_1,Tag_1]=OpenImg2004(filename); % 读入数据
                MagNS=MagMeridian2004(Image_1,Band); % 获取图像中的磁子午线向量
                dark_n=dark_n+1;
                DarkKeo(:,dark_n)=MagNS;
            end


            clear Image_1 Date_1 Time_1 Tag_1;
            clear MagNS  filename;
            clear temp_dirname tempdir_m tempdir_n;
            clear temp_ind tempind_m tempind_n;
        end
    end
    %----------------------------------
    % 保存的文件名
    [time_m,time_n]=size(keo_time);
    starttime=datestr(keo_time(1,1),31);
    topfile1=strcat(starttime(6:7),starttime(9:10));
    topfile2=strcat(starttime(12:13),starttime(15:16),starttime(18:19));
    endtime=datestr(keo_time(time_m,1),31);
    endfile1=strcat(endtime(6:7),endtime(9:10));
    endfile2=strcat(endtime(12:13),endtime(15:16),endtime(18:19));
    topfile=file(3).name(1:8);
    
    savefile=strcat(savepath,'\keo_',topfile,'_',topfile1,'_',topfile2,'_',endfile1,'_',endfile2,'.mat');
    save(savefile,'keo_data','keo_time','DarkKeo');
    
    clear savefile time_m time_n starttime topfile1 topfile2 endtime endfile1 endfile2 topfile;
    clear keo_data keo_time DarkKeo;
    %----------------------------------
    % 清除临时变量
        
    clear DirName；
end

        