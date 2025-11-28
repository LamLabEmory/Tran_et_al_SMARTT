% Habitual cleaning of the workspace
clear all;
close all;
clc;

% tic; % start point for a timer that displays how long it takes MATLAB to run the script
% 
% %% Resolution adjustments
% % These are the independent variables; each is a vector of the form
% % [min:stepsize:max]. Decrease step size to generate higher resolution
% % watermelon (takes longer to compute).
% All_TD_pct = [0.01:0.01:100]; % Y axis
% All_VCN_bulk = [0.01:0.01:6]; % X axis
% 
%% Trial data imported here
trialdata = rmmissing(readtable('trialdata.xlsx','Sheet','Trial data input','Range','A1:C1000','ReadVariableNames',true));
distincttrials = tabulate(trialdata.Name);
for i = 1:length(distincttrials) % Note you'll get an error if you have fewer than 3 trials
    trial(i).name = distincttrials{i,1};
    k = 1;
    for j = 1:length(trialdata.VCN)
        if strcmp(trialdata.Name{j},trial(i).name)
            trial(i).VCN(k) = trialdata.VCN(j);
            trial(i).PGM(k) = trialdata.PGMOT(j);
            k = k+1;
        end
    end
    clear k;
end
clear i;
clear j;

% arrays for symbols and groups for trialdata
% note that I use a modulus function in the i loop that references these
% variables so the elements are used sequentially starting with the 2nd
% element in the array
trialsymbol = {'|','o','s','^','v','d','p','h','<','>','+','x','*','.','_'};
trialcolors = {[0.6350 0.0780 0.1840],[0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250],[0.4940 0.1840 0.5560],[1 0 1],[0.3010 0.7450 0.9330]};

% %% Calculations
% % These two nested for loops run the whole show and solve the function for
% % each combination of TD and VCN
% for TDi = 1:length(All_TD_pct)
%     TD_pct = All_TD_pct(TDi);
%     for VCNi = 1:length(All_VCN_bulk)
%         VCN_bulk = All_VCN_bulk(VCNi);
%         VCN_true = VCN_bulk/(TD_pct/100); % Starting point for "input real VCN" which I call VCN_true
%         fun = @(VCN_input)estimateTD(TD_pct,VCN_bulk,VCN_input); % Creates an instance of the function estimateTD which fixes VCN_bulk and TD_pct but leaves VCN_input variable
%         x = fminbnd(fun,0,VCN_true); % Finds the value for VCN_true that minimizes the "qualcheck" equation
%         [QC,output5plus(TDi,VCNi),norm_geq5pct(TDi,VCNi),prctofTDge5(TDi,VCNi),output0(TDi,VCNi),output1_4(TDi,VCNi)] = estimateTD(TD_pct,VCN_bulk,x); % Using x (the value the line above just found), this solves the function for the % of cells with >= 5 VCN
%     end
% end
% clear TDi;
% clear VCNi;
% 
% %% Envelope for visualization purposes
% % This block calculates the "envelope" (theoretical maximum TD % for any
% % VCN i.e. the non-inflated condition)
% P_envelope = 100*exp(-All_VCN_bulk); % This is P_0 for the unadjusted Poisson equation at the given bulk VCN
% % The for loop below makes a matrix called Z_envelope which is a binary
% % representation of whether each cell falls above or on/below the envelope
% % line
% for VCNi = 1:length(All_VCN_bulk)
%     for TDi = 1:length(All_TD_pct)
%         if All_TD_pct(TDi) > (100-P_envelope(VCNi))
%             Z_envelope(TDi,VCNi) = 0;
%         elseif All_TD_pct(TDi) <= (100-P_envelope(VCNi))
%             Z_envelope(TDi,VCNi) = 1;
%         end
%     end
% end
% clear VCNi;
% clear TDi;
% clear i;
% clear j;
% % This makes the color matrix (dimensions are X x Y x 3)
% prctofTD_max = max(max(prctofTDge5));
% [a b] = size(prctofTDge5);
% for i = 1:a
%     for j = 1:b
%         C(i,j,1) = 1-prctofTDge5(i,j)/prctofTD_max; % 1 minus R value
%         C(i,j,2) = (prctofTDge5(i,j)/prctofTD_max); % 1 minus G value
%         C(i,j,3) = 1;                               % 1 minus B value
%     end
% end
% 
% % This multiplies each element in Z_envelope by the solution so that the
% % plots appear with the envelope
% [a b] = size(Z_envelope);
% for i = 1:a
%     for j = 1:b
%         output5plus(i,j) = output5plus(i,j)*Z_envelope(i,j);
%         prctTDofmax(i,j) = prctofTDge5(i,j)*Z_envelope(i,j)/prctofTD_max;
%     end
% end
% clear i;
% clear j;
% clear a;
% clear b;
% 
% % This multiplies each element in Z_envelope by C (the color valeues) so
% % that the plots appear with the envelope. It's a bit roundabout doing 1-C
% % but the reason for this is so the zero values (i.e. outside the envelope)
% % end up with the color [1,1,1] (white) instead of [0,0,0] (black)
% [a b] = size(Z_envelope);
% for i = 1:a
%     for j = 1:b
%         C(i,j,1) = 1-C(i,j,1)*Z_envelope(i,j);
%         C(i,j,2) = 1-C(i,j,2)*Z_envelope(i,j);
%         C(i,j,3) = 1-C(i,j,3)*Z_envelope(i,j);
%     end
% end
% clear i;
% clear j;
% clear a;
% clear b;

% % This calculates the overlay to account for the calculation error at
% % bottom of watermelon
% clear x y;
% for x = 0.01:0.01:15.0
%     for y = 0.01:0.01:40.0
%         if y<=(x*20/6)
%             C_over(round(y*100),round(x*100)) = 1;
%         else
%             C_over(round(y*100),round(x*100)) = NaN;
%         end
%     end
% end
% clear x y;
% save('overlay2.mat','C_over');

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
TrialLegendNames{1} = '';
TrialLegendNames{2} = '';
for i = 1:length(trial)
    scatter3([trial(i).VCN],[trial(i).PGM],90*ones(length([trial(i).VCN]),1),100,trialsymbol{mod(i,15)+1},'MarkerFaceColor',trialcolors{mod(i,7)+1},'MarkerEdgeColor',[0 0 0]);
    TrialLegendNames{i+2} = trial(i).name;
end
clear i;
hold off;
xlabel('Average VCN','FontWeight','bold');
ylabel('% Gene-modified cells of total','FontWeight','bold');
zlabel('% with VCN \geq 5');
view(2);
xlim([0 5]);%Change the second value to modify the x-axis
legend(TrialLegendNames,'location','northwest');
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

%% Output table
writematrix([[[NaN] [All_VCN_bulk]]; [[All_TD_pct'] [output5plus]];],'watermelon_table.csv');
% toc;