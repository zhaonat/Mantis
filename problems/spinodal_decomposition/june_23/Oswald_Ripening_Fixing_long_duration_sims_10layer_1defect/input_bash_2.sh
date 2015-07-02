#!/bin/sh
clear

echo "kappa bash will do a series of simulations changing the value of kappa as specified by the user"

echo "your file is defect_width_input.i"
name='W_parameter_input'
#our first major run with this will be "defect_width_input.i"
i=2

while [ $i -lt 5 ]
do
   echo $i
   z=$(echo "scale=2; $i/4.0" | bc)
   cp $name'.i' $name'_W='$(($z))'.i'
   sed -i s/"constant_expressions = '1.0'"/"constant_expressions = $z"/g $name'_W='$(($z))'.i' #this edits the files
   sed -i s/"file_base = 'out2'"/"file_base = 'out_W=$z'"/g $name'_W='$(($z))'.i'
   
   bash -c "mantis-opt -i $name'_W='$z'.i'"  #this executes the edited file
   	
   i=$(($i+1)) #assignments don't need the $ sign

done

#for filename in *.nii.gz ; do  #replace*.nii.gz with *.i...this command appears to require that the file is placed directly in the same folder as the .i files
    
#done 

return 0

