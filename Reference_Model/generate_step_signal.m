function y = generate_step_signal(set_points, t)
    % Initialize output signal
    y = zeros(size(t));

    % Iterate through set points
    for i = 1:length(set_points)
        point = set_points{i};
        value = point(1);
        time = point(2);

        % Generate step signal
        y(t >= time) = value;
    end
end

