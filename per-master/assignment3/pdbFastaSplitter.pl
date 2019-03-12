#!/usr/bin/perl
use warnings;
use strict;
use Test::Exception;
use Getopt::Long;
use Pod::Usage;
#initialise scalars.
my $file2open ='';
# create string to describe each option
my $usage = "\n\n$0 [options] \n
Options:
-infile Provide the fasta sequence file name to do the splitting on, this file contains
	two entries for each sequence, one with the protein sequence data, and one with
	the SS information
-help show this message
\n";
#passing the strings to the scalars.
GetOptions(
		'infile=s' => \$file2open,
		help => sub {pod2usage($usage);},) or pod2usage(2);
# we want to validate the input, checking whether we got all the input required by program.
unless ($file2open){
	die "Dying...make sure to provide a file name of a sequence in FASTA format", $usage;}
#writing a subroutine which returns the filehandle.
#takes in two arguments
#check if the read or write operator is defined.
#then open and return a file handle
	sub getFh {
		my $filehandle;
		my($readorwrite,$filename) = @_;
		if ($readorwrite eq! '>' or $readorwrite eq! '<'){
			die "no read or write operator found, $!";}
		unless(open($filehandle, $readorwrite,$filename)){
			die;
		}
		return $filehandle;
	}
my $file2write = "pdbProtein.fasta";
my $file2write2 = "pdbSS.fasta";		
my $fhIn  = getFh('<' , $file2open);
my $fhOut = getFh('>' , $file2write);
my $fhOut2 = getFh('>' , $file2write2);
my $fh;
#writing a subroutine which returns two arrays with header and sequences.
#intitialise 2  arrays.
# change the record seperator.
#loop through the file line by line
## write a regex to seperate header and sequence.
#push header adn sequences in to respective arrays.
# call check for size array..
# return header and sequence.
sub getHeaderAndSequenceArrayRefs {
	my @header;
	my @sequence;
	my $sequence;
	my ($fhIn) = @_;
	while (<$fhIn>){
		chomp;
		if ($_ =~ /^>/){
			push(@header, $_);
			if (defined $sequence){
				push(@sequence,$sequence)}
			$sequence = '';
		}
		else {
			$sequence .= $_;
		}
	}
	push (@sequence, $sequence);

	_checkSizeOfArrayRefs(\@header,\@sequence);
	return (\@header,\@sequence);
}
# call the subroutine.
my ($refArrHeaders, $refArrSeqs) = getHeaderAndSequenceArrayRefs($fhIn);
# write subroutine which checks for size of arrays. 
# wite if statement to check weather the header and seq are of same size.
# if no die else it will return.
sub _checkSizeOfArrayRefs {
	my ($header, $sequence) = @_;
	if (scalar(@$header) != scalar(@$sequence)){
		die, $!;}
	else{
		return;
#die $!
#unless (scalar(@$header) == scalar(@$sequence));	
#return;
	}
}
# intialise the counter
# check if the header has word sequence
# if yes the write the sequence and hrader to a fasta file,
# if no then write to other fasta file here pdbSS.fasta
my $proteincount = 0;
my $secondstr = 0;
for(my $i=0; $i < scalar(@$refArrHeaders);$i++){
	if($refArrHeaders -> [$i] =~ /sequence/){
		$fh = $fhOut;
		$proteincount++;	
	}	
	else{
		$fh = $fhOut2;
		$secondstr++;
	}
	print $fh $refArrHeaders->[$i].$refArrSeqs -> [$i];
}
print "Found $proteincount protein sequences\n";
print "Found $secondstr ss sequences\n";
