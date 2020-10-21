clc
clear all

%% parameters

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
p_w = 4;        % transmit power [W]
noise_w= 1e-15; % receiver thermal noise
bar_lambda_w = lambda_w*exp(-pi*lambda_z*rho^2);

% Bandwidths [GHz]
B_cL = 0.080;
B_cU = 0.240;
B_wL = 0.080;
B_wU = 0.240;

% Create parameters object
PARAM = parameters(alpha, rho, rho_w, lambda_z, lambda_c, lambda_w, ...
    bar_lambda_c, bar_lambda_w, p_z, p_c, p_w, noise_c, noise_w, ...
    B_cL, B_cU, B_wL, B_wU);

SINR = 10.^([-5:10]/10);
SINR_dB = [-5:10];

beta = 2.0/PARAM.alpha;
delta_c = 0.5;
delta_w = 0.5;

lambda_wU = delta_w*PARAM.bar_lambda_w;
lambda_wL = PARAM.lambda_w - lambda_wU;
lambda_cU = delta_c*PARAM.bar_lambda_c;
lambda_cL = PARAM.lambda_c - lambda_cU;

p_levels = [-1: 0.5 :2];
p_levels_abs = 2.^(p_levels);
N = length(p_levels);

%%
P_cU_mat = zeros(N,N);
for i = [1:N]
    for j = [1:N]
        gamma = 10;
        
        PARAM.p_c = p_levels_abs(i);
        PARAM.p_w = p_levels_abs(j);
        
        zeta_fun = @(x) 1./(1+x.^(PARAM.alpha/2));
        zeta_int = integral(@(x)zeta_fun(x)*0.5*gamma^(2/PARAM.alpha), ...
            gamma^(-beta), Inf, 'ArrayValued', true);

        % P_c,U

        f_RU=@(r)2*pi*lambda_cU*r*exp(-pi*lambda_cU*r^2);
        L_IcU=@(r)exp(-2*pi*lambda_cU*r^2*zeta_int);
        L_Iwz = @(r)exp( -(pi/sinc(beta))*( delta_w*PARAM.bar_lambda_w*(PARAM.p_w^beta) ...
            + PARAM.lambda_z*(PARAM.p_z^beta) )*((gamma/PARAM.p_c)^beta)*r^2 );

        P_cU= integral(@(r)f_RU(r)*exp(-gamma*r^(PARAM.alpha)*PARAM.noise_c/PARAM.p_c)*L_IcU(r)*L_Iwz(r), ...
            0, inf, 'ArrayValued', true  );
        P_cU_mat(i,j) = P_cU;

    end
end

%%

P_wU_mat = zeros(N,N);
for i = [1:N]
    for j = [1:N]
        gamma = 10;
        
        PARAM.p_c = p_levels_abs(i);
        PARAM.p_w = p_levels_abs(j);
        

        % P_w,U

        B_U = (pi/sinc(beta))*( lambda_wU*(PARAM.p_w.^beta) ...
            + delta_c*PARAM.bar_lambda_c*(PARAM.p_c^beta) ...
            + PARAM.lambda_z*(PARAM.p_z^beta) )*((gamma/PARAM.p_w)^beta);

        P_w_rU = @(r) (1/(PARAM.rho_w^2))*exp( ...
            -(PARAM.noise_w*gamma/PARAM.p_w)*(r.^(PARAM.alpha/2)) - B_U*r);
        P_wU = integral(@(r)P_w_rU(r), 0, PARAM.rho_w^2, 'ArrayValued', true);
        
        P_wU_mat(i,j) = P_wU;

    end
end

%%
% P_cL_mat = zeros(N,N);
% for i = [1:N]
%     for j = [1:N]
%         gamma = 10;
%         
%         PARAM.p_c = p_levels_abs(i);
%         PARAM.p_w = p_levels_abs(j);
%         
%         zeta_fun = @(x) 1./(1+x.^(PARAM.alpha/2));
%         zeta_int = integral(@(x)zeta_fun(x)*0.5*gamma^(2/PARAM.alpha), ...
%             gamma^(-beta), Inf, 'ArrayValued', true);
% 
%         % P_c,L
% 
%         f_RL=@(r)2*pi*lambda_cL*r*exp(-pi*lambda_cL*r^2);
%         L_IcL=@(r)exp(-2*pi*lambda_cL*r^2*zeta_int);
% 
%         P_cL=integral(@(r)f_RL(r)*exp(-gamma*r^(PARAM.alpha)*PARAM.noise_c/PARAM.p_c)*L_IcL(r), ...
%             0,inf,'ArrayValued',true);
%         P_cL_mat(i,j) = P_cL;
% 
%     end
% end

%%
% 
% P_wL_mat = zeros(N,N);
% for i = [1:N]
%     for j = [1:N]
%         gamma = 10;
%         
%         PARAM.p_c = p_levels_abs(i);
%         PARAM.p_w = p_levels_abs(j);
%         
% 
%         % P_w,L
% 
%         B_L = (pi/sinc(beta))*( lambda_wL*(gamma^beta) );
% 
%         P_w_rL = @(r) (1/(PARAM.rho_w^2))*exp( ...
%             -(PARAM.noise_w*gamma/PARAM.p_w)*(r.^(PARAM.alpha/2)) - B_L*r);
%         P_wL = integral(@(r)P_w_rL(r), 0, PARAM.rho_w^2, 'ArrayValued', true);
%         
%         P_wL_mat(i,j) = P_wL;
% 
%     end
% end


%%

figure(1)
subplot(1,2,1)
surf(p_levels, p_levels, P_cU_mat)
ylabel('log_2(p_c)')
xlabel('log_2(p_w)')
title('P_{c|U}, SINR = 10 dB')
grid on;
box on;
view(2)
colorbar



subplot(1,2,2)
surf(p_levels, p_levels, P_wU_mat)
ylabel('log_2(p_c)')
xlabel('log_2(p_w)')
title('P_{w|U}, SINR = 10 dB')
grid on;
box on;
view(2)
colorbar

