%extract_features_accnorm
% This extract features from every file of data, and
% store the features seperately into a file "features_accnorm.mat"

my_global;

if exist('g_data_idxes', 'var') == 0
    g_data_idxes = 1:12;
end
    
filename = 'features_accnorm.mat';
if (exist(filename, 'file') == 0)
    % create a new empty mat file
    save(filename, 'filename');  
end


acc_freq = [0.75 4];


for i = g_data_idxes
    
    % check if the features exists
    features_i = sprintf('features%d', i);
    eval(sprintf('global %s', features_i));

    % check if the global variable has been defined(size != 0)
    %if size(eval(features_i), 2) ~= 0
       % continue;
    %end
        
    [sig, ground_truth] = get_data(i);
    win_count = size(ground_truth,1);
    [~,features] = fft_feature(ground_truth, sig);
    
    features_ppg = features(:, 1:2, :);
    
    load('accnorm.mat');
    eval(sprintf('acc_norm = acc_norm%d;', i));
    features_acc = fft_feature_acc(ground_truth, acc_norm, acc_freq);
    
    %features 3D: (window, channel, feature(frequency))
    eval(sprintf('features%d = features;', i));
    
    eval(sprintf('features_accnorm%d = features_acc;', i));
    
    %fprintf(1,'save features%d\n', i); % display formatted string
    save(filename,sprintf('features%d', i), '-append');
    save(filename,sprintf('features_accnorm%d', i), '-append');
end

clearvars data_idxes features ground_truth i sig win_count filename


