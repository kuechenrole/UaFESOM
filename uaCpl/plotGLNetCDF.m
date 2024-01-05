function plotGLNetCDF(fileName,titleStr)

time=ncread(fileName,'time');
xGL= ncread(fileName,'xGL');
yGL = ncread(fileName,'yGL');

figure('name','GL positions');
%load meshFile;
%PlotMuaMesh(CtrlVar,MUA)
colororder(jet(size(time,1)+1));
for k = 1:length(time)
    plot(xGL(:,k),yGL(:,k),'LineWidth',2,'DisplayName',string(time(k)));
    hold on
end
legend;
title([titleStr,' Grounding line positions at different times'])
%load meshFile;
%PlotMuaMesh(CtrlVar,MUA)
end