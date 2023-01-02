function lgraph = deepCNNCreateANDConnect(isPretrained)
%isPretrained=false;
if(isPretrained)
% params = load('params_2022_12_28__13_34_51.mat'); % Load pretrained DNN
end

%%
%create Layer Graph
lgraph = layerGraph;
%add Layer Brancher
tempLayers = imageInputLayer([91 360 1],"Name","radiationPattern");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([30 120],20,"Name","conv_1","Padding","same")
    convolution2dLayer([30 120],20,"Name","conv_2","Padding","same")
    convolution2dLayer([30 120],20,"Name","conv_3","Padding","same")
    fullyConnectedLayer(50,"Name","fc_1")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([45 180],20,"Name","conv_4","Padding","same")
    convolution2dLayer([45 180],20,"Name","conv_5","Padding","same")
    fullyConnectedLayer(50,"Name","fc_2")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","addition")
    fullyConnectedLayer(100,"Name","fc_3")
    fullyConnectedLayer(1600,"Name","fc_4")
    regressionLayer("Name","regressionoutput")];
lgraph = addLayers(lgraph,tempLayers);

% clean up helper variable
clear tempLayers;
%%
%connect layer branches
lgraph = connectLayers(lgraph,"radiationPattern","conv_4");
lgraph = connectLayers(lgraph,"radiationPattern","conv_1");
lgraph = connectLayers(lgraph,"fc_2","addition/in1");
lgraph = connectLayers(lgraph,"fc_1","addition/in2");
%%
%plot layergraph
%plot(lgraph);
end