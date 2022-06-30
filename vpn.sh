#!/bin/bash

# Get script directory
script_file=$(realpath $0)
script_dir=$(dirname $script_file)

# Load configuration
set -a
. $script_dir/config
set +a

# Get VPN connection status
pid_file=$script_dir/pid

pid=0
if test -f $pid_file
then
    pid=$(cat $pid_file)
fi

connected=false
if [ $pid != 0 ] && ps -p $pid &> /dev/null
then
    connected=true
    printf 'VPN connection is ON\n\n'
else
    printf 'VPN connection is OFF\n\n'
fi

# Run action
action=$1
case $action in

    on)
        if ! $connected
        then
            # Start Android virtual device
            emulator -avd rtss-otp -no-snapshot-save -no-boot-anim -no-audio &> /dev/null &
            emulator_pid=$!

            # Connect to VPN
            printf 'Opening VPN connection...\n'
            sudo openconnect \
                --protocol=gp \
                --server=$RTSS_VPN_SERVER \
                --user=$RTSS_VPN_USER \
                --pid-file=$pid_file \
                --background

            # Stop Android virtual device
            kill $emulator_pid &> /dev/null
        fi
        ;;

    off)
        if $connected
        then
            # Disconnect from VPN
            printf 'Closing VPN connection... \n'
            sudo kill $pid
        fi
        ;;

    otp)
        # Start Android virtual device
        emulator -avd rtss-otp
        ;;

    *)
        # Print help
        cat << EOF
Usage: vpn [OPTION]

Options:
  on        Start Android virtual device and connect to VPN
            State of virtual device will not be saved
  off       Disconnect from VPN
  otp       Start Android virtual device
            State of virtual device will be saved
EOF
        ;;
esac
