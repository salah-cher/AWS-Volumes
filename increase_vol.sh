#!/bin/bash

#get the current volume size
size=$(aws ec2 describe-volumes --volume-ids "$1" --query 'Volumes[].[Size]' --output text)
echo "the size of this volume $1 is : " "$size"

#add size  10%
add_size=$((size / 10))
echo $add_size
new_size=$((size+add_size))
echo "new size should be : " $new_size

#increase volume by 10% 
aws ec2 modify-volume  --volume-id "$1" --size $new_size

#wait till the volume is ready 
echo "Waiting for volume to be ready"
state=$(aws ec2 describe-volumes-modifications --volume-ids "$1"  --query 'VolumesModifications[].[ModificationState]' --output text)
echo "Current state is :" "$state"

while [ "$state" != "completed" ]
  do
     echo "State is : " "$state"
     sleep 20
     state=$(aws ec2 describe-volumes-modifications --volume-ids "$1"  --query 'VolumesModifications[].[ModificationState]' --output text)
  done

echo "optimizing volume completed"
#trigger a powershell script / bash script to extend the volume on the target EC2
