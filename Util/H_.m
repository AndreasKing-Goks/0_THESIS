function [H] = H_(input)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% H_()                                                                   %
%                                                                         %              
% Transformation Matrix.                                                  %
%                                                                         %
% Argument:                                                               %
% input    : Input vector. Dim(3x1).                                      %      
%                                                                         %
% Created:      27.09.2023	Andreas Sitorus                               %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H = [eye(3) SS_(input)';
     zeros(3) eye(3)];
end