
%load('/albedo/work/projects/oce_rio/orichter/uacpl/results/ii0040/19790-FW-Antarctic-Forward-MeshFileAdapt3-local.mat.mat');
load('/albedo/work/projects/oce_rio/orichter/ollieWork/Misomip2/ii0020/uaData/19790-FW-Antarctic-Forward-MeshFileAdapt3.mat.mat');
%load('/albedo/work/projects/oce_rio/orichter/ollieWork/Misomip2/ii0020/uaData/19990-FW-Antarctic-Forward-MeshFileAdapt3.mat.mat');

MUAini=MUA; Fini=F;
[VAF,IceVolume,GroundedArea,hAF,hfPos]=CalcVAF([],MUA,F.h,F.B,F.S,F.rho,F.rhow,F.GF);
hAFini=hAF;

%load('/albedo/work/projects/oce_rio/orichter/uacpl/results/io0036/1979.00-Nodes129738-Ele254869-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat');
load('/albedo/work/projects/oce_rio/orichter/ollieWork/Misomip2/ii0020/uaData/19990-FW-Antarctic-Forward-MeshFileAdapt3.mat.mat');

MUAspin=MUA; Fspin=F;
[VAF,IceVolume,GroundedArea,hAF,hfPos]=CalcVAF([],MUA,F.h,F.B,F.S,F.rho,F.rhow,F.GF);
hAFspin=hAF;

%load('/albedo/work/projects/oce_rio/orichter/uacpl/results/io0036/2018.00-Nodes129561-Ele254536-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat');
load('/albedo/work/projects/oce_rio/orichter/uacpl/results/io0035/2018.00-Nodes129943-Ele255292-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat');

[VAF,IceVolume,GroundedArea,hAF,hfPos]=CalcVAF([],MUA,F.h,F.B,F.S,F.rho,F.rhow,F.GF);

[RunInfo,bIni] = MapNodalVariablesFromMesh1ToMesh2UsingScatteredInterpolant(CtrlVar,RunInfo,MUAini,MUA,NaN,Fini.b);
[RunInfo,bSpin] = MapNodalVariablesFromMesh1ToMesh2UsingScatteredInterpolant(CtrlVar,RunInfo,MUAspin,MUA,NaN,Fspin.b);

[RunInfo,hAFIni] = MapNodalVariablesFromMesh1ToMesh2UsingScatteredInterpolant(CtrlVar,RunInfo,MUAini,MUA,NaN,hAFini);
[RunInfo,hAFSpin] = MapNodalVariablesFromMesh1ToMesh2UsingScatteredInterpolant(CtrlVar,RunInfo,MUAspin,MUA,NaN,hAFspin);

%%
fig=FindOrCreateFigure('ab spin io0035') ;
fig.Position = [10 10 500 400];
%CtrlVar.PlotXYscale=1000;
GLgeo=[]; xGL=[] ; yGL=[];
[~,cbar] = PlotMeshScalarVariable(CtrlVar,MUAini,-Fini.ab);
ylabel(cbar,'Melt rate (m/yr)'); title(sprintf("Cd=0.025"),interpreter="latex");
set(gcf,'color','w');
cmocean('thermal')

caxis([0,100]);
set(cbar,'YTick',0:20:100);
hold on
GLgeo=[]; xGL=[] ; yGL=[];
PlotGroundingLines(CtrlVar,MUAini,Fini.GF,GLgeo,xGL,yGL,'color',[0.5,0.5,0.5],'Linewidth',2);
%GLgeo=[]; xGL=[] ; yGL=[];
%PlotGroundingLines(CtrlVar,MUAspin,Fspin.GF,GLgeo,xGL,yGL,'k');
hold off
%xlim([-1800 -1450])
%ylim([-700 -250])
xlim([-1700 -1550])
ylim([-400 -220])
axis('off')
fontsize(gcf,14,'points')
%{
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];
%}
exportgraphics(gcf,['figures/abIniio0035.png'],'Resolution',200);

%%
%{
fig=FindOrCreateFigure('b diff spin io0035') ;
%CtrlVar.PlotXYscale=1000;
GLgeo=[]; xGL=[] ; yGL=[];
[~,cbar] = PlotMeshScalarVariable(CtrlVar,MUA,bSpin-bIni);
ylabel(cbar,"Draft difference (m)");% title(sprintf("relaxation, Cd=0.025",CtrlVar.time),interpreter="latex");
set(gcf,'color','w');
cmocean('balance')

caxis([-500,500]);
set(cbar,'YTick',-500:100:500);
hold on
GLgeo=[]; xGL=[] ; yGL=[];
PlotGroundingLines(CtrlVar,MUAini,Fini.GF,GLgeo,xGL,yGL,'color',[0.5,0.5,0.5]);
GLgeo=[]; xGL=[] ; yGL=[];
PlotGroundingLines(CtrlVar,MUAspin,Fspin.GF,GLgeo,xGL,yGL,'k');
hold off
%xlim([-1800 -1450])
%ylim([-700 -250])
xlim([-1700 -1550])
ylim([-400 -220])
axis('off')
fontsize(gcf,scale=1.2)
saveas(gcf,['figures/bDiffSpinio0035.png']);
%}
%%
fig=FindOrCreateFigure('b diff cpl io0035') ;
fig.Position = [10 10 500 400];
GLgeo=[]; xGL=[] ; yGL=[];
[~,cbar] = PlotMeshScalarVariable(CtrlVar,MUA,F.b-bSpin);
ylabel(cbar,"Draft difference (m)") ; %title(sprintf("coupling, Cd=0.025",CtrlVar.time),interpreter="latex");
set(gcf,'color','w');
cmocean('balance')

caxis([-500,500]);
set(cbar,'YTick',-500:100:500);
hold on
GLgeo=[]; xGL=[] ; yGL=[];
PlotGroundingLines(CtrlVar,MUAspin,Fspin.GF,GLgeo,xGL,yGL,'magenta','Linewidth',2);%,[0.5,0.5,0.5]);
%PlotGroundingLines(CtrlVar,MUAspin,Fspin.GF,GLgeo,xGL,yGL,'k--');
PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'k','Linewidth',2);
hold off
%xlim([-1800 -1450])
%ylim([-700 -250])
xlim([-1700 -1550])
ylim([-400 -220])
axis('off');
fontsize(gcf,14,'points')
exportgraphics(gcf,['figures/bDiffCplio0035.png'],'Resolution',200);


%%
load('/albedo/work/projects/oce_rio/orichter/uacpl/results/ii0040/19790-FW-Antarctic-Forward-MeshFileAdapt3-local.mat.mat');
%load('/albedo/work/projects/oce_rio/orichter/ollieWork/Misomip2/ii0020/uaData/19790-FW-Antarctic-Forward-MeshFileAdapt3.mat.mat');
%load('/albedo/work/projects/oce_rio/orichter/ollieWork/Misomip2/ii0020/uaData/19990-FW-Antarctic-Forward-MeshFileAdapt3.mat.mat');

MUAini=MUA; Fini=F;

load('/albedo/work/projects/oce_rio/orichter/uacpl/results/io0036/1979.00-Nodes129738-Ele254869-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat');
%load('/albedo/work/projects/oce_rio/orichter/ollieWork/Misomip2/ii0020/uaData/19990-FW-Antarctic-Forward-MeshFileAdapt3.mat.mat');



MUAspin=MUA; Fspin=F;

load('/albedo/work/projects/oce_rio/orichter/uacpl/results/io0036/2018.00-Nodes129561-Ele254536-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat');
%load('/albedo/work/projects/oce_rio/orichter/uacpl/results/io0035/2018.00-Nodes129943-Ele255292-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat');

[RunInfo,bIni] = MapNodalVariablesFromMesh1ToMesh2UsingScatteredInterpolant(CtrlVar,RunInfo,MUAini,MUA,NaN,Fini.b);
[RunInfo,bSpin] = MapNodalVariablesFromMesh1ToMesh2UsingScatteredInterpolant(CtrlVar,RunInfo,MUAspin,MUA,NaN,Fspin.b);
%%
fig=FindOrCreateFigure('ab spin io0036') ;
fig.Position = [10 10 500 400];
%CtrlVar.PlotXYscale=1000;
GLgeo=[]; xGL=[] ; yGL=[];
[~,cbar] = PlotMeshScalarVariable(CtrlVar,MUAini,-Fini.ab);
colorbar('off');
%ylabel(cbar,'Melt rate (m/yr)');
title(sprintf("Cd=0.0125"),interpreter="latex");
set(gcf,'color','w');
cmocean('thermal')

caxis([0,100]);
%set(cbar,'YTick',0:20:100);
hold on
GLgeo=[]; xGL=[] ; yGL=[];
PlotGroundingLines(CtrlVar,MUAini,Fini.GF,GLgeo,xGL,yGL,'color',[0.5,0.5,0.5],'Linewidth',2);
%GLgeo=[]; xGL=[] ; yGL=[];
%PlotGroundingLines(CtrlVar,MUAspin,Fspin.GF,GLgeo,xGL,yGL,'k');
hold off
%xlim([-1800 -1450])
%ylim([-700 -250])
xlim([-1700 -1550])
ylim([-400 -220])
axis('off')
fontsize(gcf,14,'points')
exportgraphics(gcf,['figures/abIniio0036.png'],'Resolution',200);
%%
%{
fig=FindOrCreateFigure('b diff spin io0036') ;
%CtrlVar.PlotXYscale=1000;
GLgeo=[]; xGL=[] ; yGL=[];
[~,cbar] = PlotMeshScalarVariable(CtrlVar,MUA,bSpin-bIni);
title(cbar,"draft diff (m)") ; title(sprintf("relaxation, Cd=0.0125",CtrlVar.time),interpreter="latex");
set(gcf,'color','w');
cmocean('balance')

caxis([-500,500]);
set(cbar,'YTick',-500:100:500);
hold on
GLgeo=[]; xGL=[] ; yGL=[];
PlotGroundingLines(CtrlVar,MUAini,Fini.GF,GLgeo,xGL,yGL,'color',[0.5,0.5,0.5]);
GLgeo=[]; xGL=[] ; yGL=[];
PlotGroundingLines(CtrlVar,MUAspin,Fspin.GF,GLgeo,xGL,yGL,'k');
hold off
%xlim([-1800 -1450])
%ylim([-700 -250])
xlim([-1700 -1550])
ylim([-400 -220])
axis('off')
fontsize(gcf,scale=1.2)
saveas(gcf,['figures/bDiffSpinio0036.png']);
%}
%%
fig=FindOrCreateFigure('b diff cpl io0036') ;
fig.Position = [10 10 500 400];
%CtrlVar.PlotXYscale=1000;
GLgeo=[]; xGL=[] ; yGL=[];
[~,cbar] = PlotMeshScalarVariable(CtrlVar,MUA,F.b-bSpin);
colorbar('off');
%ylabel(cbar,"Draft difference (m)") ; %title(sprintf("coupling, Cd=0.0125",CtrlVar.time),interpreter="latex");
set(gcf,'color','w');
cmocean('balance')

caxis([-500,500]);
%set(cbar,'YTick',-500:100:500);
hold on
GLgeo=[]; xGL=[] ; yGL=[];
PlotGroundingLines(CtrlVar,MUAspin,Fspin.GF,GLgeo,xGL,yGL,'magenta','Linewidth',2);%color',[0.5,0.5,0.5]);
PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'k','Linewidth',2);
hold off
%xlim([-1800 -1450])
%ylim([-700 -250])
xlim([-1700 -1550])
ylim([-400 -220])
axis('off');
fontsize(gcf,14,'points')
exportgraphics(gcf,['figures/bDiffCplio0036.png'],'Resolution',200);
