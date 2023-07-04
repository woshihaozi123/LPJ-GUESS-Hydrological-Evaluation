function [LFEET]=LFEProcessForMap(LFEdata,lpjlon_list,lpjlat_list)
%process the LFE data for map
    rownum=180/0.5;
    colrum=360/0.5;
    LFEET=zeros(rownum,colrum);  
    LFEET(:)=NaN;
    datanum=size(lpjlon_list,1);
    for k=1:1:datanum
        lpjlon=lpjlon_list(k,1);
        lpjlat=lpjlat_list(k,1);
        %LFEdata lat=-89.5:1:89.5 lon=-179.5:1:179.5
        %convert LEF to LPJ format
        lonnum=floor((lpjlon-(-180))/1)+1;    
        latnum=floor((lpjlat-(-90))/1)+1;
        
        LFEET_gridcell=LFEdata(lonnum,latnum);
        if LFEET_gridcell==-9999
            LFEET_gridcell=NaN;
        end
        LFEET(floor((90-lpjlat)/0.5)+1,floor((lpjlon-(-180))/0.5)+1)=0;        
        LFEET(floor((90-lpjlat)/0.5)+1,floor((lpjlon-(-180))/0.5)+1)= LFEET(floor((90-lpjlat)/0.5)+1,floor((lpjlon-(-180))/0.5)+1)+LFEET_gridcell;  
    end
end