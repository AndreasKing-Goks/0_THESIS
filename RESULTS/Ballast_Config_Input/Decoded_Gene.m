function prompt = Decoded_Gene(gene, num_floater, num_weight)
% Floater Code [dtype=string] - 3 bits system:
% -'NNN' - None None None           - [0 0 0]
% -'NNF' - None None Floater        - [0 0 1]
% -'NFN' - None Floater None        - [0 1 0]
% -'FNN' - Floater None None        - [1 0 0]
% -'NFF' - None Floater Floater     - [0 1 1]
% -'FFN' - Floater Floater None     - [1 1 0]
% -'FNF' - Floater None Floater     - [1 0 1]
% -'FFF' - Floater Floater Floater  - [1 1 1]
% Weight Code [dtype=string] - 1 bit system:
% -'WN' - No Weight = 0
% -'WA' - Weight Available = 1
%% Prompt container 
f_prompt = cell(1, num_floater);
w_prompt = cell(1, num_weight);

%% Ballast tag
w_code = {'WN' 'WA'};

%% Pointer
pointer = 1;

%% Looping process
% Check floater
for i = 1 : num_floater
    f_prompt_s = char(zeros(1,3)); % 3 bits system
    binary = gene(pointer:pointer+2);
    for j = 1 : length(binary)
        if binary(j) == 0
            f_prompt_s(j) = 'N';
        else
            f_prompt_s(j) = 'F';
        end
        f_prompt{i} = f_prompt_s;
    end
    pointer = pointer + 3;
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
