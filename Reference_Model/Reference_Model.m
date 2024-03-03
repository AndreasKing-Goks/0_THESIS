function [resampled_model, resampled_time] = Reference_Model(set_points,step_value)
%% Add Path to MSS Toolbox
% Current dir
currentDir = fileparts('/home/goks/Documents/MIR/Thesis/MIR_THESIS/');

% Add the 'MSS' path
utilPath = fullfile(currentDir, 'MSS');
addpath(utilPath);

%% Data Extracting
% Set the empty container.
model_val = zeros(1, numel(set_points));
time_val = zeros(1, numel(set_points));

% Extract set points data
for i = 1:numel(set_points) 
    model_val(i) = set_points{i}(1);
    time_val(i) = set_points{i}(2);
end

%% Interpolation Process
stop_time = max(time_val);

% Set x axis
t = 0:1:stop_time;

% Cubic Hermite Interpolation
x_p = pchip(time_val, model_val,t);

% Create time series (interval 1s)
time_series = timeseries(x_p);

%% Resampling
% Resample time series
time_series_resampled = resample(time_series, 0:step_value:max(time_val));

% Extract the resampled data
resampled_model = squeeze(time_series_resampled.Data);
resampled_time = time_series_resampled.Time;
end