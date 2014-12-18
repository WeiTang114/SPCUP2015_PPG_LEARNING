look_forward = 1;
look_width = 1;

extract_features;
modify_feature;
save_groundtruths;
load('features.mat');
load('ground_truths.mat');
indexes_all = 1:12;

look_forward = 1;
look_width = 1;

% parameters
c = 2048;
gamma = 0.00625;
window_dist = 'uniform';  % 'gaussian'
window_size = 15;
window_gau_sdtype = 'd2';

% window_str to be shown in the name of the exp
if window_dist == 'uniform'
    window_str = window_dist;
elseif window_dist == 'gaussian'
    window_str = sprintf('gaussian_%s', window_gau_sdtype);
end

% for storing results
results = [];
corr_sum = 0;
aae_sum = 0;

% directories
exp_root_dir = 'exp';
date = datestr(now, 'yyyymmdd_HHMMSS');


%exp name: <c>_<gamma>_t<thres>_<delta>_s<winsize>_<window_str>_<date>
exp_name = sprintf('%f_%f_t7_2_s%d_%s__%s_lf=%d_lw=%d', c, gamma, window_size, window_str, date, look_forward, look_width);
exp_dir = sprintf('%s\\%s', exp_root_dir, exp_name);
tmp_dir = sprintf('%s\\tmp', exp_dir);
mkdir(exp_dir);
mkdir(tmp_dir);

% result file
resf = fopen(sprintf('%s\\results.txt', exp_dir), 'w+');

fprintf(1, 'Experiment starting: %s\n\n', exp_name);

for i = 1:12
    
    fprintf(1, '\nTest %d\n', i);
    train_idxes = indexes_all( ~ismember( indexes_all, i ) );
    training_file = sprintf('%s\\my_train_no_%d', tmp_dir, i);
    predict_file = sprintf('%s\\my_predict_%d', tmp_dir, i);
    output_file = sprintf('%s\\my_out_%d', exp_dir, i);
    fig_file = sprintf('%s\\plot_%d', exp_dir, i);
    
    %train
    model_file = ...
            my_svm_train(training_file, c, gamma, train_idxes);

    %predict
    [mse_predict, corr_predict] = ...
            my_svm_predict(model_file, predict_file, output_file, i);

    %temporal track
    [mse_track, corr_track, aae_track, output_file_track] = ...
            my_mod_track(predict_file, output_file);

    %window_smooth
    [mse_smooth, corr_smooth, aae_smooth, output_file_smooth] = ...
            my_mod_window_smooth(predict_file, output_file_track, window_dist, window_size, window_gau_sdtype);

    %{
    mse = mse_track;
    corr = corr_track;
    avg_abs_err = aae_track;
    %}
    mse = mse_smooth;
    corr = corr_smooth;
    avg_abs_err = aae_smooth;

    % plot
    my_plot_func(fig_file, predict_file, output_file, output_file_track, output_file_smooth);

    % save results to file
    fprintf(resf, 'predict %d:mse = %f , corr = %f\n', i, mse_predict, corr_predict);
    fprintf(resf, 'tracked %d:mse = %f , corr = %f , avg_abs_err = %f\n', i, mse_track, corr_track, aae_track);
    fprintf(resf, 'smooth  %d:mse = %f , corr = %f , avg_abs_err = %f\n', i, mse_smooth, corr_smooth, aae_smooth);      

    % print results
    fprintf(1, 'predict %d:mse = %f , corr = %f\n', i, mse_predict, corr_predict);
    fprintf(1, 'tracked %d:mse = %f , corr = %f , avg_abs_err = %f\n', i, mse_track, corr_track, aae_track);
    fprintf(1, 'smooth  %d:mse = %f , corr = %f , avg_abs_err = %f\n', i, mse_smooth, corr_smooth, aae_smooth); 

    fprintf(1, 'result : mse %f , corr %f , avg_abs_err = %f\n', mse, corr, avg_abs_err);

    corr_sum = corr_sum + corr;
    aae_sum = aae_sum + avg_abs_err;
end

fprintf(1, 'c = %f, gamma = %f,  Average corr = %f\n', c, gamma, corr_sum / 12);
fprintf(resf, 'c = %f, gamma = %f,  Average corr = %f\n', c, gamma, corr_sum / 12);
fprintf(1, 'c = %f, gamma = %f,  Average abs error = %f BPM\n', c, gamma, aae_sum / 12);
fprintf(resf, 'c = %f, gamma = %f,  Average abs error = %f BPM\n', c, gamma, aae_sum / 12);

fclose(resf);
fclose all;

fprintf(1, sprintf('Exp: %s succeeded!\n', exp_name));
exp_dir_succ = sprintf('%s__succ', exp_dir);
copyfile(exp_dir, exp_dir_succ);
rmdir(exp_dir, 's');
delete features.mat;
delete ground_truths.mat;