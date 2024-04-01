function Obj_Val = Objective_Function(Estimation_Var_Scaled, mode, scales, dt, stop_time, accFunargs)
global Param
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

%% Get the measured data
% Velo mea should span over all the time steps.
% Thus extract the data directly
temp_Velo_Mea = squeeze(Param.NIF_nu_b).';
Velo_Mea = temp_Velo_Mea(:, data);

%% Get the estimation data
% Scales back Estimation_Var_Scaled to Estimation_Var
Estimation_Var = Estimation_Var_Scaled .* scales;

% Get the optimization variables
Param.NIF_AM = Estimation_Var(1:6);
Param.NIF_K_l = Estimation_Var(7:12);
Param.NIF_K_nl = Estimation_Var(13:18);
Param.NIF_Ballast_Force = [0 ; 0; Estimation_Var(19:21)'; 0];

% Get the estimated velocity
[~, nu_b] = BlueROV2_Dynamic_Model(dt, stop_time, accFunargs);
Velo_Est = nu_b(:, data);

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