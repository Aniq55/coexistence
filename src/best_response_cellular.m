function delta_c_star = best_response_cellular(delta_w, gamma, params)
    delta_resolution = 0.05;
    DELTA_RANGE = [0: delta_resolution : 1];
    r_c_list = [];
    for delta_c = [0: delta_resolution : 1]
        r_c_list = [r_c_list; datarate_cellular(delta_c, delta_w, gamma, params)];
    end
    [argvalue, argmax] = max(r_c_list);
    delta_val = DELTA_RANGE(argmax);
    delta_c_star = delta_val;
end