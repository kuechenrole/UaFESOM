MUAold = load('/albedo/work/projects/oce_rio/orichter/uacpl/results/io0035/1998.00-Nodes129974-Ele255355-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat','MUA');
Fold = load('/albedo/work/projects/oce_rio/orichter/uacpl/results/io0035/1998.00-Nodes129974-Ele255355-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat','F');
MUAnew = load('/albedo/work/projects/oce_rio/orichter/uacpl/results/io0035/2018.00-Nodes129943-Ele255292-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat','MUA');
Fnew = load('/albedo/work/projects/oce_rio/orichter/uacpl/results/io0035/2018.00-Nodes129943-Ele255292-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat','F');
load('/albedo/work/projects/oce_rio/orichter/uacpl/results/io0035/2018.00-Nodes129943-Ele255292-Tri3-kH1000-Antarctic-Forward-MeshFile.mat.mat','CtrlVar','RunInfo');

[RunInfo,hnew] = MapNodalVariablesFromMesh1ToMesh2UsingScatteredInterpolant(CtrlVar,RunInfo,MUAold.MUA,MUAnew.MUA,NaN,Fold.F.h);

PlotMeshScalarVariable(CtrlVar,MUAnew.MUA,Fnew.F.h-hnew);
caxis([-1 1]);