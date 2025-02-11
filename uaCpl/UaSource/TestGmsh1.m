%%
close all ; clear all

% call gmsh, and gmsh meshes all surfacces (-2 flag)
% and writes out a msh file
! gmsh-2.6.1-Windows/gmsh.exe t1.geo -2 

Gmsh=load_gmshGHG('t1.msh');

TRI=Gmsh.TRIANGLES(1:Gmsh.nbTriangles,1:3);
xy=Gmsh.POS(1:Gmsh.nbNod,1:2);
triplot(TRI,xy(:,1),xy(:,2)) ; axis equal

