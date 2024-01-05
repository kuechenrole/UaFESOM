pro mkcolorbar ,xpo, ypo, mindat, maxdat, length 

;diese procedure zeichnet einen farbbalken
;folgende parameter muessen gesetzt werden
;
;xpo,ypo  position der linken unteren ecke in devicekoordinaten
;length   laenge des balkens
;mindat,maxdat  wertegrenzen des balkens


bar=findgen(100)+1
bar=rebin(bar,100,10)
tv,congrid(bar,length,10),xpo,ypo
plot,[mindat,maxdat],[0,10],xsty=1,$
ysty=1,yticks=1,$
ytickv=[0,10],ytickname=[' ',' '],$
/nodata,/noerase,$
position=[xpo,ypo,xpo+length,ypo+10],$
/device,xticklen=-0.3,color=103

end


pro plotitez, data, mindat, maxdat,text,winnum


;this procedure plots an image of data

;data		must be a 2-dim. array
;xpo		x-position in device coord.
;ypo
;xsize		x-size in device coord.
;ysize
;mindat		minimum of data
;maxdat
;text		title text

windows,winnum

xpo=30
ypo=150
xsize=550
ysize=300
;xsize=800
;ysize=500
imask=1
smask=0

smaskdum=smask

if n_elements(smask) lt 2 then begin
 if smask eq 99 then begin
  smask=data*0.
  smask(*)=1.
  smask(where(data(*) ge 1.e10))=0.
  print,'plotit does masking himself'
 endif
endif

sizes=size(smask)
;print,sizes
if sizes(0) gt 1 then data=data*smask


if (mindat eq 0 and maxdat eq 0) then begin
 mindat=min(data)
 maxdat=max(data)
 maxdat=maxdat+(maxdat-mindat)/100.
endif

sizes=size(data)
limits=[0,sizes(1),0,sizes(2)]

sc=100./(maxdat-mindat)  		;calculate scaling for color
ft=-1*mindat*sc+1		  	;calculate shift for color

plotdata=data
if max(data) gt maxdat then plotdata(where(data gt maxdat))=maxdat
if min(data) lt mindat then plotdata(where(data lt mindat))=mindat

erase

plotdats=sc*plotdata+ft
;plotdats(where(smask eq 0))=0.

if countpoints(smask) eq countpoints(plotdats) then plotdats(where(smask eq 0))=104.  ;RT corrected 2014-02-25

tv,congrid(plotdats,xsize,ysize),xpo,ypo
;tv,congrid(sc*plotdata+ft,xsize,ysize,/interp),xpo,ypo

;tv,bytscl(congrid(data,xsize,ysize),min=mindat,max=maxdat),xpo,ypo

;data1=congrid(data,300,400,/interp)
;contour,data1,/noerase,position=[xpo,ypo,xpo+xsize,ypo+ysize],$
;           /device,levels=levline,title=text

i=indgen(68)
j=indgen(54)
i1=congrid(i,xsize,/interp)
j1=congrid(j,ysize,/interp)

if 1 then begin
   plot,[0,xsize],[0,ysize],/noerase,/nodata,$
       position=[xpo,ypo,xpo+xsize,ypo+ysize],$
       /device,title=text,$
;xrange=[limits(0),limits(1)+1],$
xrange=[limits(0),limits(1)],$
xstyle=1,$
;yrange=[limits(2),limits(3)+1],$
yrange=[limits(2),limits(3)],$
ystyle=1,$
color=103
endif




;mkcolorbar,xpo+40,ypo,mindat,maxdat,xsize-80
colorbar,xpo+40,ypo-50,xsize-80,10,mindat,maxdat,0.,10.,0.,0.
;colorbarn,0.1,0.05,0.8,0.02,mindat,maxdat,0.,0.,0.,0.



smask=smaskdum

end
