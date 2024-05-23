function [Image,Date,Time,Tag,Exposure]=OpenImg2004(filename)
% ����CCD��ͼ�����ݣ�����������
% Image��ͼ�����
% Data��ͼ������
% Time��ͼ��ʱ��
% Tag ��ͼ���־��0����ʾ�ǳ���۲⣬ʱ���ʽ��'HH:MM:SS'
%                 1����ʾ�ǻ�ս�۲⣬ʱ��ƫ������ʽ��'*******ms'
% Exposure:ͼ���ع�ʱ��

%   ����˵��: �����ڱ����ƺ�վȫ��ճ����ǵ��ļ���ȡ
%   �˰汾��2005��3��28���޸�,�汾��:   2005.03.28
%   2004-2005��������۲����ڸ����˲�������,CCDͼ�����ݵ�ʱ���ʽ�����仯,
%   ��2004��11��22����,������"Comment"ģʽ
%   �����"[Comment]",��ʱ����"UserComment="Fri Dec 10 15:03:08 2004"Ϊ׼,
%   ������"Date="2004-12-10",Time="5795060ms""Ϊ׼,
%   UserComment����ʼλ�ô�1177��ʼ������Ư��,
%   ExposureTime����ʼλ�ô�523��ʼ������Ư��,
%   ��Щȡ����Time�ĸ�ʽ,��Time��ʽ��"HH:MM:SS",
%   ��UserComment��λ�ù̶���1177,EposureTime��λ�ù̶���523;
%   ��Time�ĸ�ʽ��"********ms",����������λ�û����Ư��,����Ư������󲻻ᳬ��10
%--------------------------------------------------------------------------
%   �汾�ţ�2006.05.15
%   �޸�˵����
%   D01/02�ļ�������Ȼ��ȡ��[comment]ģʽ������ʱ���¼��Ȼ�Ƿ�[comment]ģʽ,
%   ��˲���94-114�еĴ��롣��ȥ���öδ�������2005.03.28�汾������ͬ
%--------------------------------------------------------------------------
fid=fopen(filename,'r');    %   ���ļ�

if fid~=-1          %  fid=-1������ļ�������
    % �ж��Ƿ�����[comment]����ģʽ 
    ip=1160;    % "[Comment]"��־���������1165
    Point_Comment=0;    % ��ʼ��Point_Comment
    for n=0:15
        file_point=fseek(fid,ip+n,'bof'); %   �趨�ļ�ָ��λ��
        [Tag_Comment, Tag_count]=fread(fid,9); % ��ip+n����������9���ַ�
        Tag_ChrComment=char(Tag_Comment');
        if (strcmp(Tag_ChrComment,'[Comment]')) 
            Point_Comment=ip+n; % ���[Commen]����λ��
            break;
        end
    end
    
    % ��ȡExposureTime
    ep=510; % ExposureTime����ʼָ��
    Point_Exposure=0;
    for n=0:20
        file_point=fseek(fid,ep+n,'bof'); %   �趨�ļ�ָ��λ��
        [Tag_Exposure,Exposure_count]=fread(fid,12); % ExposureTime=7s/25s 12���ַ�
        Tag_ChrExposure=char(Tag_Exposure');
        Point_Exposure=ep+n; % ExposureTime��λ��
        if (strcmp(Tag_ChrExposure,'ExposureTime'))
            Time_1ip=Point_Exposure+13; % �ع�ʱ���λ�� 7s/25s
            for m=0:5
                file_point=fseek(fid,Time_1ip+m,'bof');
                [S,S_count]=fread(fid,1);
                S=char(S);
                if (strcmp(S,'s'))
                    Time_2ip=Time_1ip+m; % �ع�ʱ��Ľ���λ��, ��'s'��λ��
                    file_point=fseek(fid,Time_1ip,'bof'); % ָ�����µ��ص�'7s'�Ŀ�ʼ
                    [ExposureTime,ET_count]=fread(fid,Time_2ip-Time_1ip); % Time_2ip-Time_1ip:�ع�ʱ��ֵ��λ��,��λ��ʮλ...
                    Exposure=str2num(char(ExposureTime')); % ����ع�ʱ��
                    break;
                end
            end
            break;
        end
    end
   
                
    
    if Point_Comment==0 % δ����Comment�Ĺ���ģʽ,���ļ��Ķ�ȡ������ǰ�ķ�ʽ
        file_point=fseek(fid,84,'bof');    %   �趨�ļ�ָ��λ��
        [A,count_A]=fread(fid,10);    %   ��ȡ�ļ�������
        Date=char(A'); % get file date(yyyy-mm-dd)
        file_point=fseek(fid,102,'bof');    %   �趨�ļ�ָ��λ��
        [B,count_B]=fread(fid,20);   %   ��ȡ�ļ���ʱ��
        file_time=char(B'); %  get file time(hh:mm:ssUT)
        [tm,tn]=size(file_time);
        if (file_time(1,3)~=':')& (file_time(1,6)~=':')
            for i=2:tn-1
                if (file_time(1,i)=='m')& (file_time(1,i+1)=='s')
                    Time=file_time(1:i-1);  % �ļ�ʱ����*******ms
                    Tag=1;  
                    break;
                end
            end
        else
            Time=file_time(1:8);
            Tag=0;
        end
    else    % ������Comment�Ĺ���ģʽ,�ļ���ʱ����'UserComment'֮��
        file_point=fseek(fid,Point_Comment+23,'bof') ; %    [Comment],UserComment="Thu Dec 16 07:02:40 2004
        [C,count_C]=fread(fid,24);
        C_Char=char(C');
        if C_Char(1)=='"'
            file_point=fseek(fid,84,'bof');    %   �趨�ļ�ָ��λ��
            [A,count_A]=fread(fid,10);    %   ��ȡ�ļ�������
            Date=char(A'); % get file date(yyyy-mm-dd)
            file_point=fseek(fid,102,'bof');    %   �趨�ļ�ָ��λ��
            [B,count_B]=fread(fid,20);   %   ��ȡ�ļ���ʱ��
            file_time=char(B'); %  get file time(hh:mm:ssUT)
            [tm,tn]=size(file_time);
            if (file_time(1,3)~=':')& (file_time(1,6)~=':')
                for i=2:tn-1
                    if (file_time(1,i)=='m')& (file_time(1,i+1)=='s')
                        Time=file_time(1:i-1);  % �ļ�ʱ����*******ms
                        Tag=1;  
                        break;
                    end
                end
            else
                Time=file_time(1:8);
                Tag=0;
            end
        else
            Date_Str=strcat(C_Char(9:10),'-',C_Char(5:7),'-',C_Char(21:24));
            Date=datestr(datenum(Date_Str),29); % �����ڸ�ʽת����'yyyy-mm-dd'
            Time=C_Char(12:19);
            Tag=0;
        end
    end
    
    %%% ��ȡͼ������
    file_point=fseek(fid,-512*512*2,'eof'); % ����ָ����ļ���β512*512*2 Bytes
    Image=zeros(512,512); %   ����ͼ�����У�512 X 512
    [I,count_I]=fread(fid,[512,512],'uint16'); % ��ȡ��������
    fclose(fid);    
    Image=I'; % get CCD Image Matrix����ʾ�����ǣ�imagesc(......)
end
