
function [r, theta] = PPP_gen2(lambda, R)
    area = pi*R*R;
    n = poissrnd(lambda*area);
    
    theta = 2*pi*(rand(n,1));
    r = R*sqrt(rand(n,1));
end




 
