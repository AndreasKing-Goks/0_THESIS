function [Est_Var, Obj_Val] = NIF(obj_func, Estimation_Var)
%% "fmincon" parameters
% Optimization options
options = optimoptions('fmincon','Algorithm','sqp','Display','off');

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