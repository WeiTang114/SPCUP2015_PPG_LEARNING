% This file convert the matlab variables to libsvm data format and save
% them to a file.
function [] = features_to_svm_data(out_file, feature, ground_truth, use_feature)
% use_features: 
%    [1:2] for PPG
%    [3:5] for ACC
%    [6]   for ||ACC||
%    [7]   for peaks 
    win_count = size(ground_truth, 1);
    dim = size(feature,3);            % 27 (frequency)
    for window = 1 : win_count
        fprintf(out_file,'%f',ground_truth(window,1));
        dim_count = 0;
        for u = use_feature
            if u <= 5
                for d = 1 : dim
                    dim_count = dim_count+1;
                    fprintf(out_file,' %d:%f',dim_count,feature(window,u,d));
                end
            elseif u == 7
                peak_num = 2;
                peak_thres = 0.3;
                peaks = zeros(1, peak_num * 2);
                peaks(1 : peak_num) = get_peaks(feature(window, 1, :), peak_num, peak_thres);
                peaks(peak_num+1 : end) = get_peaks(feature(window, 2, :), peak_num, peak_thres);
                for d = 1 : peak_num*2
                    if peaks(d) > 0
                        %peaks(d) = peaks(d) * feature(window, ceil(d/3), peaks(d));
                    end
                    dim_count = dim_count + 1;
                    fprintf(out_file, ' %d:%f', dim_count, peaks(d) / 27);
                end
            end
        end
        fprintf(out_file,'\n');
    end
end




