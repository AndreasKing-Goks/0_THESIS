clear
clc

val_desired = 3.233;
voltage = 16;
mode = 0; % 0: Force to PWM, 1: PWM to Force

result = Convert_Thrust_PWM(val_desired,voltage,mode)