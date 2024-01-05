#!/bin/csh

setenv firsttime $1

date

if ($firsttime == yes) then
  echo "firsttime=yes: sleep for 60 seconds"
  sleep 60
else
  echo "firsttime=no: sleep for 15 seconds"
  sleep 60 
endif

date
echo "The year to wait for is " $newYear.$newMonth

echo "check if $uaresultsdir/$newYear.$newMonth-Nodes*.mat exist at $uauser@$uahost" 
ssh -i $HOME/.ssh/id_rsa_linsrv1-albedo -t $uauser@$uahost ls "$uaresultsdir/$newYear.$newMonth-Nodes*.mat"
#scp -i $HOME/.ssh/id_rsa $uauser@$uahost":/$uaresultsdir/$newYear.$newMonth-Nodes*.mat" $timmsdatadir
if ($status == 0) then
   sleep 2
   echo "Ua results file exists: launch Mr. Timms ice2ocean"
   ./timms.csh ice2ocean all > ice2oce_$newYear.$newMonth.log &

   echo "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
   echo "MrTimms.csh ice2ocean has been launched, check4uadata terminates succefully"
   echo "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
else
   echo "Ua results does not exist: check again in 1 minute."
   ./check4uadata.csh no >> check4uadata.log  &
endif
exit

