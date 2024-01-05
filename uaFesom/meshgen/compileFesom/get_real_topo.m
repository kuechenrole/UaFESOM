%clear all
%close all

%vis=1;

ocean_only=1; % disregards mask for coast line/grounding line
              % assumes grid only represents ocean locations
    minicedepth=-10; 
    minwaterdepth=-20;
    minwatercolumn=-20; % minwatercolumn enforced only for case ocean_only
    
nod2d_file=[meshOutPath,'nod2d.out'];
elem2d_file=[meshOutPath,'elem2d.out'];
densfile=[extendedMeshPath,'density_COARZE_mesh_improved_or.nc'];
realtopofile=[meshOutPath,'RTopoUa_data.nc'];
icebasefile=[meshOutPath,'RTopoUa_data.nc'];
maskfile=[meshOutPath,'RTopoUa_aux.nc'];

depthOutFile=[meshOutPath,'depth.out'];
shelfOutFile=[meshOutPath,'shelf.out'];
cavityFlagOutFile=[meshOutPath,'cavity_flag_nod2d.out'];

    derotate=0; % switch on if nod2d is in rotated world; off if unrotated.
    
fid=fopen(elem2d_file);
el2d=fscanf(fid,'%g',1);
elem=fscanf(fid,'%g',[3 el2d]);
fclose(fid);

%densfile='/isibhv/netscratch/vhaid/mesh/mesh_gen/density_COARZE_mesh_2.nc';
dstep=0.1; % deg
dens=ncread(densfile,'density');
dens(dens<2)=2;
dlon=ncread(densfile,'lon');
dlat=ncread(densfile,'lat');
% adjust for cut at 180°
dlon=[dlon(1)-dstep;dlon;dlon(end)+dstep];
dens=[dens(end,:);dens;dens(1,:)];


%realtopofile='/isibhv/projects/oce_rio/rtimmerm/RTopo-2/compile_rtopo2_0_4/RTopo-2.0.4_30sec_bedrock_topography_2019-07-12.nc';
%OR double tstep as using 60s tstep=0.0083; % 30"-> °
tstep=0.0167;
topo=ncread(realtopofile,'bathy');
%topo=ncread(realtopofile,'bedrock_topography');
tlon=ncread(realtopofile,'lon');
tlat=ncread(realtopofile,'lat');
% adjust for cut at 180°
%OR taking half the addon as one step is double distance
topo=[topo(end-3999:end,:);topo;topo(1:4000,:)];
tlon=[tlon(1)-4000*tstep:tstep:tlon(1)-tstep,tlon',tlon(end)+tstep:tstep:tlon(end)+4000*tstep]';
%[tlon,tlat]=meshgrid(lon,lat);

%icebasefile='/isibhv/projects/oce_rio/rtimmerm/RTopo-2/compile_rtopo2_0_4/RTopo-2.0.4_30sec_ice_base_topography_2019-07-12.nc';
shelf=ncread(icebasefile,'ice_bottom');
%shelf=ncread(icebasefile,'ice_base_topography');
% adjust for cut at 180°
shelf=[shelf(end-3999:end,:);shelf;shelf(1:4000,:)];

%maskfile='/isibhv/projects/oce_rio/rtimmerm/RTopo-2/compile_rtopo2_0_4/RTopo-2.0.4_30sec_aux_2019-07-12.nc';
mask=ncread(maskfile,'amask');
% adjust for cut at 180°
mask=[mask(end-3999:end,:);mask;mask(1:4000,:)];
imask=0*mask;
iind=find(mask==1 | mask==2);
imask(iind)=1;

% remove iceberg in front of filchner
ai=find(tlon>-44 & tlon<-39);
au=find(tlat>-76.5 & tlat<-75);
shelf(ai,au)=0;
mask(ai,au)=0;
imask(ai,au)=0;

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
%%

disp('get topo from file')
for i=1:n2d
    if mod(i,10000)==0 disp([num2str(i),'/',num2str(n2d)]), end
  % find nearest density
   % reduce indices for which to calc distance
  ai=find((nlat(i)-dstep)<dlat & (nlat(i)+dstep)>dlat);
  au=find((nlon(i)-dstep)<dlon & (nlon(i)+dstep)>dlon);
  ldens=dens(au,ai);
  llon=dlon(au);
  llat=dlat(ai);
  
   % calc distance
   clear dist
  cnt=1;
  for ii=1:size(ldens,1)
      for jj=1:size(ldens,2)
          dla= abs(nlat(i)-llat(jj));
          dlo= abs(nlon(i)-llon(ii)).*cos(nlat(i)/180*pi);
          dist(cnt)=sqrt(dla.*dla+dlo.*dlo);
          cnt=cnt+1;
      end
  end
   % pick nearest
  [a,b]=min(dist);
  ndens(i)=ldens(b);
  
  % calculate max radius
  %OR ??? should we adjust this?
  %maxindy=ceil(ndens(i)./2./40000.*360.*120); % in units of 30 sec = index spacing
  maxindy=ceil(ndens(i)./2./40000.*360.*60); % in units of 30 sec = index spacing
  maxindx=ceil(maxindy./cos(nlat(i)/180*pi));
  % cut piece from topo
  ai=find((nlat(i)-tstep)<tlat & (nlat(i)+tstep)>=tlat);
  au=find((nlon(i)-tstep)<tlon & (nlon(i)+tstep)>=tlon);
  ai=ai(1);
  au=au(1);
  if ai+maxindy > size(topo,2) cutnorth=size(topo,2); else cutnorth=ai+maxindy; end
  if ai-maxindy < 1 cutsouth=1; else cutsouth=ai-maxindy; end
  if au+maxindx > size(topo,1) cuteast=size(topo,1); else cuteast=au+maxindx; end
  if au-maxindx < 1 cutwest=1; else cutwest=au-maxindx; end
  ltopo=topo(cutwest:cuteast, cutsouth:cutnorth);
  lshelf=shelf(cutwest:cuteast, cutsouth:cutnorth);
  lmask=single(mask(cutwest:cuteast, cutsouth:cutnorth));
  limask=single(imask(cutwest:cuteast, cutsouth:cutnorth));
  llat=tlat(cutsouth:cutnorth);
  llon=tlon(cutwest:cuteast);
  % calculate distance (in km!!)
  clear ldist
  for ii=1:size(ltopo,1)
      for jj=1:size(ltopo,2)
          dla= abs(nlat(i)-llat(jj))./360.*40000;
          dlo= abs(nlon(i)-llon(ii))./360.*40000.*cos(nlat(i)/180*pi);
          ldist(ii,jj)=sqrt(dla.*dla+dlo.*dlo);
      end
  end
  % average (weighted??) over distances<density/2 
  %OR: changed this to double distance, as I use Rtopo 1 min instead of 30 sec MIGHT BE TOO MUCH CAUSING depth diff to RTopo30s!!! TRY /1.5
  %ai=find(ldist<=ndens(i)./2);
  ai=find(ldist<=ndens(i)./1.9);
  
  sum_a=0; sum_b=0; sum_c=0; sum_d=0;
  for ii=1:length(ai)
      sum_a=sum_a+ltopo(ai(ii))./ldist(ai(ii));
      sum_b=sum_b+1./ldist(ai(ii));
      sum_c=sum_c+limask(ai(ii))./ldist(ai(ii));
      sum_d=sum_d+limask(ai(ii));
  end
  depth(i)=sum_a./sum_b;
  if isnan(depth(i)) disp('something is wrong depth I'),return, end
  ival2(i)=sum_c./sum_b;
  ival(i)=sum_d./length(ai);
%   disp([nlon(i),nlat(i),depth(i),ival(i),ival2(i)])
%   figure,imagesc(ltopo)
%   figure,imagesc(limask)
%   figure,imagesc(lmask)
%   pause
  sum_e=0; sum_f=0;
  if ival(i)>0.5
      for ii=1:length(ai)
          if ocean_only
              if lmask(ai(ii))== 2 % average only over floating ice
                  sum_e=sum_e+lshelf(ai(ii))./ldist(ai(ii));
                  sum_f=sum_f+1./ldist(ai(ii));
              end
          else
              if lmask(ai(ii))== 1 | lmask(ai(ii))== 2 % floating and grounded
                  sum_e=sum_e+lshelf(ai(ii))./ldist(ai(ii));
                  sum_f=sum_f+1./ldist(ai(ii));
              end
          end
      end
      if sum_f==0 
          ibase(i)=0;
      else
          ibase(i)=sum_e./sum_f;
      end
      if isnan(ibase(i)) disp('something is wrong I'),return, end
     % if ocean_only
      % enforce min ice depth 
    %%%%%%  if ibase(i)>minicedepth ibase(i)=minicedepth; end
     % end
  else
      ibase(i)=0;
  end
  
end
ai=find(isnan(ibase));
if length(ai)>0 disp('something is wrong IIa'),return, end
ai=find(isnan(depth));
if length(ai)>0 disp('something is wrong IIb'),return, end

% check=depth-ibase;
% figure,scatter(nlon,nlat,2,check,'filled')
if vis
figure,scatter(nlon,nlat,2,ibase,'filled')
set(gcf,'position',[226    15   778   432])

figure,scatter(nlon,nlat,10,depth,'filled'); colorbar; title('depth');

nan_mask=zeros(size(depth));
nan_mask(isnan(depth))=1;
figure;scatter(nlon,nlat,10,nan_mask,'filled'); colorbar;title('depth nan');
end
%%
keep=ibase;

% if ocean_only
    disp('clean border nodes')
    % check border nodes  % avoid 1-row open ocean behind ice shelf and 1-row ice shelves
    %  cannot fix corner elements where all nodes are border nodes
    %  or where coastline is inaccurate for more than 1 row of nodes
    for i=1:n2d
        if mod(i,10000)==0 disp([num2str(i),'/',num2str(n2d)]), end
        list=[]; %collect neighbor nodes
        ai=find(elem(1,:)==i);
        list=[list,elem(2,ai),elem(3,ai)];
        ai=find(elem(2,:)==i);
        list=[list,elem(1,ai),elem(3,ai)];
        ai=find(elem(3,:)==i);
        list=[list,elem(1,ai),elem(2,ai)];
        [~,once,~]=unique(list);
        if length(once)>0.5*length(list) % border node
            inner=unique(list(setdiff((1:length(list)),once)));
            if ibase(i)==0 % open_ocean
                if length(inner)==sum(ibase(inner)<0) % all neighbor non-border nodes ice shelf
                    dla= abs(nlat(i)-nlat(inner));
                    dlo= abs(nlon(i)-nlon(inner)).*cos(nlat(i)/180*pi);
                    dist=sqrt(dla.*dla+dlo.*dlo);
                    [a,b]=min(dist);
                    ibase(i)=ibase(inner(b));
                end
            else  % ice shelf
                if length(inner)==sum(ibase(inner)==0) % all neighbor non-border nodes open_ocean
                    ibase(i)=0;
                end
            end
        end
    end
   if vis 
    figure,scatter(nlon,nlat,2,ibase-keep,'filled')
    set(gcf,'position',[226    15   778   432])
   end 

    ai=find(isnan(ibase));
    if length(ai)>0 disp('something is wrong III'),return, end
   %% 
    disp('fill in holes in ice shelves')
    % remove holes in ice shelves
    listA=find(nlat<-63 & ibase==0); % reduce problem to all open-ocean nodes south of 63°S
    ibase(find(nlat>=-63))=0; % remove all non-Antarctic ice shelves
    ai=find(nlat(listA)>-65 & nlon(listA)>-44. & nlon(listA)<-34); % start somewhere in the WS
    listB=listA(ai);
    add=listB;
    
    %cnt=0;
    while length(add)>0
        
        %     figure,hold on
        %     plot(nlon(listA),nlat(listA),'b*')
        %     for k=1:1000
        %     plot(nlon(listB),nlat(listB),'k*')
        
        list=[]; %collect neighbor nodes
        for i=1:length(add)
            ai=find(elem(1,:)==add(i));
            list=[list,elem(2,ai),elem(3,ai)];
            ai=find(elem(2,:)==add(i));
            list=[list,elem(1,ai),elem(3,ai)];
            ai=find(elem(3,:)==add(i));
            list=[list,elem(1,ai),elem(2,ai)];
        end
        list=unique(list);
        add=[];
        for ii=1:length(list)
            if ~ismember(list(ii),listB) & ismember(list(ii),listA) & ibase(list(ii))==0 % new open-ocean nodes south of 63°S
                add=[add,list(ii)];
                %         else
                %             disp([list(ii) ibase(list(ii)) nlon(list(ii)) nlat(list(ii))]);
            end
        end
        listB=[listB,add];
        %    cnt=cnt+1;
        %     plot(nlon(add),nlat(add),'r*')
        %     pause(0.1)
    end
    
    check=[]; again=[];
    for i=1:length(listA)
        if ~ismember(listA(i),listB)
            list=[]; %collect neighbor nodes
            ai=find(elem(1,:)==listA(i));
            list=[list,elem(2,ai),elem(3,ai)];
            ai=find(elem(2,:)==listA(i));
            list=[list,elem(1,ai),elem(3,ai)];
            ai=find(elem(3,:)==listA(i));
            list=[list,elem(1,ai),elem(2,ai)];
            list=unique(list);
            list(find(ibase(list)>=0))=[];
            if length(list)<1
                again=[again,listA(i)];
                % ibase(listA(i))=minicedepth;
            else
                ibase(listA(i))=mean(ibase(list));
            end
            check=[check,listA(i)];
        end
    end
    cnt=0;
    while length(again)>0
        again2=again; again=[];
        for i=1:length(again2)
            list=[]; %collect neighbor nodes
            ai=find(elem(1,:)==again2(i));
            list=[list,elem(2,ai),elem(3,ai)];
            ai=find(elem(2,:)==again2(i));
            list=[list,elem(1,ai),elem(3,ai)];
            ai=find(elem(3,:)==again2(i));
            list=[list,elem(1,ai),elem(2,ai)];
            list=unique(list);
            list(find(ibase(list)>=0))=[];
            if length(list)<1
                again=[again,again2(i)];
            else
                ibase(again2(i))=mean(ibase(list));
            end
        end
        cnt=cnt+1;
        if cnt>20
            disp('ran into failsafe. Check what is happening!')
            disp([num2str(length(again)),' nodes (marked red) will no longer be ice shelf nodes.'])
            if vis
            figure, scatter(nlon,nlat,2,ibase,'filled')
            hold on, plot(nlon(again),nlat(again),'r+')
            end 
            ibase(again)=0;
            again=[];
            %disp('If everything is fine, repeat while loop with higher counter limit.')
            %return
        end
    end
    ai=find(isnan(ibase));
    if length(ai)>0 disp('something is wrong IV'),return, end
    
   disp('enforce minimum bedrock and ice depth')
    % enforce min water depth
    ai=find(depth > minwaterdepth);
    depth(ai)=minwaterdepth; 

    ai=find(ibase<0 & ibase>minicedepth);
    ibase(ai)=minicedepth; 
    
if ocean_only
    disp('enforce minimum water column')
    % enforce min water column
    ai=find(depth-ibase > minwatercolumn);
    depth(ai)=ibase(ai)+minwatercolumn;
    
end


ai=find(isnan(ibase));
if length(ai)>0 disp('something is wrong V'),return, end

if vis
%   figure,scatter(nlon,nlat,2,ival,'filled')
% set(gcf,'position',[26    115   778   432])
%   figure,scatter(nlon,nlat,2,ival2,'filled')
% set(gcf,'position',[126    115   778   432])
%   figure,scatter(nlon,nlat,2,ival-ival2,'filled')
% set(gcf,'position',[226    115   778   432])
figure,scatter(nlon,nlat,2,depth,'filled')
set(gcf,'position',[26    15   778   432])
figure,scatter(nlon,nlat,2,ibase,'filled')
set(gcf,'position',[126    15   778   432])
check2=depth-ibase;
% figure,scatter(nlon,nlat,2,check2,'filled')
% set(gcf,'position',[226    15   778   432])
% figure,scatter(nlon,nlat,2,check-check2,'filled')
% set(gcf,'position',[226    15   778   432])
end

disp('save data')
fid=fopen(depthOutFile,'w');
fprintf(fid,'%8.2g \n',depth);
fclose(fid);

fid=fopen(shelfOutFile,'w');
fprintf(fid,'%8.2g \n',ibase);
fclose(fid);

%if ocean_only
%pause(15)
%disp('continuing with ensure_pos_wctNovl2.m')
%ensure_pos_wctNovl2
%else
disp('generate cavity_flag')
cavity_flag=ibase*0.;
cavity_flag(find(ibase<0))=1;
fid = fopen(cavityFlagOutFile,'w');
fprintf(fid,'%1i \n',cavity_flag); 
fclose(fid);
%end
