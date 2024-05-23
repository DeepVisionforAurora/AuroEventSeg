%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                           AuroEventSeg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       This code is used to segment untrimmed auroral sequences of any length.
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
%       % Read auroral change curvees from an auroral activity file
%       linePath='.\auroAct\';
%
%       % Read auroral keogram from an auroral keogram file%
%       keogramPath='.\keo\';
%
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

clc; clear all
close all
linePath='.\auroAct\';
lines=dir( [linePath 'C*']);
keogramPath='.\keo\';
keograms=dir( [keogramPath 'K*']);

windowSize = 60;
halfWin=floor(windowSize/2);
b = (1/windowSize)*ones(1,windowSize);
a = 1;

for i=1:length(lines)
    
    allLines=load([linePath  lines(i).name]);
    imgs=dir(['.\ASIImgSequence\' lines(i).name(12:32) '\*.bmp']);
    
    
    keogramName=keograms(i).name;
    keo=load([keogramPath keogramName]);
    keoImage=keo.keogram;
    
    lineToShow=allLines.changeA2;
    
    TLim=length(lineToShow);
    figure;
    set(gcf,'position',[786 366 1292 790]);
    subplot('Position', [.05 .01+0.5  .93  .40]);
    
    
    %     lineToShow=allLines.changeB2;
    %     %     lineToShow = filter(b,a, lineToShow);
    %     %     lineToShow (1:end-halfWin)=lineToShow(halfWin+1:end);
    %     lineToShow=lineToShow./max(lineToShow);
    %     p_L=plot([1:TLim], lineToShow,'linewidth', 2, 'Color',[94 155 236]./255); hold on % local
    
    
    %     lineToShow=allLines.changeC;
    %     %     lineToShow = filter(b,a, lineToShow);
    %     %     lineToShow (1:end-halfWin)=lineToShow(halfWin+1:end);
    %     lineToShow=lineToShow./max(lineToShow);
    %     p_G=plot([1:TLim], lineToShow,'linewidth', 2,'Color',[110 208 154]./255); hold on %%global
    
    
    %     lineToShow=allLines.changeD;
    %     %     lineToShow = filter(b,a, lineToShow);
    %     %     lineToShow (1:end-halfWin)=lineToShow(halfWin+1:end);
    %     lineToShow=lineToShow./max(lineToShow);
    %     p_S=plot([1:TLim], lineToShow,'linewidth', 2, 'Color', [197 152 231]./255); hold on % Shape
    
    lineToShow=allLines.changeA2;
    lineToDetect = filter(b,a, lineToShow);
    lineToDetect (1:end-halfWin)=lineToDetect (halfWin+1:end);
    
%     [v,pos,w,p]= findpeaks(  lineToShow ,'Threshold',0, 'MinPeakDistance', 20,'MinPeakProminence',1*10^8.4,'MinPeakHeight',0); %  % 1 our method: shape-constrained+global+local   1*mean(lineToShow)
    [v,pos,w,p]= findpeaks(  lineToDetect ,'Threshold',0, 'MinPeakDistance', 20,'MinPeakProminence',2*10^8,'MinPeakHeight',0); %  % 1 our method: shape-constrained+global+local   1*mean(lineToShow)
 
    
    lineToDetect=lineToDetect./max(lineToDetect);
    lineToShow=lineToShow./max(lineToShow);
    
    p_Our=plot([1:TLim], lineToShow,'k--','linewidth', 1.5); hold on %our
    
    p_Our=plot([1:TLim], lineToDetect,'r','linewidth', 2); hold on %our
    
    
    for ii=1:length(pos)
        plot([pos(ii),pos(ii)],[0 lineToDetect(pos(ii))],'--k','linewidth', 1.5); hold on
    end
    plot(pos,lineToDetect(pos),'o','MarkerSize',8,'MarkerFaceColor','r','MarkerEdgeColor','k')
    %     legend([p_S,p_G,p_L,p_Our],{'Shaped-constrained','Sequence overview','Local attention','Our method'})
    
    
    
    
    showLim=[61 959];%20031224: 12:00---14:30
    showLim=[66 800];%28
    showLim=[1+60 TLim-60];
    set(gca,'XLim',showLim,'YLim',[0,max(lineToShow)*1.1], 'YGrid','on','XTickLabel',[],'GridAlpha',0.8,'GridLineStyle','-');
    axis off
    set(gca,'FontName', 'Times New Roman','Fontsize',12);
    
    %     set(gca,'Position',[0.0513,0.1456,0.9254,0.7739],'OuterPosition',[-0.10,0.000,1.19,0.99])
    axis on;
    ylabel('Change');
    
    
    subplot('Position', [.05 .08 .93  .40]);
    imagesc(keoImage); hold on
    colormap('jet')
%     for ii=1:length(pos)
%         Xline(pos(ii),'--w','linewidth', 2.5,'Alpha',1);hold on
%     end
    for ii = 1:length(pos)
    % ªÊ÷∆¥π÷±œﬂ
        line([pos(ii), pos(ii)], ylim, 'LineStyle', '--', 'Color', 'w', 'LineWidth', 2.5);
    end

    
    peakName=[];
    FigName=['fig_' keogramName(9:end-4)];
    peakIndex=unique([showLim(1), pos,showLim(2)]);
    for tname=1:length(peakIndex)
        nameT=imgs(peakIndex(tname));
        NN=[nameT.name(11:12) ':' nameT.name(13:14) ':' nameT.name(15:16)];
        peakName=[peakName; NN];
    end
    
    
    set(gca,'XLim',showLim,'YTick',[1:73:440],'YTickLabel',[' 90';' 60';' 30';'  0';'-30';'-60';'-90'],'XTickLabel',[ ])
    
    set(gca,'XTick',peakIndex,'XTickLabel',peakName,'FontName', 'Times New Roman','Fontsize',12)
    
    
    xlabel('Time (UT)');
    
    ylabel('Zenith angle (Deg.)');
    set(gca,'FontName', 'Times New Roman','Fontsize',12);

    
    
end