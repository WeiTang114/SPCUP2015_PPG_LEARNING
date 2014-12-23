my_global;

if exist('g_data_idxes', 'var') == 0
    g_data_idxes = 1:12;
end

filename = 'ground_truths.mat';
if (exist(filename, 'file') == 0)
    % create a new empty mat file
    save(filename, 'g_data_idxes'); 
end

% check variable 'features' existence
global ground_truth;
if size(ground_truth, 2) == 0
    for i = g_data_idxes
        [sig, ground_truth{i}] = get_data(i);
    end
end
save(filename, 'ground_truth', '-append');

clearvars data_idxes i sig filename