function [ sig_o , ground_truth_o ] = get_data( data_idx )
%GET_DATA get sig and ground_truth of selected data

file_list = dir('./');
files = size(file_list,1);

for f = 1 : files
    filename = file_list(f).name();
    if (filename(1) ~= 'D')
        continue
    end
    if (strcmp(filename(1:4), 'DATA') == 1)
        file_idx = filename(6:7);
        if (strcmp(file_idx, num2str(data_idx, '%02.0f')) == 0)
            % index not match
            continue;
        end
        load(filename);
        if (strfind(filename, 'BPMtrace') > 0)  % ground truth
            ground_truth_o = BPM0;
            %disp(strcat('loaded ground truth:', num2str(data_idx)));
        else
            sig_o = sig;
            %disp(strcat('loaded sig:', num2str(data_idx)));
        end
    end
end

