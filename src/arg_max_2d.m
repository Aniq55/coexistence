function [arg_c, arg_w] = arg_max_2d(f, resolution)
    % argmax_{(delta_c, delta_w)} f
    [max1, argmax1] = max(f);
    argmax1 = max(argmax1);
    [max2, argmax2] = max(max1);

    % Best Response
    arg_w = (argmax2-1)*resolution;
    arg_c = (argmax1-1)*resolution;
    max2
end