classdef parameters
    properties   
        alpha;      % path-loss coefficient
        rho;        % radius of the exclusion zone
        rho_w;      % radius of the WiFi PCP disk

        % PPP Intensity
        lambda_z;
        lambda_c;
        lambda_w;
        
        % PHP intensity
        bar_lambda_c;
        bar_lambda_w;

        % Transmitter power
        p_z;
        p_c;
        p_w; 

        % Noise at receiver
        noise_c;
        noise_w;
        
        % Bandwidths
        B_cL;
        B_cU;
        B_wL;
        B_wU;

    end
    
    methods
        function obj = parameters(ALPHA, RHO, RHO_W, L_Z, L_C, L_W, ...
                        BARL_C, BAR_LW, POW_Z, POW_C, POW_W, NOISE_C, ...
                        NOISE_W, BAND_CL, BAND_CU, BAND_WL, BAND_WU)
            
            obj.alpha           = ALPHA;
            obj.rho             = RHO;
            obj.rho_w           = RHO_W;
            obj.lambda_z        = L_Z;
            obj.lambda_c        = L_C;
            obj.lambda_w        = L_W;
            obj.bar_lambda_c    = BARL_C;
            obj.bar_lambda_w    = BAR_LW;
            obj.p_z             = POW_Z;
            obj.p_c             = POW_C;
            obj.p_w             = POW_W;
            obj.noise_c         = NOISE_C;
            obj.noise_w         = NOISE_W;
            obj.B_cL            = BAND_CL;
            obj.B_cU            = BAND_CU;
            obj.B_wL            = BAND_WL;
            obj.B_wU            = BAND_WU;
        end
        
        function coverage_vector = coverage_probability(obj, SINR, delta_c, delta_w)
            % calculate and append the coverage probabilities here
            
            beta = 2.0/obj.alpha;
            lambda_wU = delta_w*obj.bar_lambda_w;
            lambda_wL = obj.lambda_w - lambda_wU;
            lambda_cU = delta_c*obj.bar_lambda_c;
            lambda_cL = obj.lambda_c - lambda_cU;
            
            
            zeta_fun = @(x) 1./(1+x.^(obj.alpha/2));
            zeta_int = integral(@(x)zeta_fun(x)*0.5*SINR^(2/obj.alpha), ...
                SINR^(-beta), Inf, 'ArrayValued', true);
            
            % P_c,L
            f_RL=@(r)2*pi*lambda_cL*r*exp(-pi*lambda_cL*r^2);
            L_IcL=@(r)exp(-2*pi*lambda_cL*r^2*zeta_int);

            P_cL=integral(@(r)f_RL(r)*exp( ... 
                -SINR*r^(obj.alpha)*obj.noise_c/obj.p_c)*L_IcL(r), ...
                0,inf,'ArrayValued',true);
            
            % P_c,U
            f_RU=@(r)2*pi*lambda_cU*r*exp(-pi*lambda_cU*r^2);
            L_IcU=@(r)exp(-2*pi*lambda_cU*r^2*zeta_int);
            L_Iwz = @(r)exp( ...
                -(pi/sinc(beta))*( delta_w*obj.bar_lambda_w*(obj.p_w^beta) ...
                + obj.lambda_z*(obj.p_z^beta) )*((SINR/obj.p_c)^beta)*r^2 );

            P_cU= integral(@(r)f_RU(r)*exp(...
                -SINR*r^(obj.alpha)*obj.noise_c/obj.p_c)*L_IcU(r)*L_Iwz(r), ...
                0, inf, 'ArrayValued', true  );
            
            % P_w,L
            B_L = (pi/sinc(beta))*( lambda_wL*(SINR^beta) );

            P_w_rL = @(r) (1/(obj.rho_w^2))*exp( ...
                -(obj.noise_w*SINR/obj.p_w)*(r.^(obj.alpha/2)) - B_L*r);
            P_wL = integral(@(r)P_w_rL(r), 0, obj.rho_w^2, 'ArrayValued', true);
            
            % P_w,U
            B_U = (pi/sinc(beta))*( lambda_wU*(obj.p_w.^beta) ...
                + delta_c*obj.bar_lambda_c*(obj.p_c^beta) ...
                + obj.lambda_z*(obj.p_z^beta) )*((SINR/obj.p_w)^beta);

            P_w_rU = @(r) (1/(obj.rho_w^2))*exp( ...
                -(obj.noise_w*SINR/obj.p_w)*(r.^(obj.alpha/2)) - B_U*r);
            P_wU = integral(@(r)P_w_rU(r), 0, obj.rho_w^2, 'ArrayValued', true);
            
            
            % Final output vector
            coverage_vector = [P_cL, P_cU, P_wL, P_wU];
        end
        
    end
end