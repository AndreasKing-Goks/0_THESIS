function [R_Theta_nb] = Rot_nb(eta)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Command                                                                 %
%                                                                         %
% Compute the Rotation from {b} to {n}                                    %
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
r12 = -sin(psi) * cos(phi) + cos(psi) * sin(theta) * sin(phi);
r13 = sin(psi) * sin(phi) + cos(psi) * cos(phi) * sin(theta);
r21 = sin(psi) * cos(theta);
r22 = cos(psi) * cos(phi) + sin(phi) * sin(theta) * sin(psi);
r23 = -cos(psi) * sin(phi) + sin(theta) * sin(psi) * cos(phi);
r31 = -sin(theta);
r32 = cos(theta) * sin(phi);
r33 = cos(theta) * cos(phi);

% Rotation Matrix (from {b} to {n})
R_Theta_nb = [r11 r12 r13;
              r21 r22 r23;
              r31 r32 r33];
end