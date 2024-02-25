function simplex_vertices = compute_three_initial_points( dimension, start_point, c )
    % I think this is where we should determine the constraint.
    compute_b = @(c, n) c /( n * sqrt(2) ) * ( sqrt(n+1) - 1 );
    compute_a = @(b, c) b + c / sqrt(2);

    b = compute_b( c, dimension + 1 );
    a = compute_a( b, c );

    simplex_vertices = [ start_point; start_point + [ a b ]; start_point + [ b a ] ];
end