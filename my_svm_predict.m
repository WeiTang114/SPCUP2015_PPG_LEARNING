function [mse, corr_coeff] = my_svm_predict(model_file, predict_file, output_file, indexes)
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

    features = [];
    ground_truths = [];
    f = fopen(predict_file, 'w+');
    for i = indexes
        eval(sprintf('features_to_svm_data(f, features%d, ground_truth%d, [1:5])', i, i));
    end
    fclose(f);
    
    cmd = sprintf('svm-predict %s %s %s', predict_file, model_file, output_file);
    [status, cmdout] = system(cmd);
    if (status ~= 0)
        fprintf(1, 'svm predict with testfile=%s model=%s outfile=%s failed', predict_file, model_file, output_file);
        mse = 0;
        corr_coeff = 0;
        return;
    end
    
    disp (cmdout);
    
    resultscell = regexp(cmdout, '[0-9.]*', 'match');
    mse = str2num(char(resultscell(1)));
    corr_coeff = str2num(char(resultscell(2)));
end
 
 