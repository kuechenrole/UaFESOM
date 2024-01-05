FolderName = tempdir;   % Your destination folder
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for iFig = 1:length(FigList)
  FigHandle = FigList(iFig);
  FigName   = num2str(get(FigHandle, 'Number'));
  set(0, 'CurrentFigure', FigHandle);
  savefig(fullfile(FolderName, [FigName '.fig']));
end


[figures, pathname,]=uigetfile('/work/ollie/orichter/Misomip2/io0006/reports/uanonlin/','*.fig','Multiselect','on');
for x = 1:length(figures)
    Multi_Figs = [pathname,filesep,figures{x}];
    Op = openfig(Multi_Figs);
end