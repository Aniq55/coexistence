clc;

clear all;

%% Define all constants

% Environment
L = 10*1e3;     % 10 km
alpha = 3.0;      % path-loss coefficient

% Incumbent Users
lambda_z = 1/1e6;
rho = 100;      % radius of the exclusion zone
p_z = 1;        % transmit power

% Cellular Network
lambda_c = 30/1e6;
p_c = 0.5;        % transmit power
noise_c= 1e-15; % receiver thermal noise
delta_c = 0.5;
bar_lambda_c = lambda_c*exp(-pi*lambda_z*rho^2);
lambda_cL = lambda_c - delta_c*bar_lambda_c;


% WiFi Network
lambda_w = 40/1e6;
rho_w = 20;     % radius of the WiFi PCP disk
p_w = 0.1;        % transmit power
noise_w= 1e-15; % receiver thermal noise
delta_w = 0.5;
bar_lambda_w = lambda_w*exp(-pi*lambda_z*rho^2);
prob_R_w = makedist('Triangular','a',0,'b',rho_w,'c',rho_w);

%% Simulation

n_iterations = 1000;

SINR_cL_list = [];

nearest_BS_L_list = [];

for iter = 1:n_iterations
    
    % Point Deployment:
    %   Phi_cL
    [XcL, YcL] = PPP_gen_xy(lambda_cL, L, L);
    n_cL = length(XcL);

    % Distance from Origin (user)    
    R_cL = abs(XcL + 1j*YcL)';
    
    C0_L_index = find(R_cL == min(R_cL));
    nearest_BS_L_list= [nearest_BS_L_list; min(R_cL) ];
        
    % Interference Vectors
    I_cL = p_c*exprnd(1, n_cL, 1).*R_cL.^(-alpha);
    
    % Power from associated Points
    P_c0_L = I_cL(C0_L_index);

    % Licensed
    % 1. I_cL_total
    I_cL_total = sum(I_cL') - P_c0_L;
    SINR_cL = P_c0_L/(noise_c + I_cL_total);
    SINR_cL_list = [SINR_cL_list; SINR_cL];

end

% Store the CDFs
[P_cL_sim, SINR_cL_range] = ecdf(SINR_cL_list);


%% Theoretical


beta = 2.0/alpha;
zeta_fun = @(x) 1./(1+x.^(alpha/2));

% Calculate
%   1. P_c,L
P_cL_list = [];

for gamma= 10.^([-5:10]/10)
    
    zeta_int = integral(@(x)zeta_fun(x)*0.5*gamma^(2/alpha), gamma^(-beta), Inf, 'ArrayValued', true);
    
    f_R=@(r)2*pi*lambda_cL*r*exp(-pi*lambda_cL*r^2);
    L_I=@(r)exp(-2*pi*lambda_cL*r^2*zeta_int);
    P_cL=integral(@(r)f_R(r)*exp(-gamma*r^(alpha)*noise_c/p_c),0,inf,'ArrayValued',true)*integral(@(r)f_R(r)*L_I(r),0,inf,'ArrayValued',true);

    P_cL_list = [P_cL_list; P_cL];

end

%% Plot

figure(1);
plot(10.*log10(SINR_cL_range), 1-P_cL_sim);
hold on;
plot([-5:10], P_cL_list, 'x');
ylabel('P_{c|L}(\gamma)')
xlabel('\gamma [dB]')
xlim([-5 10])
ylim([0 1])
