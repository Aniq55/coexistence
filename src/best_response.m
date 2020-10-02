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
B_cL = 0.100;
B_cU = 0.240;
B_wL = 0.160;
B_wU = 0.240;

% Create parameters object
params = parameters(alpha, rho, rho_w, lambda_z, lambda_c, lambda_w, ...
    bar_lambda_c, bar_lambda_w, p_z, p_c, p_w, noise_c, noise_w, ...
    B_cL, B_cU, B_wL, B_wU);

SINR_threshold = 100;
%% File creation

% creating a file
filename = ['D:\Coexistence\results\', num2str(int32(lambda_c*1e6)), '_', ...
    num2str(int32(lambda_w*1e6)), '_', ...
    num2str(int32(B_cU*1e3)), '.csv'];

fid = fopen(filename,'wt');

% Heading: B_cL, B_wL, delta_c, delta_w, r_c, r_w
fprintf(fid,'%s, %s, %s, %s, %s, %s\n', ...
    ["B_cL [MHz]", "B_wL [MHz]", "delta_c", "delta_w", "r_c [Gbps]", "r_w [Gbps]"]);

%% Best Response Algorithm

N = 51;

for B_cL = [20, 40, 80, 100]*1e-3
    for B_wL = [20, 40, 80, 160]*1e-3
        
        params.B_cL = B_cL;
        params.B_wL = B_wL;
        
        delta_c = zeros(N);
        delta_w = zeros(N);
        
        n = 1;
        while n<N
            n = n + 1;
  
            delta_w(n) = best_response_wifi(delta_c(n-1), SINR_threshold, params);
            delta_c(n) = best_response_cellular(delta_w(n), SINR_threshold, params);
            
            if delta_c(n) == delta_c(n-1) && delta_w(n) == delta_w(n-1)
                break;
            end
        end
        
        if n==N
            [B_cL, B_wL]
        end
        
        r_c = datarate_cellular(delta_c(n), delta_w(n), SINR_threshold, params);
        r_w = datarate_wifi(delta_c(n), delta_w(n), SINR_threshold, params);

        % Sample entry: 
        fprintf(fid,'%f, %f, %f, %f, %f, %f\n', ...
            [B_cL*1e3, B_wL*1e3, delta_c(n), delta_w(n), r_c, r_w]);
        
    end
end



%%
% closing the file
fclose(fid);