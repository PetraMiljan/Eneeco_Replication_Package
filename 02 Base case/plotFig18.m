%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paper Zagreb 2025
% Analysis of the results - Hybrid model
% Plot Figure 18
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

%% Average value of the profit for all Gamma

A = xlsread('resultsHybridSPRO_Gamma_export.xlsx','ofHSPROvector','B1:B25');
ProfitGammaInSample = A(:,end);

avProfit = zeros(length(GammaIBvector),1);
fig = figure;

for i = 1:length(GammaIBvector)
    avProfit(i,1) = mean(ProfitScen(:,i));
end
plot(GammaIBvector,ProfitGammaInSample,'o-','LineWidth',2);
hold on;
plot(GammaIBvector,avProfit,'o-','LineWidth',2);
xlabel('Uncertainty level, \Gamma^{\rm{IB}} (h)','Interpreter','tex','FontSize',16,'FontName','Times New Roman');
ylabel('Total expected profit (€)','Interpreter','tex','FontSize',16,'FontName','Times New Roman');
ymin = 2800;
ymax = 9200;
set(gcf, 'Position', [100 100 800 400])
xticks(GammaIBvector);
axis([0 24 ymin ymax]);
grid on;
legend('In-sample analysis','Out-of-sample analysis','Location','northeast','Interpreter','tex','FontSize',12,'FontName','Times New Roman');

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
savefig(fig,'figure18.fig');
