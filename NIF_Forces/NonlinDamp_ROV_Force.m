function [FDnl] = NonlinDamp_ROV_Force(NIF_K_nl, V_t_b)
global Param

NL_Damping_Coeff = diag(NIF_K_nl) * abs(V_t_b);
FDnl = -(H_(Param.CB.rb_o))' * diag(NL_Damping_Coeff) * V_t_b;

end