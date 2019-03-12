#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;
my $regionsfile = '/scratch/SampleDataFiles/test.fasta';
unless (open (REGIONS, "<", $regionsfile)) {
	die "cant open"," ", $!;
# open file for reading
}
#reads one sequence at a time.
local $/ = ">";
# initilizing scalars.
my $count = 0;
my $match = 0;
# find the match and position of the match
while (<REGIONS>){
	chomp; #remove end of the line characters
#writing a regular expression.
	if (length($_) > 0 and $_ =~ /^(.*?)$(.*)$/ms ){
		$count++;
		my $header = $1;
		my $seq = $2;
		$seq =~ s/\n//g;# remove end line characters
		my $headercount = 0; # initialise variable
# match the particular sequence
			while ($seq =~ /([VILMFWCA]{8,})/g){
				$headercount++;
				if ($headercount == 1){
					$match++;
					print "\n";
# print header which contains hydrophobic regions.
					print "Hydrophobic stretch found in : $header \n";
					}
# to get position of match
					my $matchposition = pos($seq);
# to get match length
					my $matchlength = length($1);
# to get match start position
					my $startposition = ($matchposition - $matchlength + 1);
					print "\n";
# pritn match			
					print $1, "\n";
# to print match start position.
					print "The match was at position : $startposition \n";
				}
		}
}
print "\n";
# print the required result.
print "hydrophobic regions found in $match sequences out of $count sequences \n";
# close the file handle.
close REGIONS;

