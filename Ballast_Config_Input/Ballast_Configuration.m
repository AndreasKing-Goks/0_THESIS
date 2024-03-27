function [Ballast_Config, max_ballast] = Ballast_Configuration(prompt, funargs)
global Param_B
%% Unpack function arguments
max_f = funargs{1};
max_w = funargs{2};

%% Ballast tag
ballast_code = {'NNF' 'NFN' 'FNN' 'NFF' 'FFN' 'FNF' 'FFF' 'WA'};
ballast_force = [Param_B.Ff Param_B.Ff Param_B.Ff (2*Param_B.Ff) (2*Param_B.Ff) (2*Param_B.Ff) (3*Param_B.Ff) Param_B.Fw];
ballast_maxVal = [max_f max_w];
Center_f = Param_B.Center_f;
Center_w = Param_B.Center_w;
Center_all = [Center_f Center_w];

%% Ballast Selection Algorithm
% Create the container
Ballast_Config = cell(1,(Param_B.num_hook_floater + Param_B.num_hook_weight));

% Error tag if maximum ballast amount reached.
max_ballast = 0;

% Check prompt
for i = 1:numel(prompt)
    % If hook is unassigned, skip it
    if strcmp(prompt{i}, 'NNN') || strcmp(prompt{i}, 'WN')
        continue
    end

    % Sort the strings
    ballast = cell(1,4);

    % Loop process
    for j = 1:numel(ballast_code)
        % Check prompt type : Weights
        if strcmp(prompt{i}, 'WA')
            % Load data
            ballast{1} = Center_all{i}(1);
            ballast{2} = Center_all{i}(2);
            ballast{3} = Center_all{i}(3);
            ballast{4} = ballast_force(end);

            % Set he current weights as "used"
            ballast_maxVal(2) = ballast_maxVal(2)- 1;
            
            % We don't need to go through ballast_code, exit loop 
            break

        % Check prompt type : Floaters
        elseif strcmp(prompt{i}, ballast_code{j})
            % Load data
            ballast{1} = Center_all{i}{1}(j);
            ballast{2} = Center_all{i}{2}(j);
            ballast{3} = Center_all{i}{3}(j);
            ballast{4} = ballast_force(j);

            % Set he current floaters as "used"
            floater_reduction = sum(double(strrep(strrep(prompt{i}, 'N', '0'), 'F', '1')) - '0');

            ballast_maxVal(1) = ballast_maxVal(1)- floater_reduction;
        end
        % Check if maximum ballast amount reached
        if any(ballast_maxVal < 0)
            max_ballast = 1;
        end
    end
    Ballast_Config{i} = ballast;
end
% %% Ballast Status
% Ballast_Status = {Ballast_Config, max_ballast};
end