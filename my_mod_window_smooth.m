 function [mse, corr, aae, output_label] = my_mod_window_smooth(target_label, label, window_dist, window_size, varargin)
% my_window_smooth does the task of sliding window smoothing after prediction is
% finished. 
% input:
%   target_label: 
%   label: the output label to be smoothed
%   window_dist: 'uniform' or 'gaussian'
%   window_size: size of the window
%   varargin: 
%       1. sdtype: 'd1' for [sd = len of window / 1] and so on. 'd1', 'd2'
%                   , ..., 'd6' are supported.
% return:
%   modified mse and corr_coeff^2
%   aae: avg abs error
%   output_label: smoothed labels


% parameters:
%   types:
%       [x x x i x x x] : M 7
%       [x x x x x x i] : L 7
%       [i x x x x x x] : R 7
    
    window_type = 'M';   % the index is at the middle of the window
    % window_type = 'L'     % window is at the left of the index
    % window_type = 'R'   % window is at the right of the index
%
    
    vector = label';
    output_label = [];
    
    % go window!
    for i = 1:size(vector, 2)
        window = sliding_window(vector, i, window_size, window_type);
        
        switch window_dist
            case 'uniform'
                val = mean(window);
            case 'gaussian'
                sdtype = varargin{1};
                [gau_win, gau_sum] = gaussian(window, ceil(size(window, 2)/2), get_stddev(window, sdtype));
                val = sum(gau_win/gau_sum);
            otherwise
                fprintf(1, 'Undefined window distribution: %s\n', window_dist);
        end
        
        output_label = [output_label; val];
    end
    
    %new mse and corr
    [mse, corr, aae] = my_calc_results(target_label, output_label);
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


function [gaussian_win, gaussian_sum] = gaussian(vector, mean, sd)
% sd: standard deviation
    len = size(vector, 2);
    x = linspace(1, len, len);
    y = gaussmf(x, [sd mean]);
    
    gaussian_sum = sum(y);
    gaussian_win = vector.*y;
end


function sd = get_stddev(vector, type)
% get standard deviation according predefined types for Gaussian dist.
    len = size(vector, 2);
    switch type
        case 'd1'
            sd = len / 1;
        case 'd2'
            sd = len / 2;
        case 'd3'
            sd = len / 3;
        case 'd4'
            sd = len / 4;
        case 'd5'
            sd = len / 5;
        case 'd6'
            sd = len / 6;
        otherwise
            fprintf(1, 'ERROR: Undefine type of sd:%s\n', type);
    end
end



