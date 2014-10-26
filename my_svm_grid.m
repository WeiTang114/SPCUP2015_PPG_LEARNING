% my_svm_grid: run grid.py to get the best c and gamma for svm

my_global;

extract_features;
save_groundtruths;

load('features.mat');
load('ground_truth.mat');


if exist('g_data_idxes', 'var') == 0
    g_data_idxes = 1:12;
end

training_filename = 'tang_training_data_54';
f = fopen(training_filename, 'w+');
for i = g_data_idxes
    eval(sprintf('features_to_svm_data(f, features%d, ground_truth%d, 5)', i, i)); 
end
fclose(f);

logC_s = -5;
logC_b = 15;
logC_step = 2;
logG_s = -14;
logG_b = 2;
logG_step = 2;

results = [];
for logC = logC_s : logC_step : logC_b
    for logG = logG_s : logG_step : logG_b
        [mse, corr] = my_svm_train_cross(training_filename, 2^logC, 2^logG);
        fprintf(1, 'c = %f, g = %f,     mse = %f, corr = %f\n', 2^logC, 2^logG, mse, corr);
        results = [results; [2^logC, 2^logG, mse, corr]];
    end
end

resultsorted = sortrows(results, 4);

i = size(resultsorted, 1)
best = resultsorted(i,:);
while (best(4) > 1)
    i = i - 1;
    best = resultsorted(i,:);
    disp(i)
end

fprintf(1, 'Best c:%f, gamma:%f,  mse = %f, ceff = %f\n', best(1), best(2), best(3), best(4));

tmpf = fopen('parameters.txt', 'w+');
fprintf(tmpf, 'c:%f, gamma:%f,  mse = %f, ceff = %f\n', best(1), best(2), best(3), best(4));
fclose(tmpf);










