function [colorte,invcolorte,colormi,colorcami,invcolorcami,colordiridx,...
    pcami_xy,pcami_yx] = ...
    normalizedcalcpointwise(x,y,l_past,l_future,xlinepos,ylinepos,tau,delay,units)
% CAMI Calculates the Causal Mutual Information (CaMI) for a bivariate time-series
% Cite:
% Valencio, A.L.S. An information-theoretical approach to identify seismic precursors 
%    and earthquake-causing variables. PhD thesis, University of Aberdeen.
% Bianco-Martinez, E. and Baptista, M.S. ('Space-time nature of causality', arXiv:1612.05023)
%--------------------------------------------------------
% Inputs:
%            x,y:  the time-series, provided as single columns of the data
%                  values, without timestamp.
%           lx,ly: length of the symbolic sequence for analysis in x and y
%                  (e.g.: lx=2 ly=5: blocks of 2 points in variable x and 
%                  5 points in variable y will be analysed. In this case, 
%                  causality is measured considering 2 points of the past
%                  of one time-series, and 2 points of the past and 3 points
%                  of the future of the other time-series.
%           xlinepos,ylinepos: vectors defining the position of the partition
%                  division lines, which defines marginal probabilities.
%           tau: time-delay of the time-Poincare mapping. If time-series is 
%                  already generated by a map, the user should set tau to 1. 
%                  Otherwise, for "continuous time-series" the user should find
%                  the tau leading to minimisation of cross correlation, or 
%                  maximal of mutual information or maximal of CaMI. This 
%                  strategy seeks to create a time-Poincare mapping that will 
%                  behave as a Markov system by the partition chosen (lx,ly).
%           delay: delay of effects in Y with respect to causes in X.
%	    units: 'bits' (logarithms with base 2) or 'nats' (base e). Default: bits. 
%
%--------------------------------------------------------
% Outputs:
%           color: Colour-coding of (x,y) points with the Pointwise Causal Mutual Information x->y          
%           invcolor: Colour-coding of (x,y) points with the Pointwise Causal Mutual Information y->x               
%           pcami_xy: Pointwise Causal Mutual Information x -> y
%           pcami_yx: Pointwise Causal Mutual Information y -> x
%           cami_xy: Causal Mutual Information x -> y
%           cami_yx: Causal Mutual Information y -> x
%           mi:      Mutual Information between x and y,
%                    calculated using symbolic sequences
%                    of length lx in variables x and y. 
%           diridx:  Directionality Index, defined as CaMI(x->y)-CaMI(y->x),
%                    positive if flow of information is x -> y
%           te_xy:   Transfer Entropy x -> y
%           te_yx:   Transfer Entropy y -> x
%--------------------------------------------------------
% Example:     
%	    
%--------------------------------------------------------
% (C) Arthur Valencio* and Dr Murilo S. Baptista, 13 Jun 2018
%     ICSMB, University of Aberdeen
%     *Thanks a fellowship from CNPq, Brazil [206246/2014-5]

lx=l_past;
ly=l_past+l_future;

%check consistency
    if length(x)~=length(y)
        error('x and y must be of same size!')
    end
    if length(xlinepos)~=length(ylinepos)
        error('xlinepos and ylinepos must be of same size!')
    end
    ns=length(xlinepos)+1; %partition resolution

%calculating symbols
    for n=1:length(x) %assign data points to partition symbols in x
        Sx(n)=-1;
        for i=1:length(xlinepos)
            if x(n)<xlinepos(i)
                Sx(n)=i-1;
                break;
            end
        end
        if Sx(n)==-1
            Sx(n)=ns-1;
        end
    end
    for n=1:length(y) %assign data points to partition symbols in y
        Sy(n)=-1;
        for i=1:length(ylinepos)
            if y(n)<ylinepos(i)
                Sy(n)=i-1;
                break;
            end
        end
        if Sy(n)==-1
            Sy(n)=ns-1;
        end
    end
    
    [p_xp,p_yp,p_yf,p_ypf,p_xyp,p_xypf,phi_x,phi_yp,phi_yf]=...
        getprobabilities(Sx,Sy,lx,ly,ns,tau,delay,length(x));
    
    %Calculating mutual information
    for i=1:ns^lx
        for j=1:ns^lx
            if (p_xp(i)*p_yp(j)>1e-14)&&(p_xyp(i,j)>1e-14)
                pmi(i,j)=-(log(p_xyp(i,j)/(p_xp(i)*p_yp(j))))/(log(p_xyp(i,j)));
		if units~='nats'
                	pmi(i,j)=pmi(i,j)/log(2);
        end
            end
        end
    end
    
    %Calculating CaMI X->Y
    for i=1:ns^lx
        for j=1:ns^lx
            for k=1:1:ns^(ly-lx)
                if (p_xp(i)*p_ypf(j,k)>1e-14) && (p_xypf(i,j,k)>1e-14)
                    pcami_xy(i,j,k)=-(log(p_xypf(i,j,k)/(p_xp(i)*p_ypf(j,k))))/(log(p_xypf(i,j,k)));
                    pte_xy(i,j,k)=-(log((p_xypf(i,j,k)*p_yp(j))/(p_xyp(i,j)*p_ypf(j,k))))/(log(p_xypf(i,j,k)));
		    if units~='nats'
                    	pcami_xy(i,j,k)=pcami_xy(i,j,k)/log(2);
                    	pte_xy(i,j,k)=pte_xy(i,j,k)/log(2);
            end
                end
            end
        end
    end
    
   
    colorcami(1:length(x))=NaN;
    colormi(1:length(x))=NaN;
    colorte(1:length(x))=NaN;
    invcolorcami(1:length(x))=NaN;
    invcolorte(1:length(x))=NaN;
    
    for i=1:length(x)-lx
        pos=i+lx;
        if and(and(~isnan(phi_x(pos)),~isnan(phi_yp(pos))),~isnan(phi_yf(pos)))
            colorcami(i)=pcami_xy(phi_x(pos)+1,phi_yp(pos)+1,phi_yf(pos)+1);
            colormi(i)=pmi(phi_x(pos)+1,phi_yp(pos)+1);
            colorte(i)=pte_xy(phi_x(pos)+1,phi_yp(pos)+1,phi_yf(pos)+1); 
        end
    end
    
    colormi=colormi+abs(min(colormi));
    
    %Calculating CaMI Y->X
    [ip_x,ip_yp,ip_yf,ip_ypf,ip_xyp,ip_xypf,iphi_x,iphi_yp,iphi_yf]=getprobabilities(Sy,Sx,lx,ly,ns,tau,delay,length(x));
    for i=1:ns^lx
        for j=1:ns^lx
            for k=1:1:ns^(ly-lx)
                if (ip_x(i)*ip_ypf(j,k)>1e-14)&&(ip_xypf(i,j,k)>1e-14)
                    pcami_yx(i,j,k)=-log(ip_xypf(i,j,k)/(ip_x(i)*ip_ypf(j,k)))/(log(ip_xypf(i,j,k)));
                    pte_yx(i,j,k)=-log((ip_xypf(i,j,k)*ip_yp(j))/(ip_xyp(i,j)*ip_ypf(j,k)))/(log(ip_xypf(i,j,k)));
		    if units~='nats'                    
			pcami_yx(i,j,k)=pcami_yx(i,j,k)/log(2);
                    	pte_yx(i,j,k)=pte_yx(i,j,k)/log(2);
            end
                end
            end
        end
    end
   
    
    for i=1:ns^lx
        for j=1:ns^lx
            if (ip_x(i)*ip_yp(j)>1e-14)&&(ip_xyp(i,j)>1e-14)
                ipmi(i,j)=-(log(ip_xyp(i,j)/(ip_x(i)*ip_yp(j))))/(log(ip_xyp(i,j)));
		if units~='nats'
                	ipmi(i,j)=ipmi(i,j)/log(2);
        end
            end
        end
    end 
    
   for i=1:length(x)-lx
          pos=i+lx;
       if and(and(~isnan(iphi_x(pos)),~isnan(iphi_yp(pos))),~isnan(iphi_yf(pos))) 
            invcolorcami(i)=pcami_yx(iphi_x(pos)+1,iphi_yp(pos)+1,iphi_yf(pos)+1);
            invcolorte(i)=pte_yx(iphi_x(pos)+1,iphi_yp(pos)+1,iphi_yf(pos)+1);
       end
   end
    
   colordiridx=colorte-invcolorte;  
    

    
end


function [p_xp,p_yp,p_yf,p_ypf,p_xyp,p_xypf,phi_x,phi_yp,phi_yf]=getprobabilities(Sx,Sy,lx,ly,ns,tau,delay,len)
% calculates the values of phi and probabilities used for CaMI and mutual information

    %initializing phi: removing points out-of-reach (start-end)
    phi_x(1:tau*lx)=NaN;
    phi_yp(1:tau*lx)=NaN;
    phi_yf(1:tau*lx)=NaN;
    phi_x(len-tau*(ly-lx):len)=NaN;
    phi_yp(len-tau*(ly-lx):len)=NaN;
    phi_yf(len-tau*(ly-lx):len)=NaN;
    %initializing probabilities of boxes
    p_xp(1:ns^lx+1)=0;
    p_yp(1:ns^lx+1)=0;
    p_yf(1:ns^(ly-lx)+1)=0;
    p_ypf(1:ns^lx+1,1:ns^(ly-lx)+1)=0;
    p_xyp(1:ns^lx+1,1:ns^lx+1)=0;
    p_xypf(1:ns^lx+1,1:ns^lx+1,1:1:ns^(ly-lx)+1)=0;
    %calculating phi_x, about the past of x
    for n=tau*lx+1:len-tau*(ly-lx)
        phi_x(n)=0;
        k=n-lx;%running index for sum over tau-spaced elements
        for i=n-tau*lx:tau:n-tau
            phi_x(n)=phi_x(n)+Sx(k)*ns^((n-1)-k);
            k=k+1;
        end
        p_xp(phi_x(n)+1)=p_xp(phi_x(n)+1)+1;
    end
    p_xp=p_xp/sum(p_xp);
    %calculating phi_yp, about the past of y
    for n=tau*lx+1:len-tau*(ly-lx)-delay
        phi_yp(n)=0;
        k=n-lx;
        if delay>=0
            for i=n-tau*lx:tau:n-tau
                phi_yp(n)=phi_yp(n)+Sy(k+delay)*ns^((n-1)-k);
                k=k+1;
            end
        else
            if n==len-tau*(ly-lx)
                break;
            end
            for i=n-tau*lx:tau:n-tau
                if k+delay>1
                    phi_yp(n)=phi_yp(n)+Sy(k+delay)*ns^((n-1)-k);
                    k=k+1;
                end
            end
        end
            p_yp(phi_yp(n)+1)=p_yp(phi_yp(n)+1)+1;
    end
    p_yp=p_yp/sum(p_yp);
    %calculating phi_yf, about the future of y
    for n=tau*lx+1:len-tau*(ly-lx)-delay
        phi_yf(n)=0;
        k=n;
        if delay>=0
            for i=n:tau:n+tau*(ly-lx)-1
                phi_yf(n)=phi_yf(n)+Sy(k+delay)*ns^((n+(ly-lx)-1)-k);
                k=k+1;
            end
        else
            if n==len-tau*(ly-lx)
                break;
            end
            for i=n-tau*lx:tau:n-tau
                if k+delay>1
                    phi_yf(n)=phi_yf(n)+Sy(k+delay)*ns^((n+(ly-lx)-1)-k);
                    k=k+1;
                end
            end
        end
        p_yf(phi_yf(n)+1)=p_yf(phi_yf(n)+1)+1;
    end
    p_yf=p_yf/sum(p_yf);
    %calculating joint probabilities
    if delay>=0
        for n=tau*lx+1:len-tau*(ly-lx)-delay
            p_ypf(phi_yp(n)+1,phi_yf(n)+1)=p_ypf(phi_yp(n)+1,phi_yf(n)+1)+1;
            p_xyp(phi_x(n)+1,phi_yp(n)+1)=p_xyp(phi_x(n)+1,phi_yp(n)+1)+1;
            p_xypf(phi_x(n)+1,phi_yp(n)+1,phi_yf(n)+1)=p_xypf(phi_x(n)+1,phi_yp(n)+1,phi_yf(n)+1)+1;
        end
    else
        for n=tau*lx+1-delay:len-tau*(ly-lx)
            p_ypf(phi_yp(n)+1,phi_yf(n)+1)=p_ypf(phi_yp(n)+1,phi_yf(n)+1)+1;
            p_xyp(phi_x(n)+1,phi_yp(n)+1)=p_xyp(phi_x(n)+1,phi_yp(n)+1)+1;
            p_xypf(phi_x(n)+1,phi_yp(n)+1,phi_yf(n)+1)=p_xypf(phi_x(n)+1,phi_yp(n)+1,phi_yf(n)+1)+1;
        end
    end
    p_ypf=p_ypf/sum(sum(p_ypf));
    p_xyp=p_xyp/sum(sum(p_xyp));
    p_xypf=p_xypf/sum(sum(sum(p_xypf)));
end