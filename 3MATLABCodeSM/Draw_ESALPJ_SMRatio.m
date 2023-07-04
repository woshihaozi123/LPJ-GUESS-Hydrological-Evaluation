% Draw the annual mean runoff ratio raincloud graph and monthly mean runoff ratio of the LPJGUESS to GRUN
%2022/11/26  Hao Zhou
clc;
clear;
tic
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

%% read data
%ESA monthly mean
tic;
fileName='G:\LPJGUESSHydrologyBalanceCheck\3SoilMoisture\ESA\monthlymean\851401.nc';
ncdisp(fileName)
lon=double(ncread(fileName,'lon'));                   %读取经度范围和精度
lat=double(ncread(fileName,'lat'));                   %读取纬度范围和精度
time=double((ncread(fileName,'time')));         %读取时间序列长度
dirstring="G:\LPJGUESSHydrologyBalanceCheck\3SoilMoisture\ESA\monthlymean\";
filedir=dir(char(dirstring));

LPJPreciFilePath='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mpreci8514ave.out';
LPJPreciFileData=ReadTxtData(LPJPreciFilePath);

%read lpjguess Soil moisture data
LPJSMfilename='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mssm8514ave.out';
LPJdata_SM=ReadTxtData(LPJSMfilename);
LineNum=size(LPJdata_SM,1)%show line number of file
LPJdata_SM(:,3:14)=LPJdata_SM(:,3:14)./100;

rownum=180/0.5;
colnum=360/0.5;
ESASM=zeros(rownum,colnum);
LPJSM=zeros(rownum,colnum);
LPJPReci=zeros(rownum,colnum);
%grant the area without data NaN value and 0 for area with data
ESASM(:)=NaN;
LPJSM(:)=NaN;
LPJPReci(:)=NaN;
for k=1:1:LineNum
    lpjlon=LPJdata_SM(k,1);
    lpjlat=LPJdata_SM(k,2);% lat/lon
    lonnum=floor((lpjlon-(-180))/0.5)+1;
    latnum=floor((lpjlat-(-90))/0.5)+1;
    ESASM(latnum,lonnum)=0;
    LPJSM(latnum,lonnum)=0;
    LPJPReci(latnum,lonnum)=0;
    
end


%for monthly mean ratio line
monthlyMeanRatio=zeros(12,11);

%% Average
for month=1:1:12
    %% read nc name list
    len=length(filedir);
    file_name=string(zeros(len,1));
    
    monthlysm=zeros(size(lon,1),size(lat,1));
    monthnum=0;
    for i=3:1:len
        file_name=filedir(i).name;
        if(str2num(char(file_name(5:6)))==month)
            monthdir=strcat(dirstring,file_name);
            monthlysm=double((ncread(monthdir,'sm')));
            
        end
    end
    nanmean(monthlysm(:))
    ESASMMonth=zeros(rownum,colnum);
    LPJSMMonth=zeros(rownum,colnum);
    for k=1:1:LineNum
        lpjlon=LPJdata_SM(k,1);
        lpjlat=LPJdata_SM(k,2);
%         ESAlonnum=floor(((lpjlon-0.125)-(-180))/0.25)+1;
%         ESAlatnum=floor((90-(lpjlat+0.125))/0.25)+1;
       lonnum=floor((lpjlon-(-180))/0.25)+1;
       latnum=floor((90-lpjlat)/0.25)+1;
        if(mod(latnum,2)==0)
            latnum1=latnum-1;
        else
            latnum1=latnum+1;
        end
        if(mod(lonnum,2)==0)
            lonnum1=lonnum-1;
        else
            lonnum1=lonnum+1;
        end
        
        num=4;
        if(isnan(monthlysm(lonnum,latnum)))
            num=num-1;
            monthlysm(lonnum,latnum)=0;
        end
        if(isnan(monthlysm(lonnum1,latnum1)))
            num=num-1;
            monthlysm(lonnum1,latnum1)=0;
        end
        if(isnan(monthlysm(lonnum1,latnum)))
            num=num-1;
            monthlysm(lonnum1,latnum)=0;
        end
        if(isnan(monthlysm(lonnum,latnum1)))
            num=num-1;
            monthlysm(lonnum,latnum1)=0;
        end        
        if(num~=0)
            ESAAverageSM=(monthlysm(lonnum,latnum)+monthlysm(lonnum1,latnum1)+monthlysm(lonnum1,latnum)+monthlysm(lonnum,latnum1))/num;
        end
        lonnum=floor((lpjlon-(-180))/0.5)+1;
        latnum=floor((lpjlat-(-90))/0.5)+1;
        if(ESAAverageSM~=0)
            
            ESASM(latnum,lonnum)=ESASM(latnum,lonnum)+ESAAverageSM;
            LPJSM(latnum,lonnum)=LPJSM(latnum,lonnum)+LPJdata_SM(k,month+2);
            ESASMMonth(latnum,lonnum)= ESASMMonth(latnum,lonnum)+ESAAverageSM;
            LPJSMMonth(latnum,lonnum)=LPJSMMonth(latnum,lonnum)+LPJdata_SM(k,month+2);
            LPJPReci(latnum,lonnum)=LPJPReci(latnum,lonnum)+LPJPreciFileData(k,month+2);
        end
%         ESAAverageSM=nanmean([monthlysm(ESAlonnum,ESAlatnum),monthlysm(ESAlonnum+1,ESAlatnum),monthlysm(ESAlonnum,ESAlatnum+1),monthlysm(ESAlonnum+1,ESAlatnum+1)]);
%         
%         lonnum=floor((lpjlon-(-180))/0.5)+1;
%         latnum=floor((lpjlat-(-90))/0.5)+1;
%         if(isnan(ESAAverageSM))
%             ESASM(latnum,lonnum)=NaN;
%             LPJSM(latnum,lonnum)=NaN;
%             ESASMMonth(latnum,lonnum)= NaN;
%             LPJSMMonth(latnum,lonnum)=NaN;
%         else
%             ESASM(latnum,lonnum)=ESASM(latnum,lonnum)+ESAAverageSM;
%             LPJSM(latnum,lonnum)=LPJSM(latnum,lonnum)+LPJdata_SM(k,month+2);
%             ESASMMonth(latnum,lonnum)= ESASMMonth(latnum,lonnum)+ESAAverageSM;
%             LPJSMMonth(latnum,lonnum)=LPJSMMonth(latnum,lonnum)+LPJdata_SM(k,month+2);
%             
%         end
    end
    [eco1_ESAm,eco2_ESAm,eco3_ESAm,eco4_ESAm,eco5_ESAm,eco6_ESAm,eco7_ESAm,eco8_ESAm,eco9_ESAm,eco10_ESAm,eco11_ESAm]=EcoregionMask(ESASMMonth,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);
    [eco1_LPJm,eco2_LPJm,eco3_LPJm,eco4_LPJm,eco5_LPJm,eco6_LPJm,eco7_LPJm,eco8_LPJm,eco9_LPJm,eco10_LPJm,eco11_LPJm]=EcoregionMask(LPJSMMonth,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);
    monthlyMeanRatio(month,1)=nansum(eco1_LPJm)/nansum(eco1_ESAm);
    monthlyMeanRatio(month,2)=nansum(eco2_LPJm)/nansum(eco2_ESAm);
    monthlyMeanRatio(month,3)=nansum(eco3_LPJm)/nansum(eco3_ESAm);
    monthlyMeanRatio(month,4)=nansum(eco4_LPJm)/nansum(eco4_ESAm);
    monthlyMeanRatio(month,5)=nansum(eco5_LPJm)/nansum(eco5_ESAm);
    monthlyMeanRatio(month,6)=nansum(eco6_LPJm)/nansum(eco6_ESAm);
    monthlyMeanRatio(month,7)=nansum(eco7_LPJm)/nansum(eco7_ESAm);
    monthlyMeanRatio(month,8)=nansum(eco8_LPJm)/nansum(eco8_ESAm);
    monthlyMeanRatio(month,9)=nansum(eco9_LPJm)/nansum(eco9_ESAm);
    monthlyMeanRatio(month,10)=nansum(eco10_LPJm)/nansum(eco10_ESAm);
    monthlyMeanRatio(month,11)=nansum(eco11_LPJm)/nansum(eco11_ESAm);
    
end
%yearly mean ratio
%NaN in the data could cause the box line 
LPJSM=LPJSM./12.0;
ESASM=ESASM./12.0;
rate=LPJSM./ESASM;
rate(rate(:)==0)=NaN;
rate(rate(:)==Inf)=NaN;
logRatio=rate;
%for draw yearly mean ratio
[eco1,eco2,eco3,eco4,eco5,eco6,eco7,eco8,eco9,eco10,eco11]=EcoregionMask(logRatio,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);
%for yearly scatter plot
[eco1_LPJy,eco2_LPJy,eco3_LPJy,eco4_LPJy,eco5_LPJy,eco6_LPJy,eco7_LPJy,eco8_LPJy,eco9_LPJy,eco10_LPJy,eco11_LPJy]=EcoregionMask(LPJSM,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);
[eco1_ESAy,eco2_ESAy,eco3_ESAy,eco4_ESAy,eco5_ESAy,eco6_ESAy,eco7_ESAy,eco8_ESAy,eco9_ESAy,eco10_ESAy,eco11_ESAy]=EcoregionMask(ESASM,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);
[eco1_LPJPreciy,eco2_LPJPreciy,eco3_LPJPreciy,eco4_LPJPreciy,eco5_LPJPreciy,eco6_LPJPreciy,eco7_LPJPreciy,eco8_LPJPreciy,eco9_LPJPreciy,eco10_LPJPreciy,eco11_LPJPreciy]=EcoregionMask(LPJPReci,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);



%% draw yearly mean ratio raincloud and monthly mean ratio line 

f=figure('color',[1 1 1]);%figure,background
f.Units = 'inches';%unit
f.Position = [1 1 14 12];%[x y width height] for figure position 
set(gcf,'PaperUnits','inches','PaperPosition',[1 1 14 12]);%for printing

%yearly mean ratio raincloud
subplot(2,1,1);     % layout
%dataCell={eco1_year',eco2_year',eco3_year',eco4_year',eco5_year',eco6_year',eco7_year',eco8_year',eco9_year',eco10_year',eco11_year'};  
dataCell={eco1',eco2',eco3',eco4',eco5',eco6',eco7',eco8',eco9',eco10',eco11'};  
dataName={'TSMBF', 'TSCF', 'TSGSS', 'TSDBF', 'TGSS', 'TCF', 'TBMF', 'MGS', 'MFWS', 'BFT', 'TU'};  

RainCloudsTMPL2(dataCell,dataName,[-0.3,3],'Annual ratio','Annual mean SSM ratios, LPJ-GUESS:ESA')

hold on

%monthly mean ratio line
%boxplot only shows the median,scatter will show the mean
subplot(2,1,2);
DrawLine(monthlyMeanRatio,[0,3],'Monthly ratio')

print(gcf,strcat('G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\3FigureSM\ecoregion\ESALPJRainCloud8514', '.png'),'-r300','-dpng');
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
h.Title = 'Monthly mean SSM ratios, LPJ-GUESS:ESA';
h.XLabel = 'Month';
h.YLabel = 'Ecoregion';
print(gcf,strcat('G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\3FigureSM\ecoregion\ESALPJheatmap8514', '.png'),'-r300','-dpng');

%% Draw yearly scatter plot
f=figure('color',[1 1 1]);%figure,background
set(gcf,'unit','centimeters','position',[5 0 17.4*2+2 15*2]); 
[ha, pos] = tight_subplot(3,4,[.03 .03],[.05 .01],[.1 .02]);
  
dataName={'TSMBF', 'TSCF', 'TSGSS', 'TSDBF', 'TGSS', 'TCF', 'TBMF', 'MGS', 'MFWS', 'BFT', 'TU'};  
%yearly mean scatter

LPJeco={eco1_LPJy,eco2_LPJy,eco3_LPJy,eco4_LPJy,eco5_LPJy,eco6_LPJy,eco7_LPJy,eco8_LPJy,eco9_LPJy,eco10_LPJy,eco11_LPJy};
ESAeco={eco1_ESAy,eco2_ESAy,eco3_ESAy,eco4_ESAy,eco5_ESAy,eco6_ESAy,eco7_ESAy,eco8_ESAy,eco9_ESAy,eco10_ESAy,eco11_ESAy};
LPJPrecieco={eco1_LPJPreciy,eco2_LPJPreciy,eco3_LPJPreciy,eco4_LPJPreciy,eco5_LPJPreciy,eco6_LPJPreciy,eco7_LPJPreciy,eco8_LPJPreciy,eco9_LPJPreciy,eco10_LPJPreciy,eco11_LPJPreciy};

obslabel='ESA-based SSM (mm*yr^-^1)';
predlabel='LPJ-GUESS SSM (mm*yr^-^1)';
for i=1:1:11
    axes(ha(i));
    box on;
    pred_data=zeros(length(LPJeco(i)),1);
    obs_data=zeros(length(ESAeco(i)),1);
    preci_data=zeros(length(LPJPrecieco(i)),1);
    pred_data=cell2mat(LPJeco(i));
    obs_data=cell2mat(ESAeco(i));
    preci_data=cell2mat(LPJPrecieco(i));
    DrawScatterPlot(obs_data,pred_data,preci_data,dataName(i),0.6,obslabel,predlabel,i)
    
end

axes(ha(12));
DrawColorbar(cell2mat(ESAeco(11)),cell2mat(LPJeco(11)),cell2mat(LPJPrecieco(11)))
print(gcf,strcat('G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\3FigureSM\ecoregion\ESALPJScatter8514', '.png'),'-r300','-dpng');

