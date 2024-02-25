function result = shrink( idx_for_best, dimension, simplex_vertices, best_point, delta )
    %% shrinking 
    result = simplex_vertices;
    
    for i=idx_for_best+1:dimension+1        
        result(i,:) = best_point + delta * ( simplex_vertices(i,:) - best_point );
    end
end