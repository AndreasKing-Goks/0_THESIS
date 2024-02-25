clear
clc
%% Add Path
% Current dir
currentDir = fileparts(mfilename('fullpath'));

% Add the 'T200_Data' path
T200_Data_Path = fullfile(currentDir, 'T200_Data');
addpath(T200_Data_Path);

%% Extract Data
% Define the voltage levels
voltages = [10, 12, 14, 16, 18, 20];

% Initialize a structure to store the data
thruster_data = struct();

% Load data from each CSV file and store it in the structure
for i = 1:length(voltages)
    % Construct the filename for the CSV file
    filename = sprintf('%dV.csv', voltages(i));

    % Load data from CSV file, skipping the header row
    opts = detectImportOptions(filename);
    opts.DataLines = [2, Inf];  % Skip the first row
    data_table = readtable(filename, opts);

    % Extract numeric data from the table
    data = table2array(data_table);

    % Store the header and data in the structure
    fieldname = sprintf('voltage_%d', voltages(i));
    thruster_data.(fieldname).header = data_table.Properties.VariableNames;
    thruster_data.(fieldname).data = data;
end

% Specify the directory to save the .mat file
save_dir = T200_Data_Path;

% Create the directory if it doesn't exist
if ~exist(save_dir, 'dir')
    mkdir(save_dir);
end

% Save the structure as a .mat file in the specified directory
save(fullfile(save_dir, 'thruster_data.mat'), 'thruster_data');