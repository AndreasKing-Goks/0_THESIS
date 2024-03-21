function g_obj = Ballast_Objective(prompt)
% Get Ballast Configuration
Ballast_Config = Ballast_Configuration(prompt);

% Compute the objective ballast term
g_obj = Ballast_Term(Ballast_Config);
end