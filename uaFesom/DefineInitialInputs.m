
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)


%% Select the type of run by uncommenting one of the following options:

if isempty(UserVar) || ~isfield(UserVar,'RunType')
    
    %UserVar.RunType='Inverse-MatOpt';
    %UserVar.RunType='Forward-Diagnostic';
    UserVar.RunType='Forward-Transient';
     %UserVar.RunType='TestingMeshOptions';

end

if isempty(UserVar) || ~isfield(UserVar,'m')
    UserVar.m=3;
end


CtrlVar.FlowApproximation="SSTREAM" ;

UserVar.InputDir='/albedo/work/projects/oce_rio/orichter/uacpl/data/io0036/';
UserVar.OutputDir='/albedo/work/projects/oce_rio/orichter/uacpl/results/io0036/';
UserVar.RestartDir='/albedo/work/projects/oce_rio/orichter/uacpl/restart/io0036/';
UserVar.InitialRestartFile='/albedo/work/projects/oce_rio/orichter/uacpl/restart/ii0040/Restart-Forward-Transient-1999.mat';

UserVar.StartOutputID='2017.00';
UserVar.FinalOutputID='2018.00';

UserVar.GeometryInterpolant=[UserVar.InputDir,'BedMachineGriddedInterpolants.mat'];                       
UserVar.SurfaceVelocityInterpolant=[UserVar.InputDir,'SurfVelMeasures990mInterpolants.mat'];
UserVar.MeshBoundaryCoordinatesFile=[UserVar.InputDir,'MeshBoundaryCoordinatesForAntarcticaBasedOnBedmachine.mat'];
UserVar.SurfaceMassBalanceInterpolant=[UserVar.InputDir,'surfaceMassBalanceForAntarcticaBasedOnRacmo.mat'];
UserVar.BasalMassBalanceInterpolant=[UserVar.InputDir,'Fab.2017.00.mat'];
UserVar.DistanceBetweenPointsAlongBoundary=20e3 ; 

CtrlVar.SlidingLaw="Weertman" ;

switch CtrlVar.SlidingLaw
    
    case "Weertman"
        UserVar.CFile=[UserVar.InputDir,'FC-Weertman.mat']; UserVar.AFile=[UserVar.InputDir,'FA-Weertman.mat'];
    case "Umbi"
        UserVar.CFile=[UserVar.InputDir,'FC-Umbi.mat']; UserVar.AFile=[UserVar.InputDir,'FA-Umbi.mat'];
    otherwise
        error('A and C fields not available')
end

%%

CtrlVar.Experiment=UserVar.RunType;

switch UserVar.RunType
    
    case {'Inverse-MatOpt'}
        
        CtrlVar.InverseRun=1;
        CtrlVar.Restart=1;
        
        CtrlVar.InfoLevelNonLinIt=0;
        CtrlVar.Inverse.InfoLevel=1;
        CtrlVar.InfoLevel=0;
        
        UserVar.Slipperiness.ReadFromFile=0;
        UserVar.AGlen.ReadFromFile=0;
        CtrlVar.ReadInitialMesh=1;
        CtrlVar.AdaptMesh=0;
        
        CtrlVar.Inverse.Iterations=300;
        CtrlVar.Inverse.InvertFor='logA-logC' ; % '-logAGlen-logC-' ; % {'-C-','-logC-','-AGlen-','-logAGlen-'}
        CtrlVar.Inverse.Regularize.Field=CtrlVar.Inverse.InvertFor;
        
        CtrlVar.Inverse.Measurements='-uv-' ;  % {'-uv-,'-uv-dhdt-','-dhdt-'}
        
        
    case 'Forward-Transient'
        
        CtrlVar.InverseRun=0;
        CtrlVar.TimeDependentRun=1;
        CtrlVar.InfoLevelNonLinIt=0;
        UserVar.Slipperiness.ReadFromFile=1;
        UserVar.AGlen.ReadFromFile=1;
        CtrlVar.AdaptMesh=1;
        CtrlVar.NameOfRestartFiletoWrite=[UserVar.RestartDir,'Restart-',CtrlVar.Experiment,'.mat'];
        CtrlVar.NameOfRestartFiletoRead=CtrlVar.NameOfRestartFiletoWrite;
        CtrlVar.TotalNumberOfForwardRunSteps=inf; %60 for 12 h
        CtrlVar.TotalTime=2018.00000000000;
        if '1979.00'==UserVar.StartOutputID;
            CtrlVar.Restart=1;
            CtrlVar.NameOfRestartFiletoRead=UserVar.InitialRestartFile;
	        CtrlVar.RestartTime=1979;
            CtrlVar.ResetTime=1;  
            CtrlVar.time=1979;
            CtrlVar.ResetTimeStep=0;
            CtrlVar.dt=0.1; 
            CtrlVar.ReadInitialMesh=0;  
        else
            CtrlVar.Restart=1;
            CtrlVar.ResetTime=0;   
            CtrlVar.ResetTimeStep=0;
            CtrlVar.ReadInitialMesh=0; 
            %CtrlVar.ResetTimeStep=1;
            %CtrlVar.dt=0.00001; 
            %CtrlVar.ATSdtMax=0.05;
        end

        
    case 'Forward-Diagnostic'
               
        CtrlVar.InverseRun=0;
        CtrlVar.TimeDependentRun=0;
        CtrlVar.Restart=0;
        CtrlVar.InfoLevelNonLinIt=1;
        UserVar.Slipperiness.ReadFromFile=1;
        UserVar.AGlen.ReadFromFile=1;
        CtrlVar.ReadInitialMesh=0;
        CtrlVar.AdaptMesh=0;
        
    case 'TestingMeshOptions'
        
        CtrlVar.TimeDependentRun=0;  % {0|1} if true (i.e. set to 1) then the run is a forward transient one, if not
        CtrlVar.InverseRun=0;
        CtrlVar.Restart=0;
        CtrlVar.ReadInitialMesh=1;
    
        UserVar.Slipperiness.ReadFromFile=1;
        UserVar.AGlen.ReadFromFile=1;
        CtrlVar.AdaptMesh=1;
        CtrlVar.AdaptMeshInitial=1 ;      
        CtrlVar.AdaptMeshRunStepInterval=1 ; 
        CtrlVar.AdaptMeshAndThenStop=1;    % if true, then mesh will be adapted but no further calculations performed
        % useful, for example, when trying out different remeshing options (then use CtrlVar.doAdaptMeshPlots=1 to get plots)
        CtrlVar.InfoLevelAdaptiveMeshing=10;
end

% time interval between calls to DefineOutputs.m
CtrlVar.DefineOutputsDt=-1; 
UserVar.AlwaysDoLastOutput=1;
UserVar.AlwaysDoFirstOutput=1;
% Element type
CtrlVar.TriNodes=3 ;


%%
CtrlVar.doplots=1;
CtrlVar.PlotMesh=1;  
CtrlVar.PlotBCs=0 ;
CtrlVar.PlotXYscale=1000;
CtrlVar.doAdaptMeshPlots=5; 
%%



CtrlVar.ReadInitialMeshFileName=[UserVar.InputDir,'MeshFile.mat'];
CtrlVar.SaveInitialMeshFileName=[UserVar.InputDir,'MeshFileAdaptIni.mat'];
CtrlVar.MaxNumberOfElements=300e3;

%% Meshing 

CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';
%CtrlVar.MeshRefinementMethod='explicit:local:red-green';
%CtrlVar.MeshRefinementMethod='explicit:global';   

%CtrlVar.MeshGenerator='gmsh' ; % 'mesh2d';
CtrlVar.MeshGenerator='mesh2d' ; % 'mesh2d';
%CtrlVar.GmshMeshingAlgorithm=8; 

CtrlVar.MeshSizeMax=200e3;
CtrlVar.MeshSize=CtrlVar.MeshSizeMax/2;
%CtrlVar.MeshSizeMin=CtrlVar.MeshSizeMax/50;
CtrlVar.MeshSizeMin=2000;
UserVar.MeshSizeIceShelves=20e3;

I=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='effective strain rates';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.0001;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=false;



MeshBoundaryCoordinates=CreateMeshBoundaryCoordinatesForAntarctica(UserVar,CtrlVar);
%load MeshBoundaryCoordinates.mat
%MeshBoundaryCoordinates=MeshBoundaryCoordinates;
                                         
CtrlVar.AdaptMeshInitial=1  ;   
CtrlVar.AdaptMeshMaxIterations=10;
CtrlVar.AdaptMeshRunStepInterval=2 ; % Run-step interval between mesh adaptation (zero value means this condition is always true)
CtrlVar.SaveAdaptMeshFileName=[UserVar.InputDir,'MeshFileAdapt.mat'];    %  file name for saving adapt mesh. If left empty, no file is written


CtrlVar.MeshAdapt.GLrange=[20000 10000; 10000 8000; 8000 6000; 6000 4000; 4000 3000; 3000 2000];
%CtrlVar.MeshAdapt.GLrange=[40000 10000; 11000 5000 ; 6000 2000];

%CtrlVar.MeshAdapt.GLrange=[2000 1000];
%CtrlVar.MeshAdapt.GLrange=[20000 5000 ; 5000 500; 1000 200];

%%
                                                        
%%  Bounds on C and AGlen
%CtrlVar.AGlenmin=1e-10; CtrlVar.AGlenmax=1e-5;

CtrlVar.Cmin=1e-20;  CtrlVar.Cmax=1e20;        

%CtrlVar.CisElementBased=0;   
%CtrlVar.AGlenisElementBased=0;   


%% Testing adjoint parameters, start:
CtrlVar.Inverse.TestAdjoint.isTrue=0; % If true then perform a brute force calculation 
                                      % of the directional derivative of the objective function.  
CtrlVar.Inverse.TestAdjointFiniteDifferenceType='second-order' ; % {'central','forward'}
CtrlVar.Inverse.TestAdjointFiniteDifferenceStepSize=1e-8 ;
CtrlVar.Inverse.TestAdjoint.iRange=[100,121] ;  % range of nodes/elements over which brute force gradient is to be calculated.
                                         % if left empty, values are calulated for every node/element within the mesh. 
                                         % If set to for example [1,10,45] values are calculated for these three
                                         % nodes/elements.
% end, testing adjoint parameters. 


if contains(UserVar.RunType,'MatOpt')
    CtrlVar.Inverse.MinimisationMethod='MatlabOptimization';
else
    CtrlVar.Inverse.MinimisationMethod='UaOptimization';
    if contains(UserVar.RunType,'ConjGrad')
        CtrlVar.Inverse.GradientUpgradeMethod='ConjGrad' ; %{'SteepestDecent','ConjGrad'}
    else
        CtrlVar.Inverse.GradientUpgradeMethod='SteepestDecent' ; %{'SteepestDecent','ConjGrad'}
    end
    
end

                                                    

%CtrlVar.Inverse.Regularize.C.gs=1;
%CtrlVar.Inverse.Regularize.C.ga=1;
CtrlVar.Inverse.Regularize.logC.ga=1;
CtrlVar.Inverse.Regularize.logC.gs=1e6 ;

%CtrlVar.Inverse.Regularize.logC.ga=0;  % testing for Budd
%CtrlVar.Inverse.Regularize.logC.gs=1e3 ; % testing for Budd

%CtrlVar.Inverse.Regularize.AGlen.gs=1;
%CtrlVar.Inverse.Regularize.AGlen.ga=1;
CtrlVar.Inverse.Regularize.logAGlen.ga=1;
CtrlVar.Inverse.Regularize.logAGlen.gs=1e6 ;


%%
CtrlVar.ThicknessConstraints=0;
CtrlVar.ResetThicknessToMinThickness=1;  % change this later on
CtrlVar.ThickMin=10;
CtrlVar.InfoLevelThickMin=1;

%% Filenames

CtrlVar.NameOfFileForSavingSlipperinessEstimate=UserVar.InputDir+"C-Estimate"+CtrlVar.SlidingLaw+".mat";
CtrlVar.NameOfFileForSavingAGlenEstimate=  UserVar.InputDir+"AGlen-Estimate"+CtrlVar.SlidingLaw+".mat";

meshNameSplit = strsplit(CtrlVar.ReadInitialMeshFileName,'/');

if CtrlVar.InverseRun
    CtrlVar.Experiment="Antarctic-Inverse-"...
        +meshNameSplit(end)...
        +CtrlVar.Inverse.InvertFor...
        +CtrlVar.Inverse.MinimisationMethod...
        +"-"+CtrlVar.Inverse.AdjointGradientPreMultiplier...
        +CtrlVar.Inverse.DataMisfit.GradientCalculation...
        +CtrlVar.Inverse.Hessian...
        +"-"+CtrlVar.SlidingLaw...
        +"-"+num2str(CtrlVar.DevelopmentVersion);
else
     CtrlVar.Experiment="Antarctic-Forward-"...
        +meshNameSplit(end);
end


filename=sprintf('IR-%s-%s-Nod%i-%s-%s-Cga%f-Cgs%f-Aga%f-Ags%f-m%i-%s',...
    UserVar.RunType,...
    CtrlVar.Inverse.MinimisationMethod,...
    CtrlVar.TriNodes,...
    CtrlVar.Inverse.AdjointGradientPreMultiplier,...
    CtrlVar.Inverse.DataMisfit.GradientCalculation,...
    CtrlVar.Inverse.Regularize.logC.ga,...
    CtrlVar.Inverse.Regularize.logC.gs,...
    CtrlVar.Inverse.Regularize.logAGlen.ga,...
    CtrlVar.Inverse.Regularize.logAGlen.gs,...
    UserVar.m,...
    CtrlVar.Inverse.InvertFor);

CtrlVar.Experiment=replace(CtrlVar.Experiment," ","-");
filename=replace(filename,'.','k');

CtrlVar.Inverse.NameOfRestartOutputFile=[UserVar.RestartDir,filename];
CtrlVar.Inverse.NameOfRestartInputFile=CtrlVar.Inverse.NameOfRestartOutputFile;

end
