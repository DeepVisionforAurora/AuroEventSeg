%% ---------------------------------------------------------------
% ����˵����
% �Զ���ѡ����Ŀ¼�е�ȫ��ռ���ͼ���Ƴ�keogram��.mat�ļ���������2003��12��֮�������
% �ļ�����
% keo_N061031G_1031_173740_1101_073705_1.m
%     Ŀ¼��_��ʼ����_��ʼʱ��_��������_����ʱ��_
% �ļ�������
% keo_data��437,n):���������ϵļ���ǿ�ȣ�count
% keo_time(n,1):ÿһ�����ݵ�ʱ����(matlab��ʽ)
% DarkKeo(426,2):�������ļ�1��2
%% ---------------------------------------------------------------
% ���ߣ����� (huzejun@pric.gov.cn)
% ���ڣ�2008��4��23��
% �汾��2008.04.23.001
%% ---------------------------------------------------------------
% �޸İ汾��2008.04.24.001
% ���Ӷ����ݴ���Ŀ¼��ѡ��
% 1.ָ�����ݴ����Ŀ¼����Ŀ¼��ֱ�Ӵ��ȫ��յ�.img�ļ�����ѡ����Ա��ڵ�������������Ŀ¼
% 2.ָ�����ݴ������Ŀ¼������Ŀ¼�´����n��������Ŀ¼������Щ��Ŀ¼�´��ȫ��յ�.img�ļ�
% ����E:\data\N2007R\N20071105R\*.img
%     E:\data\N2007R\N20071106R\*.img
%     N20071105R,N20071106R:������Ŀ¼(����1)
%     N2007R:������Ŀ¼(����2��
%% ---------------------------------------------------------------
% �޸İ汾��2008.04.25.001
% �Դ�����һ�����޸ģ���ȡ�ļ���Ŀ¼�ķ�ʽ������uigetfile.ԭ�Ȳ��õ�uigetdir��ȡ��Ŀ¼���ٶ�̫��
%% ---------------------------------------------------------------
clear;clc;
%% ---------------------------------------------------------------
% ��������
savepath=input('�����뱣��.mat�ļ���Ŀ¼:(���� E:\\keodata)','s');
disp('��������keogram��.mat�ļ��ķ�ʽ:');
disp('˵����E:\data\N2007R\N20071105R\*.img');
disp('N20071105R:���ݴ�����Ŀ¼');
disp('N2007R:���ݴ�����Ŀ¼');
disp('1.ָ�����ݴ�����Ŀ¼����ָ�������');
disp('2.ָ������һ��������Ŀ¼������Ŀ¼��������������������Ŀ¼����������');
disp('3.����Ŀ¼�嵥�ļ���Dir_Name_temp.mat)');
Batch_n=input('����������ѡ��[1/2/3]');

% Batch_n=1; % 1��ѡ����������n������Ŀ¼��2���Զ�����һ��������Ŀ¼�µ�����������Ŀ¼�е�����
%% ---------------------------------------------------------------
 switch Batch_n
     case 1
         %----------------------------------------------------------------------
         % ѡ����Ҫ�������������Ŀ¼
         dir_n=0;   % ��Ŀ¼������ʼΪ0
         cc='n'
         dir_name=cell(2,1); % ������Ŀ¼
         % dir_name
         while cc=='n'
             %     if dir_n==0
             dir_n=dir_n+1;
%              dir_name(dir_n,1)={uigetdir}; %   Ŀ¼����Ի���
            [filename_temp,dir_temp]=uigetfile('*.img','open IMG files'); % �����ļ��Ի���
            [temp_m,temp_n]=size(dir_temp);
            dir_name(dir_n,1)={dir_temp(1,1:temp_n-1)};
             %     else
             %         dir_name(dir_n,:)=uigetdir(dir_n-1); %   Ŀ¼����Ի���
             %     end
             cc=input('�Ƿ������Ŀ¼��ѡ��?[y/n]','s')
%              cc=input('Finish the selecting for working dir?[y/n]','s')
         end
         save('DirName.mat','dir_name','dir_n'); % ���洦��Ŀ¼
     case 2
         dirpath=input('������һ��������Ŀ¼��·��:(���� E:\\N2007G)','s');
         dir_temp=dir(dirpath); % ��ȡ������Ŀ¼�µ�������Ŀ¼
         [m_dir,n_dir]=size(dir_temp);
         dir_n=m_dir-2; % ��Ŀ¼����
         dir_name=cell(2,1); % ������Ŀ¼
         for i=3:m_dir
             dir_name(i-2,1)={strcat(dirpath,'\',dir_temp(i).name)}; % ��Ŀ¼����cell����
         end
         save('Dir_Name_temp.mat','dir_name','dir_n');  % ���洦��Ŀ¼
     case 3
         load('Dir_Name_temp.mat'); % �����봦���Ŀ¼
                 
 end
%% ---------------------------------------------------------------
% ����ÿ��Ŀ¼�е��ļ���������keogram
for i=1:dir_n
    temp_dirname=char(dir_name(i));
    [tempdir_m,tempdir_n]=size(temp_dirname);
    addpath(strcat(temp_dirname)); % ��·�����뵽����Ŀ¼��
    temp_ind=find(temp_dirname=='\');
    [tempind_m,tempind_n]=size(temp_ind);
    DirName=temp_dirname(1,temp_ind(tempind_n)+1:tempdir_n) % Ŀ¼��
    disp(strcat('Working document:',DirName)); % ��ʾ��ǰ����Ŀ¼
    
    file=dir(temp_dirname);
    [file_m,file_n]=size(file);
    
    keo_data=nan*zeros(437,1);
    keo_time=nan*zeros(1,1);
    keo_n=0;    % �ļ������������������ļ���
    
    DarkKeo=nan*zeros(437,3); % �������ļ�
    dark_n=0;   % �ļ������������������ļ���
    %--------------------------------------
    % ����Ŀ¼���ļ���keo����
    for j=3:file_m
        filename=file(j).name;
        disp(strcat('filename:',DirName,'\',filename)); % ��ʾ��ǰ�����ļ�
        if filename(1)=='N' % �ļ����С�N�������
            [Image_1,Date_1,Time_1,Tag_1]=OpenImg2004(filename); % ��������
            
            find_D=find(filename=='D'); % Ѱ���ļ������Ƿ��а������ı��,"D"
            [find_D_m,find_D_n]=size(find_D);
            if find_D_n==0  % �ǰ������ļ�
                Band=filename(8);   % ��ȡ�۲Ⲩ��
                %             [Image_1,Date_1,Time_1,Tag_1]=OpenImg2004(filename); % ��������
                MagNS=MagMeridian2004(Image_1,Band); % ��ȡͼ���еĴ�����������
                keo_n=keo_n+1;
                keo_data(:,keo_n)=MagNS;
                keo_time(keo_n,1)=datenum(str2num(Date_1(1:4)),str2num(Date_1(6:7)),str2num(Date_1(9:10)),...
                    str2num(Time_1(1:2)),str2num(Time_1(4:5)),str2num(Time_1(7:8)));
            else
                Band=filename(10);   % ��ȡ�۲Ⲩ��
                %             [Image_1,Date_1,Time_1,Tag_1]=OpenImg2004(filename); % ��������
                MagNS=MagMeridian2004(Image_1,Band); % ��ȡͼ���еĴ�����������
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
    % ������ļ���
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
    % �����ʱ����
        
    clear DirName��
end

        