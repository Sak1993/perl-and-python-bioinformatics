#!/usr/bin/perl
use warnings;
use strict;
use diagnostics;
# open files for reading.
unless ( open( GFF3, ">", 'crispr.gff3')) {
	die $!;
}
unless ( open( LESS , ">", 'offTarget.txt')) {
	die $!;
}
blastOligos();
sub blastOligos {
# put all BLAST commands in an array.
	my @commandAndParams = ('blastn','-task blastn','-db DrosophilaAllChroms', '-query ~/BIOL6308/LAB_11/uniqueKmersEndingGG.fasta', '-outfmt 6');
# print the BLAST commandfor debugging.
	print "@commandAndParams\n";
# run BLAST command and get output as a file handle named BLAST.
	open( BLAST, "@commandAndParams |");
# process BLAST output linr by line.
	while (<BLAST>) {
#get rid of enline characters.
		chomp;
# assigning the line of output from default variable $_  
		my $blastOutputLine = $_;
		processBlastOutputLine($blastOutputLine);
	}
}
sub processBlastOutputLine {
	my ($blastOutputLine) = @_;
# if the output line isnt a comment line.
	if  ($blastOutputLine !~ /^#/) {
# split the outpt line using the tab seperator.
		my @blastColumns = split( "\t", $blastOutputLine);
# assign the column positions to variables.
		my ($queryId, $chrom, $identity, $length, $mismatches, $gaps, $qStar, $qEnd, $Start, $End) = @blastColumns;
		my $strand = '+';
		my $gffStart = 0;
		my $gffEnd = 0;
		if ( $Start > $End ){
			$strand = '-';
			$gffStart = int $End;
			$gffEnd = int $Start;
		}
		else {
			$gffStart = int $Start;
			$gffEnd = int $End;
		}
# put variables required for GFF3 record in an array in order that should appear in output file.
		my @rowArray;
		@rowArray = ($chrom, ".", 'OLIGO', $gffStart, $gffEnd, ".", $strand, ".", "Name=$queryId;Note=Some info on this oligo");
# change field seperator to tab.
		local $, = "\t";
# check for identity if 100% print to GFF3 file handle.
		if($identity == 100){
			print GFF3 @rowArray,"\n";
		}
# if identity is less than 100% print ot LESS file handle.
		else {
			print LESS $blastOutputLine,"\n"
		}
	}
}
#close file handlles.
close GFF3;
close LESS;
