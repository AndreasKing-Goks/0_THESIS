function [Est_Var, Obj_Val] = NIF()
%% "fmincon" parameters
% Optimization options
options = optimsoptions('fmincon','Algorithm','sqp','Display','off');

% Linear Inequatlities on X
A = []; b =[];

% Linear Equalities on X
Aeq = []; beq = [];

% Lower bounds
lb = []; 

% Upper bounds
ub = [];

%% NIF process
[Est_Var, Obj_Val] = fmincon(myfunc, Est_Var_init, A, b, Aeq, beq, lb, ub, [], options);

end