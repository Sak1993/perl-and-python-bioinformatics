The program takes the input file and column  number to parse from the command line and returns following statistical data to the terminal.

Count    =       
validNum =       
Average  =       
Maximum  =       
Minimum  =       
Variance =       
Std Dev  =    
Median   =  

To execute program descriptiveStatistics.pl:
command looks like:
perl descriptiveStatistics.pl inputfile columntoparse
(or)
./descriptiveStatistics.pl inputfile columntoparse

For example if input file is datafile.txt and column to parse is 3 then command will be:
perl descriptiveStatistics.pl datafile.txt 3 

Note:
* Input files should be in the directory where descriptiveStatistics.pl is located i.e in present working directory.
* If specified column has either all NaN values or the file doesnot have the column program returns the error.

