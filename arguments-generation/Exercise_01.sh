#!/bin/bash
# This script genereates a list of random passwords.

# A random number as a password
PASSWORD="${RANDOM}"
echo "${PASSWORD}"

# 3 random numbers together
PASSWORD="${RANDOM}${RANDOM}${RANDOM}" 
echo "${PASSWORD}"

# Use the current date/time as the basis for the password
PASSWORD=$(date +%s)
echo "${PASSWORD}"

# Use naoseconize
PASSWORD=$(date +%s%N)
echo "${PASSWORD}"

# Better password
PASSWORD=$(date +%s%N | sha256sum | head -c32 )
echo "${PASSWORD}"

# Even better password
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c48)
echo "${PASSWORD}"

# Append a special character to the password
SPECIAL_CHARACTER=$(echo '!@#$#%^' | fold -w1 | shuf |head -c1)
echo "${PASSWORD}${SPECIAL_CHARACTER}"
