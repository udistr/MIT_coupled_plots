#!/bin/tcsh

if ( -e sst.txt ) rm sst.txt
if ( -e eta.txt ) rm eta.txt
if ( -e theta.txt ) rm theta.txt
if ( -e sss.txt ) rm sss.txt
if ( -e salt.txt ) rm salt.txt
if ( -e area.txt ) rm area.txt
if ( -e heff.txt ) rm heff.txt
if ( -e hsnow.txt ) rm hsnow.txt

foreach filo (../mit_output/STDOUT.*)
  grep dynstat_sst_mean ${filo} | tr -s " " | cut -d" " -f6 | head -n -1 >> sst.txt
  grep dynstat_eta_mean ${filo} | tr -s " " | cut -d" " -f6 | head -n -1 >> eta.txt
  grep dynstat_theta_mean ${filo} | tr -s " " | cut -d" " -f6 | head -n -1 >> theta.txt
  grep dynstat_sss_mean ${filo} | tr -s " " | cut -d" " -f6 | head -n -1 >> sss.txt
  grep dynstat_salt_mean ${filo} | tr -s " " | cut -d" " -f6 | head -n -1 >> salt.txt
  grep seaice_area_mean ${filo} | tr -s " " | cut -d" " -f6 | head -n -1 >> area.txt
  grep seaice_heff_mean ${filo} | tr -s " " | cut -d" " -f6 | head -n -1 >> heff.txt
  grep seaice_hsnow_mean ${filo} | tr -s " " | cut -d" " -f6 | head -n -1 >> hsnow.txt
end

#cat iceStDiag.* | grep -A2 sIceLoad | grep "^  " | awk '{print $2}'

