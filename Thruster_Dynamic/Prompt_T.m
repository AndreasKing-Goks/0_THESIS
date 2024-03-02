clear
clc
% Guide on 'mode'
% 0: Force to PWM, 1: PWM to Force
% STILL NOT WORKING ON ZERO FORCES
% IDEA:
% FOR DESIRED FORCES = 0, PWM = MID DEADZONE RANGE
% FOR DESIRED PWM WITHIN DEADZONE RANGE, FORCES = 0
% DEADZONE RANGE CHECK THRUSTER DOCS, SET FOR EACH VOLTAGE
% SOME INTERPOLATION MIGHT ALSO BE NEEDED FOR THE DEADZONE

% Thrust to PWM
val_desired = 1.233;
mode = 1; 

% PWM to Thrust
val_desired = 1500;
mode = 1; 

% Operating Voltage
voltage = 14.8;

% Check Thrust Allocation Matrix
T = Thrust_Allocation();

% Get result
% result = Convert_Thrust_PWM(val_desired,voltage,mode)
result = Convert2_Thrust_PWM(val_desired,voltage,mode)