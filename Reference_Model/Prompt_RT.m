clear
clc
%% This prompt is used to generate the resampled thrust timeseries given setpoints
% Set points format: {[thrust_val_1, time_1], [thrust_val_2, time_2], ... }
% Step value used to set the sampling size

set_points = {[0, 0], [100, 20], [100, 40], [500, 60], [550, 80], [1000, 90], [1000, 110], [300, 120], [300, 125], [100, 130], [500, 140], [300, 145], [300, 150], [0, 160]};
step_value = 0.01;

[resampled_thrust, resampled_time] = Reference_Model(set_points,step_value);

% Plot the resampled data
plot(resampled_time, resampled_thrust, '-');
hold on;

% Plot set points
for i = 1:numel(set_points)
    point = set_points{i};
    thrust_val = point(1);
    time_val = point(2);
    plot(time_val, thrust_val, 'ro', 'MarkerSize', 8, 'LineWidth', 2);
end

hold off;

xlabel('Time');
ylabel('Thrust');
title('Discretized Thrust with Set Points');
legend('Resampled Thrust', 'Set Points');