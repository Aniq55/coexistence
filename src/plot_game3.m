T =  readtable('D:\Coexistence\results\game\game3_A.csv');
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
