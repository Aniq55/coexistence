function [arg_c, arg_w] = arg_min_2d(f, resolution)
    % argmin_{(delta_c, delta_w)} f
    [min1, argmin1] = min(f);
    argmin1 = min(argmin1);
    [min2, argmin2] = min(min1);

    % Best Response
    arg_w = (argmin2-1)*resolution;
    arg_c = (argmin1-1)*resolution;
    
end