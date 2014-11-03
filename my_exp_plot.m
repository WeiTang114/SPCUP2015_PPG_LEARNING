c = 2048;
gamma = 0.00625;

extract_features;
save_groundtruths;
load('features.mat');
load('ground_truths.mat');
indexes_all = 1:12;

f = fopen('exp\\results.txt', 'w+');
fprintf('c=%f, g=%f\n', c, gamma);

for i = 1:12
   train_idxes = indexes_all( ~ismember( indexes_all, i ) );
   training_file = sprintf('exp\\my_train_no_%d', i);
   predict_file = sprintf('exp\\my_predict_%d', i);
   output_file = sprintf('exp\\my_out_%d', i);
   fig_file = sprintf('plot_%d', i);
   model_file = my_svm_train(training_file, c, gamma, train_idxes);
   [mse, corr] = my_svm_predict(model_file, predict_file, output_file, i);
   my_plot_func(predict_file, output_file, fig_file);
    
   fprintf(f, 'predict %d:mse = %f , corr = %f\n', i, mse, corr);
end