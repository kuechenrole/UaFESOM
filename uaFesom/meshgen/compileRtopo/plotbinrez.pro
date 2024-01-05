pro plotbinrez,datain,loninin,latin,plotkey,mindatin,maxdatin,legend,winnum

docolorbar=1
leveling=0  ;  1 takes longer
cut = 0


if winnum eq 99 then begin
 psonco,plotkey,'plotbinrez'
 set_mapi,plotkey,plotkey,latmin,latmax,lonmin,lonmax,cellscale,1,1  
 cut=1
endif else if winnum le 30 then begin
 windows,winnum
 set_mapi,plotkey,plotkey,latmin,latmax,lonmin,lonmax,cellscale,1,1   
 cut=1
endif else begin
 set_mapi,plotkey,plotkey,latmin,latmax,lonmin,lonmax,cellscale,1,1   
endelse




colors=[10,20,30,40,50,60,70,80,90,95]
nlevels=11
levelarr=0

;colors=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
;nlevels=13
;levelarr=0

lonin=loninin
;lonin(where(lonin gt 180.))=lonin(where(lonin gt 180.))-360.



anzlon=n_elements(lonin)
anzlat=n_elements(latin)
ii=0
ie=anzlon-1
ji=0
je=anzlat-1
je=min([2400,anzlat-1])


if cut then begin
 for i=0l,anzlon-2 do begin
  if lonin(i) le lonmin and lonin(i+1) gt lonmin then ii=i
  if lonin(i) le lonmax and lonin(i+1) gt lonmax then begin
   ie=i
   i=anzlon
  endif
 endfor
 for j=0l,anzlat-2 do begin
  if latin(j) le latmin and latin(j+1) gt latmin then ji=j
  if latin(j) le latmax and latin(j+1) gt latmax then begin
   je=j
   j=anzlat
  endif
 endfor
endif


;print,'plot data in the interval',lonmin,lonmax,latmin,latmax
;print,'plot data between indices',ii,ie,ji,je

plotdata=datain(ii:ie,ji:je)
lon     =lonin (ii:ie)
lat     =latin (ji:je)
maxdat=maxdatin
mindat=mindatin
mindatd=min(plotdata)
maxdatd=max(plotdata)

if (mindatin eq 0 and maxdatin eq 0) then begin
 mindat=mindatd
 maxdat=maxdatd+(maxdatd-mindatd)/100.
endif

;help,levelarr

if countpoints(levelarr) eq 1 then begin
 if levelarr eq 0 then begin
  levelarr=findgen(nlevels)*(maxdat-mindat)/float(nlevels-1)+mindat
 endif
endif

;help,levelarr
;print,levelarr

if max(plotdata) gt maxdatin then plotdata(where(plotdata gt maxdat))=maxdat
if min(plotdata) lt mindatin then plotdata(where(plotdata lt mindat))=mindat

;print,'plot ',legend,'. Data range:',mindatd,' to ',maxdatd,$
;                     ', plot range:', mindat,' to ',maxdat


sc=100./(maxdat-mindat)  		;calculate scaling for color
ft=-1*mindat*sc+1		  	;calculate shift for color
plotdats=sc*plotdata+ft

;plotindices=(where(lat ge latmin and lat le latmax and plotdata gt mindat))


debug=0

if debug then begin
 window,4
 plot,lon,color=103
 window,5
 plot,lat,color=103
 help,plotindices
; window,6
; plot,plotindices,color=103
 window,7
 plot,plotdats,color=103
 window,8
 plot,plotdats(plotindices),color=103
endif


if leveling then begin
 for i=0,n_elements(lon)-1 do begin
  for j=0,n_elements(lat)-1 do begin
   for ilevel=0,nlevels-2 do begin
    if plotdata(i,j) ge levelarr(ilevel) and plotdata(i,j) le levelarr(ilevel+1) $
     then begin
     if cellscale eq 1 then begin
      plots,lon(i),lat(j),psym=3,color=colors(ilevel)
     endif else begin   
      plots,lon(i),lat(j),psym=2,color=colors(ilevel),symsize=cellscale
     endelse
    endif
   endfor
  endfor
 endfor
endif else begin
 for j=0,n_elements(lat)-1 do begin
  if cellscale eq 1 then begin
   plots,lon(*),lat(j),psym=3,color=plotdats(*,j)
  endif else begin   
   plots,lon(*),lat(j),psym=2,color=plotdats(*,j),symsize=cellscale
  endelse
 endfor
endelse


;map_continents,mlinethick=2,color=103; ,/hires


;print,'dirty: removed calling map_nicegrid from plotbinrez.pro'
;map_nicegrid,plotkey,15,0

;map_nicegrid,plotkey,1,1      ; RTopo-1 coastline
;map_nicegrid,plotkey,20,1     ;RTopo-2 coastline
map_nicegrid,plotkey,20,0



if docolorbar ge 1 then begin
 if debug then print,'do colorbar with colors ',colors
 if winnum ne 99 then begin
  colorbar,80,30,450,10,mindat,maxdat,leveling,nlevels,levelarr,colors
 endif else begin
  colorbarn,0.1,0.05,0.8,0.02,mindat,maxdat,leveling,nlevels,levelarr,colors
 endelse
endif

;if docolorbar lt 2 then dolegend,legend,plotkey,0
if docolorbar lt 2 then dolegend,legend,plotkey,103



if winnum eq 99 then psoff

return
end
