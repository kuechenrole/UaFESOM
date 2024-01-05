pro check_consistency2,bathy,draft,height,thick,amask,imask,omask,xrg,yrg,vis,map,steps,badpoints

print,'C.    check consistency of bathy,draft,wct, and masks'

wct=draft-bathy
indices=where(amask eq 3)
if countpoints(indices) gt 0 then wct(indices)=0     ; negative wct on dry continent is unavoidable but not a problem

print,'C.1   check for consistency of masks'
print,'C.1.1 open ocean'
indices1=where(imask eq 0 and omask eq 1)
indices2=where(amask eq 0)
if abs(max(indices2-indices1)) eq 0 then begin
 print,'           mask is consistent. Continue.'
endif else begin
 print,'           inconsistency found. Game Over.'
 stop
endelse



print,'C.1.2 grounded ice
indices1=where(imask eq 1 and omask eq 0)
indices2=where(amask eq 1)
if abs(max(indices2-indices1)) eq 0 then begin
 print,'           mask is consistent. Continue.'
endif else begin
 print,'           inconsistency found. 
 anzpoints=countpoints(where(amask eq 1 and imask eq 0))
 print,'           There are',anzpoints,' points with imask eq 0.'
 anzpoints=countpoints(where(amask eq 1 and omask eq 1))
 print,'           There are',anzpoints,' points with omask eq 1.'
 print,'Game Over.'
 stop
endelse

print,'C.1.3 floating ice
indices1=where(imask eq 1 and omask eq 1)
indices2=where(amask  eq 2)
if abs(max(indices2-indices1)) eq 0 then begin
 print,'           mask is consistent. Continue.'
endif else begin
 print,'           inconsistency found. Game Over.'
 stop
endelse

print,'C.1.4 continent
indices1=where(imask eq 0 and omask eq 0)
indices2=where(amask eq 3)
if abs(max(indices2-indices1)) eq 0 then begin
 print,'           mask is consistent. Continue.'
endif else begin
 print,'           inconsistency found. Game Over.'
 stop
endelse

if steps lt 2 then return

print,'C.2   check for consistency of ice shelf draft/height and imask'
print,'C.2.1 check that there is no nonzero draft outside ice mask'
show_overlap,draft,imask,flag,0
if countpoints(where(flag eq 2)) gt 0 then begin
 print,'found ',countpoints(where(flag eq 2)),' points with nonzero draft outside ice mask. Game Over'
 indices=where(flag eq 2)
 if vis then begin
  plotitez,flag,0.,0.,'',1
  plotbinrez,flag,xrg,yrg,map,0,0,'flag draft vs imask',2
 endif
 anzpoints=countpoints(indices)
 if anzpoints lt 20 then begin
  for i=0,countpoints(indices)-1 do begin
   index=indices(i)
   xy=rtopo_ij(index)
   print,i,index,draft(index),xy(0), xy(1)  ; xrg2d(index),yrg2d(index)
  endfor
 endif else begin
  print,'anzpoints=',anzpoints
 endelse
 stop
endif else begin
 print,'           No inconsistencies found. Continue.'
endelse

print,'C.2.2 check that there is no zero thickness inside ice mask'
thickfromdiff=height-draft
thickfromdiff(where(imask eq 0))=0.
thickdiff=thickfromdiff-thick
if max(abs(thickdiff)) gt 0.001 then begin
 print,'There is a difference larger than 1 mm between the thickness array and the thickness derived from height-draft.'
 print,'The program will stop here.'
 stop
endif
show_overlap,thick,imask,flag,vis
badpoints=where(flag eq 8)
if countpoints(badpoints) gt 0 then begin
 print,'          found',countpoints(where(flag eq 8)),' points with zero thickness inside ice mask. Game over'
; return
 stop
endif else begin
 print,'           No inconsistencies found. Continue.'
endelse 


print,'C.3   check for negative wct:'
indices=where(wct lt 0.)  
if countpoints(indices) gt 0 then begin
 wctneg=wct
 wctneg(where(wctneg gt 0.))=0
 plotitez,wctneg,0.,0.,'wctneg',1
 print,'      There are',countpoints(indices),' points with negative wcts. 
 show_overlap,wctneg,omask,flag,vis
 if vis then plotbinrez,flag,xrg,yrg,map,0.,0.,'wctneg vs omask',2
 indices=where(flag eq 2)
 anzpoints=countpoints(indices)
 print,'      There are',anzpoints,' points with negative wct in grounded ice areas.'
 indices=where(flag eq 10)
 anzpoints=countpoints(indices)
 print,'      There are',anzpoints,' points with negative wct in the ocean.'
 print,'Game over.
 stop
endif else begin
 print,'           No negative wct found outside dry continents. Continue'
endelse  


print,'C.4   check for (positive) wct on grounded ice and too small wct in ocean'
show_overlap,wct,omask,flag,vis
if countpoints(where(flag eq 2)) gt 0 then begin
 print,'          found',countpoints(where(flag eq 2)),' points with nonzero wct outside ocean mask. Game Over'
 plotitez,flag,0.,0.,'C.2 flag',1
 plotbinrez,flag,xrg,yrg,'ss',0,0,'C.2 flag',2
 stop 
endif else if countpoints(where(flag eq 8)) gt 0 then begin
 print,'          found',countpoints(where(flag eq 8)),' points with zero wct inside ocean mask.'
 indices=where(flag eq 8)
 if countpoints(indices) lt 20 then begin
  print,'positions are (index,lon,lat,bathy,draft,wct,omask):'
  for k=0,countpoints(indices)-1 do begin
   print,indices(k),xrg2d(indices(k)),yrg2d(indices(k)),bathy(k),draft(k),wct(k),omask(k)
  endfor
 endif
 plotitez,flag,0.,0.,'C.2 flag',1
 flags=smooth(flag,20)
 plotitez,flags,0.,0.,'C.2 flag smoothed',2
; plotbinrez,flags,xrg,yrg,'ss',0.,0.,'C.2 flag smoothed',2
 print,'Game over.'
 stop
endif else begin
 print,'           No inconsistencies found. Continue.'
endelse 

if 1 then begin
 print,'C.5 check for levitated ice shelves'
 indices=where(draft gt 0 and amask eq 2)
 if countpoints(indices) gt 0 then begin
  print,'there are ',countpoints(indices),' points with ice shelf draft above sea level.'
  draftpos=draft
  draftpos(where(draft le 0 or amask ne 2))=0.
  plotbinrez,draftpos,xrg,yrg,map,0,0,'positive ice shelf draft',5
  print,'Game over.'
  stop
 endif else begin
  print,'           No levitated ice shelves found. Continue.'
 endelse 
endif

print,'C.6 check for negative ice shelf thickness'
indices=where(thick lt 0)
if countpoints(indices) gt 0 then begin
 print,'There are ',countpoints(indices),' points with negative ice shelf thickness.'
 thickneg=thick*0.
 thickneg(indices)=thick(indices)
 plotbinrez,thickneg,xrg,yrg,map,0,0,'negative ice shelf draft',6
 print,'Game over.'
 stop
endif else begin
 print,'           No negative ice shelf thicknesses found. Continue.'
endelse 
 

print,'Your data survived the consistency check. Congratulations.'

return
end
