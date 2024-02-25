function Param = Sphere_Parameters(percent_foam, percent_metal)
global Param
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sphere_Parameters()                                                     %
%                                                                         %              
% Set initial conditions and fixed parameters for the sphere dynamics     %
%                                                                         %
% Created:      27.09.2023	Andreas Sitorus                               %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initial Speed and Position in NED Frame
Param.IC_Pos = [0; 0; -10; 0; 0; 0];
Param.IC_Velo = [0; 0; 0; 0; 0; 0];

%% General Parameters
% Environment
Param.rho_fluid = 1000;      % Fresh water, kg/m3
Param.g = 9.81;              % m/s2, Positive pointing down to center of Earth

% Sphere Properties
Param.D = 0.25;                                     % Diameter, m
Param.R = Param.D/2;                                % Radius, m
Param.V = 4/3 * pi * Param.R^2;                     % m3

Param.percent_foam = percent_foam;                                 
Param.percent_metal = percent_metal;                              

Param.rho_foam = 300;                               % Heavy Foam, kg/m3
Param.rho_metal = 7500;                             % Stainless Steel, kg/m3
Param.rho_cavity = Param.rho_fluid;                             % kg/m3

Param.foam_height = (1 - Param.percent_foam) * Param.R;
Param.metal_height = (1 - Param.percent_metal) * Param.R;
% Param.cavity_t_height = Param.R - Param.foam_height;
% Param.cavity_b_height = Param.R - Param.metal_height;

Param.V_foam = pi*((Param.R^3 - Param.R * Param.foam_height^2) - ((Param.R^3 - Param.foam_height^3)/3));
Param.V_metal = pi*((Param.R^3 - Param.R * Param.metal_height^2) - ((Param.R^3 - Param.metal_height^3)/3));

Param.V_cavity_t = (Param.V/2) - Param.V_foam;
Param.V_cavity_b = (Param.V/2) - Param.V_metal;

Param.V_cavity = Param.V_cavity_t + Param.V_cavity_b;

Param.m_foam = Param.rho_foam * Param.V_foam;        % kg
Param.m_metal = Param.rho_metal * Param.V_metal;     % kg
Param.m_cavity = Param.rho_cavity * Param.V_cavity;  % kg

Param.m = Param.m_foam + Param.m_metal + Param.m_cavity;    % kg
Param.mb = Param.rho_fluid * Param.V;                       % kg
Param.I = 2/5 * Param.m * Param.R^2;                        % Moment inertia, kg.m2
Param.ma = -Param.rho_fluid * 2/3 * pi * Param.R^2;         % Added mass, kg

Param.W = Param.m * Param.g;                    % N
Param.B = Param.mb * Param.g;                   % Fully submerged, N

%% Center of Origin in NED Frame
% Center of Origin
Param.xo = 0;
Param.yo = 0;
Param.zo = 0;

Param.ro = [Param.xo; Param.yo; Param.zo];

%% Centroid in z-axis for each Parts in Body Frame
% Foam
Param.centroid_foam = ((((Param.R^4)/2 - (Param.R^2 * Param.foam_height^2)/2) - ((Param.R^4)/4 - (Param.foam_height^4)/4))/Param.V_foam + Param.foam_height);

% Metal
Param.centroid_metal = ((((Param.R^4)/2 - (Param.R^2 * Param.metal_height^2)/2) - ((Param.R^4)/4 - (Param.metal_height^4)/4))/Param.V_metal + Param.metal_height);

% Cavity
Param.centroid_HS = 3 * Param.R / 8;
Param.V_HS = Param.V/2;

Param.centroid_cavity_t = ((Param.centroid_HS * Param.V_HS) - (Param.centroid_foam * Param.V_foam))/Param.V_cavity_t;
Param.centroid_cavity_b = ((Param.centroid_HS * Param.V_HS) - (Param.centroid_metal * Param.V_metal))/Param.V_cavity_b;
Param.centroid_cavity = (Param.V_cavity_t*Param.centroid_cavity_t - Param.V_cavity_b*Param.centroid_cavity_b)/(Param.V_cavity);

%% Center of Gravity and Buoyancy in Body Frame
% Center of Gravity
Param.xg = 0;
Param.yg = 0;
Param.zg = (Param.m_foam*Param.centroid_foam + Param.m_metal*Param.centroid_metal + Param.m_cavity*Param.centroid_cavity)/(Param.m_foam + Param.m_metal + Param.m_cavity);

Param.rg = [Param.xg; Param.yg; Param.zg];

% Center of Buoyancy
Param.xb = 0;
Param.yb = 0;
Param.zb = (Param.V_foam*Param.centroid_foam + Param.V_metal*Param.centroid_metal + Param.V_cavity*Param.centroid_cavity)/(Param.V);

Param.rb = [Param.xb; Param.yb; Param.zb];

%% Body Positions
% Only used if body is modular and have several components

%% Body Mass Matrix
Param.Mrb = [Param.m 0 0 0 Param.m*Param.zg 0;
             0 Param.m 0 -Param.m*Param.zg 0 0;
             0 0 Param.m 0 0 0;
             0 -Param.m*Param.zg 0 Param.I 0 0;
             Param.m*Param.zg 0 0 0 Param.I 0;
             0 0 0 0 0 Param.I];

%% Body Added Mass Matrix
Param.Ma = -diag([Param.ma Param.ma Param.ma 0 0 0]);

%% Generalized Mass Matrix
Param.MT = Param.Mrb + Param.Ma;

end