pred_data=zeros(length(LPJeco(1)),1);
    obs_data=zeros(length(GLEAMeco(1)),1)
    pred_data=cell2mat(LPJeco(1));
    obs_data=cell2mat(GLEAMeco(1));
    
    pred_data(obs_data(:)==0)=[];
    obs_data(obs_data(:)==0)=[];
    
    pred_data(obs_data(:)==NaN)=[];
    obs_data(obs_data(:)==NaN)=[];
    obs_data(pred_data(:)==NaN)=[];
    pred_data(pred_data(:)==NaN)=[];
    
%pn=polyfit(obs_data,pred_data,1)
%yy=polyval(pn,obs_data);
mdl = fitlm(obs_data,pred_data)
r2=mdl.Rsquared.Ordinary
lineSlope=double(mdl.Coefficients{2,1})
lineIntercep=double(mdl.Coefficients{1,1})
