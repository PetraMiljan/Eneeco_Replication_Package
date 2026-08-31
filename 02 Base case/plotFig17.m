%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paper Zagreb 2025
% Analysis of the results - Proposed model
% Plot Figure 17
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

%% CVaR of the profit for all alpha

A = xlsread('resultsProposed_alpha_export.xlsx','ofPROPvector','B1:B11');
ProfitAlphaInSample = A(:,end);

ProfitSorted = zeros(size(ProfitScen));
varPos = zeros(length(alphaVector),1);
varProfit = zeros(length(alphaVector),1);
cvarProfit = zeros(length(alphaVector),1);
fig = figure;

for i = 1:length(alphaVector)
    ProfitSorted(:,i) = sort(ProfitScen(:,i));
    if alphaVector(i) == 0
        varPos(i,1) = size(ProfitScen,1);
    else
        varPos(i,1) = ceil(size(ProfitScen,1)*(1-alphaVector(i)));
    end
    cvarProfit(i,1) = mean(ProfitSorted(1:varPos(i,1),i));
end
plot(alphaVector,ProfitAlphaInSample,'o-','LineWidth',2);
hold on;
plot(alphaVector,cvarProfit,'o-','LineWidth',2);
xlabel('Confidence level, \alpha','Interpreter','tex','FontSize',16,'FontName','Times New Roman');
ylabel('CVaR_\alpha of the total profit (€)','Interpreter','tex','FontSize',16,'FontName','Times New Roman');
ymin = 2800;
ymax = 3600;
set(gcf, 'Position', [100 100 800 400])
xticks(alphaVector);
axis([0 0.999 ymin ymax]);
grid on;
legend('In-sample analysis','Out-of-sample analysis','Location','northeast','Interpreter','tex','FontSize',12,'FontName','Times New Roman');

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

save('cvarProfit','cvarProfit');

% Save the figure as .fig.
savefig(fig,'figure17.fig');
