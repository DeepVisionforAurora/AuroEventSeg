clear all
clc;
tic

imgPath = '..\AllImages';
LBPPath = '..\AllLBPImages';
if ~exist(LBPPath)
   mkdir(LBPPath);
end

labeled = textread('Labels20031222_NoPath.txt','%s');      % read the label file
labeled = reshape(labeled, 2, length(labeled)/2);
labeled = labeled';
for i=1:size(labeled,1)
    filename = [labeled{i,1}];
    img = imread([imgPath '\' filename]);
    im1 = double(img);
  
    % Caculate the LBP image
    lbpImage= lbp_image(im1,'P8R2');
    lbpImage = uint8(lbpImage);
    
    destFilename = [LBPPath '\' filename];
    imwrite(lbpImage, destFilename, 'bmp'); 
end

toc