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
LPJPrecifilename='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mrunoff8514ave.out';
fid = fopen(LPJPrecifilename,'r');
allText = textscan(fid,'%s','delimiter','\n');
numberOfLines = length(allText{1});
fclose(fid);
A=zeros(numberOfLines-1,14);
for INDEX = 2:numberOfLines
    str = char(allText{1,1}(INDEX));
    A(INDEX-1,:)=str2num(char(strsplit(str)));
end
datanum=size(A,1)

LPJPrecifilename='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mpreci8514ave.out';
fid = fopen(LPJPrecifilename,'r');
allText = textscan(fid,'%s','delimiter','\n');
numberOfLines = length(allText{1});
fclose(fid);
B=zeros(numberOfLines-1,14);
for INDEX = 2:numberOfLines
    str = char(allText{1,1}(INDEX));
    B(INDEX-1,:)=str2num(char(strsplit(str)));
end



%% 
%'Amazon','Danube','MacKenzie','Mississippi','Murray','Yenisei','Zaire','Nile','Ganges','Yangtze'
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


startyear=1985;
endyear=2014;
Grunstartyear=1902;
Grunendyear=2020;
Grunyearbound=[1980,2020];
daynumofmonth=[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
rownum=180/0.5;
colrum=360/0.5;
diff=zeros(rownum,colrum);
Grunrunoff=zeros(rownum,colrum,12);
lpjrunoff=zeros(rownum,colrum,12);
lpjpreci=zeros(rownum,colrum,12);
eco1=zeros(12,1);
eco2=zeros(12,1);
eco3=zeros(12,1);
eco4=zeros(12,1);
eco5=zeros(12,1);
eco6=zeros(12,1);
eco7=zeros(12,1);
eco8=zeros(12,1);
eco9=zeros(12,1);
eco10=zeros(12,1);

eco1_1=zeros(12,1);
eco2_1=zeros(12,1);
eco3_1=zeros(12,1);
eco4_1=zeros(12,1);
eco5_1=zeros(12,1);
eco6_1=zeros(12,1);
eco7_1=zeros(12,1);
eco8_1=zeros(12,1);
eco9_1=zeros(12,1);
eco10_1=zeros(12,1);

eco1_2=zeros(12,1);
eco2_2=zeros(12,1);
eco3_2=zeros(12,1);
eco4_2=zeros(12,1);
eco5_2=zeros(12,1);
eco6_2=zeros(12,1);
eco7_2=zeros(12,1);
eco8_2=zeros(12,1);
eco9_2=zeros(12,1);
eco10_2=zeros(12,1);

for month=1:1:12
%% read tif name list

%      Runoff
%            Size:       720x360x1356
%            Dimensions: X,Y,time 
     Runoff(find(isnan(Runoff)==1))=0;
     monthlyRunoff=mean(Runoff(:,:,(startyear-Grunstartyear)*12+month:12:(endyear-Grunstartyear)*12+month),3)*daynumofmonth(month);             




%% diff

for k=1:1:datanum
    lpjlon=A(k,1);
    lpjlat=A(k,2);% have added three times lat/lon
    lonnum=floor((lpjlon-(-180))/0.5)+1;    
    latnum=floor((lpjlat-(-90))/0.5)+1;    
     %aggreate at 0.5 degree
    averageRunoff=monthlyRunoff(lonnum,latnum);
    %diff(latnum,lonnum)=A(k,month+2)-averageRunoff;
    Grunrunoff(latnum,lonnum,month)=averageRunoff;
    lpjrunoff(latnum,lonnum,month)=A(k,month+2);
    lpjpreci(latnum,lonnum,month)=B(k,month+2);
end

%% mask
toc



for i=1:1:size(S1_x,1)
    lpjlat=S1_y(i);
    lpjlon=S1_x(i);
    eco1(month)=eco1(month)+Grunrunoff(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
    eco1_1(month)=eco1_1(month)+lpjrunoff(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
    eco1_2(month)=eco1_2(month)+lpjpreci(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
end
 toc
for i=1:1:size(S2_x,1)
    lpjlat=S2_y(i);
    lpjlon=S2_x(i);
    eco2(month)=eco2(month)+Grunrunoff(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
    eco2_1(month)=eco2_1(month)+lpjrunoff(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
    eco2_2(month)=eco2_2(month)+lpjpreci(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
end
 toc
for i=1:1:size(S3_x,1)
    lpjlat=S3_y(i);
    lpjlon=S3_x(i);
    eco3(month)=eco3(month)+Grunrunoff(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
    eco3_1(month)=eco3_1(month)+lpjrunoff(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
    eco3_2(month)=eco3_2(month)+lpjpreci(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
end
 toc
for i=1:1:size(S4_x,1)
    lpjlat=S4_y(i);
    lpjlon=S4_x(i);
    eco4(month)=eco4(month)+Grunrunoff(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
    eco4_1(month)=eco4_1(month)+lpjrunoff(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
    eco4_2(month)=eco4_2(month)+lpjpreci(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
end       
for i=1:1:size(S5_x,1)
    lpjlat=S5_y(i);
    lpjlon=S5_x(i);
    eco5(month)=eco5(month)+Grunrunoff(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
    eco5_1(month)=eco5_1(month)+lpjrunoff(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
    eco5_2(month)=eco5_2(month)+lpjpreci(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
end   
for i=1:1:size(S6_x,1)
    lpjlat=S6_y(i);
    lpjlon=S6_x(i);
     eco6(month)=eco6(month)+Grunrunoff(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
     eco6_1(month)=eco6_1(month)+lpjrunoff(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
     eco6_2(month)=eco6_2(month)+lpjpreci(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
end   
for i=1:1:size(S7_x,1)
    lpjlat=S7_y(i);
    lpjlon=S7_x(i);
     eco7(month)=eco7(month)+Grunrunoff(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
     eco7_1(month)=eco7_1(month)+lpjrunoff(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
     eco7_2(month)=eco7_2(month)+lpjpreci(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
end   
for i=1:1:size(S8_x,1)
    lpjlat=S8_y(i);
    lpjlon=S8_x(i);
    eco8(month)=eco8(month)+Grunrunoff(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
    eco8_1(month)=eco8_1(month)+lpjrunoff(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
    eco8_2(month)=eco8_2(month)+lpjpreci(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
end   
for i=1:1:size(S9_x,1)
    lpjlat=S9_y(i);
    lpjlon=S9_x(i);
    eco9(month)=eco9(month)+Grunrunoff(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
    eco9_1(month)=eco9_1(month)+lpjrunoff(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
    eco9_2(month)=eco9_2(month)+lpjpreci(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
end 
for i=1:1:size(S10_x,1)
    lpjlat=S10_y(i);
    lpjlon=S10_x(i);
    eco10(month)=eco10(month)+Grunrunoff(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
    eco10_1(month)=eco10_1(month)+lpjrunoff(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
    eco10_2(month)=eco10_2(month)+lpjpreci(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,month)*cellarea(lpjlat)/1e+12;
end 

toc      
    



end

%Amazon
% 	Danube
% 	MacKenzie
% 	Mississippi
% 	Murray
% 	Yenisei
% 	Zaire	
%     Nile

%'Amazon','Danube','MacKenzie','Mississippi','Murray','Yenisei','Zaire','Nile'
titlestr={'Amazon','Danube','MacKenzie','Mississippi','Murray','Yenisei','Congo','Nile','Ganges','Yangtze'};
data1=[eco1';eco2';eco3';eco4';eco5';eco6';eco7';eco8';eco9';eco10'];
data2=[eco1_1';eco2_1';eco3_1';eco4_1';eco5_1';eco6_1';eco7_1';eco8_1';eco9_1';eco10_1'];
data3=[eco1_2';eco2_2';eco3_2';eco4_2';eco5_2';eco6_2';eco7_2';eco8_2';eco9_2';eco10_2'];
for i=1:1:10
subplot(2,5,i);
x=1:1:12;%x轴上的数据，第一个值代表数据开始，第二个值代表间隔，第三个值代表终止
%plot(x,month_Runoff,'--ko',x,month_Runoff_lpj,'--k*'); %线性，颜色，标记
% h1=plot(x,data1(i,:),'-ko'); %线性，颜色，标记
% hold on;
% h2=plot(x,data2(i,:),'-ko'); %线性，颜色，标记
% set(h1, 'MarkerFaceColor', get(h1,'Color'));
%GRUN
b=bar(x,data3(i,:),0.4,'EdgeColor',[0,0.543,0.543],'LineWidth',1);
set(b,'FaceColor',[1 1 1]);
 hold on
plot(x,data1(i,:),'-o','Color',[0.255,0.412,0.88],'lineWidth',2);
 hold on
 %lpj
plot(x,data2(i,:),'--+','Color',[0.76,0.068,0.1944],'lineWidth',2);

axis([0,12.5,0,max(max(data3(i,:)),max(data2(i,:)))*1.2]);  %确定x轴与y轴框图大小
set(gca,'XTick',[1:1:12])
set(gca,'XTicklabel',{'J','F','M','A','M','J','J','A','S','O','N','D'}); %x轴范围1-6，间隔1
title(titlestr{i},'FontName','Helvetica','FontSize',15);
xlim([0 13]);
%set(gca,'YTicrk',[0:round(max(month_Et(:))/5):(max(month_Et(:))*1.2)]); %y轴范围0-700，间隔100
%set(gcf,'position',[0,0,200,200]); 
set(gcf,'unit','centimeters','position',[5 0 50 30])


if i==1
lg1=legend('CRUNCEP precipitation','GRUN','LPJ-GUESS');   %右上角标注
set(lg1,'Orientation','horizontal');
end

%xlabel('Month');  %x轴坐标描述
%ylabel('Runoff（mm/month）'); %y轴坐标描述
%saveas(1, 'D:\Program Files\PuTTY\monthlymean after 3.19 (with land use)\9AmazonBrazil', 'jpg');
end