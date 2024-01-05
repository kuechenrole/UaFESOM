pro plotbiniez,datain,lon,lat,plotkey,mindatin,maxdatin,legend,winnum

docolorbar=1
debug=0

if winnum lt 99 then begin 
 windows,winnum
endif else if winnum eq 99 then begin
 psonco
endif

if winnum le 99 then begin
 set_mapi,plotkey,plotkey,latmin,latmax,lonmin,lonmax,cellscale,1,1  
endif else begin
 lonmin=-180.
 lonmax=180.
 latmin=-90
 latmax=90.
endelse

colors=[10,20,30,40,50,60,70,80,90,95]
nlevels=10
levelarr=0.
usersym,[-0.5,.5,.5,-.5,-.5],[-.5,-.5,.5,.5,-.5],/fill
;usersym,[-1.,1.,1.,-1.,-1.],[-1.,-1.,1.,1.,-1.],/fill

plotdata=datain
mindat=mindatin
maxdat=maxdatin

if (mindat eq 0 and maxdat eq 0) then begin
 mindat=min(plotdata)
 maxdat=max(plotdata)
 maxdat=maxdat+(maxdat-mindat)/100.
endif
if max(plotdata) gt maxdat then plotdata(where(plotdata gt maxdat))=maxdat
if min(plotdata) lt mindat then plotdata(where(plotdata lt mindat))=mindat

sc=100./(maxdat-mindat)  		;calculate scaling for color
ft=-1.*mindat*sc+1.		  	;calculate shift for color
plotdats=sc*plotdata+ft

plotindices=(where(lat ge latmin and lat le latmax and plotdata gt mindat))

if debug then begin
print,'plotbin',mindat,maxdat,latmin,latmax
 window,4
 plot,lon,color=103
 window,5
 plot,lat,color=103
 help,plotindices
 window,3
 plot,plotindices,color=103
 window,6
 plot,plotdats,color=103
endif

plotdatr=reform(plotdats(plotindices))
latr    =reform(lat(plotindices))
lonr    =reform(lon(plotindices))

if debug then begin
 window,7
 plot,lonr,color=103

 window,8
 plot,latr,color=103

 window,9
 plot,plotdatr,color=103

 window,10
 plot,plotdatr
endif

plots,lonr,latr,psym=8,color=plotdatr
;plots,lonr,latr,psym=3,color=plotdatr

;map_continents,mlinethick=2,color=103

checkGL=0
if checkGL then begin
 anzgl=749475
 gl=fltarr(2,anzgl)
 openr,1,'/csys/tph2/rtimmerm/ice2sea/grounding_line/antarctica_gl.dat'
 readf,1,gl
 close,1
 longl=reform(gl(0,*))
 latgl=reform(gl(1,*))
 plots,longl,latgl,color=105,psym=3,symsize=0.2
endif

;print,'DIRTY: removed map_nicegrid from plotbiniez.pro'
map_nicegrid,plotkey,15,0

leveling=0
;print,'do colorbar with colors ',colors
if winnum ne 99 and docolorbar eq 1 then begin
 colorbar,80,30,450,10,mindat,maxdat,leveling,nlevels,levelarr,colors
endif else begin
 if docolorbar eq 1 or docolorbar eq 2 then begin
  colorbarn,0.1,0.05,0.8,0.02,mindat,maxdat,leveling,nlevels,levelarr,colors
 endif
endelse

if docolorbar lt 2 then dolegend,legend,plotkey,103

if winnum eq 99 then psoff

return
end
