function [mse, corr_coeff, aae, out_label] = my_mod_track(target_label, label)
% my_mod_track does the task of temporal tracking after prediction is
% finished. 
% input:
%   target_label: ground truth
%   label: the labels to be tracked
% return:
%   modified mse and corr_coeff^2
%   aae: avg abs error
%   output_label: tracked labels

    DELTA = 7;
    TAU = 2;
    
    lastval = -1;
    out_label = [];
    for i = 1:size(label, 1)
        val = label(i);
        if lastval > 0
            diff = val - lastval;
            if diff > DELTA
                val = lastval + TAU;
            elseif diff < -1 * DELTA
                val = lastval - TAU;
            end
        end    
        lastval = val;
        out_label = [out_label; val];
    end
   
    %new mse and corr
    [mse, corr_coeff, aae] = my_calc_results(target_label, out_label);
end