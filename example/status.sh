#!/bin/bash

# Bash script that checks:
# - Memory usage
# - CPU load
# - Number of TCP connections
# - Kernel version

SERVER_NAME=$(hostname)

# Color variables
GREEN='\e[32m'
BLUE='\e[34m'
CLEAR='\e[0m'

# Color function
ColorGreen() {
  echo -ne $GREEN$1$CLEAR
}

ColorBlue() {
  echo -ne $BLUE$1$CLEAR
}

menu() {
  echo -ne "
  $(ColorGreen '1)') Memory usage
  $(ColorGreen '2)') CPU load
  $(ColorGreen '3)') Number of TCP connections
  $(ColorGreen '4)') Kernel version
  $(ColorGreen '5)') Check All
  $(ColorGreen '0)') Exit
  $(ColorBlue 'Choose an option:') "
    read a
    case $a in
      1) memery_check ; menu ;;
      2) cpu_check ; menu ;;
      3) tcp_check ; menu ;;
      4) kernel_check ; menu ;;
      5) all_check ; menu ;;
      0) exit 0 ;;
      *) echo -e $red"Wrong option."$clear; WrongCommand ;;
    esac
}

function memery_check() {
  echo ""
  echo "Memory usage on ${SERVER_NAME} is: "
  free -h
  echo ""
}

function cpu_check() {
  echo ""
  echo "CPU load on ${SERVER_NAME} is: "
  uptime
  echo ""
}

function tcp_check() {
  echo ""
  echo "TCP connctions on ${SERVER_NAME}: "
  cat /proc/net/tcp | wc -l
  echo ""
}

function kernel_check() {
  echo ""
  echo "Kernal version on ${SERVER_NAME} is: "
  uname -r
  echo ""
}

function all_check() {
  memery_check
  cpu_check
  tcp_check
  kernel_check
}

menu
