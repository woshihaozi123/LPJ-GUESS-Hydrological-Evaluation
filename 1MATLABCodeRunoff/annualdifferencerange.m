%Draw Global GRUN Mean Runoff Map in 1985-2014 and diff with LPJ-GUESS
%2022/11/23  Hao Zhou

%start
clc;
clear;
tic
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



diff_original=LPJRunOff-GRUNRunOff;
%for plot
disp('gridcell annual range')
  nanmin(nanmin(diff_original))
  nanmax(nanmax(diff_original))
 data_latavg=nanmean(diff_original,2);
 disp('lat annual range')
    lat_annual_min=nanmin(data_latavg)
    nanmax(data_latavg)
    
data_latsum=zeros(size(lat,1),1);
for i=1:1:size(lat,1)
    lpjlat=lat(i);
    latcount=0;
    for j=1:1:size(lon,1)
      
        if ~isnan(diff_original(i,j))
       data_latsum(i)=data_latsum(i)+diff_original(i,j)*cellarea(lpjlat)/1e+12;
       %latcount=latcount+1;
        end
    end
end
    %xlimit=[min(data_lat),max(data_lat)];
    %data_lat=nanmean(data_original,2);%nanmean average by the 2rd dimension ignoring the nan
     disp('lat annual sum range')
    nanmin(data_latsum)
    nanmax(data_latsum)
    