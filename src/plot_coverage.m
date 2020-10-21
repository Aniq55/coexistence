clc
clear all

%% parameters

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
B_cL = 0.080;
B_cU = 0.240;
B_wL = 0.080;
B_wU = 0.240;

% Create parameters object
params = parameters(alpha, rho, rho_w, lambda_z, lambda_c, lambda_w, ...
    bar_lambda_c, bar_lambda_w, p_z, p_c, p_w, noise_c, noise_w, ...
    B_cL, B_cU, B_wL, B_wU);

SINR = 10.^([-5:10]/10);
SINR_dB = [-5:10];

%%
X_wU = [];
X_wL = [];
X_cU = [];
X_cL = [];

p_levels = [-2: 0.1 :2];
p_levels_abs = 2.^(p_levels);
N = length(p_levels);

for p_cell = p_levels_abs
    for p_wifi = p_levels_abs
        params.p_c = p_cell;
        params.p_w = p_wifi;
        
        X = coverage(0.5, 0.5, SINR, params);
        
        X_wL = [X_wL, X(:,1)];
        X_wU = [X_wU, X(:,2)];
        X_cL = [X_cL, X(:,3)];
        X_cU = [X_cU, X(:,4)];
        
    end
end

%%

figure(1);

subplot(2,2,1)
Y_cL = reshape(X_cL(16, :), [N,N]);
surf(p_levels, p_levels, Y_cL)
xlabel('log_2(p_c)')
ylabel('log_2(p_w)')
title('P_{c|L}, SINR = 10 dB')
grid on;
box on;
view(2)
colorbar

subplot(2,2,2)
Y_wL = reshape(X_wL(16, :), [N,N]);
surf(p_levels, p_levels, Y_wL)
xlabel('log_2(p_c)')
ylabel('log_2(p_w)')
title('P_{w|L}, SINR = 10 dB')
grid on;
box on;
view(2)
colorbar


subplot(2,2,3)
Y_cU = reshape(X_cU(16, :), [N,N]);
surf(p_levels, p_levels, Y_cU)
xlabel('log_2(p_c)')
ylabel('log_2(p_w)')
title('P_{c|U}, SINR = 10 dB')
grid on;
box on;
view(2)
colorbar

subplot(2,2,4)
Y_wU = reshape(X_wU(16, :), [N,N]);
surf(p_levels, p_levels, Y_wU)
xlabel('log_2(p_c)')
ylabel('log_2(p_w)')
title('P_{w|U}, SINR = 10 dB')
grid on;
box on;
view(2)
colorbar

%%
Y_wU_max = max(max(Y_wU));
Y_cU_max = max(max(Y_cU));
surf(p_levels, p_levels, 1./(1 + (Y_wU/Y_wU_max - Y_cU/Y_cU_max ).^2 ) )
xlabel('log_2(p_c)')
ylabel('log_2(p_w)')
title('1/( 1 + ( {[P]}_{w|U} - {[P]}_{c|U})^2 )')
grid on;
box on;
colorbar

