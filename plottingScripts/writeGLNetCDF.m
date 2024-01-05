function writeGLNetCDF(fileName,resultsFolder,meshPath,slice_user)

if exist(fileName, 'file')==2
  delete(fileName);
end

% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(resultsFolder, '*.mat'); % Change to whatever pattern you need.
theFiles = dir(filePattern);

if nargin > 3
  slice = slice_user;
else
  slice = 1:length(theFiles);
end

theFiles = theFiles(slice);

nccreate(fileName,'time','Dimensions',{'nTime',length(theFiles)},'FillValue',NaN);
nccreate(fileName,'xGL','Dimensions',{'nPointGL',300000,'nTime',length(theFiles)},'FillValue',NaN);
nccreate(fileName,'yGL','Dimensions',{'nPointGL',300000,'nTime',length(theFiles)},'FillValue',NaN);

%load(meshPath);

for k = 1 : length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
  
    load(fullFileName);

    time = CtrlVar.time;
    [GLgeo,GLnodes,GLele]=GLgeometry(MUA.connectivity,MUA.coordinates,F.GF,CtrlVar);
    [xGL,yGL] = ArrangeGroundingLinePos(CtrlVar,GLgeo) ;

    ncwrite(fileName,'time',time,k);
    ncwrite(fileName,'xGL',xGL,[1 k]);
    ncwrite(fileName,'yGL',yGL,[1 k]);

end

end
