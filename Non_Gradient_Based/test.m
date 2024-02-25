clear
clc

X = [-1.2, 1.0];

EVAL = nelder_mead(@RF, X, 100, 1);
res = RF(X);