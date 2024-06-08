clear
clc
close all

%% Add path
% Add the 'Thruster_Dynamic' path
addpath(fullfile('E:\Master Degree\Linux_file\Thesis\rosbags_new3\Thruster_Dynamic'));
% addpath(fullfile('/home/goks/thesis_ws/rosbags_new2/Thruster_Dynamic'));

% Add the 'Ballast_Config_Input' path
addpath(fullfile('E:\Master Degree\Linux_file\Thesis\rosbags_new3\Ballast_Config_Input'));
% addpath(fullfile('/home/goks/thesis_ws/rosbags_new2/Ballast_Config_Input'));

% Add the 'Util' path
addpath(fullfile('E:\Master Degree\Linux_file\Thesis\rosbags_new3\Util'));
% addpath(fullfile('/home/goks/thesis_ws/rosbags_new2/Util'));

%% Load Data Experiment
data_override = load('pid_override.mat');
data_pitch = load('pid_pitch.mat');
data_rel_alt = load('pid_rel_alt.mat');
data_roll = load('pid_roll.mat');

%% Load Data No Ballast
data_pitch_nb = load('nb_pitch.mat');
data_rel_alt_nb = load('nb_rel_alt.mat');
data_roll_nb = load('nb_roll.mat');

%% Load Data Free Float
data_pitch_ff = load('ff_pitch.mat');
data_rel_alt_ff = load('ff_rel_alt.mat');
data_roll_ff = load('ff_roll.mat');

%% Time length
[rel_alt_ts, ~] = size(data_rel_alt.rel_alt);
[roll_ts, ~] = size(data_roll.roll);
[pitch_ts, ~] = size(data_pitch.pitch);

[ff_rel_alt_ts, ~] = size(data_rel_alt_ff.rel_alt);
[ff_roll_ts, ~] = size(data_roll_ff.roll);
[ff_pitch_ts, ~] = size(data_pitch_ff.pitch);

[nb_rel_alt_ts, ~] = size(data_rel_alt_nb.rel_alt);
[nb_roll_ts, ~] = size(data_roll_nb.roll);
[nb_pitch_ts, ~] = size(data_pitch_nb.pitch);
%% Get average thruster data
% Get PWM data
PWM_data = double(data_override.override); % Convert to double first

% Converter parameters
voltage_desired = 16;
mode = 1; % 0 = Thrust to PWM ; 1 = PWM to Thrust 

% Get the size of Total_Thruster_Force
[Row_Length, Column_Length] = size(PWM_data);

% Get the starting time index for the static condition
dt = 0.1;
settling_time  = 50;
stop_time = 150;
t_s_end = 150;
t_s_index = floor((settling_time/stop_time)*Row_Length);
t_s_index_end = floor((t_s_end/stop_time)*Row_Length);

% NEW DATA (CLIPPED IN THE END)
PWM_data = PWM_data(1:t_s_index_end,:);
[Row_Length, Column_Length] = size(PWM_data);
stop_time = t_s_end;

% Get the mean of each thruster dof 
Mean_Total_Thruster = zeros(1, Column_Length);
Mean_PWM = zeros(1, Column_Length);
for column = 1 : Column_Length
    Mean_PWM(1, column) = mean(PWM_data(t_s_index:end , column));
    Mean_Total_Thruster(1, column) = -Convert_Thrust_PWM(mean(PWM_data(t_s_index:end , column)), voltage_desired, mode);
end

Mean_Total_Thruster = (Mean_Total_Thruster * diag([1 1 1 -1 1 1])); % Reversing the heave force and pitch moment sign

% %% Run Ballast Distribution Algorithm
% disp('Run Ballast Distribution Algorithm');
% % Get the g0
% g0 = Mean_Total_Thruster';
% 
% % Ballast distribution parameters
% max_f = 24;                         % Maximum allowed used floaters
% max_w = 12;                         % Maximum allowed used weights
% pop_size = 500;                    % Population size
% num_generations = 200;              % Number of generation
% crossover_rate = 0.75;               % Rate of crossover occurance
% mutation_rate = 0.010;               % Rate of mutation occurance
% stall_generations_limit = 30;       % Number of generations without improvement to tolerate
% fitness_tolerance = 0.05;           % Fitness Tolerance
% divergence_generations_limit = 60;  % Number of generations when fitness value diverge to tolerate
% 
% ballastFunargs = {max_f, max_w, pop_size, num_generations, crossover_rate, mutation_rate, stall_generations_limit, fitness_tolerance, divergence_generations_limit};
% 
% % Ballast_Distribution
% [best_fitness_history, last_nz_index, opt_prompt] = Ballast_Distribution_Func(g0, ballastFunargs);
% 
% % Compute the amount of used floaters and weights
% [f_amount, w_amount] = Compute_Ballast_Amount(opt_prompt);
% disp([num2str(f_amount), ' floater block/s and ', num2str(w_amount), ' weight block/s are used for the ballast distribution.'])
% disp(' ')
% 
% % Plot fitness history
% figure('Name', 'Fitness Value Evolution', 'Position', [100, 200, 800, 600])
% plot(best_fitness_history, 'LineWidth', 1.5)
% xlabel('Generation')
% ylabel('Fitness')
% % title('Fitness History')
% set(gca, 'Color', [0.9 0.9 0.9]);
% set(gcf, 'Color', 'w'); % white background for the figure
% set(findall(gcf, 'Type', 'axes'), 'FontName', 'Helvetica', 'FontWeight', 'bold', 'FontSize', 10); % set font
% xlim([1 last_nz_index])
% grid on

%% Plot Thrust
% Legend
legend_ref = {'z ref', 'phi ref', 'theta ref'};
legend_body = {'z', 'phi', 'theta'};
legend_f_body = {'Force-x', 'Force-y', 'Force-z', 'Force-phi', 'Force-theta', 'Force-psi'};
legend_period = {'SP'};

% Override
figure('Name', 'Thrust Stabilization Mode', 'Position', [900, 100, 800, 600])
plot(data_override.override, 'LineWidth', 1.5)
xlim([0, Row_Length])
xticks(0:(Row_Length-1)/stop_time*10:Row_Length-1)
xticklabels(0:10:stop_time);
ylim([1300,1650])
xlabel('Time (Seconds)')
ylabel('PWM')

% % Fill the area with red color, semi-transparent
% hold on; % Ensure the fill is on top of the plot
% yLimits = ylim;
% x_fill = [0, linspace(0, settling_time, 100), settling_time/stop_time*Row_Length, settling_time/stop_time*Row_Length, 0]; % X coordinates for the filled area, closed loop
% y_fill = [yLimits(1), repmat(yLimits(1), 1, 100), yLimits(1), yLimits(2), yLimits(2)]; % Y coordinates
% fill(x_fill, y_fill, 'red', 'EdgeColor', 'none', 'FaceAlpha', 0.1); 
% 
% % Adding text annotations
% text(settling_time/(2*stop_time)*Row_Length, 1600, 'Transient Phase', 'FontSize', 10, 'Color', 'black', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
% text((stop_time+settling_time)/(2*stop_time)*Row_Length, 1600, 'Steady-State Phase', 'FontSize', 10, 'Color', 'black', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

% Setting the background color and other properties
set(gca, 'Color', [0.9 0.9 0.9]);
set(gcf, 'Color', 'w'); % white background for the figure
set(findall(gcf, 'Type', 'axes'), 'FontName', 'Helvetica', 'FontWeight', 'bold', 'FontSize', 10); % set font

grid on

legend([legend_f_body, legend_period], 'Location', 'northeast')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PID PROCESS
figure('Name', 'Position and Orientation during PID', 'Position', [100, 100, 700, 900]);

% Define colors for the plots
color1 = [0, 0.4470, 0.7410]; % blue
color2 = [0.8500, 0.3250, 0.0980]; % red

% Plot Z
subplot(3,1,1);
z_ref = ones(1, rel_alt_ts)*-0.5;
plot(data_rel_alt.rel_alt, 'LineWidth', 1.5, 'Color', color1);
hold on;
plot(z_ref, 'LineWidth', 1.5, 'Color', color2);
hold on;
title('Heave displacement', 'FontSize', 12);
ylabel('meter', 'FontSize', 10);
set(gca, 'Color', [0.9 0.9 0.9]);
grid on
xlim([0, rel_alt_ts])
ylim([-1.25, 0.1])
xticks(0:rel_alt_ts/stop_time*20:rel_alt_ts)
xticklabels(0:20:stop_time);

% % Adding text annotations
% text(settling_time/stop_time*rel_alt_ts/2, 0.25, 'Transient Phase', 'FontSize', 10, 'Color', 'black', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
% text((stop_time/2 + settling_time/2)/stop_time*rel_alt_ts, 0.25, 'Steady-State Phase', 'FontSize', 10, 'Color', 'black', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
% 
% % Fill the area with red color, semi-transparent
% hold on; % Ensure the fill is on top of the plot
% yLimits = ylim;
% x_fill = [0, linspace(0, settling_time, 100), settling_time/stop_time*rel_alt_ts, settling_time/stop_time*rel_alt_ts, 0]; % X coordinates for the filled area, closed loop
% y_fill = [yLimits(1), repmat(yLimits(1), 1, 100), yLimits(1), yLimits(2), yLimits(2)]; % Y coordinates
% fill(x_fill, y_fill, 'red', 'EdgeColor', 'none', 'FaceAlpha', 0.1); 

% Plot Phi
subplot(3,1,2);
phi_ref = zeros(1, roll_ts);
plot(data_roll.roll/180*pitch_ts, 'LineWidth', 1.5, 'Color', color1);
hold on;
plot(phi_ref, 'LineWidth', 1.5, 'Color', color2);
hold on;
title('Roll angle displacement', 'FontSize', 12);
ylabel('degree', 'FontSize', 10);
set(gca, 'Color', [0.9 0.9 0.9]);
grid on
xlim([0, roll_ts])
ylim([-10, 10])
xticks(0:roll_ts/stop_time*20:roll_ts)
xticklabels(0:20:stop_time);

% % Adding text annotations
% text(settling_time/stop_time*roll_ts/2, -15, 'Transient Phase', 'FontSize', 10, 'Color', 'black', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
% text((stop_time/2 + settling_time/2)/stop_time*roll_ts, -15, 'Steady-State Phase', 'FontSize', 10, 'Color', 'black', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
% 
% % Fill the area with red color, semi-transparent
% hold on; % Ensure the fill is on top of the plot
% yLimits = ylim;
% x_fill = [0, linspace(0, settling_time, 100), settling_time/stop_time*roll_ts, settling_time/stop_time*roll_ts, 0]; % X coordinates for the filled area, closed loop
% y_fill = [yLimits(1), repmat(yLimits(1), 1, 100), yLimits(1), yLimits(2), yLimits(2)]; % Y coordinates
% fill(x_fill, y_fill, 'red', 'EdgeColor', 'none', 'FaceAlpha', 0.1); 

% Plot Theta
subplot(3,1,3);
theta_ref = zeros(1, pitch_ts);
plot(-data_pitch.pitch/pi*180, 'LineWidth', 1.5, 'Color', color1);
hold on;
plot(theta_ref, 'LineWidth', 1.5, 'Color', color2);
hold on;
title('Pitch angle displacement', 'FontSize', 12);
xlabel('Time (Seconds)')
ylabel('degree', 'FontSize', 10);
set(gca, 'Color', [0.9 0.9 0.9]);
grid on
xlim([0, pitch_ts])
ylim([-10 10])
xticks(0:pitch_ts/stop_time*20:pitch_ts)
xticklabels(0:20:stop_time);

% % Adding text annotations
% text(settling_time/stop_time*roll_ts/2, -15, 'Transient Phase', 'FontSize', 10, 'Color', 'black', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
% text((stop_time/2 + settling_time/2)/stop_time*roll_ts, -15, 'Steady-State Phase', 'FontSize', 10, 'Color', 'black', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
% 
% % Fill the area with red color, semi-transparent
% hold on; % Ensure the fill is on top of the plot
% yLimits = ylim;
% x_fill = [0, linspace(0, settling_time, 100), settling_time/stop_time*pitch_ts, settling_time/stop_time*pitch_ts, 0]; % X coordinates for the filled area, closed loop
% y_fill = [yLimits(1), repmat(yLimits(1), 1, 100), yLimits(1), yLimits(2), yLimits(2)]; % Y coordinates
% fill(x_fill, y_fill, 'red', 'EdgeColor', 'none', 'FaceAlpha', 0.1); 

% Improve overall plot appearance
set(gcf, 'Color', 'w'); % white background for the figure
set(findall(gcf, 'Type', 'axes'), 'FontName', 'Helvetica', 'FontWeight', 'bold', 'FontSize', 12); % set font

% Create a single legend for the entire figure
lgd = legend('Experiment', 'Reference', 'FontSize', 10, 'FontWeight', 'bold', 'FontName', 'Helvetica');
lgd.Position = [0.4, 0.005, 0.2, 0.04];

% Adjust line thickness and color contrast for better visibility
lineObjects = findall(gcf, 'Type', 'line');
set(lineObjects, 'LineWidth', 1.5);