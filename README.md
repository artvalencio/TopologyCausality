# TopologyCausality
Codes for "The Topology of Causality" paper



--------------------------------

(CC-BY-4.0) Arthur Valencio[1,\*] and Murilo Baptista[2], 2019

[1] Institute of Computing (IC), State University of Campinas (Unicamp) \
    Research, Innovation and Dissemination Center for Neuromathematics (RIDC NeuroMat)\
    FAPESP support [2018/09900-8] (fellowship) and [2013/07699-0] (NeuroMat) \
    * arthur_valencio@physics.org
    
[2] Institute for Complex Systems and Mathematical Biology (ICSMB), University of Aberdeen

---------------------------------

The code consists of a function that calculates and build the plots of the pointwise information-theoretical measures for bivariate time-series, and three dynamical system generators:

 - Kaplan-Yorke system
 
 - Coupled logistic maps (Kaneko coupling)
 
 - Coupled Izhikevich neurons (simplified chemical synapse coupling)

----------------------------------

Usage on the paper:

 - Kaplan-Yorke: x=kaplanyorke(1e6,2/3);
 
 - Coupled logistic: x=coupledlogistic(1e6,4,[0 1;0 0],0.1,'kaneko');
 
 - Coupled Izhikevich: x=coupledizhikevich(1e6,0.02,0.2,-50,1,9.5,[0 1;0 0],0.05);

 - Plotwise function: [pmi,pte,pcami,pdi]=pointwiseplot(x(:,1),x(:,2),((max(x(:,1))-min(x(:,1)))/n)\*(1:n-1),((max(x(:,2))-min(x(:,2)))/n)\*(1:n-1),1,0,'bits','x','y',1);
 
 where n is the number of partitions in each variable
