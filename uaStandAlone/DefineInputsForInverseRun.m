function [UserVar,InvStartValues,Priors,Meas,BCsAdjoint,RunInfo]=...
    DefineInputsForInverseRun(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,Priors,Meas,BCsAdjoint,RunInfo)

%%
% *Note: This m-file is just an example of how to define inputs for an inverse run. You will need to modify to fit your own problem.*
%
% What you need to define are:
%
%
% # Measurments and data errors (data errors are specified as diagonal covariance matrices.)
% # Start values for inversion. (These are some values for the model parameters that you want to invert for.)
% # Priors for the inverted fields. (Currently the only priors that are used the the priors for C and AGlen.)
%
%
%%



persistent FuMeas FvMeas FerrMeas  % keep scattered interpolants for the data in memory.


%% get measurments and define error covariance matrices
if isempty(FuMeas)
    
    fprintf('Loading interpolants for surface velocity data: %-s ',UserVar.SurfaceVelocityInterpolant)
    load(UserVar.SurfaceVelocityInterpolant,'FuMeas','FvMeas','FerrMeas')
    fprintf(' done.\n')
end

% Now interpolate the data onto the nodes of the mesh
Meas.us=double(FuMeas(MUA.coordinates(:,1),MUA.coordinates(:,2)));
Meas.vs=double(FvMeas(MUA.coordinates(:,1),MUA.coordinates(:,2)));
Err=double(FerrMeas(MUA.coordinates(:,1),MUA.coordinates(:,2)));

% Here I set any NaN values to 0. The assumption here is that these NaN values represent missing data and I set these values to 0. This
% may, or may not, be a good idea. But the important thing is to set the errors where data is missing to some really high value. Here I
% set the errors to 1e10.
MissingData=isnan(Meas.us) | isnan(Meas.vs) | isnan(Err) | (Err==0);
Meas.us(MissingData)=0 ;  Meas.vs(MissingData)=0 ; Err(MissingData)=1e10; 

% The data errors as specified by these covariance matrices. 
% The data errors are assumed to be uncorrelated, hence we are here using diagonal covariance matrices.
usError=Err ; vsError=Err ; 
Meas.usCov=sparse(1:MUA.Nnodes,1:MUA.Nnodes,usError.^2,MUA.Nnodes,MUA.Nnodes);
Meas.vsCov=sparse(1:MUA.Nnodes,1:MUA.Nnodes,vsError.^2,MUA.Nnodes,MUA.Nnodes);



%% Define Priors

Priors.AGlen=AGlenVersusTemp(-10);
Priors.n=F.n; 


switch CtrlVar.SlidingLaw
    
    case {"Weertman","Tsai","Cornford","Umbi"}
        
        % u=C tau^m
        
        tau=100 ; % units meters, year , kPa
        MeasuredSpeed=sqrt(Meas.us.*Meas.us+Meas.vs.*Meas.vs);
        Priors.m=F.m;
        C0=(MeasuredSpeed+1)./(tau.^Priors.m);
        Priors.C=C0;
        
        
    case {"Budd","W-N0"}

        % u=C tau^m / N^q
        hf=F.rhow.*(F.S-F.B)./F.rho;
        hf(hf<eps)=0;
        Dh=(F.s-F.b)-hf; Dh(Dh<eps)=0;
        N=F.rho.*F.g.*Dh;
        
        MeasuredSpeed=sqrt(Meas.us.*Meas.us+Meas.vs.*Meas.vs);
        tau=100+zeros(MUA.Nnodes,1) ; 
        C0=N.^F.q.*MeasuredSpeed./(tau.^F.m);
        Priors.C=C0 ; 
        Priors.m=F.m ; 
        
    otherwise
        
        error("Ua:DefineInputsForInverseRund:CaseNotFound","Sliding law prior for this sliding law not implemented")
end


%% Define Start Values
% This is only used at the very start of the inversion. (In an inverse restart run the initial value is always the last values from
% previous run.)
InvStartValues.C=Priors.C ;
InvStartValues.m=F.m ;
InvStartValues.q=F.q;
InvStartValues.muk=F.muk ;
InvStartValues.AGlen=Priors.AGlen;
InvStartValues.n=F.n ;

% OK, here I'm allowing for the initial A and C to be read from a file, overwriting the previous values
% The A and C estimates in these file could, for example, have been obtained from a previous inversion.
%
if UserVar.Slipperiness.ReadFromFile
    
    fprintf('DefineInputsForInverseRun: loading start values for C from the file: %-s ',UserVar.CFile)
    load(UserVar.CFile,'FC')
    fprintf(' done \n')
    InvStartValues.C=FC(F.x,F.y) ;
    % make sure that interpolation/extrapolation does not violate parameter value constraints
    InvStartValues.C=kk_proj(InvStartValues.C,CtrlVar.Cmax,CtrlVar.Cmin) ;
end

if UserVar.AGlen.ReadFromFile
    fprintf('DefineSlipperyDistribution: loading file: %-s ',UserVar.AFile)
    load(UserVar.AFile,'FA')
    fprintf(' done \n')
    InvStartValues.AGlen=FA(F.x,F.y);
    % make sure that interpolation/extrapolation does not violate parameter value constraints
    InvStartValues.AGlen=kk_proj(InvStartValues.AGlen,CtrlVar.AGlenmax,CtrlVar.AGlenmin) ;
end


    
    
    
end
