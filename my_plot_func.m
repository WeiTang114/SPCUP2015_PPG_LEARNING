function [] = my_plot_func(fig_file, topre_file, out_file, varargin)
% varargin:
%     any number of filenames of output files. 
%     These output files will be all plotted on the same figure.
%     eg. 
%         my_plot_func('myfig', 'mypredict', 'myout', 'myout.track', 'myout.smooth')
%     then there will be 4 lines on the figure, including groundtruth and 3 outputs.
        
    out_files_2 = varargin;
    n_out_files = 1 + length(out_files_2);
    
    inputfname = topre_file;
    ft = fopen(inputfname, 'r');
    
    predictfnames = [out_file, out_files_2];
    fps = zeros(1, n_out_files);
    for i = 1: n_out_files
        fps(i) = fopen(predictfnames{i}, 'r');
    end
    
    
    %str = fileread('tang_predict_54');
    %disp(str);

    wint = [];
    line = fgetl(ft);
    while ischar(line)
        reres = regexp(line, '^[0-9.]*', 'match');
        wint = [wint str2num(char(reres(1)))];
        line = fgetl(ft);
    end

    winps = {};
    for j = 1: n_out_files
        if (size(fps, 2)) == 1
            fp = fps;
        else
            fp = fps(j);
        end
        winp = [];
        line = fgetl(fp);
        while ischar(line)
            reres = regexp(line, '^[0-9.]*', 'match');
            winp = [winp str2num(char(reres(1)))];
            line = fgetl(fp);
        end
        winps = [winps, winp];
    end
    
    x = linspace(0, 100, size(wint,2));
    
    
    plotdata = cell(3 * (n_out_files + 1), 1);
    plotdata(1: 3: end) = {x};
    plotdata(2) = {wint};
    plotdata(5: 3: end) = winps;
    plotdata(3:3:end) = {'.-'};
    plot(plotdata{:});
    
    % legend
    legenddata = cell(n_out_files, 1);
    for t = 1: n_out_files 
        legenddata(t) = {num2str(t)};
    end
    lgnd = legend('groundtruth', legenddata{:}, 'Location', 'southeast');
    set(lgnd, 'color', 'none');
    
    % save figures as a .fig and a .png
    saveas(gcf, sprintf('plot\\%s',fig_file), 'png');
    saveas(gcf, sprintf('plot\\%s',fig_file), 'fig');
end