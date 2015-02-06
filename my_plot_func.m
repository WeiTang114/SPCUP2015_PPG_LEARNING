function [] = my_plot_func(fig_file, topre_label, out_label, aae, varargin)
% varargin:
%     any number of labels + aae of output. 
%     These output will be all plotted on the same figure.
%     eg. 
%         my_plot_func('myfig', tag_label, out_predict, aae_predict,
%         out_track, aae_track);
%     then there will be 3 lines on the figure, including groundtruth and 2 outputs.
        
    %out_labels_2 = varargin;
    out_labels_2 = [];
    aaes = [aae];
    for i = 1:2:length(varargin)-1
    	out_labels_2{(i+1)/2} = varargin{i};
    	aaes = [aaes, varargin{i+1}];
    end
    n_out_labels = 1 + length(out_labels_2);
    
    
    %str = fileread('tang_predict_54');
    %disp(str);

    wint = topre_label';


    winps = {out_label};
    for j = 1: n_out_labels - 1
        winp = out_labels_2{j}';
        winps = [winps, winp];
    end
    
    
    x = 1:size(wint,2);
    
    
    plotdata = cell(3 * (n_out_labels + 1), 1);
    plotdata(1: 3: end) = {x};
    plotdata(2) = {wint};
    plotdata(5: 3: end) = winps;
    plotdata(3:3:end) = {'.-'};
    plot(plotdata{:});
    
    %set figure size
    hFig = figure(1);
    set(hFig, 'PaperUnits', 'points', 'PaperPosition', [0 0 1200 700]);
    
    % legend
    legenddata = cell(n_out_labels, 1);
    for t = 1: n_out_labels 
        legenddata(t) = {[num2str(t) ': ' num2str(aaes(t)) ' BPM']};
    end
    lgnd = legend('groundtruth', legenddata{:}, 'Location', 'southeast');
    set(lgnd, 'color', 'none');
    set(lgnd, 'FontSize', 15);
    
    % save figures as a .fig and a .png
    %saveas(gcf, fig_file, 'png');
    saveas(gcf, fig_file, 'fig');
    print('-dpng', fig_file);
end