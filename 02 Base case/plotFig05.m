%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paper Zagreb 2025
% Analysis of the results - Hybrid model
% Profit for different values of Gamma
% Plot Figure 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Álvaro García Cerezo, Petra Miljan, Hrvoje Pandžić
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% I analyze the profit for different values of Gamma.

clear;
close all;
clc;

%% Read the data

A = xlsread('resultsHybridSPRO_Gamma_export.xlsx','GammaIBvector','B1:B25');
GammaIBvector = A(:,end);
GammaIBvector(1) = 0;

A = xlsread('resultsHybridSPRO_Gamma_export.xlsx','ofHSPROvector','B1:B25');
ProfitGamma = A(:,end);

%% Profit for all Gamma

fig = figure;
plot(GammaIBvector,ProfitGamma,'o-','LineWidth',2);
xlabel('Uncertainty level, \Gamma^{\rm{IB}} (h)','Interpreter','tex','FontSize',16,'FontName','Times New Roman');
ylabel('Total expected profit (€)','Interpreter','tex','FontSize',16,'FontName','Times New Roman');
ymin = 2000;
ymax = 10000;
set(gcf, 'Position', [100 100 800 400])
xticks(GammaIBvector);
axis([min(GammaIBvector) max(GammaIBvector) ymin ymax]);
grid on;

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

% Save the figure as .fig.
savefig(fig,'figure05.fig');