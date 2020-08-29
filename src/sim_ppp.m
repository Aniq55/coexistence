R = 100;

lambda_Z = 0.001;   % Backhaul MBS
lambda_C = 0.002;    % cellular SBS
lambda_W = 0.005;    % WiFi APs

rho = 10;


[r_Z, theta_Z] = PPP_gen(lambda_Z, R);
[r_C, theta_C] = PPP_gen(lambda_C, R);
[r_W, theta_W] = PPP_gen(lambda_W, R);


figure(1);
polar(theta_Z, r_Z, 'k^')
hold on;
polar(theta_C, r_C, 'bx')
polar(theta_W, r_W, 'r+')
legend('Incumbent User','Cellular BS','WiFi AP')


[r_Z, theta_Z] = PPP_gen2(lambda_Z, R);
[r_C, theta_C] = PPP_gen2(lambda_C, R);
[r_W, theta_W] = PPP_gen2(lambda_W, R);

figure(2);
polar(theta_Z, r_Z, 'k^')
hold on;
polar(theta_C, r_C, 'bx')
polar(theta_W, r_W, 'r+')
legend('Incumbent User','Cellular BS','WiFi AP')