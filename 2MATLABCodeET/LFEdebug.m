clc;
clear;
lon=[-(180-0.5/2):0.5:(180-0.5/2)]';
lat=[(90-0.5/2):-0.5:-(90-0.5/2)]';
%For comparing LandFluxEVAL 1989-2005 1989-1995
LPJfile_longevap='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mevap8905ave.out';
LPJfile_longaet='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\maet8905ave.out';
LPJfile_longintercep='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mintercep8905ave.out';
LPJdata_longevap=ReadTxtData(LPJfile_longevap);
%for consistent map plot
lpjlon_list=LPJdata_longevap(:,1);
lpjlat_list=LPJdata_longevap(:,2);
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
maxvalue=max(LFEET_longall(:));
LFEET_longall(LFEET_longall(:)==maxvalue)=1600;
LFEET_longall(LFEET_longall(:)>1600)=1600;
LFEET_longall(LFEET_longall(:)<0)=0;
TitleStr='Annual mean ET(mm/yr)(LandFluxEVAL All data 1989-2005)';
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\2FigureET\ET LandFluxEVAL_ALL 1989 to 2005';
Draw_Map(lon,lat,LFEET_longall,TitleStr,OutputPath,Levels,'seq','YlGnBu')

Levels=[0:200:200*8];  
maxvalue=max(LFEET_shortall(:));
LFEET_shortall(LFEET_shortall(:)==maxvalue)=1600;
LFEET_shortall(LFEET_shortall(:)>1600)=1600;
LFEET_shortall(LFEET_shortall(:)<0)=0;
TitleStr='Annual mean ET(mm/yr)(LandFluxEVAL All data 1989-1995)';
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\2FigureET\ET LandFluxEVAL_ALL 1989 to 1995';
Draw_Map(lon,lat,LFEET_shortall,TitleStr,OutputPath,Levels,'seq','YlGnBu')
%%? why the color bar did show right tick-- to figure out later
% whether the maxium is less than 1600
% 
% max(LFEET_shortall(:))
% 
% ans =
% 
%    1.5109e+03
% 
% min(LFEET_shortall(:))
% 
% ans =
% 
%     8.3944
