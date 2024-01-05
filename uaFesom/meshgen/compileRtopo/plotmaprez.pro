pro plotmaprez,datain,lonin,latin,plotkey,mindatin,maxdatin,legend,winnum

;a few flags to direct the beast
docolorbar=1
debug=0

if winnum ne 99 then begin 
 windows,winnum
endif else begin
 psonco,plotkey,'plotmaprez'
; psoncol
; psonco_a3
endelse
set_mapi,plotkey,plotkey,latmin,latmax,lonmin,lonmax,cellscale,1,1  

;this is good for full range color tables:
;colors=[10,20,30,40,50,60,70,80,90,95]
;nlevels=11

nlevels=13
nlevels=11
colors=indgen(nlevels-1)*100/(nlevels-1)+5
print,'automatic colors ',colors



levelarr=0.

;this is good for BRIOS color table:
;colors=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
;nlevels=13

if countpoints(levelarr) eq 1 then begin
 if levelarr eq 0 then begin
  levelarr=findgen(nlevels)*(maxdatin-mindatin)/float(nlevels-1)+mindatin
 endif
endif
plotdata = datain
lon      = lonin
lat      = latin
maxdat   = maxdatin
mindat   = mindatin
if (mindat eq 0 and maxdat eq 0) then begin
 mindat=min(plotdata)
 maxdat=max(plotdata)
 maxdat=maxdat+(maxdat-mindat)/100.
endif

print,levelarr

;fitminmaxtoscale (comment if not desired)
if min(plotdata) lt mindat then plotdata(where(plotdata lt mindat))=mindat
if max(plotdata) gt maxdat then plotdata(where(plotdata gt maxdat))=maxdat-(maxdat-mindat)/1000.

print,'plot ',legend,' from ',mindat,' to ',maxdat

;sc=100./(maxdat-mindat)  		;calculate scaling for color
;ft=-1*mindat*sc+1		  	;calculate shift for color
;plotdats=sc*plotdata+ft

anzlon=n_elements(lon)
anzlat=n_elements(lat)


if debug then begin
 window,4
 plot,lon,color=103
 window,5
 plot,lat,color=103
 window,6
 plot,plotdata,color=103
endif


map_cutoff_r,plotdata,lon,lat,plotkey


contour,plotdata,lon,lat,/overplot,min_value=mindat,max_value=maxdat,$
 c_colors=colors,nlevels=nlevels,levels=levelarr,/cell_fill
contour,plotdata,lon,lat,/overplot,min_value=mindat,max_value=maxdat,$
 nlevels=nlevels,levels=levelarr,color=103,c_labels=[0,1,1,1,1,1,1,1,1,1,1,1]


;map_nicegrid,plotkey,15,0
map_nicegrid,plotkey,20,0

leveling=1
if docolorbar ge 1 then begin
 if debug then print,'do colorbar with colors ',colors
 if winnum ne 99 then begin
  colorbar,80,30,450,10,mindat,maxdat,leveling,nlevels,levelarr,colors
 endif else begin
  colorbarn,0.1,0.05,0.8,0.02,mindat,maxdat,leveling,nlevels,levelarr,colors
 endelse
; if docolorbar lt 2 then begin
;  if debug then print,'do legend with ',n_elements(legend),' elements'
;  for il=0,n_elements(legend)-1 do begin
;   print,legend(il)
;   xyouts,0.1,0.935-float(il)/20.,legend(il),/normal,color=103,charsize=1.2
;  endfor
; endif
 if docolorbar lt 2 then dolegend,legend,plotkey,103
endif

if winnum eq 99 then psoff

return
end
