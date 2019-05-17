function []=simplestpointwiseplot(cause,effect,xlines,ylines,units,cause_name,effect_name,sz,L)
%SIMPLESTPOINTWISEPLOT Makes the pointwise informational measures
% Cite:
% Valencio, A., Grebogi, C. and Baptista, M.S. The topology of causality, in submission.
% Valencio, A.L.S. An information-theoretical approach to identify seismic precursors 
%    and earthquake-causing variables. PhD thesis, University of Aberdeen.
% Bianco-Martinez, E. and Baptista, M.S. (2018) Space-time nature of causality,
%    Chaos, 28, 075509, doi:10.1063/1.5019917.
%--------------------------------------------------------
% Inputs:
%           cause,effect:  the time-series, provided as single columns of the data
%                  values, without timestamp.
%           xlines,ylines: vectors defining the position of the partition
%                  division lines, which defines marginal probabilities.     
%	    units: 'bits' (logarithms with base 2) or 'nats' (base e). Default: bits. 
%	    cause/effects_name: name of the variables, for the axis of the plots.
%	    sz: size of the scatter points.
%--------------------------------------------------------
% Outputs:
%	    Figures: Pointwise information measures for the optimal delay
%--------------------------------------------------------
% Example:     
%	    pointwiseplot(x(:,1),x(:,2),linspace(0.1,1,3),linspace(0,1,3),'bits','X','Y',5)
%--------------------------------------------------------
% (CC-NC-4.0) Arthur Valencio [1,2]* and Dr Murilo S. Baptista [2], 8 May 2019
%     [1] Institute of Computing, State University of Campinas (Unicamp)
%     [2] ICSMB, University of Aberdeen
%     *AV is supported by FAPESP grant #2018/09900-8. Part of the activities 
%      of FAPESP  Research, Innovation and Dissemination Center for 
%      Neuromathematics (grant #2013/ 07699-0, S.Paulo Research Foundation).
%      Thanks a fellowship from CNPq grant #206246/2014-5 in the main development stages.
%--------------------------------------------------------

    %calculate
        [colorte,~,colormi,colorcami,~,colordiridx] = ...
            normalizedcalcpointwise(cause,effect,L,L,xlines,ylines,1,0,units);
    
    %plot mutual information and transfer entropy
    fig1=figure('visible','off');
    subplot(2,2,1)
    len=length(colormi(:));
    scatter(cause(1:len),effect(1:len),sz,colormi,'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6)
    title('Pointwise I(X;Y)')
    xlabel(cause_name)
    ylabel(effect_name)
    colormap(jet);
    colorbar;
    subplot(2,2,2)
    len=length(colorte(:));
    scatter(cause(1:len),effect(1:len),sz,colorte,'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6)
    title('Pointwise TE_{X\rightarrow Y}')
    xlabel(cause_name)
    ylabel(effect_name)
    colormap(jet);
    colorbar;
    %plot CaMI and Directionality Index
    subplot(2,2,3)
    len=length(colorcami(:));
    scatter(cause(1:len),effect(1:len),sz,colorcami,'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6)
    title('Pointwise CaMI_{X\rightarrow Y}')
    xlabel(cause_name)
    ylabel(effect_name)
    colormap(jet);
    colorbar;
    subplot(2,2,4)
    len=length(colordiridx(:));
    scatter(cause(1:len),effect(1:len),sz,colordiridx,'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6)
    title('Pointwise DirIdx')
    xlabel(cause_name)
    ylabel(effect_name)
    colormap(jet);
    colorbar; 
    disp('Done. Please wait while figure is saved...')
    set(fig1,'Position', get(0, 'Screensize'));
    saveas(fig1,'pointwisefigure.png');
    clear colorcode colorcode4 
end