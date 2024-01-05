%clear all
%close all

maskFile=[meshOutPath,'RTopoUa_aux.nc'];
nod2dInFile=[extendedMeshPath,'nod2d.out'];
elem2dInFile=[extendedMeshPath,'elem2d.out'];

nod2dOutFile=[meshOutPath,'nod2d.out'];
elem2dOutFile=[meshOutPath,'elem2d.out'];

disp('load Rtopo...')

lon = ncread(maskFile,'lon');
lat = ncread(maskFile,'lat');

mask = ncread(maskFile,'amask');

%res=60;
%lonRT=[-180:1/res:180];
%latRT=[-90:1/res:90];

%fileID = fopen([mergedRtopoDir,'mergedamask-2022.bin']);
%mask = fread(fileID,[size(lonRT,2) size(latRT,2)]);
%fclose(fileID);

disp('load mesh...')

fid=fopen(nod2dInFile,'r');
n2d=fscanf(fid,'%g',1);
nodes=fscanf(fid, '%g', [4,n2d]);
nodes=nodes.';
fclose(fid);

%alpha=50;
%beta=15;
%gamma=-90;
%[x,y]=grid_rotate_r2g(alpha,beta,gamma,nodes(:,2),nodes(:,3));

x=nodes(:,2);
y=nodes(:,3);

nodind=nodes(:,4);

fid=fopen(elem2dInFile);
el2d=fscanf(fid,'%g',1);
elem=fscanf(fid,'%g',[3,el2d]);
elem=elem.';
fclose(fid);

disp('interpolate rtopo mask to fesom extended 2d mesh')

F = griddedInterpolant({lon,lat},single(mask),'nearest','nearest');
maskF = F(x,y);

rem_nod=maskF==1;
%rem_nod=GM>0.1;
n2d_new = n2d-sum(rem_nod);
x_new = x(~rem_nod);
y_new = y(~rem_nod);

rem_elem=zeros(el2d,1);
indmesh=nodind;
for ii=1:el2d
    nod=elem(ii,:);
    sum_rem_nod = sum(rem_nod(nod));
    
    if sum_rem_nod>0
        rem_elem(ii)=1;
    end
    if (sum_rem_nod==2) | (sum_rem_nod==1)
        indmesh(nod)=1;
    end   
end

elem_new=elem;
elem_new(rem_elem==1,:)=[];
el2d_new=el2d-sum(rem_elem);

cnt=0;
indnod_new=nan(n2d,1);
% for every old n2d node, we save the new node number 
% if node is removed, put nan
for ii=1:n2d
    if rem_nod(ii)==0
        cnt=cnt+1;
        indnod_new(ii)=cnt;
    end
end

%%% correct the node number in elem2d
for ii=1:el2d_new
   elem_new(ii,:)=indnod_new(elem_new(ii,:));
end

indmesh_new=indmesh(~rem_nod);

disp('write out nod2 and elem2d')

fid=fopen(nod2dOutFile,'w');
fprintf(fid,'%d\n',n2d_new);
for n=1:n2d_new
     fprintf(fid,'%10d %20.8f %20.8f %3d\n',n,x_new(n),y_new(n),indmesh_new(n));  
end
fclose(fid);
  

fid=fopen(elem2dOutFile,'w');
fprintf(fid,'%8i \n', el2d_new);
for ii=1:el2d_new
  fprintf(fid,'%8i %8i %8i \n',elem_new(ii,:));
end
fclose(fid);

%exit;
