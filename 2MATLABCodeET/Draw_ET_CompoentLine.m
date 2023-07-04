% Draw the LPJGUESS ET line with GLEAM PML-V LandFluxEVAL 2003-2014
clc;
clear;
tic;

%%Read ET file
%% LPJ-GUESS 
%2003-2018 water balance file
%Lon	Lat	aaet	aevap	aintercep	apreci	total_water_in_colum	soilwaterchange	snowpackchange
LPJFileName = 'G:\LPJGUESSHydrologyBalanceCheck\6LPJGUESSResults\LPJdata\waterbalance0314.xlsx';
[Data,Txt] = xlsread(LPJFileName);
lpjlon_list = Data(:,1);
lpjlat_list= Data(:,2);
data_LPJaet= Data(:,3);
data_LPJevap= Data(:,4);
data_LPJintercep= Data(:,5);
data_LPJET= data_LPJaet+data_LPJevap+data_LPJintercep;

LPJaet=LPJProcessYearlyForMap(data_LPJaet,lpjlon_list,lpjlat_list);
LPJevap=LPJProcessYearlyForMap(data_LPJevap,lpjlon_list,lpjlat_list);
LPJintercep=LPJProcessYearlyForMap(data_LPJintercep,lpjlon_list,lpjlat_list);
LPJET=LPJProcessYearlyForMap(data_LPJET,lpjlon_list,lpjlat_list);

%% GLEAM a and b
filename_GleamEi='D:\Program Files\PuTTY\GLEAM data\v3.5a\yearly after 3.9\Ei_1980-2020_GLEAM_v3.5a_YR.nc';
filename_GleamEb='D:\Program Files\PuTTY\GLEAM data\v3.5a\yearly after 3.9\Eb_1980-2020_GLEAM_v3.5a_YR.nc';
filename_GleamEt='D:\Program Files\PuTTY\GLEAM data\v3.5a\yearly after 3.9\Et_1980-2020_GLEAM_v3.5a_YR.nc';
% ncdisp(filename_GleamEi);
% lon_GleamEi=double(ncread(filename_GleamEi,'lon'));
% lat_GleamEi=double(ncread(filename_GleamEi,'lat'));
% time_GleamEi=double(length(ncread(filename_GleamEi,'time')));
data_Gleamaet=double(ncread(filename_GleamEt,'Et'));
data_Gleamevap=double(ncread(filename_GleamEb,'Eb'));
data_Gleamintercep=double(ncread(filename_GleamEi,'Ei'));
data_Gleamintercep(data_Gleamintercep(:)==-999)=NaN;%_FillValue = -999
data_Gleamevap(data_Gleamevap(:)==-999)=NaN;%_FillValue = -999
data_Gleamaet(data_Gleamaet(:)==-999)=NaN;%_FillValue = -999
data_GleamET=data_Gleamaet+data_Gleamevap+data_Gleamintercep;

Gleamaet=GLEAMProcessForMap(data_Gleamaet,lpjlon_list,lpjlat_list,2003,2014);
Gleamevap=GLEAMProcessForMap(data_Gleamevap,lpjlon_list,lpjlat_list,2003,2014);
Gleamintercep=GLEAMProcessForMap(data_Gleamintercep,lpjlon_list,lpjlat_list,2003,2014);
GleamET=GLEAMProcessForMap(data_GleamET,lpjlon_list,lpjlat_list,2003,2014);



%% PML_V2
fileName2='D:\Program Files\PuTTY\PML_V2 code\yearmean\2003-2014_0.5.tif';
tifimage=imread(char(fileName2));
data_MPLV2aet=tifimage(:,:,2);
data_MPLV2evap=tifimage(:,:,4);
data_MPLV2intercep=tifimage(:,:,3);

data_MPLV2aet(data_MPLV2aet(:)==0)=NaN;%_FillValue = 0
data_MPLV2evap(data_MPLV2evap(:)==0)=NaN;%_FillValue = 0
data_MPLV2intercep(data_MPLV2intercep(:)==0)=NaN;%_FillValue = 0
data_MPLV2ET =data_MPLV2aet+data_MPLV2evap+data_MPLV2intercep; 

% GPP	gC m-2 d-1	0.01	Gross primary product
% Ec	mm d-1	0.01	Vegetation Transpiration
% Es	mm d-1	0.01	Soil Evaporation
% Ei	mm d-1	0.01	Interception from vegetation canopy
% ET_water	mm d-1	0.01	Water body, snow and ice evaporation. Penman
% evapotranspiration is regarded as actual evaporation for them.
PMLV2aet=PMLV2ProcessForMap(data_MPLV2aet,lpjlon_list,lpjlat_list);
PMLV2evap=PMLV2ProcessForMap(data_MPLV2evap,lpjlon_list,lpjlat_list);
PMLV2intercep=PMLV2ProcessForMap(data_MPLV2intercep,lpjlon_list,lpjlat_list);
PMLV2ET=PMLV2ProcessForMap(data_MPLV2ET,lpjlon_list,lpjlat_list);


%% Fluxcom
% Fluxcom_filename='H:\ET Dataset\Fluxcom\yearmean2004-2014\Fluxcom2004-2014.nc';
% FluxcomLE=double(ncread(Fluxcom_filename,'ET'))/10.0;%4320x2160
% Fluxcomlat=double(ncread(Fluxcom_filename,'lat'));

%% draw the ET and components



LPJaetLataev=nanmean(LPJaet,2);%nanmean average by the 2rd dimension ignoring the nan
LPJevapLataev=nanmean(LPJevap,2);
LPJintercepLataev=nanmean(LPJintercep,2);
LPJETLataev=nanmean(LPJET,2);

GleamaetLataev=nanmean(Gleamaet,2);
GleamevapLataev=nanmean(Gleamevap,2);
GleamintercepLataev=nanmean(Gleamintercep,2);
GleamETLataev=nanmean(GleamET,2);

PMLV2aetLataev=nanmean(PMLV2aet,2);
PMLV2evapLataev=nanmean(PMLV2evap,2);
PMLV2intercepLataev=nanmean(PMLV2intercep,2);
PMLV2ETLataev=nanmean(PMLV2ET,2);


% FluxcomLE_map_lat=nanmean(FluxcomLE,1);

%draw line
lat=[(90-0.5/2):-0.5:-(90-0.5/2)]';
lat_PML=[(90-0.5/2):-0.5:-(60-0.5/2)]';
f=figure('color',[1 1 1]);
f.Units = 'centimeters';
f.Position = [0 0 17 10];%[x y width height] for looking
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 17 12]);%for printing
[ha, pos] = tight_subplot(2,2,[.03 .08],[.08 .02],[.08 .02]);
 axes(ha(1));
    box on;
    hold on
Draw_line(lat,LPJETLataev,lat,GleamETLataev,lat_PML,PMLV2ETLataev,'Averaged ET(mm*yr^-1)')
%plot(Fluxcomlat,FluxcomLE_map_lat,'-','Color',[0.255,0.190,0.122],'lineWidth',2);

axes(ha(2));
    box on;
    hold on
Draw_line(lat,LPJaetLataev,lat,GleamaetLataev,lat_PML,PMLV2aetLataev,'Averaged Plant Transpiration(mm*yr^-1)')

axes(ha(3));
    box on;
    hold on
Draw_line(lat,LPJevapLataev,lat,GleamevapLataev,lat_PML,PMLV2evapLataev,'Averaged Soil Evaporation(mm*yr^-1)')

axes(ha(4));
    box on;
    hold on
Draw_line(lat,LPJintercepLataev,lat,GleamintercepLataev,lat_PML,PMLV2intercepLataev,'Averaged Interception(mm*yr^-1)')


output='G:\LPJGUESSHydrologyBalanceCheck\FigureDraw\2FigureET\line\ET line_more';
print(gcf,strcat(output, '.png'),'-r300','-dpng');
%%
toc;

function []=Draw_line(x1,y1,x2,y2,x3,y3, ylablel)
%x=-60:0.5:90;
h1=plot(x1,y1,'-','Color',[0.255,0.412,0.88],'lineWidth',2);
hold on;
h2=plot(x2,y2,'--','Color',[0.76,0.068,0.1944],'lineWidth',2);
hold on;
h3=plot(x3,y3,':','Color',[0.3,0.3,0.35],'lineWidth',2);
axis([-60,90,0,max([max(y1(:)),max(y2(:)),max(y3(:))])*1.2]);
set(gca,'XTick',[-60:30:90]);
set(gca,'XTicklabel',{'-60бу','-30бу','0бу','30бу','60бу','90бу'});
set(gcf,'unit','centimeters','position',[5 0 30 30])
legend('LPJ-GUESS','GLEAM','PML-V2');
xlabel('Latitude','FontName','Helvetica','FontSize',15);
ylabel(ylablel,'FontName','Helvetica','FontSize',15);
hold on;
end
