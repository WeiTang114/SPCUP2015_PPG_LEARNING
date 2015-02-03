% extract acc features
function [acc_features_o] = extract_acc_features( new )
    filename = 'acc_features.mat';
    if exist(filename, 'file') ~= 0 && new ~= 1
        load(filename, 'acc_features');
    end
    if exist('acc_features', 'var') ~= 0 && new ~= 1
        acc_features_o = acc_features;
        return;
    end
    
    load_rawdata;

    window_sec = 8;
    window_diff_sec = 2;
    sample_rate = 125;
    window_size = window_sec * sample_rate;%l000

    acc_features = {};

    for i = 1:13
        window_num = floor( ...
                (size(rawdata{i}, 2) - sample_rate * (window_sec - window_diff_sec)) /  ...
                (sample_rate * window_diff_sec));
        acc1 = rawdata{i}(4,:);
        acc2 = rawdata{i}(5,:);
        acc3 = rawdata{i}(6,:);
        acc1filt = my_filter(acc1, 10, 125, 'low');
        acc2filt = my_filter(acc2, 10, 125, 'low');
        acc3filt = my_filter(acc3, 10, 125, 'low');
        
        acc_feature_i = {};

        feature_mean = zeros(window_num, 4);
        feature_var = zeros(window_num, 4);
        feature_corr = zeros(window_num, 6);
        feature_energy = zeros(window_num, 4);
        feature_entropy = zeros(window_num, 4);

        for j = 1:window_num
            start = window_diff_sec * sample_rate * (j-1) + 1;

            acc1_part = acc1filt(start: start + window_size - 1);
            acc2_part = acc2filt(start: start + window_size - 1);
            acc3_part = acc3filt(start: start + window_size - 1);
            norm_part = (acc1_part.^2 + acc2_part.^2 + acc3_part.^2).^0.5;

            % mean
            mean1 = mean(acc1_part);
            mean2 = mean(acc2_part);
            mean3 = mean(acc3_part);
            meanN = mean(norm_part);
            feature_mean(j,:) = [mean1, mean2, mean3, meanN];

            % variance
            var1 = var(acc1_part);
            var2 = var(acc2_part);
            var3 = var(acc3_part);
            varN = var(norm_part);
            feature_var(j,:) = [var1, var2, var3, varN];

            % Correlation
            corr12 = corrcoef(acc1_part, acc2_part);
            corr13 = corrcoef(acc1_part, acc3_part);
            corr1N = corrcoef(acc1_part, norm_part);
            corr23 = corrcoef(acc2_part, acc3_part);
            corr2N = corrcoef(acc2_part, norm_part);
            corr3N = corrcoef(acc3_part, norm_part);

            corr12 = corr12(1, 2);
            corr13 = corr13(1,2);
            corr1N = corr1N(1,2);
            corr23 = corr23(1,2);
            corr2N = corr2N(1,2);
            corr3N = corr3N(1,2);
            feature_corr(j,:) = [corr12, corr13, corr1N, corr23, corr2N, corr3N];

            % ENERGY
            fft1 = abs(fft(acc1_part, [], 2));
            fft2 = abs(fft(acc2_part, [], 2));
            fft3 = abs(fft(acc3_part, [], 2));
            fftN = abs(fft(norm_part, [], 2));
            fft1AC = fft1(2:end);
            fft2AC = fft2(2:end);
            fft3AC = fft2(2:end);
            fftNAC = fftN(2:end);
            energy1 = sum(fft1AC.^2) / window_size;
            energy2 = sum(fft2AC.^2) / window_size;
            energy3 = sum(fft3AC.^2) / window_size;
            energyN = sum(fftNAC.^2) / window_size;
            feature_energy(j,:) = [energy1, energy2, energy3, energyN];

            % Freq Domain Entropy
            fft1ACPos = fft1AC(~ismember(fft1AC, 0));
            fft2ACPos = fft2AC(~ismember(fft2AC, 0));
            fft3ACPos = fft3AC(~ismember(fft3AC, 0));
            fftNACPos = fftNAC(~ismember(fftNAC, 0));
            entropy1 = - sum(fft1ACPos .* log2(fft1ACPos));
            entropy2 = - sum(fft2ACPos .* log2(fft2ACPos));
            entropy3 = - sum(fft3ACPos .* log2(fft3ACPos));
            entropyN = - sum(fftNACPos .* log2(fftNACPos));
            feature_entropy(j,:) = [entropy1, entropy2, entropy3, entropyN];
        end
        acc_feature_i{1} = feature_mean;
        acc_feature_i{2} = feature_var;
        acc_feature_i{3} = feature_corr;
        acc_feature_i{4} = feature_energy;
        acc_feature_i{5} = feature_entropy;

        acc_features{i} = acc_feature_i;
    end
    
    acc_features = normalize_features(acc_features);
    
    save(filename, 'acc_features');
    acc_features_o = acc_features;
end



function acc_features_o = normalize_features(acc_features)
    sizes = [4 4 6 4 4];
    for type = 1:5
        for fi = 1:sizes(type)
            feature = [];
            for subj = 1:12
                win_num = size(acc_features{subj}{1}, 1);
                for win = 1:win_num
                    feature = [feature, acc_features{subj}{type}(win, fi)];
                end 
            end
            m = mean(feature);
            sd = std(feature);
            fprintf(1, 'ACC feature (%d:%d); mean = %f, sd = %f\n', type, fi, m, sd);
           
            for subj = 1:12
                acc_features{subj}{type}(:, fi) = ...
                        (acc_features{subj}{type}(:, fi) - m) / sd;
            end
        end
    end
    acc_features_o = acc_features;
end