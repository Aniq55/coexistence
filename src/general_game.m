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

SINR = 1;

%% Constructing a set of Entities

share = 1.0;
% V_C, V_W, DELTA_C, DELTA_W, R_C_MIN, R_W_MIN, THETA_C, THETA_W
e1 = entity(share, 0.5, 0, 0, 0.03,   0.1,   1, 1);
e2 = entity(1.0-share, 0.5, 0, 0, 0.03,   0.1,   1, 1);

E = [e1, e2];
n_entity = length(E);

%%
n_iter = 0;
prev_vector = zeros(1, n_entity);
while true
    n_iter = n_iter + 1;
    
    delta_c_prev = 0;
    delta_w_prev = 0;
    for e = E
        delta_c_prev = delta_c_prev + e.v_c*e.delta_c;
        delta_w_prev = delta_w_prev + e.v_w*e.delta_w;
    end
    
    this_vector = [];
    % Get Best Response
    for i = 1: n_entity
        E(i) = E(i).best_response( delta_c_prev - E(i).v_c*E(i).delta_c, delta_w_prev - E(i).v_w*E(i).delta_w, param, SINR);
        this_vector = [this_vector; E(i).delta_c];
        this_vector = [this_vector; E(i).delta_w];
    end
   
%     this_vector
    if sum(abs(prev_vector - this_vector)) == 0 % convergence condition
        break;
    end
    
%     if n_iter == 2
%         break
%     end
    
    prev_vector = this_vector;
    
end

%% Final values

n_iter;
this_vector
    
datarates_list = [];
for i = 1: n_entity
    datarates_list = [datarates_list; E(i).r_c];
    datarates_list = [datarates_list; E(i).r_w];
end

datarates_list


