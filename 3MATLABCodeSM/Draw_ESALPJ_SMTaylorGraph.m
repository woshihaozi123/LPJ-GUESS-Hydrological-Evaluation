
% Draw the annual mean runoff ratio raincloud graph and monthly mean runoff ratio of the LPJGUESS to GRUN
%2022/11/26  Hao Zhou
clc;
clear;
tic
%% Ecoregion area
%Tropical_Subtropical_Moist_Broadleaf_Forests
%Tropical_Subtropical_Coniferous_Forests
%Tropical_&_Subtropical_Grasslands,_Savannas_&_Shrublands
%Tropical_&_Subtropical_Dry_Broadleaf_Forests
%Temperate_Grasslands,_Savannas_&_Shrublands
%Temperate_Conifer_Forests
%Temperate_Broadleaf_&_Mixed_Forests
%Montane_Grasslands_&_Shrublands
%Mediterranean_Forests,_Woodlands_&_Scrub
%Boreal_Forests_Taiga
%Tundra
%abbreviation:TSMBF TSCF TSGSS TSDBF TGSS TCF TBMF MGS MFWS BFT TU
[S1_x,S1_y]=textread('G:\LPJGUESSHydrologyBalanceCheck\4RegionData\Ecoregion\Fourteen types ecoregion\detailed point txt\Tropical_Subtropical_Moist_Broadleaf_Forests.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S2_x,S2_y]=textread('G:\LPJGUESSHydrologyBalanceCheck\4RegionData\Ecoregion\Fourteen types ecoregion\detailed point txt\Tropical_Subtropical_Coniferous_Forests.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S3_x,S3_y]=textread('G:\LPJGUESSHydrologyBalanceCheck\4RegionData\Ecoregion\Fourteen types ecoregion\detailed point txt\Tropical_&_Subtropical_Grasslands,_Savannas_&_Shrublands.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S4_x,S4_y]=textread('G:\LPJGUESSHydrologyBalanceCheck\4RegionData\Ecoregion\Fourteen types ecoregion\detailed point txt\Tropical_&_Subtropical_Dry_Broadleaf_Forests.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S5_x,S5_y]=textread('G:\LPJGUESSHydrologyBalanceCheck\4RegionData\Ecoregion\Fourteen types ecoregion\detailed point txt\Temperate_Grasslands,_Savannas_&_Shrublands.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S6_x,S6_y]=textread('G:\LPJGUESSHydrologyBalanceCheck\4RegionData\Ecoregion\Fourteen types ecoregion\detailed point txt\Temperate_Conifer_Forests.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S7_x,S7_y]=textread('G:\LPJGUESSHydrologyBalanceCheck\4RegionData\Ecoregion\Fourteen types ecoregion\detailed point txt\Temperate_Broadleaf_&_Mixed_Forests.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S8_x,S8_y]=textread('G:\LPJGUESSHydrologyBalanceCheck\4RegionData\Ecoregion\Fourteen types ecoregion\detailed point txt\Montane_Grasslands_&_Shrublands.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S9_x,S9_y]=textread('G:\LPJGUESSHydrologyBalanceCheck\4RegionData\Ecoregion\Fourteen types ecoregion\detailed point txt\Mediterranean_Forests,_Woodlands_&_Scrub.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S10_x,S10_y]=textread('G:\LPJGUESSHydrologyBalanceCheck\4RegionData\Ecoregion\Fourteen types ecoregion\detailed point txt\Boreal_Forests_Taiga.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );
[S11_x,S11_y]=textread('G:\LPJGUESSHydrologyBalanceCheck\4RegionData\Ecoregion\Fourteen types ecoregion\detailed point txt\Tundra.txt','%n%n', 'delimiter' , ' ' , 'headerlines' , 1 );

%% read data
%ESA monthly mean
tic;
fileName='G:\LPJGUESSHydrologyBalanceCheck\3SoilMoisture\ESA\monthlymean\851401.nc';
ncdisp(fileName)
lon=double(ncread(fileName,'lon'));                   %读取经度范围和精度
lat=double(ncread(fileName,'lat'));                   %读取纬度范围和精度
time=double((ncread(fileName,'time')));         %读取时间序列长度
dirstring="G:\LPJGUESSHydrologyBalanceCheck\3SoilMoisture\ESA\monthlymean\";
filedir=dir(char(dirstring));

%read lpjguess Soil moisture data
LPJSMfilename='G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\mssm8514ave.out';
LPJdata_SM=ReadTxtData(LPJSMfilename);
LineNum=size(LPJdata_SM,1)%show line number of file
LPJdata_SM(:,3:14)=LPJdata_SM(:,3:14)./100;

rownum=180/0.5;
colnum=360/0.5;
ESASM=zeros(rownum,colnum);
LPJSM=zeros(rownum,colnum);
%grant the area without data NaN value and 0 for area with data
ESASM(:)=NaN;
LPJSM(:)=NaN;
for k=1:1:LineNum
    lpjlon=LPJdata_SM(k,1);
    lpjlat=LPJdata_SM(k,2);% lat/lon
    lonnum=floor((lpjlon-(-180))/0.5)+1;
    latnum=floor((lpjlat-(-90))/0.5)+1;
    ESASM(latnum,lonnum)=0;
    LPJSM(latnum,lonnum)=0;
end


%for monthly mean ratio line
monthlyMeanRatio=zeros(12,11);

%% Average
for month=1:1:12
    %% read nc name list
    len=length(filedir);
    file_name=string(zeros(len,1));
    
    monthlysm=zeros(size(lon,1),size(lat,1));
    monthnum=0;
    for i=3:1:len
        file_name=filedir(i).name;
        if(str2num(char(file_name(5:6)))==month)
            monthdir=strcat(dirstring,file_name);
            monthlysm=double((ncread(monthdir,'sm')));
            
        end
    end
    nanmean(monthlysm(:))
    ESASMMonth=zeros(rownum,colnum);
    LPJSMMonth=zeros(rownum,colnum);
    for k=1:1:LineNum
        lpjlon=LPJdata_SM(k,1);
        lpjlat=LPJdata_SM(k,2);
        %ESAlonnum=floor(((lpjlon-0.125)-(-180))/0.25)+1;
        % ESAlatnum=floor((90-(lpjlat+0.125))/0.25)+1;
        
        lonnum=floor((lpjlon-(-180))/0.25)+1;
        latnum=floor((90-lpjlat)/0.25)+1;
        if(mod(latnum,2)==0)
            latnum1=latnum-1;
        else
            latnum1=latnum+1;
        end
        if(mod(lonnum,2)==0)
            lonnum1=lonnum-1;
        else
            lonnum1=lonnum+1;
        end
        
        num=4;
        if(isnan(monthlysm(lonnum,latnum)))
            num=num-1;
            monthlysm(lonnum,latnum)=0;
        end
        if(isnan(monthlysm(lonnum1,latnum1)))
            num=num-1;
            monthlysm(lonnum1,latnum1)=0;
        end
        if(isnan(monthlysm(lonnum1,latnum)))
            num=num-1;
            monthlysm(lonnum1,latnum)=0;
        end
        if(isnan(monthlysm(lonnum,latnum1)))
            num=num-1;
            monthlysm(lonnum,latnum1)=0;
        end
        if(num~=0)
            ESAAverageSM=(monthlysm(lonnum,latnum)+monthlysm(lonnum1,latnum1)+monthlysm(lonnum1,latnum)+monthlysm(lonnum,latnum1))/num;
        end
        lonnum=floor((lpjlon-(-180))/0.5)+1;
        latnum=floor((lpjlat-(-90))/0.5)+1;
        if(ESAAverageSM~=0)
            
            ESASM(latnum,lonnum)=ESASM(latnum,lonnum)+ESAAverageSM;
            LPJSM(latnum,lonnum)=LPJSM(latnum,lonnum)+LPJdata_SM(k,month+2);
            ESASMMonth(latnum,lonnum)= ESASMMonth(latnum,lonnum)+ESAAverageSM;
            LPJSMMonth(latnum,lonnum)=LPJSMMonth(latnum,lonnum)+LPJdata_SM(k,month+2);
            
        end
        %ESAAverageSM=nanmean([monthlysm(ESAlonnum,ESAlatnum),monthlysm(ESAlonnum+1,ESAlatnum),monthlysm(ESAlonnum,ESAlatnum+1),monthlysm(ESAlonnum+1,ESAlatnum+1)]);
        
        %         lonnum=floor((lpjlon-(-180))/0.5)+1;
        %         latnum=floor((lpjlat-(-90))/0.5)+1;
        %         if(isnan(ESAAverageSM))
        %             ESASM(latnum,lonnum)=NaN;
        %             LPJSM(latnum,lonnum)=NaN;
        %             ESASMMonth(latnum,lonnum)= NaN;
        %             LPJSMMonth(latnum,lonnum)=NaN;
        %         else
        %             ESASM(latnum,lonnum)=ESASM(latnum,lonnum)+ESAAverageSM;
        %             LPJSM(latnum,lonnum)=LPJSM(latnum,lonnum)+LPJdata_SM(k,month+2);
        %             ESASMMonth(latnum,lonnum)= ESASMMonth(latnum,lonnum)+ESAAverageSM;
        %             LPJSMMonth(latnum,lonnum)=LPJSMMonth(latnum,lonnum)+LPJdata_SM(k,month+2);
        %
        %         end
    end
    [eco1_ESAm,eco2_ESAm,eco3_ESAm,eco4_ESAm,eco5_ESAm,eco6_ESAm,eco7_ESAm,eco8_ESAm,eco9_ESAm,eco10_ESAm,eco11_ESAm]=EcoregionMask(ESASMMonth,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);
    [eco1_LPJm,eco2_LPJm,eco3_LPJm,eco4_LPJm,eco5_LPJm,eco6_LPJm,eco7_LPJm,eco8_LPJm,eco9_LPJm,eco10_LPJm,eco11_LPJm]=EcoregionMask(LPJSMMonth,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);
    
    
end
%for yearly scatter plot
[eco1_LPJy,eco2_LPJy,eco3_LPJy,eco4_LPJy,eco5_LPJy,eco6_LPJy,eco7_LPJy,eco8_LPJy,eco9_LPJy,eco10_LPJy,eco11_LPJy]=EcoregionMask(LPJSM,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);
[eco1_ESAy,eco2_ESAy,eco3_ESAy,eco4_ESAy,eco5_ESAy,eco6_ESAy,eco7_ESAy,eco8_ESAy,eco9_ESAy,eco10_ESAy,eco11_ESAy]=EcoregionMask(ESASM,S1_x,S2_x,S3_x,S4_x,S5_x,S6_x,S7_x,S8_x,S9_x,S10_x,S11_x,S1_y,S2_y,S3_y,S4_y,S5_y,S6_y,S7_y,S8_y,S9_y,S10_y,S11_y);


data=zeros(12,3);%for sdev,crmsd,ccoef
dataName={'Observation','Globe','TSMBF', 'TSCF', 'TSGSS', 'TSDBF', 'TGSS', 'TCF', 'TBMF', 'MGS', 'MFWS', 'BFT', 'TU'};  

%%
S = allstats(ESASM(:),LPJSM(:));
stdev=S(2,1);
S(2,:)=S(2,:)/stdev;% standization
S(3,:)=S(3,:)/stdev;% standization
data(1,:)=S(2:4,1);
data(2,:)=S(2:4,2);

S1 = allstats(eco1_ESAy(:),eco1_LPJy(:));
stdev=S1(2,1);
S1(2,:)=S1(2,:)/stdev;% standization
S1(3,:)=S1(3,:)/stdev;% standization
data(3,:)=S1(2:4,2);

S2 = allstats(eco2_ESAy(:),eco2_LPJy(:));
stdev=S2(2,1);
S2(2,:)=S2(2,:)/stdev;% standization
S2(3,:)=S2(3,:)/stdev;% standization
data(4,:)=S2(2:4,2);

S3 = allstats(eco3_ESAy(:),eco3_LPJy(:));
stdev=S3(2,1);
S3(2,:)=S3(2,:)/stdev;% standization
S3(3,:)=S3(3,:)/stdev;% standization
data(5,:)=S3(2:4,2);

S4 = allstats(eco4_ESAy(:),eco4_LPJy(:));
stdev=S4(2,1);
S4(2,:)=S4(2,:)/stdev;% standization
S4(3,:)=S4(3,:)/stdev;% standization
data(6,:)=S4(2:4,2);

S5 = allstats(eco5_ESAy(:),eco5_LPJy(:));
stdev=S5(2,1);
S5(2,:)=S5(2,:)/stdev;% standization
S5(3,:)=S5(3,:)/stdev;% standization
data(7,:)=S5(2:4,2);

S6 = allstats(eco6_ESAy(:),eco6_LPJy(:));
stdev=S6(2,1);
S6(2,:)=S6(2,:)/stdev;% standization
S6(3,:)=S6(3,:)/stdev;% standization
data(8,:)=S6(2:4,2);

S7 = allstats(eco7_ESAy(:),eco7_LPJy(:));
stdev=S7(2,1);
S7(2,:)=S7(2,:)/stdev;% standization
S7(3,:)=S7(3,:)/stdev;% standization
data(9,:)=S7(2:4,2);

S8 = allstats(eco8_ESAy(:),eco8_LPJy(:));
stdev=S8(2,1);
S8(2,:)=S8(2,:)/stdev;% standization
S8(3,:)=S8(3,:)/stdev;% standization
data(10,:)=S8(2:4,2);

S9 = allstats(eco9_ESAy(:),eco9_LPJy(:));
stdev=S9(2,1);
S9(2,:)=S9(2,:)/stdev;% standization
S9(3,:)=S9(3,:)/stdev;% standization
data(11,:)=S9(2:4,2);

S10 = allstats(eco10_ESAy(:),eco10_LPJy(:));
stdev=S10(2,1);
S10(2,:)=S10(2,:)/stdev;% standization
S10(3,:)=S10(3,:)/stdev;% standization
data(12,:)=S10(2:4,2);

S11 = allstats(eco11_ESAy(:),eco11_LPJy(:));
stdev=S11(2,1);
S11(2,:)=S11(2,:)/stdev;% standization
S11(3,:)=S11(3,:)/stdev;% standization
data(13,:)=S11(2:4,2);


Draw_taylorgraph(data,dataName,'G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\3FigureSM\ecoregion\ESALPJTaylor')
