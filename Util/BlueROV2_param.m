function Param = BlueROV2_param()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BlueROV2_Parameters()                                                   %
%                                                                         %
% Set initial conditions and fixed parameters for the BlueROV2 dynamics   %
%                                                                         %
% Arguments:                                                              %
% -                                                                       %
%                                                                         %
% Output:                                                                 %
% Param[struct] : Structure containing all fixed sphere model parameters  %
%                                                                         %
% Created:      13.02.2024	Andreas Sitorus                               %
%                                                                         %
% Reference:                                                              %
% [9]  An Open-Source Benchmark Simulator: Control of a BlueROV2          %
%      Underwater Robot                                                   %
% [10] Fresh Water and Sea Water Properties                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global Param
%% Initial Speed and Position in NED Frame
Param.IC.Pos = [0; 0; 0; 0; 0; 0];
Param.IC.Velo = [0; 0; 0; 0; 0; 0];

%% General Parameters
% Environment
Param.Env.rho_FW = 999.7025;                            % Fresh water density at 10 deg. C [10], kg/m3
Param.Env.nu_FW = 1.3063e-6;                            % Fresh water kinematic viscosity at 10 deg. C [10], m2/s
Param.Env.mu_FW = Param.Env.rho_FW * Param.Env.nu_FW;   % Fresh water dynamic viscosity at 10 deg. C [10], Pa.s
Param.Env.rho_SW = 1027;                                % Fresh water density at 10 deg. C [10], kg/m3
Param.Env.nu_SW = 1.3604e-6;                            % Fresh water kinematic viscosity at 10 deg. C [10], m2/s
Param.Env.mu_SW = Param.Env.rho_SW * Param.Env.nu_SW;   % Fresh water dynamic viscosity at 10 deg. C [10], Pa.s
Param.Env.g = 9.81;                                     % m/s2, Positive pointing down to center of Earth

% ROV Properties
Param.Dim.Loa = 457.1/1000;       % Length overall, m
Param.Dim.Boa = 575.0/1000;       % Beam overall, m
Param.Dim.Hoa = 253.9/1000;       % Height overall, m

Param.V_block = Param.Dim.Loa * Param.Dim.Boa * Param.Dim.Hoa;           % Block volume, m3
Param.V_disp = 0.0134;                                                   % Volume Displacement [9], m3

Param.m = 13.5;                 % kg, NEED TO BE MEASURED IN LAB
Param.MOI= [0.26 0.23 0.37];    % Moment inertia-z [9], kg.m2

Param.W = Param.m * Param.Env.g;                        % N
Param.B = Param.V_disp * Param.Env.rho_FW * Param.Env.g;    % N                   % Fully submerged, N

%% Center of Origin
% Center of Origin defined in Body Frame
Param.CO.ro = [0; 0; 0];

%% Center of Gravity and Buoyancy in Body Frame
% Center of Gravity
Param.CG.rg = [0; 0; 0];

% Center of Buoyancy
Param.CB.rb = [0; 0; -0.01];

% Eulerian distance for transformation
Param.CG.rg_o = Param.CG.rg - Param.CO.ro; % Distance from center of gravity to center of origin 
Param.CB.rb_o = Param.CB.rb - Param.CO.ro; % Distance from center of buoyancy to center of origin

%% Body Positions
% Only used if body is modular and have several components

%% Body Mass Matrix Transformed to CO
Param.Mrb = diag([Param.m Param.m Param.m Param.MOI]);
            
Param.Mrb_o = Transform(Param.Mrb,Param.CG.rg_o);

%% Body Added Mass Matrix Transformed to CO
Xud = 6.3567;     % kg [9]
Yvd = 7.1206;     % kg [9]
Zwd = 18.6863;    % kg [9]
Kpd = 0.1858;    % kg.m2 [9]
Mqd = 0.1348;    % kg.m2 [9]
Nrd = 0.2215;    % kg.m2 [9]

Param.AM = [Xud Yvd Zwd Kpd Mqd Nrd];

Param.Ma = -diag(Param.AM);

Param.Ma_o = Transform(Param.Ma,Param.CB.rb_o);

%% Damping Coefficient
% Linear Damping Coefficient
Xu_l = 13.7;    % N.s/m
Yv_l = 0;       % N.s/m
Zw_l = 33.0;    % N.s/m
Kp_l = 0;       % N.s/m
Mq_l = 0.8;     % N.s/m
Nr_l = 0;       % N.s/m

% Linear Damping Matrix
Param.K_l = [Xu_l Yv_l Zw_l Kp_l Mq_l Nr_l];

% Nonlinear Damping Coefficient
Xu_nl = 141.0;  % N.s2/m2
Yv_nl = 217.0;  % N.s2/m2
Zw_nl = 190.0;  % N.s2/m2
Kp_nl = 1.192;  % N.s2/m2
Mq_nl = 0.470;  % N.s2/m2
Nr_nl = 1.500;  % N.s2/m2

% Nonlinear Damping Matrix
Param.K_nl = [Xu_nl Yv_nl Zw_nl Kp_nl Mq_nl Nr_nl];

%% Generalized Mass Matrix
Param.MT = Param.Mrb_o - Param.Ma_o;
Param.inv_MT = inv(Param.MT);

end