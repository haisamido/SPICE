#!/bin/bash

#------------------------------------------------------------------------------
# Author: Haisam K. Ido
# Date: 2016-09-27
#
# Description: A script that outputs the state vector of target body from SPICE's 
# binary SPICE files (bsp)
#
#  usage: ./bsp2text.sh
#
#------------------------------------------------------------------------------

now=$(date -u "+%Y-%m-%d %H:%M:%S")

#------------------------------------------------------------------------------
# Download TLS from http://naif.jpl.nasa.gov/pub/naif/generic_kernels/lsk/naif0011.tls
#------------------------------------------------------------------------------
TLS="./data/naif0011.tls"                           # Enter the name of a leapseconds kernel file
#------------------------------------------------------------------------------
# Download BSP from here https://spsweb.fltops.jpl.nasa.gov/rest/ops/id/8449058/64_pred_20160909_20170101_od004_v1.xsp.bsp 
#------------------------------------------------------------------------------
BSP="./64_pred_20160909_20170101_od004_v1.xsp.bsp"  # Enter the name of a binary SPK ephemeris file

OB="earth"                                          # Enter the name of the observing body
TB="ORX"                                            # Enter the name of a target body
NS=23                                               # Enter the number of states to be calculated
t0="2016-09-10 00:00:00"                            # Enter the beginning UTC time
tf="2016-09-11 00:00:00"                            # Enter the ending UTC time
IRF="J2000"                                         # Enter the inertial reference frame (e.g.:J2000)
ToC="NONE"                                          # Type of correction

STATES_EXE="./exe/states"
BRIEF_EXE="./exe/brief"                             # summarizes content of BSP t0, tf

YESES=$(seq $NS | perl -ne 'print "Y\n";')          # to "interactively" provide a Y as in Yes

#$BRIEF_EXE $BSP

$STATES_EXE <<EOD
$TLS
$BSP
$OB
$TB
$NS
$t0
$tf
$IRF
$ToC
"$YESES"
EOD
