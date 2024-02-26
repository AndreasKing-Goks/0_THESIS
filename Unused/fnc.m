function [P_update, states_update,states_hat,error, K]= fnc(y, U, P, states,M,D,inv_M, Aw,Tb,Cw,E,B,H,R,Q,dt, inv_Tb, TAU)
%%%P - 15x15
%states [zeta,eta, b, nu] --15x1
%zeta - 6x1, 
%eta - 3x1, 
%b - 3x1, 
%nu - 3x1
%u - 3x1 force input 

%Aw, Tb, B, E, H
%%%states
zeta = states(1:6,:);
eta = states(7:9,:);
b = states(10:12,:);
nu = states(13:15,:);

u = nu(1,1);
v = nu(2,1);
b_x = b(1,1);
b_y = b(2,1);


%% calculating FXU

Rot_R = [cos(eta(3,1)) -sin(eta(3,1)) 0;
    sin(eta(3,1)) cos(eta(3,1)) 0;
    0 0 1];

Fx = [
Aw*zeta;
Rot_R*nu;
-inv_Tb*b;
% zeros(3,1);
-inv_M*D*nu + inv_M*Rot_R'*b
];

F = zeros(15,1);
F = (B*U);
F = Fx +F;


%%

%predictor
%%phi = PHI(states,ws_var.dt, ws_var);
%calculating phi
A = zeros(15,15);
psi = eta(3,1);

% A(7,9) = -v*cos(psi)-u*sin(psi);
% A(7,13) = cos(psi);
% A(1,15) = 0;
% A(1,4) = 1;
% A(2,5) = 1;
% A(3,6) = 1;
% A(4,1) = -0.0987;
% A(4,4) = -0.0628;
% A(5,2) = -0.0987;
% A(5,5) = -0.0628;
% A(6,3) = -0.0987;
% A(6,6) = -0.0628;
% A(7,14) = -sin(psi);
% 
% A(8,9) = u*cos(psi)-v*sin(psi);
% A(8,13) = sin(psi);
% A(8,14) = cos(psi);
% A(9,15) = 1;
% A(10:12, 10:12) = -10*eye(3);
% A(13,9) = -1.43e-7*(b_y*cos(psi)+b_x*sin(psi));
% A(13,10) = 1.43e-7*cos(psi);
% A(13,11) = -1.43e-7*sin(psi);
% 
% A(14,9) = 1.17e-7*(b_x*cos(psi) - b_y*sin(psi));
% A(14,10) = 1.17e-7*sin(psi);
% A(14,11) = -1.46e-11;
% A(14,12) = 2.63e-10;
% 
% A(15,9) = 1.46e-11*(b_y*sin(psi) - b_x*cos(psi));
% A(15,10) = -1.46e-11*sin(psi);
% A(15,11) = -1.46e-11*cos(psi);
% A(15,12) = 2.63e-10;
% A(13:15,13:15) = -inv_M*D;
% 
A = [Aw zeros(6,9);
    zeros(3,12) Rot_R;
    zeros(3,9) -inv_Tb zeros(3,3);
    zeros(3,6) zeros(3,3) -inv_M*Rot_R' -inv_M*D];

phi = eye(15)+dt*A;
%%

% TAU = dt*E;
P_hat = phi*P*phi' + TAU*Q*TAU';
states_hat = states+dt*F;


%corrector
%kalman gain
K = P_hat*H'/(H*P_hat*H'+R);
% K = zeros(15,3);
P_update = (eye(15)-K*H)*P_hat*(eye(15)-K*H)' + K*R*K';
states_update = states_hat + K*(y-H*states_hat);
error = y - H*states_hat;
end



