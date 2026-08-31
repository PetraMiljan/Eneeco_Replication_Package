%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paper Zagreb 2025
% Analysis of the results - Proposed model
% mpDA for different values of alphaCVaR
% Plot Figure 11
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Álvaro García Cerezo, Petra Miljan, Hrvoje Pandžić
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% I analyze mpDA for different values of alphaCVaR.

clear;
close all;
clc;

%% Read the data

tol = 1e-6;

A = xlsread('resultsProposed_alpha_export.xlsx','alphaCVaRvector','B1:B11');
alphaVector = A(:,end);
alphaVector(1) = 0;

A = xlsread('resultsProposed_alpha_export.xlsx','mpDAfixMatrix','C1:C264');
mpDA = zeros(length(A),3);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:11
        cont = cont+1;
        mpDA(cont,1) = ind1;
        mpDA(cont,2) = ind2;
        mpDA(cont,end) = A(cont);
    end
end
aux = mpDA;
mpDA = zeros(size(aux,1)/length(alphaVector),length(alphaVector));
for i = 1:length(alphaVector)
    mpDA(:,i) = aux(aux(:,2)==i,end);
end
mpDA(mpDA(:,end)==tol,end) = 0;
mpDA = [mpDA;mpDA(end,:)]; % I do this to use function stairs.

%% mpDA for alpha = 0, 0.5, 0.999

fig = figure;
for i = [1,6,11]
    stairs(0:24,mpDA(:,i),'LineWidth',2);
    if i == 1
        hold on;
    end
end
xlabel('Hour (h)','Interpreter','latex','FontSize',16,'FontName','Times New Roman');
ylabel('Net power sold (MW)','Interpreter','latex','FontSize',16,'FontName','Times New Roman');
grid on;
set(gcf, 'Position', [100 100 800 400])
axis([0 24 -12.5 17.5]);
xticks([0:24]);
legend('$\alpha = 0$','$\alpha = 0.5$','$\alpha = 0.999$','Interpreter','latex','Location','northeast','FontSize',12,'FontName','Times New Roman');

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
savefig(fig,'figure11.fig');
