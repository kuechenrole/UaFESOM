pro colorbar,xpo,ypo,length,height,mindat,maxdat,leveling,nlevels,levels,colors

;diese procedure zeichnet einen farbbalken
;folgende parameter muessen gesetzt werden
;
;xpo,ypo  position der linken unteren ecke in devicekoordinaten
;length   laenge des balkens
;mindat,maxdat  wertegrenzen des balkens
;leveling: decide whether a contiunous or a discrete colorbar is desired

debug = 0

format='(f5.2)'
if (maxdat ge 100) or (mindat le -100) then format='(f7.2)'
if (maxdat ge 1000) or (mindat le -1000) then format='(f7.1)'

if 0 then begin
 print,'mindat=',mindat
 print,'maxdat=',maxdat
 print,'format=',format
endif

if countpoints(levels) eq 1 then begin
 if levels eq 0 then begin
  levels=findgen(nlevels)*(maxdat-mindat)/float(nlevels-1)+mindat
 endif
endif

if 0 then begin
 print,'in colorbar with leveling=',leveling
 print,'                 levels=   ',levels
 print,'                nlevels=   ',nlevels
 print,'                 colors=   ',colors
endif

if leveling then begin
 ncol=nlevels-1
 bar=fltarr(ncol,2)
 bar(*,0)=reform(colors(0:ncol-1))
 bar(*,1)=bar(*,0)
 tv,congrid(bar,length,height),xpo,ypo
 plot,[xpo,xpo+length],[0.,height],xsty=1,ysty=1,/nodata,/noerase,$
 yticks=1,ytickv=[0,height],ytickname=[' ',' '],$
 xticks=nlevels-1,xtickn=string(levels,format=format),$
 position=[xpo,ypo,xpo+length,ypo+height],$
 /device,xticklen=0.6,color=103,charsize=0.9
endif else begin
 bar=findgen(100)+1
 bar=rebin(bar,100,height)
 tv,congrid(bar,length,height),xpo,ypo
 plot,[mindat,maxdat],[0,height],xsty=1,$
 ysty=1,yticks=1,$
 ytickv=[0,height],ytickname=[' ',' '],$
 /nodata,/noerase,$
 position=[xpo,ypo,xpo+length,ypo+height],$
 /device,xticklen=-0.3,color=103
endelse
end
