function ref = generate_step_signal(val_checkpoints, time_stamps, t)
    % Initialize output signal
    ref = zeros(size(t));

    % Iterate through set points
    for i = 1:length(val_checkpoints)
        value = val_checkpoints(i);
        time = time_stamps(i);

        % Generate step signal
        ref(t >= time) = value;
    end
end