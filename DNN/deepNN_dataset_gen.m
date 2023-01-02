function deepNN_dataset_gen(train_samples)
% Generates dataset for Deep RIS Neural Network
% Generated Data is stored in same folder as code
%% generate data
% generate test set using goog radiation patterns
load('lib\ga_ref_patterns.mat','ga_targets')
sample_num=12;% 28dB directivity beam at Theta=36deg and Phi=4deg.
ref_mag_dB=28;
phi_target=0;
mag_target=1;
scale_factor = 10^(ref_mag_dB/20);
ref_factor = 10^(83/20);% sample was created using Yang2016 data.
sample = squeeze(ga_targets(:,:,sample_num));%e_desired theta*phi
test_set_rp = zeros( 91, 360, 60);
for ii=1:1:60
    theta_target=ii-1;
    tmp = ref_maker(sample, theta_target,phi_target, mag_target); % phi target is fixed at 0;
    target = tmp(1:91,1:360)*scale_factor/ref_factor;
    target = target./max(max(target));% normalized although scale_factor becomes useless
    test_set_rp(:,:,ii) = target;
end
%test_set_rp

%% generate training data using ramdom configurations and AFA evaluated
%radiation patterns
M=40; N=40; %RIS size
num_samples = train_samples;
train_set_rp = zeros(91,360,train_samples);
train_set_cfg = zeros(1,M*N,train_samples);
disp(1);
parfor ii=1:num_samples
tmp_config=randi([0,1], 1, M*N);
tmp_rp=fitness_fcn_compact(tmp_config,M,N); %step cost 4.31s
train_set_cfg(1,:,ii) = tmp_config; 
train_set_rp(:,:,ii) = tmp_rp;
end
train_set_cfg;
train_set_rp;
%x=train_set_rp, y=trains_set_cfg;
%save generated data in deepRIS folder
save(...
    'train_test_sets.mat',... 
    'train_set_rp', 'train_set_cfg', 'test_set_rp','M','N','num_samples');

end