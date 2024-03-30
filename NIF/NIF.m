function [Est_Var, Obj_Val] = NIF(obj_func, Estimation_Var)
%% "fmincon" parameters
% Define the options structure with various settings
options = optimoptions('fmincon', ...
    'OptimalityTolerance', 1e-10, ...  % Convergence tolerance
    'StepTolerance', 1e-10, ...       % Step tolerance
    'ConstraintTolerance', 1e-10, ...  % Constraint tolerance
    'MaxIterations', 400, ...         % Maximum number of iterations
    'Algorithm', 'interior-point', ...           % Optimization algorithm
    'CheckGradients', false, ...         % Cbeck gradients
    'Display', 'iter-detailed', ...            % Display output at each iteration
    'PlotFcn', @optimplotfval);       % Plot the objective function value at each iteration
% Parameters length
n = length(Estimation_Var);

% Linear Inequatlities on X
A = []; b =[];

% Linear Equalities on X
Aeq = []; beq = [];
% 
% Lower bounds
lb = zeros(1, n);
lb(n-2 : n) = -20;

% Upper bounds
ub = ones(1, n)*200;
ub(n-2 : n) = 20;

%% NIF process
[Est_Var, Obj_Val] = fmincon(obj_func, Estimation_Var, A, b, Aeq, beq, lb, ub, [], options);

end