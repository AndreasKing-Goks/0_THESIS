clear
clc
%% Initialization
% Get the input
g0 = [0; 0; 20; 0 ; 0; 0];

% Population parameters
popSize = 100;
numGenes = 9;
num_flo = 9; % Maximum number of floaters
num_wei = 2; % Maximum number of weights

% Genetic algorithm parameters
numGenerations = 100;
crossoverRate = 0.7;
mutationRate = 0.001;
fitness = zeros(popSize, length(g0));

% Initialize population - encoded
% population = randi([0 6], popSize, numGenes);
population = generate_feasible_population(popSize, numGenes, num_flo, num_wei);

% Objective function
objectiveFunction = @(prompt) abs(g0 - Ballast_Objective(prompt));

% Array to store best fitness in each generation
bestFitnessHistory = zeros(numGenerations, 1);
bestXHistory = zeros(numGenerations, 1);

for gen = 1:numGenerations
%% Evaluation
    for i = 1:popSize
        gene = population(i,:);
        prompt = decoded_gene(gene);
        fitness(i, :) = objectiveFunction(prompt);
    end
%% Population (Encoded)

%% Selection (Tournament)
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
% Find and store the best fitness and corresponding x value
[maxFitness, idx] = max(fitness);
bestFitnessHistory(gen) = maxFitness;
bestXHistory(gen) = decode(population(idx,:));
    
disp(['Generation ', num2str(gen), ': Best Fitness = ', num2str(maxFitness), ', x = ', num2str(decode(population(idx,:)))]);

end
%% Test 1
% % Array to store best fitness in each generation
% bestFitnessHistory = zeros(numGenerations, 1);
% bestXHistory = zeros(numGenerations, 1);
% 
% for gen = 1:numGenerations
%     % Evaluation
%     for i = 1:popSize
%         x = decode(population(i,:));
%         % fitness(i) = objectiveFunction(x);
%         fitness(i) = 1 / (objectiveFunction(x) + epsilon); % Inverse of the function
%         % fitness(i) = 4;
%     end
% 
%     % Selection
%     totalFitness = sum(fitness);
%     probabilities = fitness / totalFitness;
%     cumulativeProbabilities = cumsum(probabilities);
% 
%     % New generation
%     newPopulation = zeros(size(population));
%     for i = 1:popSize
%         r = rand;
%         for j = 1:popSize
%             if r <= cumulativeProbabilities(j)
%                 newPopulation(i,:) = population(j,:);
%                 break;
%             end
%         end
%     end
% 
%     % Crossover
%     for i = 1:2:popSize
%         if rand <= crossoverRate
%             crossoverPoint = randi(numGenes-1);
%             newPopulation(i,:) = [newPopulation(i,1:crossoverPoint), newPopulation(i+1,crossoverPoint+1:end)];
%             newPopulation(i+1,:) = [newPopulation(i+1,1:crossoverPoint), newPopulation(i,crossoverPoint+1:end)];
%         end
%     end
% 
%     % Mutation
%     for i = 1:popSize
%         for j = 1:numGenes
%             if rand <= mutationRate
%                 newPopulation(i,j) = 1 - newPopulation(i,j);
%             end
%         end
%     end
% 
%     % Update population
%     population = newPopulation;
% 
%     % Find and store the best fitness and corresponding x value
%     [maxFitness, idx] = max(fitness);
%     bestFitnessHistory(gen) = maxFitness;
%     bestXHistory(gen) = decode(population(idx,:));
% 
%     disp(['Generation ', num2str(gen), ': Best Fitness = ', num2str(maxFitness), ', x = ', num2str(decode(population(idx,:)))]);
% end
% 
% % Plotting the results
% figure;
% plot(1:numGenerations, bestFitnessHistory, 'LineWidth', 2);
% xlabel('Generation');
% ylabel('Best Fitness');
% title('Best Fitness Over Generations');
% 
% figure;
% plot(1:numGenerations, bestXHistory, 'LineWidth', 2);
% xlabel('Generation');
% ylabel('x Value of Best Individual');
% title('x Value of Best Individual Over Generations');

%% Test 2
% prompt = decoded_gene(population(1,:))
% 
% g_obj = Ballast_Objective(prompt)
