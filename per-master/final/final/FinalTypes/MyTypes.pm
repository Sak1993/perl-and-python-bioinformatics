package FinalTypes::MyTypes;
use Moose;
use Carp;
use Moose::Util::TypeConstraints;
use MooseX::StrictConstructor;
use MooseX::Types -declare => [qw(FileType)]; 
use MooseX::Types::Moose qw/Str Int/;
subtype FileType,
as Str,
where {$_ eq 'fasta' || $_ eq 'genbank'},
message {"invalid file type:$_"};

1;
