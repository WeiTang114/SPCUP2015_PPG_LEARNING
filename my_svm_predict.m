function [mse, corr_coeff, aae, target_label, out_label] = my_svm_predict(model, predict_file, output_file, indexes)
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
    labels = [];
    insts = [];
    for i = indexes
        [label, inst] = features_to_svm_data(f, features{i}, ground_truth{i}, 1:5);        
        labels = [labels; label];
        insts = [insts; inst];
    end
    target_label = labels;
    fclose(f);
    
    [out_label, accuracy, dec_value] = svmpredict(labels, insts, model);
    
    [mse, corr_coeff, aae] = my_calc_results(labels, out_label);
    fprintf(1, 'predict : mse %f , corr %f , aae %f\n', mse, corr_coeff, aae);
end
