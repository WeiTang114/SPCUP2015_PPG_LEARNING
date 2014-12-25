function [mse, corr_coeff, aae, target_label, out_label] = my_svm_predict(model, predict_file, output_file, indexes, lastpredict_num)
% my_svm_predict calls libsvm to predict the input data.
%
% usage: 
%   [mse, corr_coeff] = my_svm_predict(model_file, predict_file, output_file, indexes)
% input: 
%   model_file    the .model file created by my_svm_predict
%   predict_file  new file name, stores formatted libsvm-format data
%   output_file   new file name, stores the output of svm-predict
%   indexed       the indexes vector to be predicted, e.g. [1:5], [12]
% output:
%   mse           mean-square error
%   corr_coeff    the square of correlation coeffient(corr^2)

    if (nargin < 3)
        indexes = 1:12;
    end

    extract_features;
    save_groundtruths;
    load('features.mat');
    load('ground_truths.mat');
    
    f = fopen(predict_file, 'w+');
    lastlabels(1:lastpredict_num) = 72; % normal heart rate
    target_label = [];
    out_label = [];
    for i = indexes
        for win = 1:size(features{i}, 1)
            [labe_gt, inst] = features_to_svm_data(f, features{i}(win, :, :), ground_truth{i}(win), [1:5 8], 0, lastpredict_num, lastlabels);
            [out_label_win, ~, ~] = svmpredict(labe_gt, inst, model, '-q');
            lastlabels = circshift(lastlabels, [2, 1]); % dim:2 shift:1(to the right)
            lastlabels(1) = out_label_win;
            out_label = [out_label; out_label_win];
            target_label = [target_label; labe_gt];
        end
    end
    fclose(f);

    [mse, corr_coeff, aae] = my_calc_results(target_label, out_label);
    fprintf(1, 'predict : mse %f , corr %f , aae %f\n', mse, corr_coeff, aae);
end
