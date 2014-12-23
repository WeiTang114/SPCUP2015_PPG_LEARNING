% This extract features from every file of data, and
% store the features seperately into a file "features.mat"

my_global;

if exist('g_data_idxes', 'var') == 0
    g_data_idxes = 1:12;
end

filename = 'features.mat';

% check file existence, if no, create it.
if (exist(filename, 'file') == 0)
    % create a new empty mat file
    save(filename, 'g_data_idxes');  
end

% check variable 'features' existence
global features;
if size(features, 2) == 0
    for i = g_data_idxes

        [sig, ground_truth] = get_data(i);
        win_count = size(ground_truth,1);

        %features 3D: (window, channel, feature(frequency))
        [~,features{i}] = fft_feature(ground_truth, sig);

    end
end
save(filename, 'features', '-append');

clearvars data_idxes ground_truth i sig win_count filename