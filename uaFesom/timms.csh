#!/bin/tcsh

#to be run from $masterdir

setenv runid io0036
setenv startYear 1979
setenv finyear 2018
setenv ndpyr 365

setenv awiuser orichter
setenv hlrnuser hbkorich
setenv hlrnproject hbk00097

setenv masterdir $HOME/timms/$runid

#FESOM @ HLRN:
setenv fesomuser $hlrnuser
setenv fesomhost blogin.hlrn.de
setenv fesommeshdir /scratch/projects/$hlrnproject/mesh/$runid
setenv fesomrundir /home/$hlrnuser/run/$runid
setenv fesomresultsdir /scratch/projects/$hlrnproject/results/$runid

#UA @ albedo
setenv uauser $awiuser
setenv uahost albedo1
setenv uadatadir /albedo/work/projects/oce_rio/$awiuser/uacpl/data/$runid
setenv uaresultsdir /albedo/work/projects/oce_rio/$awiuser/uacpl/results/$runid
setenv uarstdir /albedo/work/projects/oce_rio/$awiuser/uacpl/restart/$runid
setenv uarundir /albedo/home/$awiuser/uacpl/$runid


setenv run_on_host unknown
if ($HOME == /home/csys/$awiuser) setenv run_on_host AWI
if ($HOME == /home/$hlrnuser) setenv run_on_host HLRN
if ($HOME == /albedo/home/$awiuser) setenv run_on_host ALBEDO

# specific to AWI
if ($run_on_host == AWI) then
 setenv timmsdatadir /isibhv/netscratch/orichter/timmsdata/$runid
 setenv timmsmeshdir /isibhv/netscratch/orichter/timmsmesh/$runid
endif


# no users below this line
printf '%s\n' "=====================================================================  ;,//;,    ,;/ ================"
printf '%s\n' "                                  Welcome to Mr. Timms                o:::::::;;///                  "
printf '%s\n' "==================================================================== >::::::::;;\\\ ================="
printf '%s\n' "                                                                       ''\\\\\'' ';\                 "

echo "running on host" $run_on_host
echo 'masterdir='$masterdir
cd $masterdir

setenv CLOCKFILE $runid.clock
echo 'CLOCKFILE is' $CLOCKFILE

echo "========================"
echo "getclockfile"
echo "========================"

scp -i $HOME/.ssh/id_rsa_hlrn $fesomuser@$fesomhost':'/$fesomresultsdir/$CLOCKFILE .
if ($status != 0) then
 echo "--------------------------------------------------------------------------------------"
 echo "Attempt to copy" $fesomuser@$fesomhost':'/$fesomresultsdir/$CLOCKFILE " to masterdir failed."
 echo "Exit."
 echo "--------------------------------------------------------------------------------------"
 exit
endif
scp -i $HOME/.ssh/id_rsa_hlrn $fesomuser@$fesomhost':'/$fesomrundir/namelist.config .
if ($status != 0) then
 echo "--------------------------------------------------------------------------------------"
 echo "Attempt to copy" $fesomuser@$fesomhost':'/$fesomrundir/namelist.config " to masterdir failed."
 echo "Exit."
 echo "--------------------------------------------------------------------------------------"
 exit
endif

echo "======================================="
echo "extract data from FESOM clockfile "
echo "======================================="
#VAR11=`awk -F";" 'NR == [ZEILE] { print $1}' $FILE | awk '{print $[SPALTE]}'`
setenv oldTime `awk -F";" 'NR == 1 { print $1}' $CLOCKFILE | awk '{print $1}'`
setenv oldDay `awk -F";" 'NR == 1 { print $1}' $CLOCKFILE | awk '{print $2}'`
setenv oldYear `awk -F";" 'NR == 1 { print $1}' $CLOCKFILE | awk '{print $3}'`
setenv newTime `awk -F";" 'NR == 2 { print $1}' $CLOCKFILE | awk '{print $1}'`
setenv newDay `awk -F";" 'NR == 2 { print $1}' $CLOCKFILE | awk '{print $2}'`
setenv newYear `awk -F";" 'NR == 2 { print $1}' $CLOCKFILE | awk '{print $3}'`
setenv newMonth `echo "scale=6; $newDay/$ndpyr*12" | bc | xargs printf "%02.0f"`
setenv stepMonth `grep "run_length=" namelist.config | cut -d "=" -f2`
if ($newDay == 1) then
    setenv yearFrac  `printf "%.11f" "0" | cut -d "," -f2`
    setenv oldMonth  `echo "scale=6; 12-$stepMonth" | bc | xargs printf "%02.0f"`
else
    setenv yearFrac  `echo "scale=12; $newDay / $ndpyr" | bc | xargs printf "%.11f" | cut -d "," -f2 `
    setenv oldMonth  `echo "scale=6; $newMonth-$stepMonth" | bc | xargs printf "%02.0f"`
endif
echo "$oldYear"
echo $oldMonth
echo "$newYear"
echo $newMonth
echo $yearFrac

echo "========================"
echo "go to" $1
echo "========================"
goto $1
 
ice2ocean:
getuadata:
echo "==========="
echo "get ua data"
echo "==========="

echo "archive ua output using oldyear.oldmonth format and copy it to $timmsdatadir"
ssh -i $HOME/.ssh/id_rsa_linsrv1-albedo -t $uauser@$uahost cp $uarstdir/Restart-Forward-Transient.mat $uarstdir/Restart-Forward-Transient.$oldYear.$oldMonth.mat
scp -i $HOME/.ssh/id_rsa_linsrv1-albedo $uauser@$uahost":"/$uarstdir/Restart-Forward-Transient.$oldYear.$oldMonth.mat $timmsdatadir/.
if ($status != 0) then
 echo "---------------------------------------------------------------------------------------------------------"
 echo "Attempt to move" $uauser@$uahost':'$uarstdir/Restart-Forward-Transient.$oldYear.$oldMonth.mat" failed."
 echo "Exit."
 echo "---------------------------------------------------------------------------------------------------------"
 exit
endif

scp -i $HOME/.ssh/id_rsa_linsrv1-albedo $uauser@$uahost":"/$uaresultsdir/$newYear.$newMonth-Nodes\*.mat $timmsdatadir/.
if ($status != 0) then
 echo "---------------------------------------------------------------------------------------------------------"
 echo "Attempt to move" $uauser@$uahost':'$uaresultsdir/$newYear.$newMonth-Nodes\*.mat" failed."
 echo "Exit."
 echo "---------------------------------------------------------------------------------------------------------"
 exit
endif

if ($2 == 'only') then
 echo "==========================================="
 echo "exit after meshgen has been completed"
 echo "==========================================="
 exit
endif



meshgen:
echo "=========================================="
echo 'compiling the mesh'
echo "=========================================="

setenv newmeshdir $timmsmeshdir/$newYear.$newMonth
setenv uaresultfile $timmsdatadir/$newYear.$newMonth-Nodes*.mat
setenv goodfile $timmsmeshdir/meshgen.goodfile.$newYear.$newMonth

mkdir -p $newmeshdir/dist

echo "======================"
echo 'running ua2rtopo.m'
echo "======================"
cd $masterdir/meshgen/ua2rtopo
sed -i "s~meshOutPath=.*~meshOutPath='$newmeshdir/';~" ua2rtopo.m
sed -i "s~uaResultFile=.*~uaResultFile='$uaresultfile';~" ua2rtopo.m
#matlab.sh -s -S"-wprod-0304 --mem=20gb" -M"-nojvm -r run('ua2rtopo.m')"
matlab -nojvm -r "maxNumCompThreads(4); ua2rtopo; exit;"
#cpulimit -l 200 -f -- matlab -nojvm -r "ua2rtopo; exit;"

echo "======================"
echo 'running compile_rtopo_ua.pro'
echo "======================"
cd $masterdir/meshgen/compileRtopo
echo "$newmeshdir//" > meshdir.asc
cpulimit -l 200 -f -- idl -IDL_STARTUP run_compile_rtopo.pro
#/global/AWIsoft/IDL/8.6.1/idl86/bin/idl run_compile_rtopo.pro
 
echo "======================"
echo 'now running compileFesom scripts'
echo "======================"
cd $masterdir/meshgen/compileFesom
sed -i "s~goodfile_path=.*~goodfile_path='$goodfile';~" runCompileFesom.m
sed -i "s~meshOutPath=.*~meshOutPath='$newmeshdir/';~" runCompileFesom.m
sed -i "s~extendedMeshPath=.*~extendedMeshPath='$timmsmeshdir/extended/';~" runCompileFesom.m
sed -i "s~uaResultFile=.*~uaResultFile='$uaresultfile';~" runCompileFesom.m
#matlab.sh -s -S"-wprod-0304 --mem=40gb" -M"-nojvm -r run('runCompileFesom.m')"  #> meshgen.$yearfromicemod.log
 #matlab.sh -s -M" -nodisplay -r run('~/test.m')" -S"--time=6:00:00 -c4 --mem=10000"
matlab -nojvm -r "maxNumCompThreads(4); runCompileFesom; exit;"
#cpulimit -l 200 -f -- matlab -nojvm -r "runCompileFesom; exit;"


cd $masterdir
if (-e $goodfile) then
 echo "||||||||||||||||||||||||||||"
 echo "returned from meshgen.m ok. Delete intermediate files."
 echo "||||||||||||||||||||||||||||"
 rm $timmsmeshdir/*.nc
else
 echo ----------------------------------------------
 echo 'returned from meshgen.m accidentally: stop'
 echo ----------------------------------------------
 exit
endif

if ($2 == 'only') then
 echo "==========================================="
 echo "exit after meshgen has been completed"
 echo "==========================================="
 exit
endif

remapfesom:
echo "================================================="
echo 'now remap fesom data to new mesh'
echo "================================================="

setenv newmeshdir $timmsmeshdir/$newYear.$newMonth
setenv oldmeshdir $timmsmeshdir/$oldYear.$oldMonth

setenv oldocefile $timmsdatadir/$runid.$oldYear.$oldMonth.oce.nc
setenv oldicefile $timmsdatadir/$runid.$oldYear.$oldMonth.ice.nc
setenv newocefile $timmsdatadir/$runid.$newYear.$newMonth.oce.ini.nc
setenv newicefile $timmsdatadir/$runid.$newYear.$newMonth.ice.ini.nc

echo "from: "
echo $oldmeshdir
echo $oldocefile
echo $oldicefile

echo ""
echo "to: "
echo $newmeshdir
echo $newocefile
echo $newicefile

sed -i "s~oldOceFile=.*~oldOceFile='$oldocefile';~" remap.m
sed -i "s~newOceFile=.*~newOceFile='$newocefile';~" remap.m
sed -i "s~oldIceFile=.*~oldIceFile='$oldicefile';~" remap.m
sed -i "s~newIceFile=.*~newIceFile='$newicefile';~" remap.m
sed -i "s~oldMeshPath=.*~oldMeshPath='$oldmeshdir/';~" remap.m
sed -i "s~newMeshPath=.*~newMeshPath='$newmeshdir/';~" remap.m

#matlab.sh -s -S"-wprod-0304 --mem=20gb" -M"-nojvm -r run('remap.m')"
matlab -nojvm -r "maxNumCompThreads(4); remap; exit;"

if ($2 == 'only') then
 echo "==========================================="
 echo "exit after remap_data has been completed"
 echo "==========================================="
 exit
endif

prepare4fesom:
echo "============="
echo 'prepare fesom'
echo "============="

setenv newmeshdir $timmsmeshdir/$newYear.$newMonth
setenv newocefile $timmsdatadir/$runid.$newYear.$newMonth.oce.ini.nc
setenv newicefile $timmsdatadir/$runid.$newYear.$newMonth.ice.ini.nc

echo "copy new mesh and ini files to remote server"
scp -r $newmeshdir $fesomuser@$fesomhost':'$fesommeshdir/.
scp $newocefile $fesomuser@$fesomhost':'$fesomresultsdir/$runid.$oldYear.oce.ini.nc
scp $newicefile $fesomuser@$fesomhost':'$fesomresultsdir/$runid.$oldYear.ice.ini.nc

echo 'now modify namelist.config using year '$oldYear' and mesh '$newmeshdir
sed -i "s~yearnew=.*~yearnew=$oldYear~" namelist.config
sed -i "s~MeshPath=.*~MeshPath='$fesommeshdir/$newYear.$newMonth/'~" namelist.config
scp namelist.config $fesomuser@$fesomhost':'$fesomrundir/.

echo 'remove mesh/dist folder from last year'
ssh -t $fesomuser@$fesomhost rm -r $fesommeshdir/$oldYear.$oldMonth/dist

if ($2 == 'only') then
 echo "==========================================="
 echo "exit after prepare_fesom has been completed"
 echo "==========================================="
 exit
endif

start:
launchfesom:
echo "=========================================="
echo 'now launch fesom'
echo "=========================================="

ssh -i $HOME/.ssh/id_rsa_hlrn -t $fesomuser@$fesomhost $fesomrundir/launch_fesom_newyear.bash $fesomrundir
if ($status != 0) then
 echo "-----------------------------------------"
 echo "Attempt to launch FESOM has failed. Exit."
 echo "-----------------------------------------"
 exit
endif

if ($2 == 'only') then
 echo "==========================================="
 echo "exit after launch_fesom has been completed"
 echo "==========================================="
 exit
endif


launchfesomlookup:
date
echo "=========================================="
echo 'now launch sleeping lookup job'
echo "=========================================="

./check4fesomdata.csh yes > check4fesomdata.log &
#./check4fesomdata.csh yes > $timmsoutdir/check4fesomdata.log &
sleep 2

echo "================================================="
echo "Mr. Timms script completed; FESOM now runs for year $newYear and month $newMonth"
echo "================================================="

exit

# end of ocean to ice
# #######################################################################################################
# # start of ice to ocean    

ocean2ice:

getfesomdata:
echo "==========="
echo "get fesom data"
echo "==========="

echo "archive fesom output using oldyear.oldmonth format and copy it to $timmsdatadir"
set names = ('forcing.diag' 'ice.diag' 'ice.mean' 'mesh.diag' 'oce.diag' 'oce.mean' 'oce' 'ice')
foreach name ($names)
 ssh -i $HOME/.ssh/id_rsa_hlrn -t $fesomuser@$fesomhost cp $fesomresultsdir/$runid.$oldYear.$name.nc $fesomresultsdir/$runid.$oldYear.$oldMonth.$name.nc
 scp -i $HOME/.ssh/id_rsa_hlrn $fesomuser@$fesomhost':'/$fesomresultsdir/$runid.$oldYear.$oldMonth.$name.nc $timmsdatadir
 if ($status != 0) then
 echo "---------------------------------------------------------------------------------------------------------"
 echo "Attempt to move" $fesomuser@$fesomhost':'/$fesomresultsdir/$runid.$oldYear.$oldMonth.$name.nc" failed."
 echo "Exit."
 echo "---------------------------------------------------------------------------------------------------------"
 exit
 endif
 echo "$name is done"
end

chmod +r $timmsdatadir/*

if ($2 == 'only') then
 echo "==========================================="
 echo "exit after getdata has been completed"
 echo "==========================================="
 exit
endif

melt2ua:
echo "========================"
echo " run melt2ua"
echo "========================"

setenv fesommeltfile $timmsdatadir/$runid.$oldYear.$oldMonth.forcing.diag.nc
setenv fesommeshpath $timmsmeshdir/$oldYear.$oldMonth/
setenv interpolantfile $timmsdatadir/Fab.$oldYear.$oldMonth.mat
echo "using" $fesommeltfile " and" $fesommeshpath " for current ua melt rates."
sed -i "s~fesomMeltPath=.*~fesomMeltPath= '$fesommeltfile';~" makeMeltInterpolant.m
sed -i "s~fesomMeshPath=.*~fesomMeshPath= '$fesommeshpath';~" makeMeltInterpolant.m
sed -i "s~interpolantOutPath=.*~interpolantOutPath= '$interpolantfile';~" makeMeltInterpolant.m
matlab -nojvm -r "maxNumCompThreads(4); makeMeltInterpolant; exit;"

if ($2 == 'only') then
 echo "==========================================="
 echo "exit after melt2ua has been completed"
 echo "==========================================="
 exit
endif



prepare4ua:
echo "========================"
echo " run prepare4ua"
echo "========================"

echo $newYear.$yearFrac 
echo "using "$newYear.$yearFrac " for current ua step."
scp -i $HOME/.ssh/id_rsa_linsrv1-albedo $uauser@$uahost':'/$uarundir/DefineInitialInputs.m .
sed -i "s/CtrlVar.TotalTime=.*/CtrlVar.TotalTime=$newYear.$yearFrac;/" DefineInitialInputs.m
sed -i "s/UserVar.StartOutputID=.*/UserVar.StartOutputID='$oldYear.$oldMonth';/" DefineInitialInputs.m
sed -i "s/UserVar.FinalOutputID=.*/UserVar.FinalOutputID='$newYear.$newMonth';/" DefineInitialInputs.m
sed -i "s/UserVar.BasalMassBalanceInterpolant=.*/UserVar.BasalMassBalanceInterpolant=[UserVar.InputDir,'Fab.$oldYear.$oldMonth.mat'];/" DefineInitialInputs.m
scp -i $HOME/.ssh/id_rsa_linsrv1-albedo DefineInitialInputs.m $uauser@$uahost':'/$uarundir/.

if ($status != 0) then
 echo "--------------------------------------------------------------------------------------"
 echo "Attempt to configure DefineInitialInputs.m failed. "
 echo "Exit."
 echo "--------------------------------------------------------------------------------------"
 exit
endif


echo "copy melt interpolant to $uauser@$uahost':'/$uadatadir/Fab.$oldYear.$oldMonth.mat"
scp -i $HOME/.ssh/id_rsa_linsrv1-albedo $timmsdatadir/Fab.$oldYear.$oldMonth.mat $uauser@$uahost':'/$uadatadir/.

if ($status != 0) then
 echo "--------------------------------------------------------------------------------------"
 echo "Attempt to copy current melt rate interpolant failed. "
 echo "Exit."
 echo "--------------------------------------------------------------------------------------"
 exit
endif

if ($2 == 'only') then
 echo "==========================================="
 echo "exit after prepare4ua has been completed"
 echo "==========================================="
 exit
endif

launchua:                        
echo "==============="
echo "now launch Ua"
echo "==============="
ssh -i $HOME/.ssh/id_rsa_linsrv1-albedo -t $uauser@$uahost $uarundir/launch_ua_cpl.bash $uarundir

if ($2 == 'only') then
 echo "======================================================"
 echo "exit after launchua has been completed"
 echo "======================================================"
 exit
endif

if ($newYear >= $finyear) then
 echo "==================================================================================="
 echo "exit after launchua has been completed. Final year ("$finyear") has been reached."
 echo "==================================================================================="
 exit
endif


launchualookup:
date
echo "========================================"
echo "launch ua lookup job"
echo "========================================"

./check4uadata.csh yes > check4uadata.log &
sleep 2

echo "========================================================================================================="
echo "Ocan2ice part of Mr. Timms script completed; Ua is supposed to run for year $oldYear and month $oldMonth"
echo "========================================================================================================="

exit
