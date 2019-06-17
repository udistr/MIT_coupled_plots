#!/bin/tcsh

module load pkgsrc
module load ncview/2.1.7

./gif2mp4.sh ${1}_sp
./gif2mp4.sh ${1}_np

