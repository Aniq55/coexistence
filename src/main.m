clc;

clear all;

%% Define all constants

% Environment
L = 10*1e3;     % 10 km
alpha = 3;      % path-loss coefficient

% Incumbent Users
lambda_z = 1/1e6;
rho = 100;      % radius of the exclusion zone
p_z = 2;        % transmit power

% Cellular Network
lambda_c = 20/1e6;
p_c = 2;        % transmit power
noise_c= 1e-15; % receiver thermal noise
delta_c = 0.5;


% WiFi Network
lambda_w = 40/1e6;
rho_w = 20;     % radius of the WiFi PCP disk
p_w = 2;        % transmit power
noise_w= 1e-14; % receiver thermal noise
delta_w = 0.5;
prob_R_w = makedist('Triangular','a',0,'b',rho_w,'c',rho_w);


%% Simulation

n_iterations = 10;

SINR_cU_list = [];
SINR_cL_list = [];
SINR_wU_list = [];
SINR_wL_list = [];


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

            if rand > delta_c
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

            if rand > delta_w
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

% Plot the CDFs



%% Theoretical

% Calculate:
%   1. P_c,L
%   2. P_c,U
%   3. P_w,L
%   4. P_w,U


%% Calculate Datarate


