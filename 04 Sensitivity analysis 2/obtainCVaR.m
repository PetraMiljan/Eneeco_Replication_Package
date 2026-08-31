%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paper Zagreb 2025
% Obtain the CVaR
% Excel version
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Álvaro García Cerezo, Petra Miljan, Hrvoje Pandžić
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
close all;
clc;

%% Read the data

A = xlsread('results_OA_export.xlsx','AlphaCVaRvector','B1:B11');
alphaVector = A;
alphaVector(1) = 0;

A = xlsread('results_OA_export.xlsx','ProfitScen','D1:D805200');
ProfitScen = zeros(size(A,1)/length(alphaVector),length(alphaVector));
for i = 1:length(alphaVector)
    ProfitScen(:,i) = A(i:length(alphaVector):end);
end

%% CVaR of the profit for all alpha

ProfitSorted = zeros(size(ProfitScen));
varPos = zeros(length(alphaVector),1);
varProfit = zeros(length(alphaVector),1);
cvarProfit = zeros(length(alphaVector),1);

for i = 1:length(alphaVector)
    ProfitSorted(:,i) = sort(ProfitScen(:,i));
    if alphaVector(i) == 0
        varPos(i,1) = size(ProfitScen,1);
    else
        varPos(i,1) = ceil(size(ProfitScen,1)*(1-alphaVector(i)));
    end
    cvarProfit(i,1) = mean(ProfitSorted(1:varPos(i,1),i));
end

cvarProfit2 = cvarProfit;
save('cvarProfit_2','cvarProfit2');
