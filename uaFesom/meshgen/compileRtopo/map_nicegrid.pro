pro map_nicegrid,plotkey,use_rtopo_coastline,fill_continents

get_map_coordinates,plotkey,latmin,latmax,lonmin,lonmax,cellscale

print,'in map_nicegrid mit use_rtopo_coastline=',use_rtopo_coastline

if use_rtopo_coastline eq 1 then begin
 rtopo1_coastline,plotkey,fill_continents
endif else if use_rtopo_coastline eq 15 then begin
 rtopo15_coastline,plotkey,fill_continents
endif else if use_rtopo_coastline eq 20 then begin
 rtopo2_coastline,plotkey,fill_continents
endif else if use_rtopo_coastline eq 1501 then begin
 rtopo15_rim_coastline,plotkey,fill_continents,use_rtopo_coastline-1500
endif else if use_rtopo_coastline eq 1531 then begin
 rtopo15_rim2150_coastline,plotkey,fill_continents,2150
endif else begin
 print,'no coastline drawn in map_nicegrid'
; if fill_continents gt 0 then begin
;  map_continents,mlinethick=2,color=104,/fill_continents
; endif
; map_continents,mlinethick=2,color=103
endelse

if plotkey eq 's' or plotkey eq 'ss' then begin
 map_grid,glinethick=1,/label,color=103,latlab=90,latdel=5,$
 latalign=0.,lonalign=0.,$
 charsize=0.9,$
 lats=[-90,-85,-80,-75,-70,-65,-60,-55,-50],$
; latnames=[' ','','-80','','-70','','-60','','-50'],$
 latnames=[' ','',' ','',' ','',' ','',' '],$
 lons=    [-180,-135,-90,-45,0,45,90,135,180],$
; lonnames=[' ',' ','-90',' ',' ','45',' ','135',' ']
 lonnames=[' ',' ','',' ',' ',' ',' ',' ',' ']
 print,'dirty: lat/lon labels suppressed in map_nicegrid.pro'
endif else if plotkey eq 'sl' then begin
 map_grid,glinethick=1,/label,color=103,latlab=90,latdel=5,$
 latalign=0.,lonalign=0.,$
 charsize=0.75,$
 lats=[-90,-80,-70,-60,-50,-40],$
 latnames=[' ','-80','-70','-60','-50',' '],$
 lons=    [-180,-135,-90,-45,0,45,90,135,180],$
 lonnames=[' ',' ','-90',' ',' ','',' ','',''],$
 lonlab=-45.
endif else if plotkey eq 'ls' or plotkey eq 'lisbc'$
           or plotkey eq 'bell' or plotkey eq 'Wilkins' $
           or strmid(plotkey,0,5) eq 'NEGCS' then begin
 map_grid,glinethick=1,/label,color=103,$
 latalign=0.,lonalign=0.,$
 charsize=0.8,/box_axes
endif else if plotkey eq 'pigbig' then begin
 map_grid,glinethick=1,/label,color=103,$
 latalign=0.,lonalign=0.,$
 charsize=1.,/box_axes,$
  lons=[-103.,-102.5,-102.0,-101.5,-101.,-100.5,-100,-99.5,99],$
  lonnames=[' ','','-102','','-101','','-100','',' '],$
  lats=[-74.,-74.5,-75,-75.5],$
  latnames=['-74','-74.5','-75','-75.5']
endif else if plotkey eq 'Getz' then begin
 map_grid,glinethick=1,/label,color=103,$
 latalign=0.,lonalign=0.,$
 charsize=1.3,/box_axes,$
  lons=[-140.,-130.,-120.,-110.],$
  lonnames=['-140.','-130.','-120.','-110.'],$
  lats=[-76.,-75.,-74.,-73.,-72.]
  latnames=['','-75.','-74.','-73.',' ']
endif else if plotkey eq 'Abbot' then begin
 map_grid,glinethick=1,/label,color=103,$
 latalign=0.,lonalign=0.,$
 charsize=1.1,/box_axes,$
  lons=[-110.,-105.,-100.,-95.,-90.,-85,-80.],$
;  lonnames=[' ','','-102','','-101','','-100','',' '],$
  lats=[-74.5,-74.0,-73.5,-73.0,-72.5,-72.0,-71.5,-71.0],$
  latnames=['','-74.0','-73.5','-73.0','-72.5','-72.0','-71.5','']
endif else if plotkey eq 'ea' then begin
 map_grid,glinethick=1,/label,color=103,$
  lons=[30,40,50,60,70,80,90,100,110,120],$
  lats=[-70,-65,-60,-55],$
  latnames=['-70','-65','-60',' '],$
  charsize=0.75
 map_grid,glinethick=1,color=103,$
  lons=[lonmin,lonmax],lats=[-90,latmax],glinestyle=0
endif else if plotkey eq 'ws' then begin
 map_grid,glinethick=1,/label,color=103,$
 lats=    [-90,-85,-80,-75,-70,-65,-60],$
; latnames=['-90','','-80','','-70','',''],$
 lons=    [-90,-75,-60,-45,-30,-15,0],$
 lonnames=['-90','-75','-60','-45','-30','-15','0'],$
 lonlab=-62.5,lonalign=0.5,latlab=-52.5
endif else if plotkey eq 'fris' or plotkey eq 'friss' then begin
 map_grid,glinethick=1,/label,color=103,$
 lonlab=-84.5,latlab=-88,$
 lats=[-85.,-84,-82,-80,-78,-76,-74,-72,-70],$
 latnames=['','-84','-82','-80','-78','-76','-74','-72',''],$
 lons=[-90,-80,-70,-60,-50,-40,-30,-20],$
 lonnames=['','-80','-70','-60','-50','-40','-30',''],/box_axes
endif else if plotkey eq 'frisap' $
           or plotkey eq 'as'     $
           or plotkey eq 'rab' then begin
 map_grid,glinethick=1,/label,color=103,$
 /box_axes
endif else if plotkey eq 'lws' then begin
 map_grid,glinethick=1,/label,color=103,$
 lats=[-90,-80,-70,-60,-50,-40],$
 lons=[-75,-60,-45,-30,-15,0,15,30,45,60,75],$
 latnames=['','','','','',''],$
 lonnames=['','','','','','','','','','','']
 map_grid,glinethick=2,color=103,$
  lons=[-75,75],lats=[-90,latmax],glinestyle=0
endif else if plotkey eq 'Amerybig' or plotkey eq 'RossIS' then begin
 map_grid,glinethick=1,/label,color=103,$
 charsize=1.00,/box_axes
endif else if plotkey eq 'g' then begin
; map_grid,glinethick=0,/label,color=103,$
; charsize=1.00,/box_axes
 print,'global projection lat/lon lines plotted'
endif else begin
 map_grid,glinethick=1,/label,color=103,$
 charsize=0.75
endelse

end
