% make cavity
% modify the 3D mesh to remove the elements where ice shelf locates
%
% Qiang, 05.02.2017
%--------------------------------------------------------------------

%close all
%clear all

%--------------------------------------------------------------------
% user specification starts here:
vis=0;
% paths
%meshpath='/work/ollie/cwekerle/MG/mesh_jigsaw_79NG/';
%meshpath='/work/ollie/cwekerle/MG/mesh_jigsaw_79NG/mesh_79NG_coarse4_final2/'
meshpath=meshOutPath;

% Loading mesh:
disp('Loading mesh ...')

rotate_grid=1;
alpha=50;
beta=15;
gamma=-90;

fid=fopen([meshpath,'nod2d.out']);
n2d=fscanf(fid,'%g',1);
nodes2=fscanf(fid,'%g', [4,n2d]);
fclose(fid);
xcoord=nodes2(2,:);
ycoord=nodes2(3,:);
% icoord=nodes(4,:);
%clear nodes2

if rotate_grid
  [xcoord,ycoord]=grid_rotate_r2g(alpha,beta,gamma,xcoord,ycoord);
end

fid=fopen([meshpath, 'elem2d.out']);
e2d=fscanf(fid,'%g', 1);
elem2=fscanf(fid,'%g', [3,e2d]);
fclose(fid);

fid=fopen([meshpath,'nod3d.out'],'r');
n3d=fscanf(fid,'%g',1);
nodes3=fscanf(fid,'%g',[5 n3d]);
fclose(fid);

fid=fopen([meshpath,'elem3d.out'],'r');
e3d=fscanf(fid,'%g',1);
elem3=fscanf(fid,'%g', [4,e3d]);
fclose(fid);

fid=fopen([meshpath,'aux3d.out'],'r');
nl=fscanf(fid,'%g',1);
nod32=fscanf(fid,'%g', [nl n2d]);
nod23=fscanf(fid,'%g', n3d);
elem23=fscanf(fid,'%g',e3d);
fclose(fid);

fid=fopen([meshpath,'depth.out'],'r');
depth=fscanf(fid,'%g',n2d);
fclose(fid);

fid=fopen([meshpath,'shelf.out'],'r');
shelf=fscanf(fid,'%g',n2d);
fclose(fid);

fid=fopen([meshpath,'cavity_flag_nod2d.out'],'r');
cavity_flag=fscanf(fid,'%g',n2d);
fclose(fid);


% %%% test
% ind=find(shelf<0);
% shelf(ind)=-10.;
%%%
%---------------------------------------------------------
disp('Modifying the mesh ...')

% model grid layers
dep_lev=unique(nodes3(4,:));
dep_lev=sort(dep_lev,'descend');
numlay=length(dep_lev);
% layer center
dep_mid=(dep_lev(1:end-1)+dep_lev(2:end))/2;

% determine the bottom level according to ice shelf bathymetry
% there could be ice shelf nodes extending into the water, but this will not
% cause damage.
sb_lev=ones(1,n2d);
for i=1:n2d
    if (shelf(i)>=0) continue, end
    a=find(dep_mid<=shelf(i));
    sb_lev(i)=a(1);
    if(a(1)==1) 
        disp('Error, ice shelf got zero thickness')
        return
    elseif(isempty(a))
        disp('Error, ice shelf reaches the ocean bottom')
        return       
    end
end


if vis
figure
s=10;
scatter(xcoord(cavity_flag==1),ycoord(cavity_flag==1),s,...
    depth(cavity_flag==1),'filled')
caxis([-900 0])
colormap jet(18)
title('depth')
colorbar

figure
s=10;
scatter(xcoord(cavity_flag==1),ycoord(cavity_flag==1),s,...
    shelf(cavity_flag==1),'filled')
%caxis([-900 0])
colorbar
title('shelf depth in m')
colormap(jet)
colormap jet(18)
% hold onclose all

figure
s=20;
scatter(xcoord(cavity_flag==1),ycoord(cavity_flag==1),s,...
    depth(cavity_flag==1)-shelf(cavity_flag==1),'filled')
caxis([-40 0])
colormap(jet)
colormap jet(18)
colorbar
title('(depth - shelf) in m')
colormap(bluewhitered)

% plot(nodes3(2,ind),nodes3(3,ind),'b*')


figure
s=10;
scatter(xcoord(cavity_flag==1),ycoord(cavity_flag==1),s,...
    sb_lev(cavity_flag==1),'filled')
caxis([1 50])
colorbar
title('sb lev')
colormap jet

figure
s=15;
scatter(xcoord(cavity_flag==1),ycoord(cavity_flag==1),s,...
    dep_lev(sb_lev(cavity_flag==1)),'filled')
caxis([-50 0])
colorbar
title('dep sb lev')
colormap jet(18)


diff=depth(cavity_flag==1)-dep_lev(sb_lev(cavity_flag==1))';
figure
s=10;
scatter(xcoord(cavity_flag==1),ycoord(cavity_flag==1),s,...
    diff,'filled')
caxis([-40 40])
colormap(bluewhitered)
colorbar
title('(depth - depth level) in m ')
ind=find(diff>0);
end


% determine surface level in the cavity region
ss_lev=sb_lev;
for i=1:e2d
    aux=min(sb_lev(elem2(:,i)));
    for j=1:3
        ss_lev(elem2(j,i))=min([ss_lev(elem2(j,i)), aux]);
    end
end
%figure
%s=20;
%scatter(xcoord(cavity_flag==1),ycoord(cavity_flag==1),s,...
%    sb_lev(cavity_flag==1)-s(cavity_flag==1),'filled')
%caxis([-40 0])
%colormap(jet)
%colormap jet(18)
%colorbar
%title('(depth - shelf) in m')
%colormap(bluewhitered)
if vis
figure
s=15;
scatter(xcoord(cavity_flag==1),ycoord(cavity_flag==1),s,...
    dep_lev(ss_lev(cavity_flag==1)),'filled')
caxis([-900 0])
colorbar
title('dep ss lev')
colormap jet(18)

%%% problems at the boundary (ocean values are sb_lev=1, and should not be taken into account)
% ss_lev=sb_lev;
% for i=1:e2d
%     aux1=cavity_flag(elem2(:,i))';
%     aux2=sb_lev(elem2(:,i)).*aux1;
%     aux2(aux2==0)=[];
%     aux=aux2;
%     %aux=min(sb_lev(elem2(:,i)));
%     for j=1:3
%         ss_lev(elem2(j,i))=min([ss_lev(elem2(j,i)), aux]);
%     end
% end

figure
s=15;
scatter(xcoord(cavity_flag==1),ycoord(cavity_flag==1),s,...
    sb_lev(cavity_flag==1)-ss_lev(cavity_flag==1),'filled')
colorbar
caxis([-10 10])
colorbar
title('sb lev - ss lev')
colormap jet

figure
s=15;
scatter(xcoord(cavity_flag==1),ycoord(cavity_flag==1),s,...
    sb_lev(cavity_flag==1),'filled')
colorbar
hold on
%plot(xcoord(i),ycoord(i),'r*')
end

disp('3D nodes ...')
% remove 3D nodes
% find which nodes should be removed
% and correct index
ppp=1
indnod=zeros(1,n3d);
for i=1:n2d
     if (shelf(i)>=0), continue, end
     n=nod32(1,i);
     %nodes3(5,n)=11;
     %if(ss_lev(i)==sb_lev(i)), nodes3(5,n)=10; end
     nodes3(4,n)=dep_lev(ss_lev(i));
     
     for k=2:1:ss_lev(i)
         n=nod32(k,i);
         indnod(n)=1;
     end
     for k=ss_lev(i)+1:1:sb_lev(i)-1
        n=nod32(k,i);
         %if n==-999
         %    ppp=[ppp i]
         %else
            nodes3(5,n)=21;
        %end
     end    
end

depth(i)
ss_lev(i)
sb_lev(i)
shelf(i)

if vis
figure
s=15;
scatter(xcoord(cavity_flag==1),ycoord(cavity_flag==1),s,...
    sb_lev(cavity_flag==1),'filled')
colorbar
hold on
plot(xcoord(i),ycoord(i),'r*')

figure
s=20;
scatter(xcoord(cavity_flag==1),ycoord(cavity_flag==1),s,...
    depth(cavity_flag==1),'filled')
colorbar
caxis([-300 0])
hold on
colormap(jet)
plot(xcoord(i),ycoord(i),'r*')
end

% new nodes index
newind=cumsum(indnod);
newind=[1:n3d]-newind;

% remove those nodes (where indnod==1)
% the shelf surface nodes are put into the first 1:n2d nodes
nodes3(:,indnod==1)=[];
nod23(indnod==1)=[];
n3d=size(nodes3,2);
nodes3(1,:)=[1:n3d];

disp('nod32 ...')
% new nod32
nod32n=zeros(numlay,n2d);
nod32n(:)=-999;
checklay=numlay;
for i=1:n2d
    nod32n(1,i)=i;
    lay=1;
    for k=ss_lev(i)+1:numlay
        n=nod32(k,i);
        if(n<0); break; end  
        lay=lay+1;      
        nod32n(lay,i)=newind(n);
    end
    checklay=min(checklay,lay);
end
disp('minimal number of layers:')
disp(num2str(checklay))

ind=find(nod32n(1,:)==-999)

num_layers_cav=zeros(n2d,1);
for ii=1:n2d
   if nod32(1,ii)<0
       ind=find(nod32(:,ii)>0)
       num_layers_cav(ii)=1;%length(ind);
   end
end
if vis
figure
s=10;
scatter(xcoord,ycoord,s,nodes3(4,1:n2d),'filled')
% caxis([0 50])
% colormap(jet(50))
colorbar
set(gca,'xlim',[-23 -18.8],'ylim',[78.6 79.9])
colorbar
end

% correct indnod and newind
% the corrected array is required to correct elem3d: the surface nodes
% were removed, not the shelf surface nodes
for i=1:n2d
    if(ss_lev(i)>1)
        indnod(i)=1;
        indnod(nod32(ss_lev(i),i))=0;
        newind(nod32(ss_lev(i),i))=i;
    end
end

disp('3D elements ...')
% remove 3D elements
indelem=zeros(1,e3d);
indnod(indnod==1)=NaN;
for i=1:e3d
    if(isnan(sum(indnod(elem3(:,i)))))
        indelem(i)=1;
    else
        elem3(:,i)=newind(elem3(:,i));
    end
end
elem3(:,indelem==1)=[];
e3d=size(elem3,2);
elem23(indelem==1)=[];
    
% "surface nodes" should be the first 1:n2d nodes




%
%----------------------------------------------------------
%save
disp('Saving result ...')

fid = fopen([meshpath,'nod3d.out'],'w');
fprintf(fid,'%9i \n',n3d);
fprintf(fid,'%9i %9.4f %9.4f %9.2f %3i\n',nodes3);
fclose(fid);

fid = fopen([meshpath,'aux3d.out'],'w');
fprintf(fid,'%5i \n',numlay);
fprintf(fid,'%9i \n',nod32n);
fprintf(fid,'%8i \n',nod23);
fprintf(fid,'%8i \n',elem23);
fclose(fid);

fid = fopen([meshpath,'elem3d.out'],'w');
fprintf(fid,'%10i \n',e3d);
fprintf(fid,'%10i %10i %10i %10i \n',elem3);
fclose(fid);

disp('New mesh saved!')

