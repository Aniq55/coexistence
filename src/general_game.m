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
param = parameters(alpha, rho, rho_w, lambda_z, lambda_c, lambda_w, ...
    bar_lambda_c, bar_lambda_w, p_z, p_c, p_w, noise_c, noise_w, ...
    B_cL, B_cU, B_wL, B_wU);

SINR = 1;

%% Constructing a set of Entities

e1 = entity(0.4, 0.5, 0, 0, 0.025, 0.08, 10, 1);
e2 = entity(0.6, 0.0, 0, 0, 0.03, 0, 1, 1);
e3 = entity(0.0, 0.5, 0, 0, 0, 0.11, 1, 1);

E = [e1, e2, e3];
n_entity = length(E);

%%
n_iter = 0;
while true
    n_iter = n_iter + 1;
    
    delta_c_prev = 0;
    delta_w_prev = 0;
    for e = E
        delta_c_prev = delta_c_prev + e.v_c*e.delta_c;
        delta_w_prev = delta_w_prev + e.v_w*e.delta_w;
    end
    
    % Get Best Response
    for i = 1: n_entity
        E(i) = E(i).best_response( delta_c_prev - E(i).v_c*E(i).delta_c, delta_w_prev - E(i).v_w*E(i).delta_w, param, SINR);
    end
    
    [E(1).delta_c, E(1).delta_w, ...
        E(2).delta_c, E(2).delta_w, ...
        E(3).delta_c, E(3).delta_w]
    
    if n_iter == 10 % convergence condition
        break;
    end
end

%% Final values

[E(1).delta_c, E(1).delta_w, ...
        E(2).delta_c, E(2).delta_w, ...
        E(3).delta_c, E(3).delta_w]
    
[E(1).r_c, E(1).r_w, ...
    E(2).r_c, E(2).r_w, ...
    E(3).r_c, E(3).r_w]



