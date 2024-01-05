#!/bin/csh

setenv firsttime $1

date

if ($firsttime == yes) then
  echo "firsttime=yes: sleep for 180 seconds"
  #sleep 180
  sleep 20
else
  echo "firsttime=no: sleep for 60 seconds"
  sleep 60
  #sleep 1 
endif

scp -i $HOME/.ssh/id_rsa_hlrn $fesomuser@$fesomhost':'/$fesomrundir/jobid.dat .
set ID=`cat jobid.dat`
set jobfile="slurm-$ID.out"
scp -i $HOME/.ssh/id_rsa_hlrn $fesomuser@$fesomhost':'/$fesomrundir/$jobfile .



if (! -e "$jobfile") then
   echo "$jobfile does not yet exist. Check again in 1 minute."
   ./check4fesomdata.csh no >> check4fesomdata.log &
   exit
endif

scp -i $HOME/.ssh/id_rsa_hlrn $fesomuser@$fesomhost':'/$fesomrundir/namelist.config .

if ( `grep -c "The model will blow up!" $jobfile` != 0) then
    echo "Blow-up statement in $jobfile detected!"
    mv $jobfile $jobfile.canceled
    set value=`grep "step_per_day" namelist.config | cut -d '=' -f2 | cut -d '!' -f1`
    if ( $value < 2880 ) then
       @ newValue= $value * 2
       echo "Adjusting step_per_day from $value to $newValue and start fesom again."
       sed -i "s~step_per_day=.*~step_per_day=$newValue~" namelist.config
       echo "Relaunch fesom with adjusted time step."
       scp -i $HOME/.ssh/id_rsa_hlrn namelist.config $fesomuser@$fesomhost':'/$fesomrundir/.
       ssh -i $HOME/.ssh/id_rsa_hlrn -t $fesomuser@$fesomhost $fesomrundir/launch_fesom_newyear.bash $fesomrundir
       echo "check again in 1 minutes"
       ./check4fesomdata.csh no >> check4fesomdata.log &
       exit
    else
       echo "Time step_per_day is already >= 2880. We do nothing and stop the loop."
       exit
    endif
else if ( `grep -c "successfully completed" $jobfile` != 0) then
    echo "Fesom has successfully completed."
    set value=`grep "step_per_day" namelist.config | cut -d '=' -f2 | cut -d '!' -f1`
      if ( $value > 180 ) then
        @ newValue= $value / 2
        echo "adjusting step_per_day from $value to $newValue."
        sed -i "s~step_per_day=.*~step_per_day=$newValue~" namelist.config
      else
        echo "Time step_per_day is already = 360."
      endif
    echo "copy back namelist.config"
    scp -i $HOME/.ssh/id_rsa_hlrn namelist.config $fesomuser@$fesomhost':'/$fesomrundir/.
    echo "launch timms.csh ocean2ice all"
    ./timms.csh ocean2ice all > oce2ice_$oldYear.$oldMonth.log &
    echo "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
    echo "Mr. Timms oce2ice has been launched"
    echo "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
else
    echo "Neither blowup nor completed statement found. Check again in 1 min."
    ./check4fesomdata.csh no >> check4fesomdata.log &
endif
exit
