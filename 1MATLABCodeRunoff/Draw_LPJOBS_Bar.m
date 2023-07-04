clc;
clear;
%% 
%'Amazon','Danube','MacKenzie','Mississippi','Murray','Yenisei','Zaire','Nile'
[S1_x,S1_y]=textread('F:\catchment\catchmentpoint\amazon.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S2_x,S2_y]=textread('F:\catchment\catchmentpoint\danube.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S3_x,S3_y]=textread('F:\catchment\catchmentpoint\mackenzie.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S4_x,S4_y]=textread('F:\catchment\catchmentpoint\mississippi.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S5_x,S5_y]=textread('F:\catchment\catchmentpoint\murray.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S6_x,S6_y]=textread('F:\catchment\catchmentpoint\yenisei.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S7_x,S7_y]=textread('F:\catchment\catchmentpoint\zaire.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S8_x,S8_y]=textread('F:\catchment\catchmentpoint\nile.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S9_x,S9_y]=textread('F:\catchment\catchmentpoint\ganges.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S10_x,S10_y]=textread('F:\catchment\catchmentpoint\yangtze.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );


%% read Grun runoff
filename='D:\Program Files\PuTTY\GRUN_v1_GSWP3_WGS84_05_1902_2014.nc';
ncdisp(filename);                                    %展示文件信息
%提取变量                   
lon=double(ncread(filename,'X'));                   %读取经度范围和精度      
lat=double(ncread(filename,'Y'));                   %读取纬度范围和精度
time=double(ncread(filename,'time'));         %读取时间序列长度
DataGRUNRunoff=double(ncread(filename,'Runoff'));%提取变量

% monthly lpj runoff data
filename='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mrunoff.out';
delimiterIn = ' ';                      %列分隔符
headerlinesIn = 1;                      %读取从第 headerlinesIn+1 行开始的数值数据
present=importdata(filename,delimiterIn,headerlinesIn);
LPJdata_Runoff=present.data;                 %导出的1行以后的数据

% read lpj average data
LPJPrecifilename='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mrunoff8514ave.out';
fid = fopen(LPJPrecifilename,'r');
allText = textscan(fid,'%s','delimiter','\n');
numberOfLines = length(allText{1});
fclose(fid);
RunoffFileDataAveage=zeros(numberOfLines-1,14);
for INDEX = 2:numberOfLines
    str = char(allText{1,1}(INDEX));
    RunoffFileDataAveage(INDEX-1,:)=str2num(char(strsplit(str)));
end
datanum=size(RunoffFileDataAveage,1);

%%
%LPJ ET  1985-2014
LPJfile_evap='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mevap.out';
LPJfile_aet='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\maet.out';
LPJfile_intercep='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mintercep.out';
LPJdata_evap=ReadTxtData(LPJfile_evap);
LPJdata_aet=ReadTxtData(LPJfile_aet);
LPJdata_intercep=ReadTxtData(LPJfile_intercep);

LPJdata_ET=LPJdata_evap+LPJdata_aet+LPJdata_intercep;
lpjlon_list=LPJdata_evap(:,1);
lpjlat_list=LPJdata_evap(:,2);

% LPJET=LPJProcessForMap(LPJdata_ET,lpjlon_list,lpjlat_list);
% LPJEiSeries=LPJProcessForMap(LPJdata_intercep,lpjlon_list,lpjlat_list);
% LPJEbSeries=LPJProcessForMap(LPJdata_evap,lpjlon_list,lpjlat_list);
% LPJEtSeries=LPJProcessForMap(LPJdata_aet,lpjlon_list,lpjlat_list);

%% GLEAM a and b
filename_GleamEi='D:\Program Files\PuTTY\GLEAM data\v3.5a\yearly after 3.9\Ei_1980-2020_GLEAM_v3.5a_YR.nc';
filename_GleamEb='D:\Program Files\PuTTY\GLEAM data\v3.5a\yearly after 3.9\Eb_1980-2020_GLEAM_v3.5a_YR.nc';
filename_GleamEt='D:\Program Files\PuTTY\GLEAM data\v3.5a\yearly after 3.9\Et_1980-2020_GLEAM_v3.5a_YR.nc';
% ncdisp(filename_GleamEi);
data_GleamEi=double(ncread(filename_GleamEi,'Ei'));
data_GleamEb=double(ncread(filename_GleamEb,'Eb'));
data_GleamEt=double(ncread(filename_GleamEt,'Et'));
data_GleamET=double(ncread(filename_GleamEi,'Ei'))+double(ncread(filename_GleamEb,'Eb'))+double(ncread(filename_GleamEt,'Et'));

% GleamET=GLEAMProcessForMap(data_GleamET,lpjlon_list,lpjlat_list,1985,2014);
% GleamEiSeries=GLEAMProcessForMap(data_GleamEi,lpjlon_list,lpjlat_list,1985,2014);
% GleamEbSeries=GLEAMProcessForMap(data_GleamEb,lpjlon_list,lpjlat_list,1985,2014);
% GleamEtSeries=GLEAMProcessForMap(data_GleamEt,lpjlon_list,lpjlat_list,1985,2014);



% monthly lpj precipiation data
filename='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mpreci.out';
delimiterIn = ' ';                      %列分隔符
headerlinesIn = 1;                      %读取从第 headerlinesIn+1 行开始的数值数据
present=importdata(filename,delimiterIn,headerlinesIn);
LPJdata_Preci=present.data;                 %导出的1行以后的数据

%% parameter
startyear=1985;% trend from the begining
endyear=2014;
Grunstartyear=1902;
Grunendyear=2020;
Grunyearbound=[1980,2020];
daynumofmonth=[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
yearseries=1:1:endyear-Grunstartyear+1;
numofyear=endyear-startyear+1;
rownum=180/0.5;
colrum=360/0.5;
diff=zeros(rownum,colrum);

GRUNRunOffSeries=zeros(rownum,colrum,numofyear);
LPJRunOffSeries=zeros(rownum,colrum,numofyear);
GleamEiSeries=zeros(rownum,colrum,numofyear);
GleamEbSeries=zeros(rownum,colrum,numofyear);
GleamEtSeries=zeros(rownum,colrum,numofyear);
LPJEiSeries=zeros(rownum,colrum,numofyear);
LPJEbSeries=zeros(rownum,colrum,numofyear);
LPJEtSeries=zeros(rownum,colrum,numofyear);

LPJPreciSeries=zeros(rownum,colrum,numofyear);

eco_RunoffObs1=zeros(numofyear,1);eco_RunoffLPJ1=zeros(numofyear,1);eco_EiObs1=zeros(numofyear,1);eco_EbObs1=zeros(numofyear,1);eco_EtObs1=zeros(numofyear,1);eco_EiLPJ1=zeros(numofyear,1);eco_EbLPJ1=zeros(numofyear,1);eco_EtLPJ1=zeros(numofyear,1);eco_PreciLPJ1=zeros(numofyear,1);
eco_RunoffObs2=zeros(numofyear,1);eco_RunoffLPJ2=zeros(numofyear,1);eco_EiObs2=zeros(numofyear,1);eco_EbObs2=zeros(numofyear,1);eco_EtObs2=zeros(numofyear,1);eco_EiLPJ2=zeros(numofyear,1);eco_EbLPJ2=zeros(numofyear,1);eco_EtLPJ2=zeros(numofyear,1);eco_PreciLPJ2=zeros(numofyear,1);
eco_RunoffObs3=zeros(numofyear,1);eco_RunoffLPJ3=zeros(numofyear,1);eco_EiObs3=zeros(numofyear,1);eco_EbObs3=zeros(numofyear,1);eco_EtObs3=zeros(numofyear,1);eco_EiLPJ3=zeros(numofyear,1);eco_EbLPJ3=zeros(numofyear,1);eco_EtLPJ3=zeros(numofyear,1);eco_PreciLPJ3=zeros(numofyear,1);
eco_RunoffObs4=zeros(numofyear,1);eco_RunoffLPJ4=zeros(numofyear,1);eco_EiObs4=zeros(numofyear,1);eco_EbObs4=zeros(numofyear,1);eco_EtObs4=zeros(numofyear,1);eco_EiLPJ4=zeros(numofyear,1);eco_EbLPJ4=zeros(numofyear,1);eco_EtLPJ4=zeros(numofyear,1);eco_PreciLPJ4=zeros(numofyear,1);
eco_RunoffObs5=zeros(numofyear,1);eco_RunoffLPJ5=zeros(numofyear,1);eco_EiObs5=zeros(numofyear,1);eco_EbObs5=zeros(numofyear,1);eco_EtObs5=zeros(numofyear,1);eco_EiLPJ5=zeros(numofyear,1);eco_EbLPJ5=zeros(numofyear,1);eco_EtLPJ5=zeros(numofyear,1);eco_PreciLPJ5=zeros(numofyear,1);
eco_RunoffObs6=zeros(numofyear,1);eco_RunoffLPJ6=zeros(numofyear,1);eco_EiObs6=zeros(numofyear,1);eco_EbObs6=zeros(numofyear,1);eco_EtObs6=zeros(numofyear,1);eco_EiLPJ6=zeros(numofyear,1);eco_EbLPJ6=zeros(numofyear,1);eco_EtLPJ6=zeros(numofyear,1);eco_PreciLPJ6=zeros(numofyear,1);
eco_RunoffObs7=zeros(numofyear,1);eco_RunoffLPJ7=zeros(numofyear,1);eco_EiObs7=zeros(numofyear,1);eco_EbObs7=zeros(numofyear,1);eco_EtObs7=zeros(numofyear,1);eco_EiLPJ7=zeros(numofyear,1);eco_EbLPJ7=zeros(numofyear,1);eco_EtLPJ7=zeros(numofyear,1);eco_PreciLPJ7=zeros(numofyear,1);
eco_RunoffObs8=zeros(numofyear,1);eco_RunoffLPJ8=zeros(numofyear,1);eco_EiObs8=zeros(numofyear,1);eco_EbObs8=zeros(numofyear,1);eco_EtObs8=zeros(numofyear,1);eco_EiLPJ8=zeros(numofyear,1);eco_EbLPJ8=zeros(numofyear,1);eco_EtLPJ8=zeros(numofyear,1);eco_PreciLPJ8=zeros(numofyear,1);
eco_RunoffObs9=zeros(numofyear,1);eco_RunoffLPJ9=zeros(numofyear,1);eco_EiObs9=zeros(numofyear,1);eco_EbObs9=zeros(numofyear,1);eco_EtObs9=zeros(numofyear,1);eco_EiLPJ9=zeros(numofyear,1);eco_EbLPJ9=zeros(numofyear,1);eco_EtLPJ9=zeros(numofyear,1);eco_PreciLPJ9=zeros(numofyear,1);
eco_RunoffObs10=zeros(numofyear,1);eco_RunoffLPJ10=zeros(numofyear,1);eco_EiObs10=zeros(numofyear,1);eco_EbObs10=zeros(numofyear,1);eco_EtObs10=zeros(numofyear,1);eco_EiLPJ10=zeros(numofyear,1);eco_EbLPJ10=zeros(numofyear,1);eco_EtLPJ10=zeros(numofyear,1);eco_PreciLPJ10=zeros(numofyear,1);

for year=1:1:numofyear
    
    for k=1:1:datanum

    lpjlon=RunoffFileDataAveage(k,1);
    lpjlat=RunoffFileDataAveage(k,2);
   
     %aggreate at 0.5 degree  
    
    %LPJ
    LPJRunoff=sum(LPJdata_Runoff((k-1)*115+year+startyear-1901,4:15)); 
    LPJEi=sum(LPJdata_intercep((k-1)*115+year+startyear-1901,4:15)); 
    LPJEb=sum(LPJdata_evap((k-1)*115+year+startyear-1901,4:15)); 
    LPJEt=sum(LPJdata_aet((k-1)*115+year+startyear-1901,4:15)); 
    LPJPreci=sum(LPJdata_Preci((k-1)*115+year+startyear-1901,4:15)); 
       
    %OBS
    %GRUN
    lonnum=floor((lpjlon-(-180))/0.5)+1;    
    latnum=floor((lpjlat-(-90))/0.5)+1; 
    if(isnan(DataGRUNRunoff(lonnum,latnum,1))) 
        continue;
     end
    temprunoff=DataGRUNRunoff(lonnum,latnum,(year-1)*12+1:(year-1)*12+12);
    temprunoff1(:)=temprunoff(1,1,:);
    Grunrunoff=sum(temprunoff1*daynumofmonth'); 
    %GLEAM
    GLEAMlatnum=floor((90-(lpjlat+0.125))/0.25)+1;
    GLEAMlonnum=floor(((lpjlon-0.125)-(-180))/0.25)+1;
    GleamEi=nanmean([data_GleamEi(GLEAMlatnum,GLEAMlonnum,year+startyear-1980),data_GleamEi(GLEAMlatnum,GLEAMlonnum+1,year+startyear-1980),data_GleamEi(GLEAMlatnum+1,GLEAMlonnum,year+startyear-1980),data_GleamEi(GLEAMlatnum+1,GLEAMlonnum+1,year+startyear-1980)]);
    GleamEb=nanmean([data_GleamEb(GLEAMlatnum,GLEAMlonnum,year+startyear-1980),data_GleamEb(GLEAMlatnum,GLEAMlonnum+1,year+startyear-1980),data_GleamEb(GLEAMlatnum+1,GLEAMlonnum,year+startyear-1980),data_GleamEb(GLEAMlatnum+1,GLEAMlonnum+1,year+startyear-1980)]);
    GleamEt=nanmean([data_GleamEt(GLEAMlatnum,GLEAMlonnum,year+startyear-1980),data_GleamEt(GLEAMlatnum,GLEAMlonnum+1,year+startyear-1980),data_GleamEt(GLEAMlatnum+1,GLEAMlonnum,year+startyear-1980),data_GleamEt(GLEAMlatnum+1,GLEAMlonnum+1,year+startyear-1980)]);
    
    LPJRunOffSeries(latnum,lonnum,year)=LPJRunoff;
    LPJEiSeries(latnum,lonnum,year)=LPJEi;
    LPJEbSeries(latnum,lonnum,year)=LPJEb;
    LPJEtSeries(latnum,lonnum,year)=LPJEt;
    LPJPreciSeries(latnum,lonnum,year)=LPJPreci;
    
    GRUNRunOffSeries(latnum,lonnum,year)=Grunrunoff; 
    GleamEiSeries(latnum,lonnum,year)=GleamEi;
    GleamEbSeries(latnum,lonnum,year)=GleamEb;
    GleamEtSeries(latnum,lonnum,year)=GleamEt;

  
    
    end

%% mask
for i=1:1:size(S1_x,1)
    lpjlat=S1_y(i);
    lpjlon=S1_x(i);
    eco_RunoffObs1(year)=eco_RunoffObs1(year)+GRUNRunOffSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_RunoffLPJ1(year)=eco_RunoffLPJ1(year)+LPJRunOffSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
  
    eco_EiObs1(year)=eco_EiObs1(year)+GleamEiSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EbObs1(year)=eco_EbObs1(year)+GleamEbSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EtObs1(year)=eco_EtObs1(year)+GleamEtSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EiLPJ1(year)=eco_EiLPJ1(year)+LPJEiSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EbLPJ1(year)=eco_EbLPJ1(year)+LPJEbSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EtLPJ1(year)=eco_EtLPJ1(year)+LPJEtSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_PreciLPJ1(year)=eco_PreciLPJ1(year)+LPJPreciSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
 
end
 
for i=1:1:size(S2_x,1)
    lpjlat=S2_y(i);
    lpjlon=S2_x(i);
    eco_RunoffObs2(year)=eco_RunoffObs2(year)+GRUNRunOffSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_RunoffLPJ2(year)=eco_RunoffLPJ2(year)+LPJRunOffSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;

    eco_EiObs2(year)=eco_EiObs2(year)+GleamEiSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EbObs2(year)=eco_EbObs2(year)+GleamEbSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EtObs2(year)=eco_EtObs2(year)+GleamEtSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EiLPJ2(year)=eco_EiLPJ2(year)+LPJEiSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EbLPJ2(year)=eco_EbLPJ2(year)+LPJEbSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EtLPJ2(year)=eco_EtLPJ2(year)+LPJEtSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_PreciLPJ2(year)=eco_PreciLPJ2(year)+LPJPreciSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
 
end
 
for i=1:1:size(S3_x,1)
    lpjlat=S3_y(i);
    lpjlon=S3_x(i);
    eco_RunoffObs3(year)=eco_RunoffObs3(year)+GRUNRunOffSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_RunoffLPJ3(year)=eco_RunoffLPJ3(year)+LPJRunOffSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    
    eco_EiObs3(year)=eco_EiObs3(year)+GleamEiSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EbObs3(year)=eco_EbObs3(year)+GleamEbSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EtObs3(year)=eco_EtObs3(year)+GleamEtSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EiLPJ3(year)=eco_EiLPJ3(year)+LPJEiSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EbLPJ3(year)=eco_EbLPJ3(year)+LPJEbSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EtLPJ3(year)=eco_EtLPJ3(year)+LPJEtSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_PreciLPJ3(year)=eco_PreciLPJ3(year)+LPJPreciSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
 

end
 
for i=1:1:size(S4_x,1)
    lpjlat=S4_y(i);
    lpjlon=S4_x(i);
    eco_RunoffObs4(year)=eco_RunoffObs4(year)+GRUNRunOffSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_RunoffLPJ4(year)=eco_RunoffLPJ4(year)+LPJRunOffSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    
    eco_EiObs4(year)=eco_EiObs4(year)+GleamEiSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EbObs4(year)=eco_EbObs4(year)+GleamEbSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EtObs4(year)=eco_EtObs4(year)+GleamEtSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EiLPJ4(year)=eco_EiLPJ4(year)+LPJEiSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EbLPJ4(year)=eco_EbLPJ4(year)+LPJEbSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EtLPJ4(year)=eco_EtLPJ4(year)+LPJEtSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_PreciLPJ4(year)=eco_PreciLPJ4(year)+LPJPreciSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
 

end       
for i=1:1:size(S5_x,1)
    lpjlat=S5_y(i);
    lpjlon=S5_x(i);
    eco_RunoffObs5(year)=eco_RunoffObs5(year)+GRUNRunOffSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_RunoffLPJ5(year)=eco_RunoffLPJ5(year)+LPJRunOffSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;

      
    eco_EiObs5(year)=eco_EiObs5(year)+GleamEiSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EbObs5(year)=eco_EbObs5(year)+GleamEbSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EtObs5(year)=eco_EtObs5(year)+GleamEtSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EiLPJ5(year)=eco_EiLPJ5(year)+LPJEiSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EbLPJ5(year)=eco_EbLPJ5(year)+LPJEbSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EtLPJ5(year)=eco_EtLPJ5(year)+LPJEtSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_PreciLPJ5(year)=eco_PreciLPJ5(year)+LPJPreciSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
 

end   
for i=1:1:size(S6_x,1)
    lpjlat=S6_y(i);
    lpjlon=S6_x(i);
     eco_RunoffObs6(year)= eco_RunoffObs6(year)+GRUNRunOffSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
     eco_RunoffLPJ6(year)=eco_RunoffLPJ6(year)+LPJRunOffSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;

    eco_EiObs6(year)=eco_EiObs6(year)+GleamEiSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EbObs6(year)=eco_EbObs6(year)+GleamEbSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EtObs6(year)=eco_EtObs6(year)+GleamEtSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EiLPJ6(year)=eco_EiLPJ6(year)+LPJEiSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EbLPJ6(year)=eco_EbLPJ6(year)+LPJEbSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EtLPJ6(year)=eco_EtLPJ6(year)+LPJEtSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_PreciLPJ6(year)=eco_PreciLPJ6(year)+LPJPreciSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
 


end   
for i=1:1:size(S7_x,1)
    lpjlat=S7_y(i);
    lpjlon=S7_x(i);
    eco_RunoffObs7(year)=eco_RunoffObs7(year)+GRUNRunOffSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_RunoffLPJ7(year)=eco_RunoffLPJ7(year)+LPJRunOffSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;

    eco_EiObs7(year)=eco_EiObs7(year)+GleamEiSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EbObs7(year)=eco_EbObs7(year)+GleamEbSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EtObs7(year)=eco_EtObs7(year)+GleamEtSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EiLPJ7(year)=eco_EiLPJ7(year)+LPJEiSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EbLPJ7(year)=eco_EbLPJ7(year)+LPJEbSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EtLPJ7(year)=eco_EtLPJ7(year)+LPJEtSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_PreciLPJ7(year)=eco_PreciLPJ7(year)+LPJPreciSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
 


end   
for i=1:1:size(S8_x,1)
    lpjlat=S8_y(i);
    lpjlon=S8_x(i);
    eco_RunoffObs8(year)=eco_RunoffObs8(year)+GRUNRunOffSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_RunoffLPJ8(year)=eco_RunoffLPJ8(year)+LPJRunOffSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;


    eco_EiObs8(year)=eco_EiObs8(year)+GleamEiSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EbObs8(year)=eco_EbObs8(year)+GleamEbSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EtObs8(year)=eco_EtObs8(year)+GleamEtSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EiLPJ8(year)=eco_EiLPJ8(year)+LPJEiSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EbLPJ8(year)=eco_EbLPJ8(year)+LPJEbSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EtLPJ8(year)=eco_EtLPJ8(year)+LPJEtSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_PreciLPJ8(year)=eco_PreciLPJ8(year)+LPJPreciSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
 
end   


for i=1:1:size(S9_x,1)
    lpjlat=S9_y(i);
    lpjlon=S9_x(i);
    eco_RunoffObs9(year)=eco_RunoffObs9(year)+GRUNRunOffSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_RunoffLPJ9(year)=eco_RunoffLPJ9(year)+LPJRunOffSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;


    eco_EiObs9(year)=eco_EiObs9(year)+GleamEiSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EbObs9(year)=eco_EbObs9(year)+GleamEbSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EtObs9(year)=eco_EtObs9(year)+GleamEtSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EiLPJ9(year)=eco_EiLPJ9(year)+LPJEiSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EbLPJ9(year)=eco_EbLPJ9(year)+LPJEbSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EtLPJ9(year)=eco_EtLPJ9(year)+LPJEtSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_PreciLPJ9(year)=eco_PreciLPJ9(year)+LPJPreciSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
 

end 
for i=1:1:size(S10_x,1)
    lpjlat=S10_y(i);
    lpjlon=S10_x(i);
    eco_RunoffObs10(year)=eco_RunoffObs10(year)+GRUNRunOffSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_RunoffLPJ10(year)=eco_RunoffLPJ10(year)+LPJRunOffSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;


    eco_EiObs10(year)=eco_EiObs10(year)+GleamEiSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EbObs10(year)=eco_EbObs10(year)+GleamEbSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EtObs10(year)=eco_EtObs10(year)+GleamEtSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EiLPJ10(year)=eco_EiLPJ10(year)+LPJEiSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EbLPJ10(year)=eco_EbLPJ10(year)+LPJEbSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_EtLPJ10(year)=eco_EtLPJ10(year)+LPJEtSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco_PreciLPJ10(year)=eco_PreciLPJ10(year)+LPJPreciSeries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
 

end 
      
end

%% draw
titlestr={'Amazon','Danube','MacKenzie','Mississippi','Murray','Yenisei','Congo','Nile','Ganges','Yangtze'};
data_RunoffObs=[eco_RunoffObs1';eco_RunoffObs2';eco_RunoffObs3';eco_RunoffObs4';eco_RunoffObs5';eco_RunoffObs6';eco_RunoffObs7';eco_RunoffObs8';eco_RunoffObs9';eco_RunoffObs10'];
data_RunoffLPJ=[eco_RunoffLPJ1';eco_RunoffLPJ2';eco_RunoffLPJ3';eco_RunoffLPJ4';eco_RunoffLPJ5';eco_RunoffLPJ6';eco_RunoffLPJ7';eco_RunoffLPJ8';eco_RunoffLPJ9';eco_RunoffLPJ10'];

data_EiObs=[eco_EiObs1';eco_EiObs2';eco_EiObs3';eco_EiObs4';eco_EiObs5';eco_EiObs6';eco_EiObs7';eco_EiObs8';eco_EiObs9';eco_EiObs10'];
data_EiLPJ=[eco_EiLPJ1';eco_EiLPJ2';eco_EiLPJ3';eco_EiLPJ4';eco_EiLPJ5';eco_EiLPJ6';eco_EiLPJ7';eco_EiLPJ8';eco_EiLPJ9';eco_EiLPJ10'];

data_EbObs=[eco_EbObs1';eco_EbObs2';eco_EbObs3';eco_EbObs4';eco_EbObs5';eco_EbObs6';eco_EbObs7';eco_EbObs8';eco_EbObs9';eco_EbObs10'];
data_EbLPJ=[eco_EbLPJ1';eco_EbLPJ2';eco_EbLPJ3';eco_EbLPJ4';eco_EbLPJ5';eco_EbLPJ6';eco_EbLPJ7';eco_EbLPJ8';eco_EbLPJ9';eco_EbLPJ10'];

data_EtObs=[eco_EtObs1';eco_EtObs2';eco_EtObs3';eco_EtObs4';eco_EtObs5';eco_EtObs6';eco_EtObs7';eco_EtObs8';eco_EtObs9';eco_EtObs10'];
data_EtLPJ=[eco_EtLPJ1';eco_EtLPJ2';eco_EtLPJ3';eco_EtLPJ4';eco_EtLPJ5';eco_EtLPJ6';eco_EtLPJ7';eco_EtLPJ8';eco_EtLPJ9';eco_EtLPJ10'];

data_PreciLPJ=[eco_PreciLPJ1';eco_PreciLPJ2';eco_PreciLPJ3';eco_PreciLPJ4';eco_PreciLPJ5';eco_PreciLPJ6';eco_PreciLPJ7';eco_PreciLPJ8';eco_PreciLPJ9';eco_PreciLPJ10'];

data_RunoffObs=data_RunoffObs./data_PreciLPJ*100;
data_RunoffLPJ=data_RunoffLPJ./data_PreciLPJ*100;

data_EiObs=data_EiObs./data_PreciLPJ*100;
data_EiLPJ=data_EiLPJ./data_PreciLPJ*100;

data_EbObs=data_EbObs./data_PreciLPJ*100;
data_EbLPJ=data_EbLPJ./data_PreciLPJ*100;


data_EtObs=data_EtObs./data_PreciLPJ*100;
data_EtLPJ=data_EtLPJ./data_PreciLPJ*100;
titlestr={'Amazon','Danube','MacKenzie','Mississippi','Murray','Yenisei','Congo','Nile','Ganges','Yangtze'};
figure %生成图窗
%set(gcf,'unit','centimeters','position',[5 0 17 15]);
set(gcf,'position',[500 0 800 1200]);%50，300这两个参数不影响画布大小，其作用是确定画出来的图在电脑屏幕上的显示位置，改为0，0则图显示在电脑左下角。600，200确定画布宽高，600为宽，高200，画出的图为600x200的长方形。
%for i=1:1:10
%subplot(5,2,i);
[ha, pos] = tight_subplot(5,2,[.02 .05],[.1 .01],[.1 .01]);

%[ha,pos]=tight_subplot(Nh,Nw,gap,marg_h,marg_w)
% ha 是坐标轴句柄，pos是每个坐标轴的原点与长宽
% Nh,Nw 可以认为是几行几列
% gap是子图的纵向和横向间距，gap(1)为纵向，gap(2)为横向
% marg_h是图件与上下边缘的距离，marg_h(1)为距下边缘的距离，marg_h(2)是距上边缘的距离
% marg_w 是图件与左右边缘的距离，marg_w(1)为距左边缘的距离，marg_w(2)是距右边缘的距离。


 for i=1:1:10; 
    axes(ha(i));
    box on;

mean_RunoffObs=mean(data_RunoffObs(i,:));
mean_RunoffLPJ=mean(data_RunoffLPJ(i,:));

mean_EiObs=mean(data_EiObs(i,:));
mean_EiLPJ=mean(data_EiLPJ(i,:));

mean_EbObs=mean(data_EbObs(i,:));
mean_EbLPJ=mean(data_EbLPJ(i,:));

mean_EtObs=mean(data_EtObs(i,:));
mean_EtLPJ=mean(data_EtLPJ(i,:));

std_RunoffObs=std(data_RunoffObs(i,:));
std_RunoffLPJ=std(data_RunoffLPJ(i,:));

std_EiObs=std(data_EiObs(i,:));
std_EiLPJ=std(data_EiLPJ(i,:));

std_EbObs=std(data_EbObs(i,:));
std_EbLPJ=std(data_EbLPJ(i,:));

std_EtObs=std(data_EtObs(i,:));
std_EtLPJ=std(data_EtLPJ(i,:));

x=1:4;
y = [mean_RunoffLPJ mean_RunoffObs ; mean_EiLPJ  mean_EiObs; mean_EbLPJ mean_EbObs; mean_EtLPJ mean_EtObs];
ystd=[std_RunoffLPJ std_RunoffObs ; std_EiLPJ  std_EiObs; std_EbLPJ std_EbObs; std_EtLPJ std_EtObs];
bar(x,y);
hold on

er = errorbar([x'-0.15,x'+0.15],y,ystd, 'k', 'Linestyle', 'None');    

title(titlestr{i},'position',[2.5,80]);
ylim([0 100]);

set(gca,'XTicklabel',[]);
if(i>=9)
set(gca,'XTicklabel',{'Runoff', 'Interception', 'Evaporation', 'Transpiration'});
end
if(i==5)
ylabel('Percentage of Precipiation（%）'); %y轴坐标描述
end
if(i>=10)
legend('LPJ-GUESS','Reference data');  
legend('Orientation','horizontal')
legend('boxoff')
end
end
