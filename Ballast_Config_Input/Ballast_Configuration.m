function [Ballast_Config, Hook_Encoding] = Ballast_Configuration(prompt)
%% Ballast hook configuration
% Hook location [x y z]
% Top
Hook_1 = [.2 0 .229];
Hook_2 = [.125 0 .229];
Hook_3 = [-.2 0 .229];

% Thruster
Hook_4 = [0 .65 0];     % Right
Hook_5 = [0 -.65 0];    % Left

% Bottom
Hook_6 = [.171 0 -.229];
Hook_7 = [.057 0 -.229];
Hook_8 = [-.057 0 -.229];
Hook_9 = [-.171 0 -.229];

Hook_Pos = {Hook_1, Hook_2, Hook_3, Hook_4, Hook_5, Hook_6, Hook_7, Hook_8, Hook_9};

% Binary encoding for all 9 available hooks
% If used = 1
% If unused = 0
Hook_Encoding = zeros(1,numel(Hook_Pos));

%% Ballast
% Type
foam = 35;      % kg/m3
s_steel = 7700; % kg/m3

% Dimension
cross_sec = .25^2;
S_size = .05;
M_size = .1;
L_size = .15;

% Volume
S_Vol = cross_sec * S_size;
M_Vol = cross_sec * M_size;
L_Vol = cross_sec * L_size;

% Mass
Floater_S = S_Vol * foam;   % kg
Floater_M = M_Vol * foam;   % kg
Floater_L = L_Vol * foam;   % kg

Weight_S = S_Vol * s_steel;   % kg
Weight_M = M_Vol * s_steel;   % kg
Weight_L = L_Vol * s_steel;   % kg

% Available ballast amount
N_Floater_S = 12;
N_Floater_M = 12;
N_Floater_L = 12;

N_Weight_S = 2;
N_Weight_M = 2;
N_Weight_L = 2;

%% Ballast Selection Algorithm
% Create the container
Ballast_Config = cell(1,9);

% Check prompt
for i = 1:numel(prompt)
    % If hook is unassigned, skip it
    if prompt{i} == 0
        continue
    end
    error = 0;

    % Sort the strings
    ballast = cell(1,4);
    if strcmp(prompt{i}, 'FS')
        if N_Floater_S ~= 0
            ballast{1} = Hook_Pos(i);
            ballast{2} = Floater_S;
            ballast{3} = S_Vol;
            ballast{4} = foam;
            N_Floater_S = N_Floater_S - 1;
        else
            disp('The used number of Small Floater is maxed out.');
            error = 1;
        end
    elseif strcmp(prompt{i}, 'FM')
        if N_Floater_M ~= 0
            ballast{1} = Hook_Pos(i);
            ballast{2} = Floater_M;
            ballast{3} = M_Vol;
            ballast{4} = foam;
            N_Floater_M = N_Floater_M - 1;
        else
            disp('The used number of Medium Floater is maxed out.');
            error = 1;
        end
    elseif strcmp(prompt{i}, 'FL')
        if N_Floater_L ~= 0
            ballast{1} = Hook_Pos(i);
            ballast{2} = Floater_L;
            ballast{3} = L_Vol;
            ballast{4} = foam;
            N_Floater_L = N_Floater_L - 1;
        else
            disp('The used number of Large Floater is maxed out.');
            error = 1;
        end
    elseif strcmp(prompt{i}, 'WS')
        if N_Weight_S ~= 0
            ballast{1} = Hook_Pos(i);
            ballast{2} = Weight_S;
            ballast{3} = S_Vol;
            ballast{4} = -s_steel;
            N_Weight_S = N_Weight_S - 1;
        else
            disp('The used number of Small Weight is maxed out.');
            error = 1;
        end
    elseif strcmp(prompt{i}, 'WM')
        if N_Weight_M ~= 0
            ballast{1} = Hook_Pos(i);
            ballast{2} = Weight_M;
            ballast{3} = M_Vol;
            ballast{4} = -s_steel;
            N_Weight_M = N_Weight_M - 1;
        else
            disp('The used number of Medium Weight is maxed out.');
            error = 1;
        end
    elseif strcmp(prompt{i}, 'WL')
        if N_Weight_L ~= 0
            ballast{1} = Hook_Pos(i);
            ballast{2} = Weight_L;
            ballast{3} = L_Vol;
            ballast{4} = -s_steel;
            N_Weight_L = N_Weight_L - 1;
        else
            disp('The used number of Large Weight is maxed out.');
            error = 1;
        end
    end
    % Add ballast info to the configuration list
    Hook_Encoding(1) = 1;
    Ballast_Config{i} = ballast;

    if error == 1
        Ballast_Config = cell(1,9);
        disp('[ABORT OPERATION]');
        break
    end
end
end