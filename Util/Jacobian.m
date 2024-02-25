function [R_Theta, T_Theta, J_Theta] = Jacobian(eta)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Command                                                                 %
%                                                                         %              
% Compute the Jacobian to integrate the next acceleration to velocity     %
%                                                                         %
% For 6-DOF Equations:                                                    %
% [ndot = Jacobian(n_theta) * v]                                          %
% -ndot = velocity expressed in NED frame                                 %
% -n_theta = rotational part of position vector                           %
% - v = velocity expressed in Body frame                                  %
%                                                                         %
% Argument:                                                               %
% X     : Input positional vector                                         %
%                                                                         %
% Created:      27.09.2023	Andreas Sitorus                               %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Get the angular velocity
phi = eta(4,1);       % Rolling angle
theta = eta(5,1);     % Pitching angle
psi = eta(6,1);       % Yaw angle

%% Linear Velocity Transformation Matrix
% Element
r11 = cos(psi) * cos(theta);
r12 = -sin(psi) * cos(phi) + cos(psi) * sin(theta) * sin(phi);
r13 = sin(psi) * sin(phi) + cos(psi) * cos(phi) * sin(theta);
r21 = sin(psi) * cos(theta);
r22 = cos(psi) * cos(phi) + sin(phi) * sin(theta) * sin(psi);
r23 = -cos(psi) * sin(phi) + sin(theta) * sin(psi) * cos(phi);
r31 = -sin(theta);
r32 = cos(theta) * sin(phi);
r33 = cos(theta) * cos(phi);

% Matrix
R_Theta = [r11 r12 r13;
           r21 r22 r23;
           r31 r32 r33];

%% Angular Velocity Transformation Matrix
% Element
t11 = 1;
t12 = sin(phi) * tan(theta);
t13 = cos(phi) * tan(theta);
t21 = 0;
t22 = cos(phi);
t23 = -sin(phi);
t31 = 0;
t32 = sin(phi) * cos(theta);
t33 = cos(phi) * cos(theta);

% Matrix
T_Theta = [t11 t12 t13;
           t21 t22 t23;
           t31 t32 t33];

%% Jacobian
J_Theta = [R_Theta  zeros(3);
           zeros(3) T_Theta];

end