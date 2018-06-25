%% -------------------------------------------------------------------
% Norwegian University of Science and Technology
% Evelyn Paiz
% Specialisation in Colour Imaging
% Project:  Translucency Modeling and Analysis
% Instructors: Jon Y. Hardeberg
% Supervisors: Jean-Baptiste Thomas & Ivar Farup
% Description: Program which generates a mat file with the data information.
%% -------------------------------------------------------------------
close all; clc; clear all; warning off;
addpath(genpath(pwd));

%% ------------------------------------------------------------------- 
%  Define parameters:
%  -------------------------------------------------------------------
% Define the directory with the input images.
inputPath = './data/milk/'; 
% Define format of input images.
fileExtension = '.JPG';

% Define the directory with the data.
dataFile = './data/data.xlsx';

% Define the channel to evaluate the images.
channel = 1; % (red channel)

%% ------------------------------------------------------------------- 
%  Get HDR image:
%  -------------------------------------------------------------------
% Get the file names and exposure times.
[exposures, name, ~] = xlsread(dataFile);
files = strcat(inputPath, name, fileExtension);

% Clear useless variables.
clear inputPath fileExtension dataFile name

% Create the HDR image.
hdr = makehdr(files, 'ExposureValues', exposures);

% Selects only the correct channel and express the image by log scale.
% Add 1 to avoid taking log of zero.
hdrRlog = log(hdr(:,:, channel)+1);
% Normalize to the range 0-1.
hdrRlog = mat2gray(hdrRlog);

% Clear useless variables.
clear hdr

%% ------------------------------------------------------------------- 
%  Select area for images:
%  -------------------------------------------------------------------
% Selection of the areas to process the images (crop area).
f = figure;
uiwait(msgbox('Select area to evaluate'));
[~, rect] = imcrop(imshow(hdrRlog, [0, max(max(hdrRlog))]));
close(f); clear f;

% For each file, save the crop image.
for i = 1:numel(files)
    % Grab the file.
    file = files{i};
    % Read the image.
    image = imread(file);
    % Save only the specific channel.
    images{i} = imcrop(image(:, :, channel), rect);
end

% Save measure image and reference image.
measured = imcrop(hdrRlog, rect);
reference = ones(size(measured,1), size(measured, 2)) * 0.97;
% Clear useless variables.
clear i file image channel rect files

%% ------------------------------------------------------------------- 
%  Join and save all data:
%  -------------------------------------------------------------------
save('data.mat');