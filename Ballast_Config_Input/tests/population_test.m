clear
clc

popSize = 100;
numGenes = 9;
num_flo = 9; % Maximum number of floaters
num_wei = 2; % Maximum number of weights

% Initialize population - encoded
population = zeros(popSize, numGenes); % Initialize population matrix with zeros

for i = 1:popSize
    % Randomly generate the number of floaters and weights for the individual
    numFloaters = randi([0, num_flo]); % Maximum num_flo floaters
    numWeights = randi([0, num_wei]);  % Maximum num_wei weights
    
    % Assign floaters
    floaterIndices = randperm(numGenes, numFloaters); % Randomly choose indices for floaters
    population(i, floaterIndices) = randi([1, 3], 1, numFloaters); % Assign random floater sizes
    
    % Assign weights
    weightIndices = randperm(numGenes, numWeights); % Randomly choose indices for weights
    population(i, weightIndices) = randi([4, 6], 1, numWeights); % Assign random weight sizes
end

% Display the initial population (optional)
disp('Initial Population:');
disp(population);
