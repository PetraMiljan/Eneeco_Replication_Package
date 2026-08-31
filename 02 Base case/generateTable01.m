%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paper Zagreb 2025
% Generate Table 1
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

A = xlsread('resultsHybridSPRO_Gamma_export.xlsx','GammaIBvector','B1:B25');
GammaIBvector = A(:,end);
GammaIBvector(1) = 0;

% gammaVector
A = xlsread('resultsHybridSPRO_Gamma_export.xlsx','GammaIBvector','B1:B25');
gammaVector = A(:,end);
gammaVector(1) = 0;
gammaVectorLoop = 1:length(gammaVector); 
gammaVectorLoop = gammaVectorLoop';
gammaNum = length(gammaVector);

% ProfitGamma(gamma)
A = xlsread('resultsHybridSPRO_Gamma_export.xlsx','ofHSPROvector','B1:B25');
ProfitGamma = A(:,end);

% EtaW
EtaW = 0.01;

% KIB
KIB = 0.4;

% LambdaDA(gamma)
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

% LambdaH(t)
LambdaH = repmat(2,tNum,1);

% LambdaW(t)
LambdaW = repmat(0.397,tNum,1);

% mpDA(t,gamma)
A = xlsread('resultsHybridSPRO_Gamma_export.xlsx','PAR_mpDA','C1:C600');
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
mpDA(mpDA(:,end)==tol,end) = 0;

% dIB(t,s,gamma)
A = xlsread('resultsHybridSPRO_Gamma_export.xlsx','PAR_dIB','D1:D120000');
dIB = zeros(length(A),4);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:200
        for ind3 = 1:1:25
            cont = cont+1;
            dIB(cont,1) = ind1;
            dIB(cont,2) = ind2;
            dIB(cont,3) = ind3;
            dIB(cont,end) = A(cont);
        end
    end
end
dIB(dIB(:,end)==tol,end) = 0;
dIB = dIB(dIB(:,2)<=sNum,:);

% chiHIB(t,s,gamma)
A = xlsread('resultsHybridSPRO_Gamma_export.xlsx','PAR_chiHIB','D1:D120000');
chiHIB = zeros(length(A),4);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:200
        for ind3 = 1:1:25
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

% y(t,s,gamma)
A = xlsread('resultsHybridSPRO_Gamma_export.xlsx','PAR_y','D1:D120000');
y = zeros(length(A),4);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:200
        for ind3 = 1:1:25
            cont = cont+1;
            y(cont,1) = ind1;
            y(cont,2) = ind2;
            y(cont,3) = ind3;
            y(cont,end) = A(cont);
        end
    end
end
y(y(:,end)==tol,end) = 0;
y = y(y(:,2)<=sNum,:);

% z(t,s,gamma)
A = xlsread('resultsHybridSPRO_Gamma_export.xlsx','PAR_z','D1:D120000');
z = zeros(length(A),4);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:200
        for ind3 = 1:1:25
            cont = cont+1;
            z(cont,1) = ind1;
            z(cont,2) = ind2;
            z(cont,3) = ind3;
            z(cont,end) = A(cont);
        end
    end
end
z(z(:,end)==tol,end) = 0;
z = z(z(:,2)<=sNum,:);

% delta(s,gamma)
A = xlsread('resultsHybridSPRO_Gamma_export.xlsx','PAR_delta','C1:C5000');
delta = zeros(length(A),3);
cont = 0;
for ind1 = 1:200
    for ind2 = 1:25
        cont = cont+1;
        delta(cont,1) = ind1;
        delta(cont,2) = ind2;
        delta(cont,end) = A(cont);
    end
end
delta(delta(:,end)==tol,end) = 0;
delta = delta(delta(:,1)<=sNum,:);

% I check if the variables read and identified lead to the optimal 
% objective function value of the problem. I use the variables considered 
% to compute thetaCVAR

ProfitGammaDA = zeros(gammaNum,1);
ProfitGammaH2 = zeros(gammaNum,1);
ProfitGammaIB = zeros(gammaNum,1);
ProfitGammaIPD = zeros(gammaNum,1);
for gamma = 1:gammaNum
    mpDAgamma = mpDA(mpDA(:,2)==gamma,:);
    dIBgamma = dIB(dIB(:,3)==gamma,:);
    chiHIBgamma = chiHIB(chiHIB(:,3)==gamma,:);
    yGamma = y(y(:,3)==gamma,:);
    zGamma = z(z(:,3)==gamma,:);
    deltaGamma = delta(delta(:,2)==gamma,:);
    % ===============
    %  ProfitGammaDA
    % ===============
    ProfitGammaDA(gamma) = sum(LambdaDA.*mpDAgamma(:,end));
    % ===============
    %  ProfitGammaH2
    % ===============
    auxH2_ts = zeros(tNum,sNum);
    for i = 1:size(chiHIBgamma,1)
        t = chiHIBgamma(i,1);
        s = chiHIBgamma(i,2);
        auxH2_ts(t,s) = LambdaH(t)*chiHIBgamma(i,end) - LambdaW(t)*EtaW*chiHIBgamma(i,end);
    end
    auxH2_s = sum(auxH2_ts,1); auxH2_s = auxH2_s';
    ProfitGammaH2_s= auxH2_s;
    ProfitGammaH2(gamma) = sum(ProbS.*ProfitGammaH2_s);
    ProfitGammaH2(gamma) = ProfitGammaH2(gamma)';
    % ================
    %  ProfitGammaIPD
    % ================
    % auxIPD associated with dIBgamma and yGamma
    auxIPD_ts = zeros(tNum,sNum);
    for i = 1:size(dIBgamma,1)
        t = dIBgamma(i,1);
        s = dIBgamma(i,2);
        auxIPD_ts(t,s) = LambdaDA(t)*dIBgamma(i,end) + LambdaDA(t)*KIB*yGamma(i,end);
    end
    auxIPD_s = sum(auxIPD_ts,1); auxIPD_s = auxIPD_s';
    %  auxIPD associated with zGamma
    auxIPD_ts = zeros(tNum,sNum);
    for i = 1:size(zGamma,1)
        t = zGamma(i,1);
        s = zGamma(i,2);
        auxIPD_ts(t,s) = -zGamma(i,end);
    end
    auxIPD_s_1 = sum(auxIPD_ts,1);
    % auxIPD associated with delta
    auxIPD_s_2 = zeros(sNum);
    for i = 1:size(deltaGamma,1)
        s = deltaGamma(i,1);
        xi = deltaGamma(i,2);
        auxIPD_s_2(s) = -deltaGamma(i,end)*gammaVector(gamma);
    end
    % ProfitGammaIPD
    ProfitGammaIPD_s = zeros(sNum,1);
    for s = 1:sNum
        ProfitGammaIPD_s(s) = auxIPD_s(s) + auxIPD_s_1(s) + auxIPD_s_2(s);
    end
    ProfitGammaIPD(gamma) = sum(ProbS.*ProfitGammaIPD_s);
    % ================
    %  ProfitGammaIB
    % ================
    ProfitGammaIB_s = zeros(sNum,1);
    for s = 1:sNum
        ProfitGammaIB_s(s) = ProfitGammaH2_s(s) + ProfitGammaIPD_s(s);
    end
    ProfitGammaIB(gamma) = sum(ProbS.*ProfitGammaIB_s);
end
% ====================
%  ProfitGammaCheck
% ====================
ProfitGammaCheck = ProfitGammaDA + ProfitGammaIB;
if(sum(abs(ProfitGammaCheck-ProfitGamma))>tol)
    error('Error computing the profit using the results of the variables');
end

%% Write the results

filename = 'table01.xlsx';
titlesWrite = {'GammaIB','Total expected profit (€)','Day-ahead electricity trading profit (€)','Hydrogen trading profit (€)','Imbalance profit (€)'};
writecell(titlesWrite,filename,'Range','B2');
matrixWrite = [GammaIBvector,ProfitGamma,ProfitGammaDA,ProfitGammaH2,ProfitGammaIPD];
writematrix(matrixWrite,filename,'Range','B3');
