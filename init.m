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
Param = BlueROV2_param();

%% Timestep
dt = 0.1;  %-----To set

%% Input Force in Body Frame
Input_F = [0; 0; 0];       % Forces in x-axis, y-axis, and z-axis (Body Frame)
F_Coord = [0; 0; 0];       % External forces exerted on the top of the sphere, in line with the center of gravity

Ex_Force = Command_Force(Input_F, F_Coord);
impulse_time = 0.001;

%% Initial Condition
% States
Pos_N = Param.IC.Pos;
Velo_B = Param.IC.Velo;

% Thruster Dynamics
upper_limit = 30;
lower_limit = -upper_limit;
thrust_rate = 5;

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
    error('Method selection is not available. Stopping script.');
end

% Set the stop time of your Simulink model
set_param('BlueROV2_Exp_Simu', 'StopTime', num2str(stop_time));

%% Controller Model Parameters (PID)
% CP1 Heave
% Kp = [0.001; 0.001; 15; 0.001; 0.001; 0.001];
% Ki = [0.01; 0.01; 3; 0.01; 0.01; 0.01];
% Kd = [0.1; 0.1; 3; 0.1; 0.1; 0.1];

% CP2 Heave
% Kp = [0.001; 0.001; 15; 0.001; 0.001; 0.001];
% Ki = [0.01; 0.01; 3; 0.01; 0.01; 0.01];
% Kd = [0.1; 0.1; 35; 0.1; 0.1; 0.1];

Kp = [0.001; 0.001; 19.5; 0.001; 0.001; 0.001];
Ki = [0.01; 0.01; 3.1; 0.01; 0.01; 0.01];
Kd = [0.1; 0.1; 36.1; 0.1; 0.1; 0.1];

%% Extended Kalman Filter Parameters
[inv_M, B, H, R, Q, dt, inv_Tb, Gamma_o] = EKF_param(dt);

%% Ballast Force
% How to use:
% Each element in the cell indicates the hook number.
% Assign the "Ballast Code" to the cell's element to attach the ballast.
% Ballast Code [dtype=string | 0 means unassigned]:
% -"FS" - Small Floater
% -"FM" - Medium Floater
% -"FL" - Large Floater
% -"WS" - Small Weight
% -"WM" - Medium Weight
% -"WL" - Large Weight 

prompt = {0 0 0 'FS' 'FS' 0 0 0 0};

Ballast_Config = Ballast_Configuration(prompt);

%Ballast_Force = zeros(6,1);
Ballast_Force = Ballast_Term(Ballast_Config);

%% Thruster Force
Thruster_Force = zeros(6,1);

%% Environment Force
Env_Force = zeros(6,1);

%% Tether Force
Tether_Force = zeros(6,1);

%% Sphere Dynamic Model [FOR CHECKING]
Acc_G = BlueROV2_acc(Ballast_Force, Thruster_Force, Tether_Force, Pos_N, Velo_B);

%% HELP READING Acceleration result
% Forces defined in NED at first, then transformed to the body coordinate
% Thus, positive sign means downwards
% Positive acceleration means Negatively Buoyant
% Negative acceleration means Positively Buoyant

%% UNUSED
