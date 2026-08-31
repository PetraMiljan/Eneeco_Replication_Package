%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paper Zagreb 2025
% Export results from GAMS to EXCEL
% Results of the hybrid model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Álvaro García Cerezo, Petra Miljan, Hrvoje Pandžić
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% I export the results from GDX to XLSX to analyze them and create 
% Figures 12 and 14.

clear;
close all;
clc;

filename = 'resultsHybridSPRO_Gamma.xlsx';

% GammaIBvector
A = readgdx('resultsHybridSPRO_Gamma.gdx','GammaIBvector');
A(:,1)=A(:,1)-min(A(:,1))+1;
A(A==1e-6) = 0;
GammaIBvector = A;
writematrix(GammaIBvector,filename,'Sheet','Gamma','Range','B2');

%=================
% Market position
%=================

% mpDA
A = readgdx('resultsHybridSPRO_Gamma.gdx','par_mpDA');
A(:,1)=A(:,1)-min(A(:,1))+1;
A(:,2)=A(:,2)-min(A(:,2))+1;
A(A==1e-6) = 0;
mpDA = A;
writematrix(mpDA,filename,'Sheet','mpDA','Range','B2');

% rIB
A = readgdx('resultsHybridSPRO_Gamma.gdx','par_rIB');
A(:,1)=A(:,1)-min(A(:,1))+1;
A(:,2)=A(:,2)-min(A(:,2))+1;
A(:,3)=A(:,3)-min(A(:,3))+1;
A(A==1e-6) = 0;
A(A(:,2)>10,:) = [];
rIB = A;
writematrix(rIB,filename,'Sheet','rIB','Range','B2');

% dIB
A = readgdx('resultsHybridSPRO_Gamma.gdx','par_dIB');
A(:,1)=A(:,1)-min(A(:,1))+1;
A(:,2)=A(:,2)-min(A(:,2))+1;
A(:,3)=A(:,3)-min(A(:,3))+1;
A(A==1e-6) = 0;
A(A(:,2)>10,:) = [];
dIB = A;
writematrix(dIB,filename,'Sheet','dIB','Range','B2');

%====================
% Renewable facility
%====================

% Forecast renewable production
forecastPV = [0; 0; 0; 0; 0; 0; 0; 0; 0.024865; 4.3018; 9.0652; 13.681; ...
                   14.658; 14.278; 7.9838; 4.2282; 0.8303; 0.00021938; ...
                   0; 0; 0; 0; 0; 0];
A = 1:24;
A = A';
forecastPV = [A,forecastPV];
writematrix(forecastPV,filename,'Sheet','forecastPV','Range','B2');

% resRDA
A = readgdx('resultsHybridSPRO_Gamma.gdx','par_resRDA');
A(:,1)=A(:,1)-min(A(:,1))+1;
A(:,2)=A(:,2)-min(A(:,2))+1;
A(A==1e-6) = 0;
resRDA = A;
writematrix(resRDA,filename,'Sheet','resRDA','Range','B2');

% resRIB
A = readgdx('resultsHybridSPRO_Gamma.gdx','par_resRIB');
A(:,1)=A(:,1)-min(A(:,1))+1;
A(:,2)=A(:,2)-min(A(:,2))+1;
A(:,3)=A(:,3)-min(A(:,3))+1;
A(A==1e-6) = 0;
A(A(:,2)>10,:) = [];
resRIB = A;
writematrix(resRIB,filename,'Sheet','resRIB','Range','B2');

%=========================
% Charging of the battery
%=========================

% chBDA
A = readgdx('resultsHybridSPRO_Gamma.gdx','par_chBDA');
A(:,1)=A(:,1)-min(A(:,1))+1;
A(:,2)=A(:,2)-min(A(:,2))+1;
A(A==1e-6) = 0;
chBDA = A;
writematrix(chBDA,filename,'Sheet','chBDA','Range','B2');

% chBIBminus
A = readgdx('resultsHybridSPRO_Gamma.gdx','par_chBIBminus');
A(:,1)=A(:,1)-min(A(:,1))+1;
A(:,2)=A(:,2)-min(A(:,2))+1;
A(:,3)=A(:,3)-min(A(:,3))+1;
A(A==1e-6) = 0;
A(A(:,2)>10,:) = [];
chBIBminus = A;
writematrix(chBIBminus,filename,'Sheet','chBIBminus','Range','B2');

% chBIBplus
A = readgdx('resultsHybridSPRO_Gamma.gdx','par_chBIBplus');
A(:,1)=A(:,1)-min(A(:,1))+1;
A(:,2)=A(:,2)-min(A(:,2))+1;
A(:,3)=A(:,3)-min(A(:,3))+1;
A(A==1e-6) = 0;
A(A(:,2)>10,:) = [];
chBIBplus = A;
writematrix(chBIBplus,filename,'Sheet','chBIBplus','Range','B2');

%============================
% Discharging of the battery
%============================

% disBDA
A = readgdx('resultsHybridSPRO_Gamma.gdx','par_disBDA');
A(:,1)=A(:,1)-min(A(:,1))+1;
A(:,2)=A(:,2)-min(A(:,2))+1;
A(A==1e-6) = 0;
disBDA = A;
writematrix(disBDA,filename,'Sheet','disBDA','Range','B2');

% disBIBminus
A = readgdx('resultsHybridSPRO_Gamma.gdx','par_disBIBminus');
A(:,1)=A(:,1)-min(A(:,1))+1;
A(:,2)=A(:,2)-min(A(:,2))+1;
A(:,3)=A(:,3)-min(A(:,3))+1;
A(A==1e-6) = 0;
A(A(:,2)>10,:) = [];
disBIBminus = A;
writematrix(disBIBminus,filename,'Sheet','disBIBminus','Range','B2');

% disBIBplus
A = readgdx('resultsHybridSPRO_Gamma.gdx','par_disBIBplus');
A(:,1)=A(:,1)-min(A(:,1))+1;
A(:,2)=A(:,2)-min(A(:,2))+1;
A(:,3)=A(:,3)-min(A(:,3))+1;
A(A==1e-6) = 0;
A(A(:,2)>10,:) = [];
disBIBplus = A;
writematrix(disBIBplus,filename,'Sheet','disBIBplus','Range','B2');

%================================
% State-of-energy of the battery
%================================

% soeBDA
A = readgdx('resultsHybridSPRO_Gamma.gdx','par_soeBDA');
A(:,1)=A(:,1)-min(A(:,1))+1;
A(:,2)=A(:,2)-min(A(:,2))+1;
A(A==1e-6) = 0;
soeBDA = A;
writematrix(soeBDA,filename,'Sheet','soeBDA','Range','B2');

% soeBIB
A = readgdx('resultsHybridSPRO_Gamma.gdx','par_soeBIB');
A(:,1)=A(:,1)-min(A(:,1))+1;
A(:,2)=A(:,2)-min(A(:,2))+1;
A(:,3)=A(:,3)-min(A(:,3))+1;
A(A==1e-6) = 0;
A(A(:,2)>10,:) = [];
soeBIB = A;
writematrix(soeBIB,filename,'Sheet','soeBIB','Range','B2');

%=================================
% Consumption of the electrolyzer
%=================================

% elEDA
A = readgdx('resultsHybridSPRO_Gamma.gdx','par_elEDA');
A(:,1)=A(:,1)-min(A(:,1))+1;
A(:,2)=A(:,2)-min(A(:,2))+1;
A(A==1e-6) = 0;
elEDA = A;
writematrix(elEDA,filename,'Sheet','elEDA','Range','B2');

% elEIB
A = readgdx('resultsHybridSPRO_Gamma.gdx','par_elEIB');
A(:,1)=A(:,1)-min(A(:,1))+1;
A(:,2)=A(:,2)-min(A(:,2))+1;
A(:,3)=A(:,3)-min(A(:,3))+1;
A(A==1e-6) = 0;
A(A(:,2)>10,:) = [];
elEIB = A;
writematrix(elEIB,filename,'Sheet','elEIB','Range','B2');

% elEIBminus
A = readgdx('resultsHybridSPRO_Gamma.gdx','par_elEIBminus');
A(:,1)=A(:,1)-min(A(:,1))+1;
A(:,2)=A(:,2)-min(A(:,2))+1;
A(:,3)=A(:,3)-min(A(:,3))+1;
A(A==1e-6) = 0;
A(A(:,2)>10,:) = [];
elEIBminus = A;
writematrix(elEIBminus,filename,'Sheet','elEIBminus','Range','B2');

% elEIBplus
A = readgdx('resultsHybridSPRO_Gamma.gdx','par_elEIBplus');
A(:,1)=A(:,1)-min(A(:,1))+1;
A(:,2)=A(:,2)-min(A(:,2))+1;
A(:,3)=A(:,3)-min(A(:,3))+1;
A(A==1e-6) = 0;
A(A(:,2)>10,:) = [];
elEIBplus = A;
writematrix(elEIBplus,filename,'Sheet','elEIBplus','Range','B2');
