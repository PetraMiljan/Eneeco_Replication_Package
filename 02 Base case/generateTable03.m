%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paper Zagreb 2025
% Generate Table 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Álvaro García Cerezo, Petra Miljan, Hrvoje Pandžić
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%

clear;
close all;
clc;

tol = 1e-6;
tValores = 24;
alphaValores = 25;
sValores = 10;
probS = [
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

% GammaIBvector
A = xlsread('resultsHybridSPRO_Gamma_export.xlsx','GammaIBvector','B1:B25');
GammaIBvector = A(:,end);
GammaIBvector(1) = 0;

%=========================
% Charging of the battery
%=========================

% chBDA
A = xlsread('resultsHybridSPRO_Gamma_export.xlsx','par_chBDA','C1:C600');
aux = zeros(length(A),3);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:25
        cont = cont+1;
        aux(cont,1) = ind1;
        aux(cont,2) = ind2;
        aux(cont,end) = A(cont);
    end
end
aux(aux(:,end)==tol,end) = 0;
chBDA = aux;

% chBIBminus
A = xlsread('resultsHybridSPRO_Gamma_export.xlsx','par_chBIBminus','D1:D120000');
aux = zeros(length(A),4);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:200
        for ind3 = 1:25
            cont = cont+1;
            aux(cont,1) = ind1;
            aux(cont,2) = ind2;
            aux(cont,3) = ind3;
            aux(cont,end) = A(cont);
        end
    end
end
aux(aux(:,end)==tol,end) = 0;
aux(aux(:,2)>10,:) = [];
chBIBminus = aux;

% chBIBplus
A = xlsread('resultsHybridSPRO_Gamma_export.xlsx','par_chBIBplus','D1:D120000');
aux = zeros(length(A),4);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:200
        for ind3 = 1:25
            cont = cont+1;
            aux(cont,1) = ind1;
            aux(cont,2) = ind2;
            aux(cont,3) = ind3;
            aux(cont,end) = A(cont);
        end
    end
end
aux(aux(:,end)==tol,end) = 0;
aux(aux(:,2)>10,:) = [];
chBIBplus = aux;

%============================
% Discharging of the battery
%============================

% disBDA
A = xlsread('resultsHybridSPRO_Gamma_export.xlsx','par_disBDA','C1:C600');
aux = zeros(length(A),3);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:25
        cont = cont+1;
        aux(cont,1) = ind1;
        aux(cont,2) = ind2;
        aux(cont,end) = A(cont);
    end
end
aux(aux(:,end)==tol,end) = 0;
disBDA = aux;

% disBIBminus
A = xlsread('resultsHybridSPRO_Gamma_export.xlsx','par_disBIBminus','D1:D120000');
aux = zeros(length(A),4);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:200
        for ind3 = 1:25
            cont = cont+1;
            aux(cont,1) = ind1;
            aux(cont,2) = ind2;
            aux(cont,3) = ind3;
            aux(cont,end) = A(cont);
        end
    end
end
aux(aux(:,end)==tol,end) = 0;
aux(aux(:,2)>10,:) = [];
disBIBminus = aux;

% disBIBplus
A = xlsread('resultsHybridSPRO_Gamma_export.xlsx','par_disBIBplus','D1:D120000');
aux = zeros(length(A),4);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:200
        for ind3 = 1:25
            cont = cont+1;
            aux(cont,1) = ind1;
            aux(cont,2) = ind2;
            aux(cont,3) = ind3;
            aux(cont,end) = A(cont);
        end
    end
end
aux(aux(:,end)==tol,end) = 0;
aux(aux(:,2)>10,:) = [];
disBIBplus = aux;

% netChBDA: net charging in DA
netChBDA = chBDA;
netChBDA(:,end) = chBDA(:,end) - disBDA(:,end);
% diffNetChBIB: difference of the net charging in IB vs DA
diffNetChBIB = chBIBminus;
diffNetChBIB(:,end) = -chBIBminus(:,end)+chBIBplus(:,end)-(-disBIBminus(:,end)+disBIBplus(:,end));

%=================================
% Consumption of the electrolyzer
%=================================

% elEDA
A = xlsread('resultsHybridSPRO_Gamma_export.xlsx','par_elEDA','C1:C600');
aux = zeros(length(A),3);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:25
        cont = cont+1;
        aux(cont,1) = ind1;
        aux(cont,2) = ind2;
        aux(cont,end) = A(cont);
    end
end
aux(aux(:,end)==tol,end) = 0;
elEDA = aux;

% elEIB
A = xlsread('resultsHybridSPRO_Gamma_export.xlsx','par_elEIB','D1:D120000');
aux = zeros(length(A),4);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:200
        for ind3 = 1:25
            cont = cont+1;
            aux(cont,1) = ind1;
            aux(cont,2) = ind2;
            aux(cont,3) = ind3;
            aux(cont,end) = A(cont);
        end
    end
end
aux(aux(:,end)==tol,end) = 0;
aux(aux(:,2)>10,:) = [];
elEIB = aux;

% elEIBminus
A = xlsread('resultsHybridSPRO_Gamma_export.xlsx','par_elEIBminus','D1:D120000');
aux = zeros(length(A),4);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:200
        for ind3 = 1:25
            cont = cont+1;
            aux(cont,1) = ind1;
            aux(cont,2) = ind2;
            aux(cont,3) = ind3;
            aux(cont,end) = A(cont);
        end
    end
end
aux(aux(:,end)==tol,end) = 0;
aux(aux(:,2)>10,:) = [];
elEIBminus = aux;

% elEIBplus
A = xlsread('resultsHybridSPRO_Gamma_export.xlsx','par_elEIBplus','D1:D120000');
aux = zeros(length(A),4);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:200
        for ind3 = 1:25
            cont = cont+1;
            aux(cont,1) = ind1;
            aux(cont,2) = ind2;
            aux(cont,3) = ind3;
            aux(cont,end) = A(cont);
        end
    end
end
aux(aux(:,end)==tol,end) = 0;
aux(aux(:,2)>10,:) = [];
elEIBplus = aux;

% diffElE: difference of the consumption in IB vs DA
diffElE = elEIB;
diffElE(:,end) = -elEIBminus(:,end)+elEIBplus(:,end);

%==============
% Rescheduling
%==============

diffNetChBIBabs = abs(diffNetChBIB);
diffElEabs = abs(diffElE);
reschedulingIB = diffElE;
reschedulingIB(:,end) = diffNetChBIBabs(:,end) + diffElEabs(:,end);

diffNetChBIBabsMatrix= zeros(24, 10, 11);
for k = 1:size(diffNetChBIBabs,1)
    i = diffNetChBIBabs(k,1);
    j = diffNetChBIBabs(k,2);
    l = diffNetChBIBabs(k,3);
    diffNetChBIBabsMatrix(i,j,l) = diffNetChBIBabs(k,4);
end
diffElEabsMatrix= zeros(24, 10, 11);
for k = 1:size(diffElEabs,1)
    i = diffElEabs(k,1);
    j = diffElEabs(k,2);
    l = diffElEabs(k,3);
    diffElEabsMatrix(i,j,l) = diffElEabs(k,4);
end
reschedulingIBmatrix= zeros(24, 10, 11);
for k = 1:size(reschedulingIB,1)
    i = reschedulingIB(k,1);
    j = reschedulingIB(k,2);
    l = reschedulingIB(k,3);
    reschedulingIBmatrix(i,j,l) = reschedulingIB(k,4);
end

IBbatExpected = zeros(alphaValores,1);
IBeleExpected = zeros(alphaValores,1);
IBtotalExpected = zeros(alphaValores,1);

for alpha = 1:alphaValores
    for s = 1:sValores
        for t = 1:tValores
            IBbatExpected(alpha,1) = IBbatExpected(alpha,1) + diffNetChBIBabsMatrix(t,s,alpha)*probS(s);
            IBeleExpected(alpha,1) = IBeleExpected(alpha,1) + diffElEabsMatrix(t,s,alpha)*probS(s);
            IBtotalExpected(alpha,1) = IBtotalExpected(alpha,1) + reschedulingIBmatrix(t,s,alpha)*probS(s);
        end
    end
end

% IBtotalExpected-(IBbatExpected+IBeleExpected)

IBbatExpectedPrevious = IBbatExpected;
IBeleExpectedPrevious = IBeleExpected;

save('IBprevious.mat','IBbatExpectedPrevious','IBeleExpectedPrevious');

%%

clear;
close all;
clc;

tol = 1e-6;
tValores = 24;
alphaValores = 11;
sValores = 10;
probS = [
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

% alphaCVaRvector
A = xlsread('resultsProposed_alpha_export.xlsx','alphaCVaRvector','B1:B11');
alphaCVaRvector = A(:,end);
alphaCVaRvector(1) = 0;

%=========================
% Charging of the battery
%=========================

% chBDA
A = xlsread('resultsProposed_alpha_export.xlsx','par_chBDA','C1:C264');
aux = zeros(length(A),3);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:11
        cont = cont+1;
        aux(cont,1) = ind1;
        aux(cont,2) = ind2;
        aux(cont,end) = A(cont);
    end
end
aux(aux(:,end)==tol,end) = 0;
chBDA = aux;

% chBIBminus
A = xlsread('resultsProposed_alpha_export.xlsx','par_chBIBminus','D1:D52800');
aux = zeros(length(A),4);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:200
        for ind3 = 1:11
            cont = cont+1;
            aux(cont,1) = ind1;
            aux(cont,2) = ind2;
            aux(cont,3) = ind3;
            aux(cont,end) = A(cont);
        end
    end
end
aux(aux(:,end)==tol,end) = 0;
aux(aux(:,2)>10,:) = [];
chBIBminus = aux;

% chBIBplus
A = xlsread('resultsProposed_alpha_export.xlsx','par_chBIBplus','D1:D52800');
aux = zeros(length(A),4);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:200
        for ind3 = 1:11
            cont = cont+1;
            aux(cont,1) = ind1;
            aux(cont,2) = ind2;
            aux(cont,3) = ind3;
            aux(cont,end) = A(cont);
        end
    end
end
aux(aux(:,end)==tol,end) = 0;
aux(aux(:,2)>10,:) = [];
chBIBplus = aux;

%============================
% Discharging of the battery
%============================

% disBDA
A = xlsread('resultsProposed_alpha_export.xlsx','par_disBDA','C1:C264');
aux = zeros(length(A),3);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:11
        cont = cont+1;
        aux(cont,1) = ind1;
        aux(cont,2) = ind2;
        aux(cont,end) = A(cont);
    end
end
aux(aux(:,end)==tol,end) = 0;
disBDA = aux;

% disBIBminus
A = xlsread('resultsProposed_alpha_export.xlsx','par_disBIBminus','D1:D52800');
aux = zeros(length(A),4);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:200
        for ind3 = 1:11
            cont = cont+1;
            aux(cont,1) = ind1;
            aux(cont,2) = ind2;
            aux(cont,3) = ind3;
            aux(cont,end) = A(cont);
        end
    end
end
aux(aux(:,end)==tol,end) = 0;
aux(aux(:,2)>10,:) = [];
disBIBminus = aux;

% disBIBplus
A = xlsread('resultsProposed_alpha_export.xlsx','par_disBIBplus','D1:D52800');
aux = zeros(length(A),4);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:200
        for ind3 = 1:11
            cont = cont+1;
            aux(cont,1) = ind1;
            aux(cont,2) = ind2;
            aux(cont,3) = ind3;
            aux(cont,end) = A(cont);
        end
    end
end
aux(aux(:,end)==tol,end) = 0;
aux(aux(:,2)>10,:) = [];
disBIBplus = aux;

% netChBDA: net charging in DA
netChBDA = chBDA;
netChBDA(:,end) = chBDA(:,end) - disBDA(:,end);
% diffNetChBIB: difference of the net charging in IB vs DA
diffNetChBIB = chBIBminus;
diffNetChBIB(:,end) = -chBIBminus(:,end)+chBIBplus(:,end)-(-disBIBminus(:,end)+disBIBplus(:,end));

%=================================
% Consumption of the electrolyzer
%=================================

% elEDA
A = xlsread('resultsProposed_alpha_export.xlsx','par_elEDA','C1:C264');
aux = zeros(length(A),3);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:11
        cont = cont+1;
        aux(cont,1) = ind1;
        aux(cont,2) = ind2;
        aux(cont,end) = A(cont);
    end
end
aux(aux(:,end)==tol,end) = 0;
elEDA = aux;

% elEIB
A = xlsread('resultsProposed_alpha_export.xlsx','par_elEIB','D1:D52800');
aux = zeros(length(A),4);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:200
        for ind3 = 1:11
            cont = cont+1;
            aux(cont,1) = ind1;
            aux(cont,2) = ind2;
            aux(cont,3) = ind3;
            aux(cont,end) = A(cont);
        end
    end
end
aux(aux(:,end)==tol,end) = 0;
aux(aux(:,2)>10,:) = [];
elEIB = aux;

% elEIBminus
A = xlsread('resultsProposed_alpha_export.xlsx','par_elEIBminus','D1:D52800');
aux = zeros(length(A),4);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:200
        for ind3 = 1:11
            cont = cont+1;
            aux(cont,1) = ind1;
            aux(cont,2) = ind2;
            aux(cont,3) = ind3;
            aux(cont,end) = A(cont);
        end
    end
end
aux(aux(:,end)==tol,end) = 0;
aux(aux(:,2)>10,:) = [];
elEIBminus = aux;

% elEIBplus
A = xlsread('resultsProposed_alpha_export.xlsx','par_elEIBplus','D1:D52800');
aux = zeros(length(A),4);
cont = 0;
for ind1 = 1:24
    for ind2 = 1:200
        for ind3 = 1:11
            cont = cont+1;
            aux(cont,1) = ind1;
            aux(cont,2) = ind2;
            aux(cont,3) = ind3;
            aux(cont,end) = A(cont);
        end
    end
end
aux(aux(:,end)==tol,end) = 0;
aux(aux(:,2)>10,:) = [];
elEIBplus = aux;

% diffElE: difference of the consumption in IB vs DA
diffElE = elEIB;
diffElE(:,end) = -elEIBminus(:,end)+elEIBplus(:,end);

%==============
% Rescheduling
%==============

diffNetChBIBabs = abs(diffNetChBIB);
diffElEabs = abs(diffElE);
reschedulingIB = diffElE;
reschedulingIB(:,end) = diffNetChBIBabs(:,end) + diffElEabs(:,end);

diffNetChBIBabsMatrix= zeros(24, 10, 11);
for k = 1:size(diffNetChBIBabs,1)
    i = diffNetChBIBabs(k,1);
    j = diffNetChBIBabs(k,2);
    l = diffNetChBIBabs(k,3);
    diffNetChBIBabsMatrix(i,j,l) = diffNetChBIBabs(k,4);
end
diffElEabsMatrix= zeros(24, 10, 11);
for k = 1:size(diffElEabs,1)
    i = diffElEabs(k,1);
    j = diffElEabs(k,2);
    l = diffElEabs(k,3);
    diffElEabsMatrix(i,j,l) = diffElEabs(k,4);
end
reschedulingIBmatrix= zeros(24, 10, 11);
for k = 1:size(reschedulingIB,1)
    i = reschedulingIB(k,1);
    j = reschedulingIB(k,2);
    l = reschedulingIB(k,3);
    reschedulingIBmatrix(i,j,l) = reschedulingIB(k,4);
end

IBbatExpected = zeros(alphaValores,1);
IBeleExpected = zeros(alphaValores,1);
IBtotalExpected = zeros(alphaValores,1);

for alpha = 1:alphaValores
    for s = 1:sValores
        for t = 1:tValores
            IBbatExpected(alpha,1) = IBbatExpected(alpha,1) + diffNetChBIBabsMatrix(t,s,alpha)*probS(s);
            IBeleExpected(alpha,1) = IBeleExpected(alpha,1) + diffElEabsMatrix(t,s,alpha)*probS(s);
            IBtotalExpected(alpha,1) = IBtotalExpected(alpha,1) + reschedulingIBmatrix(t,s,alpha)*probS(s);
        end
    end
end

IBbatExpectedProposed = IBbatExpected;
IBeleExpectedProposed = IBeleExpected;

save('IBproposed.mat','IBbatExpectedProposed','IBeleExpectedProposed');

%%

clear;
close all;
clc;

% alphaCVaRvector
A = xlsread('resultsProposed_alpha_export.xlsx','alphaCVaRvector','B1:B11');
alphaCVaRvector = A(:,end);
alphaCVaRvector(1) = 0;

load("IBprevious.mat");
load("IBproposed.mat");

delete("IBprevious.mat");
delete("IBproposed.mat");

IBtotalExpectedPrevious = IBbatExpectedPrevious + IBeleExpectedPrevious;

IBtotalExpectedProposed = IBbatExpectedProposed + IBeleExpectedProposed;

indPrev = [1;13;25];
indProp = [1;5;11];

%% Write the results

filename = 'table03.xlsx';
titlesWrite1 = {'Expected power rescheduled (MW)'};
writecell(titlesWrite1,filename,'Range','E2');
titlesWrite2 = {'Previous model'};
writecell(titlesWrite2,filename,'Range','E3');
titlesWrite3 = {'Proposed model'};
writecell(titlesWrite3,filename,'Range','G3');
titlesWrite4 = {'Case','GammaIB','alpha','Battery','Electrolyzer','Battery','Electrolyzer'};
writecell(titlesWrite4,filename,'Range','B4');
titlesWrite5 = {'Optimistic'};
writecell(titlesWrite5,filename,'Range','B5');
titlesWrite6 = {'Intermediate'};
writecell(titlesWrite6,filename,'Range','B6');
titlesWrite7 = {'Pessimistic'};
writecell(titlesWrite7,filename,'Range','B7');
GammaIBvector = [0;12;24];
alphaVector = [0;0.5;0.999];
matrixData = [
    IBbatExpectedPrevious(indPrev(1)) IBeleExpectedPrevious(indPrev(1)) IBbatExpectedProposed(indProp(1)) IBeleExpectedProposed(indProp(1))
    IBbatExpectedPrevious(indPrev(2)) IBeleExpectedPrevious(indPrev(2)) IBbatExpectedProposed(indProp(2)) IBeleExpectedProposed(indProp(2))
    IBbatExpectedPrevious(indPrev(3)) IBeleExpectedPrevious(indPrev(3)) IBbatExpectedProposed(indProp(3)) IBeleExpectedProposed(indProp(3))
];
matrixWrite = [GammaIBvector,alphaVector,matrixData];
writematrix(matrixWrite,filename,'Range','C5');
