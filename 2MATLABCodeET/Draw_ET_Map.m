% Draw the LPJGUESS ET and diff with GLEAM PML-V LandFluxEVAL
clc;
clear;
tic;

%%Read ET file
lon=[-(180-0.5/2):0.5:(180-0.5/2)]';
lat=[(90-0.5/2):-0.5:-(90-0.5/2)]';
%% LPJ-GUESS 
%For comparing LandFluxEVAL 1989-2005 1989-1995
LPJfile_longevap='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mevap8905ave.out';
LPJfile_longaet='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\maet8905ave.out';
LPJfile_longintercep='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mintercep8905ave.out';
LPJdata_longevap=ReadTxtData(LPJfile_longevap);
LPJdata_longaet=ReadTxtData(LPJfile_longaet);
LPJdata_longintercep=ReadTxtData(LPJfile_longintercep);


LPJfile_shortevap='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mevap8995ave.out';
LPJfile_shortaet='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\maet8995ave.out';
LPJfile_shortintercep='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mintercep8995ave.out';
LPJdata_shortevap=ReadTxtData(LPJfile_shortevap);
LPJdata_shortaet=ReadTxtData(LPJfile_shortaet);
LPJdata_shortintercep=ReadTxtData(LPJfile_shortintercep);


%for consistent map plot
lpjlon_list=LPJdata_longevap(:,1);
lpjlat_list=LPJdata_longevap(:,2);
LPJdata_longET=LPJdata_longevap+LPJdata_longaet+LPJdata_longintercep;
LPJ_longET=LPJProcessForMap(LPJdata_longET,lpjlon_list,lpjlat_list);
LPJdata_shortET=LPJdata_shortevap+LPJdata_shortaet+LPJdata_shortintercep;
LPJ_shortET=LPJProcessForMap(LPJdata_shortET,lpjlon_list,lpjlat_list);

%For comparing GLEAM  1985-2014
LPJfile_evap='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mevap8514ave.out';
LPJfile_aet='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\maet8514ave.out';
LPJfile_intercep='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mintercep8514ave.out';
LPJdata_evap=ReadTxtData(LPJfile_evap);
LPJdata_aet=ReadTxtData(LPJfile_aet);
LPJdata_intercep=ReadTxtData(LPJfile_intercep);

LPJdata_ET=LPJdata_evap+LPJdata_aet+LPJdata_intercep;
LPJET=LPJProcessForMap(LPJdata_ET,lpjlon_list,lpjlat_list);

% For comparing PML_V2 2003-2014
%2003-2018 water balance file 
%Lon	Lat	aaet	aevap	aintercep	apreci	total_water_in_colum	soilwaterchange	snowpackchange
LPJFileName = 'G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\waterbalance0314.xlsx';
[Data,Txt] = xlsread(LPJFileName);
data_LPJaet= Data(:,3);
data_LPJevap= Data(:,4);
data_LPJintercep= Data(:,5);
data_LPJET= data_LPJaet+data_LPJevap+data_LPJintercep;
LPJET0318=LPJProcessYearlyForMap(data_LPJET,lpjlon_list,lpjlat_list);

%draw lpj map for three period
Levels=[0:200:200*8];     
TitleStr='Annual mean ET (mm*yr^-^1) (LPJ-GUESS 1989-2005)';
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\2FigureET\ET LPJGUESS 1989 to 2005';
Draw_Map(lon,lat,LPJ_longET,TitleStr,OutputPath,Levels,'seq','YlGnBu')

Levels=[0:200:200*8];     
TitleStr='Annual mean ET (mm*yr^-^1) (LPJ-GUESS 1989-1995)';
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\2FigureET\ET LPJGUESS 1989 to 1995';
Draw_Map(lon,lat,LPJ_shortET,TitleStr,OutputPath,Levels,'seq','YlGnBu')

Levels=[0:200:200*8];     
TitleStr='Annual mean ET (mm*yr^-^1) (LPJ-GUESS 1985-2014)';
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\2FigureET\ET LPJGUESS 1985 to 2014';
Draw_Map(lon,lat,LPJET,TitleStr,OutputPath,Levels,'seq','YlGnBu')

%% GLEAM a and b
filename_GleamEi='D:\Program Files\PuTTY\GLEAM data\v3.5a\yearly after 3.9\Ei_1980-2020_GLEAM_v3.5a_YR.nc';
filename_GleamEb='D:\Program Files\PuTTY\GLEAM data\v3.5a\yearly after 3.9\Eb_1980-2020_GLEAM_v3.5a_YR.nc';
filename_GleamEt='D:\Program Files\PuTTY\GLEAM data\v3.5a\yearly after 3.9\Et_1980-2020_GLEAM_v3.5a_YR.nc';
% ncdisp(filename_GleamEi);
% lon_GleamEi=double(ncread(filename_GleamEi,'lon'));
% lat_GleamEi=double(ncread(filename_GleamEi,'lat'));
% time_GleamEi=double(length(ncread(filename_GleamEi,'time')));
data_GleamET=double(ncread(filename_GleamEi,'Ei'))+double(ncread(filename_GleamEb,'Eb'))+double(ncread(filename_GleamEt,'Et'));
GleamET=GLEAMProcessForMap(data_GleamET,lpjlon_list,lpjlat_list,1985,2014);
%draw GLEAM and diff with lpj
Levels=[0:200:200*8];     
TitleStr='Annual mean ET (mm*yr^-^1) (GLEAM 1985-2014)';
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\2FigureET\ET GLEAM 1985 to 2014';
Draw_Map(lon,lat,LPJET,TitleStr,OutputPath,Levels,'seq','YlGnBu')

diff=LPJET-GleamET;
%for plot setting
diff(diff(:)>200)=200;
diff(diff(:)<-200)=-200;
Levels=[-200:50:200];
TitleStr='Annual mean ET DV (mm*yr^-^1) (LPJ-GUESS minus GLEAM 1985-2014) ';
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\2FigureET\ET DV(LPJGUESS minus GLEAM 1985 to 2014)';
Draw_Map(lon,lat,diff,TitleStr,OutputPath,Levels,'div', 'RdBu')


%% PML_V2
fileName2='D:\Program Files\PuTTY\PML_V2 code\yearmean\2003-2014_0.5.tif';
tifimage=imread(char(fileName2));
data_MPL2 =tifimage(:,:,2)+tifimage(:,:,3)+tifimage(:,:,4); 
% GPP	gC m-2 d-1	0.01	Gross primary product
% Ec	mm d-1	0.01	Vegetation Transpiration
% Es	mm d-1	0.01	Soil Evaporation
% Ei	mm d-1	0.01	Interception from vegetation canopy
% ET_water	mm d-1	0.01	Water body, snow and ice evaporation. Penman
% evapotranspiration is regarded as actual evaporation for them.
PMLV2ET=PMLV2ProcessForMap(data_MPL2,lpjlon_list,lpjlat_list);

%draw PML-V2 and diff with lpj
Levels=[0:200:200*8];     
TitleStr='Annual mean ET (mm*yr^-^1) (PML-V2 2003-2014)';
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\2FigureET\ET PMLV2 2003 to 2014';
Draw_Map(lon,lat,PMLV2ET,TitleStr,OutputPath,Levels,'seq','YlGnBu')

diff=LPJET0314-PMLV2ET;
%for plot setting
diff(diff(:)>200)=200;
diff(diff(:)<-200)=-200;
Levels=[-200:50:200];
TitleStr='Annual mean ET DV (mm*yr^-^1) (LPJ-GUESS minus PML-V2 2003-2014) ';
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\2FigureET\ET DV(LPJGUESS minus PMLV2 2003 to 2014)';
Draw_Map(lon,lat,diff,TitleStr,OutputPath,Levels,'div', 'RdBu')


%% LandFluxEVAL
%   Size:       360x180x17
%            Dimensions: lon,lat,time
%            Datatype:   double
%            Attributes:
%            long_name  = 'Evapotranspiration mean'
%            units      = 'mm/d'
%            _FillValue = -9999
LFEfile_longall='G:\LPJGUESSHydrologyBalanceCheck\2ET\LandFlux-EVAL merged synthesis products\LandFluxEVAL.merged.89-05.multiyear.all.nc';
LFEfile_shortall='G:\LPJGUESSHydrologyBalanceCheck\2ET\LandFlux-EVAL merged synthesis products\LandFluxEVAL.merged.89-95.multiyear.all.nc';
Data_longall = ReadNCMap(LFEfile_longall,'ET_mean');
Data_shortall = ReadNCMap(LFEfile_shortall,'ET_mean');

longyear=2005-1989+1;
shortyear=1995-1989+1;
longdays=0;
shortdays=0;
for year=1989:1:2005
    longdays=longdays+yeardays(year);
end
for year=1989:1995
    shortdays=shortdays+yeardays(year);
end

LFEET_longall=LFEProcessForMap(Data_longall,lpjlon_list,lpjlat_list);
LFEET_shortall=LFEProcessForMap(Data_shortall,lpjlon_list,lpjlat_list);
%unit mm/day to mm/year
LFEET_longall=(LFEET_longall*longdays)/longyear;
LFEET_shortall=(LFEET_shortall*shortdays)/shortyear;
%draw LFE all
Levels=[0:200:200*8]; 
%because the maxium is less than 1600, we set max(LFEET_longall(:)) to 1600 to
%plot
maxvalue=max(LFEET_longall(:));
LFEET_longall(LFEET_longall(:)==maxvalue)=1600;
LFEET_longall(LFEET_longall(:)>1600)=1600;
LFEET_longall(LFEET_longall(:)<0)=0;
TitleStr='Annual mean ET (mm*yr^-^1) (LandFluxEVAL All data 1989-2005)';
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\2FigureET\ET LandFluxEVAL_ALL 1989 to 2005';
Draw_Map(lon,lat,LFEET_longall,TitleStr,OutputPath,Levels,'seq','YlGnBu')

Levels=[0:200:200*8];  
maxvalue=max(LFEET_shortall(:));
LFEET_shortall(LFEET_shortall(:)==maxvalue)=1600;
LFEET_shortall(LFEET_shortall(:)>1600)=1600;
LFEET_shortall(LFEET_shortall(:)<0)=0;
TitleStr='Annual mean ET (mm*yr^-^1) (LandFluxEVAL All data 1989-1995)';
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\2FigureET\ET LandFluxEVAL_ALL 1989 to 1995';
Draw_Map(lon,lat,LFEET_shortall,TitleStr,OutputPath,Levels,'seq','YlGnBu')

%draw LFE diff with LPJ
diff=LPJ_longET-LFEET_longall;
diff(diff(:)>200)=200;
diff(diff(:)<-200)=-200;
Levels=[-200:50:200];
    
TitleStr='Annual mean ET DV (mm*yr^-^1) (LPJ-GUESS minus LandFluxEVAL ALL 1989-2005)';
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\2FigureET\ET LPJGUESS minus LandFluxEVAL ALL 1989 to 2005';
Draw_Map(lon,lat,diff,TitleStr,OutputPath,Levels,'div', 'RdBu')

diff=LPJ_shortET-LFEET_shortall;
diff(diff(:)>200)=200;
diff(diff(:)<-200)=-200;
Levels=[-200:50:200];     
TitleStr='Annual mean ET DV (mm*yr^-^1) (LPJ-GUESS minus LandFluxEVAL ALL 1989-1995)';
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\2FigureET\ET LPJGUESS minus LandFluxEVAL ALL 1989 to 1995';
Draw_Map(lon,lat,diff,TitleStr,OutputPath,Levels,'div', 'RdBu')

%%
toc;