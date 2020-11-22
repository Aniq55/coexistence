%% Boxplot: datarate vs theta_c/theta_w

T1 =  readtable('D:\Coexistence\results\game\game_A_1.csv');
T2 =  readtable('D:\Coexistence\results\game\game_A_2.csv');
T3 =  readtable('D:\Coexistence\results\game\game_A_3.csv');
T4 =  readtable('D:\Coexistence\results\game\game_A_4.csv');
T5 =  readtable('D:\Coexistence\results\game\game_A_5.csv');
T6 =  readtable('D:\Coexistence\results\game\game_A_6.csv');
T7 =  readtable('D:\Coexistence\results\game\game_A_7.csv');





%%

cellular_datarates = [T1.r_c1, T2.r_c1, T3.r_c1, ...
    T4.r_c1, T5.r_c1, T6.r_c1, T7.r_c1]*1e3;

wifi_datarates = [T1.r_w1, T2.r_w1, T3.r_w1, ...
    T4.r_w1, T5.r_w1, T6.r_w1, T7.r_w1]*1e3;

delta_c_list = [T1.del_c1, T2.del_c1, T3.del_c1, ...
    T4.del_c1, T5.del_c1, T6.del_c1, T7.del_c1];

delta_w_list = [T1.del_w1, T2.del_w1, T3.del_w1, ...
    T4.del_w1, T5.del_w1, T6.del_w1, T7.del_w1];


%%
font_size_val = 12;
figure('Position', [100 100 700 300]);


subplot(1,2,1)
box1 = boxplot(cellular_datarates, ...
    'Notch', 'off', 'BoxStyle', 'filled', 'colors', 'g');
box on;
grid on;
xlabel('\theta_c/\theta_w');
ylabel('Cellular datarate [Mbps]')
set(box1, 'Color', '#955196');
h = findobj(box1,'tag','Outliers');
set(h,'MarkerEdgeColor', 'k');
set(gca, 'FontSize', font_size_val);


subplot(1,2,2)
box2 = boxplot(wifi_datarates, ...
    'Notch', 'off', 'BoxStyle', 'filled', 'colors', 'r');

box on;
grid on;
xlabel('\theta_c/\theta_w');
ylabel('WiFi datarate [Mbps]')
set(box2, 'Color', '#dd5182');
h = findobj(box2,'tag','Outliers');
set(h,'MarkerEdgeColor', 'k');
set(gca, 'FontSize', font_size_val);


%%
font_size_val = 12;
figure('Position', [100 100 700 300]);


subplot(1,2,1)
box1 = boxplot(delta_c_list, ...
    'Notch', 'off', 'BoxStyle', 'filled', 'colors', 'g');
box on;
grid on;
xlabel('\theta_c/\theta_w');
ylabel('\delta_c^1')
set(box1, 'Color', '#955196');
h = findobj(box1,'tag','Outliers');
set(h,'MarkerEdgeColor', 'k');
set(gca, 'FontSize', font_size_val);


subplot(1,2,2)
box2 = boxplot(delta_w_list, ...
    'Notch', 'off', 'BoxStyle', 'filled', 'colors', 'r');

box on;
grid on;
xlabel('\theta_c/\theta_w');
ylabel('\delta_w^1')
set(box2, 'Color', '#dd5182');
h = findobj(box2,'tag','Outliers');
set(h,'MarkerEdgeColor', 'k');
set(gca, 'FontSize', font_size_val);












