function [model] = my_svm_train(training_file, c, gamma, indexes)
    if (nargin < 4)
        indexes = 1:12;
    end

    extract_features;
    save_groundtruths;
    load('features.mat');
    load('ground_truths.mat');
   
    f = fopen(training_file, 'w+');
    labels = [];
    insts = [];
    for i = indexes
        [label, inst] = features_to_svm_data(f, features{i}, ground_truth{i}, 1:5);
        labels = [labels; label];
        insts = [insts; inst];
    end
    fclose(f);

    model = svmtrain(labels, insts, sprintf('-s 3 -t 2 -c %f -g %f', c, gamma));
end