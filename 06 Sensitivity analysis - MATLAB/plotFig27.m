%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paper Zagreb 2025
% Analysis of the results - Proposed model
% Plot Figure 27
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Álvaro García Cerezo, Petra Miljan, Hrvoje Pandžić
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
close all;
clc;

%% Read the data

A = xlsread('resultsProposed_alpha_1_export.xlsx','AlphaCVaRvector','B1:B11');
alphaVector = A(:,end);
alphaVector(1) = 0;

A = xlsread('resultsProposed_alpha_1_export.xlsx','ofPROPvector','B1:B11');
ProfitAlpha1 = A(:,end);

A = xlsread('resultsProposed_alpha_2_export.xlsx','ofPROPvector','B1:B11');
ProfitAlpha2 = A(:,end);

A = xlsread('resultsProposed_alpha_3_export.xlsx','ofPROPvector','B1:B11');
ProfitAlpha3 = A(:,end);

load("cvarProfit.mat");
load("cvarProfit_1.mat");
load("cvarProfit_2.mat");
load("cvarProfit_3.mat");

%% CVaR of the profit for all alpha (out-of-sample)

fig = figure;
plot(alphaVector,cvarProfit,'o-','LineWidth',2);
hold on;
plot(alphaVector,cvarProfit1,'o-','LineWidth',2);
plot(alphaVector,cvarProfit2,'o-','LineWidth',2);
plot(alphaVector,cvarProfit3,'o-','LineWidth',2);
xlabel('Confidence level, \alpha','Interpreter','tex','FontSize',16,'FontName','Times New Roman');
ylabel('CVaR_\alpha of the total profit (€)','Interpreter','tex','FontSize',16,'FontName','Times New Roman');
ymin = 2300;
ymax = 3800;
set(gcf, 'Position', [100 100 800 400])
xticks(alphaVector);
axis([0 0.999 ymin ymax]);
grid on;
legend('Base case','Case 1','Case 2','Case 3','Location','northeast','Interpreter','tex','FontSize',12,'FontName','Times New Roman');

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
savefig(fig,'figure27.fig');
