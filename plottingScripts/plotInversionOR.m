load /albedo/work/projects/oce_rio/orichter/ollieWork/Misomip2/ii0020/uaRestart/IR-Inverse-MatOpt-MatlabOptimization-Nod3-M-Adjoint-Cga1k000000-Cgs1000000k000000-Aga1k000000-Ags1000000k000000-m3-logA-logC.mat;
CtrlVar=CtrlVarInRestartFile;
UserVar=UserVarInRestartFile;

CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=0;
us=F.ub+F.ud; vs=F.vb+F.vd;

x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);

GLgeo=GLgeometry(MUA.connectivity,MUA.coordinates,GF,CtrlVar); xGL=[] ; yGL=[] ;

speedMeas=sqrt(Meas.us.^2+Meas.vs.^2);
speedCalc=sqrt(F.ub.^2+F.vb.^2) ;

usError=sqrt(spdiags(Meas.usCov));
vsError=sqrt(spdiags(Meas.vsCov));
ErrSpeed=sqrt(usError.^2+vsError.^2); 

CtrlVar.VelPlotIntervalSpacing='log10';

%%
fig=FindOrCreateFigure('C at the end of inversion') ;

PlotMeshScalarVariable(CtrlVar,MUA,log10(InvFinalValues.C));
hold on

[xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r');
xlabel(CtrlVar.PlotsXaxisLabel);  ylabel(CtrlVar.PlotsYaxisLabel);
CtrlVar.PlotNodes=0 ; % PlotMuaMesh(CtrlVar,MUA,[],'k') ;
fontsize(gcf,12,"points");
title('log(C)','interpreter','latex');
cbar=colorbar; title(cbar, '($m\,\mathrm{yr}^{-1}\,\mathrm{kPa}^{-m}$)','interpreter','latex');
axis('off')
set(gcf,'color','w');
saveas(gcf,'figures/inversionC.png');


fig=FindOrCreateFigure('A at the end of inversion') ;
PlotMeshScalarVariable(CtrlVar,MUA,log10(InvFinalValues.AGlen));
hold on
[xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r');
xlabel(CtrlVar.PlotsXaxisLabel);  ylabel(CtrlVar.PlotsYaxisLabel);
CtrlVar.PlotNodes=0 ; % PlotMuaMesh(CtrlVar,MUA,[],'k') ;
fontsize(gcf,12,"points");
title('log(A)','interpreter','latex') ; cbar=colorbar; title(cbar, '($\mathrm{a}^{-1}$ $\mathrm{kPa}^{-3}$)',interpreter="latex");   
axis('off')
set(gcf,'color','w');
saveas(gcf,'figures/inversionA.png');

%%
%{
fig=FindOrCreateFigure('Measured velocities') ;
QuiverColorGHG(x,y,Meas.us,Meas.vs,CtrlVar); axis equal ;fontsize(gcf,12,"points"); title('Measured velocities','interpreter','latex') ;
hold on ; [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r');
PlotMuaBoundary(CtrlVar,MUA,'b')  ;
xlabel(CtrlVar.PlotsXaxisLabel);  ylabel(CtrlVar.PlotsYaxisLabel);
axis([min(x) max(x) min(y) max(y)]/CtrlVar.PlotXYscale)
axis('off')
set(gcf,'color','w');
saveas(gcf,'figures/inversionMeasUV.png');
%}

fig=FindOrCreateFigure('Calculated velocities') ;
[cbar,~,Par]=QuiverColorGHG(x,y,us,vs,CtrlVar); axis equal ;fontsize(gcf,12,"points"); title('Calculated velocities','interpreter','latex') ;
hold on ; [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'color',[0.5,0.5,0.5]);
PlotMuaBoundary(CtrlVar,MUA,'b')  ;
xlabel(CtrlVar.PlotsXaxisLabel);  ylabel(CtrlVar.PlotsYaxisLabel);
axis([min(x) max(x) min(y) max(y)]/CtrlVar.PlotXYscale)
axis('off')
set(gcf,'color','w');
saveas(gcf,'figures/inversionUV.png');

usDiff=us-Meas.us;
vsDiff=vs-Meas.vs;

usDiff(MUA.Boundary.Nodes)=0;
vsDiff(MUA.Boundary.Nodes)=0;

usDiff(Meas.us==0)=0;
vsDiff(Meas.vs==0)=0;

fig=FindOrCreateFigure('Velocity Misfit (calc-meas)');
Par.QuiverSameVelocityScalingsAsBefore=1;
QuiverColorGHG(x,y,usDiff,vsDiff,Par); axis equal ;fontsize(gcf,12,"points"); title('Velocity Misfit (Calc - Meas)','interpreter','latex') ;
hold on ; [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'color',[0.5,0.5,0.5]);
PlotMuaBoundary(CtrlVar,MUA,'b')  ; xlabel(CtrlVar.PlotsXaxisLabel);  ylabel(CtrlVar.PlotsYaxisLabel);
axis([min(x) max(x) min(y) max(y)]/CtrlVar.PlotXYscale)
axis('off')
set(gcf,'color','w');
saveas(gcf,'figures/inversionUVDiffSameColorScale.png'); 


fig=FindOrCreateFigure('Velocity residual (calc-meas)/err');
QuiverColorGHG(x,y,usDiff./usError,vsDiff./vsError,CtrlVar); axis equal ;fontsize(gcf,12,"points"); title('Velocity Residual','interpreter','latex') ;
hold on ; [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r');
PlotMuaBoundary(CtrlVar,MUA,'b')  ; xlabel(CtrlVar.PlotsXaxisLabel);  ylabel(CtrlVar.PlotsYaxisLabel);
axis([min(x) max(x) min(y) max(y)]/CtrlVar.PlotXYscale)
axis('off')
set(gcf,'color','w');
cabr=colorbar;
title(cbar,'');
saveas(gcf,'figures/inversionUVResidual.png');

%%
fig=FindOrCreateFigure('measured speed')
[~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,log10(speedMeas)) ;
title('measured speed','interpreter','latex') ; cbar=colorbar; title(cbar, '(log10 m/yr)',interpreter="latex");
hold on ; [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'color',[0.3,0.3,0.3]);
%PlotMuaBoundary(CtrlVar,MUA,'b')  ; xlabel(CtrlVar.PlotsXaxisLabel);  ylabel(CtrlVar.PlotsYaxisLabel);
caxis([0,3.5]); 
axis('off')
set(gcf,'color','w');
cmocean('speed')
saveas(gcf,'figures/inversionSpeedMeas.png');

fig=FindOrCreateFigure('calculated speed')
[~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,log10(speedCalc)) ;
title('calculated speed','interpreter','latex') ; cbar=colorbar; title(cbar, 'log10(m/yr)',interpreter="latex");
hold on ; [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'color',[0.3,0.3,0.3]);
%PlotMuaBoundary(CtrlVar,MUA,'b')  ; xlabel(CtrlVar.PlotsXaxisLabel);  ylabel(CtrlVar.PlotsYaxisLabel);
caxis([0,3.5]);
axis('off')
set(gcf,'color','w');
cmocean('speed')
saveas(gcf,'figures/inversionSpeedCalc.png');

fig=FindOrCreateFigure('measured speed error')
[~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,log10(ErrSpeed)); 
title('speed misfit','interpreter','latex') ; cbar=colorbar; title(cbar, 'log10(m/yr)',interpreter="latex");
%hold on ; [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r');
%PlotMuaBoundary(CtrlVar,MUA,'b')  ; xlabel(CtrlVar.PlotsXaxisLabel);  ylabel(CtrlVar.PlotsYaxisLabel);
caxis([0,3.5]);
axis('off')
set(gcf,'color','w');
cmocean('speed')
saveas(gcf,'figures/inversionSpeedErr.png');

fig=FindOrCreateFigure('speed residual')
[~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,(speedMeas-speedCalc)./ErrSpeed); 
title('speed residual','interpreter','latex') ; cbar=colorbar; title(cbar, '',interpreter="latex");
hold on ; [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r');
PlotMuaBoundary(CtrlVar,MUA,'b')  ; xlabel(CtrlVar.PlotsXaxisLabel);  ylabel(CtrlVar.PlotsYaxisLabel);
caxis([-30,30]);
axis('off')
set(gcf,'color','w');
saveas(gcf,'figures/inversionSpeedResidual.png');
%%
disp('0')
mean(ErrSpeed)

disp('50')
ii=speedMeas>50;
mean(ErrSpeed(ii))

disp('100')
ii=speedMeas>100;
mean(ErrSpeed(ii))

disp('500')
ii=speedMeas>500;
mean(ErrSpeed(ii))

disp('1000')
ii=speedMeas>1000;
mean(ErrSpeed(ii))
%%
%{
usError=sqrt(spdiags(Meas.usCov));
vsError=sqrt(spdiags(Meas.vsCov));

Kplot=Kplot+1;    
subplot(Iplot,Jplot,Kplot);
QuiverColorGHG(x,y,(usDiff)./usError,(vsDiff)./vsError,CtrlVar);
title('((us-Meas.us)/usError,(vs-Meas.vs)/vsError)') ;
hold on
[xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r');
PlotMuaBoundary(CtrlVar,MUA,'b')  ;
xlabel(CtrlVar.PlotsXaxisLabel);  ylabel(CtrlVar.PlotsYaxisLabel);
axis([min(x) max(x) min(y) max(y)]/CtrlVar.PlotXYscale)
%}



