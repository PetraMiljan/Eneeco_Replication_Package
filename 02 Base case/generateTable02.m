%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paper Zagreb 2025
% Generate Table 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Álvaro García Cerezo, Petra Miljan, Hrvoje Pandžić
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
close all;
clc;

%% Read the data

tol = 1e-6;
tVector = 1:24; tVector = tVector';
tNum = length(tVector);
sVector = 1:10; sVector = sVector';
sNum = length(sVector);
xiVector = 1:25; xiVector = xiVector';
xiNum = length(xiVector);

% alphaVector
A = xlsread('resultsProposed_alpha_export.xlsx','alphaCVaRvector','B1:B11');
alphaVector = A(:,end);
alphaVector(1) = 0;
alphaVectorLoop = 1:length(alphaVector); 
alphaVectorLoop = alphaVectorLoop';
alphaNum = length(alphaVector);

% ProfitAlpha(alpha)
A = xlsread('resultsProposed_alpha_export.xlsx','ofPROPvector','B1:B11');
ProfitAlpha = A(:,end);

% EtaW
EtaW = 0.01;

% KIB
KIB = 0.4;

% LambdaDA(alpha)
LambdaDA = [
    33.29
    31.1
    29.03
    28.5
    29
    33.69
    40.92
    43.09
    43.3
    44.2
    44.05
    42.95
    42.49
    42.97
    42.8
    45.67
    66.22
    94.43
    53.35
    73.71
    48
    39.79
    61.42
    57.32
];

% GammaIBvector
GammaIBvector = 0:24; GammaIBvector = GammaIBvector';

% ProbS(s)
ProbS =  [
    0.04
    0.08
    0.16
    0.08
    0.14
    0.06
    0.16
    0.02
    0.02
    0.24
];

% ProbX(xi)
ProbX = repmat(1/xiNum,xiNum,1);

% LambdaH(t)
LambdaH = repmat(2,tNum,1);

% LambdaW(t)
LambdaW = repmat(0.397,tNum,1);

% mpDA(t,alpha)
A = xlsread('resultsProposed_alpha_export.xlsx','PAR_mpDA','C1:C264');
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
mpDA(mpDA(:,end)==tol,end) = 0;

% phiVAR(alpha)
A = xlsread('resultsProposed_alpha_export.xlsx','PAR_phiVAR','B1:B11');
phiVAR = A;
phiVAR(phiVAR(:)==tol) = 0;

% thetaCVAR(s,xi,alpha)
A = xlsread('resultsProposed_alpha_export.xlsx','PAR_thetaCVAR','D1:D55000');
thetaCVAR = zeros(length(A),4);
cont = 0;
for ind1 = 1:200
    for ind2 = 1:25
        for ind3 = 1:11
            cont = cont+1;
            thetaCVAR(cont,1) = ind1;
            thetaCVAR(cont,2) = ind2;
            thetaCVAR(cont,3) = ind3;
            thetaCVAR(cont,end) = A(cont);
        end
    end
end
thetaCVAR(thetaCVAR(:,end)==tol,end) = 0;
thetaCVAR = thetaCVAR(thetaCVAR(:,1)<=sNum,:);

% dIB(t,s,alpha)
load("dIB.mat");

% chiHIB(t,s,alpha)
A = xlsread('resultsProposed_alpha_export.xlsx','PAR_chiHIB','D1:D52800');
chiHIB = zeros(length(A),4);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:200
        for ind3 = 1:11
            cont = cont+1;
            chiHIB(cont,1) = ind1;
            chiHIB(cont,2) = ind2;
            chiHIB(cont,3) = ind3;
            chiHIB(cont,end) = A(cont);
        end
    end
end
chiHIB(chiHIB(:,end)==tol,end) = 0;
chiHIB = chiHIB(chiHIB(:,2)<=sNum,:);

% y(t,s,alpha)
load("y.mat");

% zXI(t,s,xi,alpha)
load("zXI.mat");

% deltaXI(s,xi,alpha)
A = xlsread('resultsProposed_alpha_export.xlsx','PAR_deltaXI','D1:D55000');
deltaXI = zeros(length(A),4);
cont = 0;
for ind1 = 1:200
    for ind2 = 1:25
        for ind3 = 1:11
            cont = cont+1;
            deltaXI(cont,1) = ind1;
            deltaXI(cont,2) = ind2;
            deltaXI(cont,3) = ind3;
            deltaXI(cont,end) = A(cont);
        end
    end
end
deltaXI(deltaXI(:,end)==tol,end) = 0;
deltaXI = deltaXI(deltaXI(:,1)<=sNum,:);

% I check if the variables read and identified lead to the optimal 
% objective function value of the problem.

% Check 1: using variable thetaCVAR
ProfitAlphaCheck1 = zeros(alphaNum,1);
for alpha = 1:alphaNum
    thetaCVARalpha = thetaCVAR(thetaCVAR(:,3)==alpha,:);
    mpDAalpha = mpDA(mpDA(:,2)==alpha,:);
    ProfitAlphaCheck1(alpha) = sum(LambdaDA.*mpDAalpha(:,end)) + phiVAR(alpha,end);
    aux = 0;
    for i = 1:size(thetaCVARalpha,1)
        aux = aux + ProbS(thetaCVARalpha(i,1))*ProbX(thetaCVARalpha(i,2))*thetaCVARalpha(i,end);
    end
    ProfitAlphaCheck1(alpha) = ProfitAlphaCheck1(alpha) - (1/(1-alphaVector(alpha))) * aux;
end
if(sum(abs(ProfitAlphaCheck1-ProfitAlpha))>tol)
    error('Error computing the profit using the results of the variables');
end

% Check 2: using the variables considered to compute thetaCVAR
activeScenNum = zeros(alphaNum,1);
ProbScenVAR = zeros(alphaNum,1);
ProfitAlphaDA = zeros(alphaNum,1);
ProfitAlphaH2cvar = zeros(alphaNum,1);
ProfitAlphaIPDcvar = zeros(alphaNum,1);
ProfitAlphaIBcvar = zeros(alphaNum,1);
scenVAR = zeros(alphaNum,1);
for alpha = 1:alphaNum
    thetaCVARalpha = thetaCVAR(thetaCVAR(:,3)==alpha,:);
    mpDAalpha = mpDA(mpDA(:,2)==alpha,:);
    dIBalpha = dIB(dIB(:,3)==alpha,:);
    chiHIBalpha = chiHIB(chiHIB(:,3)==alpha,:);
    yAlpha = y(y(:,3)==alpha,:);
    zXIalpha = zXI(zXI(:,4)==alpha,:);
    deltaXIalpha = deltaXI(deltaXI(:,3)==alpha,:);
    % ===============
    %  ProfitAlphaDA
    % ===============
    ProfitAlphaDA(alpha) = sum(LambdaDA.*mpDAalpha(:,end));
    % ===============
    %  ProfitAlphaH2
    % ===============
    auxH2_ts = zeros(tNum,sNum);
    for i = 1:size(chiHIBalpha,1)
        t = chiHIBalpha(i,1);
        s = chiHIBalpha(i,2);
        auxH2_ts(t,s) = LambdaH(t)*chiHIBalpha(i,end) - LambdaW(t)*EtaW*chiHIBalpha(i,end);
    end
    auxH2_s = sum(auxH2_ts,1); auxH2_s = auxH2_s';
    ProfitAlphaH2 = auxH2_s;
    % ================
    %  ProfitAlphaIPD
    % ================
    % auxIPD associated with dIBalpha and yAlpha
    auxIPD_ts = zeros(tNum,sNum);
    for i = 1:size(dIBalpha,1)
        t = dIBalpha(i,1);
        s = dIBalpha(i,2);
        auxIPD_ts(t,s) = LambdaDA(t)*dIBalpha(i,end) + LambdaDA(t)*KIB*yAlpha(i,end);
    end
    auxIPD_s = sum(auxIPD_ts,1); auxIPD_s = auxIPD_s';
    %  auxIPD associated with zXIalpha
    auxIPD_tsxi = zeros(tNum,sNum,xiNum);
    for i = 1:size(zXIalpha,1)
        t = zXIalpha(i,1);
        s = zXIalpha(i,2);
        xi = zXIalpha(i,3);
        auxIPD_tsxi(t,s,xi) = -zXIalpha(i,end);
    end
    auxIPD_sxi_1 = sum(auxIPD_tsxi,1);
    auxIPD_sxi_1_ = zeros(sNum,xiNum);
    auxIPD_sxi_1_(:,:) = auxIPD_sxi_1(1,:,:);
    auxIPD_sxi_1 = auxIPD_sxi_1_;
    % auxIPD associated with deltaXI
    auxIPD_sxi_2 = zeros(sNum,xiNum);
    for i = 1:size(deltaXIalpha,1)
        s = deltaXIalpha(i,1);
        xi = deltaXIalpha(i,2);
        auxIPD_sxi_2(s,xi) = -deltaXIalpha(i,end)*GammaIBvector(xi);
    end
    % ProfitAlphaIPD
    ProfitAlphaIPD = zeros(sNum,xiNum);
    for s = 1:sNum
        ProfitAlphaIPD(s,:) = auxIPD_s(s);
        for xi = 1:xiNum
            ProfitAlphaIPD(s,xi) = ProfitAlphaIPD(s,xi) + auxIPD_sxi_1(s,xi) + auxIPD_sxi_2(s,xi);
        end
    end
    % ================
    %  ProfitAlphaIB
    % ================
    ProfitAlphaIB = zeros(sNum,xiNum);
    for s = 1:sNum
        ProfitAlphaIB(s,:) = ProfitAlphaH2(s);
        for xi = 1:xiNum
            ProfitAlphaIB(s,xi) = ProfitAlphaIB(s,xi) + ProfitAlphaIPD(s,xi);
        end
    end
    % ==================
    %  Active scenarios
    % ==================
    % I identify the active scenarios based on the values of 
    % ProfitAlphaIB.
    ProfitAlphaIBvector = reshape(ProfitAlphaIB.', [], 1);
    matrixS = zeros(sNum,xiNum);
    matrixXI = zeros(sNum,xiNum);
    contS = 0;
    for s = 1:sNum
        contS = contS + 1;
        contXI = 0;
        for xi = 1:xiNum
            matrixS(s,xi) = contS;
            contXI = contXI + 1;
            matrixXI(s,xi) = contXI;
        end
    end
    matrixSvector = reshape(matrixS.', [], 1);
    matrixXIvector = reshape(matrixXI.', [], 1);
    ProfitAlphaIBmatrix = [ProfitAlphaIBvector,matrixSvector,matrixXIvector];
    ProfitAlphaIBmatrixSorted = sortrows(ProfitAlphaIBmatrix,1,'ascend');
    ProfitAlphaIBmatrixSorted = [ProfitAlphaIBmatrixSorted,zeros(sNum*xiNum,2)];
    for i = 1:size(ProfitAlphaIBmatrixSorted,1)
        s = ProfitAlphaIBmatrixSorted(i,2);
        xi = ProfitAlphaIBmatrixSorted(i,3);
        if i == 1
            ProfitAlphaIBmatrixSorted(i,4) = ProbS(s)*ProbX(xi);
            ProfitAlphaIBmatrixSorted(i,5) = ProbS(s)*ProbX(xi);
        else
            ProfitAlphaIBmatrixSorted(i,4) = ProbS(s)*ProbX(xi);
            ProfitAlphaIBmatrixSorted(i,5) = ProfitAlphaIBmatrixSorted(i-1,5) + ProbS(s)*ProbX(xi);
        end
    end
    %
    cont = 0;
    contI = 0;
    while cont == 0
        contI = contI + 1;
        if ProfitAlphaIBmatrixSorted(contI,5) >= 1-alphaVector(alpha)
            scenVAR(alpha) = contI;
            cont = 1;
        end
    end
    activeScenNum(alpha) = ceil((1-alphaVector(alpha))*sNum*xiNum);
    % ===============================================================
    %  CVaR de ProfitAlphaIB, ProfitAlphaH2cvar y ProfitAlphaIPDcvar
    % ===============================================================
    auxProb = 0;
    auxIB = 0;
    auxH2 = 0;
    auxIPD = 0;
    if alpha == 11
        a = 1;
    end
    for i = 1:scenVAR(alpha)
        s = ProfitAlphaIBmatrixSorted(i,2);
        xi = ProfitAlphaIBmatrixSorted(i,3);
        auxProb = auxProb + ProfitAlphaIBmatrixSorted(i,4);
        if auxProb > (1-alphaVector(alpha))
            if i == 1
                ProbScenVAR(alpha) = (1-alphaVector(alpha));
            else
                ProbScenVAR(alpha) = (1-alphaVector(alpha)) - ProfitAlphaIBmatrixSorted(i-1,5);
            end
            auxIB = auxIB + ProbScenVAR(alpha)*ProfitAlphaIBmatrixSorted(i,1);
            auxH2 = auxH2 + ProbScenVAR(alpha)*ProfitAlphaH2(s);
            auxIPD = auxIPD + ProbScenVAR(alpha)*ProfitAlphaIPD(s,xi);
        else
            auxIB = auxIB + ProfitAlphaIBmatrixSorted(i,4)*ProfitAlphaIBmatrixSorted(i,1);
            auxH2 = auxH2 + ProfitAlphaIBmatrixSorted(i,4)*ProfitAlphaH2(s);
            auxIPD = auxIPD + ProfitAlphaIBmatrixSorted(i,4)*ProfitAlphaIPD(s,xi);
        end
    end
    ProfitAlphaIBcvar(alpha) = auxIB/(1-alphaVector(alpha));
    ProfitAlphaH2cvar(alpha) = auxH2/(1-alphaVector(alpha));
    ProfitAlphaIPDcvar(alpha) = auxIPD/(1-alphaVector(alpha));
end
% ====================
%  ProfitAlphaCheck2
% ====================
ProfitAlphaCheck2 = ProfitAlphaDA + ProfitAlphaIBcvar;
if(sum(abs(ProfitAlphaCheck2-ProfitAlpha))>tol)
    error('Error computing the profit using the results of the variables');
end

%% Write the results

filename = 'table02.xlsx';
titlesWrite = {'alpha','CVaR of the total profit (€)','Day-ahead electricity trading profit (€)','Hydrogen trading profit (€)','Imbalance profit (€)'};
writecell(titlesWrite,filename,'Range','B2');
matrixWrite = [alphaVector,ProfitAlpha,ProfitAlphaDA,ProfitAlphaH2cvar,ProfitAlphaIPDcvar];
writematrix(matrixWrite,filename,'Range','B3');
