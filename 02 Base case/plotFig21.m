%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paper Zagreb 2025
% Analysis of the results - Hybrid model
% Plot Figure 21
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Álvaro García Cerezo, Petra Miljan, Hrvoje Pandžić
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
close all;
clc;

%% Read the data

A = xlsread('resultsHybridSPRO_Gamma_export.xlsx','GammaIBvector','B1:B25');
GammaIBvector = A(:,end);
GammaIBvector(1) = 0;

load('ProfitScen.mat');

%% CDF for Gamma = 0, 8, 11, 24

figg = figure;
for i = [1,9,12,25]
    fig = cdfplot(ProfitScen(:,i));
    if i == 1
        hold on;
    end
    set(fig,'LineWidth',2);
end
xlabel('Total profit (€)','Interpreter','tex','FontSize',16,'FontName','Times New Roman');
ylabel('Cumulative distribution function','Interpreter','tex','FontSize',16,'FontName','Times New Roman');
set(gcf, 'Position', [100 100 800 400]);
axis([-750 7000 0 1]);
legend('\Gamma = 0','\Gamma = 8','\Gamma = 11','\Gamma = 24',...
    'Location','northwest','Interpreter','tex','FontSize',12,'FontName','Times New Roman');
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
savefig(figg,'figure21.fig');
