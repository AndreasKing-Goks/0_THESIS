function winnerIndex = Tournament_Selection(fitness, tournamentSize)
    % Randomly select contestants
    contestantIndices = randperm(length(fitness), tournamentSize);
    % Get the fitness values of the contestants
    contestantFitness = fitness(contestantIndices);
    % Find the index of the contestant with the smallest fitness value
    [~, bestContestantIdx] = max(contestantFitness);
    % Return the index of the winning individual in the population
    winnerIndex = contestantIndices(bestContestantIdx);
end
