function [ecami_xy,ecami_yx,emutual_info,ediridx,ete_xy,ete_yx] = errorcami(x,y,Lpast,Lfut,xdiv,ydiv,tau,units,n_trials)
%New calculation for error margins of infromation measures:
% largest information values obtained from shuffled data after n_trials
% (n_trials sufficiently large)
% This method preserves the marginal distributions of each variable, which
% might influence the error bounds



ecami_xy=0; ecami_yx=0; emutual_info=0; ediridx=0; ete_xy=0; ete_yx=0;


for i=1:n_trials
    
    if mod(i,10)==0
        disp('.')
    end
    
    
    x=x(randperm(length(x)));
    y=y(randperm(length(y)));
    
    [tempcami_xy,tempcami_yx,tempmutual_info,tempdiridx,tempte_xy,tempte_yx]=cami(x,y,Lpast,Lfut,xdiv,ydiv,tau,units);
    if abs(tempcami_xy)>ecami_xy
        ecami_xy=abs(tempcami_xy);
    end
    if abs(tempcami_yx)>ecami_yx
        ecami_yx=abs(tempcami_yx);
    end    
    if abs(tempmutual_info)>emutual_info
        emutual_info=abs(tempmutual_info);
    end
    if abs(tempdiridx)>ediridx
        ediridx=abs(tempdiridx);
    end
    if abs(tempte_xy)>ete_xy
        ete_xy=abs(tempte_xy);
    end
    if abs(tempte_yx)>ete_yx
        ete_yx=abs(tempte_yx);
    end  
end
    
    othererrdiridx=sqrt(ecami_xy^2+ecami_yx^2);
    ediridx=max(ediridx,othererrdiridx);
    
end