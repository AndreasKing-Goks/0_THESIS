function [FCrb] = CoriolisRB_ROV_Force(V_t_g)
global Param
% MOI
Ixx = Param.MOI(1);
Iyy = Param.MOI(2);
Izz = Param.MOI(3);

% Get CoG-body velocity
u_cg = V_t_g(1,1);
v_cg = V_t_g(2,1);
w_cg = V_t_g(3,1);
p_cg = V_t_g(4,1);
q_cg = V_t_g(5,1);
r_cg = V_t_g(6,1);

% CC-Rigid Body
% Described in Body frame, at Center of Gravity
Crb11 = zeros(3); 
Crb12 = [0 Param.m*w_cg -Param.m*v_cg;
         -Param.m*w_cg 0 Param.m*u_cg;
         Param.m*v_cg -Param.m*u_cg 0];
Crb21 = Crb12;
Crb22 = [0 -Izz*r_cg -Iyy*q_cg;
         Izz*r_cg 0 Ixx*p_cg;
         Iyy*q_cg -Ixx*p_cg 0];

Crb = [Crb11 Crb12;
       Crb21 Crb22]; % Rigid Body Coriolis Force Matrix, at Center of Gravity
FCrb = (H_(Param.CG.rg_o))' * Crb * V_t_g;
end