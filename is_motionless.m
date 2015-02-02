function [bool] = is_motionless(acc3)
% acc3: 3 * N matrix of 3 channels of acc signals
    VAR_THRES = 0;
    NORM_THRES = 200;
    
    bool = 0;

% Method 1. "var" method    
    norm2 = sqrt(acc3(1,:).^2 + acc3(2,:).^2 + acc3(3,:).^2);
%     var_o = var(norm2);
%     if var(norm2) < VAR_THRES
%         bool = true;
%     end


% Method 2. "linear acc norm2" method
    for i = 1:3
        acc3f(i,:) = my_filter(acc3(i,:), 0.5, 125, 'high');
    end
    nn = sqrt(acc3f(1,:).^2 + acc3f(2,:).^2 + acc3f(3,:).^2);
    if sum(nn) < NORM_THRES
        bool = 1;
    end
end