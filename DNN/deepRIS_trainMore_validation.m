n_train=100;
%load dataset
load('train_test_sets.mat',...
   'train_set_rp', 'train_set_cfg', 'test_set_rp', 'M', 'N');

if(n_train>size(train_set_rp,3))
    % generate and store dataset
    deepNN_dataset_gen(n_train); % n_train=100,000 requires >25GB RAM
end
%% Load architecture 
load('myCNN02.mat',...
    'net2', 'options');
layers = deepCNNConnect(net2);
% figure;plot(lgraph);
%% Modify NN trainer options
% % options = trainingOptions('adam', ... % optimizer adam or sgdm
% %     'InitialLearnRate',0.001, ...
% %     'MiniBatchSize',20,...
% %     'MaxEpochs',2, ... % epoch set to 5 for quickly testing the code
% %     'Verbose',false, ...
% %     'Plots','training-progress');
%% Resume NN training

%dataset variable reshape start


    idx=randperm(n_train);
    t_idx = 1:round(0.7*n_train);
    v_idx = round(0.7*n_train)+1:n_train;
    tx = zeros(91,360,1,length(t_idx));
    ty = zeros(length(t_idx),1600);
    vx = zeros(91,360,1,length(v_idx));
    vy = zeros(length(v_idx),1600);

    for ii=1:length(t_idx)
        ii_idx=idx(t_idx(ii));
        tx(:,:,1,ii) = squeeze(train_set_rp(:,:,ii_idx));
        ty(ii,:) = squeeze(train_set_cfg(:,:,ii_idx));
    end
    for ii=1:length(v_idx)
        ii_idx=idx(v_idx(ii));
        vx(:,:,1,ii) = squeeze(train_set_rp(:,:,ii_idx));
        vy(ii,:) = squeeze(train_set_cfg(:,:,ii_idx));
    end
    

%dataset variable reshape end

% training options edit start
options.MiniBatchSize = 50;
options.MaxEpochs = 10;
options.ValidationData={vx,vy};
options.ValidationFrequency=5;
% training options edit end
tic;
net2 = trainNetwork(tx, ty, layers, options);
toc;
save(...
    'myCNN03.mat',... 
    'net2', 'layers', 'options');