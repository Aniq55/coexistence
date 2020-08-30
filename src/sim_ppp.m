L = 100*1e3;    % 100 km


lambda_Z = 10/1e9;   % Backhaul MBS
lambda_C = 20/1e9;   % cellular SBS
lambda_W = 40/1e9;   % WiFi APs

rho = 10;




[xz, yz] = PPP_gen_xy(lambda_Z, L, L);
[xc, yc] = PPP_gen_xy(lambda_C, L, L);
[xw, yw] = PPP_gen_xy(lambda_W, L, L);


figure(1);
hold on;

scatter(xz, yz);
scatter(xc, yc);
scatter(xw, yw);
legend('Incumbent User','Cellular BS','WiFi AP')







%%here we compute the distances between all the laser beam directors and the origin.
% distances_to_origin=abs(x+1j*y); 
 
%%here we search for the nearest oint to the origin (contact distance from the origin)
% nearest_point_index=find(distances_to_origin==min(distances_to_origin)); 

    

