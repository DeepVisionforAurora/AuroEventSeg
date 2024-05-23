%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 函数说明：
% 根据所给出数据时间段和数据采样间隔，自动给出X轴Tick(Xa)和X轴Label(Xb)
% 程序作者：胡泽骏(huzejun@pric.gov.cn)
% 版本号：2007.03.1.001
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Xa,Xb]=UT4XLabel(StartTime,EndTime,FrameTime)

% StartTime='2003-12-21/03:00:00'; % 开始时间
% EndTime='2003-12-21/15:00:00';  % 结束时间
% FrameTime:帧间隔时间，单位：秒


starttime=[str2num(StartTime(1:4)) str2num(StartTime(6:7)) str2num(StartTime(9:10)) str2num(StartTime(12:13)) str2num(StartTime(15:16)) str2num(StartTime(18:19))];
endtime=[str2num(EndTime(1:4)) str2num(EndTime(6:7)) str2num(EndTime(9:10)) str2num(EndTime(12:13)) str2num(EndTime(15:16)) str2num(EndTime(18:19))];
    
starttimeNum=datenum(starttime);
endtimeNum=datenum(endtime);

shift_time3=datevec(endtimeNum-starttimeNum); % 所关注时段内的列数   
Index3=round((shift_time3(3)*24*3600+shift_time3(4)*3600+shift_time3(5)*60+shift_time3(6))/FrameTime+1);
Index3=round((shift_time3(3)*24*3600+shift_time3(4)*3600+shift_time3(5)*60+shift_time3(6))/FrameTime+1);


interval_360=round(Index3/(3600/FrameTime));
    if interval_360<=1  % 小于等于1小时,间隔10分钟/60列/600秒
        for temp=1:10*60/FrameTime:Index3
            row=fix(temp/(10*60/FrameTime))+1;
            Xa(row,1)=temp;
            Xb(row,:)=datestr(datenum([starttime(1),starttime(2),starttime(3),starttime(4),starttime(5),starttime(6)+(row-1)*600]),15);
        end
    elseif (1<interval_360)&(interval_360<=2) % 小于等于2小时,间隔20分钟/120列/1200秒
        for temp=1:20*60/FrameTime:Index3
            row=fix(temp/(20*60/FrameTime))+1;
            Xa(row,1)=temp;
            Xb(row,:)=datestr(datenum([starttime(1),starttime(2),starttime(3),starttime(4),starttime(5),starttime(6)+(row-1)*1200]),15);
        end
    elseif (2<interval_360)&(interval_360<=4) % 小于等于3小时,间隔30分钟/180列/1800秒
        for temp=1:30*60/FrameTime:Index3
            row=fix(temp/(30*60/FrameTime))+1;
            Xa(row,1)=temp;
            Xb(row,:)=datestr(datenum([starttime(1),starttime(2),starttime(3),starttime(4),starttime(5),starttime(6)+(row-1)*1800]),15);
        end
    elseif (4<interval_360)&(interval_360<=8) % 小于等于8小时,间隔60分钟/360列/3600秒
        for temp=1:60*60/FrameTime:Index3
            row=fix(temp/(60*60/FrameTime))+1;
            Xa(row,1)=temp;
            Xb(row,:)=datestr(datenum([starttime(1),starttime(2),starttime(3),starttime(4),starttime(5),starttime(6)+(row-1)*3600]),15);
        end
    elseif (8<interval_360)&(interval_360<=16) % 小于等于18小时,间隔120分钟/720列/7200秒
        for temp=1:120*60/FrameTime:Index3
            row=fix(temp/(120*60/FrameTime))+1;
            Xa(row,1)=temp;
            Xb(row,:)=datestr(datenum([starttime(1),starttime(2),starttime(3),starttime(4),starttime(5),starttime(6)+(row-1)*7200]),15);
        end
    else                    % 小于等于24小时,间隔180分钟/1080列/10800秒
        for temp=1:180*60/FrameTime:Index3
            row=fix(temp/(180*60/FrameTime))+1;
            Xa(row,1)=temp;
            Xb(row,:)=datestr(datenum([starttime(1),starttime(2),starttime(3),starttime(4),starttime(5),starttime(6)+(row-1)*10800]),15);
        end
    end
    