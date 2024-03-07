clear
clc

prompt = {0 0 0 'FS' 'FS' 0 0 0 0};

[Ballast_Config, Hook_Encoding] = Ballast_Configuration(prompt);

%Ballast_Force = zeros(6,1);
Ballast_Force = Ballast_Term(Ballast_Config);

%% Tether Force
Tether_Force = zeros(6,1);

% Pos_N = [0	0	-0.00229287741142560	0	0	0]';
% Velo_B = [-8.81451573754438e-22	-1.63588108536907e-05	-0.0440316242089105	-0.00146585973660880	5.16588597584734e-20	5.85332460928104e-20]';

Pos_N = [0	0	-0.00229287741142560	0	0	0]';
Velo_B = [0 -0.0000 0.0440 -0.0015 0 0]';

Thruster_Force = [0 0 0 0.0066 0 0]';

%% Sphere Dynamic Model [FOR CHECKING]
Acc_G = BlueROV2_acc(Ballast_Force, Thruster_Force, Tether_Force, Pos_N, Velo_B)
