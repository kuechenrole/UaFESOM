pro get_map_coordinates,plotkey,latmin,latmax,lonmin,lonmax,cellscale,proj

cellscale=1
if plotkey eq 'n' then begin
 lonmin=-180.
 lonmax= 180.
 latmin=  60.
 latmax=  90.
endif
if plotkey eq 'nst' then begin
 lonmin=-180.
 lonmax= 180.
 latmin=  65.
 latmax=  90.
endif
if plotkey eq 'ns' then begin
 lonmin=-180.
 lonmax= 180.
 latmin=  82.
 latmax=  90.
endif
if plotkey eq 'nl' then begin
 lonmin=-180.
 lonmax= 180.
 latmin=  45.
 latmax=  90.
endif
if plotkey eq 'na' then begin
 lonmin=  -100.
 lonmax=   30.
 latmin=   20.
 latmax=  85.
endif
if plotkey eq 's' then begin
 latmin=-90l
 latmax=-49l
 lonmin=-180l
 lonmax= 180l
 cellscale=1
 proj='stereo'
endif
if plotkey eq 'ss' then begin
 latmin=-90
 latmax=-59.5
 lonmin=-180
 lonmax= 180
 cellscale=1.
 proj='stereo'
endif
if plotkey eq 'sss' then begin
 latmin=-90.
 latmax=-74.
 lonmin=-180.
 lonmax= 180.
 cellscale=1.
 proj='stereo'
endif
if plotkey eq 'sl' then begin
 latmin=-90.
 latmax=-40.
 lonmin=-180
 lonmax= 180
endif
if plotkey eq 'ws' then begin
 latmin=-90.
 latmax=-60.
 lonmin=-90.
 lonmax=  0.
 cellscale=1.
 proj='cyl'
endif
if plotkey eq 'iws' then begin
 latmin=-80.;
 latmax=-60.;
 lonmin=-70.;
 lonmax=-10.;
 cellscale=1.
endif 

if plotkey eq 'lws' then begin
 latmin=-90.
 latmax=-40.
 lonmin=-90.
 lonmax= 90.
endif
if plotkey eq 'lis' then begin
 lonmin=-80.
 lonmax=-45.
 latmin=-70.
 latmax=-62.
 cellscale=1.
endif
if plotkey eq 'lisbc' then begin
 lonmin=-75.
 lonmax=-45.
 latmin=-72.
 latmax=-61.
 cellscale=1.
endif
if plotkey eq 'lisc' then begin
 lonmin=-70.
 lonmax=-45.
 latmin=-72.
 latmax=-65.
 cellscale=1.
endif
if plotkey eq 'lisb' then begin
 lonmin=-63.
 lonmax=-58.
 latmin=-66.5
 latmax=-64.
 cellscale=0.78
endif
if plotkey eq 'ap' then begin  ; Antarctic Peninsula
 lonmin=-90.
 lonmax=-45.
 latmin=-80.
 latmax=-60.
 proj='cyl'
; cellscale=0.8
endif
if plotkey eq 'fris' then begin  ; Filchner-Ronne Ice Shelf
 lonmin=-90.
 lonmax=-20.
 latmin=-85.
 latmax=-70.
 proj='cyl
 cellscale=1.5
 cellscale=1.
endif
if plotkey eq 'friss' then begin  ; Filchner-Ronne Ice Shelf, smaller area
 lonmin=-90.
 lonmax=-20.
 latmin=-85.
 latmax=-72.
 proj='cyl'
endif
if plotkey eq 'frisl' then begin  ; Filchner-Ronne Ice Shelf,  larger area
 lonmin=-90.
 lonmax=-10.
 latmin=-84.
 latmax=-70.
 proj='cyl'
endif
if plotkey eq 'frisap' then begin  ; Filchner-Ronne Ice Shelf + Antarctic Peninsula'
 lonmin=-85.
 lonmax=-27.
 latmin=-85.
 latmax=-65.
 cellscale=1.0
 proj='cyl'
endif
if plotkey eq 'filchner' then begin  ; Filchner Ice Shelf
 lonmin=-50.
 lonmax=-35.
 latmin=-84.
 latmax=-77.
 proj='cyl'
endif

if plotkey eq 'GM' then begin  ; Greenwhich Meridian region
 lonmin=-20.
 lonmax= 20.
 latmin= -72.
 latmax= -50.
 cellscale=5
 proj='cyl'
endif

if plotkey eq 'rab' then begin   ;Ross/Amundsen/Bellingshausen Sea
 lonmin=-179.
 lonmax= -60.
; latmin= -85.
; latmax= -60.
 latmin= -85.
 latmax= -62.
 proj='cyl'
endif
if plotkey eq 'as' then begin   ;Amundsen Sea
; lonmin=-160.
; lonmax= -84.
; latmin= -78.
; latmax= -71.
;without Sulzberger/Nickerson
 lonmin=-140.
 lonmax= -84.
 latmin= -75.75
 latmax= -71.52
 latmin= -76.
 latmax= -71.
 proj='cyl'
endif
if plotkey eq 'bell' then begin ;Bellingshausen Sea
 lonmin=-105.
 lonmax= -65.
 latmin= -76.
 latmax= -65.
 proj='cyl'
endif
if plotkey eq 'george6' then begin ;
 lonmin= -80.
 lonmax= -65.
 latmin= -74.
 latmax= -68.
 proj='cyl'
endif
if plotkey eq 'Wilkins' then begin ;
 lonmin= -75.
 lonmax= -69.5
 latmin= -71.2
 latmax= -69.5
 proj='cyl'
endif
if plotkey eq 'Abbot' then begin ;
 lonmin= -110.
 lonmax=  -80.
 latmin=  -73.5
 latmax=  -71.5
 latmin=  -74.5
 latmax=  -71.0
 cellscale=0.8
 cellscale=1.0
 proj='cyl'
endif
if plotkey eq 'Getz' then begin ;
 lonmin= -138.
 lonmax= -108.
 latmin=  -76.
 latmax=  -72.
; cellscale=0.8
 cellscale=1.0
 proj='cyl'
endif
if plotkey eq 'GetzW' then begin ;
 latmin=  -76.
 latmax=  -72.
 lonmin= -132.
 lonmax= -120.
; cellscale=0.8
 cellscale=1.0
 proj='cyl'
endif

if plotkey eq 'abwed' then begin ;Amundsen, Bellingshausen and western Weddell Sea
 lonmin=-140.
 lonmax= -20.
 latmin= -85.
 latmax= -60.
endif
if plotkey eq 'pig' then begin   ;PIG region
 lonmin=-105.
 lonmax=- 97.
 latmin= -76.
 latmax= -73.
 cellscale=3.
 proj='cyl'
endif
if plotkey eq 'pigbig' then begin   ;PIG region fully zoomed
 lonmin=-103.
 lonmax=- 99.
 latmin= -75.5
 latmax= -74.
 cellscale=3.
 proj='cyl'
endif
if plotkey eq 'ea' then begin
 latmin=-70.
 latmax=-55.
 lonmin=30
 lonmax=120
; cellscale=1.5
endif
if plotkey eq 'g' then begin
 lonmin=-180.
 lonmax= 180.
 latmin=-90.
 latmax=90.
 cellscale=0.3
 proj='cyl'
endif
if plotkey eq 'soc' then begin
 lonmin=-180.
 lonmax= 180.
 latmin=-80.
 latmax=-45.
 cellscale=0.3
 proj='cyl'
endif
if plotkey eq 'o' then begin
 lonmin= 130.
 lonmax=-160.
 latmin=  40.
 latmax=  60.
 cellscale=3.
endif
if plotkey eq 'lap' then begin    ;Laptev Sea
 lonmin=  90.
 lonmax= 150.
 latmin=  70.
 latmax=  80.
 cellscale=3.
endif
if plotkey eq 'Drake' then begin
 lonmin=  -120.
 lonmax=    0.
 latmin=  -70.
 latmax=  -45.
endif
if plotkey eq 'Gulf' then begin
 lonmin=  -110.
 lonmax=   45.
 latmin=    0.
 latmax=  75.
 cellscale=3.
endif

if plotkey eq 'k' then begin
 lonmin=  90.
 lonmax= 180.
 latmin=   0.
 latmax=  60.
 cellscale=3.
endif
if plotkey eq 'u' then begin
 center=[-36.27,-78.4]  ; [lon,lat]
 interval=4
 lonmin=  center(0)-interval
 lonmax=  center(0)+interval
 latmin=  center(1)-interval/2
 latmax=  center(1)+interval/2
 
 cellscale=3
endif
if plotkey eq 'ls' then begin
 print,'Lazarev Sea projection'
 latmin=-75
 latmax=-50.
 lonmin=-30.
 lonmax= 30.
 cellscale=3.
endif
if plotkey eq 'Amery' then begin
 print,'Amery ice shelf projection'
 latmin=-74.
 latmax=-64.
 lonmin= 65.
 lonmax= 90.	
 proj='cyl'
endif
if plotkey eq 'RossIS' then begin
 print,'Ross Ice Shelf projection'
 latmin= -85.
 latmax= -76.01
 lonmin= 150.
 lonmax=-140.+360.
 cellscale=2.
 proj='cyl'
endif
if plotkey eq 'Amerybig' then begin
 print,'Amery ice shelf projection'
 latmin=-74.
 latmax=-67.
 lonmin= 65.
 lonmax= 80.	
 proj='cyl'
endif
if plotkey eq 'Fimbul' then begin
 print,'Fimbul ice shelf projection'
 latmin=-72.
 latmax=-69.
 lonmin= -5.
 lonmax= 10.	
  cellscale=0.3
endif
if plotkey eq 'EWIS' then begin
 print,'EWIS projection'
 latmin=-78.
 latmax=-68.
 lonmin=-30.
 lonmax= 0.	
 proj='cyl'
endif
if plotkey eq 'Ross' then begin
 latmin= -85.
 latmax= -77.01
 lonmin= 150.
 lonmax=-140.+360.
 cellscale=1.
 proj='cyl'
endif 
if plotkey eq 'RossW' then begin
; latmin= -80.
; latmax= -70.
; lonmin= 155.
; lonmax= 175.
 latmin= -79.
 latmin= -77.
 latmax= -74.
 lonmin= 158.
 lonmax= 170.
 cellscale=1.
 proj='cyl'
endif 
if plotkey eq 'Rossplay' then begin
 latmin= -79.
 latmax= -75.
 lonmin= 162.
 lonmax= 170.
 cellscale=1.
 proj='cyl'
endif 
if plotkey eq 'NEGCS' then begin
 latmin= 74.
 latmax= 81.
 lonmin= -25
 lonmax= -3.
 cellscale=1
 proj='cyl'
endif 
if plotkey eq 'NEGIS' then begin
 latmin= 77.
 latmax= 81.
 lonmin= -32.
 lonmax= -14.
 cellscale=1
 proj='cyl'
endif
if plotkey eq 'Greenland' then begin
 latmin= 58.
 latmax= 88.
 lonmin= -80.+360.
 lonmax= -10.+360.
 cellscale=1.1
 proj='cyl'
endif 
if plotkey eq '79N' then begin
 latmin= 78
 latmax= 80
 lonmin= -24.5+360.
 lonmax= -18.+360.
 cellscale=2.
 proj='cyl'
endif 
if plotkey eq '79Nsmall' then begin
 latmin= 79.3
 latmax= 79.8
 lonmin= -22.8+360.
 lonmax= -19.+360.
 cellscale=2.
 proj='cyl'
endif 

end
