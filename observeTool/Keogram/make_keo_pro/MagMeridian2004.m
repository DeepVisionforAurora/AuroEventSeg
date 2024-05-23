function  MagNS=MagMeridian2004(Img,Band)
% 图像矩阵的行相当于图像坐标轴中的Y，图像矩阵中的列相当于图像坐标轴中的X
% 从全天空图像中获得磁子午线数据
% MagNS:    中国北极站全天空图像磁子午线数组
% img:      中国北极站全天空图像矩阵（512*512）
% band:     图像波段: 'V','G','R'
% 4278：
% 中心为（257，255），半径为r=246
% 中国站－地磁北极连线与y=255的夹角为：27.3682°
% MN点坐标为：(475,142) 
% MS点坐标为：(39,368)					 
% 5577：
% 中心为（261，257），半径为r=246
% 中国站－地磁北极连线与y=257的夹角为：28.8664°
% 6300：
% 中心为（256，257），半径为r=246
% 中国站－地磁北极连线与y=257的夹角为：27.8340°
switch Band
    case 'V'
        x0=257;
        y0=255;
        r=246;
        theta=deg2rad(27.3682); % 与y=255的夹角为：27.3682°
        
        MagNS=nan*zeros(475-39+1,1);
        n=0;
        for x=475:-1:39 % 从地磁北极到南极
            n=n+1;
            y=round(y0-tan(theta)*(x-x0));
            MagNS(n,1)=Img(y,x);
        end
    case 'G'
        x0=261;
        y0=257;
        r=246;
        theta=deg2rad(28.8664); % 与y=255的夹角为：27.3682°
        
        MagNS=nan*zeros(479-43+1,1);
        n=0;
        for x=479:-1:43 % 从地磁北极到南极
            n=n+1;
            y=round(y0-tan(theta)*(x-x0));
            MagNS(n,1)=Img(y,x);
        end
    case 'R'
        x0=256;
        y0=257;
        r=246;
        theta=deg2rad(27.8340); % 与y=255的夹角为：27.3682°
        
        MagNS=nan*zeros(474-38+1,1);
        n=0;
        for x=474:-1:38 % 从地磁北极到南极
            n=n+1;
            y=round(y0-tan(theta)*(x-x0));
            MagNS(n,1)=Img(y,x);
        end
end
 