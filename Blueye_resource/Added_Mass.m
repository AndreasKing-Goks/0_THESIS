clear all
clc
close all
% -------------Empirical Added Mass estimator for ROV----------------------

%========================================================================
% This program estimates the added mass diagonal terms for an ROV of 
% varying size and shapes. Due to the simplicity program the added mass
% matrix will be assumed to be diagonal.

% In addition will the program only compute Added mass for ROVs where two
% of the sides are somewhat equal, i.e +- 10% difference
%
% The Program will also estimate the cross coupling terms based on
% empirical data from other ROV's. 
%========================================================================


%% Input Values

L=485;                           % Length of ROV [mm]
H=354;                           % Height of ROV [mm]
W=257;                           % Width  of ROV  mm]
rho=1000;                         % Density fluid [kg/m^3]
PF= 56387;                      % Projected Area front [mm^2]
PS= 140366;                      % Projected Area side  [mm^2]
PT= 79561.5;                      % Projected Area top   [mm^2]
A=zeros(6,6);                     % Added mass Matrix

 

%% Empirical  3D data(DNV)------------------------------------------------
EMP3D=[1,0.68;2,0.36;3,0.24;4,0.19;5,0.15;6,0.14;7,0.11];
CA3D=spline(EMP3D(:,1),EMP3D(:,2));
%.........................................................................
%% Empirical 2D-data (DNV)
EMP2D=[10,1.14,0.125;5,1.21,0.15;2,1.36,0.15;1,1.51,0.234;...
       0.5,1.7,0.15;0.2,1.98,0.15;0.1,2.23,0.147];
CA2DT=spline(EMP2D(:,1),EMP2D(:,2));
CA2DR=spline(EMP2D(:,1),EMP2D(:,3));



%.........................................................................

%% Coefficients
H3D=(H+W)/2;                            % Averaged Height( For 3D-est)
W3D=H3D;                                % Averaged Width ( For 3D-est)
CpXY=PT/(L*W);                          % Projected Area Coefficient XY
CpYZ=PF/(H*W);                          % Projected Area Coefficient YZ
CpXZ=PS/(L*H);                          % Projected Area Coefficient XZ
%.........................................................................


%% Surge Direction

%% 3D------------------------------------
B=L/H3D;
Ca=ppval(CA3D,(B));
V=L*H3D^2;
A(1,1)= Ca*V*10^(-9)*rho*(CpYZ)^2*CpXZ*CpXY;

%% 2D------------------------------------
B=W/L;
Ca=ppval(CA2DT,B);
Ar=pi*((W*0.5)^2);
A2D=rho*Ca*Ar*10^(-6)*(CpYZ)^2*CpXZ*CpXY;
At=H*10^(-3)*A2D;
lambda=sqrt(A(1,1)/At);
A(1,1)=At*lambda;
%% Sway and heave
B=L/W;
Ca=ppval(CA2DT,B);
Ar=pi*(L*0.5)^2*10^-6;
A2D=rho*Ca*Ar*CpXZ^2*CpXY*CpYZ;
At=A2D*H*10^-3;
A(2,2)=At*lambda;
A2D=rho*Ca*Ar*CpXY^2*CpXZ*CpYZ;
At=A2D*W*10^-3;
A(3,3)=At*lambda;

%% Roll
B=H/W;
Ca=ppval(CA2DR,B);
if (B<=1)
  A2D=rho*Ca*pi*(W*0.5*10^(-3))^4*CpYZ*CpXY*CpXZ;
else
 A2D=rho*Ca*pi*(H*0.5*10^(-3))^4*CpYZ*CpXY*CpXZ;
end
At=L*A2D*10^-3;
A(4,4)=At*lambda;

%% Pitch
B=L/H;
Ca=ppval(CA2DR,B);
if(B>=1)   
A2D=rho*Ca*pi*(L*0.5*10^(-3))^4*CpYZ*CpXY*CpXZ;
else
A2D=rho*Ca*pi*(H*0.5*10^(-3))^4*CpYZ*CpXY*CpXZ;
end
At=W*10^-3*A2D;
A(5,5)=At*lambda;

%% Yaw
B=W/L;
Ca=ppval(CA2DR,B);
if(B>=1)
    A2D=rho*Ca*pi*(W*0.5*10^(-3))^4*CpYZ*CpXY*CpXZ;
else
    A2D=rho*Ca*pi*(L*0.5*10^(-3))^4*CpYZ*CpXY*CpXZ;
end
At=A2D*H*10^-3;
A(6,6)=At*lambda






