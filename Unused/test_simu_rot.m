clear
clc

phi = 0;
theta = 0;
psi = 0;

% For 3 DOFs
rot = [cos(psi)*cos(theta) -sin(psi)*cos(phi)+cos(psi)*sin(theta)*sin(phi) sin(psi)*sin(phi)+cos(psi)*cos(phi)*sin(theta);
       sin(psi)*cos(theta) cos(psi)*cos(phi)+sin(phi)*sin(theta)*sin(psi) -cos(psi)*sin(phi)+sin(theta)*sin(psi)*cos(phi);
       -sin(theta) cos(theta)*sin(phi) cos(theta)*cos(phi)];

% For 6 DOFs
rot_tot = [rot zeros(3,3);
           zeros(3,3) eye(3)]

% Transpose
rot_T = rot_tot'