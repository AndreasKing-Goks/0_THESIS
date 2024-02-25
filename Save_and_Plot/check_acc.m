%% PLOT
data = load('Result/check_acceleration.mat');
Acc = data.Acc_B_S;
Velo = data.Velo_B_S;
Pos = data.Pos_N_S;
tout = data.tout;

Re = zeros(length(tout),3);
Cd = zeros(length(tout),3);

Velo_T = Velo.Data(:,1:3);

%% Iterate over Velo_T
rho_fluid = 1000;
D = 0.25;
mu_fluid = 1.002e-3;

[n,m] = size(Velo_T);
for col = 1:m
    for row = 1:n
        Rn =  abs(Velo_T(row,col)) * rho_fluid * D / mu_fluid;
        Re(row,col) = Rn;
        Cd(row,col) = sphere_CD(Rn);
    end
end

% %% PLOT
% % Plotting time window in second
% time_pos = ((40) * 100)+1;
% time_velo = ((5) * 100)+1;
% time_acc = ((5) * 100)+1;
% 
% time_Re = ((5) * 100)+1;
% time_Cd = ((3) * 100)+1;
% 
% % Plot Position Evolution
% figure(1)
% %subplot(2,3,1);
% plot(tout(1:time_pos), Pos.Data(1:time_pos,3));               
% ylabel('Water depth (meter)');          
% xlabel('Time (second)');          
% title('Position evolution');
% grid on
% 
% % Plot Velocity Evolution
% figure(2)
% %subplot(2,3,2);
% plot(tout(1:time_velo), Velo.Data(1:time_velo,3));               
% ylabel('Velocity (m/s)');          
% xlabel('Time (second)');          
% title('Velocity evolution');
% grid on
% 
% % Plot Acceleration Evolution
% figure(3)
% %subplot(2,3,3);
% plot(tout(1:time_acc), Acc.Data(1:time_acc,3));               
% ylabel('Acceleration (m/s2)');          
% xlabel('Time (second)');          
% title('Acceleration evolution');
% grid on
% 
% % Plot Reynold Number Evolution
% figure(4)
% %subplot(2,3,4);
% plot(tout(1:time_Re), Re(1:time_Re,3));               
% ylabel('Reynold Number');          
% xlabel('Time (second)');          
% title('Reynold Number evolution');
% grid on
% 
% % Plot Drag Coefficient Evolution
% figure(5)
% %subplot(2,3,5);
% plot(tout(1:time_Cd), Cd(1:time_Cd,3));               
% ylabel('Cd');          
% xlabel('Time (second)');          
% title('Drag Coefficient evolution');
% grid on
% 
% % Plot Sphere Drag Coefficient
% figure(6)
% %subplot(2,3,6);
% 
% Npts = 500;
% Re = logspace(-1,7,Npts);
% Cd_log = zeros(Npts,1);
% i_list = 1:Npts;
% for i = i_list
%     Cd_log(i,1) = sphere_CD(Re(i));
% end
% 
% loglog(Re, Cd_log);
% xlabel('Reynold Number')
% ylabel('Drag Coefficient')
% title('Sphere Drag Coefficient as a Function of Reynold Number')
% grid on

%% PLOT
% Plotting time window in second
time_pos = ((40) * 100)+1;
time_velo = ((5) * 100)+1;
time_acc = ((5) * 100)+1;

time_Re = ((5) * 100)+1;
time_Cd = ((3) * 100)+1;

% Plot Position Evolution
% figure(1)
subplot(2,3,1);
plot(tout(1:time_pos), Pos.Data(1:time_pos,3));               
ylabel('Water depth (meter)');          
xlabel('Time (second)');          
title('Position evolution');
grid on

% Plot Velocity Evolution
% figure(2)
subplot(2,3,2);
plot(tout(1:time_velo), Velo.Data(1:time_velo,3));               
ylabel('Velocity (m/s)');          
xlabel('Time (second)');          
title('Velocity evolution');
grid on

% Plot Acceleration Evolution
% figure(3)
subplot(2,3,3);
plot(tout(1:time_acc), Acc.Data(1:time_acc,3));               
ylabel('Acceleration (m/s2)');          
xlabel('Time (second)');          
title('Acceleration evolution');
grid on

% Plot Reynold Number Evolution
% figure(4)
subplot(2,3,4);
plot(tout(1:time_Re), Re(1:time_Re,3));               
ylabel('Reynold Number');          
xlabel('Time (second)');          
title('Reynold Number evolution');
grid on

% Plot Drag Coefficient Evolution
% figure(5)
subplot(2,3,5);
plot(tout(1:time_Cd), Cd(1:time_Cd,3));               
ylabel('Cd');          
xlabel('Time (second)');          
title('Drag Coefficient evolution');
grid on

% Plot Sphere Drag Coefficient
% figure(6)
subplot(2,3,6);

Npts = 500;
Re = logspace(-1,7,Npts);
Cd_log = zeros(Npts,1);
i_list = 1:Npts;
for i = i_list
    Cd_log(i,1) = sphere_CD(Re(i));
end

loglog(Re, Cd_log);
xlabel('Reynold Number')
ylabel('Drag Coefficient')
title('Sphere Drag Coefficient as a Function of Reynold Number')
grid on

