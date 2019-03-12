package BioIO::Seq;
use warnings;
use strict;
use feature qw(say);
use Carp qw(confess);
use BioIO::MyIO qw(getFh);
use Moose;
use MooseX::StrictConstructor;
use BioIO::Config qw(getErrorString4WrongNumberArguments);


has 'gi' => (
		is => 'rw',
		isa => 'Int',
		required => 1
	    );

has 'seq' => (
		is => 'rw',
		isa => 'Str',
		required => 1,
	     );

has 'def' => (
		is =>'rw',
		isa => 'Str',
		required => 1
	     );

has 'accn' => (
		is => 'rw',
		isa => 'Str',
		required =>1
	      );
#-------------------------------------------------------------------------------
## void context: $seqObj->writeFasta($fileNameOut, $width)
##-------------------------------------------------------------------------------
## write the seq object to fasta file, where $fileNameOut is the outfile and $width is 
## the width of the sequence column (default 70 if none provided) 
##-------------------------------------------------------------------------------
#
sub writeFasta {
	my $filledUsage = 'Usage: \$seqObj->writeFasta(fileNameOut,width) width is optional';
# test the number of arguments passed in were correct 
	@_ == 2 or @_ == 3 or confess getErrorString4WrongNumberArguments() , $filledUsage;
	my ($self, $fileNameOut, $width);
	if (scalar @_ == 3){
		($self, $fileNameOut,$width) = @_;
	}
	else {
		($self,$fileNameOut) = @_;
		$width = 70;
	}
	my $fhout = getFh ('>', $fileNameOut);
	say $fhout ">gi|".$self->gi."|ref|".$self->accn."|".$self->def;
	my $sequence = $self->seq;
	say $fhout substr($sequence,0,$width, '') while(length($sequence));
}
#-------------------------------------------------------------------------------
## scalar context: my $newSeqObj = $seqObj->subSeq($begin, $end)
##-------------------------------------------------------------------------------
## subSeq receives the beginning and the ending sites, and returns a new BioIO::Seq object
## between the sites (inclusive, sites are bio-friendly num).  This method should
## test to make sure that $begin and $end have been defined, and that you would not
## "subSeq" outside the length of of the sequence.
##-------------------------------------------------------------------------------
sub subSeq {
	my $filledUsage = 'Usage: $newSeqObj = $seqObj->subSeq($begin, $end)';
# test the number of arguments passed in were correct 
	@_ == 3 or die getErrorString4WrongNumberArguments() , $filledUsage;
	my($self, $begin, $end) = @_;
	my $length = $end-$begin+1;
	return BioIO::Seq->new(gi =>$self->gi,
			seq => substr($self->seq,$begin-1,$length),
			def => $self->def,
			accn => $self->accn
			);
}

#-------------------------------------------------------------------------------
## scalar ( bool = 1 or return; ) context: my $isCoding = $seqObj->checkCoding()
##-------------------------------------------------------------------------------
## checkCoding check if a seq starts with ATG codon, and ends with a stop codon,
## i.e., TAA, TAG, or TGA
##-------------------------------------------------------------------------------

sub checkCoding {
	my $filledUsage = 'Usage: my $isCoding = $seqObj->checkCoding()';
# test the number of arguments passed in were correct 
	@_ == 1 or confess getErrorString4WrongNumberArguments() , $filledUsage;
	my $self = shift;
	my $sequence = $self->seq;
	if($sequence=~ m/^ATG(\w)*TAG|TGA|TAA$/i){
		return 1;
	}
	else {
		return;
	}
}


#-------------------------------------------------------------------------------
## my ($pos, $seqFound) = $seqObj->checkCutSite( 'GGATCC' );
##-------------------------------------------------------------------------------
## checkCutSite receives a  site pattern. It searches the
## seq, and determine the location of cutting site, and returns the position and the sequence
## that matched.
##-------------------------------------------------------------------------------

sub checkCutSite {
	my $filledUsage = 'Usage: my ($pos, $seqFound) = $seqObj->checkCutSite( \'GGATCC\' );';
# test the number of arguments passed in were correct 
	@_ == 2 or confess getErrorString4WrongNumberArguments() , $filledUsage;
	my($self, $pattern) = @_;
	if($self->seq =~ m/$pattern/i){
		return (length($`)+ 1,$&)
	}
	else{
		return (undef,undef)
	}
}

1;























