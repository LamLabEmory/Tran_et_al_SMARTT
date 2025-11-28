clear all;
close all;
clc;

%% Results of calculations above were saved in the file mapdata.mat
load('mapdata_0_15.mat');
load('overlay2.mat');

C_over_color(:,:,1) = C_over;
C_over_color(:,:,2) = C_over*0;
C_over_color(:,:,3) = C_over*0;

%% Plot stuff
figure('Position',[10 10 1000 800]);
subplot(1,10,1:9);
set(gca,'FontSize',20,'FontWeight',"bold")
hold on;
surf(All_VCN_bulk,All_TD_pct,prctTDofmax,C,'edgecolor','none');
surf(0.01:0.01:15.0,0.01:0.01:40.0,89*C_over,C_over_color,'EdgeColor','none');
% TrialLegendNames{1} = '';
% TrialLegendNames{2} = '';
% for i = 1:length(trial)
%     scatter3([trial(i).VCN],[trial(i).PGM],90*ones(length([trial(i).VCN]),1),100,trialsymbol{mod(i,15)+1},'MarkerFaceColor',trialcolors{mod(i,7)+1},'MarkerEdgeColor',[0 0 0]);
%     TrialLegendNames{i+2} = trial(i).name;
% end
% clear i;
hold off;
xlabel('Average VCN','FontWeight','bold');
ylabel('% Gene-modified cells of total','FontWeight','bold');
zlabel('% with VCN \geq 5');
view(2);
xlim([0 15]);
% legend(TrialLegendNames,'location','northwest');
set(gca,'FontSize',16);

subplot(1,10,10);
colororder({'white','black'});
hold on;
yticks([]);
yyaxis right;
cmapmax = 2000;
for i = 1:cmapmax
    scatter(0.5,100*i/cmapmax,200,'_','MarkerEdgeColor',[i/cmapmax 1-i/cmapmax 0],'MarkerFaceColor',[i/cmapmax 1-i/cmapmax 0]);
end
hold off;
ylim([0 100]);
xlim([0.3 0.6]);
xticks([]);
set(gca,'XColor','none');
set(gca,'color','none');
ylabel('% transduced cells with VCN \geq 5','rotation',270,'VerticalAlignment','middle','FontWeight','bold','Position',[0.85 50]);
set(gca,'FontSize',16);
box off;
