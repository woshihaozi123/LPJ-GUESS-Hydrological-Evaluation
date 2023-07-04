%precipiation trend 
clc;
clear;

GSWP3FilePath='G:\LPJGUESSHydrologyBalanceCheck\5Precipiation\GSWP3\yearlymean\pr_gswp3_1901_2010yearlymean.nc4';
ncdisp(GSWP3FilePath);   
% Dimensions:
%            lon  = 720
%            lat  = 360
%            time = 110  
ncdisp(GSWP3FilePath);                                   %Display File Information                 
lon=double(ncread(GSWP3FilePath,'lon'));                 %Read the longitude range and accuracy      
lat=double(ncread(GSWP3FilePath,'lat'));                 %Read the latitude range and accuracy
time=double(ncread(GSWP3FilePath,'time'));               %Read the time range and accuracy
GSWP3preci=double(ncread(GSWP3FilePath,'pr'));           %Read the Runoff range and accuracy

missing_value = 1.000000020040877e+20;

%%
tic
filename='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mpreci.out';
delimiterIn = ' ';                      %列分隔符
headerlinesIn = 1;                      %读取从第 headerlinesIn+1 行开始的数值数据
present=importdata(filename,delimiterIn,headerlinesIn);
A=present.data;                 %导出的1行以后的数据
%parameters=present02.textdata;          %导出的1行以前的数据，即元胞数组

%% read lpjLai data
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
datanum=size(A1,1);


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



startyear=1901;% trend from the begining
endyear=2010;



daynumofmonth=[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
numofyear=endyear-startyear+1;
yearseries=1:1:numofyear;

rownum=180/0.5;
colrum=360/0.5;
diff=zeros(rownum,colrum);
GSWP3preciseries=zeros(rownum,colrum,numofyear);
lpjpreciseries=zeros(rownum,colrum,numofyear); 

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
 
for k=1:1:datanum

    lpjlon=A1(k,1);
    lpjlat=A1(k,2);
    lonnum=floor((lpjlon-(-180))/0.5)+1;    
    latnum=floor((lpjlat-(-90))/0.5)+1;    

     if(isnan(GSWP3preci(lonnum,latnum,year))||GSWP3preci(lonnum,latnum,year)>=missing_value) 
        continue;
     end
  
    GSWP3preciseries(latnum,lonnum,year)=GSWP3preci(lonnum,latnum,year);      
    lpjpreciseries(latnum,lonnum,year)=sum(A((k-1)*115+year,4:15));
end

%% mask

for i=1:1:size(S1_x,1)
    lpjlat=S1_y(i);
    lpjlon=S1_x(i);
    eco1(year)=eco1(year)+GSWP3preciseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco1_1(year)=eco1_1(year)+lpjpreciseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
end
 
for i=1:1:size(S2_x,1)
    lpjlat=S2_y(i);
    lpjlon=S2_x(i);
    eco2(year)=eco2(year)+GSWP3preciseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco2_1(year)=eco2_1(year)+lpjpreciseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
end
 
for i=1:1:size(S3_x,1)
    lpjlat=S3_y(i);
    lpjlon=S3_x(i);
    eco3(year)=eco3(year)+GSWP3preciseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco3_1(year)=eco3_1(year)+lpjpreciseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
end
 
for i=1:1:size(S4_x,1)
    lpjlat=S4_y(i);
    lpjlon=S4_x(i);
    eco4(year)=eco4(year)+GSWP3preciseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco4_1(year)=eco4_1(year)+lpjpreciseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
end       
for i=1:1:size(S5_x,1)
    lpjlat=S5_y(i);
    lpjlon=S5_x(i);
    eco5(year)=eco5(year)+GSWP3preciseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco5_1(year)=eco5_1(year)+lpjpreciseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
end   
for i=1:1:size(S6_x,1)
    lpjlat=S6_y(i);
    lpjlon=S6_x(i);
     eco6(year)= eco6(year)+GSWP3preciseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
     eco6_1(year)=eco6_1(year)+lpjpreciseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
end   
for i=1:1:size(S7_x,1)
    lpjlat=S7_y(i);
    lpjlon=S7_x(i);
     eco7(year)=eco7(year)+GSWP3preciseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
     eco7_1(year)=eco7_1(year)+lpjpreciseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
end   
for i=1:1:size(S8_x,1)
    lpjlat=S8_y(i);
    lpjlon=S8_x(i);
    eco8(year)=eco8(year)+GSWP3preciseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco8_1(year)=eco8_1(year)+lpjpreciseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
end   


for i=1:1:size(S9_x,1)
    lpjlat=S9_y(i);
    lpjlon=S9_x(i);
    eco9(year)=eco9(year)+GSWP3preciseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco9_1(year)=eco9_1(year)+lpjpreciseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
end 
for i=1:1:size(S10_x,1)
    lpjlat=S10_y(i);
    lpjlon=S10_x(i);
    eco10(year)=eco10(year)+GSWP3preciseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
    eco10_1(year)=eco10_1(year)+lpjpreciseries(floor((lpjlat-(-90))/0.5)+1,floor((lpjlon-(-180))/0.5)+1,year)*cellarea(lpjlat)/1e+12;
end 
      
end

%% draw
titlestr={'Amazon','Danube','MacKenzie','Mississippi','Murray','Yenisei','Congo','Nile','Ganges','Yangtze'};
data1=[eco1';eco2';eco3';eco4';eco5';eco6';eco7';eco8';eco9';eco10'];
data2=[eco1_1';eco2_1';eco3_1';eco4_1';eco5_1';eco6_1';eco7_1';eco8_1';eco9_1';eco10_1'];
figure %生成图窗
set(gcf,'unit','centimeters','position',[5 0 17.4 20]);
%set(gcf,'position',[500 0 800 1200]);%50，300这两个参数不影响画布大小，其作用是确定画出来的图在电脑屏幕上的显示位置，改为0，0则图显示在电脑左下角。600，200确定画布宽高，600为宽，高200，画出的图为600x200的长方形。
%for i=1:1:10
%subplot(5,2,i);
[ha, pos] = tight_subplot(5,2,[.01 .05],[.08 .02],[.05 .01]);

%[ha,pos]=tight_subplot(Nh,Nw,gap,marg_h,marg_w)
% ha 是坐标轴句柄，pos是每个坐标轴的原点与长宽
% Nh,Nw 可以认为是几行几列
% gap是子图的纵向和横向间距，gap(1)为纵向，gap(2)为横向
% marg_h是图件与上下边缘的距离，marg_h(1)为距下边缘的距离，marg_h(2)是距上边缘的距离
% marg_w 是图件与左右边缘的距离，marg_w(1)为距左边缘的距离，marg_w(2)是距右边缘的距离。

index_L=zeros(10,4);
index_G=zeros(10,4);
x=1:1:numofyear;
 for i=1:1:10; 
    axes(ha(i));
    box on;
%GSWP3
plot(x,data1(i,:),'-','Color',[0.255,0.412,0.88],'lineWidth',1);
hold on

datain_GSWP3=[x',data1(i,:)'];
[taub1 tau1 h1 sig1 Z1 S1 sigma1 sen1 n1 senplot1 CIlower1 CIupper1 D1 Dall1 C31]=ktaub(datain_GSWP3, 0.05, 0);
hold on
        %generate points to represent median slope
        %zero time for the calculation is the first time point
        vv = median(datain_GSWP3(:,2));
        
        middata = datain_GSWP3(round(length(datain_GSWP3)/2),1);
        slope = vv + sen1*(datain_GSWP3(:,1)-middata);
        senplot1 = [datain_GSWP3(:,1) slope];
        
        %plot(datain(:,1),datain(:,2),'o')
        plot(datain_GSWP3(:,1),slope,'-');
        
        % add confidence intervals
        slope = vv + CIlower1*(datain_GSWP3(:,1)-middata);
        plot(datain_GSWP3(:,1),slope,'--');
        
        slope = vv + CIupper1*(datain_GSWP3(:,1)-middata);
        plot(datain_GSWP3(:,1),slope,'--');
        if sig1<=0.01
            sigstr_G='Sig_G<0.01';
        elseif sig1>=0.01&&sig1<=0.05
            sigstr_G='Sig_G<0.05';
        else 
            sigstr_G= ['Sig_G=', num2str(roundn(sig1,-2))];
        end
%         strings={            
%        %['Trend:', num2str(roundn(sen,-2)),'km^3/yr(',num2str(roundn(100*sen./mean(data2(i,:)),-1)),'%)'];
%        [sigstr_G,'Trend_G=', num2str(roundn(sen,-2)),'km^3*yr^-1'];
%         };
    index_G(i,1)= i;
    index_G(i,2)=sig1;
    index_G(i,3)=sen1;
    index_G(i,4)=mean(data1(i,:));
    
    
%annotation('textbox',[0.45*(1+mod(i+1,2)),1.1-0.2*(1+floor((i-1)/2)),0.1,0.1],'LineStyle','-','LineWidth',0.5,'String',strings,'FitBoxToText','on','verticalalignment','top')
%annotation('textbox','LineStyle','-','LineWidth',0.5,'String',strings,'Position',pos{i},'FitBoxToText','on','Vert','top')
hold on
%lpj
plot(x,data2(i,:),'-','Color',[0.76,0.068,0.1944],'lineWidth',1);
datain_LPJ=[x',data2(i,:)'];
[taub2 tau2 h2 sig2 Z2 S2 sigma2 sen2 n2 senplot2 CIlower2 CIupper2 D2 Dall2 C32]=ktaub(datain_LPJ, 0.05, 0);
hold on
        %generate points to represent median slope
        %zero time for the calculation is the first time point
        vv = median(datain_LPJ(:,2));
        
        middata = datain_LPJ(round(length(datain_LPJ)/2),1);
        slope = vv + sen2*(datain_LPJ(:,1)-middata);
        senplot2 = [datain_LPJ(:,1) slope];
        
        %plot(datain(:,1),datain(:,2),'o')
        plot(datain_LPJ(:,1),slope,'-');
        
        % add confidence intervals
        slope = vv + CIlower2*(datain_LPJ(:,1)-middata);
        plot(datain_LPJ(:,1),slope,'--');
        
        slope = vv + CIupper2*(datain_LPJ(:,1)-middata);
        plot(datain_LPJ(:,1),slope,'--');
        if sig2<=0.01
            sigstr_L='Sig_L<0.01';
        elseif sig2>=0.01&&sig2<=0.05
            sigstr_L='Sig_L<0.05';
        else 
            sigstr_L= ['Sig_L=', num2str(roundn(sig2,-2))];
        end
        strings={            
        % ['Trend:', num2str(roundn(sen,-2)),'km^3/yr(',num2str(roundn(100*sen./mean(data2(i,:)),-1)),'%)'];
        [sigstr_G,', Trend_G=', num2str(roundn(sen1,-2)),'km^3*yr^-1'];
        [sigstr_L,', Trend_L=', num2str(roundn(sen2,-2)),'km^3*yr^-1'];
      
        };
    index_L(i,1)= i;
    index_L(i,2)=sig2;
    index_L(i,3)=sen2;
    index_L(i,4)=mean(data2(i,:));
    
hold on  
%annotation('textbox',[0.45*(1+mod(i+1,2)),1.1-0.2*(1+floor((i-1)/2)),0.1,0.1],'LineStyle','-','LineWidth',0.5,'String',strings,'FitBoxToText','on','verticalalignment','top')
annotation('textbox','LineStyle','-','LineWidth',0.5,'String',strings,'Position',pos{i},'FitBoxToText','on','Vert','top','FontSize',10)


axis([1,numofyear,0.9*min(min(data1(i,:)),min(data2(i,:))),max(max(data1(i,:)),max(data2(i,:)))*1.3]);  %确定x轴与y轴框图大小
title(titlestr{i},'position',[numofyear/2,max(max(data1(i,:)),max(data2(i,:)))*1.05],'FontName','Helvetica','FontSize',15);
xlim([1 numofyear]);
yticks('auto')
set(gca,'XTick',[1:20:numofyear]);
set(gca,'xticklabel',[]);

if(i>=9)
set(gca,'XTicklabel',{'1901','1921','1941','1961','1981','2001','2010'});
end
if(i==5)
ylabel('Precipitation（km^3*yr^-1）','FontName','Helvetica','FontSize',15); %y轴坐标描述
end
if(i==10)
lg1=legend('GSWP3','LPJ-GUESS');   %右上角标注
set(lg1,'Orientation','horizontal','FontName','Helvetica','FontSize',12);
end
%set(gca,'XTicklabel',{'J','F','M','A','M','J','J','A','S','O','N','D'}); %x轴范围1-6，间隔1

%xlim([1 12]);
%set(gca,'YTicrk',[0:round(max(month_Et(:))/5):(max(month_Et(:))*1.2)]); %y轴范围0-700，间隔100

%legend('GSWP3','LPJ-GUESS');   %右上角标注
%xlabel('year');  %x轴坐标描述
%ylabel('preci（mm）'); %y轴坐标描述
end
