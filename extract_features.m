% This extract features from every file of data, and
% store the features seperately into a file "features.mat"

my_global;

if exist('g_data_idxes', 'var') == 0
    g_data_idxes = 1:12;
end
    
filename = 'features.mat';
if (exist(filename, 'file') == 0)
   save(filename); 
end

for i = g_data_idxes
   [sig, ground_truth] = get_data(i);
   win_count = size(ground_truth,1);
   [~,features] = fft_feature(ground_truth, sig);
   %features 3D: (window, channel, feature(frequency))
   eval(sprintf('features%d = features;', i));
   fprintf(1,'save features%d\n', i); % display formatted string
   save(filename,sprintf('features%d', i), '-append');
end

clearvars data_idxes features ground_truth i sig win_count filename