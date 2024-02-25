clear
clc
% Define your set of waypoints (x, y)
x = [0, 1, 2, 3, 4]; % Time points
y = [0, 2, 1, 3, 2]; % Output values

% Define derivatives (slopes) at waypoints
dy_dx = [1, -1, 0.5, 0, -0.5]; % Slopes at waypoints

% Define a finer grid for interpolation
x_interp = 0:0.1:4;

% Perform cubic Hermite interpolation
y_interp = spline(x, [dy_dx(1), y, dy_dx(end)], x_interp);

% Ensure that the interpolated curve does not go above the designated setpoints
y_interp = min(y_interp, max(y));

% Discretization step value
step_value = 0.01;

% Discretize the curve
time_series_data = timeseries(y_interp, x_interp);

% Resample the time series data with the desired step value
time_series_data_resampled = resample(time_series_data, 0:step_value:4);

% Extract the resampled data
resampled_values = squeeze(time_series_data_resampled.Data);
resampled_time = time_series_data_resampled.Time;

% Plot the resampled data
plot(resampled_time, resampled_values);
xlabel('Time');
ylabel('Output');
title('Discretized Curve');
