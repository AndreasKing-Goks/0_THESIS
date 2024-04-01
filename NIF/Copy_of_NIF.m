function [Opt_Var, Obj_Val] = NIF(obj_func, Estimation_Var, scales)
%% "fmincon" parameters
% Define the options structure with various settings
options = optimoptions('fmincon', ...
    'OptimalityTolerance', 1e-10, ...  % Convergence tolerance
    'StepTolerance', 1e-10, ...       % Step tolerance
    'ConstraintTolerance', 1e-10, ...  % Constraint tolerance
    'MaxIterations', 50, ...         % Maximum number of iterations
    'Algorithm', 'interior-point', ...           % Optimization algorithm
    'CheckGradients', false, ...         % Cbeck gradients
    'Display', 'iter-detailed', ...            % Display output at each iteration
    'PlotFcn', @optimplotfval);       % Plot the objective function value at each iteration
% Parameters length
n = length(Estimation_Var);

% Scales the estimation variable
Estimation_Var_Scaled = Estimation_Var ./ scales;

% Linear Inequatlities on X
A = []; b =[];

% Linear Equalities on X
Aeq = []; beq = [];
% 
% Lower bounds, then scaled it
lb = zeros(1, n);
lb(n-2 : n) = -20;
lb_Scaled = lb ./ scales;

% Upper bounds, then scaled it
ub = ones(1, n)*200;
ub(n-2 : n) = 20;
ub_Scaled = ub ./ scales;

%% NIF process
[Opt_Var_Scaled, Obj_Val] = fmincon(obj_func, Estimation_Var_Scaled, A, b, Aeq, beq, lb_Scaled, ub_Scaled, [], options);

%% Scaled back the Est_Var_Scaled to Est_Var
Opt_Var = Opt_Var_Scaled ./ scales;

end