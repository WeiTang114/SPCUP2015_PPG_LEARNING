data_idxes = 1:5;

filename = 'ground_truths.mat';
if (exist(filename, 'file') == 0)
   save(filename); 
end

for i = data_idxes
   [sig, ground_truth] = get_data(i);
   eval(sprintf('ground_truth%d = ground_truth;', i));
   save(filename,sprintf('ground_truth%d', i), '-append');
end

clearvars data_idxes ground_truth i sig filename