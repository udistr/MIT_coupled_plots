#!/bin/tcsh

set name=$1

echo ${name}
rm -rf figs/${name}_a*
convert -delay 50 figs/${name}*.png -loop 0 figs/${name}_animation.gif
#/usr/local/other/SLES11/ffmpeg/0.9.1/bin/ffmpeg -i ${name}/${name}_animation.gif -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" ${name}/${name}_animation.mp4

rm -rf figs/${name}*.png



