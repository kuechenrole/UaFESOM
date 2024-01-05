pro set_mapi,plotkey,title,latmin,latmax,lonmin,lonmax,$
    cellscale,nrofpanel,anzpanels

lonmin=-180
lonmax= 180
if anzpanels eq 1 then begin
 pos=[0.1,0.14,0.9,0.9]
endif else if anzpanels eq 4 then begin
 if nrofpanel eq 1 then begin
  pos=[0.15,0.55,0.5,0.9]
 endif else if nrofpanel eq 2 then begin
  pos=[0.55,0.55,0.9,0.9]
 endif else if nrofpanel eq 3 then begin
  pos=[0.15,0.1,0.5,0.45]
 endif else if nrofpanel eq 4 then begin
  pos=[0.55,0.1,0.9,0.45]
 endif
endif else begin
 print,'unrecognized value for anzpanels in set_map!'
endelse

get_map_coordinates,plotkey,latmin,latmax,lonmin,lonmax,cellscale

if plotkey eq 's' or plotkey eq 'ss' or plotkey eq 'sl' then begin
 map_set,-90,0,0,/stereo,limit=[latmin,-180,latmax,180],title=title,$
 pos=pos,/noborder,/noerase
 cellscale=1
endif else if plotkey eq 'ws' then begin
 map_set,-90,0,0,/stereo,limit=[latmin,lonmin,latmax,lonmax],title=title,$
 pos=pos,/noerase
endif else if plotkey eq 'ea' or plotkey eq 'lws' then begin
 map_set,-90,0.5*(lonmin+lonmax),/stereo,/isotropic,$
  limit=[latmin,lonmin,latmax,lonmax],title=title,$
   pos=pos,/noborder,/noerase
endif else if plotkey eq 'n' or plotkey eq 'ns' or plotkey eq 'nl' then begin
 map_set,90,0,0,/stereo,limit=[latmin,lonmin,latmax,lonmax],title=title,$
 pos=pos,/noborder,/noerase
endif else begin
 map_set,/cylindrical,$
 limit=[latmin,lonmin,latmax,lonmax],title=title,$
 pos=pos,/noerase,/noborder
 if plotkey eq 'g' then cellscale=0.25
endelse


return
end
