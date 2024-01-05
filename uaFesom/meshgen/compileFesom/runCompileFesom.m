meshOutPath='/isibhv/netscratch/orichter/timmsmesh/io0036/2017.00/';
extendedMeshPath='/isibhv/netscratch/orichter/timmsmesh/io0036/extended/';
uaResultFile='/isibhv/netscratch/orichter/timmsdata/io0036/2017.00-Nodes129557-Ele254528-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat';
goodfile_path='/isibhv/netscratch/orichter/timmsmesh/io0036/meshgen.goodfile.2017.00';

vis=0;

disp('removeGroundedElements.m');
removeGroundedElements;

disp('removeLonely.m');
removeLonely;

disp('get_real_topo.m');
get_real_topo;

display('rotate the mesh');
rotate_mesh_g2r;

disp('ensure_pos_wctNovl2.m');
ensure_pos_wctNovl2;

%disp('reorder');
%reorder;

disp('makeFesom3d');
makeFesom3d;

pause(2);
disp('make_cavity');
make_cavity;

cd ..;

fid = fopen(goodfile_path,'w');
fid = fclose(fid);

exit;
