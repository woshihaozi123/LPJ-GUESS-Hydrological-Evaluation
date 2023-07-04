%Draw Global LPJ-GUESS Mean Runoff Map in 1985-2014
%2022/11/23  Hao Zhou

%start
clc;
clear;
tic
%% input/output Path and figure title Parameters
InputPath='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mrunoff8514ave.out';

%% Read LPJGUESS Runoff .out data 
LPJFileData=ReadTxtData(InputPath);
LineNum=size(LPJFileData,1)%show line number of file

%Set other parameters 
StartYear=1985;
EndYear=2014;
RowNum=180/0.5;
ColNum=360/0.5;
LPJRunoff=zeros(RowNum,ColNum);

%grant the area without data NaN value and 0 for area with data
%for map plot later
LPJRunoff(:)=NaN;
for k=1:1:LineNum
    lpjlon=LPJFileData(k,1);
    lpjlat=LPJFileData(k,2);% lat/lon
    lonnum=floor((lpjlon-(-180))/0.5)+1;    
    latnum=floor((lpjlat-(-90))/0.5)+1;   
    LPJRunoff(latnum,lonnum)=0;
end

%% Average
for k=1:1:LineNum
    for month=1:1:12
        %get lon/lat from the the line
        lpjlon=LPJFileData(k,1);
        lpjlat=LPJFileData(k,2);
        %convert lon/lat to the number of array
        lonnum=floor((lpjlon-(-180))/0.5)+1;
        latnum=floor((lpjlat-(-90))/0.5)+1;
        %sum month value
        LPJRunoff(latnum,lonnum)=LPJRunoff(latnum,lonnum)+LPJFileData(k,month+2);
    end
end

%% draw
lon=[-(180-0.5/2):0.5:(180-0.5/2)]';
lat=[-(90-0.5/2):0.5:(90-0.5/2)]';
Levels=[0:200:1200];
TitleStr='(a) LPJ-GUESS Runoff (mm*yr^-1)';
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\1FigureRunoff\LPJGUESS Runoff mean 8514';
%Draw_Map_withLine(lon,lat,LPJRunoff,TitleStr,OutputPath,Levels,'YlGnBu',1600)
Draw_Map(lon,lat,LPJRunoff,TitleStr,strcat(OutputPath,'onlymap'),Levels,'seq','YlGnBu')
%end
toc
disp('Runing finished')
msgbox('Output Successfully!', 'Result');