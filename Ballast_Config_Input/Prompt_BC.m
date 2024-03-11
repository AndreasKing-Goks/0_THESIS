clear
clc
%% This prompt is used to generate the ballast configuration parameters
% How to use:
% Each element in the cell indicates the hook number.
% Assign the "Ballast Code" to the cell's element to attach the ballast.
% Ballast Code [dtype=string | 0 means unassigned]:
% -"FS" - Small Floater
% -"FM" - Medium Floater
% -"FL" - Large Floater
% -"WS" - Small Weight
% -"WM" - Medium Weight
% -"WL" - Large Weight 

prompt = {0 0 0 'FS' 'FS' 0 0 0 0};

Ballast_Config = Ballast_Configuration(prompt);

g0 = Ballast_Term(Ballast_Config)