clc;
clear all;

%% Defining Parameters

% Environment
alpha = 3.5;      % path-loss coefficient

% Incumbent Users
lambda_z = 1/1e6;
rho = 200;      % radius of the exclusion zone
p_z = 1;        % transmit power [W]

% Cellular Network
lambda_c = 25/1e6;
p_c = 2;        % transmit power [W]
noise_c= 1e-15; % receiver thermal noise
bar_lambda_c = lambda_c*exp(-pi*lambda_z*rho^2);

% WiFi Network
lambda_w = 100/1e6;
rho_w = 50;     % radius of the WiFi PCP disk
p_w = 1;        % transmit power [W]
noise_w= 1e-15; % receiver thermal noise
bar_lambda_w = lambda_w*exp(-pi*lambda_z*rho^2);

% Bandwidths [GHz]
B_cL = 0.080;
B_cU = 0.240;
B_wL = 0.080;
B_wU = 0.240;

% Create parameters object
param = parameters(alpha, rho, rho_w, lambda_z, lambda_c, lambda_w, ...
    bar_lambda_c, bar_lambda_w, p_z, p_c, p_w, noise_c, noise_w, ...
    B_cL, B_cU, B_wL, B_wU);

SINR = 10;

%% Writing Data to a file

filename = ['D:\Coexistence\results\game\game_thresh_05_18.csv'];
fid = fopen(filename,'wt');

% Header entry: (11 items)
fprintf(fid,'%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s\n', ...
    ["v_c1", "v_w1", "del_c1", "del_w1", "del_c2", "del_w2", ...
    "r_c1", "r_w1", "r_c2", "r_w2", "n_iter"]);



%% Main Loop

r_c_min  = 0.03;
r_w_min = 0.01;

share_vector = [0.1: 0.1: 0.9];
n_entity = 2;

r_c1_min  = 0.05;
r_w1_min = 0.18;

r_c2_min  = 0.05;
r_w2_min = 0.18;

theta_c = 7;
theta_w = 1;

for share_c = share_vector
    for share_w = share_vector
        [share_c, share_w]
        
        % Defining Entities
        % V_C, V_W, DELTA_C, DELTA_W, R_C_MIN, R_W_MIN, THETA_C, THETA_W
        e1 = entity(share_c, share_w, 0, 0, ...
            r_c1_min,   r_w1_min,   theta_c, theta_w);

        e2 = entity(1.0-share_c, 1.0 - share_w, 0, 0, ...
            r_c2_min,   r_w2_min,   theta_c, theta_w);

        % History Vectors
        H_c1 = [0];
        H_w1 = [0];
        H_c2 = [0];
        H_w2 = [0];

        n_iter = 0;
        prev_vector = zeros(1, n_entity);
        while true % Time-loop
            n_iter = n_iter + 1;

            % Get Best Response
            e1 = e1.best_response( e2.v_c*e2.delta_c, e2.v_w*e2.delta_w, param, SINR);
            e2 = e2.best_response( e1.v_c*e1.delta_c, e1.v_w*e1.delta_w, param, SINR);

            H_c1 = [H_c1; e1.delta_c];
            H_w1 = [H_w1; e1.delta_w];
            H_c2 = [H_c2; e2.delta_c];
            H_w2 = [H_w2; e2.delta_w];

            equilibrium = abs(H_c1(end) - H_c1(end-1)) ...
                + abs(H_w1(end) - H_w1(end-1)) ...
                + abs(H_c2(end) - H_c2(end-1)) ...
                + abs(H_w2(end) - H_w2(end-1));

            % convergence condition
            if equilibrium == 0 
                break;
            end 
            
            if n_iter > 10
                break;
                % save the datarates again
            end
        end
        
        % Write to a file: for each (v_c1, v_w1):
        % delta_c1, delta_w1, delta_c2, delta_w2, r_c1, r_w1, r_c2, r_w2, n_iter
        fprintf(fid,'%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f\n', ...
            [share_c, share_w, e1.delta_c, e1.delta_w, ...
            e2.delta_c, e2.delta_w, e1.r_c, e1.r_w, e2.r_c, e2.r_w, n_iter]);

    end
end


fclose(fid);
