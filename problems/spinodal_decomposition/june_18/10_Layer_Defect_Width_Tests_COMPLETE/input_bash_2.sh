#!/bin/sh
clear

echo "kappa bash will do a series of simulations changing the value of kappa as specified by the user"

echo "your file is defect_width_input.i"
name='defect_width_input'
#our first major run with this will be "defect_width_input.i"
i=1
while [ $i -lt 11 ]
do
   echo $i
   mkdir 'test'$i
   cp $name'.i' $name'_width='$(($i))'.i'
   sed -i s/"data_file = 'Width=0.csv'"/"data_file = 'Width=$i.csv'"/g $name'_width='$(($i))'.i' #this edits the files
   sed -i s/"file_base = 'out2'"/"file_base = out_width_$i"/g $name'_width='$(($i))'.i'
   sed -i s/',0'/''/g 'Width='$(($i))'.csv'
   bash -c "mantis-opt -i $name'_width='$(($i))'.i'"  #this executes the edited file
   	
   i=$(($i+1)) #assignments don't need the $ sign

done

#for filename in *.nii.gz ; do  #replace*.nii.gz with *.i...this command appears to require that the file is placed directly in the same folder as the .i files
    
#done 

return 0

