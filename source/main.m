%% -------------------------------------------------------------------
% Norwegian University of Science and Technology
% Evelyn Paiz
% Specialisation in Colour Imaging
% Project:  Translucency Modeling and Analysis
% Instructors: Jon Y. Hardeberg
% Supervisors: Jean-Baptiste Thomas & Ivar Farup
% Description: Main program which models the translucency of milk.
%% -------------------------------------------------------------------
close all; clc; clear all; warning off;
addpath(genpath(pwd));

%% ------------------------------------------------------------------- 
%  Load data and define parameters:
%  -------------------------------------------------------------------
load('data.mat');                           % Name, exposure time and image.
load('weighting_function_hat8.mat')         % Weighting function.

lambda = 20;                                % Smooth factor.
scale = 0.1;                                % Scale factor for the images.
radius = 36.3;                              % Radius of the glass in mm.

%% ------------------------------------------------------------------- 
%  Prepare data:
%  -------------------------------------------------------------------
% Change measured and reference image to the correct scale.
measured = imresize(measured, scale, 'bilinear');
reference = imresize(reference, scale, 'bilinear');

% Prepare pixel values in the correct format.
n = numel(images);
for i = 1:n
    im(:, :, i) = imresize(images{i}, scale, 'bilinear');
    Z(:, i) = reshape(im(:, :, i), size(im(:, :, i),1)*size(im(:, :, i),2), 1);
end

% Prepare exposure times data in the correct logarithmic format.
B = repmat(log(exposures)', size(Z, 1), 1);

% Clear useless variables.
clear i im exposures scale

%% ------------------------------------------------------------------- 
%  Compute the g and lE functions and plot the result:
%  -------------------------------------------------------------------
% Compute using Devebec & Malik's method.
[g, lE] = gsolve(Z, B, lambda, w);
lE = reshape(lE, size(measured, 1) ,size(measured, 2));
lE = lE(floor(size(measured, 1)/2),:);

% Clear useless variables.
clear B Z lambda w images

%% ------------------------------------------------------------------- 
%  Fit Rd:
%  -------------------------------------------------------------------
% Eliminate the scale factor in the data.
Idiffuser = sum(sum(reference));            % Radiance excitance on the surface.
Ldiffuser = mean(mean(reference));          % Intensity of radiance in the diffuser.
[h, w] = size(reference);                   % Width and height of the images.
area1px = (radius.^2)/(w.^2);               % Known area of the sample in 1 pixel.

%E = exp(lE)/(Idiffuser*area1px);            % Remove the scale factor.
E = exp(lE)/255.;

% Range to show of r in mm
range = linspace(0,ceil(radius),size(E,2));

% Clear useless variables.
clear Idiffuser h w area1px

% Prepare data to be fitted.
[xData, yData] = prepareCurveData(range, E);

% Set up fittype and options.
model = fittype('bssrdf(x, sigmaA, sigmaSPrime)');
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
%opts.Display = 'Off';
opts.Lower = [0 0];
%opts.StartPoint = [1 3];

% Fit model to data.
[fitresult, gof] = fit(xData, yData, model, opts);

%% ------------------------------------------------------------------- 
%  Display results:
%  -------------------------------------------------------------------
% Display the g function.
figure('Name', 'g function');
plot(g, 0:length(g)-1, 'lineWidth', 2);
xlabel('log exposure X'), ylabel('pixel value Z');
title(['g function calculated using ' num2str(n) ' images'])

% Display the lE function.
figure('Name', 'lE function');
semilogy(range, E, '*');
xlabel ('r (mm)'), ylabel ('log E')
title(['log E function calculated using ' num2str(n) ' images'])

% Plot fit with data.
figure( 'Name', 'data fitting');
h = plot(fitresult, xData, yData);
legend( h, 'data', 'diffusion theory using fitted parameters', 'Location', 'NorthEast');
% Label axes
xlabel ('r (mm)'), ylabel ('R_d (mm^{-2})')
title(['data fitting'])
grid on

fitresult.sigmaA
fitresult.sigmaSPrime