pro compile_rtopo_pism
;<---------------------------------------------- Pull Window To This Size ----------------------------------------------------->

; This program compiles a consistent global dataset for
; ocean bathymetry, ice shelf draft, and water column thickness,
; using output from the PISM ice sheet model.
;
; It has been derived from RAnGO routine compile_rtopo_rim10. 

; Topographies are stored on a 1*1 minute grid to be consistent with FESOM mesh mashinery.
;
; Ralph Timmermann, 25.03.2019
;------------------------------------------------------------------------
; The program uses the following steps:
;                these flags should all be 1 if you want the full program
;                |
;                |  these are just short cut entries)
;                |  |   
useheader=1            ; use following lines to direct program (0: directions to be issued on command line)
if useheader then begin
doinit           =1      ; 1. initialize regular grid

readmergeddata6 = 0;      Seiteneinstieg - entry for RAnGO coupling
readrtopo2      = 1

; -----------------------------------------------
;special stuff for frismeltpap
doismeltmap1        = 0    ; creates map with GL moved to new place of hydrostatic equilibrium
doismeltmap2        = 0    ; creates map with GL moved to new place of hydrostatic equilibrium
; -----------------------------------------------

dopism           = 1    ;       read and interpolate PISM datasets for icedraft and mask
mergepism        = 1    ;       merge PISM patch into merggeddata6, output of mergeddata10_yyyy
readmergeddata     = 0     ;       Seiteneinstieg

makecoastlines   = 0     ;      create coastline/grounding line to be used on plots

coupled          = 1    ;       set to 1 to run mashinery as part of coupled model

; -----------------------------------------------

vis            = 1  ; for visualization of data products
extvis         = 0    ; for excessive visualization of data
dooutput       = 0    ; enable output

; -----------------------------------------------

rhoice =  917    ; densities to be used
rhowat = 1030    ; consistently throughout FESOM-PISM

outdir=' '
openr,1,'outdir.asc'
readf,1,outdir
close,1
if strmid(outdir,strlen(outdir)-1,1) ne '/' then outdir=outdir+'/'
print,'outdir=',outdir

dirdir = '../director/'

pismtopodir=' '
openr,1,'meshdir.asc'
readf,1,pismtopodir
close,1
if strmid(pismtopodir,strlen(pismtopodir)-1,1) ne '/' then pismtopodir=pismtopodir+'/'
print,'pismtopodir=',pismtopodir

; -------------- no users beyond this line ---------------

endif else begin
 print,'Program is run in interactive mode'
endelse

if coupled then begin
 vis=0
 dooutput=1
endif

;wanted resolution: res datapoints per degree
res=60

close,/all

if doinit then begin
 print,'1.1 Universal Definitions'

 colors=[10,20,30,40,50,60,70,80,90,95]

 if vis eq 1 then begin
 loadcol,'rd.col'
; loadcol,'topo.col'  
; loadcol,'bathy.col'
; loadcol,'bathy_l2.col'
  init
 endif

 wctmin= 1.            ; mimimum water column thickness under ice shelves
 print,'apply minimum water column thickness of ',wctmin,' m'

 print,'set up interpolation to', 1./float(res)*60,' minute grid'
 anzxrg=360l*res+1
 anzyrg=180l*res+1
 anzyrs= 40l*res+1

 xrg=findgen(anzxrg)/res-180.
 yrg=findgen(anzyrg)/res-90.
 yrs=findgen(anzyrs)/res-90.    ; Southern Ocean subarray south 50S

 lonrg=fltarr(anzxrg,anzyrg)
 latrg=fltarr(anzxrg,anzyrg)
 for i=0,anzxrg-1 do begin
  latrg(i,*)=yrg
 endfor
 for j=0,anzyrg-1 do begin
  lonrg(*,j)=xrg
 endfor
 sourcebathy=bytarr(anzxrg,anzyrg)
 sourcedraft=bytarr(anzxrg,anzyrg)
 dummyc=''
endif

if readmergeddata6 then begin
  indir = '/csys/nobackup4_CLIDYN/rtimmerm/compile_rtopo1.5/'
  mergedbathy6= fltarr(anzxrg,anzyrg)
  mergeddraft6= fltarr(anzxrg,anzyrg)
  mergedheight6=fltarr(anzxrg,anzyrg)
  mergedamask6= bytarr(anzxrg,anzyrg)
  mergedimask6= bytarr(anzxrg,anzyrg)
  mergedomask6= bytarr(anzxrg,anzyrg)
  sourcebathy6= fltarr(anzxrg,anzyrg)
  sourcedraft6= fltarr(anzxrg,anzyrg)
  print,'read mergedbathy6 from file'
  openr,1,indir+'mergedbathy6.bin',/swap_if_big_endian
  readu,1,mergedbathy6
  close,1
  print,'read mergeddraft6 from file'
  openr,1,indir+'mergeddraft6.bin',/swap_if_big_endian
  readu,1,mergeddraft6
  close,1
  print,'read mergedheight6 from file'
  openr,1,indir+'mergedheight6.bin',/swap_if_big_endian
  readu,1,mergedheight6
  close,1
  print,'read mergedamask6 from file'
  openr,1,indir+'mergedamask6.bin',/swap_if_big_endian
  readu,1,mergedamask6
  close,1  
  print,'read mergedimask6 from file'
  openr,1,indir+'mergedimask6.bin',/swap_if_big_endian
  readu,1,mergedimask6
  close,1
  print,'read mergedomask6 from file'
  openr,1,indir+'mergedomask6.bin',/swap_if_big_endian
  readu,1,mergedomask6
  close,1
  print,'read sourcebathy6 from file'
  openr,1,indir+'sourcebathy6.bin',/swap_if_big_endian
  readu,1,sourcebathy6
  close,1  
  print,'read sourcedraft6 from file'
  openr,1,indir+'sourcedraft6.bin',/swap_if_big_endian
  readu,1,sourcedraft6
  close,1  
;  bathy      =mergedbathy6
;  draft      =mergeddraft6
;  height     =mergedheight6
;  amask      =mergedamask6
;  imask      =mergedimask6
;  omask      =mergedomask6
;  sourcebathy=sourcebathy6
;  sourcedraft=sourcedraft6
endif


iifris=89*res              ; do not modify, applied also for data processing!
iefris=anzxrg/2-500        ; do not modify, applied also for data processing!
jifris=300                 ; do not modify, applied also for data processing!
jefris=20*res              ; do not modify, applied also for data processing!


if doismeltmap1 then begin
 draft = mergeddraft6
 bathy  = mergedbathy6  

 height= mergedheight6
 amask = mergedamask6
 imask = mergedimask6

 thick = height-draft
 newthick = thick*0.7  ; gives 300 m reduction at 1500 m thickness  

 
 print,'compute new height and draft'
 ; derived from eq. (2) of Lambrecht et al. (2007)
 rho_w   =1028.
 rho_met = 896.
 rho_mar = 911.
 deltah1 =  15.5
 deltah2 =   0.
 a_fris  =   1.19
 frismarthick=thick*0.
 frismetthick=newthick

 newheight=1./a_fris*((rho_w-rho_mar)/rho_w*frismarthick+deltah1+deltah2+(rho_w-rho_met)/rho_w*frismetthick)
 newdraft=newheight-newthick
; newdraft(where (newdraft gt 0.))=0

 oldwct=draft-bathy
 newwct=newdraft-bathy
 indices=where(newwct gt 0 and amask eq 1)
 newamask=amask
 newamask(indices)=2

 plotbinrez,newamask,xrg,yrg,'friss',0.,0.,'newamask',5        

 if dooutput then begin
  print,'write new amask to file'
  openw,1,outdir+'ismeltamask.bin',/swap_if_big_endian
  writeu,1,newamask
  close,1  
 endif

 iifris=(180-88)*res                 ; do not modify, applied for data processing!
 iefris=(180-20)*res                 ; do not modify, applied for data processing!
 jifris=( 90-85)*res                 ; do not modify, applied for data processing!
 jefris=fix(( 90.-74.5)*float(res))        ; do not modify, applied for data processing!
 print,'create new amask only for FRIS grounding line moved'
 frisamask=amask
 frisamask(iifris:iefris,jifris:jefris)=newamask(iifris:iefris,jifris:jefris)

 iinofris=(180-30)*res        ; do not modify, applied for data processing!
 ienofris=iefris              ; do not modify, applied for data processing!
 jinofris=( 90-77)*res        ; do not modify, applied for data processing!
 jenofris=jefris              ; do not modify, applied for data processing!
 frisamask(iinofris:ienofris,jinofris:jenofris)=amask(iinofris:ienofris,jinofris:jenofris)
  
 plotbinrez,frisamask,xrg,yrg,'friss',0.,0.,'frisamask',6

 if dooutput then begin print,'write frisamask to file'
  openw,1,outdir+'frismeltamask.bin',/swap_if_big_endian
  writeu,1,frisamask
  close,1 
 endif
endif

if doismeltmap2 then begin    ; uses reduction of ice thickness by 50%
 draft = mergeddraft6
 bathy  = mergedbathy6
 height= mergedheight6
 amask = mergedamask6
 imask = mergedimask6
 thick = height-draft

; make all ice grounded on bathymetry deeper than 100 m ungrounded
 newamask=amask
 indices=where(bathy lt -100. and amask eq 1)   
 newamask(indices)=2

 plotbinrez,newamask,xrg,yrg,'friss',0.,0.,'newamask',5        

 if dooutput then begin
  print,'write new amask to file'
  openw,1,outdir+'ismeltamask2.bin',/swap_if_big_endian
  writeu,1,newamask
  close,1  
 endif

 print,'create new amask only for FRIS grounding line moved'
 iifris=(180-88)*res                 ; do not modify, applied for data processing!
 iefris=(180-20)*res                 ; do not modify, applied for data processing!
 jifris=( 90-85)*res                 ; do not modify, applied for data processing!
 jefris=fix(( 90.-74.5)*float(res))  ; do not modify, applied for data processing!

 frisamask=amask
 frisamask(iifris:iefris,jifris:jefris)=newamask(iifris:iefris,jifris:jefris)

 iinofris=(180-30)*res        ; do not modify, applied for data processing!
 ienofris=iefris              ; do not modify, applied for data processing!
 jinofris=( 90-77)*res        ; do not modify, applied for data processing!
 jenofris=jefris              ; do not modify, applied for data processing!
 frisamask(iinofris:ienofris,jinofris:jenofris)=amask(iinofris:ienofris,jinofris:jenofris)
  
 plotbinrez,frisamask,xrg,yrg,'friss',0.,0.,'frisamask',6

 if dooutput then begin print,'write frisamask to file'
  openw,1,outdir+'frismeltamask2.bin',/swap_if_big_endian
  writeu,1,frisamask
  close,1 
 endif
endif


if readrtopo2 then begin
; indir   ='/isibhv/projects/oce_rio/rtimmerm/RTopo-2/compile_rtopo2_0_3/'
; datafile='RTopo-2.0.3_1min_data_2018-09-14.nc'
; auxfile ='RTopo-2.0.3_1min_aux_2018-09-14.nc'

 indir   ='/isibhv/projects/oce_rio/rtimmerm/RTopo-2/compile_rtopo2_0_4/'
 datafile='RTopo-2.0.4_1min_data_2019-07-12.nc'
 auxfile ='RTopo-2.0.4_1min_aux_2019-07-12.nc'

 print,'load ',datafile

 filid=ncdf_open(indir+datafile)
 varid=ncdf_varid(filid,'lon')
 ncdf_varget, filid, varid, lon
 help,lon
 varid=ncdf_varid(filid,'lat')
 ncdf_varget, filid, varid, lat
 help,lat
 varid=ncdf_varid(filid,'bedrock_topography')
 ncdf_varget, filid, varid, bathy
 help,bathy
 varid=ncdf_varid(filid,'ice_base_topography')
 ncdf_varget, filid, varid, draft
 help,draft
 varid=ncdf_varid(filid,'surface_elevation')
 ncdf_varget, filid, varid, height
 help,height

 filid=ncdf_open(indir+auxfile)
 varid=ncdf_varid(filid,'lon')
 ncdf_varget, filid, varid, lonaux
 help,lonaux
 varid=ncdf_varid(filid,'lat')
 ncdf_varget, filid, varid, lataux
 help,lataux
 varid=ncdf_varid(filid,'sourcebathy')
 ncdf_varget, filid, varid, sourcebathy
 help,sourcebathy
 varid=ncdf_varid(filid,'sourcedraft')
 ncdf_varget, filid, varid, sourcedraft
 help,sourcedraft
 varid=ncdf_varid(filid,'amask')
 ncdf_varget, filid, varid, amask
 help,amask

; remove iceberg
 amask((180-45)*res:(180-35)*res,13*res:16*res) = 0
 draft((180-45)*res:(180-35)*res,13*res:16*res) = 0.
 height((180-45)*res:(180-35)*res,13*res:16*res) = 0.

 imask=amask*0
 imask(where(amask eq 1 or amask eq 2))=1
 omask=amask*0
 omask(where(amask eq 0 or amask eq 2))=1

 thick=height-draft
 thick(where(imask eq 0))=0.

 check_consistency2,bathy,draft,height,thick,amask,imask,omask,xrg,yrg,vis,'fris',6,badpoints
endif 

print,'Define dummy temperature fields: 
print,'       put +999 deg C if no ice exists, 
print,'       put -999 dec C for all existing ice.'
print,'Keep in mind that (positive) dummy temp is also put on rock outcrops!'
dummytemp= 999.
temp=thick*0. + dummytemp
temp(where(imask eq 1))= -dummytemp


if dopism then begin
 print,'incorporate PISM data of FRIS geometry'
 if coupled then begin
  print,'first read yearfromicemod.dat'
  iceyear=0
  openr,1,'./yearfromicemod.dat'
  readf,1,iceyear
  close,1 
  ciceyear=cstring(iceyear)
  print,'read data from ice year ',iceyear
  icefile=pismtopodir+'pism_to_fesom_1km_'+ciceyear+'.nc'
 endif else begin
;  icefile='/isibhv/projects/oce_rio/rtimmerm/feiom/grids/pismdata/result_3006j_equi_1km_1000yrs.nc'
  icefile='/isibhv/projects/oce_rio/rtimmerm/feiom/grids/pismdata/snap_equi_1km_1000yrs.nc_1000.000.nc'
  iceyear=45980
 endelse

 print,'open icefile=',icefile
 ncf1=ncdf_open(icefile)
 ncicelat=ncdf_varid(ncf1,'lat')
 ncicelon=ncdf_varid(ncf1,'lon')
 ncicemask=ncdf_varid(ncf1,'mask')
 ncicethck=ncdf_varid(ncf1,'thk')
 ncicerock=ncdf_varid(ncf1,'topg')
 ncicesurf=ncdf_varid(ncf1,'usurf')
 ;ncicetemp=ncdf_varid(ncf1,'T_i')    ; new for RG45983   RT 18.05.2020

 ncdf_varget,ncf1,ncicelat,icelat
 ncdf_varget,ncf1,ncicelon,icelon
 ncdf_varget,ncf1,ncicemask,icemask
 ncdf_varget,ncf1,ncicethck,icethck
 ncdf_varget,ncf1,ncicerock,icerock
 ncdf_varget,ncf1,ncicesurf,icesurf
 ;ncdf_varget,ncf1,ncicetemp,icetemp  ; new for RG45983

 icebot=icesurf-icethck            

 if 0 then begin
  loadcol,'rd.col'
  ;plotbiniez,icelat,icelon,icelat,'fris',-90.,-50,'icelat',1
  ;plotbiniez,icelon,icelon,icelat,'fris',-90.,0.,'icelon',2
  ;plotbiniez,icemask,icelon,icelat,'fris',0,5,'icemask',3
  ;plotbiniez,icethck,icelon,icelat,'fris',-2000,2000,'icethck',4
  ;plotbiniez,icerock,icelon,icelat,'fris',-2000,2000,'icerock',5
  ;plotbiniez,icesurf,icelon,icelat,'fris',-2000,2000,'icesurf',6
  ;plotbiniez,icebot,icelon,icelat,'fris',-2000,2000,'icebot',7
  ;plotbiniez,icetemp,icelon,icelat,'fris',-20.,20.,'icetemp',8
 endif

 print,'basic plausibility check'
 if min(icemask) ne 0 or max(icemask) ne 4 then begin
  print,'There are inappropriate values in icemask. The program will stop.'
  stop
 endif

 iceomask=icemask*0.+9.
 iceomask(where(round(icemask) eq 3 or round(icemask) eq 4)) = 1 ; ice shelf and open ocean
 iceomask(where(round(icemask) eq 2))                 = 0 ; grounded ice

 iceimask=icemask*0.+9.
 iceimask(where(round(icemask) eq 2 or round(icemask) eq 3)) = 1 ; grounded ice and ice shelf
 iceimask(where(round(icemask) eq 4))                        = 0 ; open ocean

 if 0 then begin
  plotbiniez,iceimask,icelon,icelat,'fris',-0.1,1.1,'iceimask',8
  plotbiniez,iceomask,icelon,icelat,'fris',-0.1,1.1,'iceomask',9
 endif

 lon=icelon
 lat=icelat
 print,'interpolate ice data to regular grid'
 pseudospherical=0
 usereflat=1
 if pseudospherical then begin 
  print,'do pseudospherical triangulation'
  y=(lat-min(lat))*111.11
  if usereflat then begin
   reflat=-80.
   print,'use reflat=',reflat,' as a reference latitude'
   x=(lon-min(lon))*111.11*cos(reflat*!dtor) 
  endif else begin
   print,'use the real latutide with 85S as southern limit'
   x=fltarr(anzrec)
   minlon=min(lon)
   for i=0,anzrec-1 do begin
    dumlat=max([lat(i),-85.])
    x(i)=(lon(i)-minlon)*111.11*cos(dumlat*!dtor)
   endfor
  endelse
  triangulate,x,y,TR
 endif else begin
  print,'do traditional triangulation'
  triangulate,lon,lat,TR
 endelse


 icebaybathy =trigrid(icelon,icelat,icerock,TR,xout=xrg,yout=yrg)
 icebaydraft =trigrid(icelon,icelat,icebot,TR,xout=xrg,yout=yrg)
 icebayheight=trigrid(icelon,icelat,icesurf,TR,xout=xrg,yout=yrg)
 icebayimask =trigrid(icelon,icelat,iceimask,TR,xout=xrg,yout=yrg)
 icebayomask =trigrid(icelon,icelat,iceomask,TR,xout=xrg,yout=yrg)
 icebaywct= icebaydraft-icebaybathy
; icebaytemp  =trigrid(icelon,icelat,icetemp,TR,xout=xrg,yout=yrg)


 if vis then begin
 ; plotbinrez,icebaybathy ,xrg,yrg,'fris',-2000.,2000.,'icebaybathy',11
 ; plotbinrez,icebaydraft ,xrg,yrg,'fris',-2000.,2000.,'icebaydraft',12
;  plotbinrez,icebaythick ,xrg,yrg,'fris',-2000.,2000.,'icebaythick',13
 ; plotbinrez,icebayheight,xrg,yrg,'fris',-2000.,2000.,'icebayheight',14
 ; plotbinrez,icebayimask ,xrg,yrg,'fris',0,0,'icebayimask',15
 ; plotbinrez,icebayomask ,xrg,yrg,'fris',0,0,'icebayomask',16
 ; plotbinrez,icebaywct,xrg,yrg,'fris',0.,0.,'icebaywct',17
 ; plotbinrez,icebaytemp,xrg,yrg,'fris',-20.,0.,'icebaytemp',18
 endif

 if 0 then begin 
; try interpolation only between ice points  - this did not work out well
  indices=where(iceimask eq 1) 
  icelati =lat(indices)
  iceloni =lon(indices)
  icethcki=icethck(indices)
  if vis then begin 
   plotbiniez,icethcki,iceloni,icelati,'fris',-2000,2000,'icethcki',16
  endif
  triangulate,iceloni,icelati,TRi
  icebaythcki=trigrid(iceloni,icelati,icethcki,TRi,xout=xrg,yout=yrg)    
 
  if vis then begin 
   plotbinrez,icebaythcki,xrg,yrg,'fris',-2000.,2000,'icebaythcki',17
  endif
 endif

 dosmooth=0
 if dosmooth then begin
  print,'smooth data'
  icebaybathy=smoothfield(icebaybathy,20,0,9999)
  icebaydraft=smoothfield(icebaydraft,20,0,9999)
  icebaythick=smoothfield(icebaythick,20,0,9999)
  icebayimask=smoothfield(icebayimask,20,0,9999)
  icebayomask=smoothfield(icebayomask,20,0,9999)
  icebaytemp =smoothfield(icebaytemp,20,0,9999)
  if vis then begin
   plotbinrez,icebaybathy,xrg,yrg,'fris',-2000.,2000.,'icebaybathy smoothed',16
   plotbinrez,icebaydraft,xrg,yrg,'fris',-2000.,2000.,'icebaydraft smoothed',17
   plotbinrez,icebaythick,xrg,yrg,'fris',-2000.,2000.,'icebaythick smoothed',18
   plotbinrez,icebayimask,xrg,yrg,'fris',0,0,'icebayimask smoothed',19  
   plotbinrez,icebayomask,xrg,yrg,'fris',0,0,'icebayomask smoothed',20
  endif
 endif  ;dosmooth

 icebayimask=round(icebayimask)
 icebayomask=round(icebayomask)
endif ;dopism'


if mergepism then begin
 print,'merge icebay patch and RTopo data into mergedbathyout etc'
 mergedbathyout  = bathy
 mergeddraftout  = draft
 mergedheightout = height
 mergedthickout  = thick
 mergedamaskout  = amask
 mergedimaskout  = imask
 mergedomaskout  = omask
 sourcebathyout  = sourcebathy
 sourcedraftout  = sourcebathy
 mergeditempout  = temp

; print,'mergepism entry consistency check'
; check_consistency2,mergedbathyout,mergeddraftout,mergedheightout,mergedthickout,$
;                    mergedamaskout,mergedimaskout,mergedomaskout,xrg,yrg,vis,'fris',6,badpoints


 for iloop=1,3 do begin
  print,'mergepism chunck ',iloop
  if iloop eq 1 then begin
   jifris=  5*res
   jefris= 14*res+res/2
   iifris= 90*res
   iefris= (180-75)*res
  endif else if iloop eq 2 then begin
   jifris=  5*res
   jefris= 15*res+res/2
   iifris= (180-75)*res+1
   iefris= (180-48)*res
  endif else if iloop eq 3 then begin
   jifris=        5*res
   jefris=       13*res
   iifris= (180-48)*res+1
   iefris=      157*res
  endif else begin
   print,'iloop error - program stops'
   stop
  endelse   
  for j=jifris,jefris do begin
   for i=iifris,iefris do begin
    if icebayimask(i,j) eq 1 then begin 
     mergeddraftout(i,j)  = icebaydraft(i,j)
     mergedbathyout(i,j)  = icebaybathy(i,j)
     mergedheightout(i,j) = icebayheight(i,j)
     ;mergeditempout(i,j)  = icebaytemp(i,j)

     if icebayomask(i,j) eq 1 then begin
      mergedimaskout(i,j) = 1
      mergedomaskout(i,j) = 1
      mergedamaskout(i,j) = 2
     endif
     if icebayomask(i,j) eq 0 then begin
      mergedimaskout(i,j) = 1
      mergedomaskout(i,j) = 0
      mergedamaskout(i,j) = 1
     endif
     sourcedraftout(i,j)  = iceyear
     sourcebathyout(i,j)  = iceyear
    endif else if icebayimask(i,j) eq 0 then begin
     mergeddraftout(i,j)  = 0.
     mergedheightout(i,j) = 0.
     ;mergeditempout(i,j)  = dummytemp
     if icebayomask(i,j) eq 1 then begin
      mergedimaskout(i,j) = 0
      mergedomaskout(i,j) = 1
      mergedamaskout(i,j) = 0
     endif
     sourcedraftout(i,j)  = iceyear
    endif
   endfor
  endfor
 endfor


 if 0 then begin
  print,'     Remove remains of Berkner Island north coast.'
  for j=round((-78.5+90.)*res),(-77+90)*res do begin
   for i=(-50+180)*res,(-42+180)*res do begin
    if mergedamaskout(i,j) eq 1 and icebayimask(i,j) eq 0 and icebayomask(i,j) eq 1 then begin
     mergedamaskout(i,j) = 0
     mergedimaskout(i,j) = 0
     mergedomaskout(i,j) = 1
    endif
   endfor
  endfor 
 endif


 mergeddraftout(where(mergedimaskout eq 0))=0.
; mergeditempout(where(mergedimaskout eq 0))=dummytemp    ; in theory this should not be needed

 indices=where(mergedamaskout eq 2 and mergeddraftout gt -1.)
 if countpoints(indices) gt 0 then mergeddraftout(indices) = -1.     ; impose minimum ice shelf draft of 1 m

 if vis then begin 
  ;plotbinrez,mergeddraftout,xrg,yrg,'fris',-2000.,2000.,'mergeddraftout',19
  plotbinrez,mergedbathyout,xrg,yrg,'fris',-2000.,2000.,'mergedbathyout',20
  ;plotbinrez,mergedamaskout,xrg,yrg,'fris',0,0,'mergedamaskout',21
  ;plotbinrez,mergedimaskout,xrg,yrg,'fris',0,0,'mergedimaskout',22
  ;plotbinrez,mergedomaskout,xrg,yrg,'fris',0,0,'mergedomaskout',23
  ;plotbinrez,sourcedraftout,xrg,yrg,'fris',0,0,'sourcedraftout',24
  ;plotbinrez,sourcebathyout,xrg,yrg,'fris',0,0,'sourcebathyout',25
  ;plotbinrez,mergeditempout,xrg,yrg,'fris',-20.,20.,'mergeditempout',26
 endif

 mergedthickout = mergedheightout-mergeddraftout
 mergedthickout(where(mergedimaskout eq 0))=0


; make_consistent2,mergedbathyout,mergeddraftout,mergedheightout,$
;                  mergedamaskout,mergedimaskout,mergedomaskout,[2,0,2,1],xrg,yrg,wctmin,vis,'fris'      ; for RAnGO-2 (RG45950)

 make_consistent2,mergedbathyout,mergeddraftout,mergedheightout,$
                  mergedamaskout,mergedimaskout,mergedomaskout,[2,2,2,1],xrg,yrg,wctmin,vis,'fris'      ; for RAnGO-2 (RG45972 from 2074 onwards)

 if vis then begin 
  plotbinrez,mergeddraftout,xrg,yrg,'fris',-2000,2000,'mergeddraftout',26
  plotbinrez,mergedamaskout,xrg,yrg,'fris',0,0,'mergedamaskout',27
  plotbinrez,mergedimaskout,xrg,yrg,'fris',0,0,'mergedimaskout',28
  plotbinrez,mergedomaskout,xrg,yrg,'fris',0,0,'mergedomaskout',29
 endif

 check_consistency2,mergedbathyout,mergeddraftout,mergedheightout,mergedthickout,$
                    mergedamaskout,mergedimaskout,mergedomaskout,xrg,yrg,vis,'fris',6,badpoints


 if dooutput then begin
  print,'outdir=',outdir
  do_output2,outdir,-iceyear,mergedbathyout,mergeddraftout,mergedheightout,mergeditempout,$
                          mergedamaskout,mergedimaskout,mergedomaskout,sourcebathyout,sourcedraftout
 endif
  if 1 then begin
 print,'13. Do NetCDF output of final dataset'
  outfile='RTopoUa.nc'
  print, 'Create '+outdir+outfile

  idout=ncdf_create(outdir+outfile,/clobber)
  NCDF_CONTROL, idout, /nofill

  ; Dimension
  xid = NCDF_DIMDEF(idout,'londim', anzxrg)
  yid = NCDF_DIMDEF(idout,'latdim', anzyrg)

 ; ; Attributs globaux
  id0 = NCDF_VARDEF(idout,'lon' ,      [xid     ], /FLOAT)
  id1 = NCDF_VARDEF(idout,'lat'  ,     [     yid], /FLOAT)
  id2 = NCDF_VARDEF(idout,'bathy',     [xid, yid], /FLOAT)
  id3 = NCDF_VARDEF(idout,'ice_bottom',[xid, yid], /FLOAT)
  id4 = NCDF_VARDEF(idout,'surf_elev', [xid, yid], /FLOAT)
  id5 = NCDF_VARDEF(idout,'amask',     [xid, yid], /BYTE)

  print,'sfter def'
  ; Variable 0
  NCDF_ATTPUT, idout, id0, 'title', 'lon'
  NCDF_ATTPUT, idout, id0, 'long_name', 'Longitude'
  NCDF_ATTPUT, idout, id0, 'units', 'degrees'

  ; Variable 1
  NCDF_ATTPUT, idout, id1, 'title', 'lat'
  NCDF_ATTPUT, idout, id1, 'long_name', 'Latitude'
  NCDF_ATTPUT, idout, id1, 'units', 'degrees'

  ; Variable 2
  NCDF_ATTPUT, idout, id2, 'title', 'bathy'
  NCDF_ATTPUT, idout, id2, 'long_name', 'Bathymetry'
  NCDF_ATTPUT, idout, id2, 'units', 'm'

  ; Variable 3
  NCDF_ATTPUT, idout, id3, 'title', 'ice_bottom'
  NCDF_ATTPUT, idout, id3, 'long_name', 'Ice bottom surface topography'
  NCDF_ATTPUT, idout, id3, 'units', 'm'

    ; Variable 4
  NCDF_ATTPUT, idout, id4, 'title', 'surf_elev'
  NCDF_ATTPUT, idout, id4, 'long_name', 'Surface elevation'
  NCDF_ATTPUT, idout, id4, 'units', 'm'

  ; Variable 5
  NCDF_ATTPUT, idout, id5, 'title', 'amask'
  NCDF_ATTPUT, idout, id5, 'long_name', 'ice ocean rock mask'
print,'befor closing'
  NCDF_CONTROL,idout, /ENDEF
print,'after closing'
  NCDF_VARPUT, idout, id0, xrg
  NCDF_VARPUT, idout, id1, yrg
  NCDF_VARPUT, idout, id2, mergedbathyout
  NCDF_VARPUT, idout, id3, mergeddraftout
  NCDF_VARPUT, idout, id4, mergedheightout
  NCDF_VARPUT, idout, id5, byte(mergedamaskout)

  print,'Output into ',outfile,' succesfully completed'
  ncdf_close,idout

 endif
endif 


;if readmergeddata then begin
; do_input,outdir,rimyear,anzxrg,anzyrg,mergedbathy2150,mergeddraft2150,mergedheight2150,mergedamask2150,mergedimask2150,mergedomask2150,sourcebathy2150,sourcedraft2150
;endif

if makecoastlines then begin
 amask=mergedamaskout
 omask=mergedomaskout

 imask=amask  ; grounded ice and ocean are ok
 imask(where(amask eq 2)) = 1   ; ice shelves
 imask(where(amask eq 3)) = 0   ; bare rock

 print,'P.1  create Rimbay coastline / grounding line for plotting'
 openw,1,outdir+runid+'.'+cstring(iceyear)+'.coast.asc'    ; coast of open ocean
 openw,2,outdir+runid+'.'+cstring(iceyear)+'.gl.asc'       ; grounding line
; openw,3,outdir+runid+'.'+cstring(iceyear)+'borders.asc'
 openw,4,outdir+runid+'.'+cstring(iceyear)+'.isf.asc'      ; ice shelf fronts
 openw,5,outdir+runid+'.'+cstring(iceyear)+'.gl.asc'      ; grounded ice limits
 icount1=0l
 icount2=0l
 icount3=0l
 icount4=0l
 icount5=0l
 for j=0,anzyrg-2 do begin
  for i=0,anzxrg-2 do begin
   if amask(i,j) ne amask(i+1,j) then begin
;    printf,3,ezmean([xrg(i),xrg(i+1)]),yrg(j)
;    icount3++
    if omask(i,j)+omask(i+1,j) eq 1 then begin
     printf,1,ezmean([xrg(i),xrg(i+1)]),yrg(j)     ; coast
     icount1++
     if imask(i,j)+imask(i+1,j) gt 0 then begin
      printf,5,ezmean([xrg(i),xrg(i+1)]),yrg(j)    ; GIL: grounded ice limit
      icount5++
     endif else if imask(i,j)+imask(i+1,j) eq 2 then begin
      printf,2,ezmean([xrg(i),xrg(i+1)]),yrg(j)    ; GL
      icount2++
     endif
    endif else begin
     if omask(i,j)+omask(i+1,j) eq 2 then begin
      printf,4,ezmean([xrg(i),xrg(i+1)]),yrg(j)    ; ice shelf front
      icount4++
     endif else if imask(i,j)+imask(i+1,j) eq 1 then begin
      printf,5,ezmean([xrg(i),xrg(i+1)]),yrg(j)    ; GIL: grounded ice limit (rock outcrop)
      icount5++       
     endif else begin
      print,'Unrecognized case in i. The program will stop.'
      print,i,j,amask(i,j),imask(i,j),omask(i,j),amask(i+1,j),imask(i+1,j),omask(i+1,j)
      stop
     endelse
    endelse
   endif
  endfor
 endfor
 for j=0,anzyrg-2 do begin
  for i=0,anzxrg-2 do begin
   if amask(i,j) ne amask(i,j+1) then begin
;    printf,3,xrg(i),ezmean([yrg(j),yrg(j+1)])
;    icount3++
    if omask(i,j)+omask(i,j+1) eq 1 then begin
     printf,1,xrg(i),ezmean([yrg(j),yrg(j+1)])
     icount1++
     if imask(i,j)+imask(i,j+1) gt 0 then begin
      printf,5,xrg(i),ezmean([yrg(j),yrg(j+1)])
      icount5++
     endif
     if imask(i,j)+imask(i,j+1) eq 2 then begin
      printf,2,xrg(i),ezmean([yrg(j),yrg(j+1)])
      icount2++
     endif
    endif else if omask(i,j)+omask(i,j+1) eq 2 then begin
     printf,4,xrg(i),ezmean([yrg(j),yrg(j+1)])
     icount4++
    endif else if imask(i,j)+imask(i,j+1) eq 1 then begin
     printf,5,xrg(i),ezmean([yrg(j),yrg(j+1)])    ; GIL: grounded ice limit (rock outcrop)
     icount5++       
    endif else begin
     print,'Unrecognized case in j. The program will stop.'
     stop
    endelse
   endif
  endfor
 endfor
 close,1
 close,2
; close,3
 close,4
 close,5

 print,'now add number of entries in first line of files'
 openr,1,outdir+'RTopo_1.5.0.rim2150.coast.asc'    ; coast of open ocean
 openr,2,outdir+'RTopo_1.5.0.rim2150.gl.asc'       ; grounding line
; openw,3,outdir+'RTopo_1.5.0.borders.asc'
 openr,4,outdir+'RTopo_1.5.0.rim2150.isf.asc'      ; ice shelf fronts
 openr,5,outdir+'RTopo_1.5.0.rim2150.gl.asc'      ; grounded ice limits

 data1=fltarr(2,icount1)
 readf,1,data1
 data2=fltarr(2,icount2)
 readf,2,data2
 data4=fltarr(2,icount4)
 readf,4,data4
 data5=fltarr(2,icount5)
 readf,5,data5

 close,1
 close,2
; close,3
 close,4
 close,5
 
 openw,1,outdir+'RTopo_1.5.0.rim2150.coast.asc'    ; coast of open ocean
 openw,2,outdir+'RTopo_1.5.0.rim2150.gl.asc'       ; grounding line
; openw,3,outdir+'RTopo_1.5.0.borders.asc'
 openw,4,outdir+'RTopo_1.5.0.rim2150.isf.asc'      ; ice shelf fronts
 openw,5,outdir+'RTopo_1.5.0.rim2150.gl.asc'      ; grounded ice limits

 printf,1,icount1
 printf,2,icount2
 printf,4,icount4
 printf,5,icount5

 printf,1,data1
 printf,2,data2
 printf,4,data4
 printf,5,data5	

 close,1
 close,2
; close,3
 close,4
 close,5
endif

;stop  ; activate to make plots for debugging

;if coupled then exit

end

