% Creating a class to store all constants



% Define datarate as functions
gamma = 1;

% cellular

% INPUTS: delta_c, delta_w, gamma, alpha, lambda_c, bar_lambda_c, lambda_w, bar_lambda_w, lambda_z, noise_c, p_c, p_w, p_z
% delta_c, delta_w
% gamma, alpha
% lambda_c, lambda_w, lambda_z = LAMBDA
% bar_lambda_c, bar_lambda_w = BAR_LAMBDA
% p_c, p_w, p_z = TX_POWER
% noise_c
% B_cL, B_cU = BANDWIDTH_CELLULAR

beta = 2.0/alpha;
lambda_cU = delta_c*bar_lambda_c;
lambda_cL = lambda_c - lambda_cU;

zeta_fun = @(x) 1./(1+x.^(alpha/2));
zeta_int = integral(@(x)zeta_fun(x)*0.5*gamma^(2/alpha), gamma^(-beta), Inf, 'ArrayValued', true);

%   1. P_c,L
    
f_RL=@(r)2*pi*lambda_cL*r*exp(-pi*lambda_cL*r^2);
L_IcL=@(r)exp(-2*pi*lambda_cL*r^2*zeta_int);

P_cL=integral(@(r)f_RL(r)*exp(-gamma*r^(alpha)*noise_c/p_c)*L_IcL(r),0,inf,'ArrayValued',true);

%   2. P_c,U

f_RU=@(r)2*pi*lambda_cU*r*exp(-pi*lambda_cU*r^2);
L_IcU=@(r)exp(-2*pi*lambda_cU*r^2*zeta_int);
L_Iwz = @(r)exp( -(pi/sinc(beta))*( delta_w*bar_lambda_w*(p_w^beta) + lambda_z*(p_z^beta) )*((gamma/p_c)^beta)*r^2 );

P_cU= integral(@(r)f_RU(r)*exp(-gamma*r^(alpha)*noise_c/p_c)*L_IcU(r)*L_Iwz(r), 0, inf, 'ArrayValued', true  );
    

% WiFi

% Run nested loops:

% 1. Find delta_c_star against delta_w

% 2. Find delta_w_star against delta_c
