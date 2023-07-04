clc;
clear;


GSWP3FilePath1='G:\LPJGUESSHydrologyBalanceCheck\5Precipiation\GSWP3\pr_gswp3_1981_1990.nc4';

ncdisp(GSWP3FilePath1);                                   %Display File Information
lonGSWP3=double(ncread(GSWP3FilePath1,'lon'));                   %Read the longitude range and accuracy
latGSWP3=double(ncread(GSWP3FilePath1,'lat'));                   %Read the latitude range and accuracy
time1=double(ncread(GSWP3FilePath1,'time'));               %Read the time range and accuracy
GSWP3Preci1=double(ncread(GSWP3FilePath1,'pr'));           %Read the Runoff range and accuracy
% Dimensions:
%            lon  = 720
%            lat  = 360
%            time = 3652  (UNLIMITED)

startyear=1985;
endyear=2010;
monthlyprecipitation=zeros(720,360,12);
daynum=zeros(12);
timelength1=size(time1,1);
    
for timeid1=1:1:timelength1
    year1=year(days(time1(timeid1))+datetime(1860,1,1));
    
    if(year1>=startyear&&year1<=endyear)
        month1=month(days(time1(timeid1))+datetime(1860,1,1));
        for monthnum=1:1:12
            if(month1==monthnum)
                monthlyprecipitation(:,:,monthnum)= monthlyprecipitation(:,:,monthnum)+GSWP3Preci1(:,:,timeid1);
                daynum(monthnum)= daynum(monthnum)+1;
            end
        end
    end      
end



%monthlymean
monthlyprecipitation=monthlyprecipitation./(1990-startyear+1);
%unit kg m-2 s-1 to mm
monthlyprecipitation=monthlyprecipitation*24*3600;

outputfilename='G:\LPJGUESSHydrologyBalanceCheck\5Precipiation\GSWP3\pr_gswp3_1985_1990monthlymean.nc4';
nccreate(outputfilename,'lon','Dimensions',{'lon',720});
nccreate(outputfilename,'lat','Dimensions',{'lat',360});
nccreate(outputfilename,'time','Dimensions',{'time',12});
nccreate(outputfilename,'pr',...
    'Dimensions', {'lon',720,'lat',360,'time',12},...
    'FillValue','disable');
timemonth=1:1:12;
% 存入数据，注意数据尺寸一致
ncwrite(outputfilename,'lon',lonGSWP3);
ncwrite(outputfilename,'lat',latGSWP3);
ncwrite(outputfilename,'time',timemonth);
ncwrite(outputfilename,'pr',monthlyprecipitation);

% 查看信息
info = ncinfo(outputfilename); %检验是否成功写入nc文件