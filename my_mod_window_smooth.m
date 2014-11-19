function [mse, corr, aae, output_file_new] = my_window_smooth(predict_file, output_file)
% my_window_smooth does the task of sliding window smoothing after prediction is
% finished. 
% input:
%   predict_file: the file to predict, created by my_svm_predict
%   output_file: the output of svm-predict(or tracking), the same as output_file for my_svm_predict.  
% return:
%   modified mse and corr_coeff^2
%   aae: avg abs error
%   output_file_new: modified output_file


% parameters:
%   types:
%       [x x x i x x x] : M 7
%       [x x x x x x i] : L 7
%       [i x x x x x x] : R 7
    window_size = 11;
    
    window_type = 'M';   % the index is at the middle of the window
    % window_type = 'L'     % window is at the left of the index
    % window_type = 'R'   % window is at the right of the index
%
    
    vector = [];
    
    f = fopen(output_file, 'r');
    output_file_new = sprintf('%s.winsmooth', output_file);
    f_new = fopen(output_file_new, 'w+');
    
    line = fgetl(f);
    while ischar(line)
        val = str2double(line);
        vector = [vector val];
        line = fgetl(f);
    end
    
    for i = 1:size(vector, 2)
        window = sliding_window(vector, i, window_size, window_type);
        val = mean(window);
        fprintf(f_new, '%f\n', val);
    end
    fclose(f);
    fclose(f_new);
    
    %new mse and corr
    [mse, corr, aae] = my_calc_results(predict_file, output_file_new);
end

function window = sliding_window(vector, index, win_size, win_type)
    
    if strcmp(win_type, 'L') == 1
        left = index - width + 1;
        right = index;
    elseif strcmp(win_type, 'R') == 1
        left = index;
        right = index + width - 1;
    else
        left = index - floor(win_size / 2);
        right = index + ceil(win_size / 2 - 1);
    end
    
    while left < 1
        left = left + 1;
    end
    while right > size(vector)
        right = right - 1;
    end
    window = vector(left:right);
end


