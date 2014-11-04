my_global;

if exist('g_data_idxes', 'var') == 0
    g_data_idxes = 1:12;
end

filename = 'ground_truths.mat';
if (exist(filename, 'file') == 0)
   save(filename); 
end

for i = g_data_idxes
    
    % check if the ground_truths exists
    gt_i = sprintf('ground_truth%d', i);
    eval(sprintf('global %s', gt_i));
    if exist(gt_i, 'var')  ~= 0
        continue;
    end
    
    [sig, ground_truth] = get_data(i);
    eval(sprintf('ground_truth%d = ground_truth;', i));
    save(filename,sprintf('ground_truth%d', i), '-append');
end

clearvars data_idxes ground_truth i sig filename