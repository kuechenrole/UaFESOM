#!/bin/tcsh

#to be run from $masterdir
set oldrunid="$1"
set newrunid="$2"

setenv awiuser orichter
setenv hlrnuser hbkorich
setenv hlrnproject hbk00097

setenv masterdir $HOME/timms

#FESOM @ HLRN:
setenv fesomuser $hlrnuser
setenv fesomhost blogin.hlrn.de
setenv fesommeshdir /scratch/projects/$hlrnproject/mesh
setenv fesomrundir /home/$hlrnuser/run
setenv fesomresultsdir /scratch/projects/$hlrnproject/results

#UA @ albedo
setenv uauser $awiuser
setenv uahost albedo1
setenv uadatadir /albedo/work/projects/oce_rio/$awiuser/uacpl/data
setenv uaresultsdir /albedo/work/projects/oce_rio/$awiuser/uacpl/results
setenv uarstdir /albedo/work/projects/oce_rio/$awiuser/uacpl/restart
setenv uarundir /albedo/home/$awiuser/uacpl

#UA @ ollie
#setenv uauser $awiuser
#setenv uahost ollie1.awi.de
#setenv uadatadir /work/ollie/$awiuser/uacpl/data
#setenv uaresultsdir /work/ollie/$awiuser/uacpl/results
#setenv uarstdir /work/ollie/$awiuser/uacpl/restart
#setenv uarundir /home/ollie/$awiuser/uacpl

setenv timmsdatadir /isibhv/netscratch/orichter/timmsdata
setenv timmsmeshdir /isibhv/netscratch/orichter/timmsmesh

echo "set up timms"
set dirs = ($masterdir $timmsdatadir $timmsmeshdir)
foreach diri ($dirs)
	mkdir $diri/$newrunid
end

cp -r $masterdir/$oldrunid/* $masterdir/$newrunid/.
sed -i "s~$oldrunid~$newrunid~g" $masterdir/$newrunid/timms.csh
sed -i "s~finyear 1200~finyear 1100~" $masterdir/$newrunid/timms.csh
cp -r $timmsmeshdir/$oldrunid/1000.00 $timmsmeshdir/$newrunid/.
#cp -r $timmsmeshdir/$oldrunid/extended $timmsmeshdir/$newrunid/.
rm $masterdir/$newrunid/ice2oce* $masterdir/$newrunid/oce2ice* $masterdir/$newrunid/slurm* $masterdir/$newrunid/$oldrunid.clock


echo "set up fesom"
set dirs = ($fesommeshdir $fesomrundir $fesomresultsdir)
foreach diri ($dirs)
        ssh -i $HOME/.ssh/id_rsa_hlrn -t $fesomuser@$fesomhost mkdir $diri/$newrunid
end 

ssh -i $HOME/.ssh/id_rsa_hlrn -t $fesomuser@$fesomhost cp $fesomresultsdir/startIdealised.clock $fesomresultsdir/$newrunid/$newrunid.clock
#ssh -i $HOME/.ssh/id_rsa_hlrn -t $fesomuser@$fesomhost cp $fesomresultsdir/$oldrunid/$oldrunid.1978.oce.ini.nc $fesomresultsdir/$newrunid/$newrunid.1978.oce.ini.nc
#ssh -i $HOME/.ssh/id_rsa_hlrn -t $fesomuser@$fesomhost cp $fesomresultsdir/$oldrunid/$oldrunid.1978.ice.ini.nc $fesomresultsdir/$newrunid/$newrunid.1978.ice.ini.nc
ssh -i $HOME/.ssh/id_rsa_hlrn -t $fesomuser@$fesomhost cp -r $fesomrundir/$oldrunid/\* $fesomrundir/$newrunid/.
ssh -i $HOME/.ssh/id_rsa_hlrn -t $fesomuser@$fesomhost rm $fesomrundir/$newrunid/slurm-\*.out
ssh -i $HOME/.ssh/id_rsa_hlrn -t $fesomuser@$fesomhost sed -i "s~$oldrunid~$newrunid~g" $fesomrundir/$newrunid/{namelist.config,fesom_newyear.slurm}
ssh -i $HOME/.ssh/id_rsa_hlrn -t $fesomuser@$fesomhost sed -i "s~MeshPath=.*~MeshPath=''\''$fesommeshdir/$newrunid/1000.00/'\'''~" $fesomrundir/$newrunid/namelist.config
ssh -i $HOME/.ssh/id_rsa_hlrn -t $fesomuser@$fesomhost sed -i "s~yearnew=.*~yearnew=1000~" $fesomrundir/$newrunid/namelist.config
ssh -i $HOME/.ssh/id_rsa_hlrn -t $fesomuser@$fesomhost sed -i "s~case_forcing=.*~case_forcing='warm'~" $fesomrundir/$newrunid/namelist.config
ssh -i $HOME/.ssh/id_rsa_hlrn -t $fesomuser@$fesomhost cp -r $fesommeshdir/$oldrunid/1000.00 $fesommeshdir/$newrunid/.
ssh -i $HOME/.ssh/id_rsa_hlrn -t $fesomuser@$fesomhost mkdir $fesommeshdir/$newrunid/1000.00/dist

echo "set up ua"
set dirs = ($uadatadir $uaresultsdir $uarstdir $uarundir)
foreach diri ($dirs)
        ssh -i $HOME/.ssh/id_rsa_linsrv1-albedo -t $uauser@$uahost mkdir $diri/$newrunid
end

ssh -i $HOME/.ssh/id_rsa_linsrv1-albedo -t $uauser@$uahost cp -r $uarundir/$oldrunid/\* $uarundir/$newrunid/.
ssh -i $HOME/.ssh/id_rsa_linsrv1-albedo -t $uauser@$uahost rm $uarundir/$newrunid/slurm-\*.out
ssh -i $HOME/.ssh/id_rsa_linsrv1-albedo -t $uauser@$uahost sed -i "s~$oldrunid~$newrunid~g" $uarundir/$newrunid/{DefineInitialInputs.m,ua_cpl.slurm}
ssh -i $HOME/.ssh/id_rsa_linsrv1-albedo -t $uauser@$uahost sed -i 's~UserVar.CouplingStart=.\*~UserVar.CouplingStart=1\;~' $uarundir/$newrunid/DefineInitialInputs.m
ssh -i $HOME/.ssh/id_rsa_linsrv1-albedo -t $uauser@$uahost cp -r $uadatadir/$oldrunid/\* $uadatadir/$newrunid/.
ssh -i $HOME/.ssh/id_rsa_linsrv1-albedo -t $uauser@$uahost rm $uadatadir/$newrunid/Fab.*
ssh -i $HOME/.ssh/id_rsa_linsrv1-albedo -t $uauser@$uahost cp $uarstdir/$oldrunid/RestartMismipPlus-spinup_W.mat $uarstdir/$newrunid/.

echo "archive initial fesom and ua setup"
set dirs = (uasource fesomsource uadata)
foreach diri ($dirs)
  mkdir $timmsdatadir/$newrunid/$diri
end

scp -r -i $HOME/.ssh/id_rsa_linsrv1-albedo $uauser@$uahost":"/$uadatadir/$newrunid/\* $timmsdatadir/$newrunid/uadata/.
scp -r -i $HOME/.ssh/id_rsa_linsrv1-albedo $uauser@$uahost":"/$uarundir/$newrunid/\* $timmsdatadir/$newrunid/uasource/.
scp -r -i $HOME/.ssh/id_rsa_hlrn $fesomuser@$fesomhost":"/$fesomrundir/$newrunid/\* $timmsdatadir/$newrunid/fesomsource/.



