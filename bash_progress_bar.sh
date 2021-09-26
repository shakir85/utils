#!/bin/bash
sleep 10 & 
PID=$! 

echo "Process Message..."
printf "["
while kill -0 $PID 2> /dev/null; do 
    # print any character
    printf  "#"
    # Add a long running process below:
    sleep 1
done
printf "]"
echo "Done."
