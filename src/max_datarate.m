clc;
clear all

%% parameters
% Environment
alpha = 3.5;      % path-loss coefficient

% Incumbent Users
lambda_z = 1/1e6;
rho = 200;      % radius of the exclusion zone
p_z = 1;        % transmit power [W]

% Cellular Network
lambda_c = 250/1e6;
p_c = 4;        % transmit power [W]
noise_c= 1e-15; % receiver thermal noise
bar_lambda_c = lambda_c*exp(-pi*lambda_z*rho^2);

% WiFi Network
lambda_w = 400/1e6;
rho_w = 50;     % radius of the WiFi PCP disk
p_w = 4;        % transmit power [W]
noise_w= 1e-15; % receiver thermal noise
bar_lambda_w = lambda_w*exp(-pi*lambda_z*rho^2);

% Bandwidths [GHz]
B_cL = 0.100;
B_cU = 0.320;
B_wL = 0.160;
B_wU = 0.320;

% Create parameters object
params = parameters(alpha, rho, rho_w, lambda_z, lambda_c, lambda_w, ...
    bar_lambda_c, bar_lambda_w, p_z, p_c, p_w, noise_c, noise_w, ...
    B_cL, B_cU, B_wL, B_wU);

gamma = 100; % SINR threshold

%% precision control
delta_resolution = 0.05;

%% Creating files
filename = ['D:\Coexistence\results\max_datarate\cellular.csv'];
fid = fopen(filename,'wt');

filename2 = ['D:\Coexistence\results\max_datarate\wifi.csv'];
fid2 = fopen(filename2,'wt');

% Header entry:
fprintf(fid,'%s, %s, %s, %s\n', ...
    ["lambda_c [x1e-6]", "B_cL [MHz]", "B_U [MHz]", "max r_c [Gbps]"]);
fprintf(fid2,'%s, %s, %s, %s\n', ...
    ["lambda_w [x1e-6]", "B_wL [MHz]", "B_U [MHz]", "max r_w [Gbps]"]);

%% main processing loop
        
for B_U = [80, 160, 240, 320]*1e-3
    params.B_cU = B_U;
    params.B_wU = B_U;
    
    % cellular
    for lambda_c = [25, 50, 250]*1e-6
        params.lambda_c = lambda_c;
        for B_cL = [20, 40, 80, 100]*1e-3
            params.B_cL = B_cL;

            r_c_list = [];
            for delta_c = [0: delta_resolution : 1]
                r_c_list = [r_c_list; datarate_cellular(delta_c, 0, gamma, params)];
            end
            max_r_c = max(r_c_list);

            % add an entry to the csv file
            fprintf(fid,'%f, %f, %f, %f\n', ...
                [lambda_c*1e6, B_cL*1e3, B_U*1e3, max_r_c]);
        end
    end   
    
    % WiFi
    for lambda_w = [100, 400]*1e-6
        params.lambda_w = lambda_w;
        for B_wL = [20, 40, 80, 160]*1e-3
            params.B_wL = B_wL;

            r_w_list = [];
            for delta_w = [0: delta_resolution : 1]
                r_w_list = [r_w_list; datarate_wifi(0, delta_w, gamma, params)];
            end
            max_r_w = max(r_w_list);

            % add an entry to the csv file
            fprintf(fid2,'%f, %f, %f, %f\n', ...
                [lambda_w*1e6, B_wL*1e3, B_U*1e3, max_r_w]);
        end
    end 
    
end

%% Closing files after writing
fclose(fid);
fclose(fid2);


