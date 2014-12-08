function [sigout] = my_filter(sigin, fcut, fsample, type)
% fcut: unnormalized cutoff frequency ( where the signal amplitude is -3dB
% ). for our work, 0.05 with type = 'high' seems to filter g well.
% fsample: sampling frequency, e.g. 125 for our work.
% type: 'high' for high-pass filter
%       'low' for low-pass filter
    
    order = 6;
    [b, a] = butter(order, 2 * pi * fcut / fsample, type);
    sigout = filter(b, a, sigin);
   
end
