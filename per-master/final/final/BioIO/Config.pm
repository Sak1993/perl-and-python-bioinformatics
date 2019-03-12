package BioIO::Config;
use strict;
use warnings;
use Carp qw( confess );
use Exporter 'import';
our @EXPORT_OK = qw(getErrorString4WrongNumberArguments 
                    getOutputDir
);
use Readonly;

# an error string for subroutines in this module, and to export via the function:
# getErrorString4WrongNumberArguments
Readonly my $ERROR_STRING_FOR_BAD_NUMBER_ARGUMENTS  => "\nIncorrect number of arguments in call to subroutine. ";
Readonly my $OUTPUT_DIR                             => 'OUTPUT';

=head1 NAME

BioIO::Config - package to show how to create a config file

=head1 SYNOPSIS

Creation:

    use BioIO::Config qw( getErrorString4WrongNumberArguments );

    sub initializeChr21Hash{
        my $filledUsage = join(' ' , 'Usage:' , (caller(0))[3]) . '($refHash, $infile)';
        # test the number of arguments passed in were correct 
        @_ == 1 or confess getErrorString4WrongNumberArguments() , $filledUsage;
        
        my ($infile) = @_; 

        return;
    }

=head1 DESCRIPTION

This module was designed to be used by the final Assignment programs, and show how to create
a configuration Perl package.

=head1 EXPORTS

=head2 Default behavior

Nothing by default. 

use BioIO::Config qw( getErrorString4WrongNumberArguments );

=head1 FUNCTIONS

=head2 getErrorString4WrongNumberArguments

   Arg [1]    : No Arguments

   Example    : @_ == 1 or confess getErrorString4WrongNumberArguments() , $filledUsage;

   Description: This will return the error string defined by constant $ERROR_STRING_FOR_BAD_NUMBER_ARGUMENTS 
                One can use to get a generic string for error handling when the incorrect number of 
                parameters is called in a Module.

   Returntype : A scalar

   Status     : Stable

=cut
sub getErrorString4WrongNumberArguments{
    my $filledUsage = join(' ' , 'Usage:', (caller(0))[3]) . '()';
    # test the number of arguments passed in were correct 
    @_ == 0 or confess $ERROR_STRING_FOR_BAD_NUMBER_ARGUMENTS , $filledUsage;
    return $ERROR_STRING_FOR_BAD_NUMBER_ARGUMENTS;
}
=head2 getOutputDir

   Arg [1]    : No Arguments

   Example    : my $outputDir = getOutputDir(); 

   Description: This will return the output directory for the project 

   Returntype : A scalar

   Status     : Stable

=cut
sub getOutputDir{
    my $filledUsage = join(' ' , 'Usage:', (caller(0))[3]) . '()';
    # test the number of arguments passed in were correct 
    @_ == 0 or confess $ERROR_STRING_FOR_BAD_NUMBER_ARGUMENTS , $filledUsage;
    return $OUTPUT_DIR;
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
