#!/usr/bin/perl
use warnings;
use strict;
use feature qw(say);
use Getopt::Long;
use Pod::Usage;
my $file2open = '';
my $file2write ='';
my $usage = "\n$0 [options]\n
Options;
-infile   Provide a fasta sequence file name to complete the stats on
-outfile  Provide a output file to put the stats into
-help     Show this message
\n";
GetOptions(
		'infile=s' => \$file2open,
		'outfile=s' => \$file2write,
		help => sub {pod2usage($usage);},) or pod2usage(2);
unless ($file2open){
        die "Dying...make sure to provide a file name of a sequence in FASTA format", $usage;}
unless ($file2write){
        die "Dying...make sure to provide a out file name from stats", $usage;}
sub getFh {
	my $filehandle;
	my ( $readorwrite, $filename ) = @_;
	unless ( open( $filehandle, $readorwrite, $filename ) ) {
		die;
	}
	return $filehandle;
}
my $fhIn  = getFh( '<', $file2open );
my $fhOut = getFh( '>', $file2write );

sub getHeaderAndSequenceArrayRefs {
	my @header;
	my @sequence;
	my $sequence;
	my ($fhIn) = @_;
	while (<$fhIn>) {
		chomp;
		if ( $_ =~ /^>/ ) {
			push( @header, $_ );
			if ( defined $sequence ) {
				push( @sequence, $sequence );
			}
			$sequence = '';
																																		}
		else {
			$sequence .= $_;
		}
	}
	push( @sequence, $sequence );

#  _checkSizeOfArrayRefs(\@header,\@sequence);
	return ( \@header, \@sequence );
}
my ( $refArrHeader, $refArrSeq ) = getHeaderAndSequenceArrayRefs($fhIn);

#print "@$seq\n";

sub printSequenceStats {
	my ( $head, $seq, $fh ) = @_;
	my $accession;
	my $abcd;
	for ( my $i = 0 ; $i < scalar(@$head) ; $i++ ) {
		my $header   = $head->[$i];
		my $sequence = $seq->[$i];
		my $numAs    = _getNtOccurrence( 'A', $sequence );
		my $numCs    = _getNtOccurrence( 'C', $sequence );
		my $numGs    = _getNtOccurrence( 'G', $sequence );
		my $numTs    = _getNtOccurrence( 'T', $sequence );
		my $accession = _getAccession($header);
		say $accession;
	}
	return $accession;
	return $abcd;
}

sub _getNtOccurrence {
	my ( $base, $seq ) = @_;
	if ( $base =~ /^A$/ ) {
		return ( $seq =~ tr/Aa// );
	}
	elsif ( $base =~ /^T$/ ) {
		return ( $seq =~ tr/Tt// );
	}
	elsif ( $base =~ /^G$/ ) {
		return ( $seq =~ tr/Gg// );
	}
	elsif ( $base =~ /^C$/ ) {
		return ( $seq =~ tr/Cc// );
	}
	else {
		die;
	}
}

sub _getAccession {
my $header = @_;
	my @a = split( " ", $header );
	my $accession = $a[0];
	return $accession;
}
#dies_ok {_getNtOccurrence('Z', $seq)};
#say $numAs;
#say $numCs;
#say $numGs;
#say $numTs;
printSequenceStats( $refArrHeader, $refArrSeq, $fhOut );
