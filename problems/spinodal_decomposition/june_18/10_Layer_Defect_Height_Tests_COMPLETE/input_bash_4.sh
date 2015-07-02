#!/bin/sh
clear

echo "kappa bash will do a series of simulations changing the value of kappa as specified by the user"

echo "your file is defect_height_input.i"
name='defect_height_input'
#our first major run with this will be "defect_height_input.i"
i=0
while [ $i -lt 7 ]
do
   echo $i
   cp $name'.i' $name'_height='$(($i+4))'.i'
   z=$(($i+4))
   sed -i s/"data_file = 'height=0.csv'"/"data_file = 'height=$z.csv'"/g $name'_height='$(($i+4))'.i' #this edits the files
   sed -i s/"file_base = 'out2'"/"file_base = out_$z"/g $name'_height='$(($i+4))'.i'
   sed -i s/',0'/''/g 'height='$(($i+4))'.csv'
   bash -c "mantis-opt -i $name'_height='$(($i+4))'.i'"  #this executes the edited file
   	
   i=$(($i+1)) #assignments don't need the $ sign

done

#for filename in *.nii.gz ; do  #replace*.nii.gz with *.i...this command appears to require that the file is placed directly in the same folder as the .i files
    
#done 

return 0

