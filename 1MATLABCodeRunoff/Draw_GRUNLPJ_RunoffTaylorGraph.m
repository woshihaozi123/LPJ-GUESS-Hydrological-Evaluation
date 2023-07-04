% Draw the annual mean runoff taylor graph of the LPJGUESS to GRUN
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

%% read data
%read LPJGUESS .out data
LPJFileData=ReadTxtData(LPJFilePath);
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

%grant the area without data NaN value and 0 for area with data
%for map plot later
GRUNRunOff(:)=NaN;
LPJRunOff(:)=NaN;
for k=1:1:LineNum
    lpjlon=LPJFileData(k,1);
    lpjlat=LPJFileData(k,2);% lat/lon
    lonnum=floor((lpjlon-(-180))/0.5)+1;    
    latnum=floor((lpjlat-(-90))/0.5)+1;   
    GRUNRunOff(latnum,lonnum)=0;
    LPJRunOff(latnum,lonnum)=0;
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
            GRUNRunOffMonth(latnum,lonnum)= NaN;
            LPJRunOffMonth(latnum,lonnum)=NaN;
        else
            GRUNRunOff(latnum,lonnum)=GRUNRunOff(latnum,lonnum)+GRUNAverageRunoff;
            LPJRunOff(latnum,lonnum)=LPJRunOff(latnum,lonnum)+LPJFileData(k,month+2);
            GRUNRunOffMonth(latnum,lonnum)= GRUNRunOffMonth(latnum,lonnum)+GRUNAverageRunoff;
            LPJRunOffMonth(latnum,lonnum)=LPJRunOffMonth(latnum,lonnum)+LPJFileData(k,month+2);
            
        end
        
    end
    
    [eco1_GRUNm,eco2_GRUNm,eco3_GRUNm,eco4_GRUNm,eco5_GRUNm,eco6_GRUNm,eco7_GRUNm,eco8_GRUNm,eco9_GRUNm,eco10_GRUNm,eco11_GRUNm]=EcoregionMask(GRUNRunOffMonth,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);
    [eco1_LPJm,eco2_LPJm,eco3_LPJm,eco4_LPJm,eco5_LPJm,eco6_LPJm,eco7_LPJm,eco8_LPJm,eco9_LPJm,eco10_LPJm,eco11_LPJm]=EcoregionMask(LPJRunOffMonth,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);
        
    
end


%for draw yearly mean ratio
%for yearly scatter plot
[eco1_LPJy,eco2_LPJy,eco3_LPJy,eco4_LPJy,eco5_LPJy,eco6_LPJy,eco7_LPJy,eco8_LPJy,eco9_LPJy,eco10_LPJy,eco11_LPJy]=EcoregionMask(LPJRunOff,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);
[eco1_GRUNy,eco2_GRUNy,eco3_GRUNy,eco4_GRUNy,eco5_GRUNy,eco6_GRUNy,eco7_GRUNy,eco8_GRUNy,eco9_GRUNy,eco10_GRUNy,eco11_GRUNy]=EcoregionMask(GRUNRunOff,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);

data=zeros(12,3);%for sdev,crmsd,ccoef 
dataName={'Observation','Globe','TSMBF', 'TSCF', 'TSGSS', 'TSDBF', 'TGSS', 'TCF', 'TBMF', 'MGS', 'MFWS', 'BFT', 'TU'};  

%% 
S = allstats(GRUNRunOff(:),LPJRunOff(:));
stdev=S(2,1);
S(2,:)=S(2,:)/stdev;% standization
S(3,:)=S(3,:)/stdev;% standization
data(1,:)=S(2:4,1);
data(2,:)=S(2:4,2);

S1 = allstats(eco1_GRUNy(:),eco1_LPJy(:));
stdev=S1(2,1);
S1(2,:)=S1(2,:)/stdev;% standization
S1(3,:)=S1(3,:)/stdev;% standization
data(3,:)=S1(2:4,2);

S2 = allstats(eco2_GRUNy(:),eco2_LPJy(:));
stdev=S2(2,1);
S2(2,:)=S2(2,:)/stdev;% standization
S2(3,:)=S2(3,:)/stdev;% standization
data(4,:)=S2(2:4,2);

S3 = allstats(eco3_GRUNy(:),eco3_LPJy(:));
stdev=S3(2,1);
S3(2,:)=S3(2,:)/stdev;% standization
S3(3,:)=S3(3,:)/stdev;% standization
data(5,:)=S3(2:4,2);

S4 = allstats(eco4_GRUNy(:),eco4_LPJy(:));
stdev=S4(2,1);
S4(2,:)=S4(2,:)/stdev;% standization
S4(3,:)=S4(3,:)/stdev;% standization
data(6,:)=S4(2:4,2);

S5 = allstats(eco5_GRUNy(:),eco5_LPJy(:));
stdev=S5(2,1);
S5(2,:)=S5(2,:)/stdev;% standization
S5(3,:)=S5(3,:)/stdev;% standization
data(7,:)=S5(2:4,2);

S6 = allstats(eco6_GRUNy(:),eco6_LPJy(:));
stdev=S6(2,1);
S6(2,:)=S6(2,:)/stdev;% standization
S6(3,:)=S6(3,:)/stdev;% standization
data(8,:)=S6(2:4,2);

S7 = allstats(eco7_GRUNy(:),eco7_LPJy(:));
stdev=S7(2,1);
S7(2,:)=S7(2,:)/stdev;% standization
S7(3,:)=S7(3,:)/stdev;% standization
data(9,:)=S7(2:4,2);

S8 = allstats(eco8_GRUNy(:),eco8_LPJy(:));
stdev=S8(2,1);
S8(2,:)=S8(2,:)/stdev;% standization
S8(3,:)=S8(3,:)/stdev;% standization
data(10,:)=S8(2:4,2);

S9 = allstats(eco9_GRUNy(:),eco9_LPJy(:));
stdev=S9(2,1);
S9(2,:)=S9(2,:)/stdev;% standization
S9(3,:)=S9(3,:)/stdev;% standization
data(11,:)=S9(2:4,2);

S10 = allstats(eco10_GRUNy(:),eco10_LPJy(:));
stdev=S10(2,1);
S10(2,:)=S10(2,:)/stdev;% standization
S10(3,:)=S10(3,:)/stdev;% standization
data(12,:)=S10(2:4,2);

S11 = allstats(eco11_GRUNy(:),eco11_LPJy(:));
stdev=S11(2,1);
S11(2,:)=S11(2,:)/stdev;% standization
S11(3,:)=S11(3,:)/stdev;% standization
data(13,:)=S11(2:4,2);


Draw_taylorgraph(data,dataName,'G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\1FigureRunoff\GRUNLPJTaylor_2')
