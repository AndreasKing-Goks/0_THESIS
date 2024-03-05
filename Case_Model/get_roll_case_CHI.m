function [X_ref, Y_ref, Z_ref, Phi_ref, Theta_ref, Psi_ref, resampled_time] = get_roll_case_CHI(idle_time, stop_time, dt)
%% Initialize mission boundaries
start_pos = 0;
end_pos = 0;

%% Initialize step value
step_value = dt;

%% Initialize idle start
idle_start = {[0,0], [start_pos,idle_time]};

%% Initialize idle stop
idle_end = {[end_pos,(stop_time-idle_time)], [end_pos,stop_time]};

%% Initialize heave set points (4 set points)
test_period = (stop_time - idle_time) - idle_time;
time_cp_step = test_period / 5;

% Time checkpoints
t1 = idle_time + 1*time_cp_step;
t2 = idle_time + 2*time_cp_step;
t3 = idle_time + 3*time_cp_step;
t4 = idle_time + 4*time_cp_step;

% Setpoints
% note: ALWAYS CHECK WITH THE MISSION BOUNDARY
cp1 = pi/4;
cp2 = pi/4;
cp3 = -pi/4;
cp4 = -pi/4;

set_points_roll = {[cp1, t1], [cp2, t2], [cp3, t3], [cp4, t4]};

%% Initialize set points
set_points_x = {[0,0], [0, stop_time]};
set_points_y = {[0,0], [0, stop_time]};
set_points_z = {[0,0], [0, stop_time]};
set_points_phi = {idle_start{:}, set_points_roll{:}, idle_end{:}};
set_points_theta = {[0,0], [0, stop_time]};
set_points_psi = {[0,0], [0, stop_time]};

%% Create reference model
[X_ref, ~] = Reference_Model_CHI(set_points_x,step_value);
[Y_ref, ~] = Reference_Model_CHI(set_points_y,step_value);
[Z_ref, ~] = Reference_Model_CHI(set_points_z,step_value);
[Phi_ref, resampled_time] = Reference_Model_CHI(set_points_phi,step_value);
[Theta_ref, ~] = Reference_Model_CHI(set_points_theta,step_value);
[Psi_ref, ~] = Reference_Model_CHI(set_points_psi,step_value);
end