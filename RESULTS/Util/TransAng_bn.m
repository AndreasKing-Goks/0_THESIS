function [T_Theta_bn] = TransAng_bn(eta)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Command                                                                 %
%                                                                         %
% Compute the Angular Velocity Transformation from {n} to {b}             %
%                                                                         %
% Argument:                                                               %
% eta     : Input positional vector                                       %
%                                                                         %
% Created:      27.09.2023	Andreas Sitorus                               %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Get the angular velocity
phi = eta(4,1);       % Rolling angle
theta = eta(5,1);     % Pitching angle
psi = eta(6,1);       % Yaw angle

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
end