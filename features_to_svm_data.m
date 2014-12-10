% This file convert the matlab variables to libsvm data format and save
% them to a file.
function [] = features_to_svm_data(out_file, feature, feature_accnorm, ground_truth, use_feature)
    win_count = size(ground_truth, 1);
    dim = size(feature,3);            % 27 (frequency)
    dim_acc = size(feature_accnorm, 2);
    for window = 1 : win_count
        fprintf(out_file,'%f',ground_truth(window,1));
        dim_count = 0;
        for u = use_feature
            if u <= 5
                for d = 1 : dim
                    dim_count = dim_count+1;
                    fprintf(out_file,' %d:%f',dim_count,feature(window,u,d));
                end
            elseif u == 6
                for d = 1 : dim_acc
                    dim_count = dim_count+1;
                    fprintf(out_file, ' %d:%f', dim_count, feature_accnorm(window, d));
                end
            end
        end
        
        fprintf(out_file,'\n');
    end
end




