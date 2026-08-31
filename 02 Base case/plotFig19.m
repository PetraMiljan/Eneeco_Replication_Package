%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paper Zagreb 2025
% Analysis of the results - Proposed model
% Plot Figure 19
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Álvaro García Cerezo, Petra Miljan, Hrvoje Pandžić
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
close all;
clc;

%% Read the data

A = xlsread('results_OA_export.xlsx','alphaCVaRvector','B1:B11');
alphaVector = A(:,end);
alphaVector(1) = 0;

A = xlsread('results_OA_export.xlsx','ProfitScen','D1:D805200');
aux = zeros(length(A),4);
cont = 0;
for ind1 = 1:200
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
ProfitScen = zeros(size(A,1)/length(alphaVector),length(alphaVector));
for i = 1:length(alphaVector)
    ProfitScen(:,i) = A(A(:,3)==i,end);
end

%% CDF for alpha = 0, 0.3, 0.6, 0.999

figg = figure;
for i = [1,4,7,11]
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
axis([2400 4600 0 1]);
legend('\alpha = 0','\alpha = 0.3','\alpha = 0.6','\alpha = 0.999','Location','northwest','Interpreter','tex','FontSize',12,'FontName','Times New Roman');
title('');

set(gca,'TickLabelInterpreter','latex');
set(gca,'FontSize',13);

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
savefig(figg,'figure19.fig');