#!/usr/bin/perl
use warnings;
use strict;
use Carp qw(confess);
use BioIO::SeqIO;
use BioIO::Config qw(getErrorString4WrongNumberArguments);
use Getopt::Long;
use Pod::Usage;

use feature qw(say);
my $infilename;
my $usage = "\n$0 [options]\n\n
Options:
-input         the genbank file name
-help          show this message

";
GetOptions(
		'input=s'            =>\$infilename,
		help                => sub { pod2usage($usage); },
	  ) or pod2usage(2);

unless ($infilename){
	$infilename = 'INPUT/p53_seq.txt';
}

my ($begin, $end) =(11717, 18680);
my $SeqIOObj = BioIO::SeqIO-> new(filename => $infilename, fileType => 'fasta');

while (my $SeqObjLong = $SeqIOObj->nextSeq()){
	my $SeqObjShort = $SeqObjLong->subSeq($begin,$end);
say "The gene gi".$SeqObjShort->gi.":";
if($SeqObjShort->checkCoding()){
		say "The sequence starts with ATG codon and ends with a stop codon";
	}
	else{
		say "failed at checkCoding";
	}

	my ($pos, $sequence) = $SeqObjShort->checkCutSite('GGATCC');
	printResults($pos, $sequence, $SeqObjShort, 'BamH1');

	my ($pos2, $sequence2) = $SeqObjShort->checkCutSite('CG[AG][CT]CG');
	printResults($pos2, $sequence, $SeqObjShort, 'BsiEI');

	my ($pos3, $sequence3) = $SeqObjShort->checkCutSite('GACwwwwwwGTC');
	printResults($pos3, $sequence, $SeqObjShort, 'DrdI');
}

sub printResults{
	my $filledUsage = 'printResults($pos, $sequence, $seqObjShort, \'BamH1\');';
# test the number of arguments passed in were correct 
	@_ == 4 or confess getErrorString4WrongNumberArguments() , $filledUsage;
	my ($pos, $sequence, $seqObjShort, $name) = @_;
	if($pos){
		say "Found $name cut site at position $pos of the coding region, here is the sequence $sequence";
	}
}
