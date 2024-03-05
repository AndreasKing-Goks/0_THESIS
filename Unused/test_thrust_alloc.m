clear
clc

% input
tau_x = 0;
tau_y = 0;
tau_z = 0;
tau_phi = 0;
tau_theta = 0;
tau_psi = 0;

tau_cmd = [tau_x, tau_y, tau_z, tau_phi, tau_theta, tau_psi]';

%% Horizontal Thruster
% x(+) front, y(+) right, z(+) down, angle(+) CW

% Thruster 1 (Front Right)
lx1 = 156/1000;             % m
ly1 = 111/1000;             % m
lz1 = 85/1000;              % m
angle1 = -pi/4;             % rad
Fx1 = cos(angle1);          % N
Fy1 = sin(angle1);          % N
Fz1 = 0;                    % N
Mr1 = Fz1*ly1 - Fy1*lz1;    % Nm
Mp1 = Fx1*lz1 - Fz1*lx1;    % Nm
My1 = Fy1*lx1 - Fx1*ly1;    % Nm
T1 = [Fx1; Fy1; Fz1; Mr1; Mp1; My1];

% Thruster 2 (Front Left)
lx2 = 156/1000;             % m
ly2 = -111/1000;            % m
lz2 = 85/1000;              % m
angle2 = pi/4;              % rad
Fx2 = cos(angle2);          % N
Fy2 = sin(angle2);          % N
Fz2 = 0;                    % N
Mr2 = Fz2*ly2 - Fy2*lz2;    % Nm
Mp2 = Fx2*lz2 - Fz2*lx2;    % Nm
My2 = Fy2*lx2 - Fx2*ly2;    % Nm
T2 = [Fx2; Fy2; Fz2; Mr2; Mp2; My2];

% Thruster 3 (Aft Right)
lx3 = -156/1000;            % m
ly3 = 111/1000;             % m
lz3 = 85/1000;              % m
angle3 = angle2 + pi;       % rad
Fx3 = cos(angle3);          % N
Fy3 = sin(angle3);          % N
Fz3 = 0;                    % N
Mr3 = Fz3*ly3 - Fy3*lz3;    % Nm
Mp3 = Fx3*lz3 - Fz3*lx3;    % Nm
My3 = Fy3*lx3 - Fx3*ly3;    % Nm
T3 = [Fx3; Fy3; Fz3; Mr3; Mp3; My3];

% Thruster 4 (Aft Left)
lx4 = -156/1000;            % m
ly4 = -111/1000;            % m
lz4 = 85/1000;              % m
angle4 = angle1 +pi;        % rad
Fx4 = cos(angle4);          % N
Fy4 = sin(angle4);          % N
Fz4 = 0;                    % N
Mr4 = Fz4*ly4 - Fy4*lz4;    % Nm
Mp4 = Fx4*lz4 - Fz4*lx4;    % Nm
My4 = Fy4*lx4 - Fx4*ly4;    % Nm
T4 = [Fx4; Fy4; Fz4; Mr4; Mp4; My4];

%% Vertical Thruster
% x(+) front, y(+) right, z(+) down, angle(+) Down

% Thruster 5 (Front Right)
lx5 = 120/1000;             % m
ly5 = 218/1000;             % m
lz5 = 0;                    % m
angle5 = pi;                % rad
Fx5 = 0;                    % N
Fy5 = 0;                    % N
Fz5 = cos(angle5);          % N
Mr5 = Fz5*ly5 - Fy5*lz5;    % Nm
Mp5 = Fx5*lz5 - Fz5*lx5;    % Nm
My5 = Fy5*lx5 - Fx5*ly5;    % Nm
T5 = [Fx5; Fy5; Fz5; Mr5; Mp5; My5];

% Thruster 6 (Front Left)
lx6 = 120/1000;             % m
ly6 = -218/1000;            % m
lz6 = 0;                    % m
angle6 = 0;                 % rad
Fx6 = 0;                    % N
Fy6 = 0;                    % N
Fz6 = cos(angle6);          % N
Mr6 = Fz6*ly6 - Fy6*lz6;    % Nm
Mp6 = Fx6*lz6 - Fz6*lx6;    % Nm
My6 = Fy6*lx6 - Fx6*ly6;    % Nm
T6 = [Fx6; Fy6; Fz6; Mr6; Mp6; My6];

% Thruster 7 (Aft Right)
lx7 = -120/1000;            % m
ly7 = 218/1000;             % m
lz7 = 0;                    % m
angle7 = 0;                 % rad
Fx7 = 0;                    % N
Fy7 = 0;                    % N
Fz7 = cos(angle7);          % N
Mr7 = Fz7*ly7 - Fy7*lz7;    % Nm
Mp7 = Fx7*lz7 - Fz7*lx7;    % Nm
My7 = Fy7*lx7 - Fx7*ly7;    % Nm
T7 = [Fx7; Fy7; Fz7; Mr7; Mp7; My7];

% Thruster 8 (Aft Left)
lx8 = -120/1000;            % m
ly8 = -218/1000;            % m
lz8 = 0;                    % m
angle8 = pi;                % rad
Fx8 = 0;                    % N
Fy8 = 0;                    % N
Fz8 = cos(angle8);          % N
Mr8 = Fz8*ly8 - Fy8*lz8;    % Nm
Mp8 = Fx8*lz8 - Fz8*lx8;    % Nm
My8 = Fy8*lx8 - Fx8*ly8;    % Nm
T8 = [Fx8; Fy8; Fz8; Mr8; Mp8; My8];

%% Thrust Allocation Matrix
T = [T1 T2 T3 T4 T5 T6 T7 T8];

%% Moore Penrose Pseudoinverse
T_trp = pinv(T)

%% Result
T_cmd = T_trp * tau_cmd
