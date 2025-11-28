% Habitual cleaning of the workspace
clear all;
close all;
clc;

%% Inputs
% These are the independent variables
All_TD_pct = [10 8 8 60 64 67]; % Y axis
All_VCN_bulk = [0.800 0.300 0.700 1.000 1.100 1.100]; % X axis
%% Calculations
% These two nested for loops run the whole show and solve the function for
% each combination of TD and VCN
for TDi = 1:length(All_TD_pct)
    TD_pct = All_TD_pct(TDi);
    VCN_bulk = All_VCN_bulk(TDi);
    VCN_true = VCN_bulk/(TD_pct/100); % Starting point for "input real VCN" which I call VCN_true
    fun = @(VCN_input)estimateTD(TD_pct,VCN_bulk,VCN_input); % Creates an instance of the function estimateTD which fixes VCN_bulk and TD_pct but leaves VCN_input variable
    x = fminbnd(fun,0,VCN_true); % Finds the value for VCN_true that minimizes the "qualcheck" equation
    [QC,output5plus(TDi),norm_geq5pct(TDi),prctofTDge5(TDi),output0(TDi),output1_4(TDi),copy_dist(TDi,1:51),P0(TDi,1)] = estimateTD(TD_pct,VCN_bulk,x); % Using x (the value the line above just found), this solves the function for the % of cells with >= 5 VCN
end
    outptTbl = array2table([All_TD_pct' All_VCN_bulk' copy_dist],'VariableNames',["TD%","Avg VCN",string([0:50])]);
    writetable(outptTbl,'VCNDistribution.xlsx');
clear TDi;

% I don't do anything to the calculation corresponding to the overlay here.
% As a result some distributions in that area could be unexpected.
% See "transduction.m" for the overlay we applied to fix the bottom of the Transduction Atlas plot.