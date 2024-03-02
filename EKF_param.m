function [inv_M, B, H, R, Q, dt, inv_Tb, Gamma_o] = EKF_param()
global Param
%% Timestep
dt = 0.1;  %-----To set

%% Bias
% Bias Model
Tb = diag([.1, .1, .1, .1, .1, .1]);    %-----TUNE 
inv_Tb = inv(Tb);

% Bias Noise Model
Eb = diag([1, 1, 1, 1, 1, 1]);          %-----TUNE 
E = [zeros(6,6);
     Eb;
     zeros(6,6)];

Gamma_o = dt*E;

%% Input Model
inv_M = inv(Param.MT);

B =  [zeros(6,6);
      zeros(6,6);
      inv_M];

%% Covariance Matrix
Q = diag([0.1,0.1,pi/180,1e6,1e6,1e9])*10e3;        %-----TUNE
R = diag([0.00001,0.00001,0.00001, ...
    0.01*pi/180,0.01*pi/180,0.01*pi/180])*10e-4;    %-----TUNE

% Q = diag([2e-2 1e-2 1e-2 2e7 2e7 1e9]);
% R = diag([1  1e1 0.5e-2]);

%% Measurement
H = [eye(6), zeros(6,6) zeros(6,6)];

end