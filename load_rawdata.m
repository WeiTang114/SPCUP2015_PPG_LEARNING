% load raw data

if exist('rawdata', 'var') == 0
    for i = 1:12
        [rawdata{i}, ~] = get_data(i);
    end
end

