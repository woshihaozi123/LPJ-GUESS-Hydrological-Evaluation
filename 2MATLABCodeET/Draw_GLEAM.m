% Draw the LPJGUESS ET and diff with GLEAM
clc;
clear;


%%Read ET file
lon=[-(180-0.5/2):0.5:(180-0.5/2)]';
lat=[(90-0.5/2):-0.5:-(90-0.5/2)]';
%% LPJ-GUESS 
%For comparing GLEAM  1985-2014
LPJfile_evap='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mevap8514ave.out';
LPJfile_aet='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\maet8514ave.out';
LPJfile_intercep='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mintercep8514ave.out';
LPJdata_evap=ReadTxtData(LPJfile_evap);
LPJdata_aet=ReadTxtData(LPJfile_aet);
LPJdata_intercep=ReadTxtData(LPJfile_intercep);
%for consistent map plot
lpjlon_list=LPJdata_evap(:,1);
lpjlat_list=LPJdata_evap(:,2);

LPJdata_ET=LPJdata_evap+LPJdata_aet+LPJdata_intercep;
LPJET=LPJProcessForMap(LPJdata_ET,lpjlon_list,lpjlat_list);




Levels=[0:200:200*8];     
TitleStr='(e) LPJ-GUESS ET (mm*yr^-^1)';
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\2FigureET\ET LPJGUESS 1985 to 2014';
%Draw_Map(lon,lat,LPJET,TitleStr,OutputPath,Levels,'seq','YlGnBu')
Draw_Map_withLine(lon,lat,LPJET,TitleStr,OutputPath,Levels,'YlGnBu',1600)

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
TitleStr='GLEAM ET (mm*yr^-^1)';
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\2FigureET\ET GLEAM 1985 to 2014';
Draw_Map(lon,lat,LPJET,TitleStr,OutputPath,Levels,'seq','YlGnBu')

diff=LPJET-GleamET;
diff_original=diff;
%for plot setting
diff(diff(:)>200)=200;
diff(diff(:)<-200)=-200;
Levels=[-200:50:200];
TitleStr='(f) LPJ-GUESS minus GLEAM (mm*yr^-^1)';
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\2FigureET\ET DV(LPJGUESS minus GLEAM 1985 to 2014)_lataver';
%Draw_Map(lon,lat,diff,TitleStr,OutputPath,Levels,'div', 'RdBu')
ticknum=size(Levels,2)-1;
RGB=cbrewer('div', 'RdBu',ticknum);
mode='h';%h or v
Draw_Diff_withLine(lon,lat,diff,diff_original,TitleStr,OutputPath,Levels,RGB,0,[-200,200])%Draw_Diff_withLine(lon,lat,data,data_original,titlestr,output,Levels,RGB,xlimit)
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\2FigureET\ET DV(LPJGUESS minus GLEAM 1985 to 2014)_latsum';
Draw_Diff_withLineAveragedArea(lon,lat,diff,diff_original,TitleStr,OutputPath,Levels,RGB,0,[-120,120])