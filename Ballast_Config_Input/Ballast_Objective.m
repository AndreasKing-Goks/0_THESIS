function objective_val = Ballast_Objective(prompt, ofunargs)
%% Unload ofunargs
g0 = ofunargs{1};
penalty = ofunargs{2};
funargs = ofunargs{3};

%% Get Ballast Configuration
[Ballast_Config, max_ballast] = Ballast_Configuration(prompt, funargs);

%% Compute the objective value
g_obj = Ballast_Compute(Ballast_Config);

objective = g_obj(3:5) - g0(3:5);

% objective_val = objective' * objective;

% objective_val = sum(abs(objective));
w1 = 20;
w2 = 1;
w3 = 1;
objective_val = w1*abs(objective(1)) + w2*abs(objective(2)) + w3*abs(objective(3));

% Add penalty if heave residual is positive (negatively buoyant)
if objective(1) > 0
    % objective_val = objective_val + penalty;
end
end