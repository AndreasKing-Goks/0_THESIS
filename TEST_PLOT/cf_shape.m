% va = -1:0.01:1;
% vm = -1:0.01:1;

[Va, Vm]  = meshgrid(va,vm);

G = 1;

CF = ((Va-Vm).^2)/Vm.^2 * G;

surf(Va, Vm, CF)