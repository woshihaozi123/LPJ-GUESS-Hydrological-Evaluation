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

%For comparing LandFluxEVAL 1989-2005 1989-1995
LPJfile_longevap='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mevap8905ave.out';
LPJdata_longevap=ReadTxtData(LPJfile_longevap);
lpjlon_list=LPJdata_longevap(:,1);
lpjlat_list=LPJdata_longevap(:,2);
LineNum=size(LPJdata_longevap,1);
%% read data
%read LPJGUESS
% For comparing PML_V2 2003-2018
%2003-2018 water balance file 
%Lon	Lat	aaet	aevap	aintercep	apreci	total_water_in_colum	soilwaterchange	snowpackchange
LPJFileName = 'G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\waterbalance0318.xlsx';
[Data,Txt] = xlsread(LPJFileName);
data_LPJaet= Data(:,3);
data_LPJevap= Data(:,4);
data_LPJintercep= Data(:,5);
data_LPJET= data_LPJaet+data_LPJevap+data_LPJintercep;
LPJET0318=LPJProcessYearlyForMap(data_LPJET,lpjlon_list,lpjlat_list);

%% PML_V2
fileName2='D:\Program Files\PuTTY\PML_V2 code\yearmean\2003-2018_0.5.tif';
tifimage=imread(char(fileName2));
data_MPL2 =tifimage(:,:,2)+tifimage(:,:,3)+tifimage(:,:,4); 
% GPP	gC m-2 d-1	0.01	Gross primary product
% Ec	mm d-1	0.01	Vegetation Transpiration
% Es	mm d-1	0.01	Soil Evaporation
% Ei	mm d-1	0.01	Interception from vegetation canopy
% ET_water	mm d-1	0.01	Water body, snow and ice evaporation. Penman
% evapotranspiration is regarded as actual evaporation for them.
PMLV2ET_data=PMLV2ProcessForMap(data_MPL2,lpjlon_list,lpjlat_list);

%Set other parameters
gleamstartyear=1980;
rownum=180/0.5;
colnum=360/0.5;
MPLV2ET=zeros(rownum,colnum);
LPJET=zeros(rownum,colnum);

%grant the area without data NaN value and 0 for area with data
MPLV2ET(:)=NaN;
LPJET(:)=NaN;
for k=1:1:LineNum
    lpjlon=lpjlon_list(k);
    lpjlat=lpjlat_list(k);% lat/lon
    latnum=floor((90-(lpjlat+0.25))/0.5)+1;
    lonnum=floor(((lpjlon-0.25)-(-180))/0.5)+1;
    MPLV2ET(latnum,lonnum)=0;
    LPJET(latnum,lonnum)=0;
end


%for monthly mean ratio line
monthlyMeanRatio=zeros(12,11);

%% Average
for k=1:1:LineNum
    lpjlon=lpjlon_list(k);
    lpjlat=lpjlat_list(k);% lat/lon
    
    latnum=floor((90-(lpjlat+0.25))/0.5)+1;
    lonnum=floor(((lpjlon-0.25)-(-180))/0.5)+1;
    %aggreate at 0.5 degree
    MPLV2AverageET=PMLV2ET_data(latnum,lonnum);
    
    if(isnan(MPLV2AverageET))
        MPLV2ET(latnum,lonnum)=NaN;
        LPJET(latnum,lonnum)=NaN;
    else
        MPLV2ET(latnum,lonnum)=MPLV2AverageET;
        LPJET(latnum,lonnum)=LPJET0318(latnum,lonnum);            
    end
end

%%Read ET file
lon=[-(180-0.5/2):0.5:(180-0.5/2)]';
lat=[(90-0.5/2):-0.5:-(90-0.5/2)]';
   diff= LPJET-MPLV2ET;
%for plot setting
diff(diff(:)>200)=200;
diff(diff(:)<-200)=-200;
Levels=[-200:50:200];
TitleStr='Annual mean ET DV (mm*yr^-^1) (LPJ-GUESS minus PML-V2 2003-2018) ';
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\2FigureET\ET DV(LPJGUESS minus PMLV2 2003 to 2018)';
Draw_Map(lon,lat,diff,TitleStr,OutputPath,Levels,'div', 'RdBu')

%for yearly scatter plot
[eco1_LPJy,eco2_LPJy,eco3_LPJy,eco4_LPJy,eco5_LPJy,eco6_LPJy,eco7_LPJy,eco8_LPJy,eco9_LPJy,eco10_LPJy,eco11_LPJy]=EcoregionMask(LPJET,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);
[eco1_MPLV2y,eco2_MPLV2y,eco3_MPLV2y,eco4_MPLV2y,eco5_MPLV2y,eco6_MPLV2y,eco7_MPLV2y,eco8_MPLV2y,eco9_MPLV2y,eco10_MPLV2y,eco11_MPLV2y]=EcoregionMask(MPLV2ET,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);

data=zeros(12,3);%for sdev,crmsd,ccoef 
dataName={'Observation','Globe','TSMBF', 'TSCF', 'TSGSS', 'TSDBF', 'TGSS', 'TCF', 'TBMF', 'MGS', 'MFWS', 'BFT', 'TU'};  

%% 
S = allstats(MPLV2ET(:),LPJET(:));
stdev=S(2,1);
S(2,:)=S(2,:)/stdev;% standization
S(3,:)=S(3,:)/stdev;% standization
data(1,:)=S(2:4,1);
data(2,:)=S(2:4,2);

S1 = allstats(eco1_MPLV2y(:),eco1_LPJy(:));
stdev=S1(2,1);
S1(2,:)=S1(2,:)/stdev;% standization
S1(3,:)=S1(3,:)/stdev;% standization
data(3,:)=S1(2:4,2);

S2 = allstats(eco2_MPLV2y(:),eco2_LPJy(:));
stdev=S2(2,1);
S2(2,:)=S2(2,:)/stdev;% standization
S2(3,:)=S2(3,:)/stdev;% standization
data(4,:)=S2(2:4,2);

S3 = allstats(eco3_MPLV2y(:),eco3_LPJy(:));
stdev=S3(2,1);
S3(2,:)=S3(2,:)/stdev;% standization
S3(3,:)=S3(3,:)/stdev;% standization
data(5,:)=S3(2:4,2);

S4 = allstats(eco4_MPLV2y(:),eco4_LPJy(:));
stdev=S4(2,1);
S4(2,:)=S4(2,:)/stdev;% standization
S4(3,:)=S4(3,:)/stdev;% standization
data(6,:)=S4(2:4,2);

S5 = allstats(eco5_MPLV2y(:),eco5_LPJy(:));
stdev=S5(2,1);
S5(2,:)=S5(2,:)/stdev;% standization
S5(3,:)=S5(3,:)/stdev;% standization
data(7,:)=S5(2:4,2);

S6 = allstats(eco6_MPLV2y(:),eco6_LPJy(:));
stdev=S6(2,1);
S6(2,:)=S6(2,:)/stdev;% standization
S6(3,:)=S6(3,:)/stdev;% standization
data(8,:)=S6(2:4,2);

S7 = allstats(eco7_MPLV2y(:),eco7_LPJy(:));
stdev=S7(2,1);
S7(2,:)=S7(2,:)/stdev;% standization
S7(3,:)=S7(3,:)/stdev;% standization
data(9,:)=S7(2:4,2);

S8 = allstats(eco8_MPLV2y(:),eco8_LPJy(:));
stdev=S8(2,1);
S8(2,:)=S8(2,:)/stdev;% standization
S8(3,:)=S8(3,:)/stdev;% standization
data(10,:)=S8(2:4,2);

S9 = allstats(eco9_MPLV2y(:),eco9_LPJy(:));
stdev=S9(2,1);
S9(2,:)=S9(2,:)/stdev;% standization
S9(3,:)=S9(3,:)/stdev;% standization
data(11,:)=S9(2:4,2);

S10 = allstats(eco10_MPLV2y(:),eco10_LPJy(:));
stdev=S10(2,1);
S10(2,:)=S10(2,:)/stdev;% standization
S10(3,:)=S10(3,:)/stdev;% standization
data(12,:)=S10(2:4,2);

S11 = allstats(eco11_MPLV2y(:),eco11_LPJy(:));
stdev=S11(2,1);
S11(2,:)=S11(2,:)/stdev;% standization
S11(3,:)=S11(3,:)/stdev;% standization
data(13,:)=S11(2:4,2);

Draw_taylorgraph(data,dataName,'G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\2FigureET\ecoregion\MPLV2LPJTaylor')