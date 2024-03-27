function objective_val = Ballast_Objective(prompt, ofunargs)
%% Unload ofunargs
g0 = ofunargs{1};
penalty = ofunargs{2};
funargs = ofunargs{3};

%% Get Ballast Configuration
[Ballast_Config, max_ballast] = Ballast_Configuration(prompt, funargs);

%% Compute the objective value
g_obj = Ballast_Compute(Ballast_Config);

objective = g0 - g_obj;

% objective_val = objective' * objective;

objective_val = sum(abs(objective));

% Add penalty if max ballast usage is reached
if max_ballast == 1
    objective_val = objective_val + penalty;
end
end