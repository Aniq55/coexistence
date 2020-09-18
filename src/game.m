clc;
clear all;

%% Define Constants

% Environment
alpha = 3.0;      % path-loss coefficient

% Incumbent Users
lambda_z = 1/1e6;
rho = 100;      % radius of the exclusion zone
p_z = 1;        % transmit power

% Cellular Network
lambda_c = 30/1e6;
p_c = 0.5;        % transmit power
noise_c= 1e-15; % receiver thermal noise
bar_lambda_c = lambda_c*exp(-pi*lambda_z*rho^2);

% WiFi Network
lambda_w = 40/1e6;
rho_w = 20;     % radius of the WiFi PCP disk
p_w = 0.1;        % transmit power
noise_w= 1e-15; % receiver thermal noise
bar_lambda_w = lambda_w*exp(-pi*lambda_z*rho^2);

% Bandwidths
B_cL = 1;
B_cU = 4;
B_wL = 2;
B_wU= 4;


% Create parameters object
params = parameters(alpha, rho, rho_w, lambda_z, lambda_c, lambda_w, ...
    bar_lambda_c, bar_lambda_w, p_z, p_c, p_w, noise_c, noise_w, ...
    B_cL, B_cU, B_wL, B_wU);

%%

rate_c_sample_call = datarate_cellular(0.5, 0.5, 100, params)

rate_w_sample_call = datarate_wifi(0.5, 0.5, 100, params)




%% Plot Nash Equilibrium Point(s):

% 1. Find delta_c_star against delta_w

% 2. Find delta_w_star against delta_c
