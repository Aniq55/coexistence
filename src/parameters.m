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
        
    end
end