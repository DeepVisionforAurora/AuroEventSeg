# AuroEventSeg

This is a source code used in the paper "Automatic Auroral Event Segmentation Based on Ground-based Observation"  

Implementation for AuroEventSeg needs:  

* **Auroral_Event_Observe_Tool.m**. The scripts are used to browse the ASI image sequence and annotate aurora events to get an overview of auroral activity.   

* **auroralActMonitor.m**. This code is used to monitoring auroral activity change at pixel and sequence level, which ensures that both macroscopic variations in auroral sequences and local key structures in auroral images can be taken into account.  

* **auroEventSeg.m**. This code is used to segment aurora events using an unsupervised way based on the previous step, which provides an effective tool for estimating the start and lifetime of auroral events without human involvement.  

* **lowrank_corr.m**. Low-rank for generating spatial attention maps indicating locations of emphasis or inhibition to detect motion saliency is based on the GoDec[1] code provided by Tianyi Zhou.   


## How To Use

Download the above code and packages and install the required toolbox and dependencies.  

A demo to segment aurora events is provided. An effective tool for estimating the start and lifetime of auroral events without human involvement are provided.  

The file in the code is organized as:  

* ASIImgSequence folder contains ASI image sequence used to segment aurora events, where each folder name contains the N/S, date, number of images in the folder and time information. For example, "N20031221G_08_11_1139" represents 1139 ASI images taken from 08:00 to 11:00 on December 21, 2003, where N is the North Pole and G is the G-band.  

* The auroAct folder is the line of monitored changes in aurora activity at the pixel and sequence levels. The file naming rules are the same as for ASIImgSequence.   

* The keo folder reads the aurora variation curve from the aurora activity file to plot the keogram for untrimmed auroral sequences of any length. File names such as "N20031221G081212_N20031221G112151" indicate that the keogram is plot from images taken between 08:12:12 December 21, 2003 and 11:21:51 December 21, 2003.  

* The observeTool provides a GUI software.  

For  segment auroral events:   

* First run **auroralActMonitor.m** to monitor auroral activities and get changeLine;  

* Once you have changeLine, run **auroEventSeg.m** to segment untrimmed auroral sequences of any length;  

* In addition to that, you can run **plotKeogram.m** to plot keogram for untrimmed auroral sequences of any length. The keogram is also provided in our code, in the **'.\keo'** directory;  

* We also provide a GUI software to browse the ASI image sequence and annotate aurora events to get an overview of auroral activity, in the observeTool folder, by running **Auroral_Event_Observe_Tool.m**.  


## Data

The aurora images in this dataset are from the all-sky imagers at the Yellow River Station (YRS). And it is used in the paper the auroral sequence in the All-sky Image is automatically segmented to estimate the start and lifetime of auroral events. The data source, acquisition instruments, data characteristics, preprocessing methods, and naming conventions of this dataset are detailed at https://zenodo.org/records/10013563.  

## Reference
[1] Guo K, Liu L, Xu X, et al. GoDec+: Fast and robust low-rank matrix decomposition based on maximum correntropy[J]. IEEE transactions on neural networks and learning systems, 2017, 29(6): 2323-2336.  
