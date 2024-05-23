%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����˵����
% ��������������ʱ��κ����ݲ���������Զ�����X��Tick(Xa)��X��Label(Xb)
% �������ߣ�����(huzejun@pric.gov.cn)
% �汾�ţ�2007.03.1.001
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Xa,Xb]=UT4XLabel(StartTime,EndTime,FrameTime)

% StartTime='2003-12-21/03:00:00'; % ��ʼʱ��
% EndTime='2003-12-21/15:00:00';  % ����ʱ��
% FrameTime:֡���ʱ�䣬��λ����


starttime=[str2num(StartTime(1:4)) str2num(StartTime(6:7)) str2num(StartTime(9:10)) str2num(StartTime(12:13)) str2num(StartTime(15:16)) str2num(StartTime(18:19))];
endtime=[str2num(EndTime(1:4)) str2num(EndTime(6:7)) str2num(EndTime(9:10)) str2num(EndTime(12:13)) str2num(EndTime(15:16)) str2num(EndTime(18:19))];
    
starttimeNum=datenum(starttime);
endtimeNum=datenum(endtime);

shift_time3=datevec(endtimeNum-starttimeNum); % ����עʱ���ڵ�����   
Index3=round((shift_time3(3)*24*3600+shift_time3(4)*3600+shift_time3(5)*60+shift_time3(6))/FrameTime+1);
Index3=round((shift_time3(3)*24*3600+shift_time3(4)*3600+shift_time3(5)*60+shift_time3(6))/FrameTime+1);


interval_360=round(Index3/(3600/FrameTime));
    if interval_360<=1  % С�ڵ���1Сʱ,���10����/60��/600��
        for temp=1:10*60/FrameTime:Index3
            row=fix(temp/(10*60/FrameTime))+1;
            Xa(row,1)=temp;
            Xb(row,:)=datestr(datenum([starttime(1),starttime(2),starttime(3),starttime(4),starttime(5),starttime(6)+(row-1)*600]),15);
        end
    elseif (1<interval_360)&(interval_360<=2) % С�ڵ���2Сʱ,���20����/120��/1200��
        for temp=1:20*60/FrameTime:Index3
            row=fix(temp/(20*60/FrameTime))+1;
            Xa(row,1)=temp;
            Xb(row,:)=datestr(datenum([starttime(1),starttime(2),starttime(3),starttime(4),starttime(5),starttime(6)+(row-1)*1200]),15);
        end
    elseif (2<interval_360)&(interval_360<=4) % С�ڵ���3Сʱ,���30����/180��/1800��
        for temp=1:30*60/FrameTime:Index3
            row=fix(temp/(30*60/FrameTime))+1;
            Xa(row,1)=temp;
            Xb(row,:)=datestr(datenum([starttime(1),starttime(2),starttime(3),starttime(4),starttime(5),starttime(6)+(row-1)*1800]),15);
        end
    elseif (4<interval_360)&(interval_360<=8) % С�ڵ���8Сʱ,���60����/360��/3600��
        for temp=1:60*60/FrameTime:Index3
            row=fix(temp/(60*60/FrameTime))+1;
            Xa(row,1)=temp;
            Xb(row,:)=datestr(datenum([starttime(1),starttime(2),starttime(3),starttime(4),starttime(5),starttime(6)+(row-1)*3600]),15);
        end
    elseif (8<interval_360)&(interval_360<=16) % С�ڵ���18Сʱ,���120����/720��/7200��
        for temp=1:120*60/FrameTime:Index3
            row=fix(temp/(120*60/FrameTime))+1;
            Xa(row,1)=temp;
            Xb(row,:)=datestr(datenum([starttime(1),starttime(2),starttime(3),starttime(4),starttime(5),starttime(6)+(row-1)*7200]),15);
        end
    else                    % С�ڵ���24Сʱ,���180����/1080��/10800��
        for temp=1:180*60/FrameTime:Index3
            row=fix(temp/(180*60/FrameTime))+1;
            Xa(row,1)=temp;
            Xb(row,:)=datestr(datenum([starttime(1),starttime(2),starttime(3),starttime(4),starttime(5),starttime(6)+(row-1)*10800]),15);
        end
    end
    