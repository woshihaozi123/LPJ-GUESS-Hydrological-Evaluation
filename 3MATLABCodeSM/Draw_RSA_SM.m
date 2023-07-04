% Draw the annual mean runoff ratio raincloud graph and monthly mean runoff ratio of the LPJGUESS to GRUN
%2022/11/26  Hao Zhou
clc;
clear;
tic

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
diff=zeros(rownum,colnum);
%grant the area without data NaN value and 0 for area with data
ESASM(:)=NaN;
LPJSM(:)=NaN;
diff(diff(:)==0)=NaN;
for k=1:1:LineNum
    lpjlon=LPJdata_SM(k,1);
    lpjlat=LPJdata_SM(k,2);% lat/lon
    lonnum=floor((lpjlon-(-180))/0.5)+1;
    latnum=floor((lpjlat-(-90))/0.5)+1;
    ESASM(latnum,lonnum)=0;
    LPJSM(latnum,lonnum)=0;
    diff(latnum,lonnum)=0;
end




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
    
    ESASMMonth=zeros(rownum,colnum);
    LPJSMMonth=zeros(rownum,colnum);
    for k=1:1:LineNum
        lpjlon=LPJdata_SM(k,1);
        lpjlat=LPJdata_SM(k,2);
       % ESAlonnum=floor(((lpjlon-0.125)-(-180))/0.25)+1;
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
        end
        
        
        
%         ESAAverageSM=nanmean([monthlysm(ESAlonnum,ESAlatnum),monthlysm(ESAlonnum+1,ESAlatnum),monthlysm(ESAlonnum,ESAlatnum+1),monthlysm(ESAlonnum+1,ESAlatnum+1)]);
%         
%         lonnum=floor((lpjlon-(-180))/0.5)+1;
%         latnum=floor((lpjlat-(-90))/0.5)+1;
%         %if(isnan(ESAAverageSM))
%         %    ESASM(latnum,lonnum)=NaN;
%         %    LPJSM(latnum,lonnum)=NaN;
%         %else
%             ESASM(latnum,lonnum)=ESASM(latnum,lonnum)+ESAAverageSM;
%             LPJSM(latnum,lonnum)=LPJSM(latnum,lonnum)+LPJdata_SM(k,month+2);
            
        %end
    end
end
lon=[-(180-0.5/2):0.5:(180-0.5/2)]';
lat=[-(90-0.5/2):0.5:(90-0.5/2)]';
Levels=[0.05:0.05:0.4];
TitleStr='(j) LPJ-GUESS SM (m^3*m^-^3*yr^-^1)';
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\3FigureSM\map\LPJGUESS SM';
Draw_Map_withLine(lon,lat,LPJSM./12.0,TitleStr,OutputPath,Levels,'YlGnBu',0.4)

diff=(LPJSM-ESASM)./12.0;
%for plot
diff_original=(LPJSM-ESASM)./12.0;
diff(diff(:)>0.16)=0.16;
diff(diff(:)<-0.16)=-0.16;
Levels=[-0.16:0.04:0.16];
TitleStr='(k) LPJ-GUESS minus ESA (m^3*m^-^3*yr^-^1)';
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\3FigureSM\map\SM DV(LPJGUESS minus ESA)_latave';
%RGB=cbrewer('seq', 'YlOrRd',ticknum,'linear');
ticknum=size(Levels,2)-1;
RGB=cbrewer('div', 'RdBu',ticknum);%RdBu
mode='h';%h or v
xlimit=[-0.1:0.1:0.1];
xline=0;
Draw_Diff_withLine(lon,lat,diff,diff_original,TitleStr,OutputPath,Levels,RGB,xline,xlimit)
%Draw_Diff_withLine(lon,lat,data,data_original,titlestr,output,Levels,RGB,xlimit)
OutputPath='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\3FigureSM\map\SM DV(LPJGUESS minus ESA)_latsum';
Draw_Diff_withLineAveragedArea(lon,lat,diff,diff_original,TitleStr,OutputPath,Levels,RGB,0,[-10,10])