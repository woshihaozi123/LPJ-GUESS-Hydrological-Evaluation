function [PMLV2ET]=PMLV2ProcessForMap(PMLV2data,lpjlon_list,lpjlat_list)
%process the PMLV2 data for map
    rownum=150/0.5;
    colrum=360/0.5;
    PMLV2ET=zeros(rownum,colrum);  
    PMLV2ET(PMLV2ET(:)==0)=NaN;
    datanum=size(lpjlon_list,1);
    
    for k=1:1:datanum
        lpjlon=lpjlon_list(k,1);
        lpjlat=lpjlat_list(k,1);
        %LFEdata lat=89.75:-0.5:(-60+0.25) lon=-179.75:0.5:179.75
        %convert PMLV2 to LPJ format
        lonnum=floor((lpjlon-(-180))/0.5)+1;    
        latnum=floor((90-lpjlat)/0.5)+1;
        PMLV2ET_gridcell=PMLV2data(latnum,lonnum);
        PMLV2ET(floor((90-lpjlat)/0.5)+1,floor((lpjlon-(-180))/0.5)+1)=0;        
        PMLV2ET(floor((90-lpjlat)/0.5)+1,floor((lpjlon-(-180))/0.5)+1)= PMLV2ET(floor((90-lpjlat)/0.5)+1,floor((lpjlon-(-180))/0.5)+1)+PMLV2ET_gridcell;  
    end
end