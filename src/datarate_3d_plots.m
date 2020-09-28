clc;
clear all;

%% Define Constants

% Environment
alpha = 3.5;      % path-loss coefficient

% Incumbent Users
lambda_z = 1/1e6;
rho = 100;      % radius of the exclusion zone
p_z =6.3;        % transmit power [W]

% Cellular Network
lambda_c = 50/1e6;
p_c = 5;        % transmit power [W]
noise_c= 1e-15; % receiver thermal noise
bar_lambda_c = lambda_c*exp(-pi*lambda_z*rho^2);

% WiFi Network
lambda_w = 200/1e6;
rho_w = 25;     % radius of the WiFi PCP disk
p_w = 1;        % transmit power [W]
noise_w= 1e-15; % receiver thermal noise
bar_lambda_w = lambda_w*exp(-pi*lambda_z*rho^2);

% Bandwidths [GHz]
B_cL = 0.080;
B_cU = 0.160;
B_wL = 0.080;
B_wU = 0.160;


% Create parameters object
params = parameters(alpha, rho, rho_w, lambda_z, lambda_c, lambda_w, ...
    bar_lambda_c, bar_lambda_w, p_z, p_c, p_w, noise_c, noise_w, ...
    B_cL, B_cU, B_wL, B_wU);

%%

delta_resolution = 0.1;
DELTA_RANGE = [0: delta_resolution: 1];
SINR_threshold = 100;

N = length(DELTA_RANGE);

datarate_cell_all = zeros(N, N);
datarate_wifi_all = zeros(N, N);

for i= 1:N
    for j = 1:N
        delta_c = DELTA_RANGE(i);
        delta_w = DELTA_RANGE(j);
        
        datarate_cell_all(i,j) = datarate_cellular(delta_c, delta_w, SINR_threshold, params);
        datarate_wifi_all(i,j) = datarate_wifi(delta_c, delta_w, SINR_threshold, params);
       
    end
end

%%
figure(1);
subplot(1,2,1);
surf(DELTA_RANGE, DELTA_RANGE, datarate_cell_all);
xlabel('\delta_w')
ylabel('\delta_c')
zlabel('r_c [Gbps]')

subplot(1,2,2);
surf(DELTA_RANGE, DELTA_RANGE, datarate_wifi_all);
xlabel('\delta_w')
ylabel('\delta_c')
zlabel('r_w [Gbps]')

%%
figure(1);
subplot(1,2,1);
surf(DELTA_RANGE, DELTA_RANGE, datarate_wifi_all - datarate_cell_all);
xlabel('\delta_w')
ylabel('\delta_c')
zlabel('r_w - r_c [Gbps]')

subplot(1,2,2);
surf(DELTA_RANGE, DELTA_RANGE, sqrt(datarate_wifi_all*datarate_cell_all) );
xlabel('\delta_w')
ylabel('\delta_c')
zlabel('\surd{ ( r_w r_c ) } [Gbps]')
