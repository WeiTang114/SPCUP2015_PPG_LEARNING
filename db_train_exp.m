extract_features;
modify_feature;
save_groundtruths;
load('features.mat');
load('ground_truths.mat');
indexes_all = 1:12;

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

% directories
exp_root_dir = 'exp';
date = datestr(now, 'yyyymmdd_HHMMSS');

%exp name: <c>_<gamma>_t<thres>_<delta>_s<winsize>_<window_str>_<date>
exp_name = sprintf('%f_%f_t7_2_s%d_%s__%s', c, gamma, window_size, window_str, date);
exp_dir = sprintf('%s\\%s', exp_root_dir, exp_name);
tmp_dir = sprintf('%s\\tmp', exp_dir);
mkdir(exp_dir);
mkdir(tmp_dir);

fprintf(1, 'Experiment starting: %s\n\n', exp_name);

for i = 1:12
    
    fprintf(1, '\nTest %d\n', i);
    train_idxes = indexes_all( ~ismember( indexes_all, i ) );
    training_file = sprintf('%s\\my_train_no_%d', tmp_dir, i);
    predict_file = sprintf('%s\\my_predict_%d', tmp_dir, i);
    output_file = sprintf('%s\\my_out_%d', exp_dir, i);
    
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

    mse = mse_smooth;
    corr = corr_smooth;
    avg_abs_err = aae_smooth;
    
    fprintf(1, 'result : mse %f , corr %f , avg_abs_err = %f\n', mse, corr, avg_abs_err);


end

prepare_db_train;
results = [];
corr_sum1 = 0;
aae_sum1 = 0;
corr_sum2 = 0;
aae_sum2 = 0;

% result file
resf = fopen(sprintf('%s\\results.txt', exp_dir), 'w+');

for i = 1:12
    
    fprintf(1, '\nDB train %d\n', i);
    train_idxes = indexes_all( ~ismember( indexes_all, i ) );
    training_file = sprintf('%s\\DB_train_no_%d', tmp_dir, i);
    predict_file = sprintf('%s\\DB_predict_%d', tmp_dir, i);
    predict_file_original = sprintf('%s\\my_predict_%d', tmp_dir, i);
    output_file1 = sprintf('%s\\my_out_%d.track.winsmooth', exp_dir, i);
    output_file2 = sprintf('%s\\DB_out_%d', exp_dir, i);
    output_file3 = sprintf('%s\\DB_after_sum_%d', exp_dir, i);
    fig_file = sprintf('%s\\DB_plot_%d', exp_dir, i);
    
    %train
    model_file = ...
            my_svm_train(training_file, c, gamma, train_idxes);

    %predict
    [mse_predict, corr_predict] = ...
            my_svm_predict(model_file, predict_file, output_file2, i);

    [mse, corr, aae] = my_calc_results(predict_file, output_file2);
    fprintf(resf, 'DB train result for #%d : mse %f , corr %f , avg_abs_err = %f\n', i, mse, corr, aae);
    fprintf(1, 'DB train result for #%d : mse %f , corr %f , avg_abs_err = %f\n', i, mse, corr, aae);

    corr_sum2 = corr_sum2 + corr;
    aae_sum2 = aae_sum2 + aae;

    tmp_fp1 = fopen(output_file1, 'r');
    tmp_fp2 = fopen(output_file2, 'r');
    tmp_fp3 = fopen(output_file3, 'w+');
    vector = [];
    line1 = fgetl(tmp_fp1);
    line2 = fgetl(tmp_fp2);
    while ischar(line1)
        val1 = str2double(line1);
        val2 = str2double(line2);
        fprintf(tmp_fp3, '%f\n', val1 + val2);
        line1 = fgetl(tmp_fp1);
        line2 = fgetl(tmp_fp2);
    end
    fclose(tmp_fp1);
    fclose(tmp_fp2);
    fclose(tmp_fp3);
    
    %temporal track
    [mse_track, corr_track, aae_track, output_file_track] = ...
            my_mod_track(predict_file_original, output_file3);

    %window_smooth
    [mse_smooth, corr_smooth, aae_smooth, output_file_smooth] = ...
            my_mod_window_smooth(predict_file_original, output_file_track, window_dist, window_size, window_gau_sdtype);
    
    %[mse, corr, aae] = my_calc_results(predict_file_original, output_file3);

    % save results to file
    fprintf(resf, 'Result %d : mse = %f , corr = %f , avg_abs_err = %f\n', i, mse_smooth, corr_smooth, aae_smooth);
    fprintf(1, 'Result %d : mse %f , corr %f , avg_abs_err = %f\n', i, mse_smooth, corr_smooth, aae_smooth);

    corr_sum1 = corr_sum1 + corr_smooth;
    aae_sum1 = aae_sum1 + aae_smooth;
end

fprintf(1, 'Train1: Average corr = %f,  Average abs error = %f BPM\n', corr_sum2 / 12, aae_sum2 / 12);
fprintf(resf, 'Train1: Average corr = %f,  Average abs error = %f BPM\n', corr_sum2 / 12, aae_sum2 / 12);

fprintf(1, 'Average corr = %f,  Average abs error = %f BPM\n', corr_sum1 / 12, aae_sum1 / 12);
fprintf(resf, 'Average corr = %f,  Average abs error = %f BPM\n', corr_sum1 / 12, aae_sum1 / 12);

fclose(resf);
fclose all;

fprintf(1, sprintf('Exp: %s succeeded!\n', exp_name));
exp_dir_succ = sprintf('%s__succ', exp_dir);
copyfile(exp_dir, exp_dir_succ);
rmdir(exp_dir, 's');
delete features.mat;
delete ground_truths.mat;