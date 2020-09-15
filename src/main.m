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

SINR_cU_list = [];
SINR_cL_list = [];
SINR_wU_list = [];
SINR_wL_list = [];

nearest_BS_U_list = [];
nearest_BS_L_list = [];

for iter = 1:n_iterations
    
    % Point Deployment:
    %   1. Phi_Z
    [Xz, Yz] = PPP_gen_xy(lambda_z, L, L);
    n_z = length(Xz);


    %   2. Phi_c
    [Xc, Yc] = PPP_gen_xy(lambda_c, L, L);
    n_c = length(Xc);


    %   3. Phi_c^U
    XcU = [];
    YcU = [];

    %   4. Phi_c^L
    XcL = [];
    YcL = [];


    for i=1:n_c
        if sum ( sqrt((Xz - Xc(i)).^2 + (Yz - Yc(i)).^2) < rho) == 0
            % the point i lies out of an exclusion zone

            if rand < delta_c
                XcU = [XcU; Xc(i)];
                YcU = [YcU; Yc(i)];
            else
                XcL = [XcL; Xc(i)];
                YcL = [YcL; Yc(i)];
            end

        else
            XcL = [XcL; Xc(i)];
            YcL = [YcL; Yc(i)];
        end
    end
    
    n_cU = length(XcU);
    n_cL = length(XcL);


    %   5. Phi_w
    [Xw, Yw] = PPP_gen_xy(lambda_w, L, L);
    n_w = length(Xw);

    %   6. Phi_w^U
    XwU = [];
    YwU = [];

    %   7. Phi_w^L
    XwL = [];
    YwL = [];


    for i=1:n_w
        if sum ( sqrt((Xz - Xw(i)).^2 + (Yz - Yw(i)).^2) < rho) == 0
            % the point i lies out of an exclusion zone

            if rand < delta_w
                XwU = [XwU; Xw(i)];
                YwU = [YwU; Yw(i)];
            else
                XwL = [XwL; Xw(i)];
                YwL = [YwL; Yw(i)];
            end

        else
            XwL = [XwL; Xw(i)];
            YwL = [YwL; Yw(i)];
        end
    end
    
    n_wU = length(XwU);
    n_wL = length(XwL);
    
    
    
    % Distance from Origin (user)
    R_z = abs(Xz + 1j*Yz);
    
    R_cL = abs(XcL + 1j*YcL);
    R_cU = abs(XcU + 1j*YcU);
    
    R_wL = abs(XwL + 1j*YwL);
    R_wU = abs(XwU + 1j*YwU);
    
    
    C0_L_index = find(R_cL == min(R_cL));
    C0_U_index = find(R_cU == min(R_cU));
    
    nearest_BS_U_list= [nearest_BS_U_list; min(R_cU) ];
    nearest_BS_L_list= [nearest_BS_L_list; min(R_cL) ];
        
    R0_w = random(prob_R_w, 1);
    
    
    % Interference Vectors
    I_z  = p_z*exprnd(1, n_z, 1).*R_z.^(-alpha)';
    
    I_cL = p_c*exprnd(1, n_cL, 1).*R_cL.^(-alpha);
    I_cU = p_c*exprnd(1, n_cU, 1).*R_cU.^(-alpha);
    
    I_wL = p_w*exprnd(1, n_wL, 1).*R_wL.^(-alpha);
    I_wU = p_w*exprnd(1, n_wU, 1).*R_wU.^(-alpha);
    
    
    % Power from associated Points
    P_c0_L = I_cL(C0_L_index);
    P_c0_U = I_cU(C0_U_index);
    
    P_w0_L = p_w*exprnd(1)*R0_w^(-alpha);
    P_w0_U = p_w*exprnd(1)*R0_w^(-alpha);
    
    
    % Unlicensed
    % 1. I_cU_total
    I_cU_total = sum(I_cU) + sum(I_z) + sum(I_wU) - P_c0_U;
    SINR_cU = P_c0_U/(noise_c + I_cU_total);
    SINR_cU_list = [SINR_cU_list; SINR_cU];
    
    % 2. I_wU_total
    I_wU_total = sum(I_cU) + sum(I_z) + sum(I_wU);
    SINR_wU = P_w0_U/(noise_w + I_wU_total);
    SINR_wU_list = [SINR_wU_list; SINR_wU];


    % Licensed
    % 1. I_cL_total
    I_cL_total = sum(I_cL) - P_c0_L;
    SINR_cL = P_c0_L/(noise_c + I_cL_total);
    SINR_cL_list = [SINR_cL_list; SINR_cL];
    
    % 2. I_wL_total
    I_wL_total = sum(I_wL);
    SINR_wL = P_w0_L/(noise_w + I_wL_total);
    SINR_wL_list = [SINR_wL_list; SINR_wL];
    
end

% Store the CDFs
[P_cU_sim, SINR_cU_range] = ecdf(SINR_cU_list);
[P_cL_sim, SINR_cL_range] = ecdf(SINR_cL_list);
[P_wU_sim, SINR_wU_range] = ecdf(SINR_wU_list);
[P_wL_sim, SINR_wL_range] = ecdf(SINR_wL_list);



%% Theoretical

beta = 2.0/alpha;
zeta_fun = @(x) 1./(1+x.^(alpha/2));

% Calculate
%   1. P_c,L
P_cL_list = [];
lambda_cL = lambda_c - delta_c*bar_lambda_c;

for gamma= 10.^([-5:10]/10)
    
    zeta_int = integral(@(x)zeta_fun(x), gamma^(-beta), Inf, 'ArrayValued', true);
    
    B = pi*lambda_cL*(1 + zeta_int);
    P_c_rL = @(r) pi*lambda_cL*exp( - B*r -(noise_c*gamma/p_c)*(r.^(alpha/2)) );
    
    P_cL = integral(@(r)P_c_rL(r), 0, Inf, 'ArrayValued', true);

    P_cL_list = [P_cL_list; P_cL];

end

%   2. P_c,U
P_cU_list = [];
lambda_cU = delta_c*bar_lambda_c;

for gamma= 10.^([-5:10]/10)
    
    zeta_int = integral(@(x)zeta_fun(x), gamma^(-beta), Inf, 'ArrayValued', true);

    B = pi*lambda_cU*(1 + zeta_int) + (pi/sinc(beta))*( delta_w*bar_lambda_w*(p_w^beta) + lambda_z*(p_z^beta) )*((gamma/p_c)^beta);


    P_c_rU = @(r) pi*lambda_cU*exp(-(noise_c*gamma/p_c)*(r.^(alpha/2)) - B*r);
    P_cU = integral(@(r)P_c_rU(r), 0, Inf, 'ArrayValued', true);

    P_cU_list = [P_cU_list; P_cU];

end

%   3. P_w,L
P_wL_list = [];

for gamma= 10.^([-5:10]/10)
    
    B = (pi/sinc(beta))*( (lambda_w - delta_w*bar_lambda_w)*(gamma^beta) );

    P_w_r = @(r) (1/(rho_w^2))*exp( -(noise_w*gamma/p_w)*(r.^(alpha/2)) - B*r);
    P_w = integral(@(r)P_w_r(r), 0, rho_w^2, 'ArrayValued', true);

    P_wL_list = [P_wL_list; P_w];

end

%   4. P_w,U

P_wU_list = [];

for gamma= 10.^([-5:10]/10)
    
    B = (pi/sinc(beta))*( delta_w*bar_lambda_w*(p_w.^beta) + delta_c*bar_lambda_c*(p_c^beta) + lambda_z*(p_z^beta) )*((gamma/p_w)^beta);

    P_w_r = @(r) (1/(rho_w^2))*exp( -(noise_w*gamma/p_w)*(r.^(alpha/2)) - B*r);
    P_w = integral(@(r)P_w_r(r), 0, rho_w^2, 'ArrayValued', true);

    P_wU_list = [P_wU_list; P_w];

end

%% Plot the Sim CDFs
figure(1);

subplot(2,2,1)
plot(10.*log10(SINR_cU_range), 1-P_cU_sim);
hold on;
plot([-5:10], P_cU_list, 'x');
ylabel('P_{c|U}(\gamma)')
xlabel('\gamma [dB]')
xlim([-5 10])
ylim([0 1])

subplot(2,2,2)
plot(10.*log10(SINR_cL_range), 1-P_cL_sim);
hold on;
plot([-5:10], P_cL_list, 'x');
ylabel('P_{c|L}(\gamma)')
xlabel('\gamma [dB]')
xlim([-5 10])
ylim([0 1])

subplot(2,2,3)
plot(10.*log10(SINR_wU_range), 1-P_wU_sim);
hold on;
plot([-5:10], P_wU_list, 'x');
ylabel('P_{w|U}(\gamma)')
xlabel('\gamma [dB]')
xlim([-5 10])
ylim([0 1])

subplot(2,2,4)
plot(10.*log10(SINR_wL_range), 1-P_wL_sim);
hold on;
plot([-5:10], P_wL_list, 'x');
ylabel('P_{w|L}(\gamma)')
xlabel('\gamma [dB]')
xlim([-5 10])
ylim([0 1])

%% Nearest BS distance [Verification: OK]
% figure(2);
% cdfplot(nearest_BS_U_list);
% hold on;
% cdfplot(nearest_BS_L_list);
% 
% syms x
% 
% fplot(1-exp(-pi*(delta_c*bar_lambda_c)*x^2), 'o-')
% fplot(1-exp(-pi*(lambda_c - delta_c*bar_lambda_c)*x^2), 'x-')
% 
% legend('Unlicensed: Sim','Licensed: Sim','Unlicensed: Theory','Licensed: Theory')
% xlim([0 400])
% xlabel('distance [m]')

%% Calculate Datarate



