function [pssnprime] = zeroinflatedpssn(pctTD,VCN)

syms xx;
x = solve((pctTD/VCN)*xx == 100*(1-exp(-xx)),xx);
x = double(x);
y = (pctTD/VCN)*x; % same as y = 100*(1-exp(-x))
fracNTD = (1-pctTD/y);

lambda = x;

for k = 0:170 % matlab will return Inf for factorial(171) and greater
    pssn(k+1) = (lambda^k)*exp(-lambda)/factorial(k);
end
clear k;
pssnprime = (1-fracNTD)*pssn;