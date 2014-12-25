% This file convert the matlab variables to libsvm data format and save
% them to a file.
function [label_vec, instance_mat] = features_to_svm_data(out_file, feature, ground_truth, use_feature, is_train, lastpredict_num, last_labels)
    win_count = size(ground_truth, 1);
    dim = size(feature,3);            % 27 (frequency)
    
    label_vec = [];
    instance_mat = [];
    for window = 1 : win_count
        fprintf(out_file,'%f',ground_truth(window,1));
        label_vec = [label_vec; ground_truth(window, 1)];
        dim_count = 0;
        inst_vec = [];
        for u = use_feature
            if u <= 5
                for d = 1 : dim
                    dim_count = dim_count+1;
                    fprintf(out_file,' %d:%f',dim_count,feature(window,u,d));
                    inst_vec = [inst_vec, feature(window, u, d)];
                end
            elseif u == 8
                
                for i = 1:lastpredict_num
                    if is_train == 1
                        j = window-i;
                        if j > 0
                            last = ground_truth(j, 1);
                        else
                            last = ground_truth(window, 1);
                        end
                    else
                        last = last_labels(i);
                    end
                    dim_count = dim_count+1;
                    fprintf(out_file, ' %d:%f', dim_count, last);
                    inst_vec = [inst_vec, last];
                end
            end
        end
        instance_mat = [instance_mat; inst_vec];
        fprintf(out_file,'\n');
    end
end




