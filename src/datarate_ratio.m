clc;
clear all

%%
T_cell = readtable('D:\Coexistence\results\max_datarate\cellular.csv');

T_wifi = readtable('D:\Coexistence\results\max_datarate\wifi.csv');
%%

filename = ['D:\Coexistence\results\max_datarate\ratio_cell.csv'];
fid = fopen(filename,'wt');
% Heading: lambda_c, lambda_w, B_cL, B_wL, r_c, r_c_max, ratio_cell
fprintf(fid,'%s, %s, %s, %s, %s, %s, %s, %s\n', ...
    ["lambda_c", "lambda_w", "B_U", "B_cL", "B_wL", "r_c", "r_c_max" "ratio"]);

filename = ['D:\Coexistence\results\max_datarate\ratio_wifi.csv'];
fid2 = fopen(filename,'wt');
% Heading: lambda_c, lambda_w, B_cL, B_wL, r_w, r_w_max, ratio
fprintf(fid2,'%s, %s, %s, %s, %s, %s, %s, %s\n', ...
    ["lambda_c", "lambda_w", "B_U", "B_cL", "B_wL", "r_w", "r_w_max" "ratio"]);

%%

for lambda_c = [25, 50, 250]
    for lambda_w = [100, 400]
        for B_U = [80, 160, 240, 320]
            % creating a file
            filename = ['D:\Coexistence\results\', ...
                num2str(int32(lambda_c)), '_', ...
                num2str(int32(lambda_w)), '_', ...
                num2str(int32(B_U)), '.csv'];
            % Open the file as a table
            T = readtable(filename);
            for B_cL = [20, 40, 80, 100]
                % pick max data_rate
                rows = (T_cell.lambda_c_x1e_6_ == lambda_c ...
                    & T_cell.B_cL_MHz_ == B_cL ...
                    & T_cell.B_U_MHz_ == B_U);
                
                r_c_max = T_cell.maxR_c_Gbps_(rows);

                for B_wL = [20, 40, 80, 160]
                    % get an element
                    rows = (T.B_cL_MHz_ == B_cL & T.B_wL_MHz_ == B_wL);
                    r_c = T.r_c_Gbps_(rows);
                    
                    cell_ratio = r_c/r_c_max;
                    if cell_ratio > 1
                        cell_ratio = 1;
                    end
                    
                    % Sample entry: 
                    fprintf(fid,'%f, %f, %f, %f, %f, %f, %f, %f\n', ...
                        [lambda_c, lambda_w, B_U, B_cL, B_wL, r_c, r_c_max, cell_ratio]);
                    
                end
            end
            
            for B_wL = [20, 40, 80, 160]
                % pick max data_rate
                rows = (T_wifi.lambda_w_x1e_6_ == lambda_w ...
                    & T_wifi.B_wL_MHz_ == B_wL ...
                    & T_wifi.B_U_MHz_ == B_U);
                
                r_w_max = T_wifi.maxR_w_Gbps_(rows);

                for B_cL = [20, 40, 80, 100]
                    % get an element
                    rows = (T.B_cL_MHz_ == B_cL & T.B_wL_MHz_ == B_wL);
                    r_w = T.r_w_Gbps_(rows);
                    
                    wifi_ratio = r_w/r_w_max;
                    
                    if wifi_ratio > 1
                        wifi_ratio = 1;
                    end
                    
                    % Sample entry: 
                    fprintf(fid2,'%f, %f, %f, %f, %f, %f, %f, %f\n', ...
                        [lambda_c, lambda_w, B_U, B_cL, B_wL, r_w, r_w_max, wifi_ratio]);
                    
                end
            end
            
        end
    end
end

fclose(fid);
fclose(fid2);
%%

% B_cL_MHz_    B_wL_MHz_    delta_c    delta_w    r_c_Gbps_    r_w_Gbps_