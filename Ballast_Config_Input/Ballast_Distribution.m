clear
clc
%% Initialization
% Get the input
% g0 = [0; 0; -15; 2; 1.5; 0];
g0 = [0; 0; -15; 0; 0; 0];

% Population parameters
popSize = 5000;
numGenes = 9;
num_flo = 9; % Maximum number of floaters
num_wei = 2; % Maximum number of weights

% Genetic algorithm parameters
numGenerations = 30;
crossoverRate = 0.7;
mutationRate = 0.001;
fitness = zeros(popSize,1);
epsilon = 1e-6;

% Initialize population - encoded
% population = randi([0 6], popSize, numGenes);
population = generate_feasible_population(popSize, numGenes, num_flo, num_wei);

% Objective function
objectiveFunction = @(prompt) sum((g0 - Ballast_Objective(prompt)).^2);

% Array to store best fitness in each generation
bestFitnessHistory = zeros(numGenerations, 1);
bestXHistory = cell(numGenerations, numGenes);

% Initialize containers to store evolution data
populationHistory = cell(numGenerations, 1);
fitnessHistory = cell(numGenerations, 1);

for gen = 1:numGenerations
%% Evaluation
    for i = 1:popSize
        gene = population(i,:);
        prompt = decoded_gene(gene);
        % fitness(i, :) = 1 / (objectiveFunction(prompt) + epsilon);
        fitness(i, :) = objectiveFunction(prompt);
    end
%% Selection (Tournament)
% Tournament selection parameters
    tournamentSize = 2; 

% New generation
    newPopulation = zeros(size(population));
    for i = 1:popSize
    % Select several genes via tournament selection and choose the best
    % gene. The best gene are the one with smallest fitness value
        winnerIndex = Tournament_Selection(fitness, tournamentSize);
        newPopulation(i,:) = population(winnerIndex,:);
    end

%% Crossover
    for i = 1:2:popSize
        if rand <= crossoverRate
            crossoverPoint = randi(numGenes-1);
            newPopulation(i,:) = [newPopulation(i,1:crossoverPoint), newPopulation(i+1,crossoverPoint+1:end)];
            newPopulation(i+1,:) = [newPopulation(i+1,1:crossoverPoint), newPopulation(i,crossoverPoint+1:end)];
        end
    end

%% Mutation
    for i = 1:popSize
        for j = 1:numGenes
            if rand <= mutationRate
                newPopulation(i,j) = 1 - newPopulation(i,j);
            end
        end
    end

%% Finalization
% Final Evaluation
    for i = 1:popSize
        newGene = newPopulation(i,:);
        newPrompt = decoded_gene(newGene);
        fitness(i, :) = objectiveFunction(newPrompt);
    end
% Find and store the best fitness and corresponding the prompt, track
% fitness history
    [optFitness, idx] = min(fitness);
    bestFitnessHistory(gen) = optFitness;
    bestXHistory(gen,:) = decoded_gene(newPopulation(idx,:));
    fitnessHistory{gen} = fitness;

% Set altered population as the initial population for next generation,
% track the population history
    population = newPopulation;
    populationHistory{gen} = population;
    
% disp(['Generation ', num2str(gen), ': Best Fitness = ', num2str(maxFitness), ', Best Ballast Configuration = ', bestBallastConfigStr]);
    disp(['Generation ', num2str(gen), ': Best Fitness = ', num2str(optFitness)]);
end

optimalPrompt = bestXHistory(end,:)
optimalObj = objectiveFunction(optimalPrompt)

best_config = Ballast_Configuration(optimalPrompt)
best_ballast_term = Ballast_Term(best_config) 
residual = (g0 - best_ballast_term)
