#!/bin/sh
clear

echo "kappa bash will do a series of simulations changing the value of kappa as specified by the user"

echo "your file is Input.i"
name='Input'
#our first major run with this will be "defect_height_input.i"
i=0
while [ $i -lt 11 ]
do
   echo $i

   z=$((20+$((4*$i))))
   cp $name'.i' $name'_bubblesize='$(($z))'.i'
   
   sed -i s/"data_file = 'layer_pocket_defect_2.csv'"/"data_file = 'bubblesize=$z.csv'"/g $name'_bubblesize='$(($z))'.i' #this edits the files
   sed -i s/"file_base = 'out2'"/"file_base = out_$z"/g $name'_bubblesize='$(($z))'.i'
   
   #edit the csv files
   sed -i s/',0'/''/g "bubblesize=$z.csv"
   bash -c "mantis-opt -i $name'_bubblesize='$(($z))'.i'"  #this executes the edited file
   	
   i=$(($i+1)) #assignments don't need the $ sign

done

#for filename in *.nii.gz ; do  #replace*.nii.gz with *.i...this command appears to require that the file is placed directly in the same folder as the .i files
    
#done 

return 0

