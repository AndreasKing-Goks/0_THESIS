function [X,f,n,n2,n3,hist] = SGD(func, dfunc, X0, Eg, Ea, Er, maxIter, alpha_1, alpha_max, mu1, mu2,rho, maxMinorIter, X_Tol, funargs, dfunargs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SGD()                                                                   %
%                                                                         %
% Implementation of the Steepes Gradient Descent                          %
%                                                                         %
% Argument:                                                               %
% func          : The objective function                                  %
% dfunc         : The gradient function of the objective function         %
% X0            : The point at current iteration                          %
% Eg            : Gradient Tolerance                                      %
% Ea            : Absolute Tolerance                                      %
% Er            : Relative Tolerance                                      %
% maxIter       : Maximum SGD Iteration                                   %
% alpha_1       : Initial step length                                     %
% alpha_max     : Maximum allowr step length                              %
% mu1           : Sufficient decrease factor ~ as flat as possible        %
% mu2           : Sufficient curvature factor ~ as flat as possible       %
% rho           : Step length scaling up factor                           %
% maxMinotIter  : Maximum Iteration for Strong Wolfe Condition            %
% X_Tol         : Initial step length                                     %
% funargs       : Function argument                                       %
% dfunargs      : Gradient function argument                              %
%                                                                         %
% Output:                                                                 %
% X         : Point after the stepping forward                            %
% f         : Function value evaluated at X                               %
% n         : The amount of SGD iterations                                %
% n2        : The amount of Strong Wolfe iterations                       %
% n3        : The amount of zoom phase iterations                         %
% hist      : X and function value throughout the iterations process      %
%                                                                         %
% Created:      20.11.2023	Andreas Sitorus                               %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialization
n2 = zeros(maxIter,1);              % Strong Wolfe iteration
n3 = zeros(maxIter,1);              % Zoom phase iteration
hist = [];                          % History counter for plotting (Point and Function Value)
k = 1;                              % SGD iteration
Xs = zeros(length(X0),maxIter+1);   % X point after step
fs = zeros(maxIter+1,1);            % Function value evaluated at Xs
cond_1 = zeros(maxIter+1,1);        %
gk = zeros(length(X0),maxIter);     % Gradient container
pk = zeros(length(X0),maxIter);     % Direction container
done = 0;                           % Stopping flag for convergence
X_change = X_Tol+1;                 % First iteration convergence criteria
Xs(:,1) = X0;                       % Initial point
conv_status = 0;                    % Convergence status.

%% SGD process
while k<=maxIter && ~done
    % Stop if iteration process reach tha maximum or convergence criteria
    % is fulfilled

    % Compute the gradient of the function
    if nargin(dfunc) == 1
        gk(:,k) = dfunc(Xs(:,k));
    else
        gk(:,k) = dfunc(Xs(:,k),dfunargs);
    end
    
    % Convergence check
    % Only after the first iteration
    if k>1
        % After the first iteration, compute difference criteria
        X_change = abs(Xs(:,k) - Xs(:,k-1) );
    end
    
    % Stop if gradient lower than the gradient criteria and point
    % difference criteria
    if (norm(gk(:,k),2) <= Eg && (max(X_change) < X_Tol))
        X = Xs(:,k);
        if nargin(func) == 1
            f = func(X);
        else
            f = func(X,funargs);
        end
        conv_status = 1;
        done = 1; % STOP
    else
        % If criteria is not fulfilled, compute the direction
        pk(:,k) = -gk(:,k)/norm(gk(:,k),2);

        % Compute a line search to find the new step length in the direction of pk
        [Xs(:,k+1),fs(k+1),n2(k),n3(k),alpha_s] = strong_wolfe(func, dfunc, pk(:,k), Xs(:,k), alpha_1,...
            alpha_max, mu1, mu2,rho, maxMinorIter,funargs,dfunargs);
        
        % Store the optimized step length as the step length for the next search
        if k>1
            scale_factor = (gk(:,k-1).'*pk(:,k-1))/(gk(:,k).'*pk(:,k));
            alpha_1 = alpha_s * scale_factor; 
        else
            % For the first iteration only 
            alpha_1 = alpha_s; 
        end
        
        % Evaluate the value for current iteration at current stepping
        % point
        if nargin(func) == 1
            fs(k) = func(Xs(:,k));
        else
            fs(k) = func(Xs(:,k),funargs);
        end

        % Check for convergence criteria
        % Compute the status (Boolean) value difference criteria
        cond_1(k) = abs(fs(k+1) - fs(k)) <= (Ea + Er*abs(fs(k)));

        if (k>1) && (cond_1(k) == 1) 
            % If it is not the first iteration and convergence criteria is
            % True
            X_change = abs(Xs(:,k) - Xs(:,k-1) );
            
            % If the maximum X difference lower than the criteria, stop.
            if max(X_change) < X_Tol
                % Get the point for this iteration
                X = Xs(:,k);

                % Get the function value for this iteration
                f = fs(k);
                conv_status = 2;
                done = 1; % STOP
            end
        end
    end
    % ITEERATION UPDATE
    Iteration = k;
    SW_Iter = n2(k);
    ZP_Iter = n3(k);
    Current_pos = [Xs(1,k), Xs(2,k)];
    Current_val = fs(k,1);
    l_r = alpha_1;
    dirc = [pk(1,1), pk(2,1)];
    
    fprintf('Iteration: %d,  Strong Wolve Iteration: %d, zoom phase iteration: %d, current position: [%.5f, %.5f], current value: %.5f, step length: %.5f, direction: [%.5f, %.5f]\n', ...
    Iteration, SW_Iter, ZP_Iter, Current_pos(1), Current_pos(2), Current_val, l_r, dirc(1), dirc(2));
    
    % Continue to the next iteration
    k = k+1;
end

% PRINT STOPPING STATUS
if conv_status == 1
    disp('Current gradient is lower than the allowed criteria: MINIMUM Achieved')
elseif conv_status == 2
    disp('Optimality condition is fulfilled: MINIMUM Achieved')
else
    disp('Maximum iteration reached')
end

% If the iteration process goes above maximum iteration, get the current
% point and current function value
if k>=maxIter
    X = Xs(:,k);
    f = fs(k);
end

% Match the n with iteration k
n = k-1;

% Store the history
hist = [Xs(:,1:n).' fs(1:n)];
n2 = n2(1:n); 
n3 = n3(1:n); 