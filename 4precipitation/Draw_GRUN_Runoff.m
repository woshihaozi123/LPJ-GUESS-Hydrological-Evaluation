%Draw Global GRUN Mean Runoff Map in 1985-2010 and diff with LPJ-GUESS
%2022/11/23  Hao Zhou

%start
clc;
clear;
tic
%% input/output Path and figure title Parameters
LPJFilePath='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mrunoff8510ave.out';
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

%Set other parameters
StartYear=1985;
EndYear=2010;
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

%% Average
for month=1:1:12

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

    averageRunoff=GRUNMonthlyMeanRunoff(lonnum,latnum);    
    GRUNRunOff(latnum,lonnum)=GRUNRunOff(latnum,lonnum)+averageRunoff;
    LPJRunOff(latnum,lonnum)=LPJRunOff(latnum,lonnum)+LPJFileData(k,month+2);
end
end
lon=[-(180-0.5/2):0.5:(180-0.5/2)]';
lat=[-(90-0.5/2):0.5:(90-0.5/2)]';

Levels=[0:200:1200];
TitleStr='GRNU Runoff (mm*yr^-^1)';
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\1FigureRunoff\GRUN runoff8510';
Draw_Map_withLine(lon,lat,GRUNRunOff,TitleStr,OutputPath,Levels,'YlGnBu',1600)


lon=[-(180-0.5/2):0.5:(180-0.5/2)]';
lat=[-(90-0.5/2):0.5:(90-0.5/2)]';
Levels=[0:200:1200];
TitleStr='(a) LPJ-GUESS Runoff (mm*yr^-^1)';
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\1FigureRunoff\LPJGUESS Runoff mean 8510';
Draw_Map_withLine(lon,lat,LPJRunOff,TitleStr,OutputPath,Levels,'YlGnBu',1600)
%Draw_Map(lon,lat,LPJRunOff,TitleStr,strcat(OutputPath,'onlymap'),Levels,'YlGnBu',1600)


diff=LPJRunOff-GRUNRunOff;
%for plot
diff_original=diff;
diff(diff(:)>200)=200;
diff(diff(:)<-200)=-200;
Levels=[-200,-150,-100,-50,0,50,100,150,200];
TitleStr='(b) LPJ-GUESS minus GRUN (mm*yr^-^1)';
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\1FigureRunoff\Runoff DV(LPJGUESS-GRUN)_lataverage8510';
%RGB=cbrewer('seq', 'YlOrRd',ticknum,'linear');
ticknum=size(Levels,2)-1;
RGB=cbrewer('div', 'RdBu',ticknum);
mode='h';%h or v
Draw_Diff_withLine(lon,lat,diff,diff_original,TitleStr,OutputPath,Levels,RGB,0,[-1600,1600])%Draw_Diff_withLine(lon,lat,data,data_original,titlestr,output,Levels,RGB,xlimit)
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\1FigureRunoff\Runoff DV(LPJGUESS-GRUN)_latsum8510';
Draw_Diff_withLineAveragedArea(lon,lat,diff,diff_original,TitleStr,OutputPath,Levels,RGB,0,[-120,120])