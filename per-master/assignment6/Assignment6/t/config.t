e strict;
use warnings;
use Test::More tests => 3;
use Test::Exception;#need this to get dies_ok and lives_ok to work
=cut
if I did not set my PERL5LIB, I'd have to do something like this
use lib '/home/cleslin/Documents/teachingCode/BIOL6200/assignment4';
But my .bashrc has the following:
PERL5LIB=$PERL5LIB:/home/cleslin/Documents/teachingCode/BIOL6200/assignment4
export PERL5LIB
=cut

BEGIN { use_ok('Assignment4::Config', qw(getErrorString4WrongNumberArguments)) }
#dies when give it a bogus file name
#dies_ok { getErrorString4WrongNumberArguments(1) } 'dies ok when an argument is passed';
#is(getOutputDir, 'OUTPUT',  "getOutputDir returns 'OUTPUT'");
