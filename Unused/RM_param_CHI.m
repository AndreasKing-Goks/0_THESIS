function [X_ref, Y_ref, Z_ref, Phi_ref, Theta_ref, Psi_ref, resampled_time] = RM_param_CHI(Case, idle_time, stop_time, dt)
% Case selector
if Case == 1
    % Heave case
    [X_ref, Y_ref, Z_ref, Phi_ref, Theta_ref, Psi_ref, resampled_time] = get_heave_case_CHI(idle_time, ...
        stop_time, dt);
elseif Case == 2
    % Roll case
    [X_ref, Y_ref, Z_ref, Phi_ref, Theta_ref, Psi_ref, resampled_time] = get_roll_case_CHI(idle_time, ...
        stop_time, dt);
elseif Case == 3
    % Pitch case
    [X_ref, Y_ref, Z_ref, Phi_ref, Theta_ref, Psi_ref, resampled_time] = get_pitch_case_CHI(idle_time, ...
        stop_time, dt);
else
    error('Case selection is not available. Stopping script.');
end
end