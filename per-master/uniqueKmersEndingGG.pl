#!/usr/bin/perl
use strict;
use warnings;
# call subroutine to load all sequences into a string.
my $sequenceref = loadsequence("/scratch/Drosophila/dmel-all-chromosome-r6.02.fasta");
# to set the window size.
my $windowsize = 21;
# set the stepsize.
my $stepsize = 1;
# initializing the hash.
my %kmerhash;
my %last12hash;
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
# writing the regular expression to get the required sequence ending with GG and first 21 characters ATG or C.
	if ($windowseq =~/([ATGC]{9}([ATGC]{10}GG))/g){
# add substring to the kmer hash.
		$last12hash{$2} = $1;
		$kmerhash{$2}++;
	}}
# open a file for writing.
open(KMERS, ">", 'unique12KmersEndingGG.fasta') or die $!;
#initializing the counter scalar.
my $kmercount = 0;
# loop through the kmer hash.
foreach my $kmer (keys %kmerhash){
# make sure the sequences donot repeat.
	if ($kmerhash{$kmer}==1) {
# increment the value by 1.
		$kmercount++;
# print kmer and count.
		print KMERS ">crispr_", $kmercount, "\n", $last12hash{$kmer},"\n";
	}
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
# close file handles
close KMERS;
close FILE;
