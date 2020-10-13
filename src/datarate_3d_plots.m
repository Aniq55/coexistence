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
lambda_c = 50/1e6;
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
B_cL = 0.080;
B_cU = 0.320;
B_wL = 0.080;
B_wU = 0.320;

% Create parameters object
params = parameters(alpha, rho, rho_w, lambda_z, lambda_c, lambda_w, ...
    bar_lambda_c, bar_lambda_w, p_z, p_c, p_w, noise_c, noise_w, ...
    B_cL, B_cU, B_wL, B_wU);

SINR_threshold = 100;

%%

delta_resolution = 0.1;
DELTA_RANGE = [0: delta_resolution: 1];


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

scale_constant = 1e5;
% 
% figure(1);
opt_fn = (datarate_cell_all.*datarate_wifi_all).*(datarate_cell_all + datarate_wifi_all)./(1 + scale_constant*(datarate_cell_all - datarate_wifi_all).^2);
% surf(DELTA_RANGE, DELTA_RANGE, opt_fn);
% xlabel('\delta_w')
% ylabel('\delta_c')

marker_list= ["x-", "o-", "+-", "s-", "v-", ...
    "^-", "*-", "x--", "o--", "+--", "v--" ];

figure(2);
hold on;
for i = [1:11]
    plot(DELTA_RANGE, opt_fn(:,i), marker_list(i))
end
legend(string(DELTA_RANGE))
xlabel("\delta_c")
box on;
grid on;

%%

Dc = 0.0;
Dw = 0.8;

[ datarate_cellular(Dc, Dw, SINR_threshold, params), ...
    datarate_wifi(Dc, Dw, SINR_threshold, params)]

%%
% figure(1);
% subplot(1,2,1);
% surf(DELTA_RANGE, DELTA_RANGE, datarate_cell_all);
% xlabel('\delta_w')
% ylabel('\delta_c')
% zlabel('r_c [Gbps]')
% 
% subplot(1,2,2);
% surf(DELTA_RANGE, DELTA_RANGE, datarate_wifi_all);
% xlabel('\delta_w')
% ylabel('\delta_c')
% zlabel('r_w [Gbps]')
% 
% %%
% figure(2);
% subplot(1,2,1);
% surf(DELTA_RANGE, DELTA_RANGE, datarate_wifi_all - datarate_cell_all);
% xlabel('\delta_w')
% ylabel('\delta_c')
% zlabel('r_w - r_c [Gbps]')
% 
% subplot(1,2,2);
% surf(DELTA_RANGE, DELTA_RANGE, sqrt(datarate_wifi_all*datarate_cell_all) );
% xlabel('\delta_w')
% ylabel('\delta_c')
% zlabel('\surd{ ( r_w r_c ) } [Gbps]')
