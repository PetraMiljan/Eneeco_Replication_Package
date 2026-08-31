%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paper Zagreb 2025
% PV Scenario Generation - Set 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Álvaro García Cerezo, Petra Miljan, Hrvoje Pandžić
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% I generate scenarios of PV production using the scenarios from set 1 as
% input data. In particular, I generate X scenarios for each scenario from
% set 1.

clear;
close all;
clc;

numScenarios = 4; % Number of scenarios generated for each scenario from 
% set 1

% Load the input data.
load('results_set1_pvScenarios.mat','scenariosProd1');

forecastProdOriginal = [0; 0; 0; 0; 0; 0; 0; 0; 0.024865; 4.3018; 9.0652; 13.681; ...
                   14.658; 14.278; 7.9838; 4.2282; 0.8303; 0.00021938; ...
                   0; 0; 0; 0; 0; 0];

relativeDeviation = 0.05;  % 0.1 = 10% of relative deviation
numHours = size(scenariosProd1,1); % Number of hours of each scenario
varH = 0.5; % dependence with respect to the deviation in the previous hour

scenariosProd = zeros(numHours, numScenarios);
scenariosProd3 = zeros(numHours, size(scenariosProd1,2)*numScenarios);

for it = 1:size(scenariosProd1,1)

    forecastProd = scenariosProd1(:,it);
    
    for i = 1:numScenarios
        for j = 1:numHours
            if forecastProd(j) == 0
                scenariosProd(j, i) = 0;
            else
                noise = relativeDeviation .* forecastProd(j) .* randn(1, 1);
                if j == 1
                    scenarioProd = forecastProd(j) + noise;
                else
                    scenarioProd = forecastProd(j) + noise + varH*( scenariosProd(j-1,i)-forecastProd(j-1) );
                end
                scenarioProd(scenarioProd < 0) = 0;  % Prevent negative values
                scenariosProd(j, i) = scenarioProd;
            end
        end
    end

    scenariosProd3(:,1+numScenarios*(it-1):numScenarios*it) = scenariosProd;

end

figure;
plot(1:numHours, forecastProdOriginal, 'k', 'LineWidth', 2); hold on;
plot(1:numHours, scenariosProd3(:, :), '--');  
xlabel('Hour');
ylabel('Power (MW)');
legend('Forecast', 'Scenarios');
axis([1 24 0 20]);
grid on;
set(gcf, 'Position', [100 100 800 400])
xticks(1:24);

% I save the results.
save('results_set3_pvScenarios','scenariosProd3');

% Save the results in a gms file.

% Open the file in which I will write the results.
fid = fopen('data_set3.gms', 'w');

% Check if the file was opened correctly.
if fid == -1
    error('The GMS file could not be created.');
end

fprintf(fid, 'Parameter ResRIBmaxSet3(t,s) Actual available production of RES (MW)\n');
fprintf(fid, '/\n');
[t, s] = size(scenariosProd3);
for i = 1:t
    for j = 1:s
        fprintf(fid, '  t%d.s%d %g\n', i, j, scenariosProd3(i,j));
    end
end
fprintf(fid, '/;\n');

% Close the file.
fclose(fid);

disp('GMS file was created correctly.');
