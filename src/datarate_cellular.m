function r_c = datarate_cellular(delta_w, delta_c, gamma, PARAM)
    
    beta = 2.0/PARAM.alpha;
    lambda_cU = delta_c*PARAM.bar_lambda_c;
    lambda_cL = PARAM.lambda_c - lambda_cU;

    zeta_fun = @(x) 1./(1+x.^(PARAM.alpha/2));
    zeta_int = integral(@(x)zeta_fun(x)*0.5*gamma^(2/PARAM.alpha), ...
        gamma^(-beta), Inf, 'ArrayValued', true);

    % P_c,L

    f_RL=@(r)2*pi*lambda_cL*r*exp(-pi*lambda_cL*r^2);
    L_IcL=@(r)exp(-2*pi*lambda_cL*r^2*zeta_int);

    P_cL=integral(@(r)f_RL(r)*exp(-gamma*r^(PARAM.alpha)*PARAM.noise_c/PARAM.p_c)*L_IcL(r), ...
        0,inf,'ArrayValued',true);

    % P_c,U

    f_RU=@(r)2*pi*lambda_cU*r*exp(-pi*lambda_cU*r^2);
    L_IcU=@(r)exp(-2*pi*lambda_cU*r^2*zeta_int);
    L_Iwz = @(r)exp( -(pi/sinc(beta))*( delta_w*PARAM.bar_lambda_w*(PARAM.p_w^beta) ...
        + PARAM.lambda_z*(PARAM.p_z^beta) )*((gamma/PARAM.p_c)^beta)*r^2 );

    P_cU= integral(@(r)f_RU(r)*exp(-gamma*r^(PARAM.alpha)*PARAM.noise_c/PARAM.p_c)*L_IcU(r)*L_Iwz(r), ...
        0, inf, 'ArrayValued', true  );

    % Calculate Datarate:
    ratio_unlicensed = lambda_cU/PARAM.lambda_c;
    
    r_c = log2(1 + gamma)*( PARAM.B_cL*P_cL*(1-ratio_unlicensed) ...
        + PARAM.B_cU*P_cU*ratio_unlicensed );

end