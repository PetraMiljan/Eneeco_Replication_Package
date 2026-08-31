%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paper Zagreb 2025
% Analysis of the results - Proposed model
% Plot Figure 16
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Álvaro García Cerezo, Petra Miljan, Hrvoje Pandžić
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
close all;
clc;

%% Read the data

A = xlsread('results_OA_S2_X3_export.xlsx','alphaCVaRvector','B1:B11');
alphaVector = A(:,end);
alphaVector(1) = 0;

A = load('results_set2_pvScenarios.mat','probRepScen2');
probS = A.probRepScen2;
probS100 = round(probS*100);

A = xlsread('results_OA_S2_X3_export.xlsx','ProfitScen','D1:D40260');
aux = zeros(length(A),4);
cont = 0;
for ind1 = 1:10
    for ind2 = 1:366
        for ind3 = 1:11
            cont = cont+1;
            aux(cont,1) = ind1;
            aux(cont,2) = ind2;
            aux(cont,3) = ind3;
            aux(cont,end) = A(cont);
        end
    end
end
A = aux;
ProfitScen = zeros(size(A,1)/length(alphaVector)*10,length(alphaVector));
Aaux = [];
cont = 1;
for i = 1:size(A,1)
    Aaux = [Aaux;repmat(A(i,:),probS100(A(i,1)),1)];
end
for i = 1:length(alphaVector)
    ProfitScen(:,i) = Aaux(Aaux(:,3)==i,end);
end

%% CDF for alpha = 0.999

figg = figure;
for i = [11]
    fig = cdfplot(ProfitScen(:,i));
    set(fig,'LineWidth',2);
    if i == 1
        hold on;
    end
end
xlabel('Total profit (€)','Interpreter','tex','FontSize',16,'FontName','Times New Roman');
ylabel('Cumulative distribution function','Interpreter','tex','FontSize',16,'FontName','Times New Roman');
grid on;
set(gcf, 'Position', [100 100 800 400])
axis([3000 3900 0 1]);
title('');

set(gca,'TickLabelInterpreter','latex');
set(gca,'FontSize',14);

ax = gca;
inset = ax.TightInset;
extraMargin = 0.02;
left = inset(1) + extraMargin;
bottom = inset(2) + extraMargin;
right = inset(3) + extraMargin;
top = inset(4) + extraMargin;
width = 1 - left - right;
height = 1 - top - bottom;
ax.Position = [left, bottom, width, height];

hold off;

% Save the figure as .fig.
savefig(figg,'figure16.fig');
