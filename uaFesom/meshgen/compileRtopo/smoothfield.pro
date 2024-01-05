function smoothfield,infield,range,periodic,spval

debug=0
print,'smooth over ',2*range+1,' points in each direction'

outfield=infield*0.
if periodic then begin
 print,'smooth field assuming periodicity in i direction'
 sizef=size(infield)
 infielde=[infield(sizef(1)-range:sizef(1)-1,*),$
           infield(*,*),$
           infield(0:range-1,*)]
 if debug then help,infield,range,infielde

 if countpoints(where(infield eq spval)) eq 0 then begin
  print,'no special values exist in field to be smoothed'
  outfielde=smooth(infielde,range,/edge_truncate)
  outfield=reform(outfielde(range:sizef(1)+range-1,*))
 endif else begin
  print,'special values exist: create smoothing windows'
  for j=range,sizef(2)-1-range do begin
   print,'smooth j=',j
   for i=range,sizef(1)-1-range do begin
    winfield=reform(infielde(i-range:i+range,j-range:j+range))
    goodpoints=where(winfield ne spval)
    outfield(i,j)=ezmean(winfield(goodpoints))
   endfor
  endfor
 endelse
 if debug then print,range,sizef(1)+range-1
 if debug then help,outfielde
 if debug then help,outfield
endif else begin
 if countpoints(where(infield eq spval)) eq 0 then begin
  print,'no special values exist in field to be smoothed'
  outfield=smooth(infield,range,/edge_truncate)
 endif else begin
  print,'special values exist: create smoothing windows'
  sizef=size(infield)
  for j=range,sizef(2)-1-range do begin
   print,'smooth j=',j
   for i=range,sizef(1)-1-range do begin
    if infield(i,j) ne spval then begin 
     winfield=reform(infield(i-range:i+range,j-range:j+range))
     goodpoints=where(winfield ne spval)
     outfield(i,j)=ezmean(winfield(goodpoints))
    endif
   endfor
  endfor
 endelse
endelse

return,outfield

end
