%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paper Zagreb 2025
% PV Scenario Generation - Set 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Álvaro García Cerezo, Petra Miljan, Hrvoje Pandžić
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% I generate the scenarios of PV production.

clear;
close all;
clc;

rng(108); % I set the seed to always obtain the same scenarios

% I use the same forecast production that Petra used in her paper (the one 
% published in CSEE JPES)
forecastProd = [0; 0; 0; 0; 0; 0; 0; 0; 0.024865; 4.3018; 9.0652; 13.681; ...
                   14.658; 14.278; 7.9838; 4.2282; 0.8303; 0.00021938; ...
                   0; 0; 0; 0; 0; 0];

numScenarios = 50; % Number of scenarios generated.
relativeDeviation = 0.1;  % 0.1 = 10% of relative deviation
numHours = length(forecastProd); % Number of hours of each scenario
varH = 0.5; % dependence with respect to the deviation in the previous hour
scenariosProd = zeros(numHours, numScenarios);

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

figure;
plot(1:numHours, forecastProd, 'k', 'LineWidth', 2); hold on;
plot(1:numHours, scenariosProd(:, :), '--');  
xlabel('Hour');
ylabel('Power (MW)');
legend('Forecast', 'Scenarios');
axis([1 24 0 20]);
grid on;
set(gcf, 'Position', [100 100 800 400])
xticks(1:24);

% I save the results.
scenariosProd1 = scenariosProd;
save('results_set1_pvScenarios','scenariosProd1');
