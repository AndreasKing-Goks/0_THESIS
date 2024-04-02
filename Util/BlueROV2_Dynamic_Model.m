function [eta_n, nu_b] = BlueROV2_Dynamic_Model(dt, stop_time, accFunargs)
%% Initial conditions
Pos_N = accFunargs{3};
Velo_B = accFunargs{4};
init_conditions = [Pos_N; Velo_B];  % Concatenate position and velocity into one vector

%% Time span for the simulation with fixed time steps
tspan = 0:dt:stop_time;     % Fixed time steps from 0 to stop_time

%% Solve the ODE using a fixed-step Runge-Kutta method
[t, y] = ode4(@(t, y) ODE(t, y, accFunargs, dt), tspan, init_conditions, dt);

%% Extract the position and velocity
eta_n = y(:, 1:6);    % Position in NED frame over time
nu_b = y(:, 7:end);   % Velocity in body frame over time

end
