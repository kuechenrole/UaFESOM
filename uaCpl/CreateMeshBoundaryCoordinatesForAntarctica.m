
function MeshBoundaryCoordinates=CreateMeshBoundaryCoordinatesForPIGandTWG(UserVar,CtrlVar)


%% 

% load boundary based on BedMachine data
load(UserVar.MeshBoundaryCoordinatesFile,"Boundary") ; 

% Now smooth and sub-sample Boundary
CtrlVar.GLtension=1e-12; % tension of spline, 1: no smoothing; 0: straight line
CtrlVar.GLds=UserVar.DistanceBetweenPointsAlongBoundary;

[xB,yB] = Smooth2dPos(Boundary(:,1),Boundary(:,2),CtrlVar);

MeshBoundaryCoordinates=[xB yB] ;

save('MeshBoundaryCoordinates','MeshBoundaryCoordinates')

% FindOrCreateFigure("MeshBoundaryCoordinates") 
%  plot(MeshBoundaryCoordinates(:,1)/1000,MeshBoundaryCoordinates(:,2)/1000,'r.-')
%  axis equal


end
