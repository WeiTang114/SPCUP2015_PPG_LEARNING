function [mse, corr_coeff, aae, target_label, out_label] = my_svm_predict(model, predict_file, output_file, indexes, lastpredict_num, past_acc_end, acc_num, peak_win_num)
% my_svm_predict calls libsvm to predict the input data.
%
% usage: 
%   [mse, corr_coeff] = my_svm_predict(model_file, predict_file, output_file, indexes)
% input: 
%   model_file    the .model file created by my_svm_predict
%   predict_file  new file name, stores formatted libsvm-format data
%   output_file   new file name, stores the output of svm-predict
%   indexes       the indexes vector to be predicted, e.g. [1:5], [12]
%   lastpredict_num  how many labels of past windows should be the features
%   past_acc_end  index of the last window whose acc is considered to the
%                 current window.--->[... 3 2 1 0(curr)]
%   acc_num       how many windows whose acc is considered, until
%                 past_acc_end
% output:
%   mse           mean-square error
%   corr_coeff    the square of correlation coeffient(corr^2)
%   aae           average absolute error
%   target_label  m*1 matrix of the target labels(ground truths)
%   out_label     m*1 matrix of the output labels

    if (nargin < 3)
        indexes = 1:12;
    end

    extract_features;
    save_groundtruths;
    load('features.mat');
    load('ground_truths.mat');
    load_rawdata;
    acc_features = extract_acc_features(0);
    
    f = fopen(predict_file, 'w+');
    lastlabels(1:lastpredict_num) = 72; % normal heart rate
    target_label = [];
    out_label = [];
    for i = indexes
        
        for win = 1:peak_win_num
            len = win * 250 + 750;
            peak_num = 3;
            peaks{1} = get_peaks(abs(fft(rawdata{i}(2, 1:len), [], 2)), peak_num, 0.3) * 125/len * 60;
            peaks{2} = get_peaks(abs(fft(rawdata{i}(3, 1:len), [], 2)), peak_num, 0.3) * 125/len * 60;
            peaks_best{1} = lastlabels(1);
            peaks_best{2} = lastlabels(1);
            for p = 1:2
                for j = 1:peak_num
                    if 50 < peaks{p}(j) && 180 > peaks{p}(j)
                        peaks_best{p} = peaks{p}(j);
                        break;
                    end
                end
            end
            out_label_win = (peaks_best{1} + peaks_best{2}) / 2;
            lastlabels = circshift(lastlabels, [2, 1]);
            lastlabels(1) = out_label_win;
            out_label = [out_label; out_label_win];
            target_label = [target_label; ground_truth{i}(win)];
        end
            
        for win = peak_win_num + 1:size(features{i}, 1)
            [labe_gt, inst] = features_to_svm_data(f, features{i}(win, :, :), ground_truth{i}(win), [1:2 8 21:25], 0, lastpredict_num, lastlabels, acc_features{i}, past_acc_end, acc_num, win);
            [out_label_win, ~, ~] = svmpredict(labe_gt, inst, model, '-q');
            lastlabels = circshift(lastlabels, [2, 1]); % dim:2 shift:1(to the right)
            lastlabels(1) = out_label_win;
            out_label = [out_label; out_label_win];
            target_label = [target_label; labe_gt];
        end
    end
    fclose(f);

    [mse, corr_coeff, aae] = my_calc_results(target_label, out_label);
    fprintf(1, 'predict : mse %f , corr %f , aae %f\n', mse, corr_coeff, aae);
end
