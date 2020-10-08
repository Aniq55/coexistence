clc;
clear all

%% Load the tables
T_cell = readtable('D:\Coexistence\results\max_datarate\ratio_cell.csv');
T_wifi = readtable('D:\Coexistence\results\max_datarate\ratio_wifi.csv');

%% Boxplot: datarate ratio

figure(1);
boxplot([T_cell.ratio, T_wifi.ratio], ["cellular", "wifi"], 'Notch', 'on')
ylabel("r_j/{max r_j},      j \in \{c, w\}")
xlabel("Network")
ylim([0 1])
box on;

%% Scatter plot: Datarate

L = length(T_cell.r_c);

figure(2);
plot([1:L], T_cell.r_c*1e3, 'x');
hold on;
plot([1:L], T_wifi.r_w*1e3, 's');

xlabel('experiment')
ylabel('datarate [Mbps]')
xlim([0 L])
box on;
grid on;
legend('cellular', 'WiFi')

%% Lineplot: Datarate ratio

L = length(T_cell.r_c);

figure(3);
plot([1:L], T_cell.ratio, 'x-');
hold on;
plot([1:L], T_wifi.ratio, 's-');

xlabel('experiment')
ylabel("r_j/{max r_j},      j \in \{c, w\}")
xlim([0 L])
ylim([0 1])
box on;
grid on;
legend('cellular', 'WiFi')

%% Scatter plot: r_c vs r_w

figure(4);

scatter(T_cell.r_c, T_wifi.r_w, 'x');
hold on;
box on;
grid on;
plot([0 1], [0 1])
xlim([0 0.1])
ylim([0 0.2])

xlabel("r_c [Gbps]")
ylabel("r_w [Gbps]")



