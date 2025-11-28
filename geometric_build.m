clear all;
close all;
clc;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EDIT YOUR THRESHOLD HERE:
yourthreshold = 8;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EDIT YOUR RESOLUTION HERE:
AllpctTD = [0:0.5:100];
AllVCN = [0.025:0.025:5];
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This part calculates a matrix called results with each row (x, y, z) = (VCN pctTD %>=5/pctTD)
for i = 1:length(AllpctTD)
    for j = 1:length(AllVCN)
        pctTD = AllpctTD(i);
        VCN = AllVCN(j);

        if pctTD > 100*(1-exp(-VCN))
            results(i,j) = 0;
            C(i,j,1:3) = [1 1 1];
        else

            % See function file
            pssnprime = zeroinflatedpssn(pctTD,VCN);

            % Calculate result based on the threshold you specified above
            a = (100-pctTD);
            b = sum(100*pssnprime(2:yourthreshold-1+1));
            z = pctTD-b;
            results(i,j) = z/pctTD;
            clear a b;

            % Assign a color. Change colorme(results(i,j),0.XX) in line 39
            % to set start of intermediate yellow color on scale. Make sure
            % to change line 28 on geometric_plot.m as well.
            if ~isnan(results(i,j))
                [C(i,j,1),C(i,j,2),C(i,j,3)] = colorme(results(i,j),0.30);
            else
                C(i,j,1:3) = [1 1 1];
            end
        end
    end
    clear VCN;
    disp(AllpctTD(i)); % Displays pctTD so you know where you're at (finishes at 100)
end
clear pctTD;

save('geometric.mat','results',"AllpctTD",'AllVCN','C');