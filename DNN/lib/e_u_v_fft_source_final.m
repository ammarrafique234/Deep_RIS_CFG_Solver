function [e_abs, e_theta, e_phi ...
    ] = e_u_v_fft_source_final(theta_vec,phi_vec,THETA,PHI,M,N,config_mat...
    ,e_theta_cmplx_edited,e_phi_cmplx_edited...
    ,freq, metaatom_size_m...
    ,varargin)
%function [e_abs, e_theta, e_phi] = e_theta_phi(theta,phi)
%E_THETA_PHI returns far region E-field for theta and phi in degrees
%   R is assumed to be r NOT= 0.62*sqrt(D^3/lambda) and r is= 2*D^2/lambda
%   frequency is assumed to be 12GHz.
% successfully vectorized @ 3:36pm 24-nov-2020
% Last updated @ 02-march-2020
%%
if(nargin==12)
    theta_phi_mat = varargin{1,1};
    skip_mat = 1-theta_phi_mat;
else
    skip_mat = zeros(THETA,PHI);
end
%Theta Phi vector range check
if((max(theta_vec)>180)||(max(phi_vec)>359))
    error("Theta>180 or Phi > 359");
end
%%
%Define array size and probe location
%M; % array elements x
%N; % array elements y

%%
%Determine location of centre of each metaatom
% does not depend on theta phi r values
%freq= 12e9; get as
lambda=2.99792458e8/freq;
%d = min(0.5*lambda,metaatom_size_m); %spaceshift in array step in m
d = metaatom_size_m; %spaceshift in array step in m
D = sqrt( (d*M)^2 + (d*N)^2 );% largest dimension of array
%r = 0.62*sqrt(D^3/lambda);% radius of far-field location in m
r = 8;%2*(D^2/lambda);% radius of far-field location in m
% x and y coordinates switched to match paper results
ycoords = repmat(d*((1:M)'-M/2-1/2),1,N);%was mid points of metaatoms in x
xcoords = repmat(d*((1:N)-N/2-1/2),M,1);% was mid points of metaatoms in y
zcoords = zeros(M,N);
%%
% [sourcex, sourcey, sourcez] = sphTOcart(90,0,r); % in paper source is at phi=90, theta=0, z=398 mm 
%sourcex = 0; sourcey= tan((0)*pi/180)*398/1000; sourcez = 398/1000;
sourcex = 0; sourcey= 0; sourcez = 0.5;
sxi = sourcex - xcoords;
syi = sourcey - ycoords;
szi = sourcez - zcoords;
sr = sqrt( sxi.*sxi + syi.*syi + szi.*szi);
Amn = 1; % assuming spherical wave, same for all
f_d_source = exp(-1j*2*1*pi*sr/lambda); % path phase delay
%%
%depends on theta phi i.e u v
%For u v conversion
theta_val = repmat((0:90)',1,360);
phi_val = repmat((0:359),91,1);
[u_val, v_val] = sphTOuv(theta_val, phi_val);
probex = r*u_val;
probey = r*v_val;
probez = r*sqrt(1 - (u_val.*u_val*0.999999 + v_val.*v_val*0.999999) ); % Multiplying by 0.999999 avoids cases with complex output. These cases occur due to trucation error.
%%
%Define configuration of each reconfigurable metaatom
%config_mat=zeros(M,N); %this must be taken as argument
%%
%Preallocating variables
e_abs = zeros(THETA,PHI);


e_theta = zeros(THETA,PHI);
e_phi = zeros(THETA,PHI);

[u_points, v_points, n_cfg]=size(e_theta_cmplx_edited);
ustep = (1 - -1)/(u_points -1);% -1 for 0 to 1999 mapping for 1 to 2000
vstep = (1 - -1)/(v_points -1);% -1 for 0 to 1999 mapping for 1 to 2000

% Loop over theta and phi
    for theta=theta_vec+1
        for phi=phi_vec+1
            %%skip iter if skip logic is true
            if(skip_mat(theta,phi)==1)
                continue;
            end
%%
            %Determine "metaatom to probe" vector for each metaatom, in phi
            %theta and r depends on theta phi r values
            xi = probex(theta,phi)-xcoords;
            yi = probey(theta,phi)-ycoords;
            zi = probez(theta,phi)-zcoords;
            
            %%
            % faster way
            r_coords = sqrt(xi.*xi + yi.*yi + zi.*zi );
            u_coords2 = xi./r_coords;
            v_coords2 = yi./r_coords;
            
            uidx = floor(u_points/2 + 1 + 0.5 + u_coords2/ustep);
            vidx = floor(v_points/2 + 1 + 0.5 + v_coords2/vstep);
            
            %
                        
%%
%Determine contribution of each metaatom @probe as Etheta Ephi complex

% e1_phi_cmplx is e_field of metatom defined for each phi/theta config1 in
% phi_vector
% e1_theta_cmplx is mag of metatom defined for each phi/theta config1 in
% theta_vector
% e_01_deg_theta is phase of metatom defined for each phi/theta config1 in
% theta_vector, values are in radians and indexed by degrees 1:1:181
        
            %submatrix index conversion, adjusted for u v
            idx = sub2ind([u_points v_points n_cfg],uidx,vidx,config_mat+1); % +1 for avoiding 0;

        
                
            % ex(theta,phi) = ex1_cst(theta_mn,phi_mn)*exp(-j*kr)
            e_t1 = e_theta_cmplx_edited(idx);
            % ey(theta,phi) = ey1_cst(theta_mn,phi_mn)*exp(-j*kr)
            e_p1 = e_phi_cmplx_edited(idx);

            
            
            % e in direction of theta vector, accumulated over MxN elements
            e_theta_tmp =  e_t1;
            
            % e in direction of phi vector, accumulated over MxN elements
            e_phi_tmp =  e_p1;
                    
            % accounting for phasedelay
            % d_t = 2*pi*r_mn/lambda
            d_t=2*pi* r_coords /lambda;% phase delay
            factor_dt = exp(1j*d_t);

            %%
            e_theta_delayed = Amn.*f_d_source.*e_theta_tmp.*factor_dt;
            
            e_phi_delayed = Amn.*f_d_source.*e_phi_tmp.*factor_dt;
            %%
            % combined response of metasurface in theta_vector and
            % phi_vector @(phi,theta,r_farfield)
            e_theta(theta,phi)  = sum(sum(e_theta_delayed));            
            e_phi(theta,phi)    = sum(sum(e_phi_delayed));
            
            % e_absolute @(theta,phi,r_farfield)
            e_abs(theta,phi) = sqrt(abs(e_theta(theta,phi)).^2 +...
                abs(e_phi(theta,phi)).^2);            
         
        end
    end
end