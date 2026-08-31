%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paper Zagreb 2025
% Analysis of the results - Hybrid model
% Plot Figure 22
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

%% Boxplot for all Gamma

fig = figure;
boxplot(ProfitScen, 'Labels', string(GammaIBvector))
xlabel('Uncertainty level, \Gamma^{\rm{IB}} (h)','Interpreter','tex','FontSize',16,'FontName','Times New Roman');
ylabel('Total profit (€)','Interpreter','tex','FontSize',16,'FontName','Times New Roman');
title('');
set(gcf, 'Position', [100 100 800 400]);
outliers = findobj(fig,'Tag','Outliers');
set(outliers,'Marker','o','MarkerEdgeColor',[0.5 0.5 0.5]); % gris

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
savefig(fig,'figure22.fig');
