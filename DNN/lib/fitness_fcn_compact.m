function e_abs=fitness_fcn_compact(configuration_matrix,M,N, varargin)
% Fitness function which evaluates given configuration
% data. Input is expected as nxM*N i.e 1 row and M*N columns for a single
% run.
% Calculates farfield radiation pattern for a given case of metasurface
% configuration.
% patternCustom(efield,theta_vec,phi_vec) gives 3D radiation pattern plot.  
% Last Edited on: 2:00PM 16-Dec-2021
%%
if(nargin>3)
    metaatomID=varargin{1,1};
else
    metaatomID='s1';
end
%Sanity Check
[nconfig, MN] = size(configuration_matrix);
if(nconfig~=1)
    disp(['nconfig' string(nconfig)])
    error('Incorrect number of configurations')
end
if(~all(ismember(configuration_matrix,[0 1])))
    error('Invalid values in configuration');
end

% load('metaatom_data.mat','e1_theta_cmplx','e1_phi_cmplx','e2_theta_cmplx','e2_phi_cmplx');
metaatom_filename = strcat('metaatom_data_uv_',metaatomID,'.mat');
load(metaatom_filename...
    ,'e_theta_cmplx','e_phi_cmplx'...
    ,'operating_freq_Hz','metaatom_size_m'...
    );

[~,~,nconfigs] = size(e_theta_cmplx);
nbits = ceil(log2(nconfigs));
configuration_matrix = bitvec2intvec(configuration_matrix, nbits);
config_mat = reshape(configuration_matrix,M,N);

if(MN~=M*N*nbits)
    error('Given configuration is not compatible with expected M and N values.')
end
% Initializing varaibles from inputs


THETA=181;
PHI=360;





%simulation range
if(nargin==6)
    theta_rng= varargin{1,2};
    phi_rng = varargin{1,3};
else
    theta_rng= 0:90;
    phi_rng = 0:359;
end
%%
%beginning of config simulation
    

    % e(theta,phi) calculation
    [e_abs_all,~,~]=e_u_v_fft_source_final(...
        theta_rng,phi_rng,THETA,PHI,M,N,config_mat...
        ,e_theta_cmplx,e_phi_cmplx...
        ,operating_freq_Hz, metaatom_size_m...
        );

    %end of config simulation
    e_abs = e_abs_all(1:91,:); % only reflective so nothing on the backside
    e_abs = e_abs./max(max(e_abs)); % normalized, although decieving in case of scaterring
     


end