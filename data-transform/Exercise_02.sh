#!/bin/bash

echo 'productID,name,price,quantiy' > inventory.csv
echo 'P101,Laptop,1200,50' >> inventory.csv
echo 'P102,Mouse,25,200' >> inventory.csv
echo 'P103,Keyboard,75,150' >> inventory.csv
echo 'P104,Monitor,250,80' >> inventory.csv

echo "Transforming inventory data..."

awk -F',' 'NR > 1 {print $2 " | Quantity: " $4 " | Total Value: $" $3 * $4}' inventory.csv

echo "Transformation complete."