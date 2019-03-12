#!/usr/bin/perl
use warnings;
use strict;
use feature qw(say);
use Scalar::Util qw(looks_like_number);
###########################################################################################
#
# File : descriptiveStatistics.pl
###########################################################################################
my @data;
my @datawithoutNaN;

# Passing command line arguments in to scalar.
my ( $FILE, $COLUMN_TO_PARSE ) = @ARGV;

if ( not defined $FILE ) {
	die "need a valid file name\n";
}

if ( defined $COLUMN_TO_PARSE && not looks_like_number($COLUMN_TO_PARSE) ) {
	die "need a valid column number\n";
}
# open a file handle to read.
unless ( open( INFILE, "<", $FILE ) ) { die "no such file exists, $! \n"; }

# Read the file Line by Line.

while (<INFILE>) {
	chomp;
	my @SplitText = split( "\t", $_ );
	my $column = $SplitText[$COLUMN_TO_PARSE];

# if statement to check if the column id present in the input file if not program dies with error.
	if ( not defined($column) ) {
		die "There is no valid number in column $COLUMN_TO_PARSE", $!;
	}

	# passing the data in to array.
	push( @data, $column );
}
close INFILE;

# loop through the data file
foreach my $num (@data) {

	# if $num is equal to NaN then skip else write in to another array.
	if ( $num eq "NaN" ) {
		next;
	}
	else {
		push( @datawithoutNaN, $num );
	}
}

# if the array is empty (meaning the whole column has NaN) program dies with an error.
if ( @datawithoutNaN == 0 ) {
	die "There is no valid number in column $COLUMN_TO_PARSE" ,$!;
}

# This subroutine takes in the array and returns count.
sub count {
	my $count = 0;
	foreach my $value (@_) {
		$count++;
	}
	return $count;
}

# This subroutine takes in the array and returns average.
sub average {
	my $sum = 0;
	foreach my $value (@_) {
		$sum += $value;
	}
	my $average = $sum / count(@datawithoutNaN);
	return "$average";
}

# This subroutine takes in the array and print the Minimum and Maximum value in the array.
sub minmax {
	my @array = sort { $a <=> $b } @_; # sort array in increasing order.
	my ( $Min, $Max ) = @array[ 0, -1 ]; # retrieving the max and min values
	printf( "Maximum\t = %8.3f\n", $Max );
	printf( "Minimum\t = %8.3f\n", $Min );
}

# This subroutine takes in the array and prints out Variance and Standard deviation.
sub stdv {
	my $mean    = average(@_); # get the mean.
	my $sqtotal = 0;	# initialize the scalar.
	foreach my $num (@_) {   # calculating the sum of ( $num - $mean )**2;)
		$sqtotal += ( $num - $mean )**2;	
	}
	my $var = $sqtotal / ( count(@_) - 1 ); #
	my $stdv = sqrt($var); # calculating sd by square root of variance.
	printf( "Variance = %8.3f\n", $var );
	printf( "Std Dev  = %8.3f\n", $stdv );
}

# This subroutine takes in the array and prints out median.
sub median {
	my @array = sort { $a <=> $b } @_; # sort an array in increasing order.
	my $length = @array; # get the length of the array.
	my $median; 
	if ( $length % 2 == 0 ) { # if statement to check for modulus of $length, if it is "0" then get the middle number of array.
		$median = @array[ $length / 2 ];
	}
	else {     # else calculate the average of the two middle numbers in array.
		$median =
		  ( @array[ ( $length / 2 ) - 1 ] + @array[ ( $length / 2 ) ] ) / 2;
	}
	printf( "Median\t = %8.3f\n\n", $median );
}

####Passing the array to the subroutnes and printing the required results.
printf ("\n   Column: %.f\t\n\n", $COLUMN_TO_PARSE); 
my $Count    = count(@data);
my $validnum = count(@datawithoutNaN);
my $average  = average(@datawithoutNaN);
printf( "Count\t = %8.3f\n",   $Count );
printf( "validNum = %8.3f\n",  $validnum );
printf( "Average\t = %8.3f\n", $average );
minmax(@datawithoutNaN);
stdv(@datawithoutNaN);
median(@datawithoutNaN);
