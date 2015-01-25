function [peak_idxes] = get_peaks(sig, peak_num, thres)
    
    maxval = max(sig);
    peak_idxes = zeros(1, peak_num);
    for i = 1:peak_num
        
        [val, idx] = max(sig);
        if (val < maxval * thres)
            break;
        end
        peak_idxes(i) = idx;
        sig(idx) = intmin('int32');
    end

end