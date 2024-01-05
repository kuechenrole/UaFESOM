MeshDir=meshOutPath;

fid=fopen([MeshDir,'nod2d.out'],'r');
nod2D=fscanf(fid,'%d',[1 1])
A=zeros(nod2D,4);
for i=1:nod2D
    A(i,:)=fscanf(fid,'%d %f %f %d',[1 4]);
end
fclose(fid);
lon=A(:,2);
lat=A(:,3);

% rotate mesh 
[rlon,rlat]=grid_rotate_g2r(50,15,-90,lon,lat);

% I added these lines and then moved them into grid_rotate_g2r    vhaid
% ai=find(rlon<0);
% rlon(ai)=rlon(ai)+360;

fid=fopen([MeshDir,'nod2d.out'],'wt');
fprintf(fid,'%d \n',nod2D);
for i=1:nod2D
    fprintf(fid,'%d %f %f %d \n',A(i,1),rlon(i),rlat(i),A(i,4));
end
fclose(fid);


% rotate back 
% [rrlon,rrlat]=grid_rotate_r2g(50,15,-90,rlon,rlat);
% 
% fid=fopen([MeshDir,'nod2d_relax_rotated_back.out'],'wt');
% fprintf(fid,'%d \n',nod2D);
% for i=1:nod2D
%     fprintf(fid,'%d %f %f %d \n',A(i,1),rrlon(i),rrlat(i),A(i,4));
% end
% fclose(fid);

