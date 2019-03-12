#!/usr/bin/perl
use strict;
use warnings;
use feature qw(say);
use Test::More tests => 70; #change to the number of test you are going to do
use BioIO::SeqIO;# ':ALL'; #bring in subs if this was a module, here its Moose, no need
use BioIO::Seq;# ':ALL'; #bring in subs if this was a module, here its Moose, no need
use Test::Exception::LessClever; # need this to get dies_ok to work with croak & confess inside and object


my $fileNameIn = 'INPUT/test.gb.txt';
my $class = 'BioIO::SeqIO';

my $seqIoObj = BioIO::SeqIO->new(filename => $fileNameIn, fileType => 'genbank'); # object creation

dies_ok {BioIO::SeqIO->new(filename => $fileNameIn, fileType => 'junk')} '... dies when bad fileType sent to the BioIO::SeqIO constructor';
dies_ok {BioIO::SeqIO->new(filename => $fileNameIn)} '... dies when no fileType sent to the BioIO::SeqIO constructor';
dies_ok {BioIO::SeqIO->new(fileType => 'fasta')} '... dies when no filename sent to the BioIO::SeqIO constructor';
dies_ok {BioIO::SeqIO->new(filename => $fileNameIn, fileType => 'fasta', => _gi => [])} '... dies when _gi sent to BioIO::SeqIO constructor';
dies_ok {BioIO::SeqIO->new(filename => $fileNameIn, fileType => 'fasta', => _seq => {})} '... dies when _seq sent to BioIO::SeqIO constructor';
dies_ok {BioIO::SeqIO->new(filename => $fileNameIn, fileType => 'fasta', => _def => {})} '... dies when _def sent to BioIO::SeqIO constructor';
dies_ok {BioIO::SeqIO->new(filename => $fileNameIn, fileType => 'fasta', => _acc => {})} '... dies when _acc sent to BioIO::SeqIO constructor';
dies_ok {BioIO::SeqIO->new(filename => $fileNameIn, fileType => 'fasta', => _current => 1)} '... dies when _current sent to BioIO::SeqIO constructor';


# Added new dies_ok
foreach my $method (qw/_gi _current _acc _def _seq filename fileType/ ){
    dies_ok { $seqIoObj->$method('test') } "... dies ok when trying to change ro attributre '$method' constructor";
}

isa_ok ($seqIoObj, $class);

#method returns an array ref
is 3, scalar @{ $seqIoObj->_gi() }, "The number of gi's is correct";
#method returns a hash ref
is 3, scalar keys %{ $seqIoObj->_accn() }, "The number of accn's is correct";
#method returns a hash ref
is 3, scalar keys %{ $seqIoObj->_seq() }, "The number of seq's is correct";
#method returns a hash ref
is 3, scalar keys %{ $seqIoObj->_def() }, "The number of def's is correct";

dies_ok{$seqIoObj->nextSeq(1)} '... nextSeq dies when not the right number of parameters are passed in';
dies_ok{$seqIoObj->_getFastaSeqs(1)} '... _getFastaSeqs dies when not the right number of parameters are passed in';
dies_ok{$seqIoObj->_getGenbankSeqs(1)} '... _getGenbankSeqs dies when not the right number of parameters are passed in';


##tess to see if the attributes are right for each SeqObj
my $NP_571131 = 'MAVWLQAGALLVLLVVSSVSTNPGTPQHLCGSHLVDALYLVCGPTGFFYNPKRDVEPLLGFLPPKSAQETEVADFAFKDHAELIRKRGIVEQCCHKPCSIFELQNYCN';
my $NP_990553 = 'MALWIRSLPLLALLVFSGPGTSYAAANQHLCGSHLVEALYLVCGERGFFYSPKARRDVEQPLVSSPLRGEAGVLPFQQEEYEKVKRGIVEQCCHNTCSLYQLENYCN';
my $NP_001103242 = 'MALWTRLLPLLALLALWAPAPAQAFVNQHLCGSHLVEALYLVCGERGFFYTPKARREAENPQAGAVELGGGLGGLQALALEGPPQKRGIVEQCCTSICSLYQLENYCN';
# go thru SeqIO obj and print all seq
while (my $seqObj = $seqIoObj->nextSeq() ) {
    #test for each of these cases
    if ($seqObj->accn eq 'NP_571131.1'){
        is $NP_571131, $seqObj->seq, 'The sequences are the same for NP_571131.1';
        is '18858895', $seqObj->gi, 'The gi\'s are the same for NP_571131.1';
        is 'NP_571131.1', $seqObj->accn, 'The accn\'s are the same for NP_571131.1';
        is 'preproinsulin [Danio rerio]', $seqObj->def, 'def\'s are the same for NP_571131.1';
    }
    elsif ($seqObj->accn eq 'NP_990553.1'){
        is $NP_990553, $seqObj->seq, 'The sequences are the same for NP_990553.1';
        is '45382573', $seqObj->gi, 'The gi\'s are the same for NP_990553.1';
        is 'NP_990553.1', $seqObj->accn, 'The accn\'s are the same for NP_990553.1';
        is 'insulin precursor [Gallus gallus]', $seqObj->def, 'def\'s are the same for NP_990553.1';
    }
    elsif ($seqObj->accn eq 'NP_001103242.1'){
        is $NP_001103242, $seqObj->seq, 'The sequences are the same for NP_001103242.1';
        is '172073148', $seqObj->gi, 'The gi\'s are the same for NP_001103242.1';
        is 'NP_001103242.1', $seqObj->accn, 'The accn\'s are the same for NP_001103242.1';
        is 'insulin [Sus scrofa]', $seqObj->def, 'def\'s are the same for NP_001103242.1';
    }
    else{
        die "Did you parse the accession with a version in your accn method?... dying";
    }
}

my $seqObj = BioIO::Seq->new(gi => 1234, accn => 'ABCDEF', def => 'test', seq => 'ACGTACGTACGTACGT'); # object creation

dies_ok {BioIO::Seq->new(gia => 1234, accn => 'ABCDEF', def => 'test', seq => 'ACGTACGTACGTACGT')} '... dies when bad attribute sent to the Bio::Seq constructor';
dies_ok {BioIO::Seq->new(gi => 1234,  acc => 'ABCDEF', def => 'test', seq => 'ACGTACGTACGTACGT')} '... dies when bad attribute sent to the Bio::Seq constructor';
dies_ok {BioIO::Seq->new(gi => 1234,  accn => 'ABCDEF', deff => 'test', seq => 'ACGTACGTACGTACGT')} '... dies when bad attribute sent to the Bio::Seq constructor';
dies_ok {BioIO::Seq->new(gi => 1234,  accn => 'ABCDEF', def => 'test', sequence => 'ACGTACGTACGTACGT')} '... dies when bad attribute sent to Bio::Seq the constructor';
dies_ok {BioIO::Seq->new(accn => 'ABCDEF', def => 'test', seq => 'ACGTACGTACGTACGT')} '... when gi not sent to the Bio::Seq constructor';
dies_ok {BioIO::Seq->new(gi => 1234, def => 'test', seq => 'ACGTACGTACGTACGT')} '... when def not sent to the Bio::Seq constructor';
dies_ok {BioIO::Seq->new(gi => 1234,  accn => 'ABCDEF',  seq => 'ACGTACGTACGTACGT')} '... when def not sent to the Bio::Seq constructor';
dies_ok {BioIO::Seq->new(gi => 1234, accn => 'ABCDEF', def => 'test',)} '... when seq not sent to the Bio::Seq constructor';
$class = 'BioIO::Seq';
isa_ok ($seqObj, $class);

is 'ACGTACGTACGTACGT', $seqObj->seq, 'The sequences are the same for the test';
is 'ABCDEF', $seqObj->accn, 'The accn are the same for the test';
is 1234, $seqObj->gi, 'The gi are the same for the test';
is 'test', $seqObj->def, 'The def are the same for the test';



my $seqObj2 = BioIO::Seq->new(gi => 1234, accn => 'ABCDEF', def => 'test', seq => 'ATGTACGTGGATCCACGTACGTCGGCCGAAAGACTACAAAGTCTGA'); # object creation
my $seqObj3 = BioIO::Seq->new(gi => 1234, accn => 'ABCDEF', def => 'test', seq => 'ATGTACGTGGATCCACGTACGTCGGCCGTGG'); # object creation
is 1, $seqObj2->checkCoding(), "Found a coding sequence";
is undef, $seqObj3->checkCoding(), "Did not find a coding sequence";
dies_ok{$seqObj2->checkCoding(1)} '... checkCoding dies when not the right number of parameters are passed in';

my ($pos, $sequence) = $seqObj2->checkCutSite('GGATCC');
is 9, $pos, "Foud the right cutsite for BamH1";
is 'GGATCC', $sequence, "Found the right sequence for BamH1 cut site";

($pos, $sequence) = $seqObj2->checkCutSite('CG[GA][CT]CG');
is 23, $pos, "Foud the right cutsite for BsiEI";
is 'CGGCCG', $sequence, "Found the right sequence for BsiEI cut site";

($pos, $sequence) = $seqObj2->checkCutSite('GAC.{6}GTC');
is 32, $pos, "Foud the right cutsite for DrDI";
is 'GACTACAAAGTC', $sequence, "Found the right sequence for DrDI cut site";

($pos, $sequence) = $seqObj2->checkCutSite('GACCCCCCCC');
is undef, $pos, "Foud the right cutsite for fake cute site";
is undef, $sequence, "Found the right sequence for fake cute site";

dies_ok{$seqObj2->checkCutSite()} '... checkCutSite dies when not the right number of parameters are passed in';


my $seqObj4 = $seqObj2->subSeq(1, 10);
isa_ok ($seqObj4, $class);
is 'ATGTACGTGG', $seqObj4->seq, "Found the right sequence for subseq";

my $seqObj5;
dies_ok{$seqObj5 = $seqObj3->subSeq(1, 32)} '... subSeq dies when too far the subSeq dies';
dies_ok{$seqObj5 = $seqObj3->subSeq(1)} '... subSeq dies when not the right number of parameters are passed in';
dies_ok{$seqObj5 = $seqObj3->subSeq(undef, 1)} '... subSeq dies when not enough parameters that are defined are passed in (HINT defined)';
dies_ok{$seqObj5 = $seqObj3->subSeq(1, undef)} '... subSeq dies when not enough parameters that are defined are passed in (HINT defined)';

my $fileOutName = 'testScript.fasta';
my $seq = 'A' x 80;
my $seqObj6 = BioIO::Seq->new(gi => 1234, accn => 'ABCDEF', def => 'test', seq => $seq); # object creation
$seqObj6->writeFasta($fileOutName, 60);
my ($compareSeq) = `sed -n '2p;' $fileOutName`;
$compareSeq =~ s/\n//g;
is 60, length $compareSeq, "Found the right length sequence";

$seqObj6->writeFasta($fileOutName);
($compareSeq) = `sed -n '2p;' $fileOutName`;
$compareSeq =~ s/\n//g;
is 70, length $compareSeq, "Found the right length sequence for default (70)";

dies_ok{$seqObj6->writeFasta()} '... writeFasta dies when not the right number of parameters are passed in';
dies_ok{$seqObj6->writeFasta($fileOutName, 60, 1)} '... writeFasta dies when not the right number of parameters are passed in';
unlink $fileOutName;
