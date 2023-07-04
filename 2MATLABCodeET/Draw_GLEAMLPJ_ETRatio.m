% Draw the yearly raincloud figure and monthly mean the GLEAM and
% LPJGUESS ET ratio
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


%% read data
%read LPJGUESS
LPJfile_evap='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mevap8514ave.out';
LPJfile_aet='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\maet8514ave.out';
LPJfile_intercep='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mintercep8514ave.out';
LPJdata_evap=ReadTxtData(LPJfile_evap);
LPJdata_aet=ReadTxtData(LPJfile_aet);
LPJdata_intercep=ReadTxtData(LPJfile_intercep);

LPJPreciFilePath='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mpreci8514ave.out';
LPJPreciFileData=ReadTxtData(LPJPreciFilePath);

LPJdata_ET=LPJdata_evap+LPJdata_aet+LPJdata_intercep;
LPJdata_ET(:,1:2)=LPJdata_ET(:,1:2)/3;
LineNum=size(LPJdata_ET,1)%show line number of file

%read GLEAM monthly mean
%Size:  720x1440x492
%Dimensions: lat,lon,time
% units = 'mm/year'
% _FillValue = -999
% missing_value = -999
filename_GleamEi='D:\Program Files\PuTTY\GLEAM data\v3.5a\monthly after 3.9\Ei_1980-2020_GLEAM_v3.5a_MO.nc';
filename_GleamEb='D:\Program Files\PuTTY\GLEAM data\v3.5a\monthly after 3.9\Eb_1980-2020_GLEAM_v3.5a_MO.nc';
filename_GleamEt='D:\Program Files\PuTTY\GLEAM data\v3.5a\monthly after 3.9\Et_1980-2020_GLEAM_v3.5a_MO.nc';
%ncdisp(filename_GleamEi);
%lon_GleamEi=double(ncread(filename_GleamEi,'lon'));
%lat_GleamEi=double(ncread(filename_GleamEi,'lat'));
%time_GleamEi=double(length(ncread(filename_GleamEi,'time')));
data_GleamEi=double(ncread(filename_GleamEi,'Ei'));
data_GleamEb=double(ncread(filename_GleamEb,'Eb'));
data_GleamEt=double(ncread(filename_GleamEt,'Et'));
data_GleamEi(data_GleamEi(:)==-999)=NaN;%_FillValue = -999
data_GleamEb(data_GleamEb(:)==-999)=NaN;%_FillValue = -999
data_GleamEt(data_GleamEt(:)==-999)=NaN;%_FillValue = -999
data_GleamET=data_GleamEi+data_GleamEb+data_GleamEt;

%Set other parameters
startyear=1985;
endyear=2014;
%startyear=2003;
%endyear=2018;
gleamstartyear=1980;
rownum=180/0.5;
colnum=360/0.5;
GLEAMET=zeros(rownum,colnum);
LPJET=zeros(rownum,colnum);
LPJPReci=zeros(rownum,colnum);

%grant the area without data NaN value and 0 for area with data
GLEAMET(:)=NaN;
LPJET(:)=NaN;
LPJPReci(:)=NaN;
for k=1:1:LineNum
    lpjlon=LPJdata_ET(k,1);
    lpjlat=LPJdata_ET(k,2);% lat/lon
    lonnum=floor((lpjlon-(-180))/0.5)+1;
    latnum=floor((lpjlat-(-90))/0.5)+1;
    GLEAMET(latnum,lonnum)=0;
    LPJET(latnum,lonnum)=0;
    LPJPReci(latnum,lonnum)=0;
end


%for monthly mean ratio line
monthlyMeanRatio=zeros(12,11);

%% Average
for month=1:1:12
    
    GLEAMETMonth=zeros(rownum,colnum);
    LPJETMonth=zeros(rownum,colnum);
    GLEAMMonthlyMeanET=nanmean(data_GleamET(:,:,(startyear-gleamstartyear)*12+month:12:(endyear-gleamstartyear)*12+month),3);
    
    for k=1:1:LineNum
        lpjlon=LPJdata_ET(k,1);
        lpjlat=LPJdata_ET(k,2);
        
        GLEAMlatnum=floor((90-(lpjlat+0.125))/0.25)+1;
        GLEAMlonnum=floor(((lpjlon-0.125)-(-180))/0.25)+1;    
        %aggreate at 0.5 degree
        GLEAMAverageRunoff=nanmean([GLEAMMonthlyMeanET(GLEAMlatnum,GLEAMlonnum),GLEAMMonthlyMeanET(GLEAMlatnum,GLEAMlonnum+1),GLEAMMonthlyMeanET(GLEAMlatnum+1,GLEAMlonnum),GLEAMMonthlyMeanET(GLEAMlatnum+1,GLEAMlonnum+1)]);
        
        
        lonnum=floor((lpjlon-(-180))/0.5)+1;
        latnum=floor((lpjlat-(-90))/0.5)+1;
        if(isnan(GLEAMAverageRunoff))
            GLEAMET(latnum,lonnum)=NaN;
            LPJET(latnum,lonnum)=NaN;
            LPJPReci(latnum,lonnum)=NaN;
            GLEAMETMonth(latnum,lonnum)= NaN;
            LPJETMonth(latnum,lonnum)=NaN;
        else
            GLEAMET(latnum,lonnum)=GLEAMET(latnum,lonnum)+GLEAMAverageRunoff;
            LPJET(latnum,lonnum)=LPJET(latnum,lonnum)+LPJdata_ET(k,month+2);
            GLEAMETMonth(latnum,lonnum)= GLEAMETMonth(latnum,lonnum)+GLEAMAverageRunoff;
            LPJETMonth(latnum,lonnum)=LPJETMonth(latnum,lonnum)+LPJdata_ET(k,month+2);
            LPJPReci(latnum,lonnum)=LPJPReci(latnum,lonnum)+LPJPreciFileData(k,month+2);
        end
    end  
    [eco1_GLEAMm,eco2_GLEAMm,eco3_GLEAMm,eco4_GLEAMm,eco5_GLEAMm,eco6_GLEAMm,eco7_GLEAMm,eco8_GLEAMm,eco9_GLEAMm,eco10_GLEAMm,eco11_GLEAMm]=EcoregionMask(GLEAMETMonth,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);
    [eco1_LPJm,eco2_LPJm,eco3_LPJm,eco4_LPJm,eco5_LPJm,eco6_LPJm,eco7_LPJm,eco8_LPJm,eco9_LPJm,eco10_LPJm,eco11_LPJm]=EcoregionMask(LPJETMonth,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);
    monthlyMeanRatio(month,1)=nansum(eco1_LPJm)/nansum(eco1_GLEAMm);
    monthlyMeanRatio(month,2)=nansum(eco2_LPJm)/nansum(eco2_GLEAMm);
    monthlyMeanRatio(month,3)=nansum(eco3_LPJm)/nansum(eco3_GLEAMm);
    monthlyMeanRatio(month,4)=nansum(eco4_LPJm)/nansum(eco4_GLEAMm);
    monthlyMeanRatio(month,5)=nansum(eco5_LPJm)/nansum(eco5_GLEAMm);
    monthlyMeanRatio(month,6)=nansum(eco6_LPJm)/nansum(eco6_GLEAMm);
    monthlyMeanRatio(month,7)=nansum(eco7_LPJm)/nansum(eco7_GLEAMm);
    monthlyMeanRatio(month,8)=nansum(eco8_LPJm)/nansum(eco8_GLEAMm);
    monthlyMeanRatio(month,9)=nansum(eco9_LPJm)/nansum(eco9_GLEAMm);
    monthlyMeanRatio(month,10)=nansum(eco10_LPJm)/nansum(eco10_GLEAMm);
    monthlyMeanRatio(month,11)=nansum(eco11_LPJm)/nansum(eco11_GLEAMm);
end
    
%yearly mean ratio
%NaN in the data could cause the box line 
rate=LPJET./GLEAMET;
rate(rate(:)==0)=NaN;
rate(rate(:)==Inf)=NaN;
logRatio=rate;
%for draw yearly mean ratio
[eco1,eco2,eco3,eco4,eco5,eco6,eco7,eco8,eco9,eco10,eco11]=EcoregionMask(logRatio,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);
%for yearly scatter plot
[eco1_LPJy,eco2_LPJy,eco3_LPJy,eco4_LPJy,eco5_LPJy,eco6_LPJy,eco7_LPJy,eco8_LPJy,eco9_LPJy,eco10_LPJy,eco11_LPJy]=EcoregionMask(LPJET,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);
[eco1_GLEAMy,eco2_GLEAMy,eco3_GLEAMy,eco4_GLEAMy,eco5_GLEAMy,eco6_GLEAMy,eco7_GLEAMy,eco8_GLEAMy,eco9_GLEAMy,eco10_GLEAMy,eco11_GLEAMy]=EcoregionMask(GLEAMET,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);
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

RainCloudsTMPL2(dataCell,dataName,[-0.3,3],'Annual ratio','Annual mean ET ratios, LPJ-GUESS:GLEAM')

hold on

%monthly mean ratio line
%boxplot only shows the median,scatter will show the mean
subplot(2,1,2);
DrawLine(monthlyMeanRatio,[0,3],'Monthly ratio')

print(gcf,strcat('G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\2FigureET\ecoregion\GLEAMLPJRainCloud8514', '.png'),'-r300','-dpng');
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
h.Title = 'Monthly mean ET ratios, LPJ-GUESS:GLEAM';
h.XLabel = 'Month';
h.YLabel = 'Ecoregion';
print(gcf,strcat('G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\2FigureET\ecoregion\GLEAMLPJheatmap8514', '.png'),'-r300','-dpng');

%% Draw yearly scatter plot
f=figure('color',[1 1 1]);%figure,background
set(gcf,'unit','centimeters','position',[5 0 17.4*2 15*2]); 
[ha, pos] = tight_subplot(3,4,[.03 .03],[.05 .01],[.1 .02]);
  
dataName={'TSMBF', 'TSCF', 'TSGSS', 'TSDBF', 'TGSS', 'TCF', 'TBMF', 'MGS', 'MFWS', 'BFT', 'TU'};  
%yearly mean scatter

LPJeco={eco1_LPJy,eco2_LPJy,eco3_LPJy,eco4_LPJy,eco5_LPJy,eco6_LPJy,eco7_LPJy,eco8_LPJy,eco9_LPJy,eco10_LPJy,eco11_LPJy};
GLEAMeco={eco1_GLEAMy,eco2_GLEAMy,eco3_GLEAMy,eco4_GLEAMy,eco5_GLEAMy,eco6_GLEAMy,eco7_GLEAMy,eco8_GLEAMy,eco9_GLEAMy,eco10_GLEAMy,eco11_GLEAMy};
LPJPrecieco={eco1_LPJPreciy,eco2_LPJPreciy,eco3_LPJPreciy,eco4_LPJPreciy,eco5_LPJPreciy,eco6_LPJPreciy,eco7_LPJPreciy,eco8_LPJPreciy,eco9_LPJPreciy,eco10_LPJPreciy,eco11_LPJPreciy};

obslabel='GLEAM-based ET (mm*yr^-^1)';
predlabel='LPJ-GUESS ET (mm*yr^-^1)';
for i=1:1:11
    axes(ha(i));
    box on;
    pred_data=zeros(length(LPJeco(i)),1);
    obs_data=zeros(length(GLEAMeco(i)),1);
    preci_data=zeros(length(LPJPrecieco(i)),1);
    pred_data=cell2mat(LPJeco(i));
    obs_data=cell2mat(GLEAMeco(i));
    preci_data=cell2mat(LPJPrecieco(i));
    DrawScatterPlot(obs_data,pred_data,preci_data,dataName(i),3000,obslabel,predlabel,i)
    
end

axes(ha(12));
DrawColorbar(cell2mat(GLEAMeco(11)),cell2mat(LPJeco(11)),cell2mat(LPJPrecieco(11)))
print(gcf,strcat('G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\2FigureET\ecoregion\GLEAMLPJScatter8514', '.png'),'-r300','-dpng');

