n_train=100000;
%load dataset
load('train_test_sets100000.mat',...
   'train_set_rp', 'train_set_cfg', 'test_set_rp', 'M', 'N');

if(n_train>size(train_set_rp,3))
    % generate and store dataset
    deepNN_dataset_gen(n_train); % n_train=100,000 requires >25GB RAM
end
%% Load architecture 
load('myCNN01.mat',...
    'net', 'options');
layers = deepCNNConnect(net);
% figure;plot(lgraph);
%% Modify NN trainer options
% % options = trainingOptions('adam', ... % optimizer adam or sgdm
% %     'InitialLearnRate',0.001, ...
% %     'MiniBatchSize',20,...
% %     'MaxEpochs',2, ... % epoch set to 5 for quickly testing the code
% %     'Verbose',false, ...
% %     'Plots','training-progress');
options.MiniBatchSize = 1000;
options.MaxEpochs = 2;
%% Resume NN training

%dataset variable reshape start
if(~exist('tx','var')||~exist('ty','var')||(size(tx,4)~=n_train)||(size(ty,1)~=n_train))
tx = zeros(91,360,1,n_train);
ty = zeros(n_train,1600);
for ii=1:n_train
    tx(:,:,1,ii) = squeeze(train_set_rp(:,:,ii));
    ty(ii,:) = squeeze(train_set_cfg(:,:,ii));
end
end
%dataset variable reshape end
tic;
net2 = trainNetwork(tx, ty, layers, options);
toc;

% comment below code to avoid saving if performance is not upto the mark
save(...
    'myCNN03.mat',... 
    'net2', 'layers', 'options');