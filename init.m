%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% init                                                                    %
%                                                                         %
% Initialize workspace                                                    %
%                                                                         %
% Created:      13.02.2024	Andreas Sitorus                               %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
close all
%% Add Path
% Current dir
currentDir = fileparts(mfilename('fullpath'));

% Add the 'Util' path
addpath(fullfile(currentDir, 'Util'));

% Add the 'Ballast_Config_Input' path
addpath(fullfile(currentDir, 'Ballast_Config_Input'));

% Add the 'Thruster_Dynamic' path
addpath(fullfile(currentDir, 'Thruster_Dynamic'));

% Add the 'Forces_setpoint' path
addpath(fullfile(currentDir, 'Reference_Model'));

% Add 'Case_Model' path
addpath(fullfile(currentDir, 'Case_Model'));

% Add 'Save_and_Plot' path
addpath(fullfile(currentDir, 'Save_and_Plot'));

%% Open Simulink Model
% Correct modelName to exclude the file extension for bdIsLoaded
modelName = 'BlueROV2_Exp_Simu';

% Use the full file name including extension with open_system
modelFileName = 'BlueROV2_Exp_Simu.slx';

% Checking if the model is already loaded to avoid loading it again
if ~bdIsLoaded(modelName)
    open_system(modelFileName);
    disp([modelName ' has been opened.']);
else
    disp([modelName ' is already open.']);
end

%% Initialize Workspace
% BlueROV2 Parameters
Param = BlueROV2_param();

% Ballast Configuration Parameters
Param_B = Ballast_Param();

%% Initial Condition
% States
Pos_N = Param.IC.Pos;
Velo_B = Param.IC.Velo;

%% Thruster System
% Thruster allocation
T_alloc = Thrust_Allocation();
lambda = 1e-3;
T_alloc_ps = pinv(T_alloc' * T_alloc + lambda * eye(size(T_alloc, 2))) * T_alloc';

% Thruster constraints
upper_limit = 30;
lower_limit = -upper_limit;
thrust_rate = 5;

%% Timestep
dt = 0.1;  %-----To set

%% Reference Model Parameters
% Implement the pre-determined reference model for the controller
% Method 1: Cubic Hermite Interpolation
% Method 2: Automatic Guidance Function
% There are 4 cases: Heave case(1), Roll case(2), Pitch case(3)
% Exclusive to Method 2 are Static case (4)

% Methods selector
Method = 2;

% Cases selector
Case = 4;

% Define time check points
% Note:
% idle_time sets the time for the ROV to go to start position and stay idle for a while
% ROV needs to be idle for some idle_time before the whole simulation ends
idle_time = 10;     
stop_time = 60;

% Get parameters
if Method == 1
    [X_ref, Y_ref, Z_ref, Phi_ref, Theta_ref, Psi_ref, resampled_time] = RM_param_CHI(Case, idle_time, stop_time, dt);
elseif Method == 2
    [Af, Omega, Gamma, X_ref, Y_ref, Z_ref, Phi_ref, Theta_ref, Psi_ref, time_stamps_x, time_stamps_y, time_stamps_z, time_stamps_phi, time_stamps_theta, time_stamps_psi] = RM_param_AGF(Case, idle_time, stop_time);
else
    error('Method selection is not available. Stopping script.');
end

% Set the stop time of your Simulink model
set_param(modelName, 'StopTime', num2str(stop_time));

%% Controller Model Parameters (PID)
% Initial set
% Kp = [1; 1; 1; 1; 1; 1];
% Ki = [1; 1; 1; 1; 1; 1];
% Kd = [1; 1; 1; 1; 1; 1];

% % Best heave only/ thrust allocation not active
% Kp = [1; 1; 750; 1; 1; 1];
% Ki = [1; 1; 155; 1; 1; 1];
% Kd = [1; 1; 70; 1; 1; 1];

% % Best roll only/ thrust allocation not active
% Kp = [1; 100; 100; 100; 1; 1];
% Ki = [1; 10; 10; 10; 1; 1];
% Kd = [1; 20; 20; 10; 1; 1];

% % Best heave only/ thrust allocation not active
% Kp = [100; 100; 100; 100; 100; 1];
% Ki = [10; 10; 10; 10; 10; 1];
% Kd = [20; 20; 20; 10; 10; 1];

% Best Heave case
% Kp = [255; 545; 7095; 2420; 2375; 1];
% Ki = [45; 45; 10; 96; 96; 1];
% Kd = [155; 355; 8985; 1205; 1205; 1];

% % Best Roll case
% Kp = [1; 100; 100; 100; 200; 1];
% Ki = [1; 20; 20; 80; 10; 1];
% Kd = [1; 70; 70; 120; 100; 1];

% % Best Pitch case
% Kp = [120; 120; 120; 200; 100; 1];
% Ki = [30; 30; 30; 10; 80; 1];
% Kd = [90; 90; 80; 100; 120; 1];

% % Best Static case
% For m_add =< 0.5
% Kp = [255; 545; 7095; 2420; 2375; 1];
% Ki = [45; 45; 10; 96; 96; 1];
% Kd = [155; 355; 8985; 1205; 1205; 1];
% For m_add > 0.5
Kp = [255; 245; 4095; 1420; 1375; 1];
Ki = [45; 45; 96; 96; 96; 1];
Kd = [155; 355; 8985; 1205; 1205; 1];

% Kp = [10; 10; 350; 10; 10; 10];
% Ki = [45; 45; 10; 96; 96; 1];
% Kd = [155; 355; 8985; 1205; 1205; 1];

%% Extended Kalman Filter Parameters
% [inv_M, B, H, R, Q, dt, inv_Tb, Gamma_o] = EKF_param(dt);

%% Ballast Force
% Floater Code [dtype=string] - 3 bits system:
% -'NNN' - None None None           - [0 0 0]
% -'NNF' - None None Floater        - [0 0 1]
% -'NFN' - None Floater None        - [0 1 0]
% -'FNN' - Floater None None        - [1 0 0]
% -'NFF' - None Floater Floater     - [0 1 1]
% -'FFN' - Floater Floater None     - [1 1 0]
% -'FNF' - Floater None Floater     - [1 0 1]
% -'FFF' - Floater Floater Floater  - [1 1 1]
% Weight Code [dtype=string] - 1 bit system:
% -'WN' - No Weight = 0
% -'WA' - Weight Available = 1

% Ballast_Configuration parameters
% Location Description
% F : Front
% A : Aft (Back)
% R : Right
% L : Left
% M : Middle
% I : Inner
% O : Outer

% Floaters Prompt
% Location : FR    FL    AR    AL    IMR   IML   OMR   OML
f_prompt = {'NNN' 'NNN' 'NNN' 'NNN' 'NNN' 'NNN' 'NNN' 'NNN'};
% Weights Prompt
% Location : OFR  IFR  OFL  IFL  OMF  IMF  IMA  OMA  OAR  IAR  OAL  IAL
w_prompt = {'WN' 'WN' 'WN' 'WN' 'WN' 'WN' 'WN' 'WN' 'WN' 'WN' 'WN' 'WN'};
prompt = [f_prompt w_prompt];

% Other function arguments
max_f = 24;
max_w = 8;
funargs = {max_f max_w};

% Get the ballast configuration
Ballast_Config = Ballast_Configuration(prompt, funargs);

% Compute the ballast force
Ballast_Force = Ballast_Compute(Ballast_Config);

%% Thruster Force
Thruster_Force = zeros(6,1);

%% Additional Force
m_add = 0.2500;          % kg
x_add = 0.1000;         % m
y_add = 0.1000;        % m
z_add = -0.1460;        % m

w_add = m_add * Param.Env.g;

% TO AVOID MODIFYING THE DYNAMIC MODEL TOO MUCH, TETHER == ADDED
% FINALIZE WHEN TROUBLESHOOTING IS DONE
Tether_Force = [0; 0; w_add; w_add*y_add; w_add*x_add; 0];

%% Sphere Dynamic Model [FOR CHECKING]
% Acc_G = BlueROV2_acc(Ballast_Force, Thruster_Force, Tether_Force, Pos_N, Velo_B);

%% HELP READING Acceleration result
% Forces defined in NED at first, then transformed to the body coordinate
% Thus, positive sign means downwards
% Positive acceleration means Negatively Buoyant
% Negative acceleration means Positively Buoyant
% Angle, positive mean clockwise

%% RUN SIMULINK MODEL to get the body force data for static case
% Measured from simulator
% Run the Simulink Model
disp(['Run the ' modelName '.']);
simOut = sim(modelName, 'ReturnWorkspaceOutputs', 'on');
disp('Finished compute the simulation outputs.');

% Get the tau_b - USED FOR VELOCITY INTEGRATION
Total_Thruster_Force = simOut.tau_b;

if Case == 4
    % Get the size of Total_Thruster_Force
    [~, Column_Length] = size(Total_Thruster_Force);

    % Get the starting time index for the static condition
    t_s = 20;
    t_s_index = (t_s/dt) + 1;

    % Get the mean of each thruster dof 
    Mean_Total_Thruster = zeros(1, Column_Length);
    for column = 1 : Column_Length
        Mean_Total_Thruster(1, column) = mean(Total_Thruster_Force(t_s_index:end , column));
    end
end

% Close the  Simulink Model
%close_system(modelFileName);
disp(['Close ' modelName '.']);

%% For heave case plot 
legend_ref = {'x ref', 'y ref', 'z ref', 'phi ref', 'theta ref', 'psi ref'};
legend_body = {'x', 'y', 'z', 'phi', 'theta', 'psi'};
legend_f_body = {'Force-x', 'Force-y', 'Force-z', 'Force-phi', 'Force-theta', 'Force-psi'};
legend_period = {'SP'};
settling_time  = 20/dt;

figure('Name', 'Trajectory Tracking', 'Position', [100, 100, 800, 600])

% Plot eta_ref - eta
plot(simOut.eta_ref_n)
hold on
plot(squeeze(simOut.Pos_N_S)')
hold on

% Adjust time ticks
% xticks(0:1/dt:stop_time*10); 
xticklabels(0:1/dt:stop_time); 

% x-y limit
xlim([0, stop_time/dt])
ylim([-1.25, 0.25])
xlabel('Time (seconds)')
ylabel('Position (meter/radian)')

% Get the current limits of the y-axis
yLimits = ylim;

% Shade the area where x <settling time
x_fill = [0, linspace(0, settling_time, 100), settling_time, settling_time, 0]; % X coordinates for the filled area, closed loop
y_fill = [yLimits(1), repmat(yLimits(1), 1, 100), yLimits(1), yLimits(2), yLimits(2)]; % Y coordinates
fill(x_fill, y_fill, 'red', 'EdgeColor', 'none', 'FaceAlpha', 0.1); % Fill the area with red color, semi-transparent

% Add legend
% legend([legend_ref, legend_period], 'Location', 'southeast')
legend([legend_ref, legend_body, legend_period], 'Location', 'southeast')

% Adding text label to the shaded area
text(settling_time/2, 2*mean(yLimits), 'Stabilizing Phase', 'FontSize', 12, 'Color', 'black', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
text((stop_time/dt + settling_time)/2, 2*mean(yLimits), 'Maintain Phase', 'FontSize', 12, 'Color', 'black', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

hold off; % Release the plot for other operations

grid on
title('Reference Trajectory for Ballast Estimation - Heave Case')

figure('Name', 'Thrust Stabilization Mode', 'Position', [900, 100, 800, 600])
% Plot thrust
plot(squeeze(simOut.tau_b))
hold on

% Adjust time ticks
% xticks(0:1/dt:stop_time*10); 
xticklabels(0:1/dt:stop_time); 

% x-y limit
xlim([0, stop_time/dt])
ylim([-20, 5])
xlabel('Time (seconds)')
ylabel('Thruste Force (N)')

% Get the current limits of the y-axis
yLimits = ylim;

% Shade the area where x <settling time
x_fill = [0, linspace(0, settling_time, 100), settling_time, settling_time, 0]; % X coordinates for the filled area, closed loop
y_fill = [yLimits(1), repmat(yLimits(1), 1, 100), yLimits(1), yLimits(2), yLimits(2)]; % Y coordinates
fill(x_fill, y_fill, 'red', 'EdgeColor', 'none', 'FaceAlpha', 0.1); % Fill the area with red color, semi-transparent

% Add legend
% legend([legend_ref, legend_period], 'Location', 'southeast')
legend([legend_f_body, legend_period], 'Location', 'southeast')

% Adding text label to the shaded area
text(settling_time/2, -15, 'Stabilizing Phase', 'FontSize', 12, 'Color', 'black', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
text((stop_time/dt + settling_time)/2, -15, 'Maintain Phase', 'FontSize', 12, 'Color', 'black', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

hold off; % Release the plot for other operations

grid on
title('Thrust Output for Ballast Estimation - Heave Case')

%% Check if the PID control is correct
% Initialize a variable to control the loop
isValidInput = false;

% Loop until a valid input is received
while ~isValidInput
    % Prompt the user for a yes/no response
    response = input('Is the PID control good enough? (y/n): ', 's');

    % Check if the response is 'n'
    if strcmpi(response, 'n')
        % Display a message and stop the script
        disp('Please modify the PID gain. Stopping the operation');
        return;  % Use 'return' to exit the script
    elseif strcmpi(response, 'y')
        % Continue with the rest of the script
        disp('Continuing operation...');
        isValidInput = true; % Set flag to true to break the loop
    else
        % Handle invalid input
        disp('Invalid input. Please enter y or n.');
    end
end

%% Run Ballast Distribution Algorithm
disp('Run Ballast Distribution Algorithm');
% Get the g0
g0 = Mean_Total_Thruster';

% Ballast distribution parameters
max_f = 24;                         % Maximum allowed used floaters
max_w = 12;                         % Maximum allowed used weights
pop_size = 2500;                    % Population size
num_generations = 150;              % Number of generation
crossover_rate = 0.75;               % Rate of crossover occurance
mutation_rate = 0.075;               % Rate of mutation occurance
stall_generations_limit = 15;       % Number of generations without improvement to tolerate
fitness_tolerance = 0.05;           % Fitness Tolerance
divergence_generations_limit = 30;  % Number of generations when fitness value diverge to tolerate

ballastFunargs = {max_f, max_w, pop_size, num_generations, crossover_rate, mutation_rate, stall_generations_limit, fitness_tolerance, divergence_generations_limit};

% Ballast_Distribution
[best_fitness_history, last_nz_index, opt_prompt] = Ballast_Distribution_Func(g0, ballastFunargs);

% Compute the amount of used floaters and weights
[f_amount, w_amount] = Compute_Ballast_Amount(opt_prompt);
disp([num2str(f_amount), ' floater block/s and ', num2str(w_amount), ' weight block/s are used for the ballast distribution.'])
disp(' ')

% Plot fitness history
figure('Name', 'Fitness Value Evolution', 'Position', [100, 200, 800, 600])
plot(best_fitness_history)
xlabel('Generation')
ylabel('Fitness')
title('Fitness History')
xlim([1 last_nz_index])
grid on

%% Continue to Validation Phase
% Initialize a variable to control the loop
isValidInput = false;

% Loop until a valid input is received
while ~isValidInput
    % Prompt the user for a yes/no response
    response_val = input('Proceed to Validation Phase? (y/n): ', 's');

    % Check if the response is 'n'
    if strcmpi(response_val, 'n')
        % Display a message and stop the script
        disp('Stopping the operation.');
        return;  % Use 'return' to exit the script
    elseif strcmpi(response_val, 'y')
        % Continue with the rest of the script
        disp('Continuing operation...');
        isValidInput = true; % Set flag to true to break the loop
    else
        % Handle invalid input
        disp('Invalid input. Please enter y or n.');
    end
end

%% Validation
% (1) Turn off the PID Controller
% (2) Add the optimal ballast
% (3) Keep the additional load intact [DO NOT CHANGE THE TETHER (ADDITIONAL) FORCE]
% (3) Run the free floating BlueROV2 simulator, and see how it behaves using the new ballast configuration

% Turn off the thruster
tau_b_test = [0; 0; 0; 0; 0; 0];

% Other function arguments
opt_max_f = 24;
opt_max_w = 12;
opt_funargs = {opt_max_f opt_max_w};

% Get the ballast configuration
Opt_Ballast_Config = Ballast_Configuration(opt_prompt, opt_funargs);

% Run and close the BlueROV2_Simu free floating simulator
testModelName = 'BlueROV2_Simu';
testModelFileName = 'BlueROV2_Simu.slx';

% Open BlueROV2 free float simulator
% Checking if the model is already loaded to avoid loading it again
if ~bdIsLoaded(testModelName)
    open_system(testModelFileName);
    disp([testModelName ' has been opened.']);
else
    disp([testModelName ' is already open.']);
end

% No Ballast Configuration used
Opt_Ballast_Force = [0; 0; 0; 0; 0; 0];

% Run simulator without new ballast configuration
disp(['Run the ' testModelName '.']);
set_param(testModelName, 'StopTime', num2str(stop_time));
simNoTestOut = sim(testModelName, 'ReturnWorkspaceOutputs', 'on');
disp('Finished compute the free float simulation outputs with new ballast configuration.');

% Compute the ballast force
Opt_Ballast_Force = Ballast_Compute(Opt_Ballast_Config);

% Run simulator with new ballast configuration
disp(['Run the ' testModelName '.']);
set_param(testModelName, 'StopTime', num2str(stop_time));
simTestOut = sim(testModelName, 'ReturnWorkspaceOutputs', 'on');
disp('Finished compute the free float simulation outputs without new ballast configuration.');

% Close simulator
close_system(testModelFileName);
disp(['Close ' testModelName '.']);

% Get the free float simulation data
nf_eta_n = squeeze(simNoTestOut.Pos_N_S)';
nf_nu_b = squeeze(simNoTestOut.Velo_B_S)';
nf_nu_dot_b = squeeze(simNoTestOut.Acc_B_S)';

% Get the free float simulation data
ff_eta_n = squeeze(simTestOut.Pos_N_S)';
ff_nu_b = squeeze(simTestOut.Velo_B_S)';
ff_nu_dot_b = squeeze(simTestOut.Acc_B_S)';

%% Plot the free float simulation data without ballast configuration
% Plot Eta_n
figure('Name', 'Free Float Simulation: Position and  Orientation, No Ballast', 'Position', [100, 100, 1000, 600])
plot(nf_eta_n)

% Adjust time ticks
% xticks(0:1/dt:stop_time*10); 
xticklabels(0:1/dt:stop_time); 

% x-y limit
xlim([0, stop_time/dt])
% ylim([-1.25, 0.25])
xlabel('Time (seconds)')
ylabel('Position (meter/radian)')

% Add legend
% legend([legend_ref, legend_period], 'Location', 'southeast')
legend(legend_body, 'Location', 'southeast')

hold off; % Release the plot for other operations

grid on
title('Position in NED frame')

% Plot Nu_b
figure('Name', 'Free Float Simulation: Velocity, No Ballast', 'Position', [100, 100, 1000, 600])
plot(nf_nu_b)

% Adjust time ticks
% xticks(0:1/dt:stop_time*10); 
xticklabels(0:1/dt:stop_time); 

% x-y limit
xlim([0, stop_time/dt])
xlabel('Time (seconds)')
ylabel('Velocity (m.s^-1/rad.s^-1)')

% Add legend
% legend([legend_ref, legend_period], 'Location', 'southeast')
legend(legend_body, 'Location', 'southeast')

hold off; % Release the plot for other operations

grid on
title('Velocity in body frame')

% Plot Nu_dot_b
figure('Name', 'Free Float Simulation: Acceleration, No Ballast', 'Position', [100, 100, 1000, 600])
plot(nf_nu_dot_b)

% Adjust time ticks
% xticks(0:1/dt:stop_time*10); 
xticklabels(0:1/dt:stop_time); 

% x-y limit
xlim([0, stop_time/dt])
xlabel('Time (seconds)')
ylabel('Acceleration (m.s^-2/rad.s^-2)')

% Add legend
% legend([legend_ref, legend_period], 'Location', 'southeast')
legend(legend_body, 'Location', 'southeast')

hold off; % Release the plot for other operations

grid on
title('Acceleration in body frame')

%% Plot the free float simulation data with ballast configuration
% Plot Eta_n
figure('Name', 'Free Float Simulation: Position and  Orientation', 'Position', [100, 100, 1000, 600])
plot(ff_eta_n)

% Adjust time ticks
% xticks(0:1/dt:stop_time*10); 
xticklabels(0:1/dt:stop_time); 

% x-y limit
xlim([0, stop_time/dt])
% ylim([-1.25, 0.25])
xlabel('Time (seconds)')
ylabel('Position (meter/radian)')

% Add legend
% legend([legend_ref, legend_period], 'Location', 'southeast')
legend(legend_body, 'Location', 'southeast')

hold off; % Release the plot for other operations

grid on
title('Position in NED frame')

% Plot Nu_b
figure('Name', 'Free Float Simulation: Velocity', 'Position', [100, 100, 1000, 600])
plot(ff_nu_b)

% Adjust time ticks
% xticks(0:1/dt:stop_time*10); 
xticklabels(0:1/dt:stop_time); 

% x-y limit
xlim([0, stop_time/dt])
xlabel('Time (seconds)')
ylabel('Velocity (m.s^-1/rad.s^-1)')

% Add legend
% legend([legend_ref, legend_period], 'Location', 'southeast')
legend(legend_body, 'Location', 'southeast')

hold off; % Release the plot for other operations

grid on
title('Velocity in body frame')

% Plot Nu_dot_b
figure('Name', 'Free Float Simulation: Acceleration', 'Position', [100, 100, 1000, 600])
plot(ff_nu_dot_b)

% Adjust time ticks
% xticks(0:1/dt:stop_time*10); 
xticklabels(0:1/dt:stop_time); 

% x-y limit
xlim([0, stop_time/dt])
xlabel('Time (seconds)')
ylabel('Acceleration (m.s^-2/rad.s^-2)')

% Add legend
% legend([legend_ref, legend_period], 'Location', 'southeast')
legend(legend_body, 'Location', 'southeast')

hold off; % Release the plot for other operations

grid on
title('Acceleration in body frame')