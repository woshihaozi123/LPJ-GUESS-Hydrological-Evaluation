function [LPJET]=LPJProcessYearlyForMap(LPJdata,lpjlon_list,lpjlat_list)
%process the LPJGUESS data for map    
rownum=180/0.5;
    colrum=360/0.5;
    LPJET=zeros(rownum,colrum);
    LPJET(LPJET(:)==0)=NaN;
    datanum=size(lpjlon_list,1);
    for k=1:1:datanum
        lpjlon=lpjlon_list(k,1);
        lpjlat=lpjlat_list(k,1);
        %LPJET
        LPJET(floor((90-lpjlat)/0.5)+1,floor((lpjlon-(-180))/0.5)+1)=0;
        LPJET(floor((90-lpjlat)/0.5)+1,floor((lpjlon-(-180))/0.5)+1)=LPJET(floor((90-lpjlat)/0.5)+1,floor((lpjlon-(-180))/0.5)+1)+LPJdata(k);
        
     end
end