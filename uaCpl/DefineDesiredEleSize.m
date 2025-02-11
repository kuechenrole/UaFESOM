function     [UserVar,EleSizeDesired,ElementsToBeRefined,ElementsToBeCoarsened]=...
    DefineDesiredEleSize(UserVar,CtrlVar,MUA,x,y,EleSizeDesired,ElementsToBeRefined,ElementsToBeCoarsened,s,b,S,B,rho,rhow,ub,vb,ud,vd,GF,NodalErrorIndicators)

%%
% Define desired sizes of elements or specify which elements to refine or
% coarsen.
%
%   [UserVar,EleSizeDesired,ElementsToBeRefined,ElementsToBeCoarsened]=...
%            DefineDesiredEleSize(UserVar,CtrlVar,MUA,x,y,EleSizeDesired,ElementsToBeRefined,ElementsToBeCoarsened,s,b,S,B,rho,rhow,ub,vb,ud,vd,GF,NodalErrorIndicators)
%
% Only used in combination with adaptive meshing.
%
% Allows user to set:
%
% 
% * EleSizeDesired when using global mesh refinement
% * ElementsToBeRefined when using local mesh refinement with either the red-green or the newest vertex bisection
% * ElementsToBeRefined and ElementsToBeCoarsened when using local mesh refinement with the the newest vertex bisection
% 
%
% On input EleSize are desired ele sizes at (x,y) as
% calculated by ?a based on some user-defined criteria.
%
% On output EleSize are user-modified values.
%
% Do not modify the size of the (nodal) vector `EleSizeDesired' or the logical (element)
% vector 'ElementsToBeRefine', only the values.
%
% When using the gobal remeshing option x,y are the locations where new element sizes are specifed (these are the coordinates of the mesh)
% 
% Note: When using the local remeshing option, x and y as given on input are not relevant. 
%       In this case use MUA.xEle and MUA.yEle as the x, y locations where the elements are to be refined or coarsened. 
%
% ElementsToBeRefined can either be a logical array in which case values set to true/1 indicate elements
% to be refined, or a list of numbers of elements to be refined.
%
% Note that this m-file is only called if the adaptive meshing option is used.
% Also, that elements will only be refined/coarsened if local mesh refinement is
% used. These options must be set accordingly in Ua2D_InitialUserInput.
%
% 
% *Example:* To set desired ele sized to 1000 within a given boundary (this boundary
% must of course be within the overall boundary of the computational
% domain):
%
%   Boundary=[0        0 ; ...
%           10e3      0 ; ...
%           10e3      10e3;
%           0       10e3];
% 
%   I=inpoly([x y],Boundary) ;
%   EleSizeDesired(I)=1000; 
%
% Here Boundary doese not have to be just a simple square, it can be a polygon of any shape.   
%
% *Example:* To set all ele size of all floating elements (i.e. ice shelves)
% to 1000:
%
%   EleSizeDesired(GF.Node<0.5)=1000;
%
%
%
%%


switch lower(CtrlVar.MeshRefinementMethod)
    
    case 'explicit:global' 
        
        % when using global mesh refinement, return EleSizeIndicator
        % defined at nodes
        %{
        fprintf('Defining desired Element size according to surface velocity data: %-s ',UserVar.SurfaceVelocityInterpolant)
        load(UserVar.SurfaceVelocityInterpolant,'FuMeas','FvMeas','FerrMeas');
        Meas.us=double(FuMeas(MUA.coordinates(:,1),MUA.coordinates(:,2)));
        Meas.vs=double(FvMeas(MUA.coordinates(:,1),MUA.coordinates(:,2)));
        MissingData=isnan(Meas.us) | isnan(Meas.vs);
        %Meas.us(MissingData)=0.1 ;  Meas.vs(MissingData)=0.1;
        MeasuredSpeed=sqrt(Meas.us.*Meas.us+Meas.vs.*Meas.vs);
        F = scatteredInterpolant(MUA.coordinates(~MissingData,1),MUA.coordinates(~MissingData,2),MeasuredSpeed(~MissingData),'linear','nearest');
        MeasuredSpeed=F(MUA.coordinates(:,1),MUA.coordinates(:,2));
        speedRatio = (max(MeasuredSpeed)-MeasuredSpeed)./(max(MeasuredSpeed)-min(MeasuredSpeed));
        
        EleSizeDesired=CtrlVar.MeshSizeMin+(CtrlVar.MeshSizeMax-CtrlVar.MeshSizeMin).*(speedRatio.^100);
     
        %}
        EleSizeIndicator=EleSizeDesired;
        EleSizeIndicator(GF.node<0.1)=UserVar.MeshSizeIceShelves;
        EleSizeDesired=max(EleSizeDesired,EleSizeIndicator);
        
        %EleSizeIndicator(s<1500)=CtrlVar.MeshSizeMax/5;
        %EleSizeDesired=min(EleSizeDesired,EleSizeIndicator);
        
        %xmin=-1727e3   ; xmax=-1100e3 ; ymin=-600e3 ; ymax=-20.e3;
        %ind=x< xmax & x>xmin & y>ymin & y< ymax ;
        %EleSizeDesired(~ind)=CtrlVar.MeshSizeMax;
        
    case {'explicit:local:newest vertex bisection','explicit:local:red-green'}
        
        % When using local mesh refinement, return ElementsToBeRefined and ElementsToBeCoarsened defined over elements
        %
        % ElementsToBeCoarsened is only used in combination with the 'newest vertex bisection' local mesh-refinement method 
        %
        %xmin=-1727e3   ; xmax=-1100e3 ; ymin=-600e3 ; ymax=-20.e3;
        %ind=MUA.xEle < xmax & MUA.xEle > xmin & MUA.yEle >ymin & MUA.yEle < ymax ;
      
        %ElementsToBeRefined(~ind)=false; 
        %ElementsToBeRefined(:)=false; 
        
        %NodeListLogical = GF.node<0.1;
        %IEle=MuaElementsContainingGivenNodes(CtrlVar,MUA,find(NodeListLogical)) ;
        %ElementsToBeRefined(IEle)=true;

        
    otherwise
        
        error('case not found')

end

end
