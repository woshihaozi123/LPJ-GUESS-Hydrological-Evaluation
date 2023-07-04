function [GLEMAEET]=GLEAMProcessForMap(GLEMAdata,lpjlon_list,lpjlat_list,startyear,endyear)
%process the GLEAM data for map
    
    rownum=180/0.5;
    colrum=360/0.5;
    GLEMAEET=zeros(rownum,colrum);  
    GLEMAEET(GLEMAEET(:)==0)=NaN;
    datanum=size(lpjlon_list,1);
    for k=1:1:datanum
        lpjlon=lpjlon_list(k,1);
        lpjlat=lpjlat_list(k,1);
        %GLEAM 720x1440x41 double
        %lonRange=(-179.875:0.25:179.875)';latRange=(89.875:0.25:-89.875)'
        %convert  LPJ lat/lon to GLEAM lat/lonnumber 
        GLEAMlatnum=floor((90-(lpjlat+0.125))/0.25)+1;
        GLEAMlonnum=floor(((lpjlon-0.125)-(-180))/0.25)+1;    
        GLEAMET_gridcell=0;
        %yearly mean
        for y=1:1:(endyear-startyear+1)
            GLEAMET_gridcell=GLEAMET_gridcell+nanmean([GLEMAdata(GLEAMlatnum,GLEAMlonnum,y+startyear-1980),GLEMAdata(GLEAMlatnum,GLEAMlonnum+1,y+startyear-1980),GLEMAdata(GLEAMlatnum+1,GLEAMlonnum,y+startyear-1980),GLEMAdata(GLEAMlatnum+1,GLEAMlonnum+1,y+startyear-1980)]);
        end
        GLEAMET_gridcell=GLEAMET_gridcell/(endyear-startyear+1);
        GLEMAEET(floor((90-lpjlat)/0.5)+1,floor((lpjlon-(-180))/0.5)+1)=0;        
        GLEMAEET(floor((90-lpjlat)/0.5)+1,floor((lpjlon-(-180))/0.5)+1)= GLEMAEET(floor((90-lpjlat)/0.5)+1,floor((lpjlon-(-180))/0.5)+1)+GLEAMET_gridcell;  
    end
end