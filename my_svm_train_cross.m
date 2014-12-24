function [mse, corr, aae] = my_svm_train_cross(c, gamma, idxes)
    tmpfile = 'exp\\trainingcross.tmp';
    tmpfile1 = 'exp\\trainingcross1.tmp';
    tmpfile2 = 'exp\\trainingcross2.tmp';
    
    mse_sum = 0;
    corr_sum = 0;
    aae_sum = 0;
    for i = idxes
        model = my_svm_train(tmpfile, c, gamma, setdiff(idxes, i));
        [msei, corri, aaei, ~, ~]  = my_svm_predict(model, tmpfile1, tmpfile2, i);
        mse_sum = mse_sum + msei;
        corr_sum = corr_sum + corri;
        aae_sum = aae_sum + aaei;
    end
    mse = mse_sum / size(idxes, 2);
    corr = corr_sum / size(idxes, 2);
    aae = aae_sum / size(idxes, 2);
end