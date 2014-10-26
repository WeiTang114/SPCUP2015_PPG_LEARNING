% This file convert the matlab variables to libsvm data format and save
% them to a file.
function [] = features_to_svm_data(out_file, feature, ground_truth, use_feature)
    win_count = size(ground_truth, 1);
    dim = size(feature,3);            % 27 (frequency)
    for window = 1 : win_count
        fprintf(out_file,'%f',ground_truth(window,1));
        dim_count = 0;
        for u = 1 : use_feature
            for d = 1 : dim
                dim_count = dim_count+1;
                fprintf(out_file,' %d:%f',dim_count,feature(window,u,d));
            end
        end
        fprintf(out_file,'\n');
    end
end




