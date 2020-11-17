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

%% Initializing Entities

r_c_min  = 0.03;
r_w_min = 0.08;

share_c = 0.1;
share_w = 0.5;

% V_C, V_W, DELTA_C, DELTA_W, R_C_MIN, R_W_MIN, THETA_C, THETA_W
e1 = entity(share_c, share_w, 0, 0, ...
    r_c_min,   r_w_min,   1, 1);

e2 = entity(1.0-share_c, 1.0 - share_w, 0, 0, ...
    r_c_min,   r_w_min,   1, 1);

% History Vectors
H_c1 = [0];
H_w1 = [0];
H_c2 = [0];
H_w2 = [0];

n_entity = 2;

%% Time-loop

n_iter = 0;
prev_vector = zeros(1, n_entity);
while true
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
end

%% Final values

datarate_vals = [e1.r_c, e2.r_c; e1.r_w, e2.r_w]

% Write to a file:
% v_c1, v_w1, delta_c1, delta_w1, delta_c2, delta_w2, r_c1, r_w1, r_c2, r_w2

%%
figure('Position', [100 100 800 200]);

subplot(1,3,1)
plot([1:n_iter+1], H_c1, 'x--', 'color', '#58508d', 'LineWidth', 1.5)
hold on;
plot([1:n_iter+1], H_w1, 's--', 'color', '#58508d', 'LineWidth', 1.5)
leg1 = legend('\delta_c^1', '\delta_w^1', 'Location','southeast');
xlabel('iterations')
ylabel('\delta')
ylim([0 1]);
box on;
grid on;

subplot(1,3,2)
plot([1:n_iter+1], H_c2, 'x--', 'color', '#ff6361', 'LineWidth', 1.5)
hold on;
plot([1:n_iter+1], H_w2, 's--', 'color', '#ff6361', 'LineWidth', 1.5)
leg2 = legend('\delta_c^2', '\delta_w^2', 'Location','southeast');
xlabel('iterations')
ylabel('\delta')
ylim([0 1]);
box on;
grid on;

subplot(1,3,3)

X = categorical({'cellular','WiFi'});
X = reordercats(X,{'cellular','WiFi'});
b = bar(X,datarate_vals*1e3, 'FaceColor', 'flat');
ylabel('datarate [Mbps]')

b(1).FaceColor = '#58508d';
b(2).FaceColor = '#ff6361';
grid on;
box on;
leg3  = legend('entity-1', 'entity-2', 'Location', 'northwest')


