function f_val = opt_fn2(v_c, v_w, r_c, r_w, ...
    r_c_min, r_w_min, delta_c, delta_w)
    
    r_c_min
    r_c
    
    
    if v_c ~= 0
        if v_w ~= 0
            f_val = delta_c + delta_w;
            
            if r_w < r_w_min || r_c < r_c_min
                f_val = 1e5;
            end
        else
            f_val = delta_c;
            if r_c < r_c_min
                f_val = 1e5;
            end
        end
    else
        if v_w > 0
            f_val = delta_w;
            if r_w < r_w_min
                f_val = 1e5;
            end
        end
    end
    
    
    

end

