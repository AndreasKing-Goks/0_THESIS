function stop = optimplotfvalNIF(~,optimValues,state,varargin)
    % OPTIMPLOTFVAL Plot value of the objective function at each iteration.
    %
    %   STOP = OPTIMPLOTFVAL(X,OPTIMVALUES,STATE) plots OPTIMVALUES.fval.  If
    %   the function value is not scalar, a bar plot of the elements at the
    %   current iteration is displayed.  If the OPTIMVALUES.fval field does not
    %   exist, the OPTIMVALUES.residual field is used.
    %
    %   Example:
    %   Create an options structure that will use OPTIMPLOTFVAL as the plot
    %   function
    %     options = optimset('PlotFcns',@optimplotfval);
    %
    %   Pass the options into an optimization problem to view the plot
    %     fminbnd(@sin,3,10,options)

    %   Copyright 2006-2023 The MathWorks, Inc.

    %   MODIFIED BY ANDREAS SITORUS 01.04.2024
    %   USED ONLY FOR NIF PROJECT ONLY

    % Always return a "stop" flag of false
%     stop = false; % Always return a "stop" flag of false
%     persistent iter fval
% 
%     switch state
%         case "init"
%             iter = [];
%             fval = [];
%             figure; % Create a new figure for the plot
%             hold on; % Hold on to plot dots and lines together
%         case "iter"
%             iter = [iter, optimValues.iteration]; % Append current iteration
%             fval = [fval, optimValues.fval]; % Append current function value
% 
%             % Plot dots and line
%             plot(iter, fval, 'o-', 'MarkerSize', 4, 'MarkerEdgeColor', 'b', 'Color', 'r'); 
%             xlabel('Iteration');
%             ylabel('Objective Function Value');
%             title('Objective Function Value vs. Iteration');
%             drawnow; % Update the plot
%         case "done"
%             hold off; % Release the plot hold when done
%     end
% end
    stop = false;

    % Persistent variables
    persistent thePlot

    switch state
        case "iter"
            if optimValues.iteration == 0
                thePlot = matlab.internal.optimfun.plotfcns.Factory.optimplotfval(optimValues);
            else
                thePlot.update(optimValues);
            end
    end
end
