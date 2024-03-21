function Param_B = Ballast_Param()
global Param_B
%% Ballast hook configuration
% Hook position for all front floaters
x_ff = [0.22 0.22 0.22 0.22 0.17 0.17 0.16 0.16 0.16 0.16];
y_ff = [0.17 -0.17 0.16 -0.16 0.17 -0.17 0.17 -0.17 0.16 -0.16];
z_ff = [-0.07 -0.07 -0.07 -0.07 -0.07 -0.07 -0.15 -0.15 -0.15 -0.15];

% Hook position for all middle floaters
x_fm = [0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0];
y_fm = [0.17 -0.17 0.28 -0.28 0.28 -0.28 0.17 -0.17 0.16 -0.16];
z_fm = [0.06 0.06 0.0 0.0 -0.02 -0.02 -0.17 -0.17 -0.17 -0.17];

% Hook position for all aft floaters
x_fa = [-0.16 -0.16 -0.16 -0.16 -0.17 -0.17 -0.22 -0.22 -0.22 -0.22];
y_fa = [0.17 -0.17 0.16 -0.16 0.17 -0.17 0.17 -0.17 0.16 -0.16];
z_fa = [-0.15 -0.15 -0.15 -0.15 -0.07 -0.07 -0.07 -0.07 -0.07 -0.07];

% Hook position for all floaters
Param_B.x_f = [x_ff x_fm x_fa];
Param_B.y_f = [y_ff y_fm y_fa];
Param_B.z_f = [z_ff z_fm z_fa];

% Hook position for all weights
Param_B.x_w = [0.11 0.11 0.10 0.05 -0.05 -0.08 -0.09 -0.09];
Param_B.y_w = [0.13 -0.13 0.0 0.0 0.0 0.0 0.13 -0.13];
Param_B.z_w = [-0.17 -0.17 -0.17 -0.17 -0.17 -0.17 -0.17 -0.17];

% Number of hooks
Param_B.num_floater = length(Param_B.x_f);
Param_B.num_weight = length(Param_B.x_w);

%% Ballast
% Gravitational acceleration
g = 9.81;                                   % m.s-2

% Floaters
rho_f = 192;                                % kg.m-3
rho_w = 1000;                               % kg.m-3

sect_area= 0.25^2;                          % m2

Vol_S = sect_area * 0.04;                   % m3
Vol_M = sect_area * 0.06;                   % m3
Vol_L = sect_area * 0.1;                    % m3

Param_B.Ff_S = (rho_f - rho_w) * Vol_S * g; % N
Param_B.Ff_M = (rho_f - rho_w) * Vol_M * g; % N
Param_B.Ff_L = (rho_f - rho_w) * Vol_L * g; % N

% Weights
w_mass = 0.2;                               % kg
Param_B.Fw = w_mass * g;                    % N
end