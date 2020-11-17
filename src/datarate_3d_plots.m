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
params = parameters(alpha, rho, rho_w, lambda_z, lambda_c, lambda_w, ...
    bar_lambda_c, bar_lambda_w, p_z, p_c, p_w, noise_c, noise_w, ...
    B_cL, B_cU, B_wL, B_wU);

SINR_threshold = 10;

%%

delta_resolution = 0.05;
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

% preference weightage
pref_cell = 1;
pref_wifi = 3;

% min datarate
r_c_min = 0.035;
r_w_min = 0.05;


% figure(1);
% opt_fn = (pref_cell.*(datarate_cell_all) ...
%     + pref_wifi.*(datarate_wifi_all)).*( ...
%     datarate_cell_all >= r_c_min).*(datarate_wifi_all >= r_w_min);
% opt_fn = 0.5*(opt_fn + abs(opt_fn));
% surf(DELTA_RANGE, DELTA_RANGE, opt_fn);
% xlabel('\delta_w')
% ylabel('\delta_c')
% 
% marker_list= ["x-", "o-", "+-", "s-", "v-", ...
%     "^-", "*-", "x--", "o--", "+--", "v--" ];
% 
% figure(2);
% hold on;
% for i = [1:11]
%     plot(DELTA_RANGE, opt_fn(:,i), marker_list(i))
% end
% legend(string(DELTA_RANGE))
% xlabel("\delta_c")
% box on;
% grid on;

% Find the argmax in a 2D matrix
% [max1, argmax1] = max(opt_fn);
% argmax1 = max(argmax1);
% [max2, argmax2] = max(max1);
% 
% delta_c_star = (argmax1-1)*delta_resolution;
% delta_w_star = (argmax2-1)*delta_resolution;
% 
% [delta_c_star, delta_w_star]
% 
% if max2 == 0
%    % false maximum (no solution)
%    display('no solution');
% end

%%
% 
% Dc = delta_c_star;
% Dw = delta_w_star;
% 
% rate_cell_star = datarate_cellular(Dc, Dw, SINR_threshold, params);
% rate_wifi_star = datarate_wifi(Dc, Dw, SINR_threshold, params);
% %%
% [r_c_min, r_w_min, Dc, Dw, rate_cell_star, rate_wifi_star]'

%% 3-D plots
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


%%
color_vec6 = ["#003f5c", "#444e86", "#955196", "#dd5182", "#ff6e54", "#ffa600",];

figure(2);
hold on
j = 1;
for i= 1:2:11
    plot(DELTA_RANGE, 1e3*datarate_cell_all(:,i), 'color', color_vec6(j), 'LineWidth', 2);
    j = j +1;
end
grid on;
box on;

leg = legend('0', '0.2', '0.4','0.6','0.8','1.0', 'Location','northwest')
title(leg, '\delta_w')
xlabel('\delta_c')
ylabel('Average cellular datarate [Mbps]')

%%
figure(3);
hold on
j = 1;
for i= 1:2:11
    plot(DELTA_RANGE, 1e3*datarate_wifi_all(i,:), 'color', color_vec6(j), 'LineWidth', 2);
    j = j +1;
end
grid on;
box on;

leg = legend('0', '0.2', '0.4','0.6','0.8','1.0', 'Location','southeast')
title(leg, '\delta_c')
xlabel('\delta_w')
ylabel('Average WiFi datarate [Mbps]')


%%
% figure(4);

figure('Position', [10 10 600 300]);

subplot(1,2,1);
hold on
j = 1;
for i= 1:2:11
    plot(DELTA_RANGE, 1e3*datarate_cell_all(:,i), 'color', color_vec6(j), 'LineWidth', 2);
    j = j +1;
end
grid on;
box on;

leg = legend('0', '0.2', '0.4','0.6','0.8','1.0', 'Location','northwest')
title(leg, '\delta_w')
xlabel('\delta_c')
ylabel('Average cellular datarate [Mbps]')
hold off;

subplot(1,2,2);
hold on
j = 1;
for i= 1:2:11
    plot(DELTA_RANGE, 1e3*datarate_wifi_all(i,:), 'color', color_vec6(j), 'LineWidth', 2);
    j = j +1;
end
grid on;
box on;

leg2 = legend('0', '0.2', '0.4','0.6','0.8','1.0', 'Location','southeast')
title(leg2, '\delta_c')
xlabel('\delta_w')
ylabel('Average WiFi datarate [Mbps]')

%%
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
