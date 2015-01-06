function [mse, corr, avg_abs_err] = my_calc_results_files(target_file, out_file)
% my_calc_results calculates results according to the input files.
% input:
%     target_file: the svm predict input file
%     out_file: the svm prediction output file
% return:
%     mse: mean square error
%     corr: correlation coeffiecient^2
%     avg_abs_arr: = (sum(BPMest(i) - BPMtrue(e)) / N)

    ft = fopen(target_file);
    fp = fopen(out_file);
     
    error = 0;
    sump = 0;
    sumt = 0;
    sumpp = 0;
    sumtt = 0;
    sumpt = 0;
    total = 0;
    abserr = 0;
    
    linet = fgetl(ft);
    while ischar(linet)
        linep = fgetl(fp);
        
        cellt = regexp(linet, '[0-9.]*', 'match');
        labelt = str2double(char(cellt(1)));
        labelp = str2double(linep);
        
        error = error + (labelp - labelt)^2;
        sump = sump + labelp;
        sumt = sumt + labelt;
        sumpp = sumpp + labelp^2;
        sumtt = sumtt + labelt^2;
        sumpt = sumpt + labelp * labelt;
        total = total + 1;
        abserr = abserr + abs(labelt - labelp);
        
        linet = fgetl(ft);
    end

    fclose(ft);
    fclose(fp);
    
    mse = error / total;
    corr = ((total * sumpt - sump * sumt)^2) / ((total * sumpp - sump^2) * (total * sumtt - sumt^2));
    avg_abs_err = abserr / total;
end