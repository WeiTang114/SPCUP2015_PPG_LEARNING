% This extract features from every file of data, and
% store the features seperately into a file "features.mat"

data_idxes = 1:5;

for i = data_idxes
   [sig, ground_truth] = get_data(i);
   win_count = size(ground_truth,1);
   [~,features] = fft_feature(ground_truth, sig);
   %features 3D: (window, channel, feature(frequency))
   eval(sprintf('features%d = features', i));
   save('features.mat',sprintf('features%d', i), '-append');
end

clearvars data_idxes features ground_truth i sig win_count