%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paper Zagreb 2025
% Imbalance Scenarios
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Álvaro García Cerezo, Petra Miljan, Hrvoje Pandžić
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% I removed manually the data for 2:00h-3:00h of 27.10.2024 due to the hour
% changed. If I do not remove this, I would have one additional hour so the
% total data are not 366 days exactly.
% All hours should be associated with deficit or surplus, but not balanced.

clear;
close all;
clc;

A = xlsread('ImbalanceCroatia2024.xlsx','U2:U35137');
imbalanceData = A;
balanced = 0;
balancedDeficit = 0;
balancedSurplus = 0;
imbalanceDataHour = zeros(length(A)/4,1);
for i = 1:size(imbalanceDataHour,1)
    imbalanceDataHour(i) = sum(imbalanceData(i:i+3));
    if imbalanceDataHour(i) > 0 % Surplus
        imbalanceDataHour(i) = -1;
    elseif imbalanceDataHour(i) < 0 % Deficit
        imbalanceDataHour(i) = 1;
    else % Balanced -> Create surplus or deficit randomly
        imbalanceDataHour(i) = 1-2*round(rand);
        balanced = balanced+1;
        if  imbalanceDataHour(i) == 1
            balancedDeficit = balancedDeficit + 1;
        else 
            balancedSurplus = balancedSurplus + 1;
        end
    end
end
deficit = sum(imbalanceDataHour==1);
surplus = sum(imbalanceDataHour==-1);
if deficit + surplus ~= size(imbalanceDataHour,1)
    error('There are hours associated with something different from deficit or surplus.');
end
numDays = size(imbalanceDataHour,1)/24;
imbalanceMatrix = zeros(numDays,24);
row = 1;
column = 0;
for i = 1:length(imbalanceDataHour)
    if column+1 > 24
        column = 1;
        row = row+1;
    else
        column = column+1;
    end
    imbalanceMatrix(row,column) = imbalanceDataHour(i);
end

% I save the results.
imbalanceScen = imbalanceMatrix;
save('results_imbalanceScenarios','imbalanceScen');

% Save the results in a gms file.

% Open the file in which I will write the results.
fid = fopen('data_imbalance.gms', 'w');

% Check if the file was opened correctly.
if fid == -1
    error('The GMS file could not be created.');
end

fprintf(fid, 'Parameter ImbalanceDev(xi,t) Realization of the imbalance price deviation \n');
fprintf(fid, '/\n');
[xi, t] = size(imbalanceScen);
for i = 1:xi
    for j = 1:t
        fprintf(fid, '  xi%d.t%d %g\n', i, j, imbalanceScen(i,j));
    end
end
fprintf(fid, '/;\n');

% Close the file.
fclose(fid);

disp('GMS file was created correctly.');
