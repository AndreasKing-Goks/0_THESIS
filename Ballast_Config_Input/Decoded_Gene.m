function prompt = Decoded_Gene(gene, num_floater, num_weight)
% Floater Code [dtype=string] - 2 bits system:
% -"FN" - No Floater = 0 0
% -"FS" - Small Floater = 0 1
% -"FM" - Medium Floater = 1 0
% -"FL" - Large Floater = 1 1
% Weight Code [dtype=string] - 1 bit system:
% -"WN" - No Weight = 0
% -"WA" - Weight Available = 1
%% Prompt container 
f_prompt = cell(1, num_floater);
w_prompt = cell(1, num_weight);

%% Ballast tag
f_binary = {[0 0] [0 1] [1 0] [1 1]};
f_code = {'FN' 'FS' 'FM' 'FL'};

w_code = {'WN' 'WA'};

%% Pointer
pointer = 1;

%% Looping process
% Check floater
for i = 1 : num_floater
    for j = 1 : numel(f_code)
        if isequal(gene(pointer:pointer+1), f_binary{j})
            f_prompt{i} = f_code{j};
        end
    end
    pointer = pointer + 2;
end

% Check weight
for k = 1 : num_weight
    if gene(pointer) == 0
        w_prompt{k} = w_code{1};
    else
        w_prompt{k} = w_code{2};
    end
    pointer = pointer + 1;
end

%% Prompt
prompt = [f_prompt w_prompt];
end