%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 文件说明：
% 读入keodata目录数据，设定关注时段（<=24h),自动绘制每天指定的特定时间段的三波段Keogram图像，并保存到ps文件中
% 作者：胡泽骏
% 版本：2008.01.08.001
%---------------------
% 修改说明：
% 增加pro_n量，选择读入黄德宏、胡泽骏的不同文件制作出来的keogram的mat文件
%---------------------
% 版本：2008.06.25.001
% 修改说明：重新修改了图像输出的位置
%--------------------------------------------------------------------------
% 详细说明：         Z1         Z2
% 假定:指定时段为     |----------|             keo(422,n)
%                   W1          W2
%      文件时段为     |==========|             filekeo(422,m)
% 则文件时段和指定时段之间存在六种状态：
%                                          |------------|
% 1.W2<Z1                 |==========|
% 2.W1>Z2                                                     |==========|
% 3.(W1<Z1)&(W2>=Z1&W2<=Z2)           |==========|
% 4.(W1>=Z1&W1<=Z2)&(W2>Z2)                       |==========|
% 5.(W1>=Z1)&(W2<=Z2)                        |========|
% 6.(W1<Z1)&(W2>Z2)                   |======================|
% 状态3，4，5，6都和关注时段有关联,相关算法：
% 3.        index3=W2-Z1+1;  
%           keo(:,1:index3)=filekeo(:,m-index3+1:m);
% %   matlab:   tempIndex=find(W2=Z1);
% %             index3=m-tempIndex+1;

% 4.        index4=Z2-W1+1;
%           keo(:,n-index4+1:n)=filekeo(:,1:index4);
% %   matlab:   tempIndex=find(W2=Z2)
% %             index4=tempIndex;
            
% 5.        index5=W1-Z1+1;
%           keo(:,index5:index5+m-1)=filekeo(:,1:m);
%   
% 6.        index6=Z1-W1+1;
%           keo(:,1:n)=filekeo(:,index6:index6+n-1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
pro_n=2; % 1:黄德宏的CCD_2006.exe程序
        % 2:胡泽骏的MakeKeoMat2004.m
colormap_n=1; % 1:colormap(jet)
              % 2:colormap(gray)
              % 3:colormap(hot)
contour_n=1;  % 0: plot Image
              % 1: plot contour
              % 2: plot contourf
              
%% ---------------------------------------------------------------              
[filename1, pathname1] = uigetfile('*.mat', ' Open ASI MAT file'); %   文件输入对话框
addpath(strcat(pathname1));%  将文件所处目录加入到Matlab工作目录中去
data_dir=dir(pathname1);
[dir_m,dir_n]=size(data_dir);
filename=char(data_dir(3:dir_m).name);
%--------------------------------------------------------------------------
% 把mat文件按照波段分开
G_index=find(filename(:,12)=='G'|filename(:,12)=='g');
filenameG=filename(G_index,:);
[G_m,G_n]=size(filenameG);
R_index=find(filename(:,12)=='R'|filename(:,12)=='r');
filenameR=filename(R_index,:);
[R_m,R_n]=size(filenameR);
V_index=find(filename(:,12)=='V'|filename(:,12)=='v');
filenameV=filename(V_index,:);
[V_m,V_n]=size(filenameV);
%------------------------------------
% 提取每个文件记录的时间段
% startG=zeros(G_m,1);    % 开始时间
% endG=zeros(G_m,1);      % 结束时间
% Id_G=zeros(G_m,1);      % 判断标志
% for i=1:G_m
%     load(strcat(filenameG(i,:)));
%     [tempG_m,tempG_n]=size(keo_time);
%     startG(i)=keo_time(1);
%     endG(i)=keo_time(tempG_m);
%     clear keo_data keo_time;
% end
%-------------------------------------
% 提取每个文件记录的时间段
% startR=zeros(R_m,1);
% endR=zeros(R_m,1);
% Id_R=zeros(R_m,1);      % 判断标志
% for i=1:R_m
%     load(strcat(filenameR(i,:)));
%     [tempR_m,tempR_n]=size(keo_time);
%     startR(i)=keo_time(1);
%     endR(i)=keo_time(tempR_m);
%     clear keo_data keo_time;
% end
%------------------------------------
% 提取每个文件记录的时间段
% startV=zeros(V_m,1);
% endV=zeros(V_m,1);
% Id_V=zeros(V_m,1);      % 判断标志
% for i=1:V_m
%     load(strcat(filenameV(i,:)));
%     [tempV_m,tempV_n]=size(keo_time);
%     startV(i)=keo_time(1);
%     endV(i)=keo_time(tempV_m);
%     clear keo_data keo_time;
% end

%--------------------------------------------------------------------------
% 输入关注时段，开始和结束的日期，以及每天关注的开始和结束的时间
disp('-----------------------------------------------');
TopDay=input('Please input the start day [yyyy-mm-dd]:','s');
EndDay=input('Please input the end day [yyyy-mm-dd]:','s');
deltaDay=datenum(str2num(EndDay(1:4)),str2num(EndDay(6:7)),str2num(EndDay(9:10)))-...
    datenum(str2num(TopDay(1:4)),str2num(TopDay(6:7)),str2num(TopDay(9:10)));
TopTime=input('Please input the start time on every day[hh:mm:ss]:','s');
EndTime=input('Please input the end time on every day[hh:mm:ss]:','s');
deltaIndex=((str2num(EndTime(1:2))*3600+str2num(EndTime(4:5))*60+str2num(EndTime(7:8)))-...
    (str2num(TopTime(1:2))*3600+str2num(TopTime(4:5))*60+str2num(TopTime(7:8))))/10+1;      % 关注时段的Keogram矩阵列数(10秒间隔）
%--------------------------------------------------------------------------
% 输入输入制作人姓名以及E-mail
% WorkerName=input('Please input your name [e.g. Hu Ze-Jun]:','s');
% WorkerEMail=input('Please input your E-mail[e.g.huzejun@pric.gov.cn]:','s');
WorkerName='Hu Ze-Jun';
WorkerEMail='huzejun@pric.gov.cn';
InstitudeName='Polar Research Institude of China (P.R.I.C.)';
GroupName='Upper Atmospheric Physics (UAP)';
%--------------------------------------------------------------------------
% 程序中的常数


% YaG=[1 71 142 212 282 353 422];
% YaR=[1 72 144 216 287 359 429];
% YaV=[1 72 143 215 286 357 427];
Yb=['M.N. 90';'     60';'     30';'      0';'    -30';'    -60';'M.S.-90'];

t10=datenum([0 0 0 0 0 10]);    % 10秒的datenum值
%------------------------------

%--------------------------------------------------------------------------
for i=0:1:deltaDay % 按天步进循环
% for i=0:0 % 按天步进循环

    %--------------------------------------------------------------------------
    if pro_n==1
        %% 黄德宏的CCD_2006.exe程序里面出来的keo_data的行数
        c_LimV=[0 500]; % unit:count
        c_LimG=[0 2000]; % unit:count
        c_LimR=[0 2000]; % unit:count
        
        G_column=422;
        R_column=429;
        V_column=427;
        YaG=[1 71 142 212 282 353 422];
        YaR=[1 72 144 216 287 359 429];
        YaV=[1 72 143 215 286 357 427];
    elseif pro_n==2
        %% 胡泽骏的MakeKeoMat2004.m程序里面出来的keo_data的行数
        c_LimV=[0 800]; % unit:count
        c_LimG=[0 3000]; % unit:count
        c_LimR=[0 3000]; % unit:count
        
        G_column=437;
        R_column=437;
        V_column=437;
        YaG=[1,74,147,219,291,364,437];
        YaR=[1,74,147,219,291,364,437];
        YaV=[1,74,147,219,291,364,437];
    end
    keoG=nan*zeros(G_column,deltaIndex);
    keoR=nan*zeros(R_column,deltaIndex);
    keoV=nan*zeros(V_column,deltaIndex);
    starttime=datenum(str2num(TopDay(1:4)),str2num(TopDay(6:7)),str2num(TopDay(9:10))+i,...
        str2num(TopTime(1:2)),str2num(TopTime(4:5)),str2num(TopTime(7:8)));
    s_tr=datestr(starttime,31);
    endtime=datenum(str2num(TopDay(1:4)),str2num(TopDay(6:7)),str2num(TopDay(9:10))+i,...
        str2num(EndTime(1:2)),str2num(EndTime(4:5)),str2num(EndTime(7:8)));
    e_tr=datestr(endtime,31);
    [Xa,Xb]=UT4XLabel(datestr(starttime,31),datestr(endtime,31),10);    % 坐标轴Xlabel
    %---------------------------------------------------
    % 获得每个文件的状态，并进行相应处理
    for j=1:G_m
        load(strcat(filenameG(j,:)));
        
        [temp_m,temp_n]=size(keo_time);
        temp_vec=datevec(keo_time);
        temp_vec(:,6)=round(temp_vec(:,6)/10)*10; % 对数据时间进行校准，校准到10的倍数
        keo_time=datenum(temp_vec);
        %-----------------------------------------------
        % 去掉小于或者等于0(时间相等)的keogram列
        n1=(keo_time(2:temp_m)-keo_time(1:temp_m-1));
        n1_ind=find(n1==0|n1<0);
        [n1_ind_m,n1_ind_n]=size(n1_ind);
        if n1_ind_m>0
            keo_time(n1_ind+1,:)=[];
            keo_data(:,n1_ind+1)=[];
        end
        %%------------------------
        % 2003年12月-2004年2月的数据中，在每天的最后一个文件，经常出现时间连续，但是天数提前增加的情况，
        % 即：2003/12/21 23:59:56（正确时间）---2003/12/22 23:59:56(错误的记录时间）
        % 要把剔除掉或者修正
        [temp_m2,temp_n2]=size(keo_time);
        n2=(keo_time(2:temp_m2)-keo_time(1:temp_m2-1));
        n2_ind=find(n2>0.9);
        [n2_ind_m,n2_ind_n]=size(n2_ind);
        if n2_ind_m>0
            keo_time(n2_ind+1,:)=keo_time(n2_ind,:)+(keo_time(2,:)-keo_time(1,:));
        end
%         keo_data(:,n2_ind+1)=[];
        clear n1 n2 n1_ind n2_ind;
        %-----------------------------------------------
        
        [tempG_m,tempG_n]=size(keo_time);        
        startG=keo_time(1);
        endG=keo_time(tempG_m);
        tt10=keo_time(2)-keo_time(1);
        %---------------------------------------------
        % 判断keo_data中是否有断层,并予以补齐
        t_ind=round((endG-startG)/tt10+1); % 从首尾时间值获得数据矩阵长度
        if t_ind>tempG_m % 计算出来的长度大于实际长度，意味存在断层,要进行填充处理
            new_keo_data=nan*zeros(G_column,t_ind);
            startG_vec=datevec(startG);
            new_keo_time=datenum(startG_vec(1),startG_vec(2),startG_vec(3),...
                startG_vec(4),startG_vec(5),startG_vec(6)+([1:t_ind]-1)*10);
            t1_data=round((keo_time(2:tempG_m)-keo_time(1:tempG_m-1))/tt10);
            t1_ind=find(t1_data>1); % 寻找大于1的索引位置
            [tm,tn]=size(t1_ind);
            if tm>0
                t2_ind=[1;t1_ind+1]; % 间断开始序列号
                t1_ind=[t1_ind;tempG_m];% 间断结束序列号
                
                
                new_t1_ind=round((keo_time(t1_ind)-startG)/tt10+1); % 间断结束在新数据矩阵中的序列号
                new_t2_ind=round((keo_time(t2_ind)-startG)/tt10+1); % 间断开始在新数据矩阵中的序列号
                
                for x=1:tm+1
                    new_keo_data(:,new_t2_ind(x):new_t1_ind(x))=keo_data(:,t2_ind(x):t1_ind(x));
                end
                clear keo_data keo_time;
                clear t1_ind t2_ind new_t1_ind new_t2_ind;
                keo_data=new_keo_data; 
                keo_time=new_keo_time;
                
                startG=keo_time(1);
                endG=keo_time(t_ind);
                [tempG_m,tempG_n]=size(keo_time');
                clear t_ind;
            end
        end
        
        %---------------------------------------------
        
        if (startG<starttime)&(endG>=starttime)&(endG<=endtime) % 3
%             t_ind=find(keo_time==starttime);
%             index3=tempG_m-t_ind+1;
            index3=round((endG-starttime)/t10+1);
            keoG(:,1:index3)=keo_data(:,tempG_m-index3+1:tempG_m);
%             part_G=part_G+1; % 有效数据段计数+1
%             partG_start(part_G)=1;
%             partG_end(part_G)=index3;
        elseif (startG>=starttime)&(startG<=endtime)&(endG>endtime) % 4 
%             t_ind=find(keo_time==endtime);
%             index4=t_ind;
            index4=round((endtime-startG)/t10+1);
            keoG(:,deltaIndex-index4+1:deltaIndex)=keo_data(:,1:index4);
%             part_G=part_G+1; % 有效数据段计数+1
%             partG_start(part_G)=deltaIndex-index4+1;
%             partG_end(part_G)=deltaIndex;
        elseif (startG>=starttime)&(endG<=endtime)  % 5
            index5=round((startG-starttime)/t10+1);
            keoG(:,index5:index5+tempG_m-1)=keo_data(:,1:tempG_m);
%             part_G=part_G+1; % 有效数据段计数+1
%             partG_start(part_G)=index5;
%             partG_end(part_G)=index5+tempG_m-1;
        elseif (startG<starttime)&(endG>endtime) % 6
            index6=find(keo_time>=starttime&keo_time<=endtime);
            keoG=keo_data(:,index6);
%             part_G=part_G+1; % 有效数据段计数+1
%             partG_start(part_G)=1;
%             partG_end(part_G)=deltaIndex;
        end
        clear keo_data keo_time;
    end
    %----------------------------------------------------------------------
    for j=1:R_m
        load(strcat(filenameR(j,:)));
        
        [temp_m,temp_n]=size(keo_time);
        temp_vec=datevec(keo_time);
        temp_vec(:,6)=round(temp_vec(:,6)/10)*10; % 对数据时间进行校准，校准到10的倍数
        keo_time=datenum(temp_vec);
        %-----------------------------------------------
        % 去掉小于或者等于0(时间相等)的keogram列
        n1=(keo_time(2:temp_m)-keo_time(1:temp_m-1));
        n1_ind=find(n1==0|n1<0);
        [n1_ind_m,n1_ind_n]=size(n1_ind);
        if n1_ind_m>0
            keo_time(n1_ind+1,:)=[];
            keo_data(:,n1_ind+1)=[];
        end
        %%------------------------
        % 2003年12月-2004年2月的数据中，在每天的最后一个文件，经常出现时间连续，但是天数提前增加的情况，
        % 即：2003/12/21 23:59:56（正确时间）---2003/12/22 23:59:56(错误的记录时间）
        % 要把剔除掉或者修正
        [temp_m2,temp_n2]=size(keo_time);
        n2=(keo_time(2:temp_m2)-keo_time(1:temp_m2-1));
        n2_ind=find(n2>0.9);
        [n2_ind_m,n2_ind_n]=size(n2_ind);
        if n2_ind_m>0
            keo_time(n2_ind+1,:)=keo_time(n2_ind,:)+(keo_time(2,:)-keo_time(1,:));
        end
        clear n1 n2 n1_ind n2_ind;
        %-----------------------------------------------
        
        [tempR_m,tempR_n]=size(keo_time);
        startR=keo_time(1);
        endR=keo_time(tempR_m);
        tt10=keo_time(2)-keo_time(1);
        %---------------------------------------------
        % 判断keo_data中是否有断层,并予以补齐
        t_ind=round((endR-startR)/tt10+1); % 从首尾时间值获得数据矩阵长度
        if t_ind>tempR_m % 计算出来的长度大于实际长度，意味存在断层,要进行填充处理
            new_keo_data=nan*zeros(R_column,t_ind);
            startR_vec=datevec(startR);
            new_keo_time=datenum(startR_vec(1),startR_vec(2),startR_vec(3),...
                startR_vec(4),startR_vec(5),startR_vec(6)+([1:t_ind]-1)*10);
            t1_data=round((keo_time(2:tempR_m)-keo_time(1:tempR_m-1))/tt10);
            t1_ind=find(t1_data>1); % 寻找大于1的索引位置
            [tm,tn]=size(t1_ind);
            if tm>0
                t2_ind=[1;t1_ind+1]; % 间断开始序列号
                t1_ind=[t1_ind;tempR_m];% 间断结束序列号
                
                                
                new_t1_ind=round((keo_time(t1_ind)-startR)/tt10+1); % 间断结束在新数据矩阵中的序列号
                new_t2_ind=round((keo_time(t2_ind)-startR)/tt10+1); % 间断开始在新数据矩阵中的序列号
                
                for x=1:tm+1
                    new_keo_data(:,new_t2_ind(x):new_t1_ind(x))=keo_data(:,t2_ind(x):t1_ind(x));
                end
                clear keo_data keo_time;
                clear t1_ind t2_ind new_t1_ind new_t2_ind;
                keo_data=new_keo_data; 
                keo_time=new_keo_time;
                
                startR=keo_time(1);
                endR=keo_time(t_ind);
                [tempR_m,tempR_n]=size(keo_time');
                clear t_ind;
            end
        end
        
        %---------------------------------------------
        
        if (startR<starttime)&(endR>=starttime)&(endR<=endtime) % 3
%             t_ind=find(keo_time==starttime);
%             index3=tempR_m-t_ind+1;
            index3=round((endR-starttime)/t10+1);
            keoR(:,1:index3)=keo_data(:,tempR_m-index3+1:tempR_m);
%             part_R=part_R+1; % 有效数据段计数+1
%             partR_start(part_R)=1;
%             partR_end(part_R)=index3;
        elseif (startR>=starttime)&(startR<=endtime)&(endR>endtime) % 4 
%             t_ind=find(keo_time==endtime);
%             index4=t_ind;
            index4=round((endtime-startR)/t10+1);
            keoR(:,deltaIndex-index4+1:deltaIndex)=keo_data(:,1:index4);
%             part_R=part_R+1; % 有效数据段计数+1
%             partR_start(part_R)=deltaIndex-index4;
%             partR_end(part_R)=deltaIndex;
        elseif (startR>=starttime)&(endR<=endtime)  % 5
            index5=round((startR-starttime)/t10+1);
            keoR(:,index5:index5+tempR_m-1)=keo_data(:,1:tempR_m);
%             part_R=part_R+1; % 有效数据段计数+1
%             partR_start(part_R)=index5;
%             partR_end(part_R)=index5+tempR_m-1;
        elseif (startR<starttime)&(endR>endtime) % 6
            index6=find(keo_time>=starttime&keo_time<=endtime);
            keoR=keo_data(:,index6);
%             part_R=part_R+1; % 有效数据段计数+1
%             partR_start(part_R)=1;
%             partR_end(part_R)=deltaIndex;
        end
        clear keo_data keo_time;
    end
    %----------------------------------------------------------------------
    for j=1:V_m
        load(strcat(filenameV(j,:)));
        
        [temp_m,temp_n]=size(keo_time);
        temp_vec=datevec(keo_time);
        temp_vec(:,6)=round(temp_vec(:,6)/10)*10; % 对数据时间进行校准，校准到10的倍数
        keo_time=datenum(temp_vec);
        %-----------------------------------------------
        % 去掉小于或者等于0(时间相等)的keogram列
        n1=(keo_time(2:temp_m)-keo_time(1:temp_m-1));
        n1_ind=find(n1==0|n1<0);
        [n1_ind_m,n1_ind_n]=size(n1_ind);
        if n1_ind_m>0
            keo_time(n1_ind+1,:)=[];
            keo_data(:,n1_ind+1)=[];
        end
        %%------------------------
        % 2003年12月-2004年2月的数据中，在每天的最后一个文件，经常出现时间连续，但是天数提前增加的情况，
        % 即：2003/12/21 23:59:56（正确时间）---2003/12/22 23:59:56(错误的记录时间）
        % 要把剔除掉或者修正
        [temp_m2,temp_n2]=size(keo_time);
        n2=(keo_time(2:temp_m2)-keo_time(1:temp_m2-1));
        n2_ind=find(n2>0.9);
        [n2_ind_m,n2_ind_n]=size(n2_ind);
        if n2_ind_m>0
            keo_time(n2_ind+1,:)=keo_time(n2_ind,:)+(keo_time(2,:)-keo_time(1,:));
        end
        clear n1 n2 n1_ind n2_ind;
        %-----------------------------------------------
        
        [tempV_m,tempV_n]=size(keo_time);
        startV=keo_time(1);
        endV=keo_time(tempV_m);
        tt10=keo_time(2)-keo_time(1); % 计算相邻文件之间的偏移量
        %---------------------------------------------
        % 判断keo_data中是否有断层,并予以补齐
        t_ind=round((endV-startV)/tt10+1); % 从首尾时间值获得数据矩阵长度
        if t_ind>tempV_m % 计算出来的长度大于实际长度，意味存在断层,要进行填充处理
            new_keo_data=nan*zeros(V_column,t_ind);
            startV_vec=datevec(startV);
            new_keo_time=datenum(startV_vec(1),startV_vec(2),startV_vec(3),...
                startV_vec(4),startV_vec(5),startV_vec(6)+([1:t_ind]-1)*10);
            t1_data=round((keo_time(2:tempV_m)-keo_time(1:tempV_m-1))/tt10);
            t1_ind=find(t1_data>1); % 寻找大于1的索引位置
            [tm,tn]=size(t1_ind);
            if tm>0
                t2_ind=[1;t1_ind+1]; % 间断开始序列号，原来数据矩阵的开始要加入
                t1_ind=[t1_ind;tempV_m];% 间断结束序列号,原来数据矩阵的结束要加入
                
                
                new_t1_ind=round((keo_time(t1_ind)-startV)/tt10+1); % 间断结束在新数据矩阵中的序列号
                new_t2_ind=round((keo_time(t2_ind)-startV)/tt10+1); % 间断开始在新数据矩阵中的序列号
                
                for x=1:tm+1
                    new_keo_data(:,new_t2_ind(x):new_t1_ind(x))=keo_data(:,t2_ind(x):t1_ind(x));
                end
                clear keo_data keo_time;
                clear t1_ind t2_ind new_t1_ind new_t2_ind;
                keo_data=new_keo_data; 
                keo_time=new_keo_time;
                
                startV=keo_time(1);
                endV=keo_time(t_ind);
                [tempV_m,tempV_n]=size(keo_time');
                clear t_ind;
            end
        end
        
        %---------------------------------------------
        
        if (startV<starttime)&(endV>=starttime)&(endV<=endtime) % 3
%             t_ind=find(keo_time==starttime);
%             index3=tempV_m-t_ind+1;
            index3=round((endV-starttime)/t10+1);
            keoV(:,1:index3)=keo_data(:,tempV_m-index3+1:tempV_m);
%             part_V=part_V+1; % 有效数据段计数+1
%             partV_start(part_V)=1;
%             partV_end(part_V)=index3;
        elseif (startV>=starttime)&(startV<=endtime)&(endV>endtime) % 4 
%             t_ind=find(keo_time==endtime);
%             index4=t_ind;
            index4=round((endtime-startV)/t10+1);
            keoV(:,deltaIndex-index4+1:deltaIndex)=keo_data(:,1:index4);
%             part_V=part_V+1; % 有效数据段计数+1
%             partV_start(part_V)=deltaIndex-index4+1;
%             partV_end(part_V)=deltaIndex;
        elseif (startV>=starttime)&(endV<=endtime)  % 5
            index5=round((startV-starttime)/t10+1);
            keoV(:,index5:index5+tempV_m-1)=keo_data(:,1:tempV_m);
%             part_V=part_V+1; % 有效数据段计数+1
%             partV_start(part_V)=index5;
%             partV_end(part_V)=index5+tempV_m-1;
        elseif (startV<starttime)&(endV>endtime) % 6
            index6=find(keo_time>=starttime&keo_time<=endtime);
            keoV=keo_data(:,index6);
%             part_V=part_V+1; % 有效数据段计数+1
%             partV_start(part_V)=1;
%             partV_end(part_V)=deltaIndex;
        end
        clear keo_data keo_time;
    end
    %---------------------------------------------------
    % part参数分别记录keoG/keoR/keoV由几部分(非nan数据段)组成
    % partG_start/partG_end则分别记录每个部分的开始/结束位置(列值)
     
    keoG_nan=isnan(keoG(1,:));
    keoR_nan=isnan(keoR(1,:));
    keoV_nan=isnan(keoV(1,:));
    %-----------
    part_G=0; % 默认非nan的部分为0个
    G_nan_ind=find(keoG_nan~=1);  % 不为nan的列索引
    [G_nan_m,G_nan_n]=size(G_nan_ind);
    
    if G_nan_n~=0 % 不为nan的列数如果存在，进行下面计算，否则意味全为nan
        d_G_nan_ind=G_nan_ind(2:G_nan_n)-G_nan_ind(1:G_nan_n-1);
        t_G_ind=find(d_G_nan_ind>1);
        [t_G_m,t_G_n]=size(t_G_ind);
        partG_end=[G_nan_ind(t_G_ind) G_nan_ind(G_nan_n)];
        partG_start=[G_nan_ind(1) G_nan_ind(t_G_ind+1)]; 
        
        t=partG_end-partG_start;
        t_i=find(t==0);
        partG_start(t_i)=[]; % 去掉单独的非nan列
        partG_end(t_i)=[]; 
        [mm,part_G]=size(partG_start);      
    end
    
    %-----------
    part_R=0;
    R_nan_ind=find(keoR_nan~=1); 
    [R_nan_m,R_nan_n]=size(R_nan_ind);
    
    if R_nan_n~=0
        d_R_nan_ind=R_nan_ind(2:R_nan_n)-R_nan_ind(1:R_nan_n-1);
        t_R_ind=find(d_R_nan_ind>1);
        [t_R_m,t_R_n]=size(t_R_ind);
        partR_end=[R_nan_ind(t_R_ind) R_nan_ind(R_nan_n)];
        partR_start=[R_nan_ind(1) R_nan_ind(t_R_ind+1)]; 
        
        t=partR_end-partR_start;
        t_i=find(t==0);
        partR_start(t_i)=[]; % 去掉单独的非nan列
        partR_end(t_i)=[];
        [mm,part_R]=size(partR_start);     
    end
    
    %-----------
    part_V=0;
    V_nan_ind=find(keoV_nan~=1); 
    [V_nan_m,V_nan_n]=size(V_nan_ind);
    
    if V_nan_n~=0
        d_V_nan_ind=V_nan_ind(2:V_nan_n)-V_nan_ind(1:V_nan_n-1);
        t_V_ind=find(d_V_nan_ind>1);
        [t_V_m,t_V_n]=size(t_V_ind);
        partV_end=[V_nan_ind(t_V_ind) V_nan_ind(V_nan_n)];
        partV_start=[V_nan_ind(1) V_nan_ind(t_V_ind+1)]; 
        
        t=partV_end-partV_start;
        t_i=find(t==0);
        partV_start(t_i)=[]; % 去掉单独的非nan列
        partV_end(t_i)=[]; 
        [mm,part_V]=size(partV_start);      
    end
    
    %---------------------------------------------------
    % 绘制图像
   VGR_f=figure;
   %---------------------
   % 选择不同的颜色色表
   switch colormap_n
       case 1
           colormap(jet);
           colormap_str='jet';
       case 2
           colormap(gray);
           colormap_str='gray';
       case 3
           colormap(hot);
           colormap_str='hot';
   end
   %---------------------
%     av=subplot(3,1,1);
    av=axes('Position',[0.1300    0.4700    0.7750    0.1500]);
%     set(av,'Position',[0.1300    0.4900    0.7750    0.1500]);
    if part_V==0
        if pro_n==1
            v_img=imagesc(keoV,c_LimV);
        elseif pro_n==2
            v_img=imagesc((keoV-594)*1.5280,c_LimV)
        end
        set(v_img,'Visible','off');
        clear part_V partV_start partV_end;
%     elseif part_V==1
%         v_img=imagesc(keoV,c_LimV);
%         clear part_V partV_start partV_end;
    else
        for v_p=1:part_V
            if pro_n==1
                v_img=imagesc(keoV(:,partV_start(v_p):partV_end(v_p)),c_LimV);                
            elseif pro_n==2
                v_img=imagesc((keoV(:,partV_start(v_p):partV_end(v_p))-594)*1.5280,c_LimV); 
            end
             set(v_img,'XData',[partV_start(v_p) partV_end(v_p)]);
             hold on;   
        end
        clear part_V partV_start partV_end;
    end
    set(gca,'TickDir','out','FontName','Times New Roman','Fontsize',10,'FontWeight','bold','Box','on');
    set(gca,'XLim',[1 deltaIndex]);
    set(gca,'YLim',[1 R_column]);
    set(gca,'XTick',Xa,'XTickLabel',[],'XMinorTick','on');    
    set(gca,'YTick',YaV,'YTickLabel',Yb);
    ylabel('427.8 nm');
%     title('Wavelength:427.8nm');
    
%     hv=colorbar('horiz') ;
    hv=colorbar('vert') ;
%     set(hv,'Position',[0.1300    0.6820    0.7750    0.0168]);
    set(hv,'Position',[0.9150    0.4700    0.0120    0.1500]);
    set(hv,'TickDir','in','TickLength',[0.01 0.01],'FontName','Times New Roman','Fontsize',8,'FontWeight','bold','Box','on');
    set(get(hv,'Ylabel'),'FontName','Times New Roman','Fontsize',8,'FontWeight','bold','String','Rayleigh');
%     set(hv,'XTick',C_YaV,'XTickLabel',C_YbV);
%     set(get(hv,'Ylabel'),'FontAngle','italic','FontWeight','bold','String','Unit:Count'); 
    %---------------------------------------------------
%     ag=subplot(3,1,2);
    ag=axes('Position',[0.1300    0.3100    0.7750    0.1500]);
%     set(ag,'Position',[0.1300    0.3200    0.7750    0.1500]);
%     imagesc(keoG,c_LimG); 
    if part_G==0
        if pro_n==1
            g_img=imagesc(keoG,c_LimG);
        elseif pro_n==2
            g_img=imagesc((keoG-564)*1.0909,c_LimG);
        end
        set(g_img,'Visible','off');
        clear part_G partG_start partG_end;
%     elseif part_G==1
%         g_img=imagesc(keoG,c_LimG);
%         clear part_G partG_start partG_end;
    else
        for g_p=1:part_G
            if pro_n==1
                g_img=imagesc(keoG(:,partG_start(g_p):partG_end(g_p)),c_LimG);
            elseif pro_n==2
                g_img=imagesc((keoG(:,partG_start(g_p):partG_end(g_p))-564)*1.0909,c_LimG);
            end
            set(g_img,'XData',[partG_start(g_p) partG_end(g_p)]);
            hold on;
        end
        clear part_G partG_start partG_end;
    end
    set(gca,'TickDir','out','FontName','Times New Roman','Fontsize',10,'FontWeight','bold','Box','on');
    set(gca,'XLim',[1 deltaIndex]);
    set(gca,'YLim',[1 G_column]);
    set(gca,'XTick',Xa,'XTickLabel',[],'XMinorTick','on');    
    set(gca,'YTick',YaG,'YTickLabel',Yb);
    ylabel('557.7nm');
%     title('Wavelength:557.7nm');
    
%     hg=colorbar('horiz') ;
    hg=colorbar('vert') ;
%     set(hv,'Position',[0.1300    0.6820    0.7750    0.0168]);

    set(hg,'Position',[0.9150   0.3100   0.0120    0.1500]);
    set(hg,'TickDir','in','TickLength',[0.01 0.01],'FontName','Times New Roman','Fontsize',8,'FontWeight','bold','Box','on');
    set(get(hg,'Ylabel'),'FontName','Times New Roman','Fontsize',8,'FontWeight','bold','String','Rayleigh');
%     set(hv,'XTick',C_YaV,'XTickLabel',C_YbV);
%     set(get(hg,'Xlabel'),'FontAngle','italic','FontWeight','bold','String','Unit:Count');
     %---------------------------------------------------
%     ar=subplot(3,1,3);
    ar=axes('Position',[0.1300    0.1500    0.7750    0.1500]);
%     set(ar,'Position',[0.1300    0.1500    0.7750    0.1500]);
%     imagesc(keoR,c_LimR); 
    if part_R==0
        if pro_n==1
            r_img=imagesc(keoR,c_LimR);
        elseif pro_n==2
            r_img=imagesc((keoR-1137)*0.5159,c_LimR);
        end
        set(r_img,'Visible','off');
        clear part_R partR_start partR_end;
%     elseif part_R==1
%         r_img=imagesc(keoR,c_LimR);
%         clear part_R partR_start partR_end;
    else
        for r_p=1:part_R
            if pro_n==1
                r_img=imagesc(keoR(:,partR_start(r_p):partR_end(r_p)),c_LimR);
            elseif pro_n==2
                r_img=imagesc((keoR(:,partR_start(r_p):partR_end(r_p))-1137)*0.5159,c_LimR);
            end           
            set(r_img,'XData',[partR_start(r_p) partR_end(r_p)]);
            hold on;
        end
        clear part_R partR_start partR_end;
    end
    set(gca,'TickDir','out','FontName','Times New Roman','Fontsize',10,'FontWeight','bold','Box','on');
    set(gca,'XLim',[1 deltaIndex]);
    set(gca,'YLim',[1 R_column]);
    set(gca,'XTick',Xa,'XTickLabel',Xb,'XMinorTick','on');    
    set(gca,'YTick',YaR,'YTickLabel',Yb);
    ylabel('630.0 nm');
    xlabel(strcat('Universal time(',s_tr(1:10),')'));
%     title('Wavelength:630.0nm');
    
    hr=colorbar('vert') ;
%     set(hv,'Position',[0.9100    0.1113    0.0300    0.2280]);
%     hr=colorbar('horiz') ;
    set(hr,'Position',[0.9150    0.1500    0.0120    0.1500]);
    set(hr,'TickDir','in','TickLength',[0.01 0.01],'FontName','Times New Roman','Fontsize',8,'FontWeight','bold','Box','on');
    set(get(hr,'Ylabel'),'FontName','Times New Roman','Fontsize',8,'FontWeight','bold','String','Rayleigh');
    
%     set(hv,'XTick',C_YaV,'XTickLabel',C_YbV);
%     set(get(hr,'Ylabel'),'FontAngle','italic','FontWeight','bold','String','Unit:Count');
    %---------------------------------------------------
    %-------------------------
    % 当页图象的头信息
    h_title=axes('Units','centimeters','Position',[0.5 27.95 20 1]);%,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1]);
    set(h_title,'XLim',[0 20],'XTick',[],'XTickLabel',[]);
    set(h_title,'YLim',[0 1],'YTick',[],'YTickLabel',[]);
    set(h_title,'Visible','off');
    title_1=text(3.2,-8.1,'Auroral Keogram at Yellow River Station','Color','k','FontName','Times New Roman','Fontsize',20,'FontWeight','bold');    
    title_2=text(2,-8.9,['Start Time:',s_tr(1:10),'/',s_tr(12:19)],'Color','k','FontName','Times New Roman','Fontsize',10,'FontWeight','bold');
    title_3=text(2,-9.6,['End  Time:',e_tr(1:10),'/',e_tr(12:19)],'Color','k','FontName','Times New Roman','Fontsize',10,'FontWeight','bold');
    title_4=text(13.8,-8.9,'GEO:(78.92^o,  11.95^o)','Color','k','FontName','Times New Roman','Fontsize',10,'FontWeight','bold');
    title_5=text(13.8,-9.6,'CGM:(75.25^o,112.08^o)','Color','k','FontName','Times New Roman','Fontsize',10,'FontWeight','bold');
    %-------------------------
    % 标出色标的单位
%     title_V1=text(0.9,-9.3,'Unit:','Color','k','FontName','Times New Roman','Fontsize',8,'FontWeight','bold');
%     title_V2=text(0.9,-9.6,'Rayleigh','Color','k','FontName','Times New Roman','Fontsize',8,'FontWeight','bold');
%     title_G1=text(0.9,-17.8,'Unit:','Color','k','FontName','Times New Roman','Fontsize',8,'FontWeight','bold');
%     title_G2=text(0.9,-18.1,'Rayleigh','Color','k','FontName','Times New Roman','Fontsize',8,'FontWeight','bold');
%     title_R1=text(0.9,-26.2,'Unit:','Color','k','FontName','Times New Roman','Fontsize',8,'FontWeight','bold');
%     title_R2=text(0.9,-26.5,'Rayleigh','Color','k','FontName','Times New Roman','Fontsize',8,'FontWeight','bold');
    %-------------------------
    % 当页图象的尾信息
%     b_title=axes('Units','centimeters','Position',[0.5 27.95 20 1]);
    title_6=text(2,-25,['Group: ',GroupName],'Color','k','FontName','Times New Roman','Fontsize',8,'FontWeight','bold');
    title_7=text(2,-25.5,['Institute: ',InstitudeName],'Color','k','FontName','Times New Roman','Fontsize',8,'FontWeight','bold');
    title_8=text(13.8,-25,['Name: ',WorkerName],'Color','k','FontName','Times New Roman','Fontsize',8,'FontWeight','bold');
    title_9=text(13.8,-25.5,['E-mail: ',WorkerEMail],'Color','k','FontName','Times New Roman','Fontsize',8,'FontWeight','bold');
    %-------------------------
    % 当夜dangye tuxiangde weixinxi 
    %---------------------------------------------------
    % 输出图形到ps文件
    toptimestr=strcat(TopTime(1:2),TopTime(4:5),TopTime(7:8));
    endtimestr=strcat(EndTime(1:2),EndTime(4:5),EndTime(7:8));
    printname=[TopDay,'_',EndDay,'_',toptimestr,'_',endtimestr,'_',colormap_str];
    set(gcf,'PaperOrientation','portrait');
    set(gcf,'PaperType','A4');
    set(gcf,'PaperPosition',[0.63 0.63 19.72 28.41]);
    eval(['print ',printname,' -dpsc2 -append']);
%     close(VGR_f);
    %---------------------------------------------------

end


