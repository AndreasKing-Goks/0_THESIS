function [Af, Omega, Gamma, X_ref, Y_ref, Z_ref, Phi_ref, Theta_ref, Psi_ref, time_stamps_x, time_stamps_y, time_stamps_z, time_stamps_phi, time_stamps_theta, time_stamps_psi] = RM_param_AGF(Case, idle_time, stop_time)
% Case selector
if Case == 1
    % Reference Model Tuning Parameters [HEAVE]
    ti = [1/1, 1/1, 3.5/1, 1/1, 1/1, 1/1];      %-----TUNE 
    Af = diag(ti);

    omega_is = [1/1, 1/1, 77/1, 1/1, 1/1, 1/1];      %-----TUNE 
    zeta_is = [1/1, 1/1, 95/1000, 1/1, 1/1, 1/1];       %-----TUNE 
    
    Omega = diag(2*omega_is.*zeta_is);
    Gamma = diag(omega_is);

    % Heave case
    [X_ref, Y_ref, Z_ref, Phi_ref, Theta_ref, Psi_ref, time_stamps_x, time_stamps_y, time_stamps_z, time_stamps_phi, time_stamps_theta, time_stamps_psi] = get_heave_case_AGF( ...
        idle_time, stop_time);
elseif Case == 2
    % Reference Model Tuning Parameters [ROLL]
    ti = [1/1, 1/1, 1/1, 1/2, 1/1, 1/1];      %-----TUNE 
    Af = diag(ti);

    omega_is = [1/1, 1/1, 1/1, 20/1, 1/1, 1/1];      %-----TUNE 
    zeta_is = [1/1, 1/1, 1/1, 40/100, 1/1, 1/1];       %-----TUNE 

    Omega = diag(2*omega_is.*zeta_is);
    Gamma = diag(omega_is);

    % Roll case
    [X_ref, Y_ref, Z_ref, Phi_ref, Theta_ref, Psi_ref, time_stamps_x, time_stamps_y, time_stamps_z, time_stamps_phi, time_stamps_theta, time_stamps_psi] = get_roll_case_AGF( ...
        idle_time, stop_time);
elseif Case == 3
    % Reference Model Tuning Parameters [PITCH]
    ti = [1/1, 1/1, 1/1, 1/1, 1/2, 1/1];      %-----TUNE 
    Af = diag(ti);

    omega_is = [1/1, 1/1, 1/1, 1/1, 20/1, 1/1];      %-----TUNE 
    zeta_is = [1/1, 1/1, 1/1, 1/1, 40/100, 1/1];       %-----TUNE 

    Omega = diag(2*omega_is.*zeta_is);
    Gamma = diag(omega_is);

    % Pitch case
    [X_ref, Y_ref, Z_ref, Phi_ref, Theta_ref, Psi_ref, time_stamps_x, time_stamps_y, time_stamps_z, time_stamps_phi, time_stamps_theta, time_stamps_psi] = get_pitch_case_AGF( ...
        idle_time, stop_time);
elseif Case == 4
    % Reference Model Tuning Parameters [PITCH]
    ti = [1/1, 1/1, 1/2, 1/2, 1/2, 1/1];      %-----TUNE 
    Af = diag(ti);

    omega_is = [1/1, 1/1, 20/1, 20/1, 20/1, 1/1];      %-----TUNE 
    zeta_is = [1/1, 1/1, 40/100, 40/100, 40/100, 1/1];       %-----TUNE 

    Omega = diag(2*omega_is.*zeta_is);
    Gamma = diag(omega_is);

    % Pitch case
    [X_ref, Y_ref, Z_ref, Phi_ref, Theta_ref, Psi_ref, time_stamps_x, time_stamps_y, time_stamps_z, time_stamps_phi, time_stamps_theta, time_stamps_psi] = get_static_case_AGF( ...
        idle_time, stop_time);    
else
    error('Case selection is not available. Stopping script.');
end