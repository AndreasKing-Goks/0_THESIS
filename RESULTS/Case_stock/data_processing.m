clear
clc
close all

%% Load Data
data_override = load('override.mat');
data_pitch = load('pitch.mat');
data_rel_alt = load('rel_alt.mat');
data_roll = load('roll.mat');
data_tau_stb = load('tau_stb.mat');

%% Plot
% Override
figure(1)
plot(data_override.override)
ylim([1400 1800])

% Roll
figure(2)
plot(data_roll.roll)
ylim([-0.7854 0.7854])

% Pitch
figure(3)
plot(data_pitch.pitch)
ylim([-0.7854 0.7854])

% Depth
figure(4)
plot(data_rel_alt.rel_alt)
ylim([-1.25 0.1])

% tau_stb
figure(5)
plot(data_tau_stb.tau_stb)
ylim([-100 300])