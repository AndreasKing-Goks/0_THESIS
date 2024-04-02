function dydt = ODE(t, y, accFunargs, dt)
global Param
%% Extract current state variables (UPDATED BY THE ode4 FUNCTION)
eta_n = y(1:6)';  % Current position in NED frame
nu_b = y(7:end)'; % Current velocity in body frame

%% Unpack additional arguments needed for acceleration
Ballast_Force = Param.NIF_Ballast_Force;        % Updated each NIF Algorithm iteration
Thruster_Force = accFunargs{1};                 % This is still a list
Tether_Force = accFunargs{2};

%% Get the body force
time_index = floor((t/dt) + 1); % To avoid decimal number for indexing
Body_Force = Thruster_Force(time_index, :)';    % Get the used body force using index

%% Calculate body-frame acceleration
nu_dot_b = BlueROV2_acc_NIF(Ballast_Force, Body_Force, Tether_Force, eta_n, nu_b);

%% Get the Jacobian for current orientation
J = Jacobian(eta_n); 

%% Transform body-frame velocity to NED-frame velocity
eta_dot_n = J * nu_b; 

%% Build the derivative vector
dydt = [eta_dot_n; nu_dot_b];  % Concatenate the derivative of position and velocity

end
