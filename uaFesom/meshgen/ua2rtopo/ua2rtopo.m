%This script interpolates Ua's results onto Rtopos grid.
%

uaResultFile='/isibhv/netscratch/orichter/timmsdata/io0036/2017.00-Nodes129557-Ele254528-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat';
meshOutPath='/isibhv/netscratch/orichter/timmsmesh/io0036/2017.00/';
outfile=[meshOutPath,'ua2rtopo.nc'];

res=60; %Rtopo uses 1/60 deg resolution, so this is set here and should be consitent to what is set in compile_rtopo_ua.pro 
vis=0;  %visualisation or not

%check if outfile exist already; if so, delete it
if isfile(outfile)
    delete(outfile);
end

%load Ua fields. Ua's computational grid is set on a polar stereographic projection with x and y in meter
load(uaResultFile);
xUa = MUA.coordinates(:,1);
yUa = MUA.coordinates(:,2);

%define the grid we want to interpolate to using the polarstereo_fwd function with the parameters set that Rtopo uses (WGS84;
%[X,Y]=POLARSTEREO_FWD(LAT,LONG,EARTHRADIUS,ECCENTRICITY,LAT_TRUE,LON_POSY))
lonRT=[-180:1/res:180];
latRT=[-90:1/res:-50];
[lonRT2d,latRT2d]=meshgrid(lonRT,latRT);
[xRT,yRT] = polarstereo_fwd(latRT2d,lonRT2d,6378137.0,0.08181919,-71,0);

%Find the points of the target grid, which are outside of Ua's computaional domain (Ua only knows regions with grounded or floating ice;
%no ocean, no sea-ice). Upon first inspection, MUA.TR is identical to what a delauny triangulation would come back with (incl. boundary 
%constraints from Ua's MeshBoundaryCoordinates)
xRTf = xRT(:); yRTf = yRT(:); %flatten the arrays from 2d to 1d
[ti,bc]=pointLocation(MUA.TR,[xRTf yRTf]); %Find the triangle that encloses each query point (Ua's triangles are MUA.TR)
% ti contains the IDs of the enclosing triangles and bc contains the barycentric coordinates associated with each triangle
good = ~isnan(ti);
xRTfi = xRTf(good);yRTfi=yRTf(good); %repeat the process with just the points inside Ua's domain
[ti,bc]=pointLocation(MUA.TR,[xRTfi yRTfi]);

%once the enclosing triangles and the distances to the query points are known; these can be used for each field to be interpolated to the query
%points (I use my own function for this, defining a fill value at the end)
gfRT = interpMua(F.GF.node,ti,bc,xRTf,xRT,good,MUA,2);
sRT = interpMua(F.s,ti,bc,xRTf,xRT,good,MUA,0);
BRT = interpMua(F.B,ti,bc,xRTf,xRT,good,MUA,0);
hRT = interpMua(F.h,ti,bc,xRTf,xRT,good,MUA,0);

if vis
    fprintf(' Generating some figures ...')
    figure(10) ; imagesc(lonRT,latRT,gfRT); title(' GF ' ) ; colorbar ; axis tight;
    figure(20) ; imagesc(lonRT,latRT,sRT); title(' s ' ) ; colorbar ; axis tight;
    figure(30) ; imagesc(lonRT,latRT,BRT); title(' B ' ) ; colorbar ; axis tight;
    figure(40) ; imagesc(lonRT,latRT,hRT); title(' h ' ) ; colorbar ; axis tight;
    figure(50) ; imagesc(lonRT,latRT,lonRT2d); title(' lon ' ) ; colorbar ; axis tight;
    figure(60) ; imagesc(lonRT,latRT,latRT2d); title(' lat ' ) ; colorbar ; axis tight;
    drawnow ; fprintf('done.\n')
end

%write out to netcdf

nccreate(outfile,'res','Dimensions',{'resn',1});
nccreate(outfile,'lat','Dimensions',{'lonn',size(xRT,2),'latn',size(xRT,1)});
nccreate(outfile,'lon','Dimensions',{'lonn',size(xRT,2),'latn',size(xRT,1)});
nccreate(outfile,'GF','Dimensions',{'lonn',size(xRT,2),'latn',size(xRT,1)});
nccreate(outfile,'B','Dimensions',{'lonn',size(xRT,2),'latn',size(xRT,1)});
nccreate(outfile,'s','Dimensions',{'lonn',size(xRT,2),'latn',size(xRT,1)});
nccreate(outfile,'h','Dimensions',{'lonn',size(xRT,2),'latn',size(xRT,1)});
ncwrite(outfile,'res',res);
ncwrite(outfile,'lat',latRT2d.');
ncwrite(outfile,'lon',lonRT2d.');
ncwrite(outfile,'GF',gfRT.');
ncwrite(outfile,'B',BRT.');
ncwrite(outfile,'s',sRT.');
ncwrite(outfile,'h',hRT.');

exit;

function Vq = interpMua(V,ti,bc,xRTf,xRT,good,MUA,fillVal)
    Vq=ones(size(xRTf)).*fillVal; % put the fill value in everywhere
    triVals=V(MUA.TR(ti,:)); % Find the values of V(x,y) at the vertices of each enclosing triangle.
    Vq(good)=dot(bc',triVals'); % Calculate the sum of the weighted values of V(x,y) using the dot product.
    Vq=reshape(Vq,size(xRT)); %reshape from 1d to 2d again
end

