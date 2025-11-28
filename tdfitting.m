clear all;
close all;
clc;

%% Parameters of estimation

% Total number of cells
CT = rmmissing(readmatrix('input.xlsx','Sheet','Experimental data input','Range','H2'));
% LV volume in microliters
LV_vol  = rmmissing(readmatrix('input.xlsx','Sheet','Experimental data input','Range','G2:G100'));

% Calculations
VC = LV_vol/CT;
VC_fine = [min(VC):1e-6:max(VC)];

%% Your experimental data
% Input data in excel file

pctTD(:,1) = rmmissing(readmatrix('input.xlsx','Sheet','Experimental data input','Range','A2:A100'));
pctTD(:,2) = rmmissing(readmatrix('input.xlsx','Sheet','Experimental data input','Range','B2:B100'));
VCN(:,1) = rmmissing(readmatrix('input.xlsx','Sheet','Experimental data input','Range','D2:D100'));
VCN(:,2) = rmmissing(readmatrix('input.xlsx','Sheet','Experimental data input','Range','E2:E100'));

%% Fit the experimental data
x = pctTD(:,1);
y = pctTD(:,2);
[f1,B1,k1] = fitme(x,y);

figure('Position',[10 50 1800 600]);
subplot(1,2,1);
hold on;
scatter(x,y,50,'o','MarkerFaceColor','none','LineWidth',2);
plot(VC_fine,f1(VC_fine));
scatter(VC,f1(VC),10,'s','LineWidth',2);
text(0.8*max(x),0.5*B1,['B = ' num2str(B1) '\newline' 'k = ' num2str(k1)]);
hold off;
title('Projected expression');
xlabel('LV volume per cell (\muL/cell)');
ylabel('% Transduced')
set(gca,'FontSize',12);
legend({'Experimental data','Hyperbolic fit'},'Location','southeast');

subplot(1,2,2);
x = VCN(:,1);
y = VCN(:,2);
[f2,B2,k2] = fitme(x,y);

subplot(1,2,2);
hold on;
scatter(x,y,50,'o','MarkerFaceColor','none','LineWidth',2);
plot(VC_fine,f2(VC_fine));
scatter(VC,f2(VC),10,'s','LineWidth',2);
text(0.8*max(x),0.5*B2,['B = ' num2str(B2) '\newline' 'k = ' num2str(k2)]);
hold off;
title('Projected VCN');
xlabel('LV volume per cell (\muL/cell)');
ylabel('VCN (cell^{-1})');
set(gca,'FontSize',12);
legend({'Experimental data','Hyperbolic fit'},'Location','southeast');


%% Estimate transduction based on the zero-inflated Poisson model
% This uses the LV volumes that are defined at the beginning of this script


for i = 1:length(VC)
    TD_pct = f1(VC(i));
    VCN_bulk = f2(VC(i));
    VCN_true = VCN_bulk/(TD_pct/100); % Starting point for "input real VCN" which I call VCN_true
    fun = @(VCN_input)estimateTD(TD_pct,VCN_bulk,VCN_input); % Creates an instance of the function estimateTD which fixes VCN_bulk and TD_pct but leaves VCN_input variable
    x = fminbnd(fun,0,VCN_true); % Finds the value for VCN_true that minimizes the "qualcheck" equation
    [QC,output5plus(i),norm_geq5pct(i),prctofTD(i),output0(i),output1_4(i)] = estimateTD(TD_pct,VCN_bulk,x); % Using x (the value the line above just found), this solves the function for the % of cells with >= 5 VCN
end

T = table(0,0,0,0,0,'VariableNames',{'LV volume','LV volume/cell (uL/cell)','% cells with 0 copies','% cells with 1-4 copies','%cells with 5+ copies'});
T{1:length(LV_vol),1:5} = [LV_vol,VC,round(output0',2),round(output1_4',2),round(output5plus',2)];
disp(T);
writetable(T,'output.xlsx');

%% Functions

function [cf,B,k] = fitme(x,y)
% Defines form of the equation to fit
ft = fittype('B.*x./(x+k)',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'B','k'});
% Defines fit method and starting point for coefficients
fo = fitoptions('method','NonlinearLeastSquares','StartPoint',[max(y) 1e-6]);
% Performs fit
[cf,G]=fit(x,y,ft,fo);
B = cf.B;
k = cf.k;
end