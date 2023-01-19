#!/bin/bash

#A helper script for basic bash functions for use in scripts.


#Some functions were taken from botspots/pi-apps: https://github.com/Botspot/pi-apps/blob/master/api#L8
#All credit goes to the pi-apps team

sudo_popup() { #just like sudo on passwordless systems like PiOS, but displays a password dialog otherwise. Avoids displaying a password prompt to an invisible terminal.
  if sudo -n true; then
    # sudo is available (within sudo timer) or passwordless
    sudo "$@"
  else
    # sudo is not available (not within sudo timer)
    pkexec "$@"
  fi
}

#determine if host system is 64 bit arm64 or 32 bit armhf
if [ "$(od -An -t x1 -j 4 -N 1 "$(readlink -f /sbin/init)")" = ' 02' ];then
  arch=64
elif [ "$(od -An -t x1 -j 4 -N 1 "$(readlink -f /sbin/init)")" = ' 01' ];then
  arch=32
else
  error "Failed to detect OS CPU architecture! Something is very wrong."
fi

#output functions below
error() { #red text and exit 1
  echo -e "\e[91m$1\e[0m" 1>&2
  exit 1
}

warning() { #yellow text
  echo -e "\e[93m\e[5m◢◣\e[25m WARNING: $1\e[0m" 1>&2
}

status() { #cyan text to indicate what is happening
  #detect if a flag was passed, and if so, pass it on to the echo command
  if [[ "$1" == '-'* ]] && [ ! -z "$2" ];then
    echo -e $1 "\e[96m$2\e[0m" 1>&2
  else
    echo -e "\e[96m$1\e[0m" 1>&2
  fi
}

status_green() { #announce the success of a major action
  echo -e "\e[92m$1\e[0m" 1>&2
}

#Codename function taken from botspot/pi-apps: https://github.com/Botspot/pi-apps/blob/master/api#L2021
get_codename() { #get debian/ubuntu codename
  if ! command -v lsb_release >/dev/null; then
    apt_update &>/dev/null && \
    sudo apt-get install -y lsb-release &>/dev/null
  fi
  
  # check if upstream-release is available
  if [ -f /etc/upstream-release/lsb-release ]; then
    # this is a derivative, get the upstream release info
    lsb_release -suc
  else
    lsb_release -sc
  fi
}

#https://github.com/Botspot/pi-apps/blob/master/api#L1971
get_model() { # populates the model and jetson_model variables with information about the current hardware
  # obtain model name
  unset model
  if [[ -d /system/app/ && -d /system/priv-app ]]; then
    model="$(getprop ro.product.brand) $(getprop ro.product.model)"
  fi
  if [[ -z "$model" ]] && [[ -f /sys/devices/virtual/dmi/id/product_name ||
          -f /sys/devices/virtual/dmi/id/product_version ]]; then
    model="$(tr -d '\0' < /sys/devices/virtual/dmi/id/product_name)"
    model+=" $(tr -d '\0' < /sys/devices/virtual/dmi/id/product_version)"
  fi
  if [[ -z "$model" ]] && [[ -f /sys/firmware/devicetree/base/model ]]; then
    model="$(tr -d '\0' < /sys/firmware/devicetree/base/model)"
  fi
  if [[ -z "$model" ]] && [[ -f /tmp/sysinfo/model ]]; then
      model="$(tr -d '\0' < /tmp/sysinfo/model)"
  fi
  unset jetson_model
  # obtain jetson model name (if available)
  # nvidia, in their official L4T (Linux for Tegra) releases 32.X and 34.X, set a distinct tegra family in the device tree /proc/device-tree/compatible
  if [[ -e "/proc/device-tree/compatible" ]]; then
    CHIP="$(tr -d '\0' < /proc/device-tree/compatible)"
    if [[ ${CHIP} =~ "tegra186" ]]; then
      jetson_model="tegra-x2"
    elif [[ ${CHIP} =~ "tegra210" ]]; then
      jetson_model="tegra-x1"
    elif [[ ${CHIP} =~ "tegra194" ]]; then
      jetson_model="xavier"
    elif [[ ${CHIP} =~ "tegra234" ]]; then
      jetson_model="orin"
    fi
  # as part of the 2X.X L4T releases, the kernel is older and the tegra family is found in /sys/devices/soc0/family
  elif [[ -e "/sys/devices/soc0/family" ]]; then
    CHIP="$(tr -d '\0' < /sys/devices/soc0/family)"
    if [[ ${CHIP} =~ "tegra20" ]]; then
      jetson_model="tegra-2"
    elif [[ ${CHIP} =~ "tegra30" ]]; then
      jetson_model="tegra-3"
    elif [[ ${CHIP} =~ "tegra114" ]]; then
      jetson_model="tegra-4"
    elif [[ ${CHIP} =~ "tegra124" ]]; then
      jetson_model="tegra-k1-32"
    elif [[ ${CHIP} =~ "tegra132" ]]; then
      jetson_model="tegra-k1-64"
    elif [[ ${CHIP} =~ "tegra210" ]]; then
      jetson_model="tegra-x1"
    fi
  fi
}

get_device_info() { #returns information about current install and hardware
  echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | tr -d '"' | awk -F= '{print $2}')"
  echo "OS architecture: ${arch}-bit"
  echo "Kernel: $(uname -m) $(uname -r)"
  # obtain model name
  if [[ -d /system/app/ && -d /system/priv-app ]]; then
    model="$(getprop ro.product.brand) $(getprop ro.product.model)"
  fi
  if [[ -z "$model" ]] && [[ -f /sys/devices/virtual/dmi/id/product_name ||
          -f /sys/devices/virtual/dmi/id/product_version ]]; then
    model="$(tr -d '\0' < /sys/devices/virtual/dmi/id/product_name)"
    model+=" $(tr -d '\0' < /sys/devices/virtual/dmi/id/product_version)"
  fi
  if [[ -z "$model" ]] && [[ -f /sys/firmware/devicetree/base/model ]]; then
    model="$(tr -d '\0' < /sys/firmware/devicetree/base/model)"
  fi
  if [[ -z "$model" ]] && [[ -f /tmp/sysinfo/model ]]; then
      model="$(tr -d '\0' < /tmp/sysinfo/model)"
  fi
  echo "Device model: $model"
  echo "Cpu name: $( lscpu | awk '/Model name:/ {print $3}' )"
  echo "Ram size: $(echo "scale=2 ; $( awk '/MemTotal/ {print $2}' /proc/meminfo ) / 1024000 " | bc ) GB"
  
  if [ -f /etc/rpi-issue ];then
    echo "Raspberry Pi OS image version: $(cat /etc/rpi-issue | grep 'Raspberry Pi reference' | sed 's/Raspberry Pi reference //g')"
  fi
}

download() { #Intercept all download commands. When possible, uses aria2c.
  local file=''
  local url=''
  #determine the download manager to use
  local use=aria2c
  #determine if being run silently (if the '-q' flag was passed)
  local quiet=0
  
  #convert wget arguments to newline-separated list
  local IFS=$'\n'
  local opts="$(IFS=$'\n'; echo "$*")"
  for opt in $opts ;do
    
    #check if this argument to wget begins with '--'
    if [[ "$opt" == '--'* ]];then
      if [ "$opt" == '--quiet' ];then
        quiet=1
      else #for any other arguments, fallback to wget
        use=wget
      fi
      
    elif [ "$opt" == '-' ];then
      #writing to stdout, use wget and hide output
      use=wget
      quiet=1
    elif [[ "$opt" == '-'* ]];then
      #this opt is a flag beginning with one '-'
      
      #check the value of every letter in this argument
      local i
      for i in $(fold -w1 <<<"$opt" | tail -n +2) ;do
        
        if [ "$i" == q ];then
          quiet=1
        elif [ "$i" == O ];then
          true
        elif [ "$i" == '-' ];then
          #writing to stdout, use wget and hide output
          use=wget
          quiet=1
        else #any other wget arguments
          use=wget
        fi
      done
      
    elif [[ "$opt" == *'://'* ]]; then
      #this opt is web address
      url="$opt"
    elif [[ "$opt" == '/'* ]]; then
      #this opt is file output
      if [ -z "$file" ];then
        file="$opt"
        #if output file is /dev/stdout, /dev/null, etc, use wget
        if [[ "$file" == /dev/* ]];then
          use=wget
          quiet=1
        fi
      else #file var already populated
        use=wget
      fi
    else
      #This argument does not begin with '-', contain '://', or begin with '/'.
      #Assume output file specified shorthand if file-argument is not already set
      if [ -z "$file" ];then
        file="$(pwd)/${opt}"
      else #file var already populated
        use=wget
      fi
    fi
  done
  
  if ! command -v aria2c >/dev/null ;then
    #aria2c command not found
    use=wget
  fi
  
  if [ "$quiet" == 0 ];then
    if [ -n "$file" ] && [ "$file" != "$(pwd)/$(basename $url)" ]; then
      status -n "Downloading $(basename "$url") to $file... " 1>&2
    else
      status -n "Downloading $(basename "$url")... " 1>&2
    fi
    echo
  fi
  
  #now, perform the download using the chosen method
  if [ "$use" == wget ];then
    #run the true wget binary with all this function's args
    
    status "using wget"
    command wget --progress=bar:force:noscroll "$@"
    local exitcode=$?
  elif [ "$use" == aria2c ];then
    
    status "using aria2c"
    
    #if $file empty, generate it based on url
    if [ -z "$file" ];then
      file="$(pwd)/$(basename "$url")"
    fi
    
    #use these flags for aria2c
    aria2_flags=(-c -x 16 -s 16 --max-tries=10 --retry-wait=30 --max-file-not-found=5 --http-no-cache=true --check-certificate=false --allow-overwrite=true --auto-file-renaming=false \
      --console-log-level=error --show-console-readout=false --summary-interval=1 "$url" -d "$(dirname "${file}")" -o "$(basename "${file}")")
    
    #suppress output if -q flag passed
    if [ "$quiet" == 1 ];then
      aria2c --quiet "${aria2_flags[@]}"
      local exitcode=$?
      
    else #run aria2c without quietness and format download-progress output
      local terminal_width="$(tput cols || echo 80)"
      
      #run aria2c and reduce its output.
      aria2c "${aria2_flags[@]}" | while read -r line ;do
        
        #filter out unnecessary lines
        line="$(grep --line-buffered -v '\-\-\-\-\-\-\-\-\|======\|^FILE:\|^$\|Summary\|Results:\|download completed\.\|^Status Legend:\||OK\||stat' <<<"$line" || :)"
        
        if [ ! -z "$line" ];then #if this line still contains something and was not erased by grep
          
          #check if this line is a progress-stat line, like: "[#a6567f 20MiB/1.1GiB(1%) CN:16 DL:14MiB ETA:1m19s]"
          if [[ "$line" == '['*']' ]];then
            
            #hide cursor
            printf "\033[?25l"
            
            #print the total data only, like: "0.9GiB/1.1GiB"
            statsline="$(echo "$line" | awk '{print $2}' | sed 's/(.*//g' | tr -d '\n') "
            #get the length of statsline
            characters_subtract=${#statsline}
            
            #determine how many characters are available for the progress bar
            available_width=$(($terminal_width - $characters_subtract))
            #make sure available_width is a positove number (in case bash-variable COLUMNS is empty)
            [ "$available_width" -le 0 ] && available_width=20
            
            #get progress percentage from aria2c output
            percent="$(grep -o '(.*)' <<<"$line" | tr -d '()%')"
            
            #echo "percent: $percent"
            #echo "available_width: $available_width"
            
            #determine how many characters in progress bar to light up
            progress_characters=$(((percent*available_width)/100))
            
            statsline+="\e[92m\e[1m$(for ((i=0; i<$progress_characters; i++)); do printf "—"; done)\e[39m" # other possible characters to put here: █🭸
            echo -ne "\e[0K${statsline}\r\033\e[0m" 1>&2 #clear and print over previous line
            
            #reduce the line and print over the previous line, like: "1.1GiB/1.1GiB(98%) DL:18MiB"
            #echo "$line" | awk '{print $2 " " $4 " " substr($5, 1, length($5)-1)}' | tr -d '\n'
            
          else
            #this line is not a progress-stat line; don't format output
            echo "$line"
          fi
        fi
        
      done
      local exitcode=${PIPESTATUS[0]}
    fi
  fi
  
  #display a "download complete" message
  if [ $exitcode == 0 ] && [ "$quiet" == 0 ];then
    
    #show cursor
    printf "\033[?25h"
    
    #display "done" message
    if [ "$use" == aria2c ];then
      local progress_characters=$(($terminal_width - 5))
      echo -e "\e[0KDone \e[92m\e[1m$(for ((i=0; i<$progress_characters; i++)); do printf "—"; done)\e[39m\e[0m" 1>&2 #clear and print over previous line
    else
      echo
      status_green "Done" 1>&2
    fi
  elif [ $exitcode != 0 ] && [ "$quiet" == 0 ];then
    echo -e "\n\e[91mFailed to download: $url\nPlease review errors above.\e[0m" 1>&2
  fi
  
  return $exitcode
}
