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

%grant the area without data NaN value and 0 for area with data
GLEAMET(:)=NaN;
LPJET(:)=NaN;
for k=1:1:LineNum
    lpjlon=LPJdata_ET(k,1);
    lpjlat=LPJdata_ET(k,2);% lat/lon
    lonnum=floor((lpjlon-(-180))/0.5)+1;
    latnum=floor((lpjlat-(-90))/0.5)+1;
    GLEAMET(latnum,lonnum)=0;
    LPJET(latnum,lonnum)=0;
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
            GLEAMETMonth(latnum,lonnum)= NaN;
            LPJETMonth(latnum,lonnum)=NaN;
        else
            GLEAMET(latnum,lonnum)=GLEAMET(latnum,lonnum)+GLEAMAverageRunoff;
            LPJET(latnum,lonnum)=LPJET(latnum,lonnum)+LPJdata_ET(k,month+2);
            GLEAMETMonth(latnum,lonnum)= GLEAMETMonth(latnum,lonnum)+GLEAMAverageRunoff;
            LPJETMonth(latnum,lonnum)=LPJETMonth(latnum,lonnum)+LPJdata_ET(k,month+2);
            
        end
    end  
    [eco1_GLEAMm,eco2_GLEAMm,eco3_GLEAMm,eco4_GLEAMm,eco5_GLEAMm,eco6_GLEAMm,eco7_GLEAMm,eco8_GLEAMm,eco9_GLEAMm,eco10_GLEAMm,eco11_GLEAMm]=EcoregionMask(GLEAMETMonth,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);
    [eco1_LPJm,eco2_LPJm,eco3_LPJm,eco4_LPJm,eco5_LPJm,eco6_LPJm,eco7_LPJm,eco8_LPJm,eco9_LPJm,eco10_LPJm,eco11_LPJm]=EcoregionMask(LPJETMonth,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);

end
   

%for yearly scatter plot
[eco1_LPJy,eco2_LPJy,eco3_LPJy,eco4_LPJy,eco5_LPJy,eco6_LPJy,eco7_LPJy,eco8_LPJy,eco9_LPJy,eco10_LPJy,eco11_LPJy]=EcoregionMask(LPJET,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);
[eco1_GLEAMy,eco2_GLEAMy,eco3_GLEAMy,eco4_GLEAMy,eco5_GLEAMy,eco6_GLEAMy,eco7_GLEAMy,eco8_GLEAMy,eco9_GLEAMy,eco10_GLEAMy,eco11_GLEAMy]=EcoregionMask(GLEAMET,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);



data=zeros(12,3);%for sdev,crmsd,ccoef 
dataName={'Observation','Globe','TSMBF', 'TSCF', 'TSGSS', 'TSDBF', 'TGSS', 'TCF', 'TBMF', 'MGS', 'MFWS', 'BFT', 'TU'};  

%% 
S = allstats(GLEAMET(:),LPJET(:));
stdev=S(2,1);
S(2,:)=S(2,:)/stdev;% standization
S(3,:)=S(3,:)/stdev;% standization
data(1,:)=S(2:4,1);
data(2,:)=S(2:4,2);

S1 = allstats(eco1_GLEAMy(:),eco1_LPJy(:));
stdev=S1(2,1);
S1(2,:)=S1(2,:)/stdev;% standization
S1(3,:)=S1(3,:)/stdev;% standization
data(3,:)=S1(2:4,2);

S2 = allstats(eco2_GLEAMy(:),eco2_LPJy(:));
stdev=S2(2,1);
S2(2,:)=S2(2,:)/stdev;% standization
S2(3,:)=S2(3,:)/stdev;% standization
data(4,:)=S2(2:4,2);

S3 = allstats(eco3_GLEAMy(:),eco3_LPJy(:));
stdev=S3(2,1);
S3(2,:)=S3(2,:)/stdev;% standization
S3(3,:)=S3(3,:)/stdev;% standization
data(5,:)=S3(2:4,2);

S4 = allstats(eco4_GLEAMy(:),eco4_LPJy(:));
stdev=S4(2,1);
S4(2,:)=S4(2,:)/stdev;% standization
S4(3,:)=S4(3,:)/stdev;% standization
data(6,:)=S4(2:4,2);

S5 = allstats(eco5_GLEAMy(:),eco5_LPJy(:));
stdev=S5(2,1);
S5(2,:)=S5(2,:)/stdev;% standization
S5(3,:)=S5(3,:)/stdev;% standization
data(7,:)=S5(2:4,2);

S6 = allstats(eco6_GLEAMy(:),eco6_LPJy(:));
stdev=S6(2,1);
S6(2,:)=S6(2,:)/stdev;% standization
S6(3,:)=S6(3,:)/stdev;% standization
data(8,:)=S6(2:4,2);

S7 = allstats(eco7_GLEAMy(:),eco7_LPJy(:));
stdev=S7(2,1);
S7(2,:)=S7(2,:)/stdev;% standization
S7(3,:)=S7(3,:)/stdev;% standization
data(9,:)=S7(2:4,2);

S8 = allstats(eco8_GLEAMy(:),eco8_LPJy(:));
stdev=S8(2,1);
S8(2,:)=S8(2,:)/stdev;% standization
S8(3,:)=S8(3,:)/stdev;% standization
data(10,:)=S8(2:4,2);

S9 = allstats(eco9_GLEAMy(:),eco9_LPJy(:));
stdev=S9(2,1);
S9(2,:)=S9(2,:)/stdev;% standization
S9(3,:)=S9(3,:)/stdev;% standization
data(11,:)=S9(2:4,2);

S10 = allstats(eco10_GLEAMy(:),eco10_LPJy(:));
stdev=S10(2,1);
S10(2,:)=S10(2,:)/stdev;% standization
S10(3,:)=S10(3,:)/stdev;% standization
data(12,:)=S10(2:4,2);

S11 = allstats(eco11_GLEAMy(:),eco11_LPJy(:));
stdev=S11(2,1);
S11(2,:)=S11(2,:)/stdev;% standization
S11(3,:)=S11(3,:)/stdev;% standization
data(13,:)=S11(2:4,2);


Draw_taylorgraph(data,dataName,'G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\2FigureET\ecoregion\GLEAMLPJTaylor')
