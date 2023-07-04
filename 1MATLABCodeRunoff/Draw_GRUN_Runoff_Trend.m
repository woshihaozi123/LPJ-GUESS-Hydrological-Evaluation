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
 
for i=1:1:size(S3_x,1)
    lpjlat=S3_y(i);
    lpjlon=S3_x(i);
    eco3(year)=eco3(year)+Grunrunoffseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco3_1(year)=eco3_1(year)+lpjrunoffseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
end
 
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
      
end

%% draw
titlestr={'Amazon','Danube','MacKenzie','Mississippi','Murray','Yenisei','Congo','Nile','Ganges','Yangtze'};
data1=[eco1';eco2';eco3';eco4';eco5';eco6';eco7';eco8';eco9';eco10'];
data2=[eco1_1';eco2_1';eco3_1';eco4_1';eco5_1';eco6_1';eco7_1';eco8_1';eco9_1';eco10_1'];
figure %生成图窗
set(gcf,'unit','centimeters','position',[5 0 17.4 15]);
%set(gcf,'position',[500 0 800 1200]);%50，300这两个参数不影响画布大小，其作用是确定画出来的图在电脑屏幕上的显示位置，改为0，0则图显示在电脑左下角。600，200确定画布宽高，600为宽，高200，画出的图为600x200的长方形。
%for i=1:1:10
%subplot(5,2,i);
[ha, pos] = tight_subplot(5,2,[.01 .05],[.05 .01],[.1 .01]);

%[ha,pos]=tight_subplot(Nh,Nw,gap,marg_h,marg_w)
% ha 是坐标轴句柄，pos是每个坐标轴的原点与长宽
% Nh,Nw 可以认为是几行几列
% gap是子图的纵向和横向间距，gap(1)为纵向，gap(2)为横向
% marg_h是图件与上下边缘的距离，marg_h(1)为距下边缘的距离，marg_h(2)是距上边缘的距离
% marg_w 是图件与左右边缘的距离，marg_w(1)为距左边缘的距离，marg_w(2)是距右边缘的距离。

index=zeros(10,4);
x=1:1:numofyear;
 for i=1:1:10; 
    axes(ha(i));
    box on;
%GRUN
plot(x,data1(i,:),'-','Color',[0.255,0.412,0.88],'lineWidth',0.5);
hold on
%lpj
%plot(x,data2(i,:),'-','Color',[0.76,0.068,0.1944],'lineWidth',0.5);
datain=[x',data1(i,:)'];
[taub tau h sig Z S sigma sen n senplot CIlower CIupper D Dall C3]=ktaub(datain, 0.05, 0);
hold on
        %generate points to represent median slope
        %zero time for the calculation is the first time point
        vv = median(datain(:,2));
        
        middata = datain(round(length(datain)/2),1);
        slope = vv + sen*(datain(:,1)-middata);
        senplot = [datain(:,1) slope];
        
        %plot(datain(:,1),datain(:,2),'o')
        plot(datain(:,1),slope,'-');
        
        % add confidence intervals
        slope = vv + CIlower*(datain(:,1)-middata);
        plot(datain(:,1),slope,'--');
        
        slope = vv + CIupper*(datain(:,1)-middata);
        plot(datain(:,1),slope,'--');
        if sig<=0.01
            sigstr='Sig<0.01';
        elseif sig>=0.01&&sig<=0.05
            sigstr='Sig<0.05'
        else 
            sigstr= ['Sig=', num2str(roundn(sig,-2))];
        end
        strings={            
         sigstr;
       % ['Trend:', num2str(roundn(sen,-2)),'km^3/yr(',num2str(roundn(100*sen./mean(data2(i,:)),-1)),'%)'];
       ['Trend=', num2str(roundn(sen,-2)),'km^3*yr^-1'];
        };
    index(i,1)= i;
    index(i,2)=sig;
    index(i,3)=sen;
    index(i,4)=mean(data1(i,:));
%annotation('textbox',[0.45*(1+mod(i+1,2)),1.1-0.2*(1+floor((i-1)/2)),0.1,0.1],'LineStyle','-','LineWidth',0.5,'String',strings,'FitBoxToText','on','verticalalignment','top')
annotation('textbox','LineStyle','-','LineWidth',0.5,'String',strings,'Position',pos{i},'FitBoxToText','on','Vert','top')


axis([1,numofyear,0.9*min(data1(i,:)),max(data1(i,:))*1.2]);  %确定x轴与y轴框图大小
title(titlestr{i},'position',[numofyear/2,max(data1(i,:))*1.05],'FontName','Helvetica','FontSize',15);
xlim([1 numofyear]);
yticks('auto')
set(gca,'XTick',[1:20:numofyear]);
set(gca,'xticklabel',[]);

if(i>=9)
set(gca,'XTicklabel',{'1902','1922','1942','1962','1982','2002','2014'});
end
if(i==5)
ylabel('Runoff（km^3*yr^-1）','FontName','Helvetica','FontSize',15); %y轴坐标描述
end
%set(gca,'XTicklabel',{'J','F','M','A','M','J','J','A','S','O','N','D'}); %x轴范围1-6，间隔1

%xlim([1 12]);
%set(gca,'YTicrk',[0:round(max(month_Et(:))/5):(max(month_Et(:))*1.2)]); %y轴范围0-700，间隔100

%legend('GRUN','LPJGuess');   %右上角标注
%xlabel('year');  %x轴坐标描述
%ylabel('Runoff（mm）'); %y轴坐标描述
end
