%function [Fas]=RacmoToUaGriddedInterpolants(filename,latlonfilename,SaveOutputs)

%arguments
filename = "/albedo/work/projects/oce_rio/orichter/uacpl/data/ii0035/SMB_RACMO2.3p2_yearly_ANT27_1979_2018.nc" ;
latlonfilename = filename;
SaveOutputs = true ;
%end

rhow=1030;
rhoi=917;

fprintf(" Reading Racmo data from file %s ",filename) 

rlat = ncread(filename,'rlat');
rlon = ncread(filename,'rlon');
time = ncread(filename,'time');
smb = ncread(filename,'smb');

lat2d = ncread(latlonfilename,'lat');
lon2d = ncread(latlonfilename,'lon');
%mask = ncread(latlonfilename,'mask2d');

fprintf(" Creating multiyear average and converting from mm w.e. per s to m i.e per a")

%smbR = smb.*(3600*24*365.25);
smb = mean(smb,4).*(rhow/rhoi/1000);
mask=ones(size(smb));
mask(smb==smb(1,1))=0;
%fprintf("...done.\n")

%fprintf(' Generating some figures of raw data...')
%figure(10) ; imagesc(rlat,rlon,smb); axis xy equal;  title(' smb in i.e. per a' ) ; colorbar ; axis tight; %caxis([0 0.1]);

%figure(20) ; imagesc(rlat,rlon,smbR(:,:,1,1)); axis xy equal;  title('smb in mm w.e. per a' ) ; colorbar ; axis tight; 
%figure(30) ; imagesc(mask); axis xy equal;  title(' mask ' ) ; colorbar ; axis tight;% caxis([0 0.1]);
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
figure(20) ; scatter(MUA.coordinates(:,1),MUA.coordinates(:,2),50,as,'filled'); axis xy equal;  title(' smb in m i.e. a^-1' ) ; colorbar ; axis tight; %caxis([-4000 1800]);
FindOrCreateFigure('as');
    PlotMeshScalarVariable(CtrlVar,MUA,as);   title('as in m i.e./yr')
    
drawnow ; fprintf('done.\n')
if SaveOutputs
    
    fprintf('Saving Racmo interpolant. \n ')
    save('/albedo/work/projects/oce_rio/orichter/uacpl/data/ii0035/surfaceMassBalanceForAntarcticaBasedOnRacmo','Fas')
end
