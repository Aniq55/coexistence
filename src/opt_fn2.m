function f_val = opt_fn2(v_c, v_w, r_c, r_w, ...
    r_c_min, r_w_min, del_c, del_w, theta_c, theta_w)
    % Minimum Utilization
    
    if v_c ~= 0
        if v_w ~= 0
            f_val = 1 + theta_c*del_c + theta_w*del_w;
            
            one_sigma =  double((r_w >= r_w_min)*(r_c >= r_c_min));
               
            f_val = -f_val/(1 + one_sigma*(1 + theta_c + theta_w));
           
            
        else
            f_val = 1 + theta_c*del_c;
            
            one_sigma =  double(r_c >= r_c_min);
               
            f_val = -f_val/(1 + one_sigma*(1 + theta_c));
        end
    else
        if v_w ~= 0
            f_val = 1 + theta_w*del_w;
            
            one_sigma =  double(r_w >= r_w_min);
               
            f_val = -f_val/(1 + one_sigma*(1 + theta_w));
        end
    end

end

