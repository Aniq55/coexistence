function r_w = datarate_wifi(delta_c, delta_w, gamma, PARAM)
    
    beta = 2.0/PARAM.alpha;
    lambda_wU = delta_w*PARAM.bar_lambda_w;
    lambda_wL = PARAM.lambda_w - lambda_wU;

    % P_w,L
    
    B_L = (pi/sinc(beta))*( lambda_wL*(gamma^beta) );

    P_w_rL = @(r) (1/(PARAM.rho_w^2))*exp( ...
        -(PARAM.noise_w*gamma/PARAM.p_w)*(r.^(PARAM.alpha/2)) - B_L*r);
    P_wL = integral(@(r)P_w_rL(r), 0, PARAM.rho_w^2, 'ArrayValued', true);

    % P_w,U

    B_U = (pi/sinc(beta))*( lambda_wU*(PARAM.p_w.^beta) ...
        + delta_c*PARAM.bar_lambda_c*(PARAM.p_c^beta) ...
        + PARAM.lambda_z*(PARAM.p_z^beta) )*((gamma/PARAM.p_w)^beta);

    P_w_rU = @(r) (1/(PARAM.rho_w^2))*exp( ...
        -(PARAM.noise_w*gamma/PARAM.p_w)*(r.^(PARAM.alpha/2)) - B_U*r);
    P_wU = integral(@(r)P_w_rU(r), 0, PARAM.rho_w^2, 'ArrayValued', true);

    % Calculate Datarate:
    ratio_unlicensed = lambda_wU/PARAM.lambda_w;
    
    r_w = log2(1 + gamma)*( PARAM.B_wL*P_wL*(1-ratio_unlicensed) ...
        + PARAM.B_wU*P_wU*ratio_unlicensed );

end