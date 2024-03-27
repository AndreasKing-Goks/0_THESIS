function population = generate_feasible_population(popSize, numGenes, num_flo, num_wei)
% Need to be modified based on the available number of floater and weight

% How to use:
% Each element in the cell indicates the hook number.
% Assign the "Ballast Code" to the cell's element to attach the ballast.
% Ballast Code [dtype=string | 0 means unassigned]:
% -"FS" - Small Floater
% -"FM" - Medium Floater
% -"FL" - Large Floater
% -"WS" - Small Weight
% -"WM" - Medium Weight
% -"WL" - Large Weight 

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