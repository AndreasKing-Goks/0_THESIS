function [traces, opt_point, opt_value] = nelder_mead(objective_func, start_point, alpha, beta, gamma, delta, maxiter,Ea, Er, X_Tol, step_size)
global Param
%% Constants
c = step_size; % usually equal to 100
eval_value = zeros(maxiter+1,1);

%% Other contstants
iteration_counter = 0;

[ ~, dimension ] = size( start_point );
simplex_vertices = compute_three_initial_points( dimension, start_point, c );
next_vertices = arrayfun(@(row) objective_func(simplex_vertices(row, :)), 1:size(simplex_vertices, 1));
eval_value(1,1) = min(next_vertices);
traces = [ simplex_vertices, next_vertices' ];
done = 0;
conv_status = 0;

while iteration_counter <= maxiter && ~done
    
    % Compute the last triange points
    point_current_1 = traces(end-2,1:2);
    point_current_2 = traces(end-1,1:2);
    point_current_3 = traces(end,1:2);
    point_current = [point_current_1; point_current_2; point_current_3];
    
    simplex_vertices = sort_by_function_values( objective_func, simplex_vertices );
    
    idx_for_best = 1;
    idx_for_bad = dimension;
    idx_for_worst = dimension + 1;
    
    best_point = simplex_vertices(idx_for_best,:);
    bad_point = simplex_vertices(idx_for_bad,:);
    worst_point = simplex_vertices(idx_for_worst,:);

    % Check for convergence criteria 1
    % Compute the status (Boolean) value difference criteria
    best_val = obj_func(best_point);
    worst_val = obj_func(worst_point);
    cond_1 = abs(best_val - worst_val) <= (Ea + Er*abs(best_val));

    if (iteration_counter>1) && cond_1 == 1 
        conv_status = 1;
        done = 1; % STOP
    end
    
    centroid = compute_centroid(dimension, simplex_vertices(1:dimension,:));
    
    % Transformation
    %% Reflection
    reflection_point = centroid + alpha * ( centroid - worst_point );

    worst_value = objective_func( worst_point );
    bad_value = objective_func( bad_point );
    reflection_value = objective_func( reflection_point );
    best_value = objective_func( best_point );
    
    point_to_replace = [];
    
    if best_value <= reflection_value && reflection_value < bad_value
        point_to_replace = reflection_point;
        
    %% Expansion
    elseif reflection_value < best_value
        expansion_point = centroid + beta * ( reflection_point - centroid );
        expantion_value = objective_func( expansion_point );
        
        if expantion_value < reflection_value
            point_to_replace = expansion_point;
        else
            point_to_replace = reflection_point;
        end        
        
    %% Outside contraction
    elseif bad_value <= reflection_value && reflection_value < worst_value
        ocontraction_point = centroid + gamma * ( reflection_point - centroid );
        ocontraction_value = objective_func( ocontraction_point );

        if ocontraction_value <= reflection_value
            point_to_replace = ocontraction_point;
        else
            %% Shrinking 
            simplex_vertices = shrink( idx_for_best, dimension, simplex_vertices, best_point, delta );            
        end
    %% Inside contraction
    elseif reflection_value >= worst_value
        icontraction_point = centroid - gamma * ( reflection_point - centroid );
        icontraction_value = objective_func( icontraction_point );

        if icontraction_value < worst_value
           point_to_replace = icontraction_point;
        else
            %% Shrinking 
            simplex_vertices = shrink( idx_for_best, dimension, simplex_vertices, best_point, delta );
        end
    end
    
    if point_to_replace
        simplex_vertices(idx_for_worst,:) = point_to_replace;
    end
    
    next_vertices = arrayfun(@(row) objective_func(simplex_vertices(row, :)), 1:size(simplex_vertices, 1));
    eval_value(maxiter+1,1) = min(next_vertices);
    
    % Store the history
    traces = [ traces; [ simplex_vertices, next_vertices' ] ];
    
    % Compute the last triange points
    point_last_1 = simplex_vertices(1,1:2);
    point_last_2 = simplex_vertices(1,1:2);
    point_last_3 = simplex_vertices(1,1:2);
    point_last = [point_last_1; point_last_2; point_last_3];

    % Store the current optimum value
    current_opt_val = min(next_vertices);

    % Check for convergence criteria 2
    % If it is not the first iteration and convergence criteria is True
    cond_2 = max(abs(point_last - point_current)) < X_Tol;
      
    % If the maximum X difference lower than the criteria, stop.
    if (iteration_counter>1) && all(cond_2 == 1)
        conv_status = 2;
        done = 1; % STOP
    end

    fprintf('Iteration: %d, Point 1: [%.5f, %.5f], Point 2: [%.5f, %.5f], Point 3: [%.5f, %.5f], Current Value: %.5f\n', ...
    iteration_counter, point_last_1, point_last_2, point_last_3, current_opt_val);
    
    iteration_counter = iteration_counter + 1;       
end

% arr = arrayfun(@(row) objective_func(simplex_vertices(row, :)), 1:size(simplex_vertices, 1))

% PRINT STOPPING STATUS
if conv_status == 1
    disp('The value change is smaller than the tolerance criteria: MINIMUM Achieved')
    fprintf('Stopped at iteration: %d\n',iteration_counter)
    fprintf('For a sphere model with radius %f meters\n',Param.R)
    fprintf('best floater height ratio is: %f meters\n',best_point(1)*Param.R)
    fprintf('best weight height ratio is: %f meters\n',best_point(2)*Param.R)
elseif conv_status == 2
    disp('The size of simplex is smaller than the tolerance criteria: MINIMUM Achieved')
    fprintf('Stopped at iteration: %d\n',iteration_counter)
    fprintf('For a sphere model with radius %f meters\n',Param.R)
    fprintf('best floater height ratio is: %f meters\n',best_point(1)*Param.R)
    fprintf('best weight height ratio is: %f meters\n',best_point(2)*Param.R)
else
    disp('Maximum iteration reached')
    fprintf('Stopped at iteration: %d\n',iteration_counter)
    fprintf('For a sphere model with radius %f meters\n',Param.R)
    fprintf('The last optimized floater height ratio is: %f meters\n',best_point(1)*Param.R)
    fprintf('The last optimized weight height ratio is: %f\n',best_point(2)*Param.R)
end

arr = evaluate_points(objective_func, simplex_vertices);
opt_value = min(arr);
opt_point = simplex_vertices (arr == opt_value,:);
end