function [v,u,t,ISI]=coupledizhikevich(a,b,c,d,A,tslen)
%Izhikevich model for coupled neurons.
%Each neuron exhibits chaotic behaviour for a=0.02, b=0.2,c=-52,d=1,I=10.5.
%A is the weigthed adjacency matrix for a coupling
%Example: [v,u,t,ISI]=coupledizhikevich(0.02,0.2,-52,1,[10.5 0 0.2 10.5],10000);
%Ref: https://www.nature.com/articles/s41598-017-01511-y

   tau=0.2;
   v(1,1:2)=-70;
   u(1,1:2)=-20;
   v(2:tslen+5000,1:2)=NaN;
   u(2:tslen+5000,1:2)=NaN;
   t(1)=0;
   k1=1;
   k2=1;
   for i=1:tslen+5000
       t(i+1)=t(i)+tau;
       v(i+1,1)=v(i,1)+tau*(0.04*v(i,1)^2+5*v(i,1)+140-u(i,1)+A(1,1)+A(1,2));
       u(i+1,1)=u(i,1)+tau*a*(b*v(i,1)-u(i,1));
       v(i+1,2)=v(i,2)+tau*(0.04*v(i,2)^2+5*v(i,2)+140-u(i,2)+A(2,2)+A(2,1));
       u(i+1,2)=u(i,2)+tau*a*(b*v(i,2)-u(i,2));
       if v(i,1)>30
           v(i+1,1)=c;
           u(i+1,1)=u(i,1)+d;
           peaktime(k1,1)=t(i);
           k1=k1+1;
       end  
       if v(i,2)>30
           v(i+1,2)=c;
           u(i+1,2)=u(i,2)+d;
           peaktime(k2,2)=t(i);
           k2=k2+1;
       end  
   end
   t=t(5002:end);
   v=v(5002:end,1:2);
   u=u(5002:end,1:2);
   ISI(:,1)=diff(peaktime(:,1));
   ISI(:,2)=diff(peaktime(:,2));
   ISI(ISI<0)=NaN;
end