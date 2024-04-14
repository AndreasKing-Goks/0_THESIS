function [f_amount, w_amount] = Compute_Ballast_Amount(prompt)
%% Floater and Weights Amount
f_amount = 0;
w_amount = 0;

%% Decode string to amount
floater_1 = {'NNF', 'NFN', 'FNN'};
floater_2 = {'NFF', 'FNF', 'FFN'};
floater_3 = {'FFF'};
weight = {'WA'};

% Check for each element in prompt
for i = 1 : numel(prompt)
    if ismember(prompt{i}, floater_1)
        f_amount = f_amount + 1;
    elseif ismember(prompt{i}, floater_2)
        f_amount = f_amount + 2;
    elseif ismember(prompt{i}, floater_3)
        f_amount = f_amount + 3;
    elseif ismember(prompt{i}, weight)
        w_amount = w_amount + 1;
    end
end

end