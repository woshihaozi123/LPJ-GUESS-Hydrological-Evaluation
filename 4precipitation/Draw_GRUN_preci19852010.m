%Draw Global GRUN Mean preci Map in 1985-2010 and diff with LPJ-GUESS
%2022/11/23  Hao Zhou

%start
clc;
clear;
tic

GSWP3FilePath1='G:\LPJGUESSHydrologyBalanceCheck\5Precipiation\GSWP3\pr_gswp3_1985_1990monthlymean.nc4';
GSWP3FilePath2='G:\LPJGUESSHydrologyBalanceCheck\5Precipiation\GSWP3\pr_gswp3_1991_2000monthlymean.nc4';
GSWP3FilePath3='G:\LPJGUESSHydrologyBalanceCheck\5Precipiation\GSWP3\pr_gswp3_2001_2010monthlymean.nc4';

% Dimensions:
%            lon  = 720
%            lat  = 360
%            time = 3652  (UNLIMITED)
ncdisp(GSWP3FilePath1);                                   %Display File Information                 
lon=double(ncread(GSWP3FilePath1,'lon'));                   %Read the longitude range and accuracy      
lat=double(ncread(GSWP3FilePath1,'lat'));                   %Read the latitude range and accuracy
time=double(ncread(GSWP3FilePath1,'time'));               %Read the time range and accuracy
GSWP3preci1=double(ncread(GSWP3FilePath1,'pr'));           %Read the Runoff range and accuracy
GSWP3preci2=double(ncread(GSWP3FilePath2,'pr'));           %Read the Runoff range and accuracy
GSWP3preci3=double(ncread(GSWP3FilePath3,'pr'));           %Read the Runoff range and accuracy

missing_value = 1.000000020040877e+20;
GSWP3preci=(GSWP3preci1*6+GSWP3preci2*10+GSWP3preci3*10)./26;

%% Read LPJGUESS Runoff .out data 
LPJPrecifilename='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mpreci8510ave.out';
LPJFileData=ReadTxtData(LPJPrecifilename);
LineNum=size(LPJFileData,1);%show line number of file

%Set other parameters
rownum=180/0.5;
colrum=360/0.5;
GSWP3Preci=zeros(rownum,colrum);
LPJPreci=zeros(rownum,colrum);

%grant the area without data NaN value and 0 for area with data
%for map plot later
GSWP3Preci(:)=NaN;
LPJPreci(:)=NaN;
for k=1:1:LineNum
    lpjlon=LPJFileData(k,1);
    lpjlat=LPJFileData(k,2);% lat/lon
    lonnum=floor((lpjlon-(-180))/0.5)+1;    
    latnum=floor((lpjlat-(-90))/0.5)+1;   
    GSWP3Preci(latnum,lonnum)=0;
    LPJPreci(latnum,lonnum)=0;
end

%% Average
for month=1:1:12
for k=1:1:LineNum
    lpjlon=LPJFileData(k,1);
    lpjlat=LPJFileData(k,2);
    lonnum=floor((lpjlon-(-180))/0.5)+1;    
    latnum=floor((lpjlat-(-90))/0.5)+1;    

    averagePreci=GSWP3preci(lonnum,latnum,month);    
    GSWP3Preci(latnum,lonnum)=GSWP3Preci(latnum,lonnum)+averagePreci;
    LPJPreci(latnum,lonnum)=LPJPreci(latnum,lonnum)+LPJFileData(k,month+2);
end
end

lon=[-(180-0.5/2):0.5:(180-0.5/2)]';
lat=[-(90-0.5/2):0.5:(90-0.5/2)]';

Levels=[0:500:3000];
TitleStr='GSWP3 Precipitation (mm*yr^-^1)';
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\4FigurePreci\GSWP3 Preci8510';
Draw_Map_withLine(lon,lat,GSWP3Preci,TitleStr,OutputPath,Levels,'YlGnBu',3000)


lon=[-(180-0.5/2):0.5:(180-0.5/2)]';
lat=[-(90-0.5/2):0.5:(90-0.5/2)]';
Levels=[0:500:3000];
TitleStr='CRUNCEP Precipitation (mm*yr^-^1)';
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\4FigurePreci\LPJGUESS Preci mean 8510';
Draw_Map_withLine(lon,lat,LPJPreci,TitleStr,OutputPath,Levels,'YlGnBu',3000)
%Draw_Map(lon,lat,LPJPreci,TitleStr,strcat(OutputPath,'onlymap'),Levels,'YlGnBu',1600)


diff=LPJPreci-GSWP3Preci;
%for plot
diff_original=diff;
shreshold=1000;
diff(diff(:)>shreshold)=shreshold;
diff(diff(:)<-shreshold)=-shreshold;
Levels=[-shreshold:shreshold/4:shreshold];
TitleStr='CRUNCEP minus GSWP3 (mm*yr^-^1)';
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\4FigurePreci\Preci DV(LPJGUESS-GSWP3)_lataverage8510';
%RGB=cbrewer('seq', 'YlOrRd',ticknum,'linear');
ticknum=size(Levels,2)-1;
RGB=cbrewer('div', 'RdBu',ticknum);
mode='h';%h or v
Draw_Diff_withLine(lon,lat,diff,diff_original,TitleStr,OutputPath,Levels,RGB,0,[-1600,1600])%Draw_Diff_withLine(lon,lat,data,data_original,titlestr,output,Levels,RGB,xlimit)
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\4FigurePreci\Preci DV(LPJGUESS-GSWP3)_latsum8510';
Draw_Diff_withLineAveragedArea(lon,lat,diff,diff_original,TitleStr,OutputPath,Levels,RGB,0,[-1600,1600])
