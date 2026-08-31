%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paper Zagreb 2025
% Modified maximum dissimilarity algorithm (MMDA) - Representative
% scenarios of PV production with 24 hours per scenario - Set 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Álvaro García Cerezo, Petra Miljan, Hrvoje Pandži
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% I initialize the MMDA selecting the scenarios with the highest and lowest
% maximum values of PV production.

clear;
close all;
clc;

k = 10; % Number of representative scenarios.

% Load the input data.
load('results_set1_pvScenarios.mat','scenariosProd1');

inputData = scenariosProd1'; % Rows scenarios, columns hours.

% Normalization of the input data is not needed since only one time serie
% is considered.

numScenarios = size(inputData,1); % Number of scenarios.
idx = 1:1:numScenarios; % Auxiliar vector with elements from 1 to 
% numScenarios.
idx = idx';
cardR = 0; % Number of scenarios included in the set of representative 
% scenarios.
representativeScenarios = zeros(k,1); % Vector that constains the index of 
% the representative scenarios.

% Compute the distance between all the scenarios.
d = pdist2(inputData,inputData); % Function pdist2(M1,M2) compute the 
% Euclidean distance between each point of M1 and each point of M2.

% Select the scenario with the highest maximum value.
highestMax = max(max(inputData));
iAux = idx(sum(highestMax==inputData,2)>=1); % The 2 is used to sum the 
% elements of the same row.
% I check that there are not several elements with the same highest value.
if length(iAux) > 1
    iAux = iAux(1); % I choose the first value.
end
cardR = cardR+1;
representativeScenarios(1,1) = iAux;

% Select the scenario with the lowest maximum value.
lowestMax = min(max(inputData,[],2));
iAux = idx(sum(lowestMax==inputData,2)>=1); % The 2 is used to sum the 
% elements of the same row.
% I check that there are not several elements with the same lowest value.
if length(iAux) > 1
    iAux = iAux(1); % I choose the first value.
end
cardR = cardR+1;
representativeScenarios(2,1) = iAux;

dR = zeros(numScenarios,1); % Vector with the minimum distance between each
% vector and the vectors within the set of representative scenarios.
dR(:,1) = min(d(:,representativeScenarios(1:2,1)),[],2);
dRnew = zeros(numScenarios,1); % Vector with the distance between each 
% vector and the last vector included in the set of representative 
% scenarios.
dRnew(:,1) = d(:,iAux);

ident = ones(numScenarios,1); % Auxiliar vector. It is equal to 0 if the 
% vector is within the set of representative scenarios.
ident(representativeScenarios(1),1) = 0;

while cardR < k
    
    % Compute the minimum distance between each vector and the vectors 
    % within the set of representative scenarios.
    dR = min([dRnew,dR],[],2); % El 2 significa que busca el mínimo por 
    % filas.
    
    % I choose the vector with the highest minimum distance with respect 
    % to the representative scenarios.
    dRmax = max(dR);
    iRmax = idx(dR==dRmax);
    % I check that there are not several elements with the same value.
    if length(iRmax) > 1
        iRmax = iRmax(1); % I choose the first value.
    end
    cardR = cardR+1;
    representativeScenarios(cardR,1) = iRmax;
    ident(representativeScenarios(cardR,1),1) = 0;
    dRnew(:,1) = d(:,representativeScenarios(cardR,1));
    
end

% I compute the weights of the representative scenarios.
% The weight of a representative scenario is equal to the number of
% scenarios that are not representative and that are closer to that
% representative scenario. Moreover, 1 is added since the representative
% scenario is an original scenario of the input data.
dw = d(idx(ident==1),representativeScenarios); % Distances between the 
% remaining scenarios and the representative scenarios.
mindw = min(dw,[],2); % The 2 is used to find the minimum of each row.
idxw = 1:1:numScenarios; % Auxiliar vector with the elements from 1 to 
% numScenarios. At the end of process, each element will have a number
% associated with the closest representative scenario.
idxw = idxw';
cont = 1;
for i = 1:numScenarios
    if sum(i==representativeScenarios) == 0
        iw = representativeScenarios(idx(mindw(cont,1)==dw(cont,:)));
        if length(iw) > 1
            iw = iw(1);
        end
        idxw(i,1) = iw;
        cont = cont+1;
    end
end
cont = 1;
weights = ones(k,1);
for i = 1:numScenarios
    if sum(i==representativeScenarios) == 1
        weights(cont,1) = sum(idxw==i);
        cont = cont+1;
    end
end

% Reviso que los pesos se han calculado correctamente.
if sum(weights) ~= numScenarios
    error('The sum of the weights is not equal to the number of scenarios within the input data.');
end

C = inputData(sort(representativeScenarios),:); % Matrix that contains the 
% data of the representative scenarios.
% I sort the vector representativeScenarios because it should match vector 
% weights.

figure;
plot(1:24,inputData(1,:),'k');
hold on;
plot(1:24,C(1,:),'r-','LineWidth',1);
plot(1:24,inputData,'k');
plot(1:24,C,'r-','LineWidth',1);
title('Modified Maximum Dissimilarity Algorithm');
xlabel('Hour');
ylabel('Power (MW)');
legend('Forecast', 'Scenarios');
axis([1 24 0 20]);
legend('Input data','Representative scenarios');
xticks([1,4:4:24]);
grid on;
xticks(1:24);
hold off;
set(gcf, 'Position', [100 100 800 400])

% I transform the weights to probabilities.
probRepScen2 = weights/sum(weights);

% I save the results.
scenariosProd2 = C'; % Rows hours, columns representative scenarios.
save('results_set2_pvScenarios','scenariosProd2','probRepScen2');

% Save the results in a gms file.

% Open the file in which I will write the results.
fid = fopen('data_set2.gms', 'w');

% Check if the file was opened correctly.
if fid == -1
    error('The GMS file could not be created.');
end

fprintf(fid, 'Parameter ResRIBmaxSet2(t,s) Actual available production of RES (MW)\n');
fprintf(fid, '/\n');
[t, s] = size(scenariosProd2);
for i = 1:t
    for j = 1:s
        fprintf(fid, '  t%d.s%d %g\n', i, j, scenariosProd2(i,j));
    end
end
fprintf(fid, '/;\n');
fprintf(fid, '\n');
fprintf(fid, 'Parameter ProbSSet2(s) Probability of RES scenario realization\n');
fprintf(fid, '/\n');
[s] = length(probRepScen2);
for i = 1:s
    fprintf(fid, '  s%d %g\n', i, probRepScen2(i));
end
fprintf(fid, '/;\n');

% Close the file.
fclose(fid);

disp('GMS file was created correctly.');
