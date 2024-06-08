function Ballast_Term = Ballast_Compute(Ballast_Config)
%% Create storage for the ballast term
g0 = zeros(6,1);

%% Compute the ballast term
for i = 1:numel(Ballast_Config)
    % Check if Ballast_Config{i} is a non-empty cell and if its content is not equal to 0
    % if iscell(Ballast_Config{i}) && ~isempty(Ballast_Config{i}) && Ballast_Config{i}{1} ~= 0
    if ~isempty(Ballast_Config{i})
        % Unpack
        x = Ballast_Config{i}{1}{1};
        y = Ballast_Config{i}{2}{1};
        z = Ballast_Config{i}{3}{1};
        F = Ballast_Config{i}{4};

        % Compute
        Z_Ballast = -(F);
        K_Ballast = -(y * F);
        M_Ballast = (x * F);

        % Store
        g0(3) = g0(3) + Z_Ballast;
        g0(4) = g0(4) + K_Ballast;
        g0(5) = g0(5) + M_Ballast;
    else
        % Skip if Ballast_Config{i} is empty or its content is 0
        continue;
    end
end
%% Ballast Term
Ballast_Term = -g0;
end