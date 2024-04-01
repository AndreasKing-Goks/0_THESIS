function Obj_Val = Objective_Function(Estimation_Var_Scaled, mode, scales)
global Param_NIF
%% Get the mode of objective function
% To optimize heave parameters
if strcmp(mode, 'heave')
    data = 3;
elseif strcmp(mode, 'roll')
    data = 4;
elseif strcmp(mode, 'pitch')
    data = 5;
else
    error('Mode selection is not supported. Stopping script.');
end

%% Get data from simulink
% Scales back Estimation_Var_Scaled to Estimation_Var
Estimation_Var = Estimation_Var_Scaled .* scales;

% Get the optimization variables
Param_NIF.AM = Estimation_Var(1:6);
Param_NIF.K_l = Estimation_Var(7:12);
Param_NIF.K_nl = Estimation_Var(13:18);
Param_NIF.Ballast_Force = [0 ; 0; Estimation_Var(19:21)'; 0];

% Set the model name
modelName = 'BlueROV2_Exp_Simu_NIF';

% Full path to the "Ballast" block within the subsystems
ballastBlockPath = 'BlueROV2_Exp_Simu_NIF/For Estimation/BlueROV2/Ballast Force in Body Frame';

% Set the parameter at Simulink Model
set_param([modelName '/Added_Mass'], 'Value', mat2str(Param_NIF.AM))
set_param([modelName '/Linear_Damping'], 'Value', mat2str(Param_NIF.K_l))
set_param([modelName '/Nonlinear_Damping'], 'Value', mat2str(Param_NIF.K_nl))
set_param([modelName '/Ballast_Force'], 'Value', mat2str(Param_NIF.Ballast_Force))
set_param([ballastBlockPath '/Ballast'], 'Before', mat2str(Param_NIF.Ballast_Force))
set_param([ballastBlockPath '/Ballast'], 'After', mat2str(Param_NIF.Ballast_Force))


% Run the Simulink Model
simOut = sim(modelName, 'ReturnWorkspaceOutputs', 'on');

% Get the Velo_Mea
Velo_Mea = squeeze(simOut.Est_Velo_B_S(data,:,:));

% Get the Velo_Est
Velo_Est = squeeze(simOut.Velo_B_S(data,:,:));

%% Convergence coefficient
G_delta = 100;

%% Estimation-Measurement Error
delta = Velo_Est - Velo_Mea;

%% Compute cost value
nominator = delta' * delta;
denuminator = Velo_Mea' * Velo_Mea;

Obj_Val = (nominator/denuminator) * G_delta;

%% Handle exploding objective value
if Obj_Val > 100000
    Obj_Val = 100000;
end

end