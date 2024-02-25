function [X,f,n,n2,alpha_s] = strong_wolfe(func, dfunc, pk, X0, alpha_1, alpha_max, mu1, mu2, rho, maxIter, funargs, dfunargs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% strong_wolfe()                                                          %
%                                                                         %
% Implementation of the Strong Wolfe Conditions                           %
%                                                                         %
% Argument:                                                               %
% func      : The objective function                                      %
% dfunc     : The gradient function of the objective function             %
% pk        : The step direction                                          %
% X0        : The point at current iteration                              %
% alpha_1   : Initial step length                                         %
% alpha_max : Maximum allowed step length                                  %
% mu1       : Sufficient decrease factor ~ as flat as possible            %
% mu2       : Sufficient curvature factor ~ as flat as possible           %
% rho       : Step length scaling up factor                               %
% maxIter   : Maximum iteration                                           %
% funargs   : Function argument                                           %
% dfunargs  : Gradient function argument                                  %
%                                                                         %
% Output:                                                                 %
% X         : Point after the stepping forward                            %
% f         : Function value evaluated at X                               %
% n         : The amount of line search iterations                        %
% n2        : The amount of zoom phase iterations                         %
% alpha_s   : The optimal step length                                     %
%                                                                         %
% Terminology:                                                            %
% Bracketing : Finds and interval within which we are certain to find a   %
%              point that satisfies the Strong Wolfe condition            %
% Zooming    : Find the point that satisfies the Strrong Wolfe Condition  %
%              within the bracket interval                                %
%                                                                         %
% Created:      20.11.2023	Andreas Sitorus                               %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Intialization
n = 1;                          % Counter for major line search iteration
done = 0;                       % Stopping condtions if both conditions is fulfilled
alpha = zeros(1,maxIter);       % Step length container, alpha also used as the bracket boundaries
alpha(2) = alpha_1;             % Initial step
phi = zeros(1,maxIter);         % Function value evaluation container (as a function of alpha)
dphi = zeros(maxIter);          % Gradient container
n2 = 0;                         % Counter for zoom stage


%% Line search evaluation
% Function's value at the starting point
if nargin(func) == 1
    phi0 = func(X0);
else
    phi0 = func(X0,funargs);
end

% Gradient at the starting point
if nargin(dfunc) == 1
    phiPrime0 = dfunc(X0).'*pk;
else
    phiPrime0 = dfunc(X0,dfunargs).'*pk; 
end 

%% Line search process
while (~done && n<maxIter) 
% Stop if (the Sufficient Decrease and Sufficient Curvature Condition is 
% fulfilled or Sufficient Decrease Condition is not fulfilled at all), OR, 
% maximum iterations is already achieved
    
    % Evaluate line search value at current iteration
    if nargin(func) == 1
        phi(n) = func(X0+alpha(n) * pk);
    else
        phi(n) = func(X0+alpha(n) * pk, funargs);
    end

    if ((phi(n) > phi0 + mu1*alpha(n)*(phiPrime0)) || (n>1 && phi(n) > phi(n-1))) 
        % The Sufficient Decrease is not fullfilled at first iteration, OR,
        % the current iteration value is bigger than the previous iteration
        % value (Value is not decreasing). STOP
        if n>1
            % Do zoom phase inside the bracket
            [alpha_s, n2] = wolfe_zoom(alpha(n-1), alpha(n), func, dfunc, pk, X0, mu1, mu2, maxIter,funargs,dfunargs);
        else
            % At first iteration, do zoom phase between current step length
            % and zero, get the step length
            [alpha_s, n2] = wolfe_zoom(0,alpha_1, func, dfunc, pk, X0, mu1, mu2, maxIter,funargs,dfunargs);
        end
        
        % Move to the next point
        X = X0+alpha_s * pk;

        % Evaluate function at this point
        if nargin(func) == 1
            f = func(X);
        else
            f = func(X,funargs);
        end
        done = 1; % STOP

    else 
        % Sufficient Decrease is fulfilled, evaluated gradient could be
        % positive (increasing value) or negative (decreasing value) as
        % long.

        % Evaluate gradient to check curvature condition
        if nargin(dfunc) == 1
            dphi(n) = (dfunc(X0+alpha(n) * pk)).'*pk;
        else
            dphi(n) = (dfunc(X0+alpha(n) * pk,dfunargs)).'*pk; 
        end 

        if abs(dphi(n)) <= -mu2 * phiPrime0 
            % Curvature condition is fulfilled (Gradient at current
            % iteration is flatter than the Sufficient Curvature Gradient)
            
            % Use this iteration step length
            alpha_s = alpha(n);

            % Move to the next point
            X = X0+alpha_s * pk;

            % Evaluate the function at this point
            if nargin(func) == 1
                f = func(X);
            else
                f = func(X,funargs);
            end
            done = 1; % STOP

        elseif dphi(n) >= 0
            % Curvature condition is not fulfilled yet, positive gradient
            % (value increasing)

            if n>1
                % Do zoom phase inside the bracket, get the step length.
                % Sufficient Decrease Condition is achieved, prev alpha
                % becomes alpha_hi
                [alpha_s, n2] = wolfe_zoom(alpha(n),alpha(n-1), func, dfunc, pk, X0, mu1, mu2, maxIter,funargs,dfunargs);
            else
                % At first iteration, do zoom phase between current step 
                % length and zero, get the step length
                [alpha_s, n2] = wolfe_zoom(0,alpha(n), func, dfunc, pk, X0, mu1, mu2, maxIter,funargs,dfunargs);
            end

            % Move to the next point
            X = X0+alpha_s * pk;
            
            % Evaluate the function at this point
            if nargin(func) == 1
                f = func(X);
            else
                f = func(X,funargs);
            end
            done = 1; % STOP

        else
            % Curvature is not fulfilled and it still negative (value still
            % decreasing)
            
            % Pick the a bigger step length for the next iteration. It must
            % not be bigger than the maximum step length
            alpha(n+1) = min([alpha(n+1)*rho, alpha_max]);

            
            % But if the next step length bigger equal than the maximum
            % step length, force the next step length as the maximum step
            % length
            if alpha(n+1) >= alpha_max
                % Use the maximum step length as the current iteration step
                % length
                alpha_s = alpha_max; 
                
                % Move to the next point
                X = X0+alpha_s * pk;
                
                % Evaluate the function at this point
                if nargin(func) == 1
                    f = func(X);
                else
                    f = func(X,funargs);
                end
                done = 1; % STOP
            end
        end
    end
    % Continue to the next iteration
    n = n+1; 
end

if n==maxIter
    % We reach the maximum iteration, so we use the last computed step
    % length to move on
    
    % Use the last computed step length as the current iteration step
    % length
    alpha_s=alpha(end);

    % Move to the next point
    X = X0+alpha_s * pk;

    % Evaluate the function at this point
    if nargin(func) == 1
        f = func(X);
    else
        f = func(X,funargs);
    end 
end