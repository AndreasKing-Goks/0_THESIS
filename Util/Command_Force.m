function [Input] = Command_Force(F, rF)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Command                                                                 %
%                                                                         %              
% Give force input and location of force in Body Frame                    %
%                                                                         %
% Argument:                                                               %
% F     : Force                                                           %
% rF    : Lever Arm                                                       %
%                                                                         %
% Created:      27.09.2023	Andreas Sitorus                               %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Input_Coord = rF;

M = cross(F,Input_Coord);        % Moment Calculation

Input = [F; M];

end