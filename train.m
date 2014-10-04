f = fopen('train.sh','w+');

%
logC_s = -5;
logC_b = 15;
logC_step = 2;
logG_s = -14;
logG_b = 2;
logG_step = 2;
%

%{
logC_s = -5;
logC_b = 15;
logC_step = 2;
logG_s = -20;
logG_b = -2;
logG_step = 2;
%}

for logC = logC_s : logC_step : logC_b
    for logG = logG_s : logG_step : logG_b
        fprintf(f,'echo \"C:%f G:%f\"\n', 2^logC, 2^logG);
        fprintf(f,'svm-train -s 3 -t 2 -v 5 -q -c %f -g %f training_data_54\n',2^logC,2^logG);%svm-train
        %fprintf(f,'svm-train -s 3 -t 2 -v 5 -q -c %f -g %f training_data_135\n',2^logC,2^logG);%svm-train
    end
end
fclose(f);