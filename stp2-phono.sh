#!/bin/bash


for i in Surface_O1 Surface_OH1  Surface_OOH1
do
	rm -r dir-$i/phonon
	mkdir dir-$i/phonon
	cp INCAR-freq dir-$i/phonon/INCAR
	cd dir-$i
	ls
	cp POTCAR KPOINTS run-vasp-intel.pbs phonon
	cp POTCAR phonon
	cp CONTCAR phonon/POSCAR
	cd phonon
	(echo '402';echo '1';echo '2';echo '0.0'; echo '0.42'; echo '1') | vaspkit
	cp POSCAR_FIX POSCAR

	nelement=`awk 'NR==6{print NF-2}' POSCAR`
	natom=`awk 'NR==7{sum=0; for(i=1; i<=NF; i++) sum+=$i; print sum}' POSCAR`
	echo $nelement $natom
# add MAGMON line
	echo MAGMON = $natom*0.6 >> INCAR	
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
	cd ../..
done
