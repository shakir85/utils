#!/bin/bash

#!/bin/bash

echo "Run 'vagrant up' or 'vagrant halt' (u/h)?"
read -r input

cd ${HOME}/vagrant

function vagrant_up {
    echo "Starting VMs"
    cd ansible-control && vagrant up > /dev/null 2>&1 &
    cd ansible-worker-1 && vagrant up  > /dev/null 2>&1 &
    cd ansible-worker-2 && vagrant up  > /dev/null 2>&1 &

}

function vagrant_halt {
    echo "Halting VMs"
    cd ansible-control && vagrant halt > /dev/null 2>&1 &
    cd ansible-worker-1 && vagrant halt > /dev/null 2>&1 &
    cd ansible-worker-2 && vagrant halt  > /dev/null 2>&1 &

}


case $input in
    [uU])
            vagrant_up
    ;;
    [hH])
            vagrant_halt
    ;;

    *) echo -e "\nInvalid option... Choose 'u' for vagrant up or 'h' for vagrant halt"
    ;;
esac

echo 'Done.'
