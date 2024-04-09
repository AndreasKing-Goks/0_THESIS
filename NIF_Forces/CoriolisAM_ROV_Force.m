function [FCam] = CoriolisAM_ROV_Force(NIF_AM, V_t_b)
global Param
% Added Mass Coefficient
Xud = NIF_AM(1);
Yvd = NIF_AM(2);
Zwd = NIF_AM(3);
Kpd = NIF_AM(4);
Mqd = NIF_AM(5);
Nrd = NIF_AM(6);

% Get CoB-body velocity
u_cb = V_t_b(1,1);
v_cb = V_t_b(2,1);
w_cb = V_t_b(3,1);
p_cb = V_t_b(4,1);
q_cb = V_t_b(5,1);
r_cb = V_t_b(6,1);

% CC-Added Mass
% Described in Body frame, at Center of Buoyancy
Ca11 = zeros(3);
Ca12 = [0 -Zwd*w_cb Yvd*v_cb;
        Zwd*w_cb 0 -Xud*u_cb;
        -Yvd*v_cb Xud*u_cb 0];
Ca21 = Ca12;
Ca22 = [0 -Nrd*r_cb Mqd*q_cb;
        Nrd*r_cb 0 -Kpd*p_cb;
        -Mqd*q_cb Kpd*p_cb 0];

Ca = [Ca11 Ca12;
      Ca21 Ca22]; % Added mass Coriolis Force Matrix, at Center of Buoyancy
FCam = (H_(Param.CB.rb_o))' * Ca * V_t_b;
end