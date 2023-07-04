%generate yearly time series
clc;
clear;

filelist='G:\LPJGUESSHydrologyBalanceCheck\5Precipiation\GSWP3\';
GSWP3dir=dir(filelist);%name folder date bytes isdir datenum
len=length(GSWP3dir);
filenum=11;
file_name=string(zeros(filenum,1));
fileid=1;
for i=1:len
    if(GSWP3dir(i).isdir==0)
        file_name(fileid)=GSWP3dir(i).name;%'pr_gswp3_1901_1910.nc4'
        fileid=fileid+1;
    end
end

%paremeter setting
startyear=1901;
endyear=2010;
yearlength=endyear-startyear+1;
yearlyprecipitation=zeros(720,360,yearlength);
filestartdata=datetime(1860,1,1)
for fileid=1:1:filenum
    GSWP3FilePath=filelist+file_name(fileid)
    % Dimensions:
    % lon  = 720
    % lat  = 360
    % time = 3652  (UNLIMITED)
    ncdisp(GSWP3FilePath);                                   %Display File Information
    lonGSWP3=double(ncread(GSWP3FilePath,'lon'));            %Read the longitude range and accuracy
    latGSWP3=double(ncread(GSWP3FilePath,'lat'));             %Read the latitude range and accuracy
    timeGSWP3=double(ncread(GSWP3FilePath,'time'));               %Read the time range and accuracy
    GSWP3Preci=double(ncread(GSWP3FilePath,'pr'));           %Read the Runoff range and accuracy
    
    timelength=size(timeGSWP3,1);    
    for timeid1=1:1:timelength
        timeidyear=year(days(timeGSWP3(timeid1))+filestartdata);
        yearlyprecipitation(:,:,timeidyear-startyear+1)= yearlyprecipitation(:,:,timeidyear-startyear+1)+GSWP3Preci(:,:,timeid1);
    end
    
end

%unit kg m-2 s-1 to mm
yearlyprecipitation=yearlyprecipitation*24*3600;

outputfilename='G:\LPJGUESSHydrologyBalanceCheck\5Precipiation\GSWP3\yearlymean\pr_gswp3_1901_2010yearlymean.nc4';
nccreate(outputfilename,'lon','Dimensions',{'lon',720});
nccreate(outputfilename,'lat','Dimensions',{'lat',360});
nccreate(outputfilename,'time','Dimensions',{'time',yearlength});
nccreate(outputfilename,'pr',...
    'Dimensions', {'lon',720,'lat',360,'time',yearlength},...
    'FillValue','disable');
timeyear=1:1:yearlength;
% 存入数据，注意数据尺寸一致
ncwrite(outputfilename,'lon',lonGSWP3);
ncwrite(outputfilename,'lat',latGSWP3);
ncwrite(outputfilename,'time',timeyear);
ncwrite(outputfilename,'pr',yearlyprecipitation);

% 查看信息
info = ncinfo(outputfilename); %检验是否成功写入nc文件
