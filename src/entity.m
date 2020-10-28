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
            
        end
        
        function obj = best_response(obj, delta_c_rem, delta_w_rem, ...
                param, SINR)
            
            delta_resolution = 0.25;
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
                    X = param.coverage_probability( SINR, DELTA_C, DELTA_W);
                    
                    % coverage probability
                    P_cL = X(:,1);
                    P_cU = X(:,2);
                    P_wL = X(:,3);
                    P_wU = X(:,4);
                                      
                    % unclisenced fraction
                    frac_cU = del_c*param.bar_lambda_c/param.lambda_c;
                    frac_wU = del_w*param.bar_lambda_w/param.lambda_w;
                    
                    % calculate datarate
                    r_c = (param.B_cU*P_cU*frac_cU ...
                        + param.B_cL*P_cL*(1- frac_cU))*log2(1+ SINR);
                    r_w = (param.B_wU*P_wU*frac_wU ...
                        + param.B_wL*P_wL*(1- frac_wU))*log2(1+ SINR);
                    
                    obj.r_c = r_c*(obj.v_c > 0);
                    obj.r_w = r_w*(obj.v_w > 0);
                    
                    % calculate optimization function value
                    % opt_fn(v_c, v_w, r_c, r_w, r_c_min, r_w_min, theta_c, theta_w)
                    if obj.v_c > 0
                        if obj.v_w > 0
                            f(i,j) = obj.theta_c*r_c*(r_c >= obj.r_c_min) ...
                                + obj.theta_w*r_w*(r_w >= obj.r_w_min);
                        else
                            f(i,j) = obj.theta_c*r_c;
                        end
                    else
                        if obj.v_w > 0
                            f(i,j) = obj.theta_w*r_w;
                        end
                    end
                    
                end
            end
                     
            % argmax_{(delta_c, delta_w)} f
            [max1, argmax1] = max(f);
            argmax1 = max(argmax1);
            [max2, argmax2] = max(max1);
            
            % Best Response
            obj.delta_c = (argmax1-1)*delta_resolution;
            obj.delta_w = (argmax2-1)*delta_resolution;
            
        end
    end
end