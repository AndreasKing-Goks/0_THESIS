function [Fc_o, Ca_o, Crb_o] = Fc_o_record(Pos_N, Velo_B)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BlueROV2_acc()                                                          %
%                                                                         %
% Compute the dynamics of the BlueROV2 given the external forces,         %
% position and velocity described at the body frame                       %
%                                                                         %
% Argument:                                                               %
% Ex_Force  : External forces directed at sphere, described on Body Frame %
% Pos_N     : Position described at NED frame. Dim(3x1).                  %
% Velo_B    : Velocity described at Body frame. Dim(3x1).                 %
%                                                                         %
% Output:                                                                 %
% Acc_G     : Total acceleration of the BlueROV2                          %
% Reference:                                                              %
% [9]  An Open-Source Benchmark Simulator: Control of a BlueROV2          %
%      Underwater Robot                                                   %
%                                                                         %
% Created:      13.02.2024	Andreas Sitorus                               %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global Param
%% Position
% Described in NED frame
x = Pos_N(1,1);
y = Pos_N(2,1);
z = Pos_N(3,1);
phi = Pos_N(4,1);
theta = Pos_N(5,1);
psi = Pos_N(6,1);

% General Vector
T_ = [x; y; z];         % Translational Vector
R_ = [phi, theta, psi]; % Rotational Vector

%% Velocity
% Described in Body Frame at CO
u = Velo_B(1,1);
v = Velo_B(2,1);
w = Velo_B(3,1);
p = Velo_B(4,1);
q = Velo_B(5,1);
r = Velo_B(6,1);

% General Vector
V_ = [u; v; w];                 % Translation Velocity vector, read "Nu"
W_ = [p; q; r];                 % Angular velocity vector, read "Omega"

V_t = [V_ ; W_];                % 6DOF Velocity, expressed in CO

V_t_g = H_(-Param.CG.rg_o) * V_t;  % 6DOF Velocity, expressed in CG
V_t_b = H_(-Param.CB.rb_o) * V_t;  % 6DOF Velocity, expressed in CB

% Notes:
% For a velocity obtained from DVL, velocity is measured ad DVL Position.
% For damping and added mass coriolis-centripetal forces, transform the 
% velocity from DVL to CB. rCB_b = rCB_o - rb_o. Use rCB_b for H_ matrix

%% Centers
% Origin
xo = Param.CO.ro(1);
yo = Param.CO.ro(2);
zo = Param.CO.ro(3);

% Gravity
xg = Param.CG.rg(1);
yg = Param.CG.rg(2);
zg = Param.CG.rg(3);

% Buoyancy
xb = Param.CB.rb(1);
yb = Param.CB.rb(2);
zb = Param.CB.rb(3);

%% Coriolis-Centripetal Forces
% MOI
Ixx = Param.MOI(1);
Iyy = Param.MOI(2);
Izz = Param.MOI(3);

% CC-Rigid Body
% Described in Body frame, at Center of Gravity

Crb11 = zeros(3); 
Crb12 = [0 Param.m*w -Param.m*v;
         -Param.m*w 0 Param.m*u;
         Param.m*v -Param.m*u 0];
Crb21 = Crb12;
Crb22 = [0 -Izz*r -Iyy*q;
         Izz*r 0 Ixx*p;
         Iyy*q -Ixx*p 0];

Crb = [Crb11 Crb12;
             Crb21 Crb22]; % Rigid Body Coriolis Force Matrix, at Center of Gravity
Crb_o = (H_(Param.CG.rg_o))' * Crb * V_t_g;

% Added Mass Coefficient
Xud = Param.AM(1);
Yvd = Param.AM(2);
Zwd = Param.AM(3);
Kpd = Param.AM(4);
Mqd = Param.AM(5);
Nrd = Param.AM(6);

% CC-Added Mass
% Described in Body frame, at Center of Buoyancy
Ca11 = zeros(3);
Ca12 = [0 -Zwd*w Yvd*v;
        Zwd*w 0 -Xud*u;
        -Yvd*v Xud*u 0];
Ca21 = Ca12;
Ca22 = [0 -Nrd*r Mqd*q;
        Nrd*r 0 -Kpd*p;
        -Mqd*q Kpd*p 0];

Ca = [Ca11 Ca12;
      Ca21 Ca22]; % Added mass Coriolis Force Matrix, at Center of Buoyancy
Ca_o = (H_(CB.rb_o))' * Ca * V_t_b;

% Total Coriolis-Centripetal Force
Fc_o = Crb_o + Ca_o;
end