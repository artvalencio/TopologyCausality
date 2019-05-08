function []=simplepointwiseplot(cause,effect,xlines,ylines,units,cause_name,effect_name,sz)
%SIMPLEPOINTWISEPLOT Makes the pointwise informational measures for the optimal delay
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
    for L=1:4
        [colorte{L},invcolorte{L},colormi{L},colorcami{L},invcolorcami{L},...
            colordiridx{L},~,~,cami_xy(L),cami_yx(L),mi(L),diridx(L),...
            te_xy(L),te_yx(L)] = ...
            calcpointwise(cause,effect,L,L,xlines,ylines,1,0,units);
    end
    
    %plot mutual information and transfer entropy
    fig1=figure;
    subplot(4,2,1)
    len=length(colormi{1}(:));
    colorcode3(1:len)=colormi{1};
    scatter(cause(1:len),effect(1:len),sz,colorcode3(1:len),'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6)
    title('Pointwise I(X;Y), L=1')
    xlabel(cause_name)
    ylabel(effect_name)
    colormap(jet);
    colorbar;
    subplot(4,2,2)
    len=length(colorte{1}(:));
    colorcode2(1:len)=colorte{1};
    scatter(cause(1:len),effect(1:len),sz,colorcode2(1:len),'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6)
    title('Pointwise TE_{X\rightarrow Y}, L=1')
    xlabel(cause_name)
    ylabel(effect_name)
    colormap(jet);
    colorbar;
    clear colorcode2 colorcode3 
    subplot(4,2,3)
    len=length(colormi{2}(:));
    colorcode3(1:len)=colormi{2};
    scatter(cause(1:len),effect(1:len),sz,colorcode3(1:len),'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6)
    title('Pointwise I(X;Y), L=2')
    xlabel(cause_name)
    ylabel(effect_name)
    colormap(jet);
    colorbar;
    subplot(4,2,4)
    len=length(colorte{2}(:));
    colorcode2(1:len)=colorte{2};
    scatter(cause(1:len),effect(1:len),sz,colorcode2(1:len),'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6)
    title('Pointwise TE_{X\rightarrow Y}, L=2')
    xlabel(cause_name)
    ylabel(effect_name)
    colormap(jet);
    colorbar;
    clear colorcode2 colorcode3 
    subplot(4,2,5)
    len=length(colormi{3}(:));
    colorcode3(1:len)=colormi{3};
    scatter(cause(1:len),effect(1:len),sz,colorcode3(1:len),'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6)
    title('Pointwise I(X;Y), L=3')
    xlabel(cause_name)
    ylabel(effect_name)
    colormap(jet);
    colorbar;
    subplot(4,2,6)
    len=length(colorte{3}(:));
    colorcode2(1:len)=colorte{3};
    scatter(cause(1:len),effect(1:len),sz,colorcode2(1:len),'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6)
    title('Pointwise TE_{X\rightarrow Y}, L=3')
    xlabel(cause_name)
    ylabel(effect_name)
    colormap(jet);
    colorbar;
    clear colorcode2 colorcode3 
    subplot(4,2,7)
    len=length(colormi{4}(:));
    colorcode3(1:len)=colormi{4};
    scatter(cause(1:len),effect(1:len),sz,colorcode3(1:len),'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6)
    title('Pointwise I(X;Y), L=4')
    xlabel(cause_name)
    ylabel(effect_name)
    colormap(jet);
    colorbar;
    subplot(4,2,8)
    len=length(colorte{4}(:));
    colorcode2(1:len)=colorte{4};
    scatter(cause(1:len),effect(1:len),sz,colorcode2(1:len),'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6)
    title('Pointwise TE_{X\rightarrow Y}, L=4')
    xlabel(cause_name)
    ylabel(effect_name)
    colormap(jet);
    colorbar;
    set(fig1,'Position', get(0, 'Screensize'));
    
    %plot CaMI and Directionality Index
    fig2=figure;
    subplot(4,2,1)
    len=length(colorcami{1}(:));
    colorcode(1:len)=colorcami{1};
    scatter(cause(1:len),effect(1:len),sz,colorcode(1:len),'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6)
    title('Pointwise CaMI_{X\rightarrow Y}, L=1')
    xlabel(cause_name)
    ylabel(effect_name)
    colormap(jet);
    colorbar;
    subplot(4,2,2)
    len=length(colordiridx{1}(:));
    colorcode4(1:len)=colordiridx{1};
    scatter(cause(1:len),effect(1:len),sz,colorcode4(1:len),'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6)
    title('Pointwise DirIdx, L=1')
    xlabel(cause_name)
    ylabel(effect_name)
    colormap(jet);
    colorbar; 
    clear colorcode colorcode4 
    subplot(4,2,3)
    len=length(colorcami{2}(:));
    colorcode(1:len)=colorcami{2};
    scatter(cause(1:len),effect(1:len),sz,colorcode(1:len),'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6)
    title('Pointwise CaMI_{X\rightarrow Y}, L=2')
    xlabel(cause_name)
    ylabel(effect_name)
    colormap(jet);
    colorbar; 
    subplot(4,2,4)
    len=length(colordiridx{2}(:));
    colorcode4(1:len)=colordiridx{2};
    scatter(cause(1:len),effect(1:len),sz,colorcode4(1:len),'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6)
    title('Pointwise DirIdx, L=2')
    xlabel(cause_name)
    ylabel(effect_name)
    colormap(jet);
    colorbar;
    clear colorcode colorcode4 
    subplot(4,2,5)
    len=length(colorcami{3}(:));
    colorcode(1:len)=colorcami{3};
    scatter(cause(1:len),effect(1:len),sz,colorcode(1:len),'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6)
    title('Pointwise CaMI_{X\rightarrow Y}, L=3')
    xlabel(cause_name)
    ylabel(effect_name)
    colormap(jet);
    colorbar;
    subplot(4,2,6)
    len=length(colordiridx{3}(:));
    colorcode4(1:len)=colordiridx{3};
    scatter(cause(1:len),effect(1:len),sz,colorcode4(1:len),'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6)
    title('Pointwise DirIdx, L=3')
    xlabel(cause_name)
    ylabel(effect_name)
    colormap(jet);
    colorbar;
    clear colorcode colorcode4 
    subplot(4,2,7)
    len=length(colorcami{4}(:));
    colorcode(1:len)=colorcami{4};
    scatter(cause(1:len),effect(1:len),sz,colorcode(1:len),'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6)
    title('Pointwise CaMI_{X\rightarrow Y}, L=4')
    xlabel(cause_name)
    ylabel(effect_name)
    colormap(jet);
    colorbar;
    subplot(4,2,8)
    len=length(colordiridx{4}(:));
    colorcode4(1:len)=colordiridx{4};
    scatter(cause(1:len),effect(1:len),sz,colorcode4(1:len),'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6)
    title('Pointwise DirIdx, L=4')
    xlabel(cause_name)
    ylabel(effect_name)
    colormap(jet);
    colorbar;
    set(fig1,'Position', get(0, 'Screensize'));
    set(fig2,'Position', get(0, 'Screensize'));
end
