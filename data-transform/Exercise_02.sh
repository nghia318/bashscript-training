#!/bin/bash

netstat -nutl $1 | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}'

