clear all;
close all;
clc;

load("geometric.mat");

% this part plots the results

figure('Position',[10 50 1000 800]);
subplot(1,10,1:9);
set(gca,'FontSize',20,'FontWeight',"bold");
hold on;
surf(AllVCN,AllpctTD,results,C,'edgecolor','none');
vcn = [0:0.1:5];
plot3(vcn,100*(1-exp(-vcn)),[2*ones(1,length(vcn))],'LineWidth',2,'Color',[0 0 0]);
hold off;
xlabel('Average VCN','FontWeight','bold');
ylabel('% Gene-modified cells of total','FontWeight','bold');
zlabel('% with VCN \geq 5');
view(2);

subplot(1,10,10);
hold on;
set(gca,'FontSize',20,'FontWeight',"bold");
%%Change [r,g,b] = colorme(i/100,0.XX) to match line 39 in
%%geometric_build.m to set transition point for yellow on color scale
for i = 0:0.1:100
    [r,g,b] = colorme(i/100,0.3);
    plot(1,i+2,'s','MarkerSize',30,'MarkerFaceColor',[r g b],'MarkerEdgeColor',[r g b]);
end
hold off;
ylim([0 100]);
xticks([]);
clear i;