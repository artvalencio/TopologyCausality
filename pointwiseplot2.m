function []=pointwiseplot2(cause,effect,xlinepos,ylinepos,L,delay,units,cause_name,effect_name,sz)
%POINTWISEPLOT Makes the pointwise informational measures for the optimal delay
% Cite:
% Valencio, A.L.S. An information-theoretical approach to identify seismic precursors 
%    and earthquake-causing variables. PhD thesis, University of Aberdeen.
% Bianco-Martinez, E. and Baptista, M.S. ('Space-time nature of causality', arXiv:1612.05023).
%--------------------------------------------------------
% Inputs:
%           cause,effect:  the time-series, provided as single columns of the data
%                  values, without timestamp.
%           xlinepos,ylinepos: vectors defining the position of the partition
%                  division lines, which defines marginal probabilities.
%           delay: delay of effects with respect to causes. An interval is provided, 
%	           and the optimal delay is obtained from data (maximal Causal Mutual Information)
%	    units: 'bits' (logarithms with base 2) or 'nats' (base e). Default: bits. 
%	    cause/effects_name: name of the variables, for the plot axis.
%	    sz: size of the scatter points.
%--------------------------------------------------------
% Outputs:
%           console: information about the optimal delay
%	    Figure 3: Variation of the information measures with the delay between cause and effect
%	    Figures 4 and 5: Pointwise information measures for the optimal delay
%--------------------------------------------------------
% Example:     
%	    pointwiseplot(x(:,1),x(:,2),0.5,0.5,0,10,'bits','X','Y',5)
%--------------------------------------------------------
% (C) Arthur Valencio* and Dr Murilo S. Baptista, 13 Jun 2018
%     ICSMB, University of Aberdeen
%     *Thanks a fellowship from CNPq, Brazil [206246/2014-5]
    
    [colorte,~,colormi,colorcami,~,colordiridx]= ...
        calcpointwise(cause,effect,L,L,xlinepos,ylinepos,1,delay,units);
    
    figure
    subplot(2,2,1)
    scatter(cause,effect,sz,colormi,'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6)
    title('PMI(X;Y)')
    xlabel(cause_name)
    ylabel(effect_name)
    colormap(jet);
    colorbar;
    subplot(2,2,2)
    scatter(cause,effect,sz,colorte,'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6)
    colormap(jet);
    colorbar;
    title('PTE_{X\rightarrow Y}')
    subplot(2,2,3)
    scatter(cause,effect,sz,colorcami,'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6)
    title('PCaMI_{X\rightarrow Y}')
    xlabel(cause_name)
    ylabel(effect_name)
    colormap(jet);
    colorbar;
    subplot(2,2,4)
    scatter(cause,effect,sz,colordiridx,'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6)
    title('PDI')
    xlabel(cause_name)
    ylabel(effect_name)
    colormap(jet);
    colorbar;
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.1,0.9, 0.9]);
end
