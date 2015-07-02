#!/bin/sh
clear

echo "kappa bash will do a series of simulations changing the value of kappa as specified by the user"

echo "enter name of moose script"
read name
echo "your file is $name"
xdg-open $name&

i=1
while [ $i -lt 10 ]
do
   echo $i
   cp $name $name+"$i"
   z=$(($i/10))
   sed -i s/'kappa = 0.1'/'k = '$z/g $name+"$i" #this edits the files
   
   bash -c "mantis-opt -i $name+$i"  #this executes the edited file
   	
   i=$(($i+1)) #assignments don't need the $ sign

done

#for filename in *.nii.gz ; do  #replace*.nii.gz with *.i...this command appears to require that the file is placed directly in the same folder as the .i files
    
#done 

return 0

