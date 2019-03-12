#!/usr/bin/perl
return 1 if (caller() );
use warnings;
use strict;
use Getopt::Long;
use Pod::Usage;
use Assignment6::Config qw(getErrorString4WrongNumberArguments);
use Assignment6::MyIO qw(getFh);
use feature qw(say);
use Carp;
use Data::Dumper;
################################################################################
# File: snpScan.pl
# This program takes a queryfile, eqtl datafile, a output filename
# each site from queryfile is used to search from eqtl and writes to outputfile
################################################################################
my $queryfile;
my $eqtlfile;
my $outfile;
my $usage = "\n$0 [options]\n\n 
Options:
-query   open the query file
-eqtl open eQTL data file
-outfile open for output file
-help     Show this message
";
GetOptions(
		'query=s' => \$queryfile,
		'eqtl=s' => \$eqtlfile,
		'outfile=s' => \$outfile,
		help       => sub { pod2usage($usage); },
	  ) or pod2usage(2);
unless($queryfile){
	die "\nDying...Make sure to provide a query file name\n" , $usage;
}
unless($eqtlfile){
	die "\nDying...Make sure to provide a eqtl  file name\n" , $usage;
}
unless($outfile){
	die "\nDying...Make sure to provide a outfile name\n" , $usage;
}
my $refHOA1 = getQuerySites($queryfile);
my ($refHOA2, $refHOH) = getEqtlSites($eqtlfile);
compareInputSitesWithQtlSites($refHOA1,$refHOA2,$refHOH,$outfile);
#my $datafh = getFh('<', $eqtlfile);
#my $outfh = getFh('>', $outfile);
#--------------------------------------------------------------------------------------------
#my $refHOA = getQuerySites($file);
#-------------------------------------------------------------------------------------------
#receives one argument 1. query file name.
#this subroutine  returns a reference to HOA created.
#-------------------------------------------------------------------------------------------
sub getQuerySites{
my $filledusage = join(' ', 'usage:', (caller (0))[3]) . '($type, $file)';
@==1 or confess getErrorString4WrongNumberArguments() , $filledusage;
	my ($file) = @_;
	my $infh = getFh('<', $file);
	my @endpositions;
	my %hashofarray;
	my $x = 1;
	while(<$infh>){
		chomp;
#to skip the header.
		if($x == 1){
			$x = 0;
			next;
		}
		my @column = split('\t',$_);
		my $chrnum = $column[0];
		my $end = $column[2];
		if(exists $hashofarray{$chrnum}){
			my $refPositions=$hashofarray{$chrnum};
			@endpositions=@$refPositions;
		}
		push(@endpositions,$end);
		$hashofarray{$chrnum}=\@endpositions;
	}
	return \%hashofarray;

#say Dumper %hashofarray;
}

#-------------------------------------------------------------------------------------------
#my ($refHOA2, refHOH) = getEqtlSites($eqtldatfile);
#-------------------------------------------------------------------------------------------
#receives one argument 1. eqtl data file
#thos sub routine reads eqtl dataset and creates a hash of hashes 
#key being the chromosome and hash with position and description, returns two reference hashes.
#-------------------------------------------------------------------------------------------
sub getEqtlSites{
	my ($file1)= @_;
	my $fh = getFh('<', $file1);
	my %HOA;
	my %HOH;
	my %value;
	my %descriptionhash;
	my $x = 1;
	while(<$fh>){
		chomp $_;
		if ($x==1){
			$x=0;
			next;}	
		my @column = split('\t',$_);
		my @reqcolumn = $column[1];
if(scalar(@column)<4){
			confess "Invalid line in $file1";
			next;}		
my @splitreqcol = split(':',$column[1]);
		my $chrnum = $splitreqcol[2];
		my $endposition = $splitreqcol[3];
		my $description = $column[3];
		my @positions;
if (exists $HOA{chrnum}){
my $refhash = $HOA{$chrnum};
my %value = %$refhash;
my $refpositions = $value{'positions'};
my $refdesc = $value{'description'};
@positions = @$refpositions;
%descriptionhash = %$refdesc;
}

		push(@positions, $endposition);
		#$HOA{$chrnum} = \@positions;
		$descriptionhash{$endposition} = $description;
		$value{'position'} = \@positions;
		$value{'description'} = \%descriptionhash;
		$HOH{$chrnum} = \%value;}
#say Dumper "%HOH";	

	return (\%HOA, \%HOH);
}
#my %xyz = %$refHOA2;
#my @v = values %xyz;
#while(my($key, $value)= each %xyz){
#	print "$key: $value\n";
#}
#for my $description(keys %xyz){
#	print " @{$xyz{$description}}\n";}
#print"$xyz{endpositons}[25]\n";

#-------------------------------------------------------------------------------------------
# compareInputSitesWithQtlSites($refHOA1,refHOA2,refHOH,outfile)
# ------------------------------------------------------------------------------------------
#receives four arguments:
#			1). A reference to the HoA in sub1. 
#			2). A reference to the HoA created in sub2. 
#			3). A reference to the HoH created in sub2. 
#			4). file name for the outfile 
#this subroutine iterates over each site in the query hash and compares i
#t to the sites in eqtl hash to find nearest site. and print to outfile.
#-------------------------------------------------------------------------------------------
#
sub compareInputSitesWithQtlSites{
		my ($refHOA1, $refHOA2, $refHOH, $outfile) = @_;
		my %queryhash = %$refHOA1;
		my %eqtlhash = %$refHOH;
		my $fh = getFh('>', $outfile);
print $fh "#site\tDistance\teQTL\t[Gene:P-val:Population]\n";
		foreach my $chrnum(keys %queryhash){
			my $refquerysites = $queryhash{$chrnum};		
my $refeqtlhash = $eqtlhash{$chrnum};			
my %chreqtlhash = %$refeqtlhash;
			my @querysites = @$refquerysites;
			foreach my $site(@querysites){
				my $closestSite = _findNearest($site, $refeqtlhash);
				my $distance = abs($site-$closestSite);
				my $eQTL = $chrnum.":".$closestSite;
				my $refdescriptionhash = $chreqtlhash{'descriptions'};
				my $description = $refdescriptionhash ->{$closestSite};
				print $fh "xyz\t","$chrnum:$site\t$description\n";}}
		return;}
#-------------------------------------------------------------------------------------------
#my $nearestPosition = _findNearest($chr, $pos, $hoaRef2);
#------------------------------------------------------------------------------
# receives three arguments: 1) A chromosome
#                           2) A position on the chromosome
#                           3) A reference to the HoA created in sub2.
#
# This subroutine should find the closest position on the same chromosome to
# the queried position and return that position.  Returns void if no position
# is found.
# ------------------------------------------------------------------------------------------
		sub _findNearest{
			my ($query, $refHash)=@_;
			my $positionsRef=$refHash->{'positions'};
			my @positions=sort {$a <=> $b} @$positionsRef;
			my $min;
			my $closest; 
			foreach my $position (@positions){
				my $diff=abs($query-$position);
				if(!defined $min){
					$min=$diff;
					$closest=$position;
				}
				elsif($min>$diff){
					$min=$diff;
					$closest=$position;
				}
				elsif($min==$diff){
				}
				if($position > $closest){
					last; 
				}
			}
			return $closest;
		}
