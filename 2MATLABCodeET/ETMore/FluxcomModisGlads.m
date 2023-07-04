clc;
clear;
tic;

%setting
Fluxcomlist='H:\ET Dataset\Fluxcom\*.nc';
startyear=2004;
endyear=2014;

%% read file name list
Fluxcomdir=dir(Fluxcomlist);%name folder date bytes isdir datenum
len=length(Fluxcomdir);
FluxcomLE_sum=zeros(4320,2160,46);

for i=1:len
    filename=[Fluxcomdir(i).folder,'\',Fluxcomdir(i).name];
    FluxcomLE_individual=double(ncread(filename,'LE'));%4320x2160x46
%            Size:       4320x2160x46
%            Dimensions: lon,lat,time
%            Datatype:   single
%            Attributes:
%                        units         = 'MJ m-2 d-1'
%                        long_name     = 'latent heat'
%                        missing_value = -9999
%                        _FillvALUE    = -9999
%                        scale_factor  = 1
%                        add_offset    = 0
    FluxcomLE_individual(FluxcomLE_individual(:)==-9999)=NaN;
    FluxcomLE_sum=FluxcomLE_sum+FluxcomLE_individual;
end

lamba=2.45;
FluxcomLE_map=sum(FluxcomLE_sum*8.0/lamba,3);

%% output
filename1=[Fluxcomdir(1).folder,'\',Fluxcomdir(1).name];
data_Fluxcomlon=double(ncread(filename1,'lon'));
data_Fluxcomlat=double(ncread(filename1,'lat'));
FluxcomLE_map_lat=nanmean(FluxcomLE_map,1);
plot(data_Fluxcomlat,FluxcomLE_map_lat,'-','Color',[0.255,0.412,0.88],'lineWidth',2);
set(gca,'XTick',[-60:30:90]);
set(gca,'XTicklabel',{'-60°','-30°','0°','30°','60°','90°'});

outputfilename='H:\ET Dataset\Fluxcom\yearmean2004-2014\Fluxcom2004-2014.nc';
nccreate(outputfilename,'lon','Dimensions',{'lon',4320});
nccreate(outputfilename,'lat','Dimensions',{'lat',2160});
nccreate(outputfilename,'ET',...
    'Dimensions', {'lon',4320,'lat',2160},...
    'FillValue','disable');

% 存入数据，注意数据尺寸一致
ncwrite(outputfilename,'lon',data_Fluxcomlon);
ncwrite(outputfilename,'lat',data_Fluxcomlat);
ncwrite(outputfilename,'ET',FluxcomLE_map);

% 查看信息
info = ncinfo(outputfilename); %检验是否成功写入nc文件


