classdef entity
    properties   
        v_c;        % share cellular
        v_w;        % share WiFi
        delta_c;    % unlicensed ratio cellular
        delta_w;    % unlicensed ratio WiFi
        r_c_min;    % min datarate cellular
        r_w_min;    % min datarate WiFi
        theta_c;    % weight preference for cellular network
        theta_w;    % weight preference for WiFi network
        r_c;        % datarate cellular
        r_w;        % datarate WiFi
    end
    
    methods
        function obj = entity(V_C, V_W, DELTA_C, DELTA_W, ...
                R_C_MIN, R_W_MIN, THETA_C, THETA_W)
            
            obj.v_c         = V_C;
            obj.v_w         = V_W;
            obj.delta_c     = DELTA_C;
            obj.delta_w     = DELTA_W;
            obj.r_c_min     = R_C_MIN;
            obj.r_w_min     = R_W_MIN;
            obj.theta_c     = THETA_C;
            obj.theta_w     = THETA_W;
            obj.r_c         = 0;
            obj.r_w         = 0;
            
        end
        
        function obj = update_datarate(obj, delta_c_rem, delta_w_rem, ...
                param, SINR)
            
            DELTA_C = delta_c_rem + obj.v_c*obj.delta_c;
            DELTA_W = delta_w_rem + obj.v_w*obj.delta_w;

            % coverage probability
            [P_cL, P_cU, P_wL, P_wU] = param.coverage_probability( SINR, DELTA_C, DELTA_W);
            
            % unclisenced fraction
            frac_cU = obj.delta_c*param.bar_lambda_c/param.lambda_c;
            frac_wU = obj.delta_w*param.bar_lambda_w/param.lambda_w;

            % calculate datarate
            if obj.v_c ~= 0
                obj.r_c = (param.B_cU*P_cU*frac_cU ...
                    + param.B_cL*P_cL*(1- frac_cU))*log2(1+ SINR);
            end

            if obj.v_w ~= 0
                obj.r_w = (param.B_wU*P_wU*frac_wU ...
                + param.B_wL*P_wL*(1- frac_wU))*log2(1+ SINR);
            end
        end
        
        function obj = best_response(obj, delta_c_rem, delta_w_rem, ...
                param, SINR)
            
            delta_resolution = 0.1;
            delta_range = [0:delta_resolution:1];
            L = length(delta_range);
            f = zeros(L,L);
            
            % solve the optimization problem here
            for i = 1:L
                del_c = delta_range(i);
                for j = 1:L
                    del_w = delta_range(j);
                    % code here
                    DELTA_C = delta_c_rem + obj.v_c*del_c;
                    DELTA_W = delta_w_rem + obj.v_w*del_w;
                    
                    % coverage probability
                    [P_cL, P_cU, P_wL, P_wU] = param.coverage_probability( SINR, DELTA_C, DELTA_W);
                               
                    % unclisenced fraction
                    frac_cU = del_c*param.bar_lambda_c/param.lambda_c;
                    frac_wU = del_w*param.bar_lambda_w/param.lambda_w;
                    
                    % calculate datarate
                    if obj.v_c ~= 0
                        obj.r_c = (param.B_cU*P_cU*frac_cU ...
                            + param.B_cL*P_cL*(1- frac_cU))*log2(1+ SINR);
                    end
                    
                    if obj.v_w ~= 0
                        obj.r_w = (param.B_wU*P_wU*frac_wU ...
                        + param.B_wL*P_wL*(1- frac_wU))*log2(1+ SINR);
                    end
                    
                    % calculate optimization function value
                    
                    % f_A
                    f(i,j) =  opt_fn1(obj.v_c, obj.v_w, obj.r_c, obj.r_w, ...
                        obj.r_c_min, obj.r_w_min, obj.theta_c, obj.theta_w);
                    
                    % f_B
%                     f(i,j) =  opt_fn2(obj.v_c, obj.v_w, obj.r_c, obj.r_w, ...
%                         obj.r_c_min, obj.r_w_min, del_c, del_w, ...
%                         obj.theta_c, obj.theta_w);
                end
            end
            
            % argmax/argmin as per the opt_fn
            [obj.delta_c, obj.delta_w] = arg_max_2d(f, delta_resolution);
            
        end
    end
end