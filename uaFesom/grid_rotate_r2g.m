function [lon,lat]=grid_rotate_r2g(al, be, ga, rlon, rlat)


rad=pi/180;
al=al*rad;
be=be*rad;
ga=ga*rad;

%
rotate_matrix(1,1)=cos(ga)*cos(al)-sin(ga)*cos(be)*sin(al);
rotate_matrix(1,2)=cos(ga)*sin(al)+sin(ga)*cos(be)*cos(al);
rotate_matrix(1,3)=sin(ga)*sin(be);
rotate_matrix(2,1)=-sin(ga)*cos(al)-cos(ga)*cos(be)*sin(al);
rotate_matrix(2,2)=-sin(ga)*sin(al)+cos(ga)*cos(be)*cos(al);
rotate_matrix(2,3)=cos(ga)*sin(be);
rotate_matrix(3,1)=sin(be)*sin(al);
rotate_matrix(3,2)=-sin(be)*cos(al);
rotate_matrix(3,3)=cos(be);

%
rotate_matrix=inv(rotate_matrix);

%
rlat=rlat*rad;
rlon=rlon*rad;

% Rotated Cartesian coordinates:
xr=cos(rlat).*cos(rlon);
yr=cos(rlat).*sin(rlon);
zr=sin(rlat);

% Geographical Cartesian coordinates:
xg=rotate_matrix(1,1)*xr + rotate_matrix(1,2)*yr + rotate_matrix(1,3)*zr;
yg=rotate_matrix(2,1)*xr + rotate_matrix(2,2)*yr + rotate_matrix(2,3)*zr;
zg=rotate_matrix(3,1)*xr + rotate_matrix(3,2)*yr + rotate_matrix(3,3)*zr;

% Geographical coordinates:
lat=asin(zg);
lon=atan2(yg,xg);
a=find(yg==0 & xg==0);
lon(a)=0;

%
lat=lat/rad;
lon=lon/rad;

return
