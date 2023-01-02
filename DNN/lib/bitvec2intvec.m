function [intVec] = bitvec2intvec(bitVec,groupSize)
%BINVEC2INTVEC Converters groups of bits as vector to interger vector
%   Detailed explanation goes here
[rbin,cbin] = size(bitVec);
cdec=floor(cbin/groupSize);
rdec = rbin;
%tmp = reshape(bitVec, nbits,1);
tmp = reshape(bitVec', groupSize,[]);
intVec = (2.^(groupSize-1:-1:0))*tmp;
intVec = reshape(intVec, cdec, rdec)';
end