function [mse, corr_coeff] = my_svm_train_cross(training_file, c, gamma)
    cmd = sprintf('svm-train -s 3 -t 2 -v 5 -q -c %f -g %f %s', c, gamma, training_file);
    [status, cmdout] = system(cmd);
    if (status ~= 0)
        fprintf(1, 'svm train with c=%f g=%f file=%s  failed', c, gamma, training_file);
        mse = 0;
        corr_coeff = 0;
        return;
    end
    resultscell = regexp(cmdout, '[0-9.]*', 'match');
    mse = str2num(char(resultscell(1)));
    corr_coeff = str2num(char(resultscell(2)));
end