function result = evaluate_points( obj_func, points )
    [~, dim] = size(points);
    result = zeros(1, dim+1);
    for i=1:dim+1
        result(i) = feval( obj_func, points(i,:) );
    end
end