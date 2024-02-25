% FOR SAVING RESULTS %% FOR SAVING DATA ONLY
Pos_N_S = out.Pos_N_S;
Velo_B_S = out.Velo_B_S;
Acc_B_S = out.Acc_B_S;
tout = out.tout;
save('Result/check_acceleration.mat', 'Pos_N_S', 'Velo_B_S', 'Acc_B_S', 'tout');

% % Plot time
% tout10 = out.tout;
% save('Result/tout10.mat', 'tout10');