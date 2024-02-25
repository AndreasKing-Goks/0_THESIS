function points = sort_by_function_values( obj_func, points )        
    eval_pts = evaluate_points( obj_func, points );   
    [ ~, index ] = sort( eval_pts );
    points = points(index,:);
end