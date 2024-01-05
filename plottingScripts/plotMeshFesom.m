
%%
basedir = '/albedo/work/projects/oce_rio/orichter/ollieWork/Misomip2/';
maskfile=[basedir,'oo0012/fesomInitialMesh/2dExtended/RTopo-2.0.4_30sec_mesh_gen_mask_CI11_cpl.nc'];
maskM=ncread(maskfile,'topo');
latM=ncread(maskfile,'lat');
lonM=ncread(maskfile,'lon');

densfile=[basedir,'oo0012/fesomInitialMesh/2dExtended/density_COARZE_mesh_improved_11_cpl_or3.nc'];
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
dens(dens<2)=2;
%%
f = figure;
f.Position = [100 100 740 600];
newdens=dens;
tickVals = linspace(2,300,9);
newTickVals=[0,2,5,10,20,50,100,200,300];
for tv = 2:length(newTickVals)
    % find all data between the new tick ranges, one block at a time
    ind = dens>newTickVals(tv-1) & dens<=newTickVals(tv);
    % Change the corresponding values in the copied data to scale to the
    % block edges
    newdens(ind) = rescale(dens(ind),tickVals(tv-1),tickVals(tv));
end
contourf(lon,lat,newdens',tickVals)
C=parula(8);
%C(end+1,:)=1;
colormap(C);
cb=colorbar('Ticks',tickVals,...
    'TickLabels',["0" "2" "5" "10" "20" "50" "100" "200" "300"])
%title(cb, 'Resolution in km')
ylabel(cb,'Resolution in km')
set(gcf,'color','w');
fontsize(gcf,16,"points");
xlabel(['longitude (' char(176) ')']);
ylabel(['latitude (' char(176) ')']);
pos = get(gca, 'Position');
set(gca, 'Position', [pos(1) pos(2) pos(3)-0.02 pos(4)]);
%savefig('./figures/densTotal.fig');
saveas(gcf,'figures/fesomResolutionTotal.png');



%%
f = figure;
f.Position = [100 100 740 600];
newdens=dens;
tickVals = linspace(2,300,11);
newTickVals=[0,2,4,8,10,15,20,35,50,100,200];
for tv = 2:length(newTickVals)
    % find all data between the new tick ranges, one block at a time
    ind = dens>newTickVals(tv-1) & dens<=newTickVals(tv);
    % Change the corresponding values in the copied data to scale to the
    % block edges
    newdens(ind) = rescale(dens(ind),tickVals(tv-1),tickVals(tv));
end
contourf(lon,lat,newdens',tickVals)
C=parula(10);
%C(end+1,:)=1;
colormap(C);
cb=colorbar('Ticks',tickVals,...
    'TickLabels',["0" "2" "4" "8" "10" "15" "20" "35" "50" "100" "200"])
axis([-180 180 -87 -57])
ylabel(cb,'Resolution in km')
set(gcf,'color','w');
fontsize(gcf,16,"points");
xlabel(['longitude (' char(176) ')']);
ylabel(['latitude (' char(176) ')']);
pos = get(gca, 'Position');
set(gca, 'Position', [pos(1) pos(2) pos(3)-0.02 pos(4)]);
%pos = get(gca, 'Position');
%set(gca, 'Position', [pos(1)-1 pos(2) pos(3)+1 pos(4)]);
saveas(gcf,'figures/fesomResolutionSouthOwnColobar.png')


%%
f = figure;
f.Position = [100 100 540 400];
newdens=dens;
tickVals = linspace(2,50,9);
newTickVals=[0,2,5,10,15,20,30,40,50];
for tv = 2:length(newTickVals)
    % find all data between the new tick ranges, one block at a time
    ind = dens>newTickVals(tv-1) & dens<=newTickVals(tv);
    % Change the corresponding values in the copied data to scale to the
    % block edges
    newdens(ind) = rescale(dens(ind),tickVals(tv-1),tickVals(tv));
end
contourf(lon,lat,newdens',tickVals)
axis([-180 180 -87 -57])

C=parula(8);
%C(end+1,:)=1;
colormap(C);
cb=colorbar('Ticks',tickVals,...
    'TickLabels',["0" "2" "5" "10" "15" "20" "30" "40" ">50"])
ylabel(cb,'Resolution in km')
set(gcf,'color','w');
fontsize(gcf,12,"points");
xlabel(['longitude (' char(176) ')']);
ylabel(['latitude (' char(176) ')']);
%savefig('./figures/densTotal.fig');
%saveas(gcf,'figures/fesomResolutionTotal.png');
%%





%levels=[2,3,4,5,6,7,8,9,10,20];
%contourf(lon,lat,log(dens'),log(levels),'LineColor','None')
%contourf(lon,lat,log(dens'))
contourf(lon,lat,dens',levels)
%set(gca,'colorscale','log');
%colormap(parula);
%hold on
%contour(lon,lat,dens',levels,'k')
%hold off
c=colorbar;
%set(cb,'YTick',log([2 10 20 30 40 50 60]));
%%
%c.TickLabels=string(round(exp(str2double(c.TickLabels))));
ylabel(c,'Resolution in km');
set(gcf,'color','w');
fontsize(gcf,12,"points");
xlabel(['longitude (' char(176) ')']);
ylabel('latitude')
%savefig('./figures/densTotal.fig');
%%saveas(gcf,'figures/densTotal.png');


%%
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
%saveas(gcf,'figures/densSouth.png');

axis([-130 -75 -76 -64]);
%savefig('./figures/densDetailFRIS.fig');
%saveas(gcf,'figures/densDetailFRIS.png');
