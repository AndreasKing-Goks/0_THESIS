clear
clc

set_points = {[-0.8, 0],[-0.7, 10], [-0.6, 20], [-0.5, 50], [-0.4, 70], [-0.3, 80], [-0.2, 90]};
dt = 0.01;

% MANUAL REFERENCE MODEL
ti = [1/1, 1/1, 1/1, 1/2, 1/2, 1/2];      %-----TUNE 
Af = diag(ti);

omega_is = [0.2, 0.2, 0.2, 0.2, 0.2, 0.2];      %-----TUNE 
zeta_is = [1.5, 1.5, 1.5, 1.5, 1.5, 1.5];       %-----TUNE 

Gamma = diag(omega_is);
Omega = diag(2*omega_is.*zeta_is);

%% Data Extracting
[val_checkpoints, time_stamps] = convert_sp_to_step(set_points);