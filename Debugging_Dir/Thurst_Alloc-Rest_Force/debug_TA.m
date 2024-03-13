clear
clc
%% BEGIN HERE
T = Thrust_Allocation()
T_ps = pinv(T)

tau = [0; 0; 1; 0; 0; 0];

t = T_ps * tau
tau_cmd = T * t 