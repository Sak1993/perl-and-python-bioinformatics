#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use BioIO::SeqIO;
my $output = 'OUTPUT';
my $fileInName;
my $usage = "\n$0 [options]\n\n
Options:
-input         the genbank file name
-help          show this message

";
GetOptions(
	'input=s'            =>\$fileInName,
       	help                => sub { pod2usage($usage); },
	  ) or pod2usage(2);

unless ($fileInName){
$fileInName = 'INPUT/genbank_seq.txt';
}

my $seqIOObj = BioIO::SeqIO -> new(filename => $fileInName, fileType => 'genbank');
while (my $seqObj = $seqIOObj->nextSeq()){
	my $fileout = $output.'/'.$seqObj->accn.".fasta";
	$seqObj->writeFasta($fileout);}
