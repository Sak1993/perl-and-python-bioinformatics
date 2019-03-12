pdbFastaSplitter.pl

The program takes the input file from the command line and returns two fasta files One with the corresponding protein sequence (pdbProtein.fasta), and the other with the corresponding secondary structures (pdbSS.fasta).

To execute this program command looks like this
perl pdbFastaSplitter.pl -infile ss.txt

or 

./pdbFastaSplitter.pl -infile ss.txt

for help on command line options for this program

perl pdbFastaSplitter.pl -options
or
perl pdbFastaSplitter.pl -h

Note:
* Input files should be in the directory where pdbFastaSplitter.pl is located i.e in present working directory.


2)
nucleotideStatisticsFromFasta.pl
The program takes the input fasta file and output file name from the command line and returns nucleotide statistics of the fasta file provided to the provided outfile.

To execute this program command looks like this

perl nucleotideStatisticsFromFasta.pl -infile .fasta  -outfile .txt


or 

./nucleotideStatisticsFromFasta.pl -infile .fasta -outfile .txt

for help on command line options for this program

perl nucleotideStatisticsFromFasta.pl -options
or
perl nucleotideStatisticsFromFasta.pl -h

