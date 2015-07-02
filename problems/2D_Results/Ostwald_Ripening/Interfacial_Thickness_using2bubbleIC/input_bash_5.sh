#!/bin/sh
clear

echo "kappa bash will do a series of simulations changing the value of kappa as specified by the user"

echo "your file is Ostwald_interface_thickness_test.i"
name='Ostwald_interface_thickness_test'  #leave out the .i for the variable
#our first major run with this will be "defect_height_input.i"
i=3
while [ $i -lt 11 ]
do
   echo $i

   coeff=$(echo "0.05*$i" | bc)
   new_name=$name'_kappa='$coeff'.i'
   cp $name'.i' $new_name
   
   sed -i s/"kappa = 0.02"/"kappa = $coeff"/g $new_name #this edits the files
   sed -i s/"file_base = 'OstwaldTest'"/"file_base = out_kappa_$coeff"/g $new_name
   
   bash -c "mantis-opt -i $new_name"  #this executes the edited file
   	
   i=$(($i+1)) #assignments don't need the $ sign

done

#for filename in *.nii.gz ; do  #replace*.nii.gz with *.i...this command appears to require that the file is placed directly in the same folder as the .i files
    
#done 

return 0

