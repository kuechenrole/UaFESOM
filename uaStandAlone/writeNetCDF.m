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

nccreate(fileName,'time','Dimensions',{'nTime',length(theFiles)},'FillValue',NaN);
nccreate(fileName,'VAF','Dimensions',{'nTime',length(theFiles)},'FillValue',NaN);
nccreate(fileName,'IV','Dimensions',{'nTime',length(theFiles)},'FillValue',NaN);
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
    i = find(UserVar.VAF,1,'last');
    
    ncwrite(fileName,'time',time,k);
    ncwrite(fileName,'VAF',UserVar.VAF(i),k); %Volume Above Flotation in km3
    ncwrite(fileName,'GA',UserVar.GA(i),k); %Grounded Area in km2
    ncwrite(fileName,'IV',UserVar.IV(i),k); % Ice Volume in km3
    ncwrite(fileName,'IceExtent',UserVar.IceExtent(i),k); %total ice extend in km2
    ncwrite(fileName,'IceShelfExtent',UserVar.IceShelfExtent(i),k);% total extent of floating ice in km2
    ncwrite(fileName,'GLFlux',UserVar.GLFlux(i),k); %flux across the grounding line in Gt
    ncwrite(fileName,'BMB',UserVar.BMB(i),k); %total BMB in Gt
    ncwrite(fileName,'SMB',UserVar.SMB(i),k); %total SMB in GT
end

end
