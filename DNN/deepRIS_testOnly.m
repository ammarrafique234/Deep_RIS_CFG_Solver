%% Test NN

%% load test dataset
load('train_test_sets.mat',...
   'test_set_rp', 'M', 'N');
%% load network
% load('myCNN01.mat',... 
%     'net', 'layers', 'options');
load('myCNN02.mat',... 
    'net2');
net=net2;
[~,~,ntest] = size(test_set_rp);
rmse = zeros(ntest,1);
for ii=1:10:ntest
tmp_prime=predict(net, test_set_rp(:,:,ii));
%make it binary
tmp_prime(tmp_prime==0)=-1; 
tmp_prime(tmp_prime>0)=1;
tmp_prime(tmp_prime<0)=0;
test_set_cfg_prime = tmp_prime; 
%
test_set_rp_prime=fitness_fcn_compact(test_set_cfg_prime,M,N);% the predicted output
rmse(ii) = sqrt(mean(mean((test_set_rp(:,:,ii) - test_set_rp_prime).^2)));% prediction error
end