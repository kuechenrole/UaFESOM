plotGLNetCDF('/albedo/work/projects/oce_rio/orichter/ollieHome/Misomip2/ii0033/uaSource/GL.nc','without remeshing','withoutRemeshing','show')

plotGLNetCDF('/albedo/home/orichter/uacpl/ii0035/GL.nc','with remeshing','withRemeshing','show')

function plotGLNetCDF(fileName,titleStr,saveStr,legStr)

time=ncread(fileName,'time');
xGL= ncread(fileName,'xGL');
yGL = ncread(fileName,'yGL');

fig=FindOrCreateFigure('GL positions');
%fig.Position = [10 10 600 500];
%load meshFile;
%PlotMuaMesh(CtrlVar,MUA)
colororder(jet(5));
%for k = 1:length(time)
for k = [1,5,10,15,20]
    plot(xGL(:,k),yGL(:,k),'LineWidth',1,'DisplayName',string(k));
    hold on
end
leg=legend(legStr);
title(leg,'year')
title(titleStr)
%load meshFile;
%PlotMuaMesh(CtrlVar,MUA)
xlim([-1.52 -0.8].*10^6)
ylim([1 6].*10^5)
set(gcf,'color','w');
axis('off')
exportgraphics(gcf,['figures/GL_',saveStr,'.png'],'Resolution',300);
end


