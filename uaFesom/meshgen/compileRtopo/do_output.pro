pro do_output,outdir,rank,mergedbathy,mergeddraft,mergedheight,mergedamask,mergedimask,mergedomask,sourcebathy,sourcedraft

crank=cstring(rank)

print,'write mergedbathy'+crank+' to file'
openw,1,outdir+'mergedbathy'+crank+'.bin',/swap_if_big_endian
writeu,1,mergedbathy
close,1
print,'write sourcebathy'+crank+' to file'
openw,1,outdir+'sourcebathy'+crank+'.bin',/swap_if_big_endian
writeu,1,sourcebathy
close,1
print,'write mergeddraft'+crank+' to file'
openw,1,outdir+'mergeddraft'+crank+'.bin',/swap_if_big_endian
writeu,1,mergeddraft
close,1
print,'write sourcedraft'+crank+' to file'
openw,1,outdir+'sourcedraft'+crank+'.bin',/swap_if_big_endian
writeu,1,sourcedraft
close,1
print,'write mergedheight'+crank+' to file'
openw,1,outdir+'mergedheight'+crank+'.bin',/swap_if_big_endian
writeu,1,mergedheight
close,1
print,'write mergedamask'+crank+' to file'
openw,1,outdir+'mergedamask'+crank+'.bin',/swap_if_big_endian
writeu,1,mergedamask
close,1
print,'write mergedimask'+crank+' to file'
openw,1,outdir+'mergedimask'+crank+'.bin',/swap_if_big_endian
writeu,1,mergedimask
close,1
print,'write mergedomask'+crank+' to file'
openw,1,outdir+'mergedomask'+crank+'.bin',/swap_if_big_endian
writeu,1,mergedomask
close,1

print,'output of step',rank,' completed.'
return
end
