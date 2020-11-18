T =  readtable('D:\Coexistence\results\game\game_B.csv');
T.r_c1 = T.r_c1*1e3;
T.r_w1 = T.r_w1*1e3;
T.r_c2 = T.r_c2*1e3;
T.r_w2 = T.r_w2*1e3;

color_vec5 = ["#003f5c","#58508d","#bc5090","#ff6361","#ffa600",];

%%

figure('Position', [100 100 500 470]);

h = heatmap(T,'v_c1','v_w1','ColorVariable','r_c1', 'CellLabelColor','none');

xlabel('v_c^1')
ylabel('v_w^1')
title(h, '')
set(gca,'Fontsize', 16);


figure('Position', [700 100 500 470]);

h = heatmap(T,'v_c1','v_w1','ColorVariable','r_w1', 'CellLabelColor','none');

xlabel('v_c^1')
ylabel('v_w^1')
title(h, '')
set(gca,'Fontsize', 16);

%%

figure('Position', [100 500 500 470]);

h = heatmap(T,'v_c1','v_w1','ColorVariable','del_c1', 'CellLabelColor','none');

xlabel('v_c^1')
ylabel('v_w^1')
title(h, '')
set(gca,'Fontsize', 16);


figure('Position', [700 500 500 470]);

h = heatmap(T,'v_c1','v_w1','ColorVariable','del_w1', 'CellLabelColor','none');

xlabel('v_c^1')
ylabel('v_w^1')
title(h, '')
set(gca,'Fontsize', 16);

%%
% figure(1)
% 
% hold on;
% v_vec = [0.1, 0.3, 0.5, 0.7, 0.9];
% color_i = 1;
% for i = v_vec
%     x = T.v_w1(T.v_c1 == i);
%     y = T.r_c1(T.v_c1 == i)*1e3;
%     plot(x, y, 'x--', 'color', color_vec5(color_i), 'LineWidth', 1.5);
%     color_i = color_i + 1;
% end
% % ylim([33, 40])
% xlabel('v_w^1')
% ylabel('r_c^1 [Mbps]')
% leg1 = legend('0.1', '0.3', '0.5', '0.7', '0.9')
% title(leg1, 'v_c^1')
% box on;
% grid on;
% 
% 
% %%
% figure(2)
% 
% hold on;
% v_vec = [0.1, 0.3, 0.5, 0.7, 0.9];
% color_i = 1;
% for i = v_vec
%     x = T.v_w1(T.v_c1 == i);
%     y = T.r_w1(T.v_c1 == i)*1e3;
%     plot(x, y, 's--', 'color', color_vec5(color_i), 'LineWidth', 1.5);
%     color_i = color_i + 1;
% end
% % ylim([33, 40])
% xlabel('v_w^1')
% ylabel('r_w^1 [Mbps]')
% leg1 = legend('0.1', '0.3', '0.5', '0.7', '0.9')
% title(leg1, 'v_c^1')
% box on;
% grid on;

%%


