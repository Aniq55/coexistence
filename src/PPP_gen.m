% Poisson Point Process

function [r, theta] = PPP_gen(lambda, R)
    area = pi*R*R;
    n = poissrnd(lambda*area);
    r = zeros(n,1);
    theta = zeros(n,1);
    
    for i=1:n
        % draw uniform numbers
        sum = 0;
        for j=i:i
            sum = sum+ log(rand);
        end
        r(i) = sqrt(-(1/(pi*lambda))*sum);
        theta(i) = 2*pi*rand;
    end
end