
modify_feature_to_acc;

if exist('g_data_idxes', 'var') == 0
    g_data_idxes = 1:12;
end

fprintf(1, 'DB train start\n', i);
GT_file = 'ground_truths.mat';
load(GT_file);
delete(GT_file);
save(GT_file, 'g_data_idxes'); 

for i = g_data_idxes
    predict_GT = sprintf('%s\\my_out_%d', exp_dir, i);
    tmp_fp = fopen(predict_GT, 'r');
    vector = [];
    line = fgetl(tmp_fp);
    while ischar(line)
        val = str2double(line);
        vector = [vector val];
        line = fgetl(tmp_fp);
    end
    
    GT_i = sprintf('ground_truth%d', i);
    eval(sprintf('%s = %s - vector'';', GT_i, GT_i));
    save(GT_file, GT_i, '-append');
    
    fclose(tmp_fp);
end

clearvars GT_file GT_i vector line val tmp_fp predict_GT