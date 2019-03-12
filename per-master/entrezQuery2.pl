#!/usr/bin/perl
use warnings;

use strict;
# we need this to access eutilities.
use LWP::Simple;
#open file for writing.
unless ( open( FILE, ">", "abstracts.txt" ) ) {

	die "Unable to open file $!";

}
# to get output without widechracter warnings.
binmode(FILE,":utf8");
# assigning url for eutilities
my $utils = "http://www.ncbi.nlm.nih.gov/entrez/eutils";
# defining the database.
my $db        = "PubMed";

#The query string is the same format used in Entrez web queries.
# query which contain mesh terms buuilt in pubmed database.
my $query = 'alzheimer disease[Title] AND exercise[Title]';
#The report corresponds to the Display Settings in Entrez web queries.

my $report = "Abstract";

# $esearch contains the PATH & parameters for the ESearch call.

my $esearch = "$utils/esearch.fcgi?" . "db=$db&retmax=1&usehistory=y&term=";

#$esearch_result contains the result of the ESearch call.
my $esearch_result = get( $esearch . $query );

# print the query so you can try it in a browser.

#To understand this program better, take this printed line and paste it into your browser's address bar.
# See what is displayed in the browser.
#
print $esearch . $query, "\n";
#
#  # The results are parsed into variables $Count, $QueryKey, and $WebEnv.
#
$esearch_result =~ m|<Count>(\d+)</Count>.*<QueryKey>(\d+)</QueryKey>.*<WebEnv>(\S+)</WebEnv>|s;

my $Count        = $1;

my $QueryKey = $2;

my $WebEnv   = $3;
#this area defines a loop which will display $retmax results from Efetch each time the the Enter Key is pressed, after a prompt.

my $retstart;

my $retmax = 100;

$retstart = 0;

my $efetch = "$utils/efetch.fcgi?" . "rettype=$report&retmode=text&retstart=$retstart&retmax=$retmax&". "db=$db&query_key=$QueryKey&WebEnv=$WebEnv";

if ( $Count <= 100 ) {
#Print the URL being used to retrieve results

	print $efetch, "\n";

	my $efetch_result = get($efetch);

	print FILE $efetch_result;

}
else {
	print "Too many search results. Narrow your query\n";
}
