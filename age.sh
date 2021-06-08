#!/bin/bash

echo -n "age: "
read age
if [ $age -ge 20 ] ; then
  echo " you can drink."
else
  echo " you cannot drink."
fi
