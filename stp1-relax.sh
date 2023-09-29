#!/bin/bash


for i in Surface Surface_O1  Surface_OH1  Surface_OOH1
do
	mkdir dir-$i
	cp INCAR KPOINTS run-vasp-intel.pbs dir-$i
	cp $i dir-$i/POSCAR
	cd dir-$i
	vaspkit -task 103
	nelement=`awk 'NR==6{print NF-2}' POSCAR`
	natom=`awk 'NR==7{sum=0; for(i=1; i<=NF; i++) sum+=$i; print sum}' POSCAR`
	echo $nelement $natom
# add MAGMOM line
	echo MAGMOM = $natom*0.6 >> INCAR	
# add +U line
	str="LDAUJ = 2 2"
	for ((i=1; i<=$nelement ; i++))
	do
		str="$str 0"
	done
	echo $str >> INCAR


    str="LDAUL = 2 2"
    for ((i=1; i<=$nelement ; i++))
    do
        str="$str 0"
    done
    echo $str >> INCAR

    str="LDAUU = 3.9 3.32"
    for ((i=1; i<=$nelement ; i++))
    do
        str="$str 0.0"
    done
    echo $str >> INCAR

	
	qsub run-vasp-intel.pbs
	cd ../
done
