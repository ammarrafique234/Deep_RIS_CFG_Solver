function [dir_dB] = eTOdir(e_in)
%ETODIR Calculates directivity in dB using given e_field
%   Detailed explanation goes here
    iso = ones(size(e_in));
    dir_lin_iso = 4*pi *iso/sum(sum(iso));
    e_in_normalized_power = 4*pi*(e_in.*e_in)/sum(sum(e_in.*e_in));
    lin_dir = e_in_normalized_power./dir_lin_iso;
    dir_dB = 10*log10(lin_dir);
    dir_dB(dir_dB<0) = 0;
end

