#!/usr/bin/perl
use strict;
use warnings;
# call subroutine to load all sequences into a string.
my $sequenceref = loadsequence("/scratch/Drosophila/dmel-2L-chromosome-r5.54.fasta");
# to set the window size.
my $windowsize = 15;
# set the stepsize.
my $stepsize = 1;
# initializing the hash.
my %kmerhash;
# loop through to get sequences using sliding window.
for (
# initialize window start.
		my $windowstart = 0;
# check to make sure we dont past the end of the string.
		$windowstart <= (length($$sequenceref) - $windowsize);
# move the sliding window.
		$windowstart += $stepsize
    )
{
# get substring
	my $windowseq = substr($$sequenceref, $windowstart, $windowsize);
# add substring to the kmer hash.
	$kmerhash{$windowseq}++;
}
# open a file for writing.
open(KMERS, ">", 'kmers.txt') or die $!;
# loop through the kmer hash.
foreach my $kmer (keys %kmerhash){
# print kmer and count.
	print KMERS $kmer, "\t", $kmerhash{$kmer},"\n";
}
sub loadsequence {
# get the parameters passed to the subroutine.
	my ($sequencefile) = @_;
# initialize the sequence.
	my $sequence = "";
# open file handle to read a file.
	unless ( open( FILE, "<", $sequencefile)) {
		die $!;
	}
# loop through the file line by line.
	while (<FILE>) {
		my $line = $_;
# remove end of the line characters.
		chomp($line);
# if its not a header line.
		if ($line !~ /^>/){
# its a sequence line append it
			$sequence .= $line;
		}
	}
# return a reference to the sequence variable.
	return \$sequence;
}
close KMERS;
close FILE;
