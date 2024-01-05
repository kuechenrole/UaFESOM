function  [UserVar,BCs]=DefineBoundaryConditions(UserVar,CtrlVar,MUA,BCs,time,s,b,h,S,B,ub,vb,ud,vd,GF)


BCs.vbFixedNode=[];
BCs.ubFixedNode=[];

% [BCs.ubFixedValue,BCs.vbFixedValue]=EricVelocities(CtrlVar,[x(Boundary.Nodes(I)) y(Boundary.Nodes(I))]);

BCs.ubFixedValue=[];
BCs.vbFixedValue=[];
%

%
%FindOrCreateFigure("BCs") ; PlotBoundaryConditions(CtrlVar,MUA,BCs);

end