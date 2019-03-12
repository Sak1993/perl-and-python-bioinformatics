package BioIO::SeqIO;
use BioIO::MyIO qw(getFh);
use Moose;
use Carp;
use BioIO::Config qw(getErrorString4WrongNumberArguments);
use MooseX::StrictConstructor;
use FinalTypes::MyTypes qw(FileType);
use BioIO::Seq;
use feature qw(say);

has '_gi' => (
		is       => 'ro',
		isa      => 'ArrayRef',
		writer   => '_writer_gi',
		init_arg => undef
	     );
has '_seq' => (
		is       => 'ro',
		isa      => 'HashRef',
		writer   => '_writer_seq',
		init_arg => undef
	      );
has '_def' => (
		is       => 'ro',
		isa      => 'HashRef',
		writer   => '_writer_def',
		init_arg => undef
	      );
has '_accn' => (
		is       => 'ro',
		isa      => 'HashRef',
		writer   => '_writer_accn',
		init_arg => undef
	       );
has '_current' => (
		is       => 'ro',
		isa      => 'Int',
		default => 0,
		writer   => '_writer_current',
		init_arg => undef
		);

has 'filename' => (
		is       => 'ro',
		isa      => 'Str',
		required => 1,
		);

has 'fileType' => (
		isa => FileType,
		is => 'ro',
		required => 1,
		);

#-------------------------------------------------------------------------------
#_getGenbankSeqs: private to the class, and called by the BUILD method 
#-------------------------------------------------------------------------------
# _getGenbankSeqs read seqs and info, and fills in the SeqIO attributes 
# with _gi, _accn, _def and _seq attributes created
#-------------------------------------------------------------------------------

sub _getGenbankSeqs {
	my $filledUsage = qq(Usage: \$seqIOObj->_getGenbankSeqs(fileName) );
# test the number of arguments passed in were correct 
	@_ == 2 or confess getErrorString4WrongNumberArguments() , $filledUsage;
	my ($self,$filename) = @_;
	my $fh = getFh('<', $filename);
# initialize required array and hashes locally.
	my @gi;
	my %seq;
	my %def;
	my %accn;
	{
		$/ = "//\n";
		while (<$fh>){
			my $token = $_;
			unless ($token =~ /^\s*LOCUS/){
				next;
			}
			$token =~ m/DEFINITION\s+(.*)\nACCESSION/s;
			my $definition = $1;
			if($definition){
				$definition =~s/\n/ /g;
				$definition =~s/\s+/ /g;}
			$token =~ m/VERSION\s+(.+)GI:(\w+)/;
			my $accession = $1;
			if($accession){		
				$accession =~s/\s//g;}
			my $gid = $2;
			$token =~ m/ORIGIN(.*)/s;
			my $sequence = $1;
			if ($sequence){

				$sequence =~ s/\s+//g;
				$sequence =~ s/\d+//g;
				$sequence =~ s/\/\///;				
					$sequence = uc($sequence);
			}
			if ($gid){
				push (@gi, $gid);
				$accn{$gid} = $accession;
				$def{$gid} = $definition;
				$seq{$gid} = $sequence;
			}
		}
	}
	$self->_writer_gi(\@gi);
	$self->_writer_seq(\%seq);
	$self->_writer_def(\%def);
	$self->_writer_accn(\%accn);
}

sub nextSeq {
	my $filledUsage = qq(Usage: \$seqIOObj->nextSeq() );
# test the number of arguments passed in were correct 
	@_ == 1 or confess getErrorString4WrongNumberArguments() , $filledUsage;
	my ($self) = @_;
	if ($self->_current < scalar @{$self-> _gi()}){
		my $gi = $self->_gi->[$self->_current()];
		$self->_writer_current($self->_current+1);
		return BioIO::Seq->new(gi => $gi,
				seq => $self->_seq->{$gi},
				def => $self->_def->{$gi},
				accn => $self->_accn->{$gi},
				);
	}
	else{
		return undef;
	}
}

sub BUILD {
	my ($self) =@_;
	if ($self->fileType eq 'genbank'){
		$self->_getGenbankSeqs($self->filename);
	}
	else{
		$self->_getFastaSeqs($self->filename);
	}
}

#-------------------------------------------------------------------------------
# _getFastaSeqs: private to the class, and called by the BUILD method 
#-------------------------------------------------------------------------------
# _getFastaSeqs read seqs and info, and fills in the SeqIO attributes 
# with _gi, _accn, _def and _seq attributes created
#---------------------------------------------------------------------------

sub _getFastaSeqs {
	my $filledUsage = qq(Usage: \$seqIOObj->_getGenbankSeqs(fileName) );
# test the number of arguments passed in were correct 
	@_ == 2 or confess getErrorString4WrongNumberArguments() , $filledUsage;
	my ($self, $filename) = @_;
	my $fh = getFh('<', $filename);
	my @gi;
	my %accn;
	my %def;
	my %seq;
	{
		$/ = ">";
		while (<$fh>){ 
			my $token = $_;
			$token =~ /^(.*?)$(.*)$/ms;
			my $header = $1;
			my $sequence = $2;
			my @splithead = split(/\|/,$header);
			my $gid = $splithead[1];
			my $accession = $splithead[3];
			my $definition = $splithead[4];
			if($gid){
				push(@gi,$gid);
				$accn{$gid}=$accession;
				$def{$gid}=$definition;
				$seq{$gid}=$sequence;
			}
		}
	}
	$self->_writer_gi(\@gi);
	$self->_writer_seq(\%seq);
	$self->_writer_def(\%def);
	$self->_writer_accn(\%accn);
}

1;
