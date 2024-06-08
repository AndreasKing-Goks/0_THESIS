function [Result] = Convert_Thrust_PWM(val_desired, voltage, mode)
%% Add Path
% Voltage levels
voltage_levels = [10 12 14 16 18 20];

% Zero Zone
V10_bound  = [1460, 1540];
V12_bound  = [1464, 1536];
V14_bound  = [1468, 1532];
V16_bound  = [1472, 1528];
V18_bound  = [1472, 1528];
V20_bound  = [1476, 1528];
bound = [V10_bound; V12_bound; V14_bound; V16_bound; V18_bound; V20_bound];

% Desired voltage
tag = find(voltage_levels == voltage);
des_bound = bound(tag,:);
up_bound = des_bound(2);
down_bound = des_bound(1);


% Gravitational acceleration
g = 9.81;

% Current dir
currentDir = fileparts(mfilename('fullpath'));

% Add the 'T200_Data' path
T200_Data_Path = fullfile(currentDir, 'T200_Data');
addpath(T200_Data_Path);

%% Load Data
load(fullfile(T200_Data_Path, 'thruster_data.mat'));
fieldname = sprintf('voltage_%d', voltage);

force = thruster_data.(fieldname).data(:,6);
pwm = thruster_data.(fieldname).data(:,1);

% Remove zero-thrust regions from data
[unique_force, idx] = unique(force, 'stable');
unique_pwm = pwm(idx);

%% Interpolate Data
% Switch Mode
% Force to PWM
if mode == 0
    PWM_est = interp1(unique_force, unique_pwm, val_desired/9.81, 'linear');
    Result = PWM_est;
% PWM to Force
elseif mode == 1
    if val_desired >= des_bound(2) || val_desired <= des_bound(1)
        Force_est = interp1(unique_pwm, unique_force, val_desired, 'linear');
        Result = Force_est * g;
    else
        Result = 0;
    end
end
end