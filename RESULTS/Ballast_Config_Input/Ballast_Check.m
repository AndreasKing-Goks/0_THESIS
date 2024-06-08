clear
clc
%% Ballast_Configuration parameters
% Location Desctription
% F : Front
% A : Aft (Back)
% R : Right
% L : Left
% M : Middle
% I : Inner
% O : Outer

%% Floaters Prompt
% Location : FR    FL    AR    AL    IMR   IML   OMR   OML
% f_prompt = {'FFF' 'FFF' 'FFF' 'FFF' 'FFF' 'FFF' 'FFF' 'FFF'};     % Max Buoyancy
% f_prompt = {'NNN' 'NNN' 'NNN' 'NNN' 'NNN' 'NNN' 'NNN' 'NNN'};     % Max Weights
% f_prompt = {'NNN' 'FFF' 'NNN' 'FFF' 'NNN' 'FFF' 'NNN' 'FFF'};     % Max Roll Moment
f_prompt = {'NNN' 'NNN' 'FFF' 'FFF' 'NNN' 'NNN' 'NNN' 'NNN'};     % Max Pitch Moment

%% Weights Prompt
% Location : FR   FL   OMF  IMF  IMA  OMA  AR   AL
% w_prompt = {'WA' 'WA' 'WA' 'WA' 'WA' 'WA' 'WA' 'WA'};
% w_prompt = {'WN' 'WN' 'WN' 'WN' 'WN' 'WN' 'WN' 'WN'};
% w_prompt = {'WA' 'WN' 'WA' 'WA' 'WA' 'WA' 'WA' 'WN'};
w_prompt = {'WA' 'WA' 'WA' 'WA' 'WN' 'WN' 'WN' 'WN'};
prompt = [f_prompt w_prompt];

%% Other function arguments
max_f = 24;
max_w = 8;
funargs = {max_f max_w};

%% Get the ballast configuration
Ballast_Config = Ballast_Configuration(prompt, funargs);

%% Compute the ballast force
Ballast_Force = Ballast_Compute(Ballast_Config)