% Draw the annual mean runoff ratio raincloud graph and monthly mean runoff ratio of the LPJGUESS to GRUN
%2022/11/26  Hao Zhou
clc;
clear;
tic;

%% Ecoregion area
%Tropical_Subtropical_Moist_Broadleaf_Forests 
%Tropical_Subtropical_Coniferous_Forests 
%Tropical_&_Subtropical_Grasslands,_Savannas_&_Shrublands 
%Tropical_&_Subtropical_Dry_Broadleaf_Forests
%Temperate_Grasslands,_Savannas_&_Shrublands 
%Temperate_Conifer_Forests
%Temperate_Broadleaf_&_Mixed_Forests
%Montane_Grasslands_&_Shrublands
%Mediterranean_Forests,_Woodlands_&_Scrub
%Boreal_Forests_Taiga
%Tundra
%abbreviation:TSMBF TSCF TSGSS TSDBF TGSS TCF TBMF MGS MFWS BFT TU
[S1_x,S1_y]=textread('G:\LPJGUESSHydrologyBalanceCheck\4RegionData\Ecoregion\Fourteen types ecoregion\detailed point txt\Tropical_Subtropical_Moist_Broadleaf_Forests.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S2_x,S2_y]=textread('G:\LPJGUESSHydrologyBalanceCheck\4RegionData\Ecoregion\Fourteen types ecoregion\detailed point txt\Tropical_Subtropical_Coniferous_Forests.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S3_x,S3_y]=textread('G:\LPJGUESSHydrologyBalanceCheck\4RegionData\Ecoregion\Fourteen types ecoregion\detailed point txt\Tropical_&_Subtropical_Grasslands,_Savannas_&_Shrublands.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S4_x,S4_y]=textread('G:\LPJGUESSHydrologyBalanceCheck\4RegionData\Ecoregion\Fourteen types ecoregion\detailed point txt\Tropical_&_Subtropical_Dry_Broadleaf_Forests.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S5_x,S5_y]=textread('G:\LPJGUESSHydrologyBalanceCheck\4RegionData\Ecoregion\Fourteen types ecoregion\detailed point txt\Temperate_Grasslands,_Savannas_&_Shrublands.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S6_x,S6_y]=textread('G:\LPJGUESSHydrologyBalanceCheck\4RegionData\Ecoregion\Fourteen types ecoregion\detailed point txt\Temperate_Conifer_Forests.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S7_x,S7_y]=textread('G:\LPJGUESSHydrologyBalanceCheck\4RegionData\Ecoregion\Fourteen types ecoregion\detailed point txt\Temperate_Broadleaf_&_Mixed_Forests.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S8_x,S8_y]=textread('G:\LPJGUESSHydrologyBalanceCheck\4RegionData\Ecoregion\Fourteen types ecoregion\detailed point txt\Montane_Grasslands_&_Shrublands.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S9_x,S9_y]=textread('G:\LPJGUESSHydrologyBalanceCheck\4RegionData\Ecoregion\Fourteen types ecoregion\detailed point txt\Mediterranean_Forests,_Woodlands_&_Scrub.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S10_x,S10_y]=textread('G:\LPJGUESSHydrologyBalanceCheck\4RegionData\Ecoregion\Fourteen types ecoregion\detailed point txt\Boreal_Forests_Taiga.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S11_x,S11_y]=textread('G:\LPJGUESSHydrologyBalanceCheck\4RegionData\Ecoregion\Fourteen types ecoregion\detailed point txt\Tundra.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );


%% input/output Path and figure title Parameters
LPJFilePath='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mrunoff8514ave.out';
GRUNFilePath='D:\Program Files\PuTTY\GRUN_v1_GSWP3_WGS84_05_1902_2014.nc';
LPJPreciFilePath='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mpreci8514ave.out';

%% read data
%read LPJGUESS .out data
LPJFileData=ReadTxtData(LPJFilePath);
LPJPreciFileData=ReadTxtData(LPJPreciFilePath);
LineNum=size(LPJFileData,1)%show line number of file

% Read GRUN Runoff data 
%     Runoff
%     Size:       720x360x1356
%     Dimensions: X,Y,time 
ncdisp(GRUNFilePath);                                   %Display File Information                 
lon=double(ncread(GRUNFilePath,'X'));                   %Read the longitude range and accuracy      
lat=double(ncread(GRUNFilePath,'Y'));                   %Read the latitude range and accuracy
time=double(ncread(GRUNFilePath,'time'));               %Read the time range and accuracy
NCRunoff=double(ncread(GRUNFilePath,'Runoff'));           %Read the Runoff range and accuracy
NCRunoff(NCRunoff(:)==-9999)=NaN;%_FillValue = -9999

%Set other parameters
StartYear=1985;
EndYear=2014;
GrunStartYear=1902;
%GrunEndYear=2020;
%GrunYearBound=[1980,2020];
rownum=180/0.5;
colrum=360/0.5;
GRUNRunOff=zeros(rownum,colrum);
LPJRunOff=zeros(rownum,colrum);
LPJPReci=zeros(rownum,colrum);

%grant the area without data NaN value and 0 for area with data
%for map plot later
GRUNRunOff(:)=NaN;
LPJRunOff(:)=NaN;
LPJPReci(:)=NaN;
for k=1:1:LineNum
    lpjlon=LPJFileData(k,1);
    lpjlat=LPJFileData(k,2);% lat/lon
    lonnum=floor((lpjlon-(-180))/0.5)+1;    
    latnum=floor((lpjlat-(-90))/0.5)+1;   
    GRUNRunOff(latnum,lonnum)=0;
    LPJRunOff(latnum,lonnum)=0;
    LPJPReci(latnum,lonnum)=0;
end

%for monthly mean ratio line
monthlyMeanRatio=zeros(12,11);

%% Average
for month=1:1:12
    GRUNRunOffMonth=zeros(rownum,colrum);
    LPJRunOffMonth=zeros(rownum,colrum);
    
    
    GRUNMonthlyMeanRunoff=0;
    for year=StartYear:1:EndYear
        GRUNMonthlyMeanRunoff=GRUNMonthlyMeanRunoff+NCRunoff(:,:,(year-GrunStartYear)*12+month)*eomday(year,month);%NCRunoff(lon,lat,time,runoff)
    end
    GRUNMonthlyMeanRunoff=GRUNMonthlyMeanRunoff./(EndYear-StartYear+1);
    
    
    
    for k=1:1:LineNum
        lpjlon=LPJFileData(k,1);
        lpjlat=LPJFileData(k,2);
        lonnum=floor((lpjlon-(-180))/0.5)+1;
        latnum=floor((lpjlat-(-90))/0.5)+1;
        
        GRUNAverageRunoff=GRUNMonthlyMeanRunoff(lonnum,latnum);
        if(isnan(GRUNAverageRunoff))
            GRUNRunOff(latnum,lonnum)=NaN;
            LPJRunOff(latnum,lonnum)=NaN;
            LPJPReci(latnum,lonnum)=NaN;
            GRUNRunOffMonth(latnum,lonnum)= NaN;
            LPJRunOffMonth(latnum,lonnum)=NaN;
        else
            GRUNRunOff(latnum,lonnum)=GRUNRunOff(latnum,lonnum)+GRUNAverageRunoff;
            LPJRunOff(latnum,lonnum)=LPJRunOff(latnum,lonnum)+LPJFileData(k,month+2);
            GRUNRunOffMonth(latnum,lonnum)= GRUNRunOffMonth(latnum,lonnum)+GRUNAverageRunoff;
            LPJRunOffMonth(latnum,lonnum)=LPJRunOffMonth(latnum,lonnum)+LPJFileData(k,month+2);
            LPJPReci(latnum,lonnum)=LPJPReci(latnum,lonnum)+LPJPreciFileData(k,month+2);
        end
        
    end
    
    [eco1_GRUNm,eco2_GRUNm,eco3_GRUNm,eco4_GRUNm,eco5_GRUNm,eco6_GRUNm,eco7_GRUNm,eco8_GRUNm,eco9_GRUNm,eco10_GRUNm,eco11_GRUNm]=EcoregionMask(GRUNRunOffMonth,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);
    [eco1_LPJm,eco2_LPJm,eco3_LPJm,eco4_LPJm,eco5_LPJm,eco6_LPJm,eco7_LPJm,eco8_LPJm,eco9_LPJm,eco10_LPJm,eco11_LPJm]=EcoregionMask(LPJRunOffMonth,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);
    monthlyMeanRatio(month,1)=nansum(eco1_LPJm)/nansum(eco1_GRUNm);
    monthlyMeanRatio(month,2)=nansum(eco2_LPJm)/nansum(eco2_GRUNm);
    monthlyMeanRatio(month,3)=nansum(eco3_LPJm)/nansum(eco3_GRUNm);
    monthlyMeanRatio(month,4)=nansum(eco4_LPJm)/nansum(eco4_GRUNm);
    monthlyMeanRatio(month,5)=nansum(eco5_LPJm)/nansum(eco5_GRUNm);
    monthlyMeanRatio(month,6)=nansum(eco6_LPJm)/nansum(eco6_GRUNm);
    monthlyMeanRatio(month,7)=nansum(eco7_LPJm)/nansum(eco7_GRUNm);
    monthlyMeanRatio(month,8)=nansum(eco8_LPJm)/nansum(eco8_GRUNm);
    monthlyMeanRatio(month,9)=nansum(eco9_LPJm)/nansum(eco9_GRUNm);
    monthlyMeanRatio(month,10)=nansum(eco10_LPJm)/nansum(eco10_GRUNm);
    monthlyMeanRatio(month,11)=nansum(eco11_LPJm)/nansum(eco11_GRUNm);
 
    
    
end

%yearly mean ratio
%NaN in the data could cause the box line 
rate=LPJRunOff./GRUNRunOff;
rate(rate(:)==0)=NaN;
rate(rate(:)==Inf)=NaN;
logRatio=rate;
%for draw yearly mean ratio
[eco1,eco2,eco3,eco4,eco5,eco6,eco7,eco8,eco9,eco10,eco11]=EcoregionMask(logRatio,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);
%for yearly scatter plot
[eco1_LPJy,eco2_LPJy,eco3_LPJy,eco4_LPJy,eco5_LPJy,eco6_LPJy,eco7_LPJy,eco8_LPJy,eco9_LPJy,eco10_LPJy,eco11_LPJy]=EcoregionMask(LPJRunOff,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);
[eco1_GRUNy,eco2_GRUNy,eco3_GRUNy,eco4_GRUNy,eco5_GRUNy,eco6_GRUNy,eco7_GRUNy,eco8_GRUNy,eco9_GRUNy,eco10_GRUNy,eco11_GRUNy]=EcoregionMask(GRUNRunOff,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);
[eco1_LPJPreciy,eco2_LPJPreciy,eco3_LPJPreciy,eco4_LPJPreciy,eco5_LPJPreciy,eco6_LPJPreciy,eco7_LPJPreciy,eco8_LPJPreciy,eco9_LPJPreciy,eco10_LPJPreciy,eco11_LPJPreciy]=EcoregionMask(LPJPReci,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);



% %% draw yearly mean ratio raincloud and monthly mean ratio line 

f=figure('color',[1 1 1]);%figure,background
f.Units = 'inches';%unit
f.Position = [1 1 14 12];%[x y width height] for figure position 
set(gcf,'PaperUnits','inches','PaperPosition',[1 1 14 12]);%for printing

%yearly mean ratio raincloud
subplot(2,1,1);     % layout
%dataCell={eco1_year',eco2_year',eco3_year',eco4_year',eco5_year',eco6_year',eco7_year',eco8_year',eco9_year',eco10_year',eco11_year'};  
dataCell={eco1',eco2',eco3',eco4',eco5',eco6',eco7',eco8',eco9',eco10',eco11'};  
dataName={'TSMBF', 'TSCF', 'TSGSS', 'TSDBF', 'TGSS', 'TCF', 'TBMF', 'MGS', 'MFWS', 'BFT', 'TU'};  

RainCloudsTMPL2(dataCell,dataName,[-0.3,4],'Annual ratio','Annual mean runoff ratios, LPJ-GUESS:GRUN')

hold on

%monthly mean ratio line
%boxplot only shows the median,scatter will show the mean
subplot(2,1,2);
DrawLine(monthlyMeanRatio,[0,2.5],'Monthly ratio')

print(gcf,strcat('G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\1FigureRunoff\GRUNLPJRainCloud', '.png'),'-r300','-dpng');
%% draw heat map
f=figure('color',[1 1 1]);%figure,background
f.Units = 'inches';%unit
f.Position = [1 1 14 6];%[x y width height] for figure position 
set(gcf,'PaperUnits','inches','PaperPosition',[1 1 14 6]);%for printing

cdata = monthlyMeanRatio';
xvalues = {'1','2','3','4','5','6','7','8','9','10','11','12'};
yvalues = {'TSMBF', 'TSCF', 'TSGSS', 'TSDBF', 'TGSS', 'TCF', 'TBMF', 'MGS', 'MFWS', 'BFT', 'TU'};
RGB=cbrewer('div', 'RdBu',20,'linear');
h = heatmap(xvalues,yvalues,cdata);
colormap(gca,RGB);
h.CellLabelFormat = '%0.2f';
h.CellLabelColor = 'none';
caxis([0 2])% color range
%c=colorbar; % not support on heatmap
%set(c,'tickdir','out')  % out
%set(c,'YTick',0:0.2:2); %colorbar range


%colormap(gca, 'parula')
h.Title = 'Monthly mean runoff ratios, LPJ-GUESS:GRUN';
h.XLabel = 'Month';
h.YLabel = 'Ecoregion';
print(gcf,strcat('G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\1FigureRunoff\GRUNLPJheatmap', '.png'),'-r300','-dpng');

%% Draw yearly scatter plot
f=figure('color',[1 1 1]);%figure,background
set(gcf,'unit','centimeters','position',[5 0 17.4*2 15*2]); 
[ha, pos] = tight_subplot(3,4,[.03 .03],[.05 .01],[.1 .02]);
  
dataName={'TSMBF', 'TSCF', 'TSGSS', 'TSDBF', 'TGSS', 'TCF', 'TBMF', 'MGS', 'MFWS', 'BFT', 'TU'};  
%yearly mean scatter

LPJeco={eco1_LPJy,eco2_LPJy,eco3_LPJy,eco4_LPJy,eco5_LPJy,eco6_LPJy,eco7_LPJy,eco8_LPJy,eco9_LPJy,eco10_LPJy,eco11_LPJy};
GRUNeco={eco1_GRUNy,eco2_GRUNy,eco3_GRUNy,eco4_GRUNy,eco5_GRUNy,eco6_GRUNy,eco7_GRUNy,eco8_GRUNy,eco9_GRUNy,eco10_GRUNy,eco11_GRUNy};
LPJPrecieco={eco1_LPJPreciy,eco2_LPJPreciy,eco3_LPJPreciy,eco4_LPJPreciy,eco5_LPJPreciy,eco6_LPJPreciy,eco7_LPJPreciy,eco8_LPJPreciy,eco9_LPJPreciy,eco10_LPJPreciy,eco11_LPJPreciy};
obslabel='GRUN-based runoff (mm*yr^-^1)';
predlabel='LPJ-GUESS runoff (mm*yr^-^1)';
for i=1:1:11
    %subplot(3,4,i);     % layout
    axes(ha(i));
    box on;
    %if log needed
    pred_data=zeros(length(LPJeco(i)),1);
    obs_data=zeros(length(GRUNeco(i)),1)
    preci_data=zeros(length(LPJPrecieco(i)),1);
    pred_data=cell2mat(LPJeco(i));
    obs_data=cell2mat(GRUNeco(i));
    preci_data=cell2mat(LPJPrecieco(i));
    %DrawScatterPlot(pred_data,obs_data,dataName(i),3000)
    DrawScatterPlot(obs_data,pred_data,preci_data,dataName(i),3000,obslabel,predlabel,i)
end

axes(ha(12));
DrawColorbar(cell2mat(GRUNeco(11)),cell2mat(LPJeco(11)),cell2mat(LPJPrecieco(11)))
print(gcf,strcat('G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\1FigureRunoff\GRUNLPJScatter', '.png'),'-r300','-dpng');

