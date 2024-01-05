#!/bin/csh

echo "in getfesomdata.csh"

set names = ('ice.diag' 'ice.mean' 'mesh.diag' 'oce.diag' 'oce.mean' 'oce' 'ice' 'ice.ini' 'oce.ini')
foreach name ($names)
 scp -i $HOME/.ssh/id_rsa_hlrn $fesomuser@$fesomhost':'/$fesomdatadir/$runid.$oldYear.$oldMonth.$name.nc $timmsdatadir
 if ($status != 0) then
 echo "---------------------------------------------------------------------------------------------------------"
 echo "Attempt to move" $fesomuser@$fesomhost':'/$fesomdatadir/$runid.$oldYear.$oldMonth.$name.nc" to copy $name failed."
 echo "Exit."
 echo "---------------------------------------------------------------------------------------------------------"
 exit
 endif
 echo "$name is done"
end

echo "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
echo "getfesomdata succesfully completed"
echo "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"

exit
