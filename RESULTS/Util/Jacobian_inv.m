function [J_Theta_bn] = Jacobian_inv(phi, theta, psi)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Command                                                                 %
%                                                                         %              
% Compute the Jacobian inverse from {n} to {b}                            %
%                                                                         %
% For 6-DOF Equations:                                                    %
% [ndot = Jacobian(n_theta) * v]                                          %
% -ndot = velocity expressed in NED frame                                 %
% -n_theta = rotational part of position vector                           %
% - v = velocity expressed in Body frame                                  %
%                                                                         %
% Argument:                                                               %
% eta     : Input positional vector                                       %
%                                                                         %
% Created:      27.09.2023	Andreas Sitorus                               %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Linear Velocity Transformation Matrix
% Element
r11 = cos(psi) * cos(theta);
r12 = cos(theta) * sin(psi);
r13 = -sin(theta);
r21 = cos(psi) * sin(phi) * sin(theta) - sin(psi) * cos(phi);
r22 = cos(phi) * cos(psi) + sin(phi) * sin(psi) * sin(theta);
r23 = cos(theta) * sin(phi);
r31 = sin(phi) * sin(psi) + cos(phi) * cos(psi) * sin(theta);
r32 = cos(phi) * sin(psi) * sin(theta) - cos(psi) * sin(phi);
r33 = cos(phi) * cos(theta);

% Rotation Matrix (from {n} to {b})
R_Theta_bn = [r11 r12 r13;
              r21 r22 r23;
              r31 r32 r33];

%% Angular Velocity Transformation Matrix
% Element
t11 = 1;
t12 = 0;
t13 = -sin(theta);
t21 = 0;
t22 = cos(phi);
t23 = cos(theta) * sin(phi);
t31 = 0;
t32 = -sin(phi);
t33 = cos(theta) * cos(phi);

% Angular Velocity Rotation Matrix (from {n} to {b})
T_Theta_bn = [t11 t12 t13;
              t21 t22 t23;
              t31 t32 t33];

%% Jacobian
J_Theta_bn = [R_Theta_bn  zeros(3);
               zeros(3) T_Theta_bn];

end