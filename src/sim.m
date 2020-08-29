[r, theta] = PPP_gen(0.01, 100);

x = r.*cos(theta);
y = r.*sin(theta);


scatter(x,y)