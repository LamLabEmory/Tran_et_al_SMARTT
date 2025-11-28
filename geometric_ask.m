clear all;
close all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set your pctTD and VCN of interest
pctTD = 80;
VCN = 4.0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This does the math based on Reggie's geometric method - output is the
% poisson distribution from k = 0 to 170 for the transducible cells.
% P(k=0) is simply 100-pctTD
pssnprime = zeroinflatedpssn(pctTD,VCN);

% Find all k values of pssnprime where P(k)>0.01. Simply doing this to plot
% the relevant range.
x2 = max(find(pssnprime>0.0001));

hold on;

% Plot
P = [(100-pctTD) 100*pssnprime(2:x2)];
bar([0:x2-1],P,'EdgeColor','none');

% Cosmetic stuff
set(gca,'FontName','Arial','FontWeight','bold','FontSize',12);
ylabel('P(k)');
xlabel('VCN');

% Display text
a = (100-pctTD);
b = sum(100*pssnprime(2:5));
c = pctTD-b;
text(x2,max(P)*0.95,['0 VCN = ' num2str(round(a,1)) '%'],'FontWeight','bold','FontSize',12,'FontName','Arial','HorizontalAlignment','right');
text(x2,max(P)*0.88,['1-4 VCN = ' num2str(round(b,1)) '%'],'FontWeight','bold','FontSize',12,'FontName','Arial','HorizontalAlignment','right');
text(x2,max(P)*0.81,['5+ VCN = ' num2str(round(c,1)) '%'],'FontWeight','bold','FontSize',12,'FontName','Arial','HorizontalAlignment','right');
text(x2,max(P)*0.74,['Sum = ' num2str(round(a+b+c,1)) '%'],'FontWeight','bold','FontSize',12,'FontName','Arial','HorizontalAlignment','right');

hold off;