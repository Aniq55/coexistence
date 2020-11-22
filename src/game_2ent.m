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

r_c1_min  = 0.05;
r_w1_min = 0.1;

r_c2_min  = 0.03;
r_w2_min = 0.14;

share_c = 0.2;
share_w = 0.6;

theta_c = 5;
theta_w = 1;


datarate_min = [r_c1_min, r_c2_min ; r_w1_min, r_w2_min];

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

n_entity = 2;

%% Time-loop

n_iter = 0;
prev_vector = zeros(1, n_entity);
while true
    n_iter = n_iter + 1
    
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
%     if equilibrium == 0 
%         break;
%     end    
    
    if n_iter > 3
        break;
        % save the datarates again
    end
    
end

e1 = e1.update_datarate( e2.v_c*e2.delta_c, e2.v_w*e2.delta_w, param, SINR);
e2 = e2.update_datarate( e1.v_c*e1.delta_c, e1.v_w*e1.delta_w, param, SINR);

%% Final values

datarate_vals = [e1.r_c, e2.r_c; e1.r_w, e2.r_w]

%%

color1 = "#665191";
color2 = "#f95d6a";

font_size_val = 12;
figure('Position', [100 100 1000 250]);


subplot(1,4,1)

X = categorical({'cellular','WiFi'});
X = reordercats(X,{'cellular','WiFi'});
b3 = bar(X,[e1.v_c, e2.v_c; e1.v_w, e2.v_w], 0.5, ...
    'stacked', 'FaceColor', 'flat');
b3(1).FaceColor = color1;
b3(2).FaceColor = color2;
ylabel('share')
xlabel('network')

box on;
% leg4  = legend('e_1', 'e_2', 'e_3', 'Location', 'northeastoutside', 'Orientation', 'vertical')
set(gca,'Fontsize', font_size_val);
leg3  = legend('e$$_1$$', 'e$$_2$$', 'Interpreter','Latex',...
    'Location', 'northoutside', 'Orientation', 'horizontal' )

subplot(1,4,2)
plot([1:n_iter+1], H_c1, 'x--', 'color', color1, 'LineWidth', 1.5, 'MarkerSize', 10)
hold on;
plot([1:n_iter+1], H_w1, 's--', 'color', color1, 'LineWidth', 1.5, 'MarkerSize', 10)
leg1 = legend('\delta_c^1', '\delta_w^1', ...
    'Location', 'northoutside', 'Orientation', 'horizontal');
xlabel('iterations')
% ylabel('\delta')
ylim([0 1]);
xlim([1, n_iter+1])
box on;
grid on;
set(gca,'Fontsize', font_size_val);


subplot(1,4,3)
plot([1:n_iter+1], H_c2, 'x--', 'color', color2, 'LineWidth', 1.5, 'MarkerSize', 10)
hold on;
plot([1:n_iter+1], H_w2, 's--', 'color', color2, 'LineWidth', 1.5, 'MarkerSize', 10)
leg2 = legend('\delta_c^2', '\delta_w^2', ... 
    'Location', 'northoutside', 'Orientation', 'horizontal');
xlabel('iterations')
% ylabel('\delta')
ylim([0 1]);
xlim([1, n_iter+1])
box on;
grid on;
set(gca,'Fontsize', font_size_val);





subplot(1,4,4)

X = categorical({'cellular','WiFi'});
X = reordercats(X,{'cellular','WiFi'});
b = bar(X,datarate_vals*1e3, 1, 'FaceColor', 'flat');
hold on;
b2 = bar(X,datarate_min*1e3, 0.25,'FaceColor','k');
ylabel('datarate [Mbps]')
xlabel('network')

b(1).FaceColor = color1;
b(2).FaceColor = color2;
grid on;
box on;
leg3  = legend('e$$_1$$', 'e$$_2$$', '$$\hat{\sigma}$$', 'Interpreter','Latex', 'Location', 'northwest')
set(gca,'Fontsize', font_size_val);
set(gca,'Fontsize', font_size_val);


