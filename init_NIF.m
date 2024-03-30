%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% init_NIF                                                                %
%                                                                         %
% Initialize workspace                                                    %
%                                                                         %
% Created:      28.03.2024	Andreas Sitorus                               %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
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

% Add 'NIF' path
addpath(fullfile(currentDir, 'NIF'));

%% Open Simulink Model
% Correct modelName to exclude the file extension for bdIsLoaded
modelName = 'BlueROV2_Exp_Simu_NIF';

% Use the full file name including extension with open_system
modelFileName = 'BlueROV2_Exp_Simu_NIF.slx';

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
% There are 3 cases: Heave case(1), Roll case(2), and Pitch case(3)

% Methods selector
Method = 2;

% Cases selector
Case = 1;

% Define time check points
% Note:
% idle_time sets the time for the ROV to go to start position and stay idle for a while
% ROV needs to be idle for some idle_time before the whole simulation ends
idle_time = 10;     
stop_time = 120;

% Get parameters
if Method == 1
    [X_ref, Y_ref, Z_ref, Phi_ref, Theta_ref, Psi_ref, resampled_time] = RM_param_CHI(Case, idle_time, stop_time, dt);
elseif Method == 2
    [Af, Omega, Gamma, X_ref, Y_ref, Z_ref, Phi_ref, Theta_ref, Psi_ref, time_stamps_x, time_stamps_y, time_stamps_z, time_stamps_phi, time_stamps_theta, time_stamps_psi] = RM_param_AGF(Case, idle_time, stop_time);
else
    error('Method selection is not supported. Stopping script.');
end

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
Kp = [255; 545; 7095; 2420; 2375; 1];
Ki = [45; 45; 10; 96; 96; 1];
Kd = [155; 355; 8985; 1205; 1205; 1];

% % Best Roll case
% Kp = [1; 100; 100; 100; 200; 1];
% Ki = [1; 20; 20; 80; 10; 1];
% Kd = [1; 70; 70; 120; 100; 1];

% % Best Pitch case
% Kp = [120; 120; 120; 200; 100; 1];
% Ki = [30; 30; 30; 10; 80; 1];
% Kd = [90; 90; 80; 100; 120; 1];

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
% Location Desctription
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
% Location : FR   FL   OMF  IMF  IMA  OMA  AR   AL
w_prompt = {'WN' 'WN' 'WN' 'WN' 'WN' 'WN' 'WN' 'WN'};
prompt = [f_prompt w_prompt];

% Other function arguments
max_f = 24;
max_w = 8;
funargs = {max_f max_w};

% Get the ballast configuration
Ballast_Config = Ballast_Configuration(prompt, funargs);

% Compute the ballast force
Ballast_Force = Ballast_Compute(Ballast_Config);

%% Tether Force
Tether_Force = zeros(6,1);

%% Numerical Integration Fitting Method
% % NIF Parameters
% Param_NIF.AM = [6.3567, 7.1206, 18.6863, 0.1858, 0.1348, 0.2215];   % Added Mass
% Param_NIF.K_l = [13.7, 0, 33.0, 0, 0.8, 0];                         % Linear Damping Coefficient
% Param_NIF.K_nl = [141.0, 217.0, 190.0, 1.192, 0.470, 1.500];        % Nonlinear Damping Coefficient
% Param_NIF.Ballast_Force = [0; 0; 0; 0; 0; 0];                       % Ballast Term

% Set the stop time of your Simulink model
set_param('BlueROV2_Exp_Simu_NIF', 'StopTime', num2str(stop_time));

% Get the estimation variables
% NIF Parameters
% % % Initial and ground truth condition
% AM = [6.3567, 7.1206, 18.6863, 0.1858, 0.1348, 0.2215];     % Added Mass
% K_l = [13.7, 0, 33.0, 0, 0.8, 0];                           % Linear Damping Coefficient
% K_nl = [141.0, 217.0, 190.0, 1.192, 0.470, 1.500];          % Nonlinear Damping Coefficient
% Ballast_Term = [0; 0; 0];                                   % Ballast Term
% Ballast_Force = [0; 0; Ballast_Term; 0];                    % Ballast Force

% % Initial and ground truth condition
AM = [1, 1, 1, 1, 1, 1];     % Added Mass
K_l = [1, 1, 1, 1, 1, 1];                           % Linear Damping Coefficient
K_nl = [1, 1, 1, 1, 1, 1];          % Nonlinear Damping Coefficient
Ballast_Term = [1; 1; 1];                                   % Ballast Term
Ballast_Force = [0; 0; Ballast_Term; 0];                    % Ballast Force

% INPUT
Estimation_Var = [AM K_l K_nl Ballast_Term'];              % Estimation variables

% Set the mode of the objective function
% Available mode: 'heave', 'roll', 'pitch'
mode = 'heave';

% Set pseudo function of the objective function
obj_func = @(var) Objective_Function(Estimation_Var, mode);

% % Compute the objective function
% Obj_Val = obj_func(Estimation_Var)

% Run NIF
[Est_Var, Obj_Val] = NIF(obj_func, Estimation_Var);

%% Display Results
Est_AM = Est_Var(1:6)
Est_K_l = Est_Var(7:12)
Est_K_nl = Est_Var(13:18)
Est_g0 = Est_Var(19:21)

%% NOT USED
% % Run the Simulink model
% simOut = sim(modelName, 'ReturnWorkspaceOutputs', 'on');

% % Get the velocity data from the simulation
% Result_NIF.Velo_Mea = simOut.Est_Velo_B_S;
% Result_NIF.Velo_Est = simOut.Velo_B_S;

% % Choose the parameter index you want to sweep
% param_index = 1; % As an example, vary the first parameter
% min_value = 0.1; % Define the minimum value of the sweep range
% max_value = 10; % Define the maximum value of the sweep range
% number_of_points = 100; % Number of points in the sweep
% 
% % Preallocate the sweep values
% param_sweep = linspace(min_value, max_value, number_of_points);
% Obj_Val_sweep = zeros(1, number_of_points);
% 
% % Keep other parameters fixed at their initial values
% fixed_params = Estimation_Var;
% 
% % Sweep across the parameter range
% for i = 1:number_of_points
%     % Update only the parameter you're sweeping
%     Estimation_Var(param_index) = param_sweep(i);
% 
%     % Evaluate the objective function
%     Obj_Val_sweep(i) = Objective_Function(Estimation_Var, mode);
% end
% 
% % Plot the results
% figure;
% plot(param_sweep, Obj_Val_sweep);
% xlabel(sprintf('Parameter %d Value', param_index));
% ylabel('Objective Function Value');
% title(sprintf('Objective Function Sweep for Parameter %d', param_index));
