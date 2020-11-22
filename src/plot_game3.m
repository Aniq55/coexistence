T =  readtable('D:\Coexistence\results\game\game3_B.csv');
T.r_c1 = T.r_c1*1e3;
T.r_w1 = T.r_w1*1e3;
T.r_c2 = T.r_c2*1e3;
T.r_w2 = T.r_w2*1e3;
T.r_c3 = T.r_c3*1e3;
T.r_w3 = T.r_w3*1e3;

color_vec5 = ["#003f5c","#58508d","#bc5090","#ff6361","#ffa600",];

%%

% T1 = T(T.v_w1 == 0.2 & T.v_w2 == 0.3,:);

figure('Position', [100 100 1500 800]);

subplot(2,3, 1)
h = heatmap( T,'v_c1','v_c2','ColorVariable','r_c1', 'CellLabelColor','none');
xlabel('v_c^1')
ylabel('v_c^2')
title(h, '\sigma_c^1')
set(gca,'Fontsize', 16);

subplot(2,3, 2)
h = heatmap( T,'v_c1','v_c2','ColorVariable','r_c2', 'CellLabelColor','none');
xlabel('v_c^1')
ylabel('v_c^2')
title(h, '\sigma_c^2')
set(gca,'Fontsize', 16);

subplot(2,3, 3)
h = heatmap( T,'v_c1','v_c2','ColorVariable','r_c3', 'CellLabelColor','none');
xlabel('v_c^1')
ylabel('v_c^2')
title(h, '\sigma_c^3')
set(gca,'Fontsize', 16);


subplot(2,3, 4)
h = heatmap( T,'v_c1','v_c2','ColorVariable','r_w1', 'CellLabelColor','none');
xlabel('v_c^1')
ylabel('v_c^2')
title(h, '\sigma_w^1')
set(gca,'Fontsize', 16);

subplot(2,3, 5)
h = heatmap( T,'v_c1','v_c2','ColorVariable','r_w2', 'CellLabelColor','none');
xlabel('v_c^1')
ylabel('v_c^2')
title(h, '\sigma_w^2')
set(gca,'Fontsize', 16);

subplot(2,3, 6)
h = heatmap( T,'v_c1','v_c2','ColorVariable','r_w3', 'CellLabelColor','none');
xlabel('v_c^1')
ylabel('v_c^2')
title(h, '\sigma_w^3')
set(gca,'Fontsize', 16);

%%
figure('Position', [100 100 1500 800]);


subplot(2,3, 1)
h = heatmap( T,'v_w1','v_w2','ColorVariable','r_c1', 'CellLabelColor','none');
xlabel('v_w^1')
ylabel('v_w^2')
title(h, '\sigma_c^1')
set(gca,'Fontsize', 16);

subplot(2,3, 2)
h = heatmap( T,'v_w1','v_w2','ColorVariable','r_c2', 'CellLabelColor','none');
xlabel('v_w^1')
ylabel('v_w^2')
title(h, '\sigma_c^2')
set(gca,'Fontsize', 16);

subplot(2,3, 3)
h = heatmap( T,'v_w1','v_w2','ColorVariable','r_c3', 'CellLabelColor','none');
xlabel('v_w^1')
ylabel('v_w^2')
title(h, '\sigma_c^3')
set(gca,'Fontsize', 16);


subplot(2,3, 4)
h = heatmap( T,'v_w1','v_w2','ColorVariable','r_w1', 'CellLabelColor','none');
xlabel('v_w^1')
ylabel('v_w^2')
title(h, '\sigma_w^1')
set(gca,'Fontsize', 16);

subplot(2,3, 5)
h = heatmap( T,'v_w1','v_w2','ColorVariable','r_w2', 'CellLabelColor','none');
xlabel('v_w^1')
ylabel('v_w^2')
title(h, '\sigma_w^2')
set(gca,'Fontsize', 16);

subplot(2,3, 6)
h = heatmap( T,'v_w1','v_w2','ColorVariable','r_w3', 'CellLabelColor','none');
xlabel('v_w^1')
ylabel('v_w^2')
title(h, '\sigma_w^3')
set(gca,'Fontsize', 16);

%%
figure('Position', [100 100 500 470]);


h = heatmap( T,'v_c1','v_c2','ColorVariable','del_c1', 'CellLabelColor','none');
xlabel('v_w^1')
ylabel('v_w^2')
title(h, '\sigma_c^1')
set(gca,'Fontsize', 16);

%%
figure('Position', [100 100 1000 300]);

subplot(1,2,1)
hold on;

[h, x] = ecdf(T.r_c1);
plot(x,h, '--', 'LineWidth', 2, 'color', '#003f5c')

[h, x] = ecdf(T.r_c2);
plot(x,h, '.-', 'LineWidth', 2, 'color', '#7a5195')

[h, x] = ecdf(T.r_c3);
plot(x,h, '--', 'LineWidth', 2, 'color', '#ef5675')

xlabel('average cellular datarate \sigma_c^i [Mbps]')
ylabel('empirical cdf')
xlim([30, 42])
set(gca,'Fontsize', 12);
box on;
grid on;

legend('e_1', 'e_2', 'e_3', 'Location', 'northwest')


subplot(1,2,2)
hold on;

[h, x] = ecdf(T.r_w1);
plot(x,h, '--', 'LineWidth', 2, 'color', '#003f5c')

[h, x] = ecdf(T.r_w2);
plot(x,h, '.-', 'LineWidth', 2, 'color', '#7a5195')

[h, x] = ecdf(T.r_w3);
plot(x,h, '--', 'LineWidth', 2, 'color', '#ef5675')

xlabel('average WiFi datarate \sigma_w^i [Mbps]')
ylabel('empirical cdf')
xlim([140, 200])
set(gca,'Fontsize', 12);
box on;
grid on;

legend('e_1', 'e_2', 'e_3', 'Location', 'northwest')







