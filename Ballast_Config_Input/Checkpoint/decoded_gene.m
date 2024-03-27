function prompt = Decoded_Gene(gene)
% Ballast Code [dtype=string | 0 means unassigned]:
% -"FS" - Small Floater = 1
% -"FM" - Medium Floater = 2
% -"FL" - Large Floater = 3
% -"WS" - Small Weight = 4
% -"WM" - Medium Weight = 5
% -"WL" - Large Weight  = 6
prompt = cell(size(gene(1,:)));

ballastCode = {'FS' 'FM' 'FL' 'WS' 'WM' 'WL'};
numBallastCode = numel(ballastCode);

for i = 1:length(gene)
    for j = 1:numBallastCode
        if gene(i) == j
            prompt{i} = ballastCode{j};
            break
        else
            prompt{i} = 0;
        end
    end
end
end