clc;
clear all;

%% Define constants

L = 10*1e3;    % 10 km


lambda_z = 1/1e6;   % Backhaul MBS
lambda_c = 25/1e6;   % cellular SBS
lambda_w = 50/1e6;   % WiFi APs

rho = 200;  % radius of the exclusion zone
rho_w = 50; % radius of the WiFi PCP disk

% Transmit powers
p_z = 2;
p_c = 2;
p_w = 2;

alpha = 3; % path-loss coefficient

% receiver thermal noise
noise_c= 1e-15;
noise_w= 1e-14;

n_deployments = 1;
n_iterations = 1;
n_observations = n_deployments*n_iterations;

SINR_c = zeros(1, n_observations);

%% Generate PPPs:

% ITERATE: change deployment
for deployment= 1:n_deployments

[Xz, Yz] = PPP_gen_xy(lambda_z, L, L);  % Incumbent Users
[xc, yc] = PPP_gen_xy(lambda_c, L, L);  % Cellulat Base Stations
[xw, yw] = PPP_gen_xy(lambda_w, L, L);  % WiFi Access Points

n_z = length(Xz);
n_c = length(xc);
n_w = length(xw);


%% Generate PHPs:

Xc = [];
Yc = [];
for i=1:n_c
    if sum ( sqrt((Xz - xc(i)).^2 + (Yz - yc(i)).^2) < rho) == 0
        % the point i lies out of an exclusion zone
        Xc = [Xc; xc(i)];
        Yc = [Yc; yc(i)];
    end
end

n_c = length(Xc);


Xw = [];
Yw = [];
for i=1:n_w
    if sum ( sqrt((Xz - xw(i)).^2 + (Yz - yw(i)).^2) < rho) == 0
        % the point i lies out of an exclusion zone
        Xw = [Xw; xw(i)];
        Yw = [Yw; yw(i)];
    end
end
n_w = length(Xw);
%% Calculating Interference:

% SINR for Cellular Users:

% assume that the cellular user is at the origin:
R_c = abs(Xc + 1j*Yc);
R_w = abs(Xw + 1j*Yw);
R_z = abs(Xz + 1j*Yz)';

B_0_index = find(R_c == min(R_c));

% ITERATE: change fading

    for iteration = 1:n_iterations
        I_c_vector = p_c*exprnd(1, n_c, 1).*R_c.^(-alpha);
        received_power_c = I_c_vector(B_0_index);
        I_c = sum(I_c_vector) - received_power_c;


        I_w = sum(p_w*exprnd(1, n_w, 1).*R_w.^(-alpha));
        I_z = sum(p_z*exprnd(1, n_z, 1).*R_z.^(-alpha));

        i = (deployment-1)*n_iterations + iteration;
        SINR_c(i) = received_power_c/(noise_c + I_c + I_w + I_z);
    end
end

%%
[f, SINR] = ecdf(SINR_c);


bar_lambda_c = lambda_c*exp(-pi*lambda_z*rho^2);
bar_lambda_w = lambda_w*exp(-pi*lambda_z*rho^2);


beta = 2/alpha;

%%

P_c_list = [];

for gamma= [0: 0.01: 10]
    
zeta_fun = @(x) 1./(1+x.^(alpha/2));
zeta_int = integral(@(x)zeta_fun(x), gamma.^(-beta), Inf, 'ArrayValued', true);

B = pi.*bar_lambda_c.*(1+zeta_int) + (pi/sinc(beta)).*( bar_lambda_w.*(p_w.^beta) + lambda_z.*(p_z.^beta) ).*((gamma./p_c).^beta);


P_c_r = @(r) pi*bar_lambda_c*exp(-(noise_c*gamma/p_c)*(r.^(alpha/2)) - B*r);
P_c = integral(@(r)P_c_r(r), 0, Inf, 'ArrayValued', true)
    
P_c_list = [P_c_list; P_c];

end
%%
figure(2);
plot(SINR, f, 'LineWidth', 2);
hold on;

plot([0: 0.01: 10], 1-P_c_list, '--', 'LineWidth', 2);

legend('simulation', 'theoretical')
xlim([0 10])
xlabel('\gamma')
ylabel('P(SINR_c \leq \gamma)')
grid on;
box on;



%% Plot

figure('Position', [10 10 500 500]);
hold on;
box on;


viscircles([Xz' Yz'], rho*ones(n_z, 1), ...
    'LineWidth', 1.5, 'color', '#ffa600'); % exclusion zones
hold on;
% viscircles([Xw Yw], rho_w*ones(n_w, 1), ...
%     'LineWidth', 0.1, 'color', '#ff7c43'); % wifi coverage zones

scatter(Xz, Yz,  '+', 'MarkerEdgeColor', '#58508d');
scatter(Xc, Yc,  's', 'MarkerEdgeColor', '#003f5c', 'MarkerFaceColor', '#a05195');
scatter(Xw, Yw,  'o', 'MarkerEdgeColor', '#2f4b7c');

xlabel("x [m]");
ylabel("y [m]");

xlim([-1e3 1e3])
ylim([-1e3 1e3])

legend('Incumbent User','Cellular BS','WiFi AP')

