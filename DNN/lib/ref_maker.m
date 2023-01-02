function [e_abs] = ref_maker(sample,theta_target,phi_target,mag_list)
%GA_TARGET_MAKER Using a sample pencil beam radiation Pattern, a pattern in
%desired target orientations is generated using circularshift and
%averaging.NOT VALIDATED
%
theta_target(theta_target==0) = 3;
theta_target(theta_target==90) = 87;
theta_target = theta_target + 1; % +1 for correction to map to index
phi_target = phi_target + 1;

[THETA, PHI] = size(sample);
if(THETA==91 && PHI==360)
    dir_limit = 24-3; % -3 for half sphere seen as full sphere
    ishemisphere = true;
    e_abs = zeros(181,360);
    e_abs(1:THETA, 1:PHI) = sample;
elseif(THETA==181 && PHI==360)
    e_abs = sample;
    dir_limit = 24;
    if(all(sample(92:end,:)==0))
        ishemisphere=true;
    else
        ishemisphere=false;
    end
else
    error('Sample variable is not of expected size')
end


if(length(theta_target)~=length(phi_target))
    error('theta_target and phi_target do not form theta phi pairs')
end

[max_dir,theta_max,phi_max]=max2d(eTOdir(sample));

if(max_dir - 4*log(length(theta_target)) < dir_limit ) % formula drived using curve fitting tool and trial and error
    warning('Sample does not have good enough directivity for required number of beams')
end

e_original = e_abs;
e_tmp = zeros(size(e_abs));
for i = 1: length(theta_target)
    theta_shift = 181-theta_max+theta_target(i);
    phi_shift = 360-phi_max+phi_target(i);
    e_tmp = e_tmp + circshift(e_original,[theta_shift phi_shift])*mag_list(i);
end

e_abs = e_tmp/length(theta_target);
if(ishemisphere)
    e_abs(92:end,:) = 0;
end
end