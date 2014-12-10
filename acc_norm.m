function acc_norm
    data_idxes = 1:12;

    filename_accnorm = 'accnorm.mat';
    if (exist(filename, 'file') == 0)
        save(filename, '');
    end

    for i = data_idxes
        [sig, ~] = get_data(i);
        acc = sig(4:6, :);
        accnorm = (acc(1,:).^2 + acc(2,:).^2 + acc(3,:).^2).^0.5;
        accnorm_filtered = my_filter(accnorm, [0.5, 20], 125, 'bandpass');

        eval(sprintf('acc_norm%d = accnorm;', i));
        eval(sprintf('acc_norm_filtered%d = accnorm_filtered;', i));
        save(filename_accnorm, sprintf('acc_norm%d', i), '-append');
        save(filename_accnorm, sprintf('acc_norm_filtered%d', i), '-append');
    end
    
end