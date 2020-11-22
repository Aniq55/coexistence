% Histogram/ECDF of datarates
T1 =  readtable('D:\Coexistence\results\game\game_thresh_03_1.csv');
T2 =  readtable('D:\Coexistence\results\game\game_thresh_03_15.csv');
T3 =  readtable('D:\Coexistence\results\game\game_thresh_03_18.csv');

T4 =  readtable('D:\Coexistence\results\game\game_thresh_05_1.csv');
T5 =  readtable('D:\Coexistence\results\game\game_thresh_05_15.csv');
T6 =  readtable('D:\Coexistence\results\game\game_thresh_05_18.csv');


%% Colors
color1 = "#003f5c";
color2 = "#444e86";
color3 = "#955196";
color4 = "#dd5182";
color5 = "#ff6e54";
color6 = "#ffa600";

%% Cellular Datarate (CDF)

figure('Position', [100 100 700 350]);

hold on;

% min sigma_c = 30 Mbps
[h, x] = ecdf(T1.r_c1*1e3);
plot(x,h, 'x-', 'LineWidth', 1.5, 'color', color1)

[h, x] = ecdf(T2.r_c1*1e3);
plot(x,h, 'x-', 'LineWidth', 1.5, 'color', color2)

[h, x] = ecdf(T3.r_c1*1e3);
plot(x,h, 'O-', 'LineWidth', 1.5, 'color', color3)

% min sigma_c = 50 Mbps
[h, x] = ecdf(T4.r_c1*1e3);
plot(x,h, 'x--', 'LineWidth', 1.5, 'color', color4)

[h, x] = ecdf(T5.r_c1*1e3);
plot(x,h, 'x--', 'LineWidth', 1.5, 'color', color5)

[h, x] = ecdf(T6.r_c1*1e3);
plot(x,h, 'x--', 'LineWidth', 1.5, 'color', color6)


xlabel('average cellular datarate [Mbps]')
ylabel('empirical CDF')
% xlim([30, 42])
set(gca,'Fontsize', 12);
box on;
grid on;

leg1 = legend('30, 100', '30, 150', '30, 180',...
    '50, 100', '50, 150', '50, 180', ...
    'Location', 'northwest');

title(leg1, '$$ \hat{\sigma}_c, \hat{\sigma}_w $$ [Mbps]', 'Interpreter', 'Latex')


%% WiFi Datarate (CDF)

figure('Position', [100 100 700 350]);

hold on;

% min sigma_c = 30 Mbps
[h, x] = ecdf(T1.r_w1*1e3);
plot(x,h, 'x-', 'LineWidth', 1.5, 'color', color1)

[h, x] = ecdf(T2.r_w1*1e3);
plot(x,h, 'x-', 'LineWidth', 1.5, 'color', color2)

[h, x] = ecdf(T3.r_w1*1e3);
plot(x,h, 'O-', 'LineWidth', 1.5, 'color', color3)

% min sigma_c = 50 Mbps
[h, x] = ecdf(T4.r_w1*1e3);
plot(x,h, 'x--', 'LineWidth', 1.5, 'color', color4)

[h, x] = ecdf(T5.r_w1*1e3);
plot(x,h, 'x--', 'LineWidth', 1.5, 'color', color5)

[h, x] = ecdf(T6.r_w1*1e3);
plot(x,h, 'x--', 'LineWidth', 1.5, 'color', color6)

xlim([50, 500])
xlabel('average WiFi datarate [Mbps]')
ylabel('empirical CDF')
% xlim([30, 42])
set(gca,'Fontsize', 12);
box on;
grid on;

leg1 = legend('30, 100', '30, 150', '30, 180',...
    '50, 100', '50, 150', '50, 180', ...
    'Location', 'northwest');

title(leg1, '$$ \hat{\sigma}_c, \hat{\sigma}_w $$ [Mbps]', 'Interpreter', 'Latex')


%% WiFi Delta (Boxplot)
font_size_val = 12;
figure('Position', [100 100 700 300]);


subplot(1,2,1)
box1 = boxplot([T1.del_w1, T2.del_w1, T3.del_w1], ...
    'Labels', {'100', '150', '180'}, ...
    'Notch', 'off', 'BoxStyle', 'filled', 'colors', 'g');
box on;
grid on;
xlabel('$$\hat{\sigma}_w$$ [Mbps]', 'Interpreter', 'latex');
ylabel('\delta_w^1')
set(box1, 'Color', '#955196');
h = findobj(box1,'tag','Outliers');
set(h,'MarkerEdgeColor', 'k');
set(gca, 'FontSize', font_size_val);

subplot(1,2,2)
box1 = boxplot([T4.del_w1, T5.del_w1, T6.del_w1], ...
    'Labels', {'100', '150', '180'}, ...
    'Notch', 'off', 'BoxStyle', 'filled', 'colors', 'g');
box on;
grid on;
xlabel('$$\hat{\sigma}_w$$ [Mbps]', 'Interpreter', 'latex');
ylabel('\delta_w^1')
set(box1, 'Color', '#955196');
h = findobj(box1,'tag','Outliers');
set(h,'MarkerEdgeColor', 'k');
set(gca, 'FontSize', font_size_val);

%%

fig = figure(1);
subplot(6,1,1)
histogram(T1.del_w1, 20, 'Normalization', 'probability');
xlim([0, 1])

subplot(6,1,2)
histogram(T2.del_w1, 20, 'Normalization', 'probability');
xlim([0, 1])

subplot(6,1,3)
histogram(T3.del_w1, 20, 'Normalization', 'probability');
xlim([0, 1])

subplot(6,1,4)
histogram(T4.del_w1, 20, 'Normalization', 'probability');
xlim([0, 1])

subplot(6,1,5)
histogram(T5.del_w1, 20, 'Normalization', 'probability');
xlim([0, 1])

subplot(6,1,6)
histogram(T6.del_w1, 20, 'Normalization', 'probability');
xlim([0, 1])

ax = axes(fig);
han = gca;
han.Visible = 'off';
han.XLabel.Visible = 'on';
han.YLabel.Visible = 'on';
xlabel('\delta')
ylabel('P(\delta_w^1 = \delta)')

%% WiFi datarate vs. WiFi Network share

fig = figure('Position', [100 100 700 400]);


subplot(2,3,1)
box on;
plot(fitlm(T1,'r_w1 ~ v_w1'))
set(legend(), 'visible', 'off')
ylabel(''); xlabel(''); title('');
dim = [0.25 0.95 0 0];
str = {'$$\hat{\sigma}_c = 30$$', '$$\hat{\sigma}_w= 100$$', '(Mbps)'};
annotation('textbox', dim, 'BackgroundColor', 'white', 'EdgeColor', 'k', ...
    'String',str,'FitBoxToText','on', 'Interpreter', 'Latex');
set(gca,'Fontsize', font_size_val);

subplot(2,3,2)
box on;
plot(fitlm(T2,'r_w1 ~ v_w1'))
set(legend(), 'visible', 'off')
ylabel(''); xlabel(''); title('');
dim = [0.53 0.95 0 0];
str = {'$$\hat{\sigma}_c = 30$$', '$$\hat{\sigma}_w= 150$$', '(Mbps)'};
annotation('textbox', dim, 'BackgroundColor', 'white', 'EdgeColor', 'k', ...
    'String',str,'FitBoxToText','on', 'Interpreter', 'Latex');
set(gca,'Fontsize', font_size_val);

subplot(2,3,3)
box on;
plot(fitlm(T3,'r_w1 ~ v_w1'))
set(legend(), 'visible', 'off')
ylabel(''); xlabel(''); title('');
dim = [0.81 0.95 0 0];
str = {'$$\hat{\sigma}_c = 30$$', '$$\hat{\sigma}_w= 180$$', '(Mbps)'};
annotation('textbox', dim, 'BackgroundColor', 'white', 'EdgeColor', 'k', ...
    'String',str,'FitBoxToText','on', 'Interpreter', 'Latex');
set(gca,'Fontsize', font_size_val);

subplot(2,3,4)
box on;
plot(fitlm(T4,'r_w1 ~ v_w1'))
set(legend(), 'visible', 'off')
ylabel(''); xlabel(''); title('');
dim = [0.25 0.5 0 0];
str = {'$$\hat{\sigma}_c = 50$$', '$$\hat{\sigma}_w= 100$$', '(Mbps)'};
annotation('textbox', dim, 'BackgroundColor', 'white', 'EdgeColor', 'k', ...
    'String',str,'FitBoxToText','on', 'Interpreter', 'Latex');
set(gca,'Fontsize', font_size_val);

subplot(2,3,5)
box on;
plot(fitlm(T5,'r_w1 ~ v_w1'))
set(legend(), 'visible', 'off')
ylabel(''); xlabel(''); title('');
dim = [0.53 0.5 0 0];
str = {'$$\hat{\sigma}_c = 50$$', '$$\hat{\sigma}_w= 150$$', '(Mbps)'};
annotation('textbox', dim, 'BackgroundColor', 'white', 'EdgeColor', 'k', ...
    'String',str,'FitBoxToText','on', 'Interpreter', 'Latex');
set(gca,'Fontsize', font_size_val);

subplot(2,3,6)
box on;
plot(fitlm(T6,'r_w1 ~ v_w1'))
set(legend(), 'visible', 'off')
ylabel(''); xlabel(''); title('');
dim = [0.81 0.5 0 0];
str = {'$$\hat{\sigma}_c = 50$$', '$$\hat{\sigma}_w= 180$$', '(Mbps)'};
annotation('textbox', dim, 'BackgroundColor', 'white', 'EdgeColor', 'k', ...
    'String',str,'FitBoxToText','on', 'Interpreter', 'Latex');
set(gca,'Fontsize', font_size_val);

ax = axes(fig);
han = gca;
han.Visible = 'off';
han.XLabel.Visible = 'on';
han.YLabel.Visible = 'on';
xlabel('WiFi netowrk share v_w^1')
ylabel('Average WiFi datarate\sigma_w^1 [Gbps]')
set(gca,'Fontsize', font_size_val);

%% Cellular datarate vs. WiFi Network share

fig = figure('Position', [100 100 700 400]);


subplot(2,3,1)
box on;
plot(fitlm(T1,'r_c1 ~ v_w1'))
set(legend(), 'visible', 'off')
ylabel(''); xlabel(''); title('');
dim = [0.25 0.95 0 0];
str = {'$$\hat{\sigma}_c = 30$$', '$$\hat{\sigma}_w= 100$$', '(Mbps)'};
annotation('textbox', dim, 'BackgroundColor', 'white', 'EdgeColor', 'k', ...
    'String',str,'FitBoxToText','on', 'Interpreter', 'Latex');
set(gca,'Fontsize', font_size_val);

subplot(2,3,2)
box on;
plot(fitlm(T2,'r_c1 ~ v_w1'))
set(legend(), 'visible', 'off')
ylabel(''); xlabel(''); title('');
dim = [0.53 0.95 0 0];
str = {'$$\hat{\sigma}_c = 30$$', '$$\hat{\sigma}_w= 150$$', '(Mbps)'};
annotation('textbox', dim, 'BackgroundColor', 'white', 'EdgeColor', 'k', ...
    'String',str,'FitBoxToText','on', 'Interpreter', 'Latex');
set(gca,'Fontsize', font_size_val);

subplot(2,3,3)
box on;
plot(fitlm(T3,'r_c1 ~ v_w1'))
set(legend(), 'visible', 'off')
ylabel(''); xlabel(''); title('');
dim = [0.81 0.95 0 0];
str = {'$$\hat{\sigma}_c = 30$$', '$$\hat{\sigma}_w= 180$$', '(Mbps)'};
annotation('textbox', dim, 'BackgroundColor', 'white', 'EdgeColor', 'k', ...
    'String',str,'FitBoxToText','on', 'Interpreter', 'Latex');
set(gca,'Fontsize', font_size_val);

subplot(2,3,4)
box on;
plot(fitlm(T4,'r_c1 ~ v_w1'))
set(legend(), 'visible', 'off')
ylabel(''); xlabel(''); title('');
dim = [0.25 0.5 0 0];
str = {'$$\hat{\sigma}_c = 50$$', '$$\hat{\sigma}_w= 100$$', '(Mbps)'};
annotation('textbox', dim, 'BackgroundColor', 'white', 'EdgeColor', 'k', ...
    'String',str,'FitBoxToText','on', 'Interpreter', 'Latex');
set(gca,'Fontsize', font_size_val);

subplot(2,3,5)
box on;
plot(fitlm(T5,'r_c1 ~ v_w1'))
set(legend(), 'visible', 'off')
ylabel(''); xlabel(''); title('');
dim = [0.53 0.5 0 0];
str = {'$$\hat{\sigma}_c = 50$$', '$$\hat{\sigma}_w= 150$$', '(Mbps)'};
annotation('textbox', dim, 'BackgroundColor', 'white', 'EdgeColor', 'k', ...
    'String',str,'FitBoxToText','on', 'Interpreter', 'Latex');
set(gca,'Fontsize', font_size_val);

subplot(2,3,6)
box on;
plot(fitlm(T6,'r_c1 ~ v_w1'))
set(legend(), 'visible', 'off')
ylabel(''); xlabel(''); title('');
dim = [0.81 0.5 0 0];
str = {'$$\hat{\sigma}_c = 50$$', '$$\hat{\sigma}_w= 180$$', '(Mbps)'};
annotation('textbox', dim, 'BackgroundColor', 'white', 'EdgeColor', 'k', ...
    'String',str,'FitBoxToText','on', 'Interpreter', 'Latex');
set(gca,'Fontsize', font_size_val);

ax = axes(fig);
han = gca;
han.Visible = 'off';
han.XLabel.Visible = 'on';
han.YLabel.Visible = 'on';
xlabel('WiFi netowrk share v_w^1')
ylabel('Average Cellular datarate\sigma_c^1 [Gbps]')
set(gca,'Fontsize', font_size_val);

%% Cellular datarate vs. Cellular Network share

fig = figure('Position', [100 100 700 400]);


subplot(2,3,1)
box on;
plot(fitlm(T1,'r_c1 ~ v_c1'))
set(legend(), 'visible', 'off')
ylabel(''); xlabel(''); title('');
dim = [0.25 0.95 0 0];
str = {'$$\hat{\sigma}_c = 30$$', '$$\hat{\sigma}_w= 100$$', '(Mbps)'};
annotation('textbox', dim, 'BackgroundColor', 'white', 'EdgeColor', 'k', ...
    'String',str,'FitBoxToText','on', 'Interpreter', 'Latex');
set(gca,'Fontsize', font_size_val);

subplot(2,3,2)
box on;
plot(fitlm(T2,'r_c1 ~ v_c1'))
set(legend(), 'visible', 'off')
ylabel(''); xlabel(''); title('');
dim = [0.53 0.95 0 0];
str = {'$$\hat{\sigma}_c = 30$$', '$$\hat{\sigma}_w= 150$$', '(Mbps)'};
annotation('textbox', dim, 'BackgroundColor', 'white', 'EdgeColor', 'k', ...
    'String',str,'FitBoxToText','on', 'Interpreter', 'Latex');
set(gca,'Fontsize', font_size_val);

subplot(2,3,3)
box on;
plot(fitlm(T3,'r_c1 ~ v_c1'))
set(legend(), 'visible', 'off')
ylabel(''); xlabel(''); title('');
dim = [0.81 0.95 0 0];
str = {'$$\hat{\sigma}_c = 30$$', '$$\hat{\sigma}_w= 180$$', '(Mbps)'};
annotation('textbox', dim, 'BackgroundColor', 'white', 'EdgeColor', 'k', ...
    'String',str,'FitBoxToText','on', 'Interpreter', 'Latex');
set(gca,'Fontsize', font_size_val);

subplot(2,3,4)
box on;
plot(fitlm(T4,'r_c1 ~ v_c1'))
set(legend(), 'visible', 'off')
ylabel(''); xlabel(''); title('');
dim = [0.25 0.5 0 0];
str = {'$$\hat{\sigma}_c = 50$$', '$$\hat{\sigma}_w= 100$$', '(Mbps)'};
annotation('textbox', dim, 'BackgroundColor', 'white', 'EdgeColor', 'k', ...
    'String',str,'FitBoxToText','on', 'Interpreter', 'Latex');
set(gca,'Fontsize', font_size_val);

subplot(2,3,5)
box on;
plot(fitlm(T5,'r_c1 ~ v_c1'))
set(legend(), 'visible', 'off')
ylabel(''); xlabel(''); title('');
dim = [0.53 0.5 0 0];
str = {'$$\hat{\sigma}_c = 50$$', '$$\hat{\sigma}_w= 150$$', '(Mbps)'};
annotation('textbox', dim, 'BackgroundColor', 'white', 'EdgeColor', 'k', ...
    'String',str,'FitBoxToText','on', 'Interpreter', 'Latex');
set(gca,'Fontsize', font_size_val);

subplot(2,3,6)
box on;
plot(fitlm(T6,'r_c1 ~ v_c1'))
set(legend(), 'visible', 'off')
ylabel(''); xlabel(''); title('');
dim = [0.81 0.5 0 0];
str = {'$$\hat{\sigma}_c = 50$$', '$$\hat{\sigma}_w= 180$$', '(Mbps)'};
annotation('textbox', dim, 'BackgroundColor', 'white', 'EdgeColor', 'k', ...
    'String',str,'FitBoxToText','on', 'Interpreter', 'Latex');
set(gca,'Fontsize', font_size_val);

ax = axes(fig);
han = gca;
han.Visible = 'off';
han.XLabel.Visible = 'on';
han.YLabel.Visible = 'on';
xlabel('Cellular netowrk share v_c^1')
ylabel('Average Cellular datarate\sigma_c^1 [Gbps]')
set(gca,'Fontsize', font_size_val);

%% WiFi datarate vs. Cellular Network share

fig = figure('Position', [100 100 700 400]);


subplot(2,3,1)
box on;
plot(fitlm(T1,'r_w1 ~ v_c1'))
set(legend(), 'visible', 'off')
ylabel(''); xlabel(''); title('');
dim = [0.25 0.95 0 0];
str = {'$$\hat{\sigma}_c = 30$$', '$$\hat{\sigma}_w= 100$$', '(Mbps)'};
annotation('textbox', dim, 'BackgroundColor', 'white', 'EdgeColor', 'k', ...
    'String',str,'FitBoxToText','on', 'Interpreter', 'Latex');
set(gca,'Fontsize', font_size_val);

subplot(2,3,2)
box on;
plot(fitlm(T2,'r_w1 ~ v_c1'))
set(legend(), 'visible', 'off')
ylabel(''); xlabel(''); title('');
dim = [0.53 0.95 0 0];
str = {'$$\hat{\sigma}_c = 30$$', '$$\hat{\sigma}_w= 150$$', '(Mbps)'};
annotation('textbox', dim, 'BackgroundColor', 'white', 'EdgeColor', 'k', ...
    'String',str,'FitBoxToText','on', 'Interpreter', 'Latex');
set(gca,'Fontsize', font_size_val);

subplot(2,3,3)
box on;
plot(fitlm(T3,'r_w1 ~ v_c1'))
set(legend(), 'visible', 'off')
ylabel(''); xlabel(''); title('');
dim = [0.81 0.95 0 0];
str = {'$$\hat{\sigma}_c = 30$$', '$$\hat{\sigma}_w= 180$$', '(Mbps)'};
annotation('textbox', dim, 'BackgroundColor', 'white', 'EdgeColor', 'k', ...
    'String',str,'FitBoxToText','on', 'Interpreter', 'Latex');
set(gca,'Fontsize', font_size_val);

subplot(2,3,4)
box on;
plot(fitlm(T4,'r_w1 ~ v_c1'))
set(legend(), 'visible', 'off')
ylabel(''); xlabel(''); title('');
dim = [0.25 0.5 0 0];
str = {'$$\hat{\sigma}_c = 50$$', '$$\hat{\sigma}_w= 100$$', '(Mbps)'};
annotation('textbox', dim, 'BackgroundColor', 'white', 'EdgeColor', 'k', ...
    'String',str,'FitBoxToText','on', 'Interpreter', 'Latex');
set(gca,'Fontsize', font_size_val);

subplot(2,3,5)
box on;
plot(fitlm(T5,'r_w1 ~ v_c1'))
set(legend(), 'visible', 'off')
ylabel(''); xlabel(''); title('');
dim = [0.53 0.5 0 0];
str = {'$$\hat{\sigma}_c = 50$$', '$$\hat{\sigma}_w= 150$$', '(Mbps)'};
annotation('textbox', dim, 'BackgroundColor', 'white', 'EdgeColor', 'k', ...
    'String',str,'FitBoxToText','on', 'Interpreter', 'Latex');
set(gca,'Fontsize', font_size_val);

subplot(2,3,6)
box on;
plot(fitlm(T6,'r_w1 ~ v_c1'))
set(legend(), 'visible', 'off')
ylabel(''); xlabel(''); title('');
dim = [0.81 0.5 0 0];
str = {'$$\hat{\sigma}_c = 50$$', '$$\hat{\sigma}_w= 180$$', '(Mbps)'};
annotation('textbox', dim, 'BackgroundColor', 'white', 'EdgeColor', 'k', ...
    'String',str,'FitBoxToText','on', 'Interpreter', 'Latex');
set(gca,'Fontsize', font_size_val);

ax = axes(fig);
han = gca;
han.Visible = 'off';
han.XLabel.Visible = 'on';
han.YLabel.Visible = 'on';
xlabel('Cellular netowrk share v_c^1')
ylabel('Average WiFi datarate\sigma_w^1 [Gbps]')
set(gca,'Fontsize', font_size_val);


%%

c1 = sum(T1.r_c1>= 0.03)/length(T1.r_c1);
c2 = sum(T2.r_c1>= 0.03)/length(T2.r_c1);
c3 = sum(T3.r_c1>= 0.03)/length(T3.r_c1);
c4 = sum(T4.r_c1>= 0.05)/length(T4.r_c1);
c5 = sum(T5.r_c1>= 0.05)/length(T5.r_c1);
c6 = sum(T6.r_c1>= 0.05)/length(T6.r_c1);

w1 = sum(T1.r_w1>= 0.1)/length(T1.r_w1);
w2 = sum(T2.r_w1>= 0.15)/length(T2.r_w1);
w3 = sum(T3.r_w1>= 0.18)/length(T3.r_w1);
w4 = sum(T4.r_w1>= 0.1)/length(T4.r_w1);
w5 = sum(T5.r_w1>= 0.15)/length(T5.r_w1);
w6 = sum(T6.r_w1>= 0.18)/length(T6.r_w1);

C = [c1, c2, c3; c4, c5, c6];
W = [w1, w4; w2, w5; w3, w6];

R_c1_mean = [mean(T1.r_c1), mean(T2.r_c1), mean(T3.r_c1); ...
    mean(T4.r_c1), mean(T5.r_c1), mean(T6.r_c1)]

R_w1_mean = [mean(T1.r_w1), mean(T4.r_w1); ...
    mean(T2.r_w1), mean(T5.r_w1); ...
    mean(T3.r_w1), mean(T6.r_w1)]

%%
color1 = "#003f5c";
color2 = "#955196";
color3 = "#ff6e54";

font_size_val = 12;

%% Cellular Datarate Characteristics
figure('Position', [100 100 700 250]);

subplot(1,2,1)
X = categorical({'30','50'});
X = reordercats(X,{'30','50'});
b = bar(X, C, 1, 'FaceColor', 'flat');
hold on;

ylabel('$$ \mathrm{P}\Big( \sigma_c \geq \hat{\sigma}_c \Big)$$ ', 'Interpreter', 'Latex')
xlabel('$$\hat{\sigma}_c$$ [Mbps]', 'Interpreter', 'Latex')
ylim([0,1])

b(1).FaceColor = color1;
b(2).FaceColor = color2;
b(3).FaceColor = color3;

grid on;
box on;
leg3  = legend('100', '150', '180', 'Interpreter','Latex', 'Location', 'northeast')
title(leg3, '$$\hat{\sigma}_w $$ [Mbps]' , 'Interpreter','Latex')
set(gca,'Fontsize', font_size_val);


subplot(1,2,2)
X = categorical({'30','50'});
X = reordercats(X,{'30','50'});
b = bar(X, R_c1_mean*1e3, 1, 'FaceColor', 'flat');
hold on;

ylabel('$$ \mathrm{E}\big[ \sigma_c \big]$$ [Mbps] ', 'Interpreter', 'Latex')
xlabel('$$\hat{\sigma}_c$$ [Mbps]', 'Interpreter', 'Latex')
ylim([0,50])

b(1).FaceColor = color1;
b(2).FaceColor = color2;
b(3).FaceColor = color3;

grid on;
box on;
leg3  = legend('100', '150', '180', 'Interpreter','Latex', 'Location', 'southeast')
title(leg3, '$$\hat{\sigma}_w $$ [Mbps]' , 'Interpreter','Latex')
set(gca,'Fontsize', font_size_val);
set(gca,'Fontsize', font_size_val);

%%
% WiFi datarate characteristics
figure('Position', [100 100 700 250]);

subplot(1,2,1)
X = categorical({'100','150', '180'});
X = reordercats(X,{'100','150', '180'});
b = bar(X, W, 1, 'FaceColor', 'flat');
hold on;

ylabel('$$ \mathrm{P}\Big( \sigma_w \geq \hat{\sigma}_w \Big)$$ ', 'Interpreter', 'Latex')
xlabel('$$\hat{\sigma}_w$$ [Mbps]', 'Interpreter', 'Latex')
ylim([0,1])

b(1).FaceColor = color1;
b(2).FaceColor = color2;

grid on;
box on;
leg3  = legend('30', '50', 'Interpreter','Latex', 'Location', 'northeast')
title(leg3, '$$\hat{\sigma}_c $$ [Mbps]' , 'Interpreter','Latex')
set(gca,'Fontsize', font_size_val);
set(gca,'Fontsize', font_size_val);


subplot(1,2,2)
X = categorical({'100','150', '180'});
X = reordercats(X,{'100','150', '180'});
b = bar(X, R_w1_mean*1e3, 1, 'FaceColor', 'flat');
hold on;
ylim([100, 250])
ylabel('$$ \mathrm{E}\big[ \sigma_w \big]$$ [Mbps] ', 'Interpreter', 'Latex')
xlabel('$$\hat{\sigma}_w$$ [Mbps]', 'Interpreter', 'Latex')

b(1).FaceColor = color1;
b(2).FaceColor = color2;

grid on;
box on;
leg3  = legend('30', '50', 'Interpreter','Latex', 'Location', 'northwest')
title(leg3, '$$\hat{\sigma}_c $$ [Mbps]' , 'Interpreter','Latex')
set(gca,'Fontsize', font_size_val);
set(gca,'Fontsize', font_size_val);

























