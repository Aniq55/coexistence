function P_cov_vectors = coverage(delta_c, delta_w, GAMMA, PARAM)
    
    beta = 2.0/PARAM.alpha;
    lambda_wU = delta_w*PARAM.bar_lambda_w;
    lambda_wL = PARAM.lambda_w - lambda_wU;
    lambda_cU = delta_c*PARAM.bar_lambda_c;
    lambda_cL = PARAM.lambda_c - lambda_cU;
    
    P_wL_list = [];
    P_wU_list = [];
    P_cL_list = [];
    P_cU_list = [];
    
    for gamma= GAMMA
        % P_w,L

        B_L = (pi/sinc(beta))*( lambda_wL*(gamma^beta) );

        P_w_rL = @(r) (1/(PARAM.rho_w^2))*exp( ...
            -(PARAM.noise_w*gamma/PARAM.p_w)*(r.^(PARAM.alpha/2)) - B_L*r);
        P_wL = integral(@(r)P_w_rL(r), 0, PARAM.rho_w^2, 'ArrayValued', true);
        P_wL_list = [P_wL_list; P_wL];

        % P_w,U

        B_U = (pi/sinc(beta))*( lambda_wU*(PARAM.p_w.^beta) ...
            + delta_c*PARAM.bar_lambda_c*(PARAM.p_c^beta) ...
            + PARAM.lambda_z*(PARAM.p_z^beta) )*((gamma/PARAM.p_w)^beta);

        P_w_rU = @(r) (1/(PARAM.rho_w^2))*exp( ...
            -(PARAM.noise_w*gamma/PARAM.p_w)*(r.^(PARAM.alpha/2)) - B_U*r);
        P_wU = integral(@(r)P_w_rU(r), 0, PARAM.rho_w^2, 'ArrayValued', true);
        P_wU_list = [P_wU_list; P_wU];

        zeta_fun = @(x) 1./(1+x.^(PARAM.alpha/2));
        zeta_int = integral(@(x)zeta_fun(x)*0.5*gamma^(2/PARAM.alpha), ...
            gamma^(-beta), Inf, 'ArrayValued', true);
        
        
        
        % P_c,L

        f_RL=@(r)2*pi*lambda_cL*r*exp(-pi*lambda_cL*r^2);
        L_IcL=@(r)exp(-2*pi*lambda_cL*r^2*zeta_int);

        P_cL=integral(@(r)f_RL(r)*exp(-gamma*r^(PARAM.alpha)*PARAM.noise_c/PARAM.p_c)*L_IcL(r), ...
            0,inf,'ArrayValued',true);
        P_cL_list = [P_cL_list; P_cL];
        
        % P_c,U

        f_RU=@(r)2*pi*lambda_cU*r*exp(-pi*lambda_cU*r^2);
        L_IcU=@(r)exp(-2*pi*lambda_cU*r^2*zeta_int);
        L_Iwz = @(r)exp( -(pi/sinc(beta))*( delta_w*PARAM.bar_lambda_w*(PARAM.p_w^beta) ...
            + PARAM.lambda_z*(PARAM.p_z^beta) )*((gamma/PARAM.p_c)^beta)*r^2 );

        P_cU= integral(@(r)f_RU(r)*exp(-gamma*r^(PARAM.alpha)*PARAM.noise_c/PARAM.p_c)*L_IcU(r)*L_Iwz(r), ...
            0, inf, 'ArrayValued', true  );
        P_cU_list = [P_cU_list; P_cU];

        
    end
    
    
    % Generating the final matrix
    P_cov_vectors = [P_wL_list, P_wU_list, P_cL_list, P_cU_list];

end