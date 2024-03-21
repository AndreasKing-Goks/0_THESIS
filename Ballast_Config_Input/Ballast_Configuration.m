function [Ballast_Config, max_ballast] = Ballast_Configuration(prompt, funargs)
global Param_B
%% Unpack function arguments
max_f_s = funargs{1};
max_f_m = funargs{2};
max_f_l = funargs{3};
max_w = funargs{4};

%% Ballast tag
ballast_code = {'FS' 'FM' 'FL' 'WA'};
ballast_force = [Param_B.Ff_S Param_B.Ff_M Param_B.Ff_L Param_B.Fw];
ballast_maxVal = [max_f_s max_f_m max_f_l max_w];
ballast_posX = {Param_B.x_f Param_B.x_f Param_B.x_f Param_B.x_w};
ballast_posY = {Param_B.y_f Param_B.y_f Param_B.y_f Param_B.y_w};
ballast_posZ = {Param_B.z_f Param_B.z_f Param_B.z_f Param_B.z_w};

%% Ballast Selection Algorithm
% Create the container
Ballast_Config = cell(1,(Param_B.num_floater + Param_B.num_weight));

% Error tag if maximum ballast amount reached.
max_ballast = 0;

% Check prompt
for i = 1:numel(prompt)
    % If hook is unassigned, skip it
    if strcmp(prompt{i}, 'FN') || strcmp(prompt{i}, 'WN')
        continue
    end

    % Sort the strings
    ballast = cell(1,4);
    
    % Loop process
    for j = 1:numel(ballast_code)
        % Check prompt type : Weights
        if strcmp(prompt{i}, ballast_code{j})
            % Load data
            ballast{1} = ballast_posX{j}(1);
            ballast{2} = ballast_posY{j}(2);
            ballast{3} = ballast_posZ{j}(3);
            ballast{4} = ballast_force(j);

            % Set he current ballast as "used"
            ballast_maxVal(j) = ballast_maxVal(j)- 1;

            % Check if maximum ballast amount reached
            if ballast_maxVal(j) == 0
                max_ballast = 1;
            end
        end 
    end
    Ballast_Config{i} = ballast;
end
% %% Ballast Status
% Ballast_Status = {Ballast_Config, max_ballast};
end