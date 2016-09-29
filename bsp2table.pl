#!/usr/bin/perl -w

use strict;
use List::MoreUtils 'first_index'; 

#------------------------------------------------------------------------------
# Author: Haisam K. Ido
# Date: 2016-09-27
#
# Description: A perl script that takes the output of SPICE's states executable and reformats the 
# data into tabular format
#
#  usage: ./bsp2text.sh | ./bsp2tabl.pl 
#
#------------------------------------------------------------------------------

my @months = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );

my ( $OB,    # Observing Body 
     $TB,    # Target Body
     $IRF,   # Inertial Reference Frame
     $UTC, 
     $x, 
     $y, 
     $z, 
     $xd, 
     $yd, 
     $zd);

print "#Epoch,Observing Body,Target Body,Inertial Reference Frame,X(km),Y(km),Z(km),Xd(km/s),Yd(km/s),Zd(km/s)\n";

while(<>) {

  $OB  = $1 if( /^relative to body\s*\:\s*(.*)$/i );
  $TB  = $1 if( /^Body\s*\:\s*(.*)$/i );
  $IRF = $1 if( /^In Frame\s*\:\s*(.*)$/i );

  if( /^At UTC time\s*\:\s*(.*)$/i ) {
    $UTC   = $1;
    #print $1;
    if( $UTC =~ /^(\d{4}) (\w{3}) (\d{2}) (.*)$/i ) {
      my $year      = $1;
      my $monthAbbr = $2;
      my $dom       = $3;
      my $time      = $4;
      my $month     = sprintf("%02d", (first_index { /^${monthAbbr}/i } @months) + 1); # Get month's number
      $UTC="${year}-${month}-${dom} $time";
    }
  }

  s/^\s+//g;
  s/\s+\:\s+/:/g;

  if( /^(X|Y|Z)\:/ ) { s/\s+/,/g; }

  if( /^X:,(.*),(.*),$/ ) {
    $x  = $1;
    $xd = $2;
  }
  if( /^Y:,(.*),(.*),$/ ) {
    $y  = $1;
    $yd = $2;
  }
  if( /^Z:,(.*),(.*),$/ ) {
    $z  = $1;
    $zd = $2;
  }

  if( defined $OB && 
      defined $TB && 
      defined $IRF &&
      defined $UTC &&
      defined $x &&
      defined $y &&
      defined $z &&
      defined $xd && 
      defined $yd &&
      defined $zd ) {

    print "$UTC,$OB,$TB,$IRF,$x,$y,$z,$xd,$yd,$zd\n";

    undef $OB;
    undef $TB;
    undef $IRF;
    undef $UTC;
    undef $x;
    undef $y;
    undef $z;
    undef $xd;
    undef $yd;
    undef $zd;
  }
}
