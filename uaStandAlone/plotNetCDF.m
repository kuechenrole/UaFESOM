function plotResults(fileName)

time=ncread(fileName,'time');
VAF = ncread(fileName,'VAF');
GA = ncread(fileName,'GA');
IV = ncread(fileName,'IV');
IceExtent= ncread(fileName,'IceExtent');
IceShelfExtent= ncread(fileName,'IceShelfExtent');
GLFlux= ncread(fileName,'GLFlux');
BMB = ncread(fileName,'BMB');
SMB= ncread(fileName,'SMB');

figure('name','VAF');
movegui(1);
plot(time,VAF);
xlabel('time since start in years');
ylabel('VAF in km^3');
title('Volume Above Flotation in km^3');

figure('name','GA');
plot(time,GA);
xlabel('time since start in years');
ylabel('GA in km^2');
title('Grounded Area in km^2');

figure('name','IV');
plot(time,IV);
xlabel('time since start in years');
ylabel('IV in km^2');
title('Ice Volume in km^2');

figure('name','IceExtent');
plot(time,IceExtent);
xlabel('time since start in years');
ylabel('IceExtent in km^2');
title('Total Ice Extent in km^2');

figure('name','IceShelfExtent');
plot(time,IceShelfExtent);
xlabel('time since start in years');
ylabel('IceShelfExtent in km^2');
title('Total Floating Ice Extent in km^2');

figure('name','GLFlux');
plot(time,GLFlux);
xlabel('time since start in years');
ylabel('GLFlux in Gt/yr');
title('Flux across the grounding line in Gt/yr');

figure('name','SMB');
plot(time,SMB);
xlabel('time since start in years');
ylabel('SMB in Gt/yr');
title('Surface Mass Balance in Gt/yr');

figure('name','BMB');
plot(time,BMB);
xlabel('time since start in years');
ylabel('BMB in Gt/yr');
title('Basal Mass Balance in Gt/yr');


end