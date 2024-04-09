function [FDl] = LinDamp_ROV_Force(NIF_K_l, V_t_b)
global Param

FDl = -(H_(Param.CB.rb_o))' * diag(NIF_K_l) * V_t_b;

end