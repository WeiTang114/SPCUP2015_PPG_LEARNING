function [model] = my_svm_train(training_file, c, gamma, indexes, use_lastpredict, lastpredict_num, past_acc_end, acc_num)
    if (nargin < 4)
        indexes = 1:12;
    end

    extract_features;
    save_groundtruths;
    load('features.mat');
    load('ground_truths.mat');
    load_rawdata;
    acc_features = extract_acc_features(0);

    f = fopen(training_file, 'w+');
    labels = [];
    insts = [];
    for i = indexes
        % choose features
        use_features = [1:2];
        if use_lastpredict; use_features = [use_features, 8]; end;
        if acc_num > 0; use_features = [use_features, [21:25]]; end;
        [label, inst] = features_to_svm_data(f, features{i}, ground_truth{i}, use_features, 1, lastpredict_num, [], acc_features{i}, past_acc_end, acc_num, 0);
        labels = [labels; label];
        insts = [insts; inst];
    end
    fclose(f);

    model = svmtrain(labels, insts, sprintf('-s 3 -t 2 -c %f -g %f -q', c, gamma));
end