function [u,v] = sphTOuv(theta,phi)
%GET_UV Converts theta phi in deg to u and v
%   Detailed explanation goes here
u = sin(theta*pi/180).*cos(phi*pi/180);
v = sin(theta*pi/180).*sin(phi*pi/180);
end