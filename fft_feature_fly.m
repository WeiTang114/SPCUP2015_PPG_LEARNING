function [ feature ] = fft_feature_fly( sig, last_hr)
%FFT_FEATURE Summary of this function goes here
%   Detailed explanation goes here
    
    
    fps = 125;
    hr_high = 4;
    hr_low = 0.75;
    window_sec = 8;
    dim_high = ceil(hr_high*window_sec+1);
    dim_low = floor(hr_low*window_sec+1);
      
    len = size(sig, 2);
    
    % SSA
    L = 400;
    [sig(1,:),~,~] = my_ssa(sig(1,:), sig(3:5, :), L, last_hr);
    [sig(2,:),~,~] = my_ssa(sig(2,:), sig(3:5, :), L, last_hr);
     
    %FFT
    %fft_sig_part = abs(fft(sig_part,[],2));

    %Periodogram
    for i = 1:5
        fq_sig(i,:) = periodogram(sig(i, :), rectwin(len), len, fps);
    end
    
    % select frequency
    feature(1,:,:) = fq_sig(:, dim_low:dim_high);
    
    % normalize
    for f = 1:5
        mean_ = mean(feature(1, f, :));
        if mean_ ~= 0
            feature(1,f,:) = feature(1,f,:)/mean_;
        end
    end
end

