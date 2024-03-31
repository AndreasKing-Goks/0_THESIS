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

% % Parameter scaling
scale_AM = [10, 10, 10, 0.2, 0.2, 0.2];                         % Added Mass
scale_K_l = [15, 15, 15, 1, 1, 1];                              % Linear Damping Coefficient
scale_K_nl = [200, 200, 200, 1, 1, 1];                          % Nonlinear Damping Coefficient
scale_Ballast_Term = [20; 1; 1];                                % Ballast Term
scales = [scale_AM, scale_K_l, scale_K_nl, scale_Ballast_Term'];  

% % Initial and ground truth condition
AM = [2.3567, 2.1206, 8.6863, 2.1858, 2.1348, 2.2215];     % Added Mass
K_l = [10.7, 0, 25.0, 0, 1.8, 0];                           % Linear Damping Coefficient
K_nl = [101.0, 187.0, 130.0, 0.192, 1.470, 0.500];          % Nonlinear Damping Coefficient
Ballast_Term = [0; 0; 0];                                   % Ballast Term
Ballast_Force = [0; 0; Ballast_Term; 0];                    % Ballast Force

% INPUT
Estimation_Var = [AM K_l K_nl Ballast_Term'];              % Estimation variables

% Set the mode of the objective function
% Available mode: 'heave', 'roll', 'pitch'
mode = 'heave';

% Set pseudo function of the objective function
obj_func = @(var) Objective_Function(var, mode, scales);

% % Compute the objective function
% Obj_Val = obj_func(Estimation_Var)

% Run NIF
[Opt_Var, Obj_Val] = NIF(obj_func, Estimation_Var, scales);

%% Display Results
Opt_AM = Est_Var(1:6)
Opt_K_l = Est_Var(7:12)
Opt_K_nl = Est_Var(13:18)
Opt_g0 = Est_Var(19:21)
