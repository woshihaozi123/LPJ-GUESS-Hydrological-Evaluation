clc;
clear;

%% read Grun runoff
tic;
filename='D:\Program Files\PuTTY\GRUN_v1_GSWP3_WGS84_05_1902_2014.nc';
ncdisp(filename);                                    %展示文件信息
%提取变量                   
lon=double(ncread(filename,'X'));                   %读取经度范围和精度      
lat=double(ncread(filename,'Y'));                   %读取纬度范围和精度
time=double(ncread(filename,'time'));         %读取时间序列长度
Runoff=double(ncread(filename,'Runoff'));%提取变量


%% read lpjLai data
% LPJPrecifilename='D:\Program Files\PuTTY\monthlymean after 3.19 (with land use)\mrunoff.out';
% fid = fopen(LPJPrecifilename,'r');
% allText = textscan(fid,'%s','delimiter','\n');
% numberOfLines = length(allText{1});
% fclose(fid);
% A=zeros(numberOfLines-1,15);
% for INDEX = 2:numberOfLines
%     str = char(allText{1,1}(INDEX));
%     A(INDEX-1,:)=str2num(char(strsplit(str)));
% end

tic
filename='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mrunoff.out';
delimiterIn = ' ';                      %列分隔符
headerlinesIn = 1;                      %读取从第 headerlinesIn+1 行开始的数值数据
present=importdata(filename,delimiterIn,headerlinesIn);
A=present.data;                 %导出的1行以后的数据
%parameters=present02.textdata;          %导出的1行以前的数据，即元胞数组
toc


%% read lpjLai data
tic
LPJPrecifilename='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mrunoff8514ave.out';
fid = fopen(LPJPrecifilename,'r');
allText = textscan(fid,'%s','delimiter','\n');
numberOfLines = length(allText{1});
fclose(fid);
A1=zeros(numberOfLines-1,14);
for INDEX = 2:numberOfLines
    str = char(allText{1,1}(INDEX));
    A1(INDEX-1,:)=str2num(char(strsplit(str)));
end
datanum=size(A1,1)
toc

%% 
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



startyear=1902;% trend from the begining
endyear=2014;
Grunstartyear=1902;
Grunendyear=2020;
Grunyearbound=[1980,2020];
daynumofmonth=[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
yearseries=1:1:endyear-Grunstartyear+1;
numofyear=endyear-Grunstartyear+1;
rownum=180/0.5;
colrum=360/0.5;
diff=zeros(rownum,colrum);
Grunrunoffseries=zeros(rownum,colrum,numofyear);
lpjrunoffseries=zeros(rownum,colrum,numofyear); 
eco1=zeros(numofyear,1);
eco2=zeros(numofyear,1);
eco3=zeros(numofyear,1);
eco4=zeros(numofyear,1);
eco5=zeros(numofyear,1);
eco6=zeros(numofyear,1);
eco7=zeros(numofyear,1);
eco8=zeros(numofyear,1);
eco9=zeros(numofyear,1);
eco10=zeros(numofyear,1);

eco1_1=zeros(numofyear,1);
eco2_1=zeros(numofyear,1);
eco3_1=zeros(numofyear,1);
eco4_1=zeros(numofyear,1);
eco5_1=zeros(numofyear,1);
eco6_1=zeros(numofyear,1);
eco7_1=zeros(numofyear,1);
eco8_1=zeros(numofyear,1);
eco9_1=zeros(numofyear,1);
eco10_1=zeros(numofyear,1);

for year=1:1:numofyear
%% read tif name list

%      Runoff
%            Size:       720x360x1356
%            Dimensions: X,Y,time 
     %Runoff(find(isnan(Runoff)==1))=0;% NaN to 0
     %monthlyRunoff=mean(Runoff(:,:,(startyear-Grunstartyear)*12+month:12:(endyear-Grunstartyear)*12+month),3)*daynumofmonth(month);             
     
     


%% diff

for k=1:1:datanum

    lpjlon=A1(k,1);
    lpjlat=A1(k,2);% have added three times lat/lon
    lonnum=floor((lpjlon-(-180))/0.5)+1;    
    latnum=floor((lpjlat-(-90))/0.5)+1;    
     %aggreate at 0.5 degree  
     if(isnan(Runoff(lonnum,latnum,1))) 
        continue;
     end
    temprunoff=Runoff(lonnum,latnum,(year-1)*12+1:(year-1)*12+12);
    temprunoff1(:)=temprunoff(1,1,:);
    Grunrunoff=sum(temprunoff1*daynumofmonth');
  
    lpjrunoff=sum(A((k-1)*115+year+1,4:15));
     
     
     Grunrunoffseries(latnum,lonnum,year)=Grunrunoff;    
    
     lpjrunoffseries(latnum,lonnum,year)=lpjrunoff;
end

%% mask
toc


for i=1:1:size(S1_x,1)
    lpjlat=S1_y(i);
    lpjlon=S1_x(i);
    eco1(year)=eco1(year)+Grunrunoffseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco1_1(year)=eco1_1(year)+lpjrunoffseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
end
 toc
for i=1:1:size(S2_x,1)
    lpjlat=S2_y(i);
    lpjlon=S2_x(i);
    eco2(year)=eco2(year)+Grunrunoffseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco2_1(year)=eco2_1(year)+lpjrunoffseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
end
 toc
for i=1:1:size(S3_x,1)
    lpjlat=S3_y(i);
    lpjlon=S3_x(i);
    eco3(year)=eco3(year)+Grunrunoffseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco3_1(year)=eco3_1(year)+lpjrunoffseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
end
 toc
for i=1:1:size(S4_x,1)
    lpjlat=S4_y(i);
    lpjlon=S4_x(i);
    eco4(year)=eco4(year)+Grunrunoffseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco4_1(year)=eco4_1(year)+lpjrunoffseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
end       
for i=1:1:size(S5_x,1)
    lpjlat=S5_y(i);
    lpjlon=S5_x(i);
    eco5(year)=eco5(year)+Grunrunoffseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco5_1(year)=eco5_1(year)+lpjrunoffseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
end   
for i=1:1:size(S6_x,1)
    lpjlat=S6_y(i);
    lpjlon=S6_x(i);
     eco6(year)= eco6(year)+Grunrunoffseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
     eco6_1(year)=eco6_1(year)+lpjrunoffseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
end   
for i=1:1:size(S7_x,1)
    lpjlat=S7_y(i);
    lpjlon=S7_x(i);
     eco7(year)=eco7(year)+Grunrunoffseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
     eco7_1(year)=eco7_1(year)+lpjrunoffseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
end   
for i=1:1:size(S8_x,1)
    lpjlat=S8_y(i);
    lpjlon=S8_x(i);
    eco8(year)=eco8(year)+Grunrunoffseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco8_1(year)=eco8_1(year)+lpjrunoffseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
end   


for i=1:1:size(S9_x,1)
    lpjlat=S9_y(i);
    lpjlon=S9_x(i);
    eco9(year)=eco9(year)+Grunrunoffseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco9_1(year)=eco9_1(year)+lpjrunoffseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
end 
for i=1:1:size(S10_x,1)
    lpjlat=S10_y(i);
    lpjlon=S10_x(i);
    eco10(year)=eco10(year)+Grunrunoffseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco10_1(year)=eco10_1(year)+lpjrunoffseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
end 
toc      
end

%% draw
%'Amazon','Danube','MacKenzie','Mississippi','Murray','Yenisei','Zaire','Nile'
titlestr={'Amazon','Danube','MacKenzie','Mississippi','Murray','Yenisei','Congo','Nile','Ganges','Yangtze'};
data1=[eco1';eco2';eco3';eco4';eco5';eco6';eco7';eco8';eco9';eco10'];
data2=[eco1_1';eco2_1';eco3_1';eco4_1';eco5_1';eco6_1';eco7_1';eco8_1';eco9_1';eco10_1'];
for i=1:1:10
subplot(5,2,i);
x=1:1:numofyear;%x轴上的数据，第一个值代表数据开始，第二个值代表间隔，第三个值代表终止

% h1=plot(x,data1(i,:),'-ko'); %线性，颜色，标记
% hold on;
% h2=plot(x,data2(i,:),'-ko'); %线性，颜色，标记
% set(h1, 'MarkerFaceColor', get(h1,'Color'));

%GRUN
plot(x,data1(i,:),'-o','Color',[0.255,0.412,0.88],'lineWidth',2);
 hold on
 %lpj
plot(x,data2(i,:),'--+','Color',[0.76,0.068,0.1944],'lineWidth',2);

axis([0,12,0,max(max(data1(i,:)),max(data2(i,:)))*1.2]);  %确定x轴与y轴框图大小
xlim([1 numofyear]);
set(gca,'XTick',[1:20:numofyear])
set(gca,'xticklabel',[]);
if(i>=9)
set(gca,'XTicklabel',{'1902','1922','1942','1962','1982','2002','2014'})
end
if(i==5)
ylabel('Time series of annual runoff（km^3*yr^-1）','FontName','Helvetica','FontSize',15); %y轴坐标描述
end
%set(gca,'XTicklabel',{'J','F','M','A','M','J','J','A','S','O','N','D'}); %x轴范围1-6，间隔1
title(titlestr{i},'FontName','Helvetica','FontSize',15);
%xlim([1 12]);
%set(gca,'YTicrk',[0:round(max(month_Et(:))/5):(max(month_Et(:))*1.2)]); %y轴范围0-700，间隔100
%set(gcf,'position',[0,0,200,200]); 
set(gcf,'unit','centimeters','position',[5 0 30 30])
if i==1
lg1=legend('GRUN','LPJ-GUESS');   %右上角标注
set(lg1,'Orientation','horizontal','FontName','Helvetica','FontSize',15);
end
%legend('GRUN','LPJGuess');   %右上角标注
%xlabel('year');  %x轴坐标描述
%ylabel('Runoff（mm）'); %y轴坐标描述
end
