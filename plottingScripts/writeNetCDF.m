function writeNetCDF(fileName,resultsFolder,slice_user)

if exist(fileName, 'file')==2
  delete(fileName);
end

% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(resultsFolder, '*.mat'); % Change to whatever pattern you need.
theFiles = dir(filePattern);

if nargin > 2
  slice = slice_user;
else
  slice = 1:length(theFiles);
end

theFiles = theFiles(slice);

nccreate(fileName,'time','Dimensions',{'nTime',length(theFiles)},'FillValue',NaN);
nccreate(fileName,'VAF','Dimensions',{'nTime',length(theFiles)},'FillValue',NaN);
nccreate(fileName,'SLE','Dimensions',{'nTime',length(theFiles)},'FillValue',NaN);
nccreate(fileName,'SLED','Dimensions',{'nTime',length(theFiles)},'FillValue',NaN);
nccreate(fileName,'IV','Dimensions',{'nTime',length(theFiles)},'FillValue',NaN);
nccreate(fileName,'ISV','Dimensions',{'nTime',length(theFiles)},'FillValue',NaN);
nccreate(fileName,'GA','Dimensions',{'nTime',length(theFiles)},'FillValue',NaN);
nccreate(fileName,'SMB','Dimensions',{'nTime',length(theFiles)},'FillValue',NaN);
nccreate(fileName,'BMB','Dimensions',{'nTime',length(theFiles)},'FillValue',NaN);
nccreate(fileName,'GLFlux','Dimensions',{'nTime',length(theFiles)},'FillValue',NaN);
nccreate(fileName,'IceExtent','Dimensions',{'nTime',length(theFiles)},'FillValue',NaN);
nccreate(fileName,'IceShelfExtent','Dimensions',{'nTime',length(theFiles)},'FillValue',NaN);

for k = 1 : length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
  
    load(fullFileName);
    time = CtrlVar.time;

    A=TriAreaTotalFE(MUA.coordinates,MUA.connectivity);
    [VAF,IceVolume,GroundedArea,hAF,hfPos]=CalcVAF(CtrlVar,MUA,F.h,F.B,F.S,F.rho,F.rhow,F.GF);
    GF=IceSheetIceShelves(CtrlVar,MUA,F.GF);
    FloatingArea=sum(FEintegrate2D(CtrlVar,MUA,GF.NodesDownstreamOfGroundingLines));
    
    GA = GroundedArea.Total./1e6'; %km2
    IV = IceVolume.Total./1e9'; %km3
    if k==1
        VAFIni=VAF.Total;
    end
    SLED = (VAF.Total-VAFIni)/3.625e11; % mm SLE diff
    SLE = VAF.Total/3.625e14;% m SLE
    VAF = VAF.Total./1e9; %km3
    IceExtent=A./1e6; %total ice extent in km2
    IceShelfExtent=FloatingArea./1e6; %total extent of floating ice in km2
    
    qGL=FluxAcrossGroundingLine(CtrlVar,MUA,F.GF,F.ub,F.vb,F.ud,F.vd,F.h,F.rho);
    GLFlux=sum(qGL)./1e12; %Gt
    
    SMB=sum(FEintegrate2D(CtrlVar,MUA,F.as.*F.rho))./1e12; %total SMB in Gt
    BMB=sum(FEintegrate2D(CtrlVar,MUA,F.ab.*F.rho))./1e12; %total BMB in Gt
    %i = find(UserVar.VAF,1,'last');
    
    %ncwrite(fileName,'time',time,k);
    ncwrite(fileName,'time',k,k);
    ncwrite(fileName,'VAF',VAF,k); %Volume Above Flotation in km3
    ncwrite(fileName,'SLE',SLE,k); %Sea level eqivalent in m
    ncwrite(fileName,'SLED',SLED,k); %Sea level eqivalent in m
    ncwrite(fileName,'GA',GA,k); %Grounded Area in km2
    ncwrite(fileName,'IV',IV,k); % Ice Volume in km3
    ncwrite(fileName,'IceExtent',IceExtent,k); %total ice extend in km2
    ncwrite(fileName,'IceShelfExtent',IceShelfExtent,k);% total extent of floating ice in km2
    ncwrite(fileName,'GLFlux',GLFlux,k); %flux across the grounding line in Gt
    ncwrite(fileName,'BMB',BMB,k); %total BMB in Gt
    ncwrite(fileName,'SMB',SMB,k); %total SMB in GT
end

end
