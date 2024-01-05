% load mesh data
nod2dInFile=[meshOutPath,'nod2d.out'];
elem2dInFile=[meshOutPath,'elem2d.out'];

nod2dOutFile=[meshOutPath,'nod2d.out'];
elem2dOutFile=[meshOutPath,'elem2d.out'];

disp('load mesh...')

fid=fopen(nod2dInFile,'r');
n2d=fscanf(fid,'%g',1);
nodes=fscanf(fid, '%g', [4,n2d]);
fclose(fid);

fid=fopen(elem2dInFile);
el2d=fscanf(fid,'%g',1);
elem=fscanf(fid,'%g',[3 el2d]);
fclose(fid);

% find lonely elements: Elements where all nodes where sum(nodes_new(4,nod))==3 
% (connected only with 1 edge to the rest of the elements)
ind_rem_elem=zeros(el2d,1);
for ii=1:el2d
    nod=elem(:,ii);

    if sum(nodes(4,nod))==3
        ind_rem_elem(ii)=1;
    end   
end

elem_new=elem;
elem_new(:,ind_rem_elem==1)=[];
el2d_new=el2d-sum(ind_rem_elem);

% set boundary index to 1 for nodes of removed elements
nodes_new =nodes;
ind=find(ind_rem_elem==1);
for ii=1:sum(ind_rem_elem)
    nod=elem(:,ind(ii));
    nodes_new(4,nod)=1;
end

% remove 2d nodes
% dermine nodes that we keep
keep_nod=zeros(n2d,1);
for ii=1:el2d_new
    nod=elem_new(:,ii);
    keep_nod(nod)=1;
end
ind_rem_nodes=find(keep_nod==0);


cnt=0;
indnod_new=nan(n2d,1);
% for every old n2d node, we save the new node number 
% if node is removed, put nan
for ii=1:n2d
    if keep_nod(ii)==1
        cnt=cnt+1;
        indnod_new(ii)=cnt;
    end
end
nodes_new(:,ind_rem_nodes)=[];
n2d_new=n2d-length(ind_rem_nodes);
nodes_new(1,:)=[1:n2d_new];


%%% correct the node number in elem2d
for ii=1:el2d_new
   elem_new(:,ii)=indnod_new(elem_new(:,ii));
end

disp('write out nod2d and elem2d')

%%% write out the data with the id for topography files
fid = fopen(nod2dOutFile,'w');
fprintf(fid,'%9i \n',n2d_new);
fprintf(fid,'%9i %9.4f %9.4f %3i\n',nodes_new);
fclose(fid);

fid = fopen(elem2dOutFile,'w');
fprintf(fid,'%10i \n',el2d_new);
fprintf(fid,'%10i %10i %10i \n',elem_new);
fclose(fid);

%exit;
