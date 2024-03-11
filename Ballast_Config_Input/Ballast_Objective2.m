function [g_heave, g_roll, g_pitch] = Ballast_Objective2(prompt, g0)
% Get Ballast Configuration
Ballast_Config = Ballast_Configuration(prompt);

% Compute the objective ballast term
g_obj = abs(g0 - Ballast_Term(Ballast_Config));

% Outputs
g_heave = g_obj(3);
g_roll = g_obj(4);
g_pitch = g_obj(5);
end