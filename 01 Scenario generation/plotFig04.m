%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paper Zagreb 2025
% PV scenarios
% Plot Figure 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Álvaro García Cerezo, Petra Miljan, Hrvoje Pandžić
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
close all;
clc;

%% Read the data

forecastProd = [0; 0; 0; 0; 0; 0; 0; 0; 0.024865; 4.3018; 9.0652; 13.681; ...
                   14.658; 14.278; 7.9838; 4.2282; 0.8303; 0.00021938; ...
                   0; 0; 0; 0; 0; 0];

load('results_set1_pvScenarios.mat');
load('results_set2_pvScenarios.mat');
load('results_set3_pvScenarios.mat');

%% In-sample and out-of-sample RPA scenarios

fig = figure;

% Dummies for legend
plot(1,10000,'-','LineWidth',2,'Color',[0.0 0.0 1.0]);
hold on;
plot(1,10000,'-','LineWidth',2,'Color',[0.5 0.5 1.0]);
plot(1,10000,'-','LineWidth',1.5,'Color',[0.8 0.8 1.0]);
% Out-of-sample scenarios
plot(1:24,scenariosProd3,'-','LineWidth',1.5,'Color',[0.8 0.8 1.0]);
% In-sample scenarios
plot(1:24,scenariosProd2,'-','LineWidth',1.5,'Color',[0.5 0.5 1.0]);
% Forecast value
plot(1:24,forecastProd,'-','LineWidth',2,'Color',[0.0 0.0 1.0]);
xlabel('Hour, $t$','Interpreter','latex','FontSize',16);
ylabel('Power (MW)','Interpreter','latex','FontSize',16);
ymin = 0;
ymax = 20;
set(gcf, 'Position', [100 100 800 400])
xticks([1,3:3:24]);
axis([1 24 ymin ymax]);
% grid on;
legend('Forecast RPA curve','In-sample RPA scenarios','Out-off-sample RPA scenarios','Location','northeast','Interpreter','latex','FontSize',12);

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
savefig(fig,'figure04.fig');
