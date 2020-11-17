function f_val = opt_fn1(v_c, v_w, r_c, r_w, ...
    r_c_min, r_w_min, theta_c, theta_w)
    % Maximum Darate
    
    if v_c ~= 0
        if v_w ~= 0
            f_val = (theta_c*r_c + theta_w*r_w )*(...
                r_c >= r_c_min)*(r_w >= r_w_min);
        else
            f_val = theta_c*r_c*(r_c >= r_c_min);
        end
    else
        if v_w ~= 0
            f_val = theta_w*r_w*(r_w >= r_w_min);
        end
    end

end

