clc;
clear;
tic


GSWP3FilePath3='G:\LPJGUESSHydrologyBalanceCheck\5Precipiation\GSWP3\pr_gswp3_2001_2010.nc4';
ncdisp(GSWP3FilePath3);                                   %Display File Information
lonGSWP3=double(ncread(GSWP3FilePath3,'lon'));                   %Read the longitude range and accuracy
latGSWP3=double(ncread(GSWP3FilePath3,'lat'));                   %Read the latitude range and accuracy
time3=double(ncread(GSWP3FilePath3,'time'));               %Read the time range and accuracy
GSWP3Preci3=double(ncread(GSWP3FilePath3,'pr'));           %Read the Runoff range and accuracy
% Dimensions:
%            lon  = 720
%            lat  = 360
%            time = 3652  (UNLIMITED)

startyear=1985;
endyear=2010;
monthlyprecipitation=zeros(720,360,12);
daynum=zeros(12);
timelength3=size(time3,1);

    


for timeid3=1:1:timelength3
    year3=year(days(time3(timeid3))+datetime(1860,1,1));
    
    if(year3>=startyear&&year3<=endyear)
        month3=month(days(time3(timeid3))+datetime(1860,1,1));
        for monthnum=1:1:12
            if(month3==monthnum)
                monthlyprecipitation(:,:,monthnum)= monthlyprecipitation(:,:,monthnum)+GSWP3Preci3(:,:,timeid3);
                daynum(monthnum)= daynum(monthnum)+1;
            end
        end
    end      
end

%monthlymean
monthlyprecipitation=monthlyprecipitation./10.0;
%unit kg m-2 s-1 to mm
monthlyprecipitation=monthlyprecipitation*10e-3*1000*24*3600;

outputfilename='G:\LPJGUESSHydrologyBalanceCheck\5Precipiation\GSWP3\pr_gswp3_2001_2010monthlymean.nc4';
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