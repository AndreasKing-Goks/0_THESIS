function [eta_n, nu_b, nu_dot_b, nu_dot_b_red] = BlueROV2_Dynamic_Model(dt, stop_time, accFunargs)
global Param
%% Initial conditions
Thruster_Force = accFunargs{1};
Pos_N = accFunargs{3};
Velo_B = accFunargs{4};
init_conditions = [Pos_N; Velo_B];  % Concatenate position and velocity into one vector

%% Time span for the simulation with fixed time steps
tspan = 0:dt:stop_time;     % Fixed time steps from 0 to stop_time

% %% Solve the ODE using a fixed-step Runge-Kutta method
% % [t, y] = ode4(@(t, y) ODE(t, y, accFunargs, dt), tspan, init_conditions, dt);
% [t, y, z] = ode4_thrust(@(t, y) ODE(t, y, accFunargs, dt), tspan, init_conditions, dt);
% 
% %% Extract the position and velocity
% eta_n = y(:, 1:6);    % Position in NED frame over time
% nu_b = y(:, 7:end);   % Velocity in body frame over time
% nu_dot_b = z;

%% SIMPLE INTEGRATION = COMMENT FROM BELOW
% Initialize the states
eta_n = zeros(length(tspan), 6);    % Initialize position in NED frame over time
nu_b = zeros(length(tspan), 6);     % Initialize velocity in body frame over time
nu_dot_b = zeros(length(tspan), 6);
nu_dot_b_red = zeros(length(tspan), 6);

eta_n(1, :) = Pos_N';               % Set initial position
nu_b(1, :) = Velo_B';               % Set initial velocity

% STORE EACH FORCE
Param.NIF_Fr = zeros(length(tspan), 6);
Param.NIF_Fcrb = zeros(length(tspan), 6);
Param.NIF_Fca = zeros(length(tspan), 6);
Param.NIF_Fld = zeros(length(tspan), 6);
Param.NIF_Fnld = zeros(length(tspan), 6);
Param.NIF_Ft = zeros(length(tspan), 6);
Param.Comp_F = zeros(length(tspan), 6);

% Simple integration loop using Euler's method
for i = 1:length(tspan) 
    % Get the Body_Force
    Body_Force = Thruster_Force(i,:)';
    % Body_Force = zeros(6,1);

    % Calculate derivatives for current state
    dydt = ODE(tspan(i), [eta_n(i, :), nu_b(i, :)], accFunargs, dt, Body_Force);

    % Store body force
    Param.Comp_F(i,:) = Body_Force;
    
    % Get acc reduction
    nu_dot_b_red(i,:) = dydt(1:6);

    % Get acceleration
    nu_dot_b(i,:) = dydt(7:end);

    % Get force
    Param.NIF_Fr(i, :) = Param.NIF_Fr_o';
    Param.NIF_Fcrb(i, :) = Param.NIF_Crb_o';
    Param.NIF_Fca(i, :) = Param.NIF_Ca_o';
    Param.NIF_Fld(i, :) = Param.NIF_Fld_o';
    Param.NIF_Fnld(i, :) = Param.NIF_Fnld_o';
    Param.NIF_Ft(i, :) = Param.NIF_Ft_o';

    % Update states
    eta_n(i+1, :) = eta_n(i, :) + dydt(1:6).' * dt;  % Note the transpose operator '.'
    nu_b(i+1, :) = nu_b(i, :) + dydt(7:12).' * dt;  % Note the transpose operator '.'
end

end
