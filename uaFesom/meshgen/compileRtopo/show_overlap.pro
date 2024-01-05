

pro show_overlap,data1,data2,flag,vis

flag=data1*0.

indices=where(data1 ne 0 and data2 eq 0)
if countpoints(indices) gt 0 then flag(indices)=2.

indices=where(data1 eq 0 and data2 ne 0)
if countpoints(indices) gt 0 then flag(indices)=8.

indices=where(data1 ne 0 and data2 ne 0)
if countpoints(indices) gt 0 then flag(indices)=10.

if vis then begin
plotitez,flag(*,0:1750),0,11,'nix: dunkelblau   nur data1: blau      nur data2: rot     beides: gelb',0


;windows,0
;plotit,flag,0,11,0,'nix: dunkelblau   nur data1: blau      nur data2: rot     beides: gelb'


;plotit,flag,0,0,0,'nur data1: blau -- nur data2: rot -- beides: gelb'
endif


end
