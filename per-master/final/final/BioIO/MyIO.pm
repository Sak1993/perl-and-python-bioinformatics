package BioIO::MyIO;
use warnings;
use strict;
use BioIO::Config qw(getErrorString4WrongNumberArguments);
use Carp qw( confess );
use Exporter 'import';
our @EXPORT_OK = qw(getFh makeDir);

=head1 NAME

BioIO::MyIO - package to handle opening of files and passing filehandles

=head1 SYNOPSIS

Creation:

   use BioIO::MyIO qw(getFh);
   my $infile = 'test.txt'
   # get a filehandle for reading
   my $fh = getFh('<', $infile);

=head1 DESCRIPTION

This module was designed to be used by the final programs, and show how to create
a Perl package used for IO

=head1 EXPORTS

=head2 Default behavior

Nothing by default. 

use Assignment7::MyIO qw( getFh );

=head1 FUNCTIONS

=head2 getFH

   Arg [1]    : Type of file to open, reading '<', writing '>', appending '>>'
   
   Arg [2]    : A name for the file


   Example    : my $fh = getFh('<', $infile);

   Description: This will return a filehandle to the file passed in.  This function
                can be used to open, write, and append, and get the File Handle. You are 
                best giving the absolute path, but since we are using this Module in the same directory 
                as the calling scripts, we are fine.

   Returntype : A filehandle

   Status     : Stable

=cut

sub getFh{
    my $filledUsage = join(' ' , 'Usage:', (caller(0))[3]) . '($type, $file)';
    # test the number of arguments passed in were correct 
    @_ == 2 or confess getErrorString4WrongNumberArguments() , $filledUsage;

    my ($type, $file) = @_;

    my $confessStatement = "Can't open " . $file;
    if ($type ne '>' && $type ne '<' && $type ne '>>'){
        confess "Can't use this type for opening/writing/appending '" , $type , "'";
    }
    # do not open a directory filehandle 
    if (-d $file){ # if what was sent in was a direcotry, die
        confess "The file you provided is a directory";
    }

    # error checking for specific die output
    if ($type eq '<'){
        $confessStatement .=  " for reading: ";
    }
    elsif ($type eq '>'){
        $confessStatement .=  " for writing: ";
    }
    elsif ($type eq '>>'){
        $confessStatement .=  " for appending: ";
    }

    # go forward with the open  
    my $fh;
    unless (open($fh, $type , $file) ) {
        confess join(' ' , $confessStatement , $!);
    }
    return ($fh);
}

=head2 makeDir

   Arg [1]    : A directory to make
   
   Example    : makeDir('OUTPUT');

   Description: This will test if there is a need to make a directory, and if there is it will attempt
                to make the directory if it has privileges

   Returntype : returns 1 on successful creation of directory

   Status     : Stable

=cut
sub makeDir{
    my $filledUsage = join(' ' , 'Usage:', (caller(0))[3]) . '("OUTPUT")';
    # test the number of arguments passed in were correct 
    @_ == 1 or confess getErrorString4WrongNumberArguments() , $filledUsage;

    my ($dir) = @_;
    if (-e $dir){
        return;
    }
    else{
        mkdir $dir or confess join(" ", "Cannot make directory", $dir . "\n", $!);
        return 1;
    }
}

=head1 COPYRIGHT AND LICENSE

Copyright [2011-2015] Chesley Leslin

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself, either Perl version 5.8.4 or, at your
option, any later version of Perl 5 you may have available.

=head1 CONTACT

Please email comments or questions to Chesley Leslin c.leslin@neu.edu

=head1 SETTING PATH

if I did not set my PERL5LIB, I'd have to do something like this

use lib '/home/cleslin/Documents/teachingCode/BIOL6200/assignment4';

But my .bashrc has the following:

PERL5LIB=/home/cleslin/Documents/teachingCode/BIOL6200/assignment4

export PERL5LIB
=cut
1;
