function [rlon,rlat]=grid_rotate_g2r(al, be, ga, lon, lat)


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
lat=lat*rad;
lon=lon*rad;

% geographical Cartesian coordinates:
xr=cos(lat).*cos(lon);
yr=cos(lat).*sin(lon);
zr=sin(lat);

% rotated Cartesian coordinates:
xg=rotate_matrix(1,1)*xr + rotate_matrix(1,2)*yr + rotate_matrix(1,3)*zr;
yg=rotate_matrix(2,1)*xr + rotate_matrix(2,2)*yr + rotate_matrix(2,3)*zr;
zg=rotate_matrix(3,1)*xr + rotate_matrix(3,2)*yr + rotate_matrix(3,3)*zr;

% rotated coordinates:
rlat=asin(zg);
rlon=atan2(yg,xg);
a=find(yg==0 & xg==0);
rlon(a)=0;

%
rlat=rlat/rad;
rlon=rlon/rad;

% addition by vhaid
ai=find(rlon<0);
rlon(ai)=rlon(ai)+360;
ai=find(rlon>360);
rlon(ai)=rlon(ai)-360;
return
