#!/bin/bash

rm ./E_correct.dat

for i in Surface_O1  Surface_OH1  Surface_OOH1 
do
	cd dir-$i
	E0=`grep F= out | tail -1 | awk '{print $3}'`
	cd phonon
	correct=`(echo '501';echo '298.15') | vaspkit | grep "Thermal correction to G"| awk '{print $7}'`
	cd ../..
	echo $i $E0 $correct >> E_correct.dat
done


i=Surface
cd dir-$i
E0=`grep F= out | tail -1 | awk '{print $3}'`
correct=0
cd ../
echo $i $E0 $correct >> E_correct.dat
