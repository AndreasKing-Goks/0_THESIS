clear
clc
% Define the rotation angles in degrees
roll_deg = 0; % Roll angle in degrees
pitch_deg = 90; % Pitch angle causing gimbal lock when it's 90 degrees
yaw_deg = 30; % Yaw angle in degrees

% Convert degrees to radians for MATLAB trigonometric functions
roll = deg2rad(roll_deg);
pitch = deg2rad(pitch_deg);
yaw = deg2rad(yaw_deg);

% Define rotation matrices around the x (roll), y (pitch), and z (yaw) axes
R_x = [1, 0, 0; 0, cos(roll), -sin(roll); 0, sin(roll), cos(roll)]; % Roll rotation matrix
R_y = [cos(pitch), 0, sin(pitch); 0, 1, 0; -sin(pitch), 0, cos(pitch)]; % Pitch rotation matrix
R_z = [cos(yaw), -sin(yaw), 0; sin(yaw), cos(yaw), 0; 0, 0, 1]; % Yaw rotation matrix

% Combine the rotations. The order of multiplication matters and can change the final outcome.
% Here we use the common aerospace sequence of yaw, pitch, then roll (Z, Y, X).
R_final = R_x * R_y * R_z;

% Display the final rotation matrix
disp('Final rotation matrix:');
disp(R_final);

% To demonstrate gimbal lock, notice how the final rotation matrix simplifies when pitch = 90 degrees.
% This results in a loss of one degree of freedom, as the roll and yaw rotations now affect the object in the same way.
rank(R_final)