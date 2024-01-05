
%load('/albedo/work/projects/oce_rio/orichter/uacpl/results/ii0040/19790-FW-Antarctic-Forward-MeshFileAdapt3-local.mat.mat');
load('/albedo/work/projects/oce_rio/orichter/uacpl/results/ii0046/20000-FW-Antarctic-Forward-MeshFileAdapt3-local.mat.mat');
%load('/albedo/work/projects/oce_rio/orichter/ollieWork/Misomip2/ii0020/uaData/19990-FW-Antarctic-Forward-MeshFileAdapt3.mat.mat');

MUAini=MUA; Fini=F;
[VAF,IceVolume,GroundedArea,hAF,hfPos]=CalcVAF([],MUA,F.h,F.B,F.S,F.rho,F.rhow,F.GF);
hAFini=hAF;

%load('/albedo/work/projects/oce_rio/orichter/uacpl/results/io0036/1979.00-Nodes129738-Ele254869-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat');
%load('/albedo/work/projects/oce_rio/orichter/ollieWork/Misomip2/ii0020/uaData/20170-FW-Antarctic-Forward-MeshFileAd'
load('/albedo/work/projects/oce_rio/orichter/uacpl/results/ii0046/20380-FW-Antarctic-Forward-MeshFileAdapt3-local.mat.mat');

[VAF,IceVolume,GroundedArea,hAF,hfPos]=CalcVAF([],MUA,F.h,F.B,F.S,F.rho,F.rhow,F.GF);

[RunInfo,bIni] = MapNodalVariablesFromMesh1ToMesh2UsingScatteredInterpolant(CtrlVar,RunInfo,MUAini,MUA,NaN,Fini.b);
%[RunInfo,bSpin] = MapNodalVariablesFromMesh1ToMesh2UsingScatteredInterpolant(CtrlVar,RunInfo,MUAspin,MUA,NaN,Fspin.b);

[RunInfo,hAFIni] = MapNodalVariablesFromMesh1ToMesh2UsingScatteredInterpolant(CtrlVar,RunInfo,MUAini,MUA,NaN,hAFini);
%[RunInfo,hAFSpin] = MapNodalVariablesFromMesh1ToMesh2UsingScatteredInterpolant(CtrlVar,RunInfo,MUAspin,MUA,NaN,hAFspin);


%%
fig=FindOrCreateFigure('b diff cpl io0035') ;
GLgeo=[]; xGL=[] ; yGL=[];
[~,cbar] = PlotMeshScalarVariable(CtrlVar,MUA,F.b-bIni);
title(cbar,"draft diff (m)") ; title(sprintf("coupling, Cd=0.025",CtrlVar.time),interpreter="latex");
set(gcf,'color','w');
cmocean('balance')

caxis([-500,500]);
set(cbar,'YTick',-500:100:500);
hold on
GLgeo=[]; xGL=[] ; yGL=[];
PlotGroundingLines(CtrlVar,MUAini,Fini.GF,GLgeo,xGL,yGL,'color',[0.5,0.5,0.5]);
PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'k');
hold off
%xlim([-1800 -1450])
%ylim([-700 -250])
xlim([-1700 -1550])
ylim([-400 -220])
axis('off');
fontsize(gcf,scale=1.2)
%saveas(gcf,['figures/bDiffCplio0035.png']);


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
%%
fig=FindOrCreateFigure('b diff cpl io0036') ;
%CtrlVar.PlotXYscale=1000;
GLgeo=[]; xGL=[] ; yGL=[];
[~,cbar] = PlotMeshScalarVariable(CtrlVar,MUA,F.b-bSpin);
title(cbar,"draft diff (m)") ; title(sprintf("coupling, Cd=0.0125",CtrlVar.time),interpreter="latex");
set(gcf,'color','w');
cmocean('balance')

caxis([-500,500]);
set(cbar,'YTick',-500:100:500);
hold on
GLgeo=[]; xGL=[] ; yGL=[];
PlotGroundingLines(CtrlVar,MUAspin,Fspin.GF,GLgeo,xGL,yGL,'color',[0.5,0.5,0.5]);
PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'k');
hold off
%xlim([-1800 -1450])
%ylim([-700 -250])
xlim([-1700 -1550])
ylim([-400 -220])
axis('off');
fontsize(gcf,scale=1.2)
saveas(gcf,['figures/bDiffCplio0036.png']);
