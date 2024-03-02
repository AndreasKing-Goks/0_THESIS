% Define the range for X and Y
x_values = -5:0.5:5;
y_values = -5:0.5:5;

% Create a grid for X and Y
[X, Y] = meshgrid(x_values, y_values);

% Define Z as a function of X and Y
Z = sin(sqrt(X.^2 + Y.^2));

% Create the surface plot
surf(X, Y, Z);

% Add labels and title
xlabel('X Axis');
ylabel('Y Axis');
zlabel('Z Axis');
title('3D Surface Plot: Z = sin(sqrt(X^2 + Y^2))');
