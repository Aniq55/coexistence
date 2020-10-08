for lambda_c = [25, 50, 250]
    for lambda_w = [100, 400]
        for B_cU = [80, 160, 240, 320]
            filename = ['D:\Coexistence\results\', num2str(int32(lambda_c)), '_', ...
                num2str(int32(lambda_w)), '_', ...
                num2str(int32(B_cU)), '.csv']
            
            %Plot goes here:
            M = csvread(filename, 1, 0)

            delta_c = reshape(M(:,3), [4,4]);
            delta_w = reshape(M(:,4), [4,4]);

            r_c = reshape(M(:,5), [4,4]);
            r_w = reshape(M(:,6), [4,4]);

            BcL = [20, 40, 80, 100];
            BwL = [20, 40, 80, 160];

            Fh = figure;

            subplot(2,2,1)
            surf(BcL, BwL, delta_c);
            title('\delta_c')
            xlim([20, 100])
            ylim([20, 160])
            xticks(BcL)
            yticks(BwL)
            xlabel('B_c^L')
            ylabel('B_w^L')
            shading interp 
            view(2);
            colorbar;
            caxis([0 1])

            subplot(2,2,2)
            surf(BcL, BwL, delta_w);
            title('\delta_w')
            xlim([20, 100])
            ylim([20, 160])
            xticks(BcL)
            yticks(BwL)
            xlabel('B_c^L')
            ylabel('B_w^L')
            shading interp 
            view(2);
            colorbar;
            caxis([0 1])

            subplot(2,2,3)
            surf(BcL, BwL, r_c*1e3);
            title('r_c')
            xlim([20, 100])
            ylim([20, 160])
            xticks(BcL)
            yticks(BwL)
            xlabel('B_c^L')
            ylabel('B_w^L')
            shading interp 
            view(2);
            h = colorbar;
            ylabel(h, 'Mbps')

            subplot(2,2,4)
            surf(BcL, BwL, r_w*1e3);
            title('r_w')
            xlim([20, 100])
            ylim([20, 160])
            xticks(BcL)
            yticks(BwL)
            xlabel('B_c^L')
            ylabel('B_w^L')
            shading interp 
            view(2);
            h = colorbar;
            ylabel(h, 'Mbps')
            
            
            % Saving the plot
            plotname = ['D:\Coexistence\plots\game1\', ...
                num2str(int32(lambda_c)), '_', ...
                num2str(int32(lambda_w)), '_', ...
                num2str(int32(B_cU)), '.png']
            
            saveas(Fh, plotname)
            
            
        end
    end
end


%%

% corr(yourvariables)
% imagesc(ans); % Display correlation matrix as an image
% set(gca, 'XTick', 1:sizeofyourcorrmatrix); % center x-axis ticks on bins
% set(gca, 'YTick', 1:nsizeofyourcorrmatrix); % center y-axis ticks on bins
% set(gca, 'XTickLabel', yourlabelnames); % set x-axis labels
% set(gca, 'YTickLabel', yourlabelnames); % set y-axis labels
% title('Your Title', 'FontSize', 10); % set title
% colormap('jet'); % Choose jet or any other color scheme
% colorbar on; % 
