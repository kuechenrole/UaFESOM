function writeNetCDF(fileName,resultsFolder,slice_user)

%ncinfo

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

if exist(fileName, 'file')==2
  delete(fileName);
end

nccreate(fileName,'time','Dimensions',{'nTime',length(theFiles)},'FillValue',NaN);
nccreate(fileName,'iceVAF','Dimensions',{'nTime',length(theFiles)},'FillValue',NaN);
nccreate(fileName,'groundedArea','Dimensions',{'nTime',length(theFiles)},'FillValue',NaN);
nccreate(fileName,'iceVolume','Dimensions',{'nTime',length(theFiles)},'FillValue',NaN);
nccreate(fileName,'xGL','Dimensions',{'nPointGL',100000,'nTime',length(theFiles)},'FillValue',NaN);
nccreate(fileName,'yGL','Dimensions',{'nPointGL',100000,'nTime',length(theFiles)},'FillValue',NaN);
nccreate(fileName,'basalMassBalance','Dimensions',{'nTime',length(theFiles)},'FillValue',NaN);

for k = 1 : length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
  
    load(fullFileName);

    time = CtrlVar.time;
    [VAF,IceVolume,GroundedArea]=CalcVAF(CtrlVar,MUA,F.h,F.B,F.S,F.rho,F.rhow,F.GF);
    [GLgeo,GLnodes,GLele]=GLgeometry(MUA.connectivity,MUA.coordinates,F.GF,CtrlVar);
    [xGL,yGL] = ArrangeGroundingLinePos(CtrlVar,GLgeo) ;
    Int=FEintegrate2D([],MUA,F.ab); bmb=sum(Int)*917e-12; 

    ncwrite(fileName,'time',time,k);
    ncwrite(fileName,'iceVAF',VAF.Total,k);
    ncwrite(fileName,'groundedArea',GroundedArea.Total,k);
    ncwrite(fileName,'iceVolume',IceVolume.Total,k);
    ncwrite(fileName,'xGL',xGL,[1 k]);
    ncwrite(fileName,'yGL',yGL,[1 k]);
    ncwrite(fileName,'basalMassBalance',bmb,k);
end

end
