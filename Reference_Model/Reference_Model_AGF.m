function [val_checkpoints, time_stamps] = Reference_Model_AGF(set_points)
    % Adding additional step points to make a step signal set points

    %% Initialize the new cell array
    new_set_points = {};

    %% Iterate through the original cell array
    for i = 1:numel(set_points)-1
        % Add the current element
        new_set_points{end+1} = set_points{i};

        % Add the new element between the current and next elements
        new_element = [set_points{i}(1), set_points{i+1}(2)];
        new_set_points{end+1} = new_element;
    end

    %% Add the last element from the original cell array
    new_set_points{end+1} = set_points{end};

    %% Data Extracting
    % Set the empty container.
    val_checkpoints = zeros(1, numel(new_set_points));
    time_stamps = zeros(1, numel(new_set_points));

    % Extract set points data
    for i = 1:numel(new_set_points) 
        val_checkpoints(i) = new_set_points{i}(1); % Access the first element
        time_stamps(i) = new_set_points{i}(2); % Access the second element
    end
end
