pro rtopo2_coastline,plotkey,fill_continents

;print,sollbruchstelle

print,'in rtopo2_coastline'
if plotkey eq 'ss' then begin
 extract=5
endif else begin
 extract=1
endelse

get_map_coordinates,plotkey,latmin,latmax,lonmin,lonmax,cellscale

indir='/isibhv/projects/oce_rio/rtimmerm/RTopo-2/compile_rtopo2_JRJRJR/'

if fill_continents gt 0 then begin
 print,'fill_continents=',fill_continents
 res=120
 anzxrg=360l*res+1
 anzyrg=180l*res+1 
 mask=bytarr(anzxrg,anzyrg)
 xrg=findgen(anzxrg)/res-180.
 yrg=findgen(anzyrg)/res-90.
 openr,1,indir+'mergedamask14.bin',/swap_if_big_endian 
 readu,1,mask
 close,1


 bigplots=1
 usersym,[-0.5,.5,.5,-.5,-.5],[-.5,-.5,.5,.5,-.5],/fill

 if plotkey eq 'as' or plotkey eq 'pig'  then begin 
  bigsym = 1
 endif else if plotkey eq 'pigbig' or plotkey eq 'Amerybig' then begin
  usersym,[-0.5,.5,.5,-.5,-.5],[-.9,-.9,.9,.9,-.9],/fill
  bigsym = 2
 endif else begin
  bigsym= 0
 endelse

 if bigplots then begin
  steplat=fix((latmax-latmin)/22.)   ; for big plots
  steplon=fix((lonmax-lonmin)/35.)   ; for big plots
 endif else begin
  steplat=fix((latmax-latmin)/10.)   ; for small plots
  steplon=fix((lonmax-lonmin)/17.)   ; for small plots
 endelse

 steplat=max([steplat,1])
 steplon=max([steplon,1])
; steplat=1
; steplon=2
; print,'steplat / steplon dirty!'
 help,steplat
 help,steplon
 help,bigsym
 help,latmin
 help,latmax
 help,lonmin
 help,lonmax
 if fill_continents eq 1 then begin
  for j=(latmin+90)*res,(latmax+90)*res,steplat do begin
   for i=(lonmin+180)*res,(lonmax+180)*res,steplon do begin
    if mask(i,j) eq 1 or mask(i,j) eq 3 then begin
;     if bigsym gt 0 then begin
     if bigsym eq 1 then begin
      plots,xrg(i),yrg(j),psym=6,color=102,symsize=0.3*float(bigsym)   ; for small scale maps
     endif else if bigsym eq 2 then begin
      plots,xrg(i),yrg(j),psym=8,color=102,symsize=0.3*float(bigsym)
     endif else begin
      plots,xrg(i),yrg(j),psym=3,color=102
     endelse
    endif
   endfor
  endfor
 endif

 if fill_continents eq 2 then begin
  for j=(latmin+90)*res,(latmax+90)*res,steplat do begin
   for i=(lonmin+180)*res,(lonmax+180)*res,steplon do begin
    if mask(i,j) eq 1 or mask(i,j) eq 3 then begin
     plots,xrg(i),yrg(j),psym=3,color=102
    endif
    if mask(i,j) eq 2 then begin
     plots,xrg(i),yrg(j),psym=3,color=104
    endif
   endfor
  endfor
 endif

;neu

 if fill_continents eq 3 then begin
  for j=(latmin+90)*res,(latmax+90)*res,steplat do begin
   for ii=(lonmin+180)*res,(lonmax+180)*res,steplon do begin
    if ii gt anzxrg then begin
     i=ii-anzxrg
    endif else begin
     i=ii
    endelse
    if mask(i,j) eq 0 or mask(i,j) eq 1 or mask(i,j) eq 3 then begin
     if bigsym gt 0 then begin
;      plots,xrg(i),yrg(j),psym=6,color=102,symsize=0.3*float(bigsym)   ; for small scale maps
      plots,xrg(i),yrg(j),psym=8,color=102,symsize=0.3*float(bigsym)
     endif else begin
      plots,xrg(i),yrg(j),psym=3,color=102
     endelse
    endif
   endfor
  endfor
 endif

endif

coastcol=103
glcol=105
isfcol= 103; 19; 104; 105  ; 88  ; 104
gilcol=80

if 1 then begin
 print,'plot coastline from RTOPO-2.0.1'
 anzgl=0l
 openr,1,indir+'RTopo-2.0.1_coast_2016-09-29.asc'
; readf,1,anzgl
 anzgl=1913892l
 gl=fltarr(2,anzgl)
 readf,1,gl
 close,1
 if lonmax gt 180. then begin
  print,'add 360 to lon < 0'
  indices=where(gl(0,*) lt 0.)
  gl(0,indices)=gl(0,indices)+360.
 endif
 indices=where(gl(0,*) gt lonmin and gl(0,*) lt lonmax $
           and gl(1,*) gt latmin and gl(1,*) lt latmax)
 longl=reform(gl(0,indices))
 latgl=reform(gl(1,indices))
 if extract gt 1 then begin
  print,'rt_coastline extract',extract
  plots,e1d(longl,extract),e1d(latgl,extract),color=coastcol,psym=3,symsize=0.2
 endif else begin
  plots,longl,latgl,color=coastcol,psym=3,symsize=0.4
;  plots,longl,latgl,color=coastcol,psym=6,symsize=0.15
 endelse
endif 


if 0 then begin
 print,'plot grounding line from RTOPO-2.0.1'
 anzgl=0l
 openr,1,indir+'RTopo-2.0.1_gl_2016-09-29.asc'
; readf,1,anzgl
 anzgl=146203l
 gl=fltarr(2,anzgl)
 readf,1,gl
 close,1
 indices=where(gl(0,*) gt lonmin and gl(0,*) lt lonmax $
           and gl(1,*) gt latmin and gl(1,*) lt latmax)
 longl=reform(gl(0,indices))
 latgl=reform(gl(1,indices))
 if extract gt 1 then begin
  plots,e1d(longl,extract),e1d(latgl,extract),color=glcol,psym=3,symsize=0.2
 endif else begin
  plots,longl,latgl,color=glcol,psym=3,symsize=0.8  ; 0.4
 endelse
endif

if 1 then begin
 print,'plot ice shelf front from RTopo-2.0.1;  isfcol=',isfcol
 anzgl=0l
 openr,1,indir+'RTopo-2.0.1_isf_2016-09-29.asc'
; readf,1,anzgl
 anzgl='52506'
 gl=fltarr(2,anzgl)
 readf,1,gl
 close,1
 indices=where(gl(0,*) gt lonmin and gl(0,*) lt lonmax $
           and gl(1,*) gt latmin and gl(1,*) lt latmax)
 longl=reform(gl(0,indices))
 latgl=reform(gl(1,indices))
 if extract gt 1 then begin
  plots,e1d(longl,extract),e1d(latgl,extract),color=isfcol,psym=3,symsize=0.2
 endif else begin
  if fill_continents eq 2 then begin
   plots,longl,latgl,color=isfcol,psym=3,symsize=0.4
  endif else begin
   plots,longl,latgl,color=isfcol,psym=6,symsize= 0.15
;   plots,longl,latgl,color=isfcol,psym=6,symsize=0.5
  endelse
 endelse
endif


if 0 then begin
 print,'plot grounded ice limit from RTOPO-2'
 anzgl=1057111
 gl=fltarr(2,anzgl)
 openr,1,indir+'RTopo-2.0.1_gil_2016-09-29.asc'
 readf,1,gl
 close,1
 indices=where(gl(0,*) gt lonmin and gl(0,*) lt lonmax $
           and gl(1,*) gt latmin and gl(1,*) lt latmax)
 longl=reform(gl(0,indices))
 latgl=reform(gl(1,indices))
 if extract gt 1 then begin
  plots,e1d(longl,extract),e1d(latgl,extract),color=gilcol,psym=3,symsize=0.2
 endif else begin
  plots,longl,latgl,color=gilcol,psym=3,symsize=3.
 endelse
endif

return
end
