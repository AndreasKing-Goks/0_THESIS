function [Opt_Var, Obj_Val] = NIF(obj_func, Estimation_Var, scales)
%% Start Elapsed Time Counter
tic

%% "fmincon" parameters
% Define the options structure with various settings
options = optimoptions('fmincon', ...
    'OptimalityTolerance', 1e-20, ...   % Convergence tolerance
    'StepTolerance', 1e-20, ...         % Step tolerance
    'ConstraintTolerance', 1e-20, ...   % Constraint tolerance
    'MaxIterations', 100, ...           % Maximum number of iterations
    'Algorithm', 'sqp', ...             % Optimization algorithm
    'ObjectiveLimit', 1e-40, ...        % Objective Limit
    'ScaleProblem', true, ...           % Problem Scale
    'CheckGradients', false, ...        % Cbeck gradients
    'Display', 'iter-detailed', ...     % Display output at each iteration
    'PlotFcn', @optimplotfval);         % Plot the objective function value at each iteration

% Parameters length
n = length(Estimation_Var);

% Scales the estimation variable
Estimation_Var = Estimation_Var ./ scales;

% Linear Inequatlities on X
A = []; b =[];

% Linear Equalities on X
Aeq = []; beq = [];
% 
% Lower bounds, then scaled it
lb = zeros(1, n);
lb(n-2 : n) = -20;
lb = lb ./ scales;

% Upper bounds, then scaled it
ub = ones(1, n)*200;
ub(n-2 : n) = 20;
ub = ub ./ scales;

%% NIF process
[Opt_Var, Obj_Val] = fmincon(obj_func, Estimation_Var, A, b, Aeq, beq, lb, ub, [], options);

%% Scaled back the Est_Var_Scaled to Est_Var
Opt_Var = Opt_Var .* scales;

%% Display Elapsed Time
Elapsed_Time = toc;
fprintf('Elapsed time for the NIF method is %f seconds.\n', Elapsed_Time);

end