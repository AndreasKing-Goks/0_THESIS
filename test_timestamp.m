global Param
% Assuming yourArray is your n by 1 array
isCorrect = all((1:length(Param.time_stamps))' == Param.time_stamps);
disp(isCorrect);