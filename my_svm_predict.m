function [mse, corr_coeff] = my_svm_predict(model_file, output_file, indexes)
    if (nargin < 4)
        indexes = 1:12;
    end

    extract_features;
    save_groundtruths;
    load('features.mat');
    load('ground_truths.mat');

    predict_file = 'tang_predict_54';
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
    mse = 0;
    corr_coeff = 0;
    
    
end
 
 