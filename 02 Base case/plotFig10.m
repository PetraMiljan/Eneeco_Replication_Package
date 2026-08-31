%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paper Zagreb 2025
% Analysis of the results - Hybrid model
% mpDA for different values of Gamma
% Plot Figure 10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Álvaro García Cerezo, Petra Miljan, Hrvoje Pandžić
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% I analyze mpDA for different values of Gamma.

clear;
close all;
clc;

%% Read the data

tol = 1e-6;

A = xlsread('resultsHybridSPRO_Gamma_export.xlsx','GammaIBvector','B1:B25');
GammaIBvector = A(:,end);
GammaIBvector(1) = 0;

A = xlsread('resultsHybridSPRO_Gamma_export.xlsx','mpDAfixMatrixGamma','C1:C600');
mpDA = zeros(length(A),3);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:25
        cont = cont+1;
        mpDA(cont,1) = ind1;
        mpDA(cont,2) = ind2;
        mpDA(cont,end) = A(cont);
    end
end
aux = mpDA;
mpDA = zeros(size(aux,1)/length(GammaIBvector),length(GammaIBvector));
for i = 1:length(GammaIBvector)
    mpDA(:,i) = aux(aux(:,2)==i,end);
end
mpDA(mpDA(:,end)==tol,end) = 0;
mpDA = [mpDA;mpDA(end,:)]; % I do this to use function stairs.

%% mpDA for Gamma = 0, 12, 24

fig = figure;
for i = [1,13,25]
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
legend('$\Gamma^{\rm IB} = 0$','$\Gamma^{\rm IB} = 12$','$\Gamma^{\rm IB} = 24$','Interpreter','latex','Location','northeast','FontSize',12,'FontName','Times New Roman');

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
savefig(fig,'figure10.fig');
