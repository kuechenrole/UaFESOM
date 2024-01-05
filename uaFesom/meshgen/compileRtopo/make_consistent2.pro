pro make_consistent2,bathy,draft,height,amask,imask,omask,steps,xrg,yrg,wctmin,vis,map

;adopted from treatment of PIG data, but added a couple of features
;
;steps:
; 1. wct < 0      under grounded ice
; 2. wct < 0      in the ocean
; 3. wct > 0      under grounded ice
; 4. wct < wctmin in the ocean


extvis=0

if 1 then begin
 print,'M.0   first check for consistency of masks'
 print,'M.0.1 open ocean
 indices1=where(imask eq 0 and omask eq 1)
 indices2=where(amask eq 0)
 if abs(max(indices2-indices1)) eq 0 then begin
  print,'           mask is consistent. Continue.'
 endif else begin
  print,'           inconsistency found. Game Over.'
  stop
 endelse

 print,'M.0.2 grounded ice
 indices1=where(imask eq 1 and omask eq 0)
 indices2=where(amask eq 1)
 if abs(max(indices2-indices1)) eq 0 then begin
  print,'           mask is consistent. Continue.'
 endif else begin
  print,'           inconsistency found. 
  anzpoints=countwherelems(where(amask eq 1 and imask eq 0))
  print,'           There are',anzpoints,' points with imask eq 0.'
  anzpoints=countwherelems(where(amask eq 1 and omask eq 1))
  print,'           There are',anzpoints,' points with omask eq 1.'
  print,'Game Over.'
  stop
 endelse

 print,'M.0.3 floating ice
 indices1=where(imask eq 1 and omask eq 1)
 indices2=where(amask  eq 2)
 if abs(max(indices2-indices1)) eq 0 then begin
  print,'           mask is consistent. Continue.'
 endif else begin
  print,'           inconsistency found. Game Over.'
  stop
 endelse

 if 1 then begin
  print,'M.0.4 continent
  indices1=where(imask eq 0 and omask eq 0)
  indices2=where(amask  eq 3)
  if abs(max(indices2-indices1)) eq 0 then begin
   print,'           mask is consistent. Continue.'
  endif else begin
   print,'           inconsistency found. Game Over.'
   stop
  endelse
 endif


 print,'M.0.5 check for negative ice shelf/sheet thickness'
 thick=height-draft
 indicesn=where(thick lt 0)
 anzneg = countpoints(indicesn)
 if anzneg gt 0 then begin
  print,'Bad news: There are already ',anzneg,' points with negative ice thickness.'
  print,'Game over.'
  stop
 endif else begin
  print,'           no negative ice thicknesses. Continue.'
 endelse
endif

print,'M.    ensure consistency of wct'
print,'      check for negative wct'
wct=draft-bathy
wctneg=wct
wctneg(where(wct gt 0 or amask eq 3))=0.
show_overlap,wctneg,omask,flag,vis
if 0 then plotbinrez,flag,xrg,yrg,map,0.,0.,'wctneg vs omask',1

print,'M.1 get rid of negative wcts on grounded ice areas'
indices=where(flag eq 2)
anzpoints=countpoints(indices)
print,'      There are',anzpoints,' points with negative wct on grounded ice areas.'



if anzpoints gt 0 then begin
 print,'      
 if steps(0) eq 1 then begin
  draft(indices)=0.5*(draft(indices)+bathy(indices))
  bathy(indices)=draft(indices)
  print,'       corrected by putting draft and bathy to their mean'
  if vis then begin
   plotbinrez,e2d(bathy,5,5),e1d(xrg,5),e1d(yrg,5),map,-500.,1200.,'bathy, wctneg removed on grounded ice',2
   plotbinrez,e2d(draft,5,5),e1d(xrg,5),e1d(yrg,5),map,-500.,1200.,'draft, wctneg removed on grounded ice',3
  endif
 endif else if steps(0) eq 2 then begin
  bathy(indices)=draft(indices)
  print,'       corrected by putting draft:=bathy'
 endif else begin
  plotbinrez,flag,xrg,yrg,map,0,0,'flag wctneg vs omask',1
  plotbinrez,wct,xrg,yrg,map,-100,100,'wct',2
  print,'      I can offer you to put bathy and draft to their mean values (set flag=1) '
  print,'                          or to set bathy:=draft for grounded ice (set flag=2).'
  stop
 endelse
 thick=height-draft
 indicesn=where(thick lt 0)
; anzneg=countwherelems(indicesn)
 anzneg=countpoints(indicesn)
 if anzneg gt 0 then begin
  print,'Bad news: There are now',anzneg,' points with negative ice shelf thickness.'
  print,'The program stops.'
  stop
  minicethick=1.
  print,'These points will be corrected by assuming a minumum ice thickness of',minicethick,'  m.'
  bathy(indicesn)=height(indicesn)+5.
  draft(indicesn)=height(indicesn)+5.
 endif
endif

print,'M.2 get rid of negative wcts in the ocean'
indices=where(flag eq 10)
;anzpoints=countwherelems(indices)
anzpoints=countpoints(indices)
print,'      There are',anzpoints,' points with negative wct in the ocean.'
if vis then windows,10
if anzpoints gt 0 then begin
 if vis then plot,wct(indices),color=103
 show_overlap,wctneg,imask,flagi,vis
 if extvis then plotbinrez,flagi,xrg,yrg,map,0,0,'overlap wctneg vs imask',4
 indicesi=where(flag eq 10 and flagi eq 10)
 indiceso=where(flag eq 10 and flagi eq 2)
; anzi=countwherelems(indicesi)
; anzo=countwherelems(indiceso)
 anzi=countpoints(indicesi)
 anzo=countpoints(indiceso)
 print,'      Of these,',anzi,' are under ice shelf,'
 print,'               ',anzo,' are in the open ocean.'

 if steps(1) gt 0 then begin
  if extvis then plotbinrez,wctneg,xrg,yrg,map,0.,0.,'wctneg',5
  if anzi gt 0 then begin
   if steps(1) eq 1 then begin
    draft(indicesi)=0.5*(draft(indicesi)+bathy(indicesi))+0.25*wctmin
    bathy(indicesi)=draft(indicesi)-0.75*wctmin
    print,'      ice shelf cavities corected: adjusted bathy more than draft'
    print,'      Now check whether ice shelf thickness is still positive:'
    thick=height+draft
    indicesn=where(thick lt 0)
    anzneg=countwherelems(indicesn)
    if anzneg gt 0 then begin
     print,'There are now',anzneg,' points with negative ice shelf thickness'
     thicknew=thick*0.
     thicknew(indicesi)=thick(indicesi)
     indicesin=where(thicknew lt 0)
     print,'Of these, ',countwherelems(indicesin),' have just been corrected.'
     print,'Think about using flag 2 instead.
     print,'Game over'
     stop
    endif 
   endif else if steps(1) eq 2 then begin
    bathy(indicesi)=draft(indicesi)-wctmin
    print,'      ice shelf cavities corected: prescribe minimum wct for bathy, keep draft'
   endif else begin
    print,'unregnized entry in steps(1)'
   endelse
  endif else begin
   print,'      nothing to do in the ice shelf cavities.'
  endelse

  if anzo gt 0 then begin
   draft(indiceso)=0.
   bathy(indiceso)=-wctmin
   print,'      open water points corected by setting bathy to wctmin'
  endif else begin
   print,'      nothing to do in open ocean.'
  endelse

  if extvis then begin
   plotbinrez,bathy,xrg,yrg,map,-500.,1200.,'bathy, wctneg removed in ocean',6
   plotbinrez,draft,xrg,yrg,map,-500.,1200.,'draft, wctneg removed in ocean',7
  endif
 endif else begin
  print,'      You really should do something about it.'
  print,'      I can offer you to:
  print,'      - adjust bathy more than draft (set flag=1)'
  print,'      - prescribe minimum wct for bathy and keep draft (set flag=2).'
  print,'      Pick one.'
  stop
 endelse
endif

print,'M.3 get rid of positive wct under grounded ice'
wct=draft-bathy
show_overlap,wct,omask,flag,vis
indices=where(flag eq 2 and amask eq 1)
;anzpoints=countwherelems(indices)
anzpoints=countpoints(indices)
print,'      There are',anzpoints,' points with positive wct under grounded ice.'
if anzpoints gt 0 then begin
 if vis then begin
;  windows,8
;  plot,wct(indices),color=104
  plotbinrez,flag,xrg,yrg,map,0.,0.,'wct vs omask (will show also wct>0 on land points!)',1
  wctmask=wct*0.
  wctmask(indices)=wct(indices)
  plotbinrez,wctmask,xrg,yrg,map,0.,0.,'wctmask',2
 endif
 if steps(2) eq 1 then begin
  print,'      corrected by setting bathy and draft:=ezmean(bathy+draft)'
  draft(indices)=0.5*(draft(indices)+bathy(indices))
  bathy(indices)=draft(indices)
 endif else if steps(2) eq 2 then begin
  bathy(indices)=draft(indices)
  print,'      corrected by setting bathy:=draft'
  if extvis then begin
   plotbinrez,bathy,xrg,yrg,map,-500.,1200.,'bathy, wctpos removed on grounded ice',3
   plotbinrez,draft,xrg,yrg,map,-500.,1200.,'draft, wctpos removed on grounded ice',4
  endif
 endif else begin
  print,'    You really should do something about it.'
  print,'    I can offer you to put bathy and draft to their mean values (set flag=1)'
  print,'                                       or to set bathy to draft (set flag=2).'
  stop
 endelse
endif

print,'M.4 treat points with wct = 0 in the ocean'
wct=draft-bathy
show_overlap,wct,omask,flag,vis
indices=where(flag eq 8)
anzpoints=countwherelems(indices)
;anzpoints=countpoints(indices)
if anzpoints gt 0 then begin
 print,'      There are',anzpoints,' points with too small wct in the ocean.'
 if vis then plotbinrez,wct,xrg,yrg,map,-50.,50.,'wct',5
 if steps(3) eq 0 then begin
  print,'      You really should do something about it.'
  print,'      I can offer you to prescribe minimum wct for bathy and keep draft (set flag=1).'
  stop
 endif else if steps(3) eq 1 then begin
  bathy(indices)=draft(indices)-wctmin
  print,'      wct corected: prescribe minimum wct for bathy, keep draft'
 endif else begin
  print,'unregnized entry in steps(1)'
 endelse
 if extvis then begin
  plotbinrez,bathy,xrg,yrg,map,-500.,1200.,'bathy, too small wct removed in ocean',6
  plotbinrez,draft,xrg,yrg,map,-500.,1200.,'draft, too small wct removed in ocean',7
 endif
endif else begin
 print,'there are no points with 0 wct in the open ocean'
endelse

return
end
