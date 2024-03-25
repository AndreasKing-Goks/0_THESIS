function Param_B = Ballast_Param()
global Param_B
%% Ballast hook configuration (Base block)
% Hook front right (1)
x_ffr = [0.1415 0.0989 0.0563];
y_ffr = [0.1925 0.1925 0.1925];
z_ffr = [-0.1590 -0.1590 -0.1590];

% Hook front left (2)
x_ffl = [0.1415 0.0989 0.0563];
y_ffl = [-0.1925 -0.1925 -0.1925];
z_ffl = [-0.1590 -0.1590 -0.1590];

% Hook  aft right (3)
x_far = [-0.0378 -0.0804 -0.1230];
y_far = [0.1925 0.1925 0.1925];
z_far = [-0.1590 -0.1590 -0.1590];

% Hook  aft left (4)
x_fal = [-0.0378 -0.0804 -0.1230];
y_fal = [-0.1925 -0.1925 -0.1925];
z_fal = [-0.1590 -0.1590 -0.1590];

% Hook inner mid right (5)
x_fimr = [0.0093 0.0093 0.0093];
y_fimr = [0.1360 0.1360 0.1360];
z_fimr = [0.0584 0.0158 -0.0268];

% Hook inner mid left (6)
x_fiml = [0.0093 0.0093 0.0093];
y_fiml = [-0.1360 -0.1360 -0.1360];
z_fiml = [0.0584 0.0158 -0.0268];

% Hook outer mid right (7)
x_fomr = [0.0093 0.0093 0.0093];
y_fomr = [0.1925 0.1925 0.1925];
z_fomr = [0.0584 0.0158 -0.0268];

% Hook outer mid left (7)
x_foml = [0.0093 0.0093 0.0093];
y_foml = [-0.1925 -0.1925 -0.1925];
z_foml = [0.0584 0.0158 -0.0268];

% Hook position for all floaters
x_f = [x_ffr x_ffl x_far x_fal x_fimr x_fiml x_fomr x_foml];
y_f = [y_ffr y_ffl y_far y_fal y_fimr y_fiml y_fomr y_foml];
z_f = [z_ffr z_ffl z_far z_fal z_fimr z_fiml z_fomr z_foml];

%% Hook center for combinatory floaters
% Code string
f_code_list = {'NNF' 'NFN' 'FNN' 'NFF' 'FFN' 'FNF' 'FFF'};

% Anonymous function
calculate_center = @(vec, f_code) mean(vec(f_code == 'F'));

% Floater center matrix for all hooks (8 hooks)
Center_f = cell(1,8); 

% Compute the center of x, y, and z for each combinations in each hook
% For each hook
for i = 1 : numel(Center_f)
    Center_f_x = cell(numel(f_code_list),1);
    Center_f_y = cell(numel(f_code_list),1);
    Center_f_z = cell(numel(f_code_list),1);
    for k = 1: numel(f_code_list)
        % Check boundary for computing the center
        lb = 3*(i-1) + 1;
        ub = lb + 2;
            
        % Get the positional vecotr for each hook
        vec_x = x_f(lb:ub);
        vec_y = y_f(lb:ub);
        vec_z = z_f(lb:ub);
            
        % For x
        Center_f_x{k} = calculate_center(vec_x, f_code_list{k});

        % For y
        Center_f_y{k} = calculate_center(vec_y, f_code_list{k});

        % For z
        Center_f_z{k} = calculate_center(vec_z, f_code_list{k});
    end
    Center_f{i} = {Center_f_x, Center_f_y, Center_f_z};
end

% Store in ballast parameter
Param_B.Center_f = Center_f;

%% Hook position for all weights
% Weights positional data
w_X = [0.0993 0.0993 0.0968 0.0468 -0.0282 -0.0782 -0.0861 -0.0861];
w_Y = [0.0638 -0.0638 0.0 0.0 0.0 0.0 0.0638 -0.0638];
w_Z = [-0.1753 -0.1753 -0.1753 -0.1753 -0.1753 -0.1753 -0.1753 -0.1753];

% Weight center matrix for all hooks (8 hooks)
Center_w = cell(1,length(w_X)); 

% Do looping process
for a = 1 : numel(Center_w)
    % For x
    Center_w_x = w_X(a);

    % For y
    Center_w_y = w_Y(a);

    % For z
    Center_w_z = w_Z(a);
    
    % Store all data
    Center_w{a} = {Center_w_x, Center_w_y, Center_w_z};
end

% Store in ballast parameter
Param_B.Center_w = Center_w;

%% Number of hooks
Param_B.num_hook_floater = numel(Center_f);
Param_B.num_hook_weight = numel(Center_w);

%% Ballast
% Gravitational acceleration
g = 9.81;                                   % m.s-2

% Floaters (Cube 4 cm)
rho_f = 192;                                % kg.m-3
rho_w = 1000;                               % kg.m-3

Volume = 0.04^3;                            % m2

Param_B.Ff = (rho_f - rho_w) * Volume * g; % N

% Weights
w_mass = 0.2;                               % kg
Param_B.Fw = w_mass * g;                    % N
end