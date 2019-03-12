package Assignment6::Config;
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

Assignment6::Config 

=head1 SYNOPSIS

Creation:

    use Assignment6::Config qw( getErrorString4WrongNumberArguments );

    sub initializeChr21Hash{
        my $filledUsage = join(' ' , 'Usage:' , (caller(0))[3]) . '($refHash, $infile)';
        # test the number of arguments passed in were correct 
        @_ == 1 or confess getErrorString4WrongNumberArguments() , $filledUsage;
        
        my ($infile) = @_; 

        return;
    }

=head1 DESCRIPTION

This module was designed to be used by the Assignment 6 programs
=head1 EXPORTS

=head2 Default behavior

Nothing by default. 

use Assignment4::Config qw( getErrorString4WrongNumberArguments );

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

