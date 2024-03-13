function [R_Theta_bn] = Rot_bn(eta)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Command                                                                 %
%                                                                         %
% Compute the Rotation from {n} to {b}                                    %
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
end