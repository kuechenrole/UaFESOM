load('./ollieWork/io0021/uaData/1979.00-Nodes118387-Ele228356-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat', ...
    'MUA','BCs','F','CtrlVar')
% work in progress, but to color Ua plots with resolution, you can use the
% area of the elements and assume they are all equal sides a=sqrt(4A)*3^-1/4

%PlotElementBasedQuantities(MUA.connectivity,MUA.coordinates,sqrt(MUA.EleAreas.*4).*(3^(-1/4))./1000,CtrlVarInRestartFile)
% caxis([2 200])
%ylabel(cb,'Resolution in km','FontSize',12,'Rotation',270)



meshpath='./ollieWork/io0021/fesomMesh/1978.00/';

nod2d_file=[meshpath,'nod2d.out'];
elem2d_file=[meshpath,'elem2d.out'];
cflag_file=[meshpath,'cavity_flag_nod2d.out'];

derotate=1;

fid=fopen(nod2d_file,'r');
n2d=fscanf(fid,'%g',1);
nodes=fscanf(fid, '%g', [4,n2d]);
fclose(fid);
if derotate
    alpha=50;
    beta=15;
    gamma=-90;
    [nlon,nlat]=grid_rotate_r2g(alpha,beta,gamma,nodes(2,:),nodes(3,:));
else
    nlon=nodes(2,:);
    nlat=nodes(3,:);
end

fid=fopen(elem2d_file);
el2d=fscanf(fid,'%g',1);
elem=fscanf(fid,'%g',[3 el2d]);
fclose(fid);

[xFes,yFes]=polarstereo_fwd(nlat(ii)',nlon(ii)',6378137.0,0.08181919,-71,0);

MUAHack=MUA;
MUAHack.coordinates=[xFes yFes];
MUAHack.connectivity=elem';
MUAHack.Nele=el2d;

figure(1)
CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=0;
CtrlVar.PlotIndividualGLs=1 ; 
PlotMuaMesh(CtrlVar,MUAHack,[],'color','b','LineStyle','--','Marker','.') ;
hold on
PlotMuaMesh(CtrlVar,MUA,[],'k') ;
[xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,[],[],[],'color','r');
hold off

axis([-3000 3000 -3000 3000]);
savefig('./figures/meshTotal.fig');
saveas(gcf,'figures/meshTotal.png');

%axis([-1560 -400 80 1100]);
%savefig('./figures/meshFRIS.fig');
%saveas(gcf,'figures/meshFRIS.png');

%axis([-1700 -1450 -400 0]);
%savefig('./figures/meshPIG.fig');
%saveas(gcf,'figures/meshPIG.png');

%%
figure(2)
CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=0;
CtrlVar.PlotIndividualGLs=1 ; 
PlotMuaMesh(CtrlVar,MUAHack,[],'color','b','LineStyle','--','Marker','.') ;
hold on
PlotMuaMesh(CtrlVar,MUA,[],'color','k','LineWidth',2) ;
[xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,[],[],[],'color','r','LineWidth',2);
hold off

%axis([-1700 -1550 -375 -250]);
%axis([-1600 -1565 -345 -320]);
axis([-1545 -1500 -520 -480]);
savefig('./figures/meshDetail.fig');
saveas(gcf,'figures/meshDetail.png');

%example of creating a box inside the figure, maybe usefull for later
%axes('position',[.65 .175 .25 .25])
%box on
%PlotMuaMesh(CtrlVar,MUA,[],'k'); axis([-1500 -500 0 1000]);

%%
maskfile='ollieWork/oo0012/fesomInitialMesh/2dExtended/RTopo-2.0.4_30sec_mesh_gen_mask_CI11_cpl.nc';
maskM=ncread(maskfile,'topo');
latM=ncread(maskfile,'lat');
lonM=ncread(maskfile,'lon');

densfile='ollieWork/oo0012/fesomInitialMesh/2dExtended/density_COARZE_mesh_improved_11_cpl_or3.nc';
dens=ncread(densfile,'density');
lat=ncread(densfile,'lat');
lon=ncread(densfile,'lon');

%maskfile='/isibhv/projects/oce_rio/rtimmerm/RTopo-2/compile_rtopo2_0_4/RTopo-2.0.4_1min_aux_2019-07-12.nc';
%lonM=ncread(maskfile,'lon');
%latM=ncread(maskfile,'lat');
%maskM=ncread(maskfile,'amask');

[lonM2d,latM2d]=meshgrid(lonM(1,1:10:end),latM(2,1:10:end));
F = griddedInterpolant(lonM2d',latM2d',single(maskM(1:10:end,1:10:end)),'nearest','none');

[lon2d,lat2d]=meshgrid(lon,lat);
mask=F(lon2d',lat2d');

%dens((mask==1) | (mask==3))=NaN;
dens(mask>0)=NaN;

figure(3)
%levels=[2,5,10,20,50,100,200,400];
levels=[2,3,4,5,6,7,8,9,10,20];
%contourf(lon,lat,log(dens'),log(levels),'LineColor','None')
contourf(lon,lat,log(dens'))
colormap(parula)
%hold on
%contour(lon,lat,dens',levels,'k')
%hold off
c=colorbar;
c.TickLabels=string(round(exp(str2double(c.TickLabels))));
ylabel(c,'Resolution in km');
%savefig('./figures/densTotal.fig');
saveas(gcf,'figures/densTotal.png');

figure(4)
contourf(lon,lat,log(dens'))
colormap(parula)
c=colorbar;
c.TickLabels=string(round(exp(str2double(c.TickLabels))));
xlabel('Longitude in deg')
ylabel('Latitude in deg')
ylabel(c,'Resolution in km');
axis([-180 180 -86 -50])
%axis([-130 -75 -76 -64]);
%savefig('./figures/densDetailPIG.fig');
axes('position',[.5 .12 .25 .25])
box on
contourf(lon,lat,log(dens'))
axis off
saveas(gcf,'figures/densSouth.png');

axis([-130 -75 -76 -64]);
%savefig('./figures/densDetailFRIS.fig');
saveas(gcf,'figures/densDetailFRIS.png');
