load('ground_truth.mat');%ground_truth
load('fft_features.mat');%features

count = size(ground_truth,1)
dim = size(features,3);

answers = zeros([count 3]);
answers(:,1) = ground_truth(:,1);
%PPG 1
PPG = 1;
for c = 1 : count
    max_value = max(features(c,PPG,:));
    for d = 1 : dim
        if max_value == features(c,PPG,d)
            answers(c,PPG+1) = 60*((d-1)/8+0.75);
            break;
        end
    end
end

%PPG 2
PPG = 2;
for c = 1 : count
    max_value = max(features(c,PPG,:));
    for d = 1 : dim
        if max_value == features(c,PPG,d)
            answers(c,PPG+1) = 60*((d-1)/8+0.75);
            break;
        end
    end
end

%evaluate
corr = corrcoef(answers);
disp(corr);
rmse1 = sqrt(mean((answers(:,1)-answers(:,2)).*(answers(:,1)-answers(:,2))));
rmse2 = sqrt(mean((answers(:,1)-answers(:,3)).*(answers(:,1)-answers(:,3))));
disp([rmse1 rmse2]);
