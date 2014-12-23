function [] = my_plot_func(fig_file, topre_label, out_label, varargin)
% varargin:
%     any number of filenames of output files. 
%     These output files will be all plotted on the same figure.
%     eg. 
%         my_plot_func('myfig', 'mypredict', 'myout', 'myout.track', 'myout.smooth')
%     then there will be 4 lines on the figure, including groundtruth and 3 outputs.
        
    out_labels_2 = varargin;
    n_out_labels = 1 + length(out_labels_2);
    
    
    %str = fileread('tang_predict_54');
    %disp(str);

    wint = topre_label';


    winps = {out_label};
    for j = 1: n_out_labels - 1
        winp = out_labels_2{j}';
        winps = [winps, winp];
    end
    
    
    x = linspace(0, 100, size(wint,2));
    
    
    plotdata = cell(3 * (n_out_labels + 1), 1);
    plotdata(1: 3: end) = {x};
    plotdata(2) = {wint};
    plotdata(5: 3: end) = winps;
    plotdata(3:3:end) = {'.-'};
    plot(plotdata{:});
    
    %set figure size
    hFig = figure(1);
    set(hFig, 'Position', [100 0 900 600])
    
    % legend
    legenddata = cell(n_out_labels, 1);
    for t = 1: n_out_labels 
        legenddata(t) = {num2str(t)};
    end
    lgnd = legend('groundtruth', legenddata{:}, 'Location', 'southeast');
    set(lgnd, 'color', 'none');
    
    % save figures as a .fig and a .png
    saveas(gcf, fig_file, 'png');
    saveas(gcf, fig_file, 'fig');
end