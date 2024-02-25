function [alpha_s, n] = wolfe_zoom(alpha_lo, alpha_hi, func, dfunc, pk, X0, mu1, mu2, maxIter, funargs, dfunargs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% wolfe_zoom()                                                            %
%                                                                         %
% Implementation of the Zooming Phase of the Strong Wolfe Line Search     %
%                                                                         %
% Argument:                                                               %
% alpha_lo  : Interval endpoint with lower function value                 %
% alpha_hi  : Interval endpoint with higher function value                %
% func      : The objective function                                      %
% dfunc     : The gradient function of the objective function             %
% pk        : The step direction                                          %
% X0        : The point at current iteration                              %
% mu1       : Sufficient decrease factor ~ as flat as possible            %
% mu2       : Sufficient curvature factor ~ as flat as possible           %
% maxIter   : Maximum iteration                                           %
% dfunargs  : Gradient function argument                                  %
%                                                                         %
% Output:                                                                 %
% alpha_s   : The optimal step length                                     %
% n         : The amount of line search iterations                        %
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
%% Initialization
done = 0;                    % Stopping flag if both conditions is fulfilled
if nargin(func) == 1         % Container of evaluated function value
    fk = func(X0);
else
    fk = func(X0,funargs);
end
if nargin(dfunc) == 1        % Container of evaluated gradient
    gk = dfunc(X0);
else
    gk = dfunc(X0,dfunargs);
end
alpha = zeros(1,maxIter);    % Step length container, alpha also used as the bracket boundaries
falpha = zeros(1,maxIter);   % Function value evaluated at new point using current step length
dfalpha = zeros(1,maxIter);  % Gradient of the function evaluated at new point using current step length

%% Zoom phase evaluation
% Function evaluation at lower bracket
if nargin(func) == 1
    flo = func(X0+alpha_lo * pk);
else
    flo = func(X0+alpha_lo * pk,funargs);
end

% Start zoom phase counter
n = 1;

%% Zoom phase process
while (~done && n<maxIter)
    % Stop if (the Sufficient Decrease and Sufficient Curvature Condition is 
    % fulfilled or Sufficient Decrease Condition is not fulfilled at all), OR, 
    % maximum iterations is already achieved

    % Do simple interpolation between lower bracket and higher bracket to
    % get an initial zoom phase step length
    alpha(n) = (alpha_lo + alpha_hi)/2; 
    
    % Evaluate function at the new point after stepping
    if nargin(func) == 1
        falpha(n) = func(X0+alpha(n) * pk);
    else
        falpha(n) = func(X0+alpha(n) * pk,funargs);
    end
    
    if (falpha(n) > fk + mu1*alpha(n)*(gk'*pk)) || (falpha(n) > flo)
        % If the evaluated function value bigger than the Sufficient 
        % Decrease Condition, OR, the evaluated function value is bigger
        % than the lower bracket, set the high interval endpoint as the
        % interpolated zoom phase step length.
        alpha_hi = alpha(n);
    else
        % Sufficient Decrease Condition fulfilled
        if nargin(dfunc) == 1
            dfalpha(n) = dfunc(X0+alpha(n) * pk).'* pk;
        else
            dfalpha(n) = dfunc(X0+alpha(n) * pk,dfunargs).'* pk;
        end 

        if abs(dfalpha(n)) <= mu2*abs(gk'*pk)
            % Evaluated gradient at initial zoom phase step length is below
            % the criteria
            done = 1; % STOP

        elseif dfalpha(n)*(alpha_hi-alpha_lo) >= 0
            % Bracket is not defined because evaluated gradient at initial
            % zoom phase step length is increasing, initial zoom phase step
            % length becomes higher bracket interval
            alpha_hi = alpha(n);
        else
            % Bracket is not defined because evaluated gradient at initial
            % zoom phase step length is decreasing, initial zoom phase step
            % length becomes lower bracket interval
            alpha_lo = alpha(n);
        end
    end
    % Continue to the next iteration
    n = n+1;
    
end

% Pick the optimal step length
% Why (n-1)?
% We input lower bracket and higher bracket at first
% The optimal step length always lies between lower bracket and higher
% bracket
alpha_s = alpha(n-1);
