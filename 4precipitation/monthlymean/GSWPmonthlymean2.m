clc;
clear;
tic


GSWP3FilePath2='G:\LPJGUESSHydrologyBalanceCheck\5Precipiation\GSWP3\pr_gswp3_1991_2000.nc4';
ncdisp(GSWP3FilePath2);                                   %Display File Information
lonGSWP3=double(ncread(GSWP3FilePath2,'lon'));                   %Read the longitude range and accuracy
latGSWP3=double(ncread(GSWP3FilePath2,'lat'));                   %Read the latitude range and accuracy

time2=double(ncread(GSWP3FilePath2,'time'));               %Read the time range and accuracy
GSWP3Preci2=double(ncread(GSWP3FilePath2,'pr'));           %Read the Runoff range and accuracy
% Dimensions:
%            lon  = 720
%            lat  = 360
%            time = 3652  (UNLIMITED)

startyear=1985;
endyear=2010;
monthlyprecipitation=zeros(720,360,12);
daynum=zeros(12);
timelength2=size(time2,1);


    


for timeid2=1:1:timelength2
    year2=year(days(time2(timeid2))+datetime(1860,1,1));
    
    if(year2>=startyear&&year2<=endyear)
        month2=month(days(time2(timeid2))+datetime(1860,1,1));
        for monthnum=1:1:12
            if(month2==monthnum)
                monthlyprecipitation(:,:,monthnum)= monthlyprecipitation(:,:,monthnum)+GSWP3Preci2(:,:,timeid2);
                daynum(monthnum)= daynum(monthnum)+1;
            end
        end
    end      
end




%monthlymean
monthlyprecipitation=monthlyprecipitation./10.0;
%unit kg m-2 s-1 to mm
monthlyprecipitation=monthlyprecipitation*10e-3*1000*24*3600;

outputfilename='G:\LPJGUESSHydrologyBalanceCheck\5Precipiation\GSWP3\pr_gswp3_1991_2000monthlymean.nc4';
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