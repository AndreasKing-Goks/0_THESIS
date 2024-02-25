function [grad] = finite_difference(X, dfunargs)
    % Unpack derivative arugments
    func = dfunargs.func;
    funargs = dfunargs.funargs;

    % Step size
    h = 1e-10;

    % Number of X elements
    n = numel(X);

    % Gradient memory
    grad = zeros(size(X,1), size(X,2));
    
    % Looping process
    for i = 1:n
        % Copy of the original vector X
        X_perturbed = X;

        % Perturb the X vector
        X_perturbed(i) = X_perturbed(i) + h;
        
        % Compute complex step gradient
        if nargin(func) == 1
            grad(i) = (func(X_perturbed)-obj_func(X)) / h;
        else
            grad(i) = (func(X_perturbed, funargs)-obj_func(X, funargs)) / h;
        end
    end
end