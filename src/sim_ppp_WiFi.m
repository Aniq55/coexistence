clc;
clear all;

%% Define constants

L = 10*1e3;    % 10 km


lambda_z = 1/1e6;   % Backhaul MBS
lambda_c = 20/1e6;   % cellular SBS
lambda_w = 40/1e6;   % WiFi APs

rho = 100;  % radius of the exclusion zone
rho_w = 50; % radius of the WiFi PCP disk

% Transmit powers
p_z = 2;
p_c = 2;
p_w = 2;

alpha = 3; % path-loss coefficient

% receiver thermal noise
noise_c= 1e-15;
noise_w= 1e-10;

n_deployments = 100;
n_iterations = 100;
n_observations = n_deployments*n_iterations;

SINR_w = zeros(1, n_observations);

%% Generate PPPs:


pd = makedist('Triangular','a',0,'b',rho_w,'c',rho_w);

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

% SINR for WiFi Users:

% assume that the WiFi user is at the origin:
R_c = abs(Xc + 1j*Yc);
R_w = abs(Xw + 1j*Yw);
R_z = abs(Xz + 1j*Yz)';

% ITERATE: change fading

    for iteration = 1:n_iterations
        % create an imaginary WiFi AP at a distance R
        R = random(pd, 1); % this is wrong (should be a triangular distribution)
        received_power_w = p_w*exprnd(1)*R^(-alpha);

        I_c = sum(p_w*exprnd(1, n_c, 1).*R_c.^(-alpha));
        I_w = sum(p_w*exprnd(1, n_w, 1).*R_w.^(-alpha));
        I_z = sum(p_z*exprnd(1, n_z, 1).*R_z.^(-alpha));

        i = (deployment-1)*n_iterations + iteration;
        SINR_w(i) = received_power_w/(noise_w + I_c + I_w + I_z);
    end
end

%%
[f, SINR] = ecdf(SINR_w);


bar_lambda_c = lambda_c*exp(-pi*lambda_z*rho^2);
bar_lambda_w = lambda_w*exp(-pi*lambda_z*rho^2);


beta = 2/alpha;

%%

P_w_list = [];

for gamma= [0: 0.1: 10]
    

B = (pi/sinc(beta)).*( bar_lambda_w.*(p_w.^beta) + bar_lambda_c.*(p_c.^beta) + lambda_z.*(p_z.^beta) ).*((gamma./p_w).^beta);


P_w_r = @(r) (1/(rho_w.^2))*exp( -(noise_w*gamma/p_w)*(r.^(alpha/2)) - B*r);
P_w = integral(@(r)P_w_r(r), 0, rho_w^2, 'ArrayValued', true)
    
P_w_list = [P_w_list; P_w];

end
%%
figure(2);
plot(SINR, f, 'LineWidth', 2);
hold on;

plot([0: 0.1: 10], 1-P_w_list, '--', 'LineWidth', 2);

legend('simulation', 'theoretical')
xlim([0 10])
xlabel('\gamma')
ylabel('P(SINR_w \leq \gamma)')
grid on;
box on;



%% Plot
% 
% figure('Position', [10 10 500 500]);
% hold on;
% box on;
% 
% 
% viscircles([Xz' Yz'], rho*ones(n_z, 1), 'LineWidth', 1, 'color', 'green'); % exclusion zones
% 
% scatter(Xz, Yz, 'k.');
% scatter(Xc, Yc, 'bo');
% scatter(Xw, Yw, 'rx');
% 
% xlabel("x [m]");
% ylabel("y [m]");
% 
% legend('Incumbent User','Cellular BS','WiFi AP')

