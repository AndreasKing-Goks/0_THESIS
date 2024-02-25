function [grad] = complex_step(X, dfunargs)
    % Unpack derivative arugments
    func = dfunargs.func;
    funargs = dfunargs.funargs;

    % Step size
    h = 1e-3;

    % Number of X elements
    n = numel(X);

    % Gradient memory
    grad = zeros(size(X));
    
    % Looping process
    for i = 1:n
        % Copy of original X vector
        X_complex = X;
        
        % Do complex step
        X_complex(i) = X_complex(i) + 1i * h;
        
        % Compute complex step gradient
        if nargin(func) == 1
            grad(i) = imag(func(X_complex)) / h;
        else
            grad(i) = imag(func(X_complex, funargs)) / h;
        end
    end
end