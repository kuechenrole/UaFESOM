fesomMeltPath= '/isibhv/netscratch/orichter/timmsdata/io0036/io0036.2017.00.forcing.diag.nc';
fesomMeshPath= '/isibhv/netscratch/orichter/timmsmesh/io0036/2017.00/';
interpolantOutPath= '/isibhv/netscratch/orichter/timmsdata/io0036/Fab.2017.00.mat';

%arguments
fprintf('loading file: %-s ',fesomMeltPath)
wnetFes = ncread(fesomMeltPath,'wnet');
wnetFes = mean(double(wnetFes),2);
fprintf(' done \n')

fprintf('loading coordinates and mask from folder: %-s ',fesomMeshPath)
fid=fopen([fesomMeshPath,'nod2d.out'],'r');
n2d=fscanf(fid,'%g',1);
nodes=fscanf(fid, '%g', [4,n2d]);
fclose(fid);

fid=fopen([fesomMeshPath,'cavity_flag_nod2d.out'],'r');
cflag=fscanf(fid,'%g',n2d);
fclose(fid);
fprintf(' done \n')

[lonFes,latFes]=grid_rotate_r2g(50,15,-90,nodes(2,:),nodes(3,:));
lonFes=transpose(lonFes(cflag==1)); latFes=transpose(latFes(cflag==1));
[xFes,yFes]=polarstereo_fwd(latFes,lonFes,6378137.0,0.08181919,-71,0);

wnetFes=wnetFes(cflag==1);

Fab = scatteredInterpolant(xFes,yFes,wnetFes,'linear','nearest');

fprintf('Saving Fab interpolant. \n ')
save(interpolantOutPath,'Fab')
