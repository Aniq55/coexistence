classdef entity
    properties   
        v_c;        % share cellular
        v_w;        % share WiFi
        delta_c;    % unlicensed ratio cellular
        delta_w;    % unlicensed ratio WiFi
        r_c_min;    % min datarate cellular
        r_w_min;    % min datarate WiFi
    end
    
    methods
        function obj = entity(V_C, V_W, DELTA_C, DELTA_W, ...
                R_C_MIN, R_W_MIN)
            
            obj.v_c         = V_C;
            obj.v_w         = V_W;
            obj.delta_c     = DELTA_C;
            obj.delta_w     = DELTA_W;
            obj.r_c_min     = R_C_MIN;
            obj.r_w_min     = R_W_MIN;
            
        end
        
        function obj = best_response(obj, delta_c_rem, delta_w_rem, ...
                param, SINR)
            delta_range = [0:0.1:1];
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
                    X = param.coverage_probability( SINR, DELTA_C, DELTA_W)
                    % calculate datarate
                    r_c = 0;
                    r_w = 0;
                    
                    % calculare optimization function value
                    if obj.v_c > 0
                        if obj.v_w > 0
                            f(i,j) = r_c + r_w; % add weights
                        else
                            f(i,j) = r_c;
                        end
                    else
                        if obj.v_w > 0
                            f(i,j) = r_w;
                        end
                    end
                end
            end
            
            
            % argmax f
            obj.delta_c = 1; % update
            obj.delta_w = 1; % update
            
        end
    end
end