% ensure_pos_wct.m
% ensure positive water column and overlapping depths of adjoining 2d elems
% adapted for 2nd part by Verena Haid, Oct 2020

%meshpath=meshOutPath
%outpath='../fesom_grid_4.7.1/'
%outpath='./'

nodfile          =[meshOutPath,'nod2d.out']
elemfile         =[meshOutPath,'elem2d.out']
depfile_in       =[meshOutPath,'depth.out']
shelffile_in     =[meshOutPath,'shelf.out']

depfile_out      =[meshOutPath,'depth.out']
shelffile_out    =[meshOutPath,'shelf.out']
cavityFlagOutFile=[meshOutPath,'cavity_flag_nod2d.out']

ovl = 0    % deactivate to check for min overlap; just for testing if its necessary OR
ovlmin        =  1.      % minimum number of 3d elem to overlap vertically
levmin        =  2.      % minimum number of 3d elem in total (replaces wctmin for z-level grid)
%wctmin        =  20.     % minimum water column thickness (follows needs of numerics)
shelfmin      =  -1.     % minimum ice shelf draft (<0)
%vis = 0

% make sure these are the same depth levels as for 3d step:
zbar=-[   0.0000    5.0000   10.0000   20.0000   30.0000   40.0000   50.0000   60.0000 ...
         70.0000   80.0000   90.0000  100.0000  111.7500  124.5000  137.7500  150.5000 ...
        162.7500  175.5000  189.0000  203.5000  219.0000  235.5000  253.0000  271.5000 ...
        291.0000  311.0000  331.0000  351.0000  371.0000  391.0000  411.2500  431.7500 ...
        452.2500  472.7500  493.2500  513.7500  534.2500  554.7500  575.2500  595.7500 ...
        616.2500  636.7500  657.2500  678.0000  699.0000  720.2500  741.7500  763.5000 ...
        785.5000  807.7500  830.2500  853.0000  876.0000  899.5000  924.3000  950.3000 ...
        977.3000 1005.3000 1034.3000 1064.3000 1095.8000 1129.3000 1164.8000 1202.3000 ...
       1241.3000 1281.3000 1322.8000 1365.3000 1408.8000 1454.3000 1501.8000 1551.3000 ...
       1602.8000 1657.3000 1715.6000 1778.1000 1845.6000 1920.6000 2005.6000 2100.6000 ...
       2205.6000 2320.6000 2445.6000 2580.6000 2725.6000 2880.6000 3045.6000 3220.6000 ...
       3405.6000 3600.6000 3806.9000 4025.6000 4256.9000 4500.6000 4756.9000 5025.6000 ...
       5313.1000 5625.6000 5963.1000 6325.6000 6713.1000 ] ;
% zbar=-[   0.0000    5.0000   10.0000   20.0000   30.0000   40.0000   50.0000   60.0000 ...
%          70.0000   80.0000   90.0000  100.0000  111.7500  124.5000  137.7500  150.5000 ...
%         162.7500  175.5000  189.0000  203.5000  219.0000  235.5000  253.0000  271.5000 ...
%         291.0000  311.0000  331.0000  351.0000  371.0000  391.0000  411.2500  431.7500 ...
%         452.2500  472.7500  493.2500  513.7500  534.2500  554.7500  575.2500  595.7500 ...
%         616.2500  636.7500  657.2500  678.0000  699.0000  720.2500  741.7500  763.5000 ...
%         785.5000  807.7500  830.2500  853.0000  876.0000  899.5000  924.3000  950.3000 ...
%         977.3000 1005.3000 1034.3000 1064.3000 1094.3000 1124.3000 1154.3000 1184.3000 1214.3000 ...
%        1244.3000 1274.3000 1304.3000 1334.3000 1364.3000 1394.3000 1424.3000 1454.3000 1484.3000 1514.3000 1544.3000 ...
%        1574.3000 1604.3000 1634.3000 1664.3000 1694.3000 1724.3000 1754.3000 1784.3000 1814.3000 1844.3000 1874.3000 ...
%        1904.3000 1934.3000 1964.3000 1994.3000 2027.6000 2075.6000 2130.6000 ...
%        2205.6000 2320.6000 2445.6000 2580.6000 2725.6000 2880.6000 3045.6000 3220.6000 ...
%        3405.6000 3600.6000 3806.9000 4025.6000 4256.9000 4500.6000 4756.9000 5025.6000 ...
%        5313.1000 5625.6000 5963.1000 6325.6000 6713.1000 ] ;


%Ralph Timmermann 28.02.11
%--------------------------------------------------------------------
% no step                no step                    no step

fid=fopen(nodfile);
n2d=fscanf(fid,'%g',1);
nodes=fscanf(fid,'%g', [4,n2d]);
fclose(fid);
xcoord=nodes(2,:);
ycoord=nodes(3,:);
icoord=nodes(4,:);

fid=fopen(elemfile);
e2d=fscanf(fid,'%g', 1);
elem=fscanf(fid,'%g', [3,e2d]);
fclose(fid);

% for plotting only: remove left-to-right elems
for i=1:e2d
aux(i)=max(abs(diff(xcoord(elem(:,i)))));
end
pind=find(aux<270);
pelem=elem(:,pind);

fid=fopen(depfile_in);
dep=fscanf(fid,'%g',n2d);
fclose(fid);

if vis
figure(11)
xc=xcoord(pelem);
yc=ycoord(pelem);
dc=dep(pelem);
pp=patch(xc, yc, dc);
set(pp,'EdgeColor','none');
%caxis([-1500 0])
colorbar
axis ij
title('depth  (dep)');
drawnow
end
% cavity draft and flag: used to check mesh quality and contour line
% location
fid=fopen(shelffile_in);
shelf=fscanf(fid,'%g',n2d);
fclose(fid);
 
if vis
figure(12)
dc=shelf(pelem);
pp=patch(xc, yc, dc);
set(pp,'EdgeColor','none');
%caxis([-1500 0])
colorbar
axis ij
title('shelf');
drawnow
end


disp('generate cavity_flag')
cavity_flag=shelf*0.;
cavity_flag(find(shelf<0))=1;

if vis
figure(13)
dc=cavity_flag(pelem);
pp=patch(xc, yc, dc);
set(pp,'EdgeColor','none');
%caxis
colorbar
axis ij
title('cavity flag')
drawnow

disp('check water column thickness')
figure(14)
%wct=abs(dep)-abs(shelf);
wct=shelf-dep;
dc=wct(pelem);
pp=patch(xc, yc, dc);
set(pp,'EdgeColor','none');
axis ij
colorbar
caxis([-40,40])
title('water column thickness (wct)')
drawnow
end
%stop



wct=shelf-dep;
ai=find(wct<0);
if length(ai)>0 
 disp(['There are ',num2str(length(ai)),' nodes with negative wct.'])
 disp(['The program will cure them.'])
end

% *************************************************************
% replace /adjust next two steps adequately!
% *************************************************************
if 0    % VH
ai=find(cavity_flag==1 & wct<wctmin);
if length(ai)>0 
 disp(['There are ',num2str(length(ai)),' nodes with wct < wctmin'])
 disp(['The program will cure them all.'])
% shelf(ai)=0.5*(dep(ai)+shelf(ai))+0.5*wctmin;
 dep(ai)  =shelf(ai)-wctmin;
end


ai=find(cavity_flag==1 & shelf>shelfmin);   % shelf and shelfmin are negative numbers
if length(ai)>0 
 disp(['There are ',num2str(length(ai)),' nodes with shelf>shelfmin'])
 disp(['The program will cure them.'])
 shelf(ai)=shelfmin;
 dep(ai)=shelf(ai)-wctmin; 
end
end

% ensure levmin depth levels   % VH
cnt=0;
dep_mid=(zbar(1:end-1)+zbar(2:end))/2;
for ei=1:e2d
  % find uppermost level
  ai=find(dep_mid<=min(shelf(elem(:,ei))));
  ul(ei)=ai(1);
  minbl=ul(ei)+levmin-1; % minimum number for bottom layer
  % find bottom level
  au=find(dep_mid<max(dep(elem(:,ei))));
  bl(ei)=au(1)-1;
  bli(ei)=bl(ei); % for debugging
  if bl(ei)<minbl
      for i=1:3
          if dep(elem(i,ei))>dep_mid(minbl)-1 % if clause for counting
              dep(elem(i,ei))=dep_mid(minbl)-1;
              cnt=cnt+1;
          end
      % dep(elem(i,ei))=min(dep(elem(i,ei)),dep_mid(minbl)-1);
      end
      bl(ei)=minbl;
  end
end
disp([num2str(cnt),' nodes deepened to enforce ',num2str(levmin),' layers. (Some possibly counted multiple times.)'])

if ovl
  bla(ei)=bl(ei); % for debugging
depi=dep; % for debugging
tic
disp('check for overlap')     %   VH
cnt=0;
changednodes=[];
maxct=0;
checked_flag=0*bl;
for ei=1:e2d  
  if sum(cavity_flag(elem(:,ei)))==3
      if mod(ei,20)==0 disp([num2str(ei),'/',num2str(e2d)]), end
      cnt2=0; 
    % find neighbor elems
    for ei2=1:e2d
       if sum(cavity_flag(elem(:,ei2)))==3 & checked_flag(ei2)==0
           if sum([ismember(elem(1,ei),elem(:,ei2)),ismember(elem(2,ei),elem(:,ei2)),ismember(elem(3,ei),elem(:,ei2))])==2
           cnt2=cnt2+1;
         % check overlap
         if bl(ei)<bl(ei2) & bl(ei)<ul(ei2)+levmin-1
             for i=1:3
                 if dep(elem(i,ei))>dep_mid(ul(ei2)+levmin-1)-1 % if clause for counting
                     dep(elem(i,ei))=dep_mid(ul(ei2)+levmin-1)-1;
                     cnt=cnt+1;
                 end
                 % dep(elem(i,ei))=min(dep(elem(i,ei)),dep_mid(ul(ei2)+levmin-1)-1);
             end
         elseif bl(ei)>bl(ei2) & bl(ei2)<ul(ei)+levmin-1
             for i=1:3
                 if dep(elem(i,ei2))>dep_mid(ul(ei)+levmin-1)-1 % if clause for counting
                     dep(elem(i,ei2))=dep_mid(ul(ei)+levmin-1)-1;
                     cnt=cnt+1;
                 end
                 % dep(elem(i,ei2))=min(dep(elem(i,ei2)),dep_mid(ul(ei)+levmin-1)-1);
             end
         end
           end
       end
       maxct=max(maxct,cnt2);
    end
  end
  checked_flag(ei)=1;
end
disp([' nodes deepened in ',num2str(cnt),' operations to enforce ',num2str(ovlmin),' overlapping layers.'])
toc
end

if vis
disp('look at corrected fields')
figure(15)
xc=xcoord(pelem);
yc=ycoord(pelem);
dc=dep(pelem);
pp=patch(xc, yc, dc);
set(pp,'EdgeColor','none');
%caxis
axis ij
colorbar
title('corrected depth  (dep)');
drawnow

figure(16)
dc=shelf(pelem);
pp=patch(xc, yc, dc);
set(pp,'EdgeColor','none');
caxis([-1500 0])
axis ij
colorbar
title('corrected shelf');
drawnow

figure(17)
wctnew=abs(dep)-abs(shelf);
dc=wctnew(pelem)-wct(pelem);
pp=patch(xc, yc, dc);
set(pp,'EdgeColor','none');
%caxis([0,40])
axis ij
colorbar
title('corrected water column thickness')
drawnow
end

if 0 then     % removec because 
 disp('second correction step based on elementwise wct')
 shelf_min=min(shelf(elem));
 bott_max=max(dep(elem));
 wct_elem=abs(bott_max)-abs(shelf_min);
 ae=find(wct_elem<wctmin)
 if length(ae)>0 
  disp(['There are ',num2str(length(ae)),' elements with wct < wctmin'])
  disp(['The program will correct them'])
  correction=wct_elem*0.
  correction(ae)=1./3.*1./2.*(-wct_elem(ae)+wct_min)  % minus because we want to add the negative wcts as a correction term
 end
%Das wird nicht gehen. Mach mal neu mit Schleifen, die ueber die Elemente gehen und dann die knoten einzeln abtasten. 
end

disp('write data')
fid=fopen(depfile_out,'w');
fprintf(fid,'%8i\n', dep);
fclose(fid);

fid=fopen(shelffile_out,'w');
fprintf(fid,'%8i\n', shelf);
fclose(fid);
disp('create cavity flag')
fid = fopen(cavityFlagOutFile,'w');
fprintf(fid,'%1i \n',cavity_flag); 
fclose(fid);

disp('creation of cavity_flag_nod2d_postwct.out succesfully completed')

