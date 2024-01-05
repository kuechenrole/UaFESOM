%function plotResults(fileName)
fileName='/albedo/work/projects/oce_rio/orichter/uacpl/postprocessing/ii0040/VAF.nc';
fileName2='/albedo/work/projects/oce_rio/orichter/uacpl/postprocessing/io0036/VAF.nc';
fileName3='/albedo/work/projects/oce_rio/orichter/uacpl/postprocessing/ii0020/VAF.nc';
fileName4='/albedo/work/projects/oce_rio/orichter/uacpl/postprocessing/io0035/VAF.nc';

time=ncread(fileName,'time');
VAF = ncread(fileName,'VAF');
GA = ncread(fileName,'GA');
IV = ncread(fileName,'IV');
IceExtent= ncread(fileName,'IceExtent');
IceShelfExtent= ncread(fileName,'IceShelfExtent');
GLFlux= ncread(fileName,'GLFlux');
BMB = ncread(fileName,'BMB');
SMB= ncread(fileName,'SMB');
SLE=-(VAF-VAF(1)).*1e9./3.625e11;

time2=ncread(fileName2,'time');
VAF2 = ncread(fileName2,'VAF');
GA2 = ncread(fileName2,'GA');
IV2 = ncread(fileName2,'IV');
IceExtent2= ncread(fileName2,'IceExtent');
IceShelfExtent2= ncread(fileName2,'IceShelfExtent');
GLFlux2= ncread(fileName2,'GLFlux');
BMB2 = ncread(fileName2,'BMB');
SMB2= ncread(fileName2,'SMB');
SLE2=-(VAF2-VAF(1)).*1e9./3.625e11;

time3=ncread(fileName3,'time');
VAF3 = ncread(fileName3,'VAF');
GA3 = ncread(fileName3,'GA');
IV3 = ncread(fileName3,'IV');
IceExtent3= ncread(fileName3,'IceExtent');
IceShelfExtent3= ncread(fileName3,'IceShelfExtent');
GLFlux3= ncread(fileName3,'GLFlux');
BMB3 = ncread(fileName3,'BMB');
SMB3= ncread(fileName3,'SMB');
SLE3=-(VAF3-VAF3(1)).*1e9./3.625e11;

time4=ncread(fileName4,'time');
VAF4 = ncread(fileName4,'VAF');
GA4 = ncread(fileName4,'GA');
IV4 = ncread(fileName4,'IV');
IceExtent4= ncread(fileName4,'IceExtent');
IceShelfExtent4= ncread(fileName4,'IceShelfExtent');
GLFlux4= ncread(fileName4,'GLFlux');
BMB4 = ncread(fileName4,'BMB');
SMB4= ncread(fileName4,'SMB');
SLE4=-(VAF4-VAF3(1)).*1e9./3.625e11;
%%
%fontsize(scale=1.2)

figure('name','SLE');
fontsize(gcf,scale=1.2)
movegui(1);
plot([SLE(2:end)' SLE2(2:end)'],'label','cd=0.0125');
plot([SLE3(2:20)' SLE4(2:end)']);
xline(20)
%xticks(1:10:59)
%xticklabels(([(1:10:20) (1979:10:2017)]));
xlabel('time in years');
ylabel('sea sevel rise contribution in mm');
title('global mean sea level rise contribution');
set(gcf,'color','w');
saveas(gcf,'./figures/uaIntegratedSLE.png');

figure('name','VAF');
movegui(1);
plot([VAF(2:end)' VAF2(2:end)']);
xline(20)
%xticks(1:10:59)
%xticklabels(([(1:10:20) (1979:10:2017)]));
xlabel('time in years');
ylabel('VAF in km^3');
title('Volume Above Flotation in km^3');
set(gcf,'color','w');
saveas(gcf,'./figures/uaIntegratedVAF.png');


figure('name','GA');
plot([GA(2:end)' GA2(2:end)']);
xline(20)
xlabel('time in years');
ylabel('GA in km^2');
title('Grounded Area in km^2');
set(gcf,'color','w');
saveas(gcf,'./figures/uaIntegratedGA.png');

figure('name','IV');
plot([IV(2:end)' IV2(2:end)']);
xline(20)
xlabel('time in years');
ylabel('IV in km^3');
title('Ice Volume in km^3');
set(gcf,'color','w');
saveas(gcf,'./figures/uaIntegratedIV.png');

figure('name','IceExtent');
plot([IceExtent(2:end)' IceExtent2(2:end)']);
xline(20)
xlabel('time in years');
ylabel('IceExtent in km^2');
title('Total Ice Extent in km^2');
set(gcf,'color','w');
saveas(gcf,'./figures/uaIntegratedIE.png');

figure('name','IceShelfExtent');
plot([IceShelfExtent(2:end)' IceShelfExtent2(2:end)']);
xline(20)
xlabel('time since start in years');
ylabel('IceShelfExtent in km^2');
title('Total Floating Ice Extent in km^2');
set(gcf,'color','w');
saveas(gcf,'./figures/uaIntegratedISE.png');

figure('name','GLFlux');
plot([GLFlux(2:end)' GLFlux2(2:end)']);
xline(20)
xlabel('time in years');
ylabel('GLFlux in Gt/yr');
title('Flux across the grounding line in Gt/yr');
set(gcf,'color','w');
saveas(gcf,'./figures/uaIntegratedGLFlux.png');

figure('name','SMB');
plot([SMB(2:end)' SMB2(2:end)']);
xline(20)
xlabel('time in years');
ylabel('SMB in Gt/yr');
title('Surface Mass Balance in Gt/yr');
set(gcf,'color','w');
saveas(gcf,'./figures/uaIntegratedSMB.png');

figure('name','BMB');
plot([BMB(2:end)' BMB2(2:end)']);
xline(20)
xlabel('time in years');
ylabel('BMB in Gt/yr');
title('Basal Mass Balance in Gt/yr');
set(gcf,'color','w');
saveas(gcf,'./figures/uaIntegratedBMB.png');

%%
%fileName='/albedo/work/projects/oce_rio/orichter/uacpl/postprocessing/ii0040/VAF.nc';
%fileName2='/albedo/work/projects/oce_rio/orichter/uacpl/postprocessing/io0036/VAF.nc';
fileName='/albedo/work/projects/oce_rio/orichter/uacpl/postprocessing/ii0020/VAF.nc';
fileName2='/albedo/work/projects/oce_rio/orichter/uacpl/postprocessing/io0035/VAF.nc';

time=ncread(fileName,'time');
VAF = ncread(fileName,'VAF');
GA = ncread(fileName,'GA');
IV = ncread(fileName,'IV');
IceExtent= ncread(fileName,'IceExtent');
IceShelfExtent= ncread(fileName,'IceShelfExtent');
GLFlux= ncread(fileName,'GLFlux');
BMB = ncread(fileName,'BMB');
SMB= ncread(fileName,'SMB');
SLE=-(VAF-VAF(1)).*1e9./3.625e11;

time2=ncread(fileName2,'time');
VAF2 = ncread(fileName2,'VAF');
GA2 = ncread(fileName2,'GA');
IV2 = ncread(fileName2,'IV');
IceExtent2= ncread(fileName2,'IceExtent');
IceShelfExtent2= ncread(fileName2,'IceShelfExtent');
GLFlux2= ncread(fileName2,'GLFlux');
BMB2 = ncread(fileName2,'BMB');
SMB2= ncread(fileName2,'SMB');
SLE2=-(VAF2-VAF(1)).*1e9./3.625e11;

%fontsize(scale=1.2)

figure('name','SLE');
fontsize(gcf,scale=1.2)
movegui(1);
plot([SLE(2:end)' SLE2(2:end)']);
xline(39)
%xticks(1:10:59)
%xticklabels(([(1:10:20) (1979:10:2017)]));
xlabel('time in years');
ylabel('sea sevel rise contribution in mm');
title('global mean sea level rise contribution');
set(gcf,'color','w');
saveas(gcf,'./figures/uaIntegratedSLE.png');

figure('name','VAF');
movegui(1);
plot([VAF(2:end)' VAF2(2:end)']);
xline(39)
%xticks(1:10:59)
%xticklabels(([(1:10:20) (1979:10:2017)]));
xlabel('time in years');
ylabel('VAF in km^3');
title('Volume Above Flotation in km^3');
set(gcf,'color','w');
saveas(gcf,'./figures/uaIntegratedVAF.png');


figure('name','GA');
plot([GA(2:end)' GA2(2:end)']);
xline(39)
xlabel('time in years');
ylabel('GA in km^2');
title('Grounded Area in km^2');
set(gcf,'color','w');
saveas(gcf,'./figures/uaIntegratedGA.png');

figure('name','IV');
plot([IV(2:end)' IV2(2:end)']);
xline(39)
xlabel('time in years');
ylabel('IV in km^3');
title('Ice Volume in km^3');
set(gcf,'color','w');
saveas(gcf,'./figures/uaIntegratedIV.png');

figure('name','IceExtent');
plot([IceExtent(2:end)' IceExtent2(2:end)']);
xline(39)
xlabel('time in years');
ylabel('IceExtent in km^2');
title('Total Ice Extent in km^2');
set(gcf,'color','w');
saveas(gcf,'./figures/uaIntegratedIE.png');

figure('name','IceShelfExtent');
plot([IceShelfExtent(2:end)' IceShelfExtent2(2:end)']);
xline(39)
xlabel('time since start in years');
ylabel('IceShelfExtent in km^2');
title('Total Floating Ice Extent in km^2');
set(gcf,'color','w');
saveas(gcf,'./figures/uaIntegratedISE.png');

figure('name','GLFlux');
plot([GLFlux(2:end)' GLFlux2(2:end)']);
xline(39)
xlabel('time in years');
ylabel('GLFlux in Gt/yr');
title('Flux across the grounding line in Gt/yr');
set(gcf,'color','w');
saveas(gcf,'./figures/uaIntegratedGLFlux.png');

figure('name','SMB');
plot([SMB(2:end)' SMB2(2:end)']);
xline(39)
xlabel('time in years');
ylabel('SMB in Gt/yr');
title('Surface Mass Balance in Gt/yr');
set(gcf,'color','w');
saveas(gcf,'./figures/uaIntegratedSMB.png');

figure('name','BMB');
plot([BMB(2:end)' BMB2(2:end)']);
xline(39)
xlabel('time in years');
ylabel('BMB in Gt/yr');
title('Basal Mass Balance in Gt/yr');
set(gcf,'color','w');
saveas(gcf,'./figures/uaIntegratedBMB.png');
%end