function [S_S] = SS_(input)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SS_()                                                                   %
%                                                                         %              
% Skew Symmetric Matrix.                                                  %
%                                                                         %
% Argument:                                                               %
% input    : Input vector. Dim(3x1).                                      %      
%                                                                         %
% Created:      27.09.2023	Andreas Sitorus                               %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S_S = [0 -input(3) input(2);
       input(3) 0 -input(1);
       -input(2) input(1) 0;];
end