% load raw data
my_global;

if exist('rawdata', 'var') == 0
    for i = 1:13
        [rawdata{i}, ~] = get_data(i);
    end
end

