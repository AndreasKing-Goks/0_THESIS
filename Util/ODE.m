function dydt = ODE(t, y, accFunargs)
%% Extract current state variables
disp('yes')
eta_n = y(1:6)';  % Current position in NED frame
nu_b = y(7:end)'; % Current velocity in body frame

%% Unpack additional arguments needed for acceleration
Ballast_Force = accFunargs{1};
Thruster_Force = accFunargs{2};
Tether_Force = accFunargs{3};

%% Calculate body-frame acceleration
nu_dot_b = BlueROV2_acc_NIF(Ballast_Force, Thruster_Force, Tether_Force, eta_n, nu_b);

%% Get the Jacobian for current orientation
J = Jacobian(eta_n); 

%% Transform body-frame velocity to NED-frame velocity
eta_dot_n = J * nu_b; 

%% Build the derivative vector
dydt = [eta_dot_n; nu_dot_b];  % Concatenate the derivative of position and velocity

end
