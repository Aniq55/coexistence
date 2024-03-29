clc;
clear all;

%% Define Constants

% Environment
alpha = 3.5;      % path-loss coefficient

% Incumbent Users
lambda_z = 1/1e6;
rho = 200;      % radius of the exclusion zone
p_z = 1;        % transmit power [W]

% Cellular Network
lambda_c = 25/1e6;
p_c = 4;        % transmit power [W]
noise_c= 1e-15; % receiver thermal noise
bar_lambda_c = lambda_c*exp(-pi*lambda_z*rho^2);

% WiFi Network
lambda_w = 100/1e6;
rho_w = 50;     % radius of the WiFi PCP disk
p_w = 4;        % transmit power [W]
noise_w= 1e-15; % receiver thermal noise
bar_lambda_w = lambda_w*exp(-pi*lambda_z*rho^2);

% Bandwidths [GHz]
B_cL = 0.040;
B_cU = 0.160;
B_wL = 0.080;
B_wU = 0.160;

% Create parameters object
params = parameters(alpha, rho, rho_w, lambda_z, lambda_c, lambda_w, ...
    bar_lambda_c, bar_lambda_w, p_z, p_c, p_w, noise_c, noise_w, ...
    B_cL, B_cU, B_wL, B_wU);

%% Plot Nash Equilibrium Point(s):
delta_resolution = 0.01;
DELTA_RANGE = [0: delta_resolution: 1];
SINR_threshold = 100;

% 1. Find delta_c_star against delta_w
delta_c_star = zeros(1, length(DELTA_RANGE));
i= 1;
for delta_w = [0: delta_resolution : 1]
    r_c_list = [];
    for delta_c = [0: delta_resolution : 1]
        r_c_list = [r_c_list; datarate_cellular(delta_c, delta_w, SINR_threshold, params)];
    end
    [argvalue, argmax] = max(r_c_list);
    delta_val = DELTA_RANGE(argmax);
    delta_c_star(i) = delta_val;
    i=i+1;
end

% 2. Find delta_w_star against delta_c
delta_w_star = zeros(1, length(DELTA_RANGE));
i = 1;
for delta_c = [0: delta_resolution : 1]
    r_w_list = [];
    for delta_w = [0: delta_resolution : 1]
        r_w_list = [r_w_list; datarate_wifi(delta_c, delta_w, SINR_threshold, params)];
    end
    [argvalue, argmax] = max(r_w_list);
    delta_val = DELTA_RANGE(argmax);
    delta_w_star(i) = delta_val;
    i=i+1;
end

%% Plot

figure(1);
plot(DELTA_RANGE, delta_c_star, '-', 'LineWidth', 1.5);
hold on;
plot(delta_w_star, DELTA_RANGE, '-', 'LineWidth', 1.5);
legend('\delta_c^* vs \delta_w ', '\delta_c vs \delta_w^* ')
xlabel('\delta_w/\delta_w^*')
ylabel('\delta_c^*/\delta_c')

%%
delta_w_test = 0.0;
delta_c_test = 1.0;
datarate_wifi(delta_c_test, delta_w_test, SINR_threshold, params)
datarate_cellular(delta_c_test, delta_w_test, SINR_threshold, params)
