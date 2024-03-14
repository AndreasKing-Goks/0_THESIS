clear
clc
T = Thrust_Allocation()
lambda = 0.01;
T_dagger = pinv(T' * T + lambda * eye(size(T, 2))) * T'

svd_T = svd(T)
svd_T_dagger = svd(T_dagger)

cond_T = cond(T)
cond_T_dagger = cond(T_dagger)