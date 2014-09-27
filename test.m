file_list = dir('./');
files = size(file_list,1);

count = 0;
window_count = 0;
flag = 0;
for f = 1 : files
    if flag == 1
        flag = 0;
        continue;
    end
    if file_list(f).name(1) == 'D'
        disp(f);
        disp(file_list(f).name);
        load(file_list(f+1).name);
        count = count + 1;
        window_count = window_count + size(BPM0,1);
        flag = 1;
    end
end

features = zeros([window_count 5 27]);%windows,channels,dimensions
ground_truth = zeros([window_count 1]);

window_count = 0;
flag = 0;
for f = 1 : files
    if flag == 1
        flag = 0;
        continue;
    end
    if file_list(f).name(1) == 'D'
        disp(f);
        disp(file_list(f).name);
        load(file_list(f).name);
        load(file_list(f+1).name);
        [~,features(window_count+1:window_count+size(BPM0,1),:,:)] = fft_feature(BPM0,sig);
        ground_truth(window_count+1:window_count+size(BPM0,1),1) = BPM0(:,1);
        window_count = window_count + size(BPM0,1);
        flag = 1;
    end
end
save('fft_features.mat','features');
save('ground_truth.mat','ground_truth');