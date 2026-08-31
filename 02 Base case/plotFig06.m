%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paper Zagreb 2025
% Analysis of the results - Proposed model
% Profit for different values of alphaCVaR
% Plot Figure 6
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Álvaro García Cerezo, Petra Miljan, Hrvoje Pandžić
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% I analyze the profit for different values of alphaCVaR.

clear;
close all;
clc;

%% Read the data

A = xlsread('resultsProposed_alpha_export.xlsx','alphaCVaRvector','B1:B11');
alphaVector = A(:,end);
alphaVector(1) = 0;

A = xlsread('resultsProposed_alpha_export.xlsx','ofPROPvector','B1:B11');
ProfitAlpha = A(:,end);

%% CVaR of the profit for all alpha

fig = figure;
plot(alphaVector,ProfitAlpha,'o-','LineWidth',2);
xlabel('Confidence level, \alpha','Interpreter','tex','FontSize',16,'FontName','Times New Roman');
ylabel('CVaR_\alpha of the total profit (€)','Interpreter','tex','FontSize',16,'FontName','Times New Roman');
ymin = 2900;
ymax = 3600;
set(gcf, 'Position', [100 100 800 400])
xticks(alphaVector);
axis([0 0.999 ymin ymax]);
grid on;

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

% Save the figure as .fig.
savefig(fig,'figure06.fig');
