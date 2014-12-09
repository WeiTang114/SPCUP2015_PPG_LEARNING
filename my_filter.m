function [sigout] = my_filter(sigin, fcut, fsample, type)
% fcut: a scalar or a 2-element vector. Unnormalized cutoff frequency ( where the signal amplitude is -3dB
%       ). for low/high-pass filter, this is a scalar; for band-pass filter, this
%       is a 2-element vector. 
% fsample: sampling frequency, e.g. 125 for our work.
% type: 'high' for high-pass filter
%       'low' for low-pass filter
%       'bandpass' for band-pass filter 

    order = 6;
    [b, a] = butter(order, 2 * fcut / fsample, type);
    sigout = filter(b, a, sigin);
   
end
