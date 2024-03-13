function [T_Theta_nb] = TransAng_nb(eta)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Command                                                                 %
%                                                                         %
% Compute the Angular Velocity Transformation from {b} to {n}             %
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
t12 = sin(phi) * tan(theta);
t13 = cos(phi) * tan(theta);
t21 = 0;
t22 = cos(phi);
t23 = -sin(phi);
t31 = 0;
t32 = sin(phi) / cos(theta);
t33 = cos(phi) / cos(theta);

% Angular Velocity Rotation Matrix (from {b} to {n})
T_Theta_nb = [t11 t12 t13;
              t21 t22 t23;
              t31 t32 t33];
end