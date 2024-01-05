%% plot Ua mesh

load('/albedo/work/projects/oce_rio/orichter/uacpl/results/io0036/1979.00-Nodes129738-Ele254869-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat', ...
    'MUA','BCs','F','CtrlVar')
%GLgeo=[]; xGL=[] ; yGL=[];
%[xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL);
f = figure;
f.Position=[10 10 700 500];
dens=sqrt(MUA.EleAreas.*4).*(3^(-1/4))./1000-1;
newdens=dens;
tickVals = linspace(2,200,9);
newTickVals=[0,2,5,10,20,50,100,150,200];
for tv = 2:length(newTickVals)
    % find all data between the new tick ranges, one block at a time
    ind = dens>=newTickVals(tv-1) & dens<newTickVals(tv);
    % Change the corresponding values in the copied data to scale to the
    % block edges
    newdens(ind) = rescale(dens(ind),tickVals(tv-1),tickVals(tv));
end
PlotElementBasedQuantities(MUA.connectivity,MUA.coordinates,newdens,CtrlVar);
C=parula(8);
%C(end+1,:)=1;
colormap(C);
cb=colorbar('Ticks',tickVals,...
    'TickLabels',["0" "2" "5" "10" "20" "50" "100" "150" "200"])
%cb = colorbar;
ylabel(cb,'Resolution in km')
axis off;
xlabel('km')
ylabel('km')
set(gcf,'color','w');
%set(cb,'YTick',[2 20 40 60 80 100 120 140 160 180]);
%hold on
%[xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'k');
%caxis([2 200])
%ylabel(cb,'Resolution in km','FontSize',12,'Rotation',270)
fontsize(gcf,16,"points");
pos = get(gca, 'Position');
set(gca, 'Position', [pos(1) pos(2) pos(3)-0.04 pos(4)]);
saveas(gcf,'figures/uaResolutionTotal.png');
%exportgraphics(f,'barchart.png','Resolution',300)
%%
axis([-1560 -400 80 1100]);
%axis([-1700 -00 0 1300]);
caxis([2 60]);
%savefig('./figures/meshFRIS.fig');
saveas(gcf,'figures/uaResolutionFRIS.png');
%%

axis([-1700 -1530 -360 -200]);
caxis([2 25]);
set(cb,'YTick',[2  4  6  8  10 12 14 16 18 20 22 24]);

%savefig('./figures/meshPIG.fig');
saveas(gcf,'figures/uaResolutionPIG.png')


%%



%% plot Ua mesh

load('/albedo/work/projects/oce_rio/orichter/uacpl/results/io0036/1979.00-Nodes129738-Ele254869-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat', ...
    'MUA','BCs','F','CtrlVar')
%GLgeo=[]; xGL=[] ; yGL=[];
%[xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL);
f = figure;
f.Position=[100 100 700 500];

PlotElementBasedQuantities(MUA.connectivity,MUA.coordinates,sqrt(MUA.EleAreas.*4).*(3^(-1/4))./1000,CtrlVar);
cb = colorbar;
ylabel(cb,'Resolution in km')
axis off;
xlabel('km')
ylabel('km')
set(gcf,'color','w');
set(cb,'YTick',[2 20 40 60 80 100 120 140 160 180]);
%hold on
%[xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'k');
%caxis([2 200])
%ylabel(cb,'Resolution in km','FontSize',12,'Rotation',270)
fontsize(gcf,12,"points");
saveas(gcf,'figures/uaResolutionTotal.png');
%exportgraphics(f,'barchart.png','Resolution',300)
%%
axis([-1560 -400 80 1100]);
%axis([-1700 -00 0 1300]);
caxis([2 60]);
%savefig('./figures/meshFRIS.fig');
saveas(gcf,'figures/uaResolutionFRIS.png');
%%

axis([-1700 -1530 -360 -200]);
caxis([2 25]);
set(cb,'YTick',[2  4  6  8  10 12 14 16 18 20 22 24]);

%savefig('./figures/meshPIG.fig');
saveas(gcf,'figures/uaResolutionPIG.png')


%%


