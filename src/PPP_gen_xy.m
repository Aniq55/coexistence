
function [x, y] = PPP_gen_xy(lambda, Lx, Ly)
    area = Lx*Ly;
    n = poissrnd(lambda*area);
    
    % rectangle centred at origin
    x = Lx*rand(1,n) - (Lx/2)*ones(1,n);
    y = Ly*rand(1,n) - (Ly/2)*ones(1,n);
    
end