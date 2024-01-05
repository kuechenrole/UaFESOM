load('/albedo/work/projects/oce_rio/orichter/uacpl/results/io0036/2017.00-Nodes129557-Ele254528-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat');
CtrlVar.PlotXYscale=1000;
GLgeo=[]; xGL=[] ; yGL=[];
[~,cbar] = PlotMeshScalarVariable(CtrlVar,MUA,F.as);
title(cbar,"(m/yr)") ; title("surface mass balance",interpreter="latex");
%hold on
axis off
set(gcf,'color','w');

%[xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'k');
%hold off
saveas(gcf,'figures/SMB.png');