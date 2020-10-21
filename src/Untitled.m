r_c_min_vec = 20:1:35;
r_c_vec = [0.0208	0.0213	0.0243	0.0235	0.0243	0.0252	0.0263	0.0273	0.0286	0.0297	0.0302	0.0315	0.0327	0.0336	0.035	0.035];
r_w_vec = [0.1055	0.0782	0.0735	0.0751	0.0735	0.0725	0.0705	0.0695	0.0669	0.0659	0.0635	0.0624	0.0614	0.0578	0.0569	0.0569];
delta_c_vec = [0	0.95	0.95	1	0.95	1	0.95	1	0.95	1	0.9	0.95	1	0.9	0.95	0.95];
delta_w_vec = [0.75	0.45	0.35	0.4	0.35	0.35	0.3	0.3	0.25	0.25	0.2	0.2	0.2	0.15	0.15	0.15];

figure(1);
plot(r_c_min_vec, r_c_vec*1e3, 'o-');
hold on;
plot(r_c_min_vec, r_w_vec*1e3, 's-');

box on;
grid on;
xlabel("r_{c,min} [Mbps]")
ylabel("datarate [Mbps]")
legend('r_c', 'r_w')


figure(2);
plot(r_c_min_vec, delta_c_vec, 'o-');
hold on;
plot(r_c_min_vec, delta_w_vec, 's-');

box on;
grid on;
xlabel("r_{c,min} [Mbps]")
ylabel("\delta")
legend('\delta_c', '\delta_w')


