function UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)

%% inverse run outputs
if CtrlVar.InverseRun && strcmp(CtrlVar.DefineOutputsInfostring,'End of Inverse Run')==1
    
    %InvFileName=sprintf('./AGlenSlipperinessFiles/AGlen-C-%s.mat',CtrlVar.Inverse.NameOfRestartOutputFile(19:end-4));
    InvFileName=UserVar.OutputDir+"AGlen-C"+CtrlVar.SlidingLaw+".mat";
    
    xI=MUA.coordinates(:,1);
    yI=MUA.coordinates(:,2);
    
    AGlen=F.AGlen;
    C=F.C;
    
    m=F.m;
    n=F.n;
    muk=F.muk;
    q=F.q;
    
    fprintf(' Saving A and C fields in %s \n',InvFileName)
    save(InvFileName,'xI','yI','AGlen','C','m','n','muk','q');
    
%% forward transient run outputs    
elseif CtrlVar.TimeDependentRun
    
    if exist(fullfile(cd,UserVar.OutputDir),'dir')~=7
        mkdir(UserVar.OutputDir) ;
    end
    
    TT=CtrlVar.TotalTime./CtrlVar.DefineOutputsDt;
    
    if ~isfield(UserVar,'VAF')
        UserVar.GA = zeros(TT,1);
        UserVar.IV = zeros(TT,1);
        UserVar.VAF = zeros(TT,1);
        UserVar.tsav = zeros(TT,1);
        UserVar.SLE = zeros(TT,1);
        UserVar.GLFlux = zeros(TT,1);
        UserVar.BMB = zeros(TT,1);
        UserVar.SMB = zeros(TT,1);
    end
    
    if strcmp(CtrlVar.DefineOutputsInfostring,'Last call')==0
        
        %%% save below variables annually
        II = CtrlVar.DefineOutputsCounter;
        UserVar.tsav(II) = CtrlVar.time;
        A=TriAreaTotalFE(MUA.coordinates,MUA.connectivity);
        [VAF,IceVolume,GroundedArea,hAF,hfPos]=CalcVAF(CtrlVar,MUA,F.h,F.B,F.S,F.rho,F.rhow,GF);
        GF=IceSheetIceShelves(CtrlVar,MUA,GF);
        FloatingArea=sum(FEintegrate2D(CtrlVar,MUA,GF.NodesDownstreamOfGroundingLines));
        
        UserVar.GA(II) = GroundedArea.Total./1e6'; %km2
        UserVar.IV(II) = IceVolume.Total./1e9'; %km3
        UserVar.VAF(II) = VAF.Total./1e9; %km3
        %UserVar.SLE(II) = SLE; % m SLE
        UserVar.IceExtent(II)=A./1e6; %total ice extent in km2
        UserVar.IceShelfExtent(II)=FloatingArea./1e6; %total extent of floating ice in km2
        
        qGL=FluxAcrossGroundingLine(CtrlVar,MUA,GF,F.ub,F.vb,F.ud,F.vd,F.h,F.rho);
        UserVar.GLFlux(II)=sum(qGL)./1e12; %Gt
        
        UserVar.SMB(II)=sum(FEintegrate2D(CtrlVar,MUA,F.as.*F.rho))./1e12; %total SMB in Gt
        UserVar.BMB(II)=sum(FEintegrate2D(CtrlVar,MUA,F.ab.*F.rho))./1e12; %total BMB in Gt
      
        YearsSinceStart = sprintf('%05.0f',CtrlVar.time.*10);
                
        FileName=sprintf('%s/%s-FW-%s.mat',...
            UserVar.OutputDir,...
            YearsSinceStart,...
            CtrlVar.Experiment);
        
        fprintf(' Saving data in %s \n',FileName)
        if CtrlVar.AdaptMesh
            save(FileName,'UserVar','CtrlVar','MUA','F','GF')
        else
            save(FileName,'UserVar','CtrlVar','F','GF')
        end
        
    end
    
end
