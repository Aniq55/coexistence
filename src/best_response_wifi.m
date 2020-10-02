function delta_w_star = best_response_wifi(delta_c, gamma, params)
    delta_resolution = 0.05;
    DELTA_RANGE = [0: delta_resolution : 1];
    r_w_list = [];
    for delta_w = [0: delta_resolution : 1]
        r_w_list = [r_w_list; datarate_wifi(delta_c, delta_w, gamma, params)];
    end
    [argvalue, argmax] = max(r_w_list);
    delta_val = DELTA_RANGE(argmax);
    delta_w_star = delta_val;
end