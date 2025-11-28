function [qualcheck,output5plus,normoutput,percentoftransducedge5,output0,output1_4,P_adj,P0] = estimateTD(TD_pct,VCN_bulk,VCN_input)
k = [0:50];
cells_total = 1e5;
for i = 1:length(k)
    P_kL(i) = 100*(VCN_input.^k(i))*exp(-VCN_input)/factorial(k(i));
end
clear i;
P0 = P_kL(1);
UnTD = (100-TD_pct-P0)/(1-P0/100);
P_adj = [100-TD_pct (100-UnTD)*P_kL(2:51)/100];
for i = 1:length(P_adj)
    copy_dist(i) = round(cells_total*P_adj(i)/100)*k(i);
end
copies_total = sum(copy_dist);
copy_distout = copy_dist/copies_total;
VCN_pred = copies_total/cells_total;
qualcheck = abs(VCN_pred-VCN_bulk);
normoutput = sum(P_kL(6:length(P_kL)));
percentoftransducedge5 = sum(P_adj(6:length(P_adj)))/TD_pct;
output0 = P_adj(1);
output1_4 = sum(P_adj(2:5));
output5plus = sum(P_adj(6:length(P_adj)));
end