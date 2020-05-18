#!/bin/bash

for i in tests/*.clp; do
	echo $i
	clips -f $i >${i%.*}.out
done
