function [UserVar,as,ab]=DefineMassBalance(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)


persistent Fas Fab


disp('DefineSurfaceMassBalance')

if isempty(Fas)
    
    fprintf('loading file: %-s ',UserVar.SurfaceMassBalanceInterpolant)
    load(UserVar.SurfaceMassBalanceInterpolant,'Fas')
    fprintf(' done \n')
    
end

as = Fas(MUA.coordinates(:,1),MUA.coordinates(:,2));

disp('DefineBasalMassBalance')

rhofw = 1000;
rho_ice = 917;% already defined by default

if isempty(Fab)
    
    fprintf('loading file: %-s ',UserVar.BasalMassBalanceInterpolant)
    load(UserVar.BasalMassBalanceInterpolant,'Fab')
    fprintf(' done \n')
    
end

xUa = MUA.coordinates(:,1);
yUa = MUA.coordinates(:,2);
wnetUa = Fab(xUa,yUa);
wnetUa = wnetUa.*365.25*24*3600.*-1;
wnetUa = wnetUa.*(rhofw/rho_ice);

ab=wnetUa.*(1-GF.node);
%GF=IceSheetIceShelves(CtrlVar,MUA,GF);
%ab=wnetUa.*GF.NodesDownstreamOfGroundingLines;

end
 

%{
    xfes=transpose(nodes(2,:)*111000);
    yfes=transpose(nodes(3,:)*111000);

fprintf(" Reading Racmo data from file %s ",filename) 

rlat = ncread(filename,'rlat');
rlon = ncread(filename,'rlon');
time = ncread(filename,'time');
smb = ncread(filename,'smb');

lat2d = ncread(latlonfilename,'lat2d');
lon2d = ncread(latlonfilename,'lon2d');
mask = ncread(latlonfilename,'mask2d');

fprintf(" Creating multiyear average and converting from mm w.e. per a to m i.e per a")

smb = mean(smb,4).*(rhow/rhoi*1000);

%fprintf("...done.\n")

%fprintf(' Generating some figures of raw data...')
figure(10) ; imagesc(rlat,rlon,smb(:,:,1,1)); axis xy equal;  title(' smb ' ) ; colorbar ; axis tight; caxis([0 0.1]);
figure(30) ; imagesc(mask); axis xy equal;  title(' mask ' ) ; colorbar ; axis tight;% caxis([0 0.1]);
%figure(20) ; imagesc(lat2d); axis xy equal;  title(' lat' ) ; colorbar ; axis tight
%figure(30) ; imagesc(lon2d); axis xy equal;  title(' lat' ) ; colorbar ; axis tight
%figure(40) ; imagesc(x); axis xy equal;  title(' x' ) ; colorbar ; axis tight
%figure(50) ; imagesc(y); axis xy equal;  title(' x' ) ; colorbar ; axis tight
%figure(60) ; imagesc(MUA.coordinates); axis xy equal;  title(' MUA' ) ; colorbar ; axis tight
%figure(30) ; imagesc(x,y,firn); axis xy equal; caxis([0 50]); title(' firn ' ) ; colorbar ; axis tight 
%figure(40) ; imagesc(x,y,surface); axis xy equal; caxis([0 4800]); title(' surface ' ) ; colorbar ; axis tight
%figure(50) ; imagesc(x,y,geoid); axis xy equal; caxis([-100 100]); title(' geoid ' ) ; colorbar ; axis tight
%figure(60) ; imagesc(x,y,mask); axis xy equal; caxis([0 4]); title(' mask ' ) ; colorbar ; axis tight
drawnow ; fprintf('done.\n')

fprintf(" transforming coordinates to polar stereographic (bedMachine) and generating interpolant")
[x,y]=polarstereo_fwd(lat2d,lon2d,6378137.0,0.08181919,-71,0);

x=x(mask==1); y=y(mask==1); smb = smb(mask==1);

%xf = reshape(x.',1,[]); yf = reshape(y.',1,[]); smbf = reshape(smb.',1,[]);
%Fas = scatteredInterpolant(xf',yf',smbf');
Fas = scatteredInterpolant(x,y,smb,'linear','nearest');

disp(' Generating some figure of checkup ...')
as = Fas(MUA.coordinates);
figure(20) ; scatter(MUA.coordinates(:,1),MUA.coordinates(:,2),10,as); axis xy equal;  title(' smb ' ) ; colorbar ; axis tight; %caxis([-4000 1800]);

drawnow ; fprintf('done.\n')
if SaveOutputs

    fprintf('Saving Racmo interpolant. \n ')
    save('../myUtilities/surfaceMassBalanceForAntarcticaBasedOnRacmo','Fas')
end


    fprintf('loading file: %-s ',UserVar.fesomMeltPath)
    wnetFes = ncread(UserVar.fesomMeltPath,'wnet');
    fprintf(' done \n')
    wnetFes = double(wnetFes(:,end));
    fid=fopen(UserVar.fesomCoordPath,'r');
    n2d=fscanf(fid,'%g',1);
    nodes=fscanf(fid, '%g', [4,n2d]);
    fclose(fid);
    xfes=transpose(nodes(2,:)*111000);
    yfes=transpose(nodes(3,:)*111000);
    

    Fab = scatteredInterpolant(xfes,yfes,wnetFes,'linear','nearest');
end

xUa = MUA.coordinates(:,1);
yUa = MUA.coordinates(:,2);
wnetUa = Fab(xUa,yUa);
wnetUa = wnetUa.*365.25*24*3600.*-1;
wnetUa = wnetUa.*(rhofw/rho_ice);

%ab=wnetUa.*(1-GF.node);
GF=IceSheetIceShelves(CtrlVar,MUA,GF);
ab=wnetUa.*GF.NodesDownstreamOfGroundingLines;



end
%}
