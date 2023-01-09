clear all
clc;
%%
%notes
%generate dataset
%load or create DNN
%train DNN if created
%test DNN
%%
tic
%generate dataset
n_train=1000;
% generate and store dataset
% deepNN_dataset_gen(n_train); % n_train=100,000 requires >25GB RAM
disp('Dataset generation Time');
toc;
%load dataset
load('train_test_sets1000.mat',...
   'train_set_rp', 'train_set_cfg', 'test_set_rp', 'M', 'N');

%% Load architecture 
layers = deepCNNCreateANDConnect(0); % 0 to create fresh network
% figure;plot(lgraph);
%% Set NN trainer options
options = trainingOptions('adam', ... % optimizer adam or sgdm
    'InitialLearnRate',0.001, ...
    'MiniBatchSize',20,...
    'MaxEpochs',2, ... % epoch set to 5 for quickly testing the code
    'Verbose',false, ...
    'Plots','training-progress');

%% Start NN training
tx = zeros(91,360,1,n_train);
ty = zeros(n_train,1600);
for ii=1:n_train
    tx(:,:,1,ii) = squeeze(train_set_rp(:,:,ii));
    ty(ii,:) = squeeze(train_set_cfg(:,:,ii));
end
net = trainNetwork(tx, ty, layers, options);

disp('Total time including network training');
toc;
save(...
    'myCNN01.mat',... 
    'net', 'layers', 'options');

% % % %% test NN
% % % [~,~,ntest] = size(test_set_rp);
% % % rmse = zeros(ntest,1);
% % % for ii=1:25:ntest
% % % tmp_prime=predict(net, test_set_rp(:,:,ii));
% % % %make it binary
% % % tmp_prime(tmp_prime==0)=-1; 
% % % tmp_prime(tmp_prime>0)=1;
% % % tmp_prime(tmp_prime<0)=0;
% % % test_set_cfg_prime = tmp_prime; 
% % % %
% % % test_set_rp_prime=fitness_fcn_compact(test_set_cfg_prime,M,N);
% % % rmse(ii) = sqrt(mean(mean((test_set_rp(:,:,ii) - test_set_rp_prime).^2)));
% % % end
% % % disp('Total time including network testing');
% % % toc;