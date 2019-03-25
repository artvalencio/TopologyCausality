function [out]=kaplanyorke(length,alpha)

x(1)=rand;
a(1)=floor(100*rand);
y(1)=rand;
prime=1000003;

for t=2:length+5000
   a(t)=floor(mod(2*a(t-1),prime));
   x(t)=a(t-1)/prime;
   y(t)=alpha*y(t-1)+cos(4*pi()*x(t-1));
end

out=[x(5001:end)' y(5001:end)'];

end