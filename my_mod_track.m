function [mse, corr_coeff, aae, output_file_new] = my_mod_track(predict_file, output_file)
% my_mod_track does the task of temporal tracking after prediction is
% finished. 
% input:
%   predict_file: the file to predict, created by my_svm_predict
%   output_file: the output of svm-predict, the same as output_file for my_svm_predict.  
% return:
%   modified mse and corr_coeff^2
%   aae: avg abs error
%   output_file_new: modified output_file

    DELTA = 7;
    TAU = 2;

    f = fopen(output_file, 'r');
    output_file_new = sprintf('%s.track', output_file);
    f_new = fopen(output_file_new, 'w+');
    
    line = fgetl(f);
    lastval = -1;
    while ischar(line)
        val = str2double(line);
        if lastval > 0
            diff = val - lastval;
            if diff > DELTA
                val = lastval + TAU;
            elseif diff < -1 * DELTA
                val = lastval - TAU;
            end
        end
    
        fprintf(f_new, '%f\n', val);
        lastval = val;
        line = fgetl(f);
    end
   
    fclose(f);
    fclose(f_new);
    
    
    %new mse and corr
    [mse, corr_coeff, aae] = my_calc_results(predict_file, output_file_new);
end