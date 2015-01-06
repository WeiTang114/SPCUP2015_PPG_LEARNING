function [c, gamma] = my_svm_grid(cv_set)
% my_svm_grid: get best c and gamma of the best aae
% input: cv_set: cross-validation set, e.g. 1:5 or 1:12
    tic;
    extract_features;
    save_groundtruths;

    load('features.mat');
    load('ground_truths.mat');

    logC_s = 1;
    logC_b = 15;
    logC_step = 2;
    logG_s = -14;
    logG_b = 1;
    logG_step = 2;

    exp_num = 0;
    results = [];
    for logC = logC_s : logC_step : logC_b
        for logG = logG_s : logG_step : logG_b
            [mse, corr, aae] = my_svm_train_cross(2^logC, 2^logG, cv_set);
            fprintf(1, 'c = %f, g = %f,     mse = %f, corr = %f, aae = %f\n', 2^logC, 2^logG, mse, corr, aae);
            results = [results; [2^logC, 2^logG, mse, corr, aae]];
            exp_num = exp_num + 1;
        end
    end

    resultsorted = sortrows(results, -5);  % sort by aae in descending order

    i = size(resultsorted, 1);
    best = resultsorted(i,:);
    while (best(4) > 1)
        i = i - 1;
        best = resultsorted(i,:);
        disp(i)
    end
    
    fprintf('Finish running %d experiments.\n', exp_num);
    toc;
    fprintf(1, 'Best c:%f, gamma:%f,  mse = %f, ceff = %f, aae = %f\n', best(1), best(2), best(3), best(4), best(5));    
    
    tmpf = fopen('parameters.txt', 'w+');
    fprintf(tmpf, 'c:%f, gamma:%f,  mse = %f, ceff = %f, aae = %f\n', best(1), best(2), best(3), best(4), best(5));
    fclose(tmpf);

    c = best(1);
    gamma = best(2);
end