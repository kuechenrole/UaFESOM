%load('./io1056/RestartMismipPlus-spinup_W.mat');
load('/isibhv/netscratch/orichter/timmsdata/io1056/1001.00-Nodes1909-Ele3608-Tri3-kH1000-MismipPlus-io1056.mat');
%CtrlVar=CtrlVarInRestartFile;
%UserVar=UserVarInRestartFile;

meshpath='/isibhv/netscratch/orichter/timmsmesh/io1056/1001.00/';

nod2d_file=[meshpath,'nod2d.out'];
elem2d_file=[meshpath,'elem2d.out'];
cflag_file=[meshpath,'cavity_flag_nod2d.out'];

derotate=0;
fplane=1;

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

fid=fopen(elem2d_file);
el2d=fscanf(fid,'%g',1);
elem=fscanf(fid,'%g',[3 el2d]);
fclose(fid);

if fplane
    yFes=nlat'.*111000;
    xFes=nlon'.*111000;
else
    [xFes,yFes]=polarstereo_fwd(nlat(ii)',nlon(ii)',6378137.0,0.08181919,-71,0);
end

MUAHack=MUA;
MUAHack.coordinates=[xFes yFes];
MUAHack.connectivity=elem';
MUAHack.Nele=el2d;
%%
%{
meshdir='/isibhv/netscratch/orichter/timmsmesh/io1056/extended/isomip-MESH.msh';

%Ua_path = '/work/ollie/orichter/MisomipPlus/ua_data/ResultsFiles/0000100-Nodes8013-Ele15780-Tri3-kH1000-MismipPlus-ice1rr_t.mat';


[mesh] = loadmsh(meshdir);
x=mesh.point.coord(:,1);
y=mesh.point.coord(:,2);
n2d=length(x);
indmesh=zeros(size(x));
elem=mesh.tria3.index(:,1:3);
el2d=size(elem,1);

MUAHacke=MUA;
MUAHacke.coordinates=[x.*111000 y.*111000];
MUAHacke.connectivity=elem;
MUAHacke.Nele=el2d;
%}
%%

f1= figure(1);
set(gcf,'color','w');
fontsize(gcf,12,"points");
f1.Position = [0 0 630*2 80*2];
%CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=0;
%CtrlVar.PlotIndividualGLs=1 ; 
%PlotMuaMesh(CtrlVar,MUAHack,[],'color','b','LineStyle','--','Marker','.','linewidth',1) ;
%PlotMuaMesh(CtrlVar,MUAHack,[],'color','b','linewidth',2) ;
%hold on
PlotMuaMesh(CtrlVar,MUA,[],'color',[0,0,0,0.5]) ;
[xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,[],[],[],'color','r');

%GF=IceSheetIceShelves(CtrlVar,MUA,F.GF);
%meltEle=GF.ElementsDownstreamOfGroundingLines;
%meltEle(GF.ElementsCrossingGroundingLines)=1;
%PlotMuaMesh(CtrlVar,MUA,meltEle,'color',[0,0,0,0.5],'Marker','o','linewidth',3) ;

%hold off
title('')
xlabel('km')
ylabel('km')

axis([350 650 0 80]);
%savefig('./figures/idealisedMeshDetail.fig');
%f=gcf;
pos = get(gca, 'Position');
set(gca, 'Position', [pos(1) pos(2)+0.02 pos(3) pos(4)-0.02]);
exportgraphics(gcf,'./figures/idealisedIceMeshCut.png','BackgroundColor','none','Resolution',300);
%%
f2= figure(2);
set(gcf,'color','w');
fontsize(gcf,12,"points");
f2.Position = [0 0 320*2 80*2];
%CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=0;
%CtrlVar.PlotIndividualGLs=1 ; 
%PlotMuaMesh(CtrlVar,MUAHack,[],'color','b','LineStyle','--','Marker','.','linewidth',1) ;
%PlotMuaMesh(CtrlVar,MUAHacke,[],'color','b','linewidth',0.01) ;
hold on
PlotMuaMesh(CtrlVar,MUAHack,[],'color','b') ;
%PlotMuaMesh(CtrlVar,MUA,[],'color',[0,0,0,0.5],'linewidth',2) ;
[xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,[],[],[],'color','r');

%GF=IceSheetIceShelves(CtrlVar,MUA,F.GF);
%meltEle=GF.ElementsDownstreamOfGroundingLines;
%meltEle(GF.ElementsCrossingGroundingLines)=1;
%PlotMuaMesh(CtrlVar,MUA,meltEle,'color',[0,0,0,0.5],'Marker','o','linewidth',3) ;

hold off
title('')
xlabel('km')
ylabel('km')

%axis([453 464 37 45]);
%savefig('./figures/idealisedMeshDetail.fig');
%f=gcf;
set(gcf,'color','w');
fontsize(gcf,12,"points");
pos = get(gca, 'Position');
set(gca, 'Position', [pos(1) pos(2)+0.02 pos(3) pos(4)-0.02]);
exportgraphics(gcf,'./figures/idealisedOceanMesh.png','BackgroundColor','none','Resolution',300);


%%
f3= figure(3);
set(gcf,'color','w');
fontsize(gcf,12,"points");
f3.Position = [0 0 200*2 200*2];
%CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=0;
%CtrlVar.PlotIndividualGLs=1 ; 
%PlotMuaMesh(CtrlVar,MUAHack,[],'color','b','LineStyle','--','Marker','.','linewidth',1) ;
PlotMuaMesh(CtrlVar,MUAHack,[],'color','b','linewidth',1) ;
hold on
PlotMuaMesh(CtrlVar,MUA,[],'linewidth',1) ;
[xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,[],[],[],'color','r','linewidth',1);

GF=IceSheetIceShelves(CtrlVar,MUA,F.GF);
meltEle=GF.ElementsDownstreamOfGroundingLines;
meltEle(GF.ElementsCrossingGroundingLines)=1;
PlotMuaMesh(CtrlVar,MUA,meltEle,'color',[0,0,0,0.5],'Marker','o','linewidth',1) ;

hold off
title('')
xlabel('km')
ylabel('km')

axis([453 465 37 47]);
%savefig('./figures/idealisedMeshDetail.fig');
%f=gcf;
exportgraphics(gcf,'./figures/idealisedMeshDetail.png','BackgroundColor','none','Resolution',300);

%%
%figsWidth=1000 ; figHeights=300;
    GLgeo=[]; xGL=[] ; yGL=[];
    %%
    
    FindOrCreateFigure("FourPlots") ; % ,[50 50 figsWidth 3*figHeights]) ;

    subplot(3,1,1)
    PlotMeshScalarVariable(CtrlVar,MUA,F.s-F.b); title(sprintf('Bedrock',time))
    hold on    
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL);
    %Plot_sbB(CtrlVar,MUA,s,b,B) ; title(sprintf('time=%g',time))
    



%%
%axis([-3000 3000 -3000 3000]);

figure(2)
%CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=0;
%CtrlVar.PlotIndividualGLs=1 ; 
%PlotMuaMesh(CtrlVar,MUAHack,[],'color','b','LineStyle','--','Marker','.','linewidth',1) ;
PlotMuaMesh(CtrlVar,MUAHack,[],'color','b','linewidth',0.001) ;
hold on
PlotMuaMesh(CtrlVar,MUA,[],'color',[0,0,0,0.5],'linewidth',1) ;
%[xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,[],[],[],'color','r','linewidth',3);

hold off
title('')
xlabel('km')
ylabel('km')

axis([0 800 0 80]);
%savefig('./figures/ideali
%sedMeshTotal.fig');
f=gcf;
exportgraphics(f,'figures/idealisedMeshTotal.png','BackgroundColor','none','Resolution',300);

%%
figure(3)
%CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=0;
%CtrlVar.PlotIndividualGLs=1 ; 
%PlotMuaMesh(CtrlVar,MUAHack,[],'color','b','LineStyle','--','Marker','.','linewidth',1) ;
PlotMuaMesh(CtrlVar,MUAHack,[],'color','b','linewidth',1) ;
hold on
PlotMuaMesh(CtrlVar,MUA,[],'color',[0,0,0,0.5],'linewidth',1) ;
[xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,[],[],[],'color','r');

hold off
title('')
xlabel('km')
ylabel('km')

axis([420 550 0 80]);
%savefig('./figures/idealisedMeshZoom.fig');
f=gcf;
exportgraphics(f,'figures/idealisedMeshZoom.png','BackgroundColor','none');
