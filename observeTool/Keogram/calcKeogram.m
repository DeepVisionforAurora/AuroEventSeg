clear all
close all
clc;

day = '20040118';

ImagePath = ['..\N'  day 'G'];
imgList = textread(['..\ImageList\ImgList_N' day 'G.txt'],'%s');     
keogram = uint8(zeros(440,4320));

for i=1:size(imgList,1)
    filename = [imgList{i}];
    img   =  imread([ImagePath '\' filename]);
  
    col = (str2num(filename(11:12))-3)*360+str2num(filename(13:14))*6+str2num(filename(15))+1;
    keogram(:,col) = img(:,220);
end

figure; imshow(keogram);    
colormap('jet'); 

imwrite(keogram, ['Keogram_N' day 'G.bmp'], 'bmp');