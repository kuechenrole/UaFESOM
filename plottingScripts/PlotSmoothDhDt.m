%load('/albedo/work/projects/oce_rio/orichter/uacpl/results/io0036/1979.00-Nodes129738-Ele254869-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat');
load('/albedo/work/projects/oce_rio/orichter/uacpl/results/io0036/1979.00-Nodes129738-Ele254869-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat');
%load('/albedo/work/projects/oce_rio/orichter/uacpl/results/io0035/1979.00-Nodes129945-Ele255284-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat');
MUAold=MUA; Fold=F;
[VAF,IceVolume,GroundedArea,hAF,hfPos]=CalcVAF([],MUA,F.h,F.B,F.S,F.rho,F.rhow,F.GF);
hAFold=hAF;
load('/albedo/work/projects/oce_rio/orichter/uacpl/results/io0036/2018.00-Nodes129561-Ele254536-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat');
%load('/albedo/work/projects/oce_rio/orichter/uacpl/results/io0035/2018.00-Nodes129943-Ele255292-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat');
[VAF,IceVolume,GroundedArea,hAF,hfPos]=CalcVAF([],MUA,F.h,F.B,F.S,F.rho,F.rhow,F.GF);

[RunInfo,hAFoldRm] = MapNodalVariablesFromMesh1ToMesh2UsingScatteredInterpolant(CtrlVar,RunInfo,MUAold,MUA,NaN,hAFold);
[RunInfo,hOld] = MapNodalVariablesFromMesh1ToMesh2UsingScatteredInterpolant(CtrlVar,RunInfo,MUAold,MUA,NaN,Fold.h);
[RunInfo,dhdtOld] = MapNodalVariablesFromMesh1ToMesh2UsingScatteredInterpolant(CtrlVar,RunInfo,MUAold,MUA,NaN,Fold.dhdt);

%{
 %cMap = parula(256);
 cMap=cmocean('-balance',256);
  dataMax = 0.5;
  dataMin = -10;
  centerPoint = 0.5;
  scalingIntensity = 5;
%Then perform some operations to create your colormap. I have done this by altering the indices "x” at which each existing color lives, and then interpolating to expand or shrink certain areas of the spectrum.
  x = 1:length(cMap); 
  x = x - (centerPoint-dataMin)*length(x)/(dataMax-dataMin);
  x = scalingIntensity * x/max(abs(x));
%Next, select some function or operations to transform the original linear indices into nonlinear. In the last line, I then use "interp1” to create the new colormap from the original colormap and the transformed indices.
  x = sign(x).* exp(abs(x));
  x = x - min(x); x = x*511/max(x)+1; 
  newMap = interp1(x, cMap, 1:512);
%}

f=FindOrCreateFigure("coupling, Cd=0.0125");
fig.Position = [10 10 500 400];
[~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,(hAF-hAFoldRm)./39) ;
colorbar('off')
%set(cbar,'YTick',-2:0.5:2)
%axis tight
axis off
%hold on ; PlotLatLonGrid(CtrlVar.PlotXYscale) ;
hold on ; PlotGroundingLines(CtrlVar,MUA,F.GF,[],[],[],'k','Linewidth',1);hold off;
%xlabel("xps (km)",interpreter="latex") ; ylabel("yps (km)",interpreter="latex") ; 
%ylabel(cbar,"HAF trend (m/yr)") ;% title("coupling, Cd=0.0125",interpreter="latex")
%fprintf("VAF=%f (Gt/yr)\n",VAF.Total/1e9)   ; 
%fprintf("GroundedArea=%-7.2f (times the area of iceland)\n",GroundedArea.Total/1e6/103e3) ; 
%colormap(othercolor('Blues7',1024));
%colormap(bluewhitered);
cmocean('-balance')
caxis([-2,2])
xlim([-1950 -1100])
ylim([-700 200])
set(gcf,'color','w');
fontsize(gcf,14,'points')
%f.Position = [0 0 500 700];
exportgraphics(gcf,'figures/dhAFdtio0036PIG.png','Resolution',200);
%exportgraphics(ax,'myplot.png','Resolution',300) 
%%
%load('/albedo/work/projects/oce_rio/orichter/uacpl/results/io0036/1979.00-Nodes129738-Ele254869-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat');
%load('/albedo/work/projects/oce_rio/orichter/uacpl/results/io0036/1979.00-Nodes129738-Ele254869-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat');
load('/albedo/work/projects/oce_rio/orichter/uacpl/results/io0035/1979.00-Nodes129945-Ele255284-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat');
MUAold=MUA; Fold=F;
[VAF,IceVolume,GroundedArea,hAF,hfPos]=CalcVAF([],MUA,F.h,F.B,F.S,F.rho,F.rhow,F.GF);
hAFold=hAF;
%load('/albedo/work/projects/oce_rio/orichter/uacpl/results/io0036/2018.00-Nodes129561-Ele254536-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat');
load('/albedo/work/projects/oce_rio/orichter/uacpl/results/io0035/2018.00-Nodes129943-Ele255292-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat');
[VAF,IceVolume,GroundedArea,hAF,hfPos]=CalcVAF([],MUA,F.h,F.B,F.S,F.rho,F.rhow,F.GF);

[RunInfo,hAFoldRm] = MapNodalVariablesFromMesh1ToMesh2UsingScatteredInterpolant(CtrlVar,RunInfo,MUAold,MUA,NaN,hAFold);
[RunInfo,hOld] = MapNodalVariablesFromMesh1ToMesh2UsingScatteredInterpolant(CtrlVar,RunInfo,MUAold,MUA,NaN,Fold.h);
[RunInfo,dhdtOld] = MapNodalVariablesFromMesh1ToMesh2UsingScatteredInterpolant(CtrlVar,RunInfo,MUAold,MUA,NaN,Fold.dhdt);




FindOrCreateFigure("coupling, Cd=0.025"); 
fig.Position = [10 10 500 400];
[~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,(hAF-hAFoldRm)./39) ;

set(cbar,'YTick',-2:0.5:2)
%axis tight
axis off
%hold on ; PlotLatLonGrid(CtrlVar.PlotXYscale) ;
hold on ; PlotGroundingLines(CtrlVar,MUA,F.GF,[],[],[],'k');hold off;
%xlabel("xps (km)",interpreter="latex") ; ylabel("yps (km)",interpreter="latex") ; 
ylabel(cbar,"HAF trend (m/yr)") ;% title("coupling, Cd=0.025",interpreter="latex")
%fprintf("VAF=%f (Gt/yr)\n",VAF.Total/1e9)   ; 
%fprintf("GroundedArea=%-7.2f (times the area of iceland)\n",GroundedArea.Total/1e6/103e3) ; 
%colormap(othercolor('Blues7',1024));
%colormap(bluewhitered);
cmocean('-balance')
caxis([-2,2])
xlim([-1950 -1100])
ylim([-700 200])
%xlim([-1750 -1400])
%ylim([-350 75])
set(gcf,'color','w');
fontsize(gcf,14,'points');
exportgraphics(gcf,'figures/dhAFdtio0035PIG.png','Resolution',200);


%%

FindOrCreateFigure("dhdt 1979 snapshot"); 
[~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,dhdtOld) ;
%set(cbar,'YTick',-2:0.5:2)
%axis tight
%axis off
%hold on ; PlotLatLonGrid(CtrlVar.PlotXYscale) ;
%hold on ; PlotGroundingLines(CtrlVar,MUA,F.GF,[],[],[],'k');
%xlabel("xps (km)",interpreter="latex") ; ylabel("yps (km)",interpreter="latex") ; 
title(cbar,"(m/yr)") ; title("1979 dhdt",interpreter="latex")
%fprintf("VAF=%f (Gt/yr)\n",VAF.Total/1e9)   ; 
%fprintf("GroundedArea=%-7.2f (times the area of iceland)\n",GroundedArea.Total/1e6/103e3) ; 
%colormap(othercolor('Blues7',1024));
%colormap(newMap);
cmocean('-balance')
caxis([-1,1])

saveas(gcf,'figures/dhdt1979.png');

%%

FindOrCreateFigure("dhdt 2018 snapshot"); 
[~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.dhdt) ;
%set(cbar,'YTick',-2:0.5:2)
%axis tight
%axis off
%hold on ; PlotLatLonGrid(CtrlVar.PlotXYscale) ;
%hold on ; PlotGroundingLines(CtrlVar,MUA,F.GF,[],[],[],'k');
%xlabel("xps (km)",interpreter="latex") ; ylabel("yps (km)",interpreter="latex") ; 
title(cbar,"(m/yr)") ; title("2018 dhdt",interpreter="latex")
%fprintf("VAF=%f (Gt/yr)\n",VAF.Total/1e9)   ; 
%fprintf("GroundedArea=%-7.2f (times the area of iceland)\n",GroundedArea.Total/1e6/103e3) ; 
%colormap(othercolor('Blues7',1024));
%colormap(newMap);
cmocean('-balance')
caxis([-1,1])

saveas(gcf,'figures/dhdt2018.png');
%%
load('/albedo/work/projects/oce_rio/orichter/uacpl/results/ii0040/19800-FW-Antarctic-Forward-MeshFileAdapt3-local.mat.mat');
FindOrCreateFigure("dhdt 1979 spinUp snapshot"); 
[~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.dhdt) ;
%set(cbar,'YTick',-2:0.5:2)
%axis tight
%axis off
%hold on ; PlotLatLonGrid(CtrlVar.PlotXYscale) ;
%hold on ; PlotGroundingLines(CtrlVar,MUA,F.GF,[],[],[],'k');
%xlabel("xps (km)",interpreter="latex") ; ylabel("yps (km)",interpreter="latex") ; 
title(cbar,"(m/yr)") ; title("1979 spin-up dhdt",interpreter="latex")
%fprintf("VAF=%f (Gt/yr)\n",VAF.Total/1e9)   ; 
%fprintf("GroundedArea=%-7.2f (times the area of iceland)\n",GroundedArea.Total/1e6/103e3) ; 
%colormap(othercolor('Blues7',1024));
%colormap(newMap);
cmocean('-balance')
caxis([-1,1])

saveas(gcf,'figures/dhdt1979spinUp.png');
%%

%PlotMeshScalarVariable(CtrlVar,MUAnew.MUA,Fnew.F.h-hnew);
%caxis([-1 1]);
%MUA=MUAnew.MUA; F=Fnew.F;

%load('/albedo/work/projects/oce_rio/orichter/uacpl/results/io0035/2018.00-Nodes129943-Ele255292-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat');
%[VAF,IceVolume,GroundedArea,hAF-hAFoldRm,hfPos]=CalcVAF([],MUA,F.h,F.B,F.S,F.rho,F.rhow,F.GF);
   %CtrlVar=CtrlVarInRestartFile;
   FindOrCreateFigure("hAF 1979-2018 mean") ; 
   [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,(hAF-hAFoldRm)./39) ;
   %set(cbar,'YTick',-2:0.5:2)
   %axis tight
   %axis off
   %hold on ; PlotLatLonGrid(CtrlVar.PlotXYscale) ;
   %hold on ; PlotGroundingLines(CtrlVar,MUA,F.GF,[],[],[],'k');
   %xlabel("xps (km)",interpreter="latex") ; ylabel("yps (km)",interpreter="latex") ; 
   title(cbar,"(m/yr)") ; title("2018-1979 dhAF/dt mean",interpreter="latex")
   %fprintf("VAF=%f (Gt/yr)\n",VAF.Total/1e9)   ; 
   %fprintf("GroundedArea=%-7.2f (times the area of iceland)\n",GroundedArea.Total/1e6/103e3) ; 
   %colormap(othercolor('Blues7',1024));
   cmocean('-balance')
   caxis([-1,1])

   saveas(gcf,'figures/dhAFdt1979-2018Mean.png');

   %%

   FindOrCreateFigure("s 2018 snapshot"); 
[~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.s) ;
%set(cbar,'YTick',-2:0.5:2)
%axis tight
%axis off
%hold on ; PlotLatLonGrid(CtrlVar.PlotXYscale) ;
%hold on ; PlotGroundingLines(CtrlVar,MUA,F.GF,[],[],[],'k');
%xlabel("xps (km)",interpreter="latex") ; ylabel("yps (km)",interpreter="latex") ; 
title(cbar,"(m)") ; title("2018 s",interpreter="latex")
%fprintf("VAF=%f (Gt/yr)\n",VAF.Total/1e9)   ; 
%fprintf("GroundedArea=%-7.2f (times the area of iceland)\n",GroundedArea.Total/1e6/103e3) ; 
%colormap(othercolor('Blues7',1024));
%colormap(newMap);
%cmocean('-balance')
%caxis([-1,1])

saveas(gcf,'figures/s2018.png');

%%
FindOrCreateFigure("dsdt 2018"); 
[~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.dsdt) ;
%set(cbar,'YTick',-2:0.5:2)
%axis tight
%axis off
%hold on ; PlotLatLonGrid(CtrlVar.PlotXYscale) ;
%hold on ; PlotGroundingLines(CtrlVar,MUA,F.GF,[],[],[],'k');
%xlabel("xps (km)",interpreter="latex") ; ylabel("yps (km)",interpreter="latex") ; 
title(cbar,"(m/yr)") ; title("2018 dsdt",interpreter="latex")
%fprintf("VAF=%f (Gt/yr)\n",VAF.Total/1e9)   ; 
%fprintf("GroundedArea=%-7.2f (times the area of iceland)\n",GroundedArea.Total/1e6/103e3) ; 
%colormap(othercolor('Blues7',1024));
%colormap(newMap);
cmocean('-balance')
caxis([-1,1])

saveas(gcf,'figures/dsdt2018.png');
