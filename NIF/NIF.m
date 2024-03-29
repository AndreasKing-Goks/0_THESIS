function [Est_Var, Obj_Val] = NIF(obj_func, Estimation_Var)
%% "fmincon" parameters
% Define the options structure with various settings
options = optimoptions('fmincon', ...
    'OptimalityTolerance', 1e-10, ...  % Convergence tolerance
    'StepTolerance', 1e-10, ...       % Step tolerance
    'ConstraintTolerance', 1e-10, ...  % Constraint tolerance
    'MaxIterations', 400, ...         % Maximum number of iterations
    'Algorithm', 'interior-point', ...           % Optimization algorithm
    'CheckGradients', true, ...         % Cbeck gradients
    'Display', 'iter-detailed', ...            % Display output at each iteration
    'PlotFcn', @optimplotfval);       % Plot the objective function value at each iteration

% Linear Inequatlities on X
A = []; b =[];

% Linear Equalities on X
Aeq = []; beq = [];

% Lower bounds
lb = []; 

% Upper bounds
ub = [];

%% NIF process
[Est_Var, Obj_Val] = fmincon(obj_func, Estimation_Var, A, b, Aeq, beq, lb, ub, [], options);

end