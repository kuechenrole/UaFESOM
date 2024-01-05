pro dolegend,legend,plotkey,color

debug=0

if debug then print,'do legend with ',n_elements(legend),' elements'

for il=0,n_elements(legend)-1 do begin
 if debug then print,legend(il)
 if plotkey eq 'bell' or plotkey eq 'lisbc' $
 or plotkey eq 'Abbot' or plotkey eq 'Getz' then begin
  xyouts,0.12,0.85-float(il)/20.,legend(il),/normal,color=color,charsize=1.3
 endif else begin
  xyouts,0.1,0.95-float(il)/20.,legend(il),/normal,color=color,charsize=1.3
 endelse
endfor

end
