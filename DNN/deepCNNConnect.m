function lgraph = deepCNNConnect(dagnet)
%isPretrained=true;

%%
%create Layer Graph
lgraph = layerGraph(dagnet);
%%
%plot layergraph
%plot(lgraph);
end