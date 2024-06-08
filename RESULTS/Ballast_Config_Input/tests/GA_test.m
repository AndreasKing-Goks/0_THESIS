clear
clc

% Extended Genetic Algorithm with Plotting
popSize = 100;
numGenes = 10;
numGenerations = 100;
crossoverRate = 0.7;
mutationRate = 0.001;
fitness = zeros(popSize, 1);

% Initialize population
population = randi([0 1], popSize, numGenes);

% Convert binary to decimal
decode = @(individual) -10 + sum(individual .* (2.^(numGenes-1:-1:0))) * 20 / (2^numGenes - 1);

% Objective function
objectiveFunction = @(x) x^2;

% Epsilon
epsilon = 1e-6; % Small constant to prevent division by zero

% Array to store best fitness in each generation
bestFitnessHistory = zeros(numGenerations, 1);
bestXHistory = zeros(numGenerations, 1);

for gen = 1:numGenerations
    % Evaluation
    for i = 1:popSize
        x = decode(population(i,:));
        % fitness(i) = objectiveFunction(x);
        fitness(i) = 1 / (objectiveFunction(x) + epsilon); % Inverse of the function
        % fitness(i) = 4;
    end
    
    % Selection
    totalFitness = sum(fitness);
    probabilities = fitness / totalFitness;
    cumulativeProbabilities = cumsum(probabilities);
    
    % New generation
    newPopulation = zeros(size(population));
    for i = 1:popSize
        r = rand;
        for j = 1:popSize
            if r <= cumulativeProbabilities(j)
                newPopulation(i,:) = population(j,:);
                break;
            end
        end
    end
    
    % Crossover
    for i = 1:2:popSize
        if rand <= crossoverRate
            crossoverPoint = randi(numGenes-1);
            newPopulation(i,:) = [newPopulation(i,1:crossoverPoint), newPopulation(i+1,crossoverPoint+1:end)];
            newPopulation(i+1,:) = [newPopulation(i+1,1:crossoverPoint), newPopulation(i,crossoverPoint+1:end)];
        end
    end
    
    % Mutation
    for i = 1:popSize
        for j = 1:numGenes
            if rand <= mutationRate
                newPopulation(i,j) = 1 - newPopulation(i,j);
            end
        end
    end
    
    % Update population
    population = newPopulation;
    
    % Find and store the best fitness and corresponding x value
    [maxFitness, idx] = max(fitness);
    bestFitnessHistory(gen) = maxFitness;
    bestXHistory(gen) = decode(population(idx,:));
    
    disp(['Generation ', num2str(gen), ': Best Fitness = ', num2str(maxFitness), ', x = ', num2str(decode(population(idx,:)))]);
end

% Plotting the results
figure;
plot(1:numGenerations, bestFitnessHistory, 'LineWidth', 2);
xlabel('Generation');
ylabel('Best Fitness');
title('Best Fitness Over Generations');

figure;
plot(1:numGenerations, bestXHistory, 'LineWidth', 2);
xlabel('Generation');
ylabel('x Value of Best Individual');
title('x Value of Best Individual Over Generations');
