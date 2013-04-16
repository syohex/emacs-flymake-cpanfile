#!perl
use strict;
use warnings;
use Module::CPANfile;

my $cpanfile = shift;
eval { Module::CPANfile->load($cpanfile) };
if (my $err = $@) {
    print format_errors($err), "\n";
} else {
    exit 0;
}

sub format_errors {
    my $err_msg = shift;

    my ( $err_text_ahead, $file_name, $line, $err_text_rear ) =
      $err_msg =~ /failed: (.*) at (.*) line (\d+)(?:, |\.)?(.*)/;

    my $err_text = format_error_text($err_text_ahead, $err_text_rear);
    return "$file_name:$line:$err_text";
}

sub format_error_text {
    my ($err_text_ahead, $err_text_rear) = @_;

    $err_text_ahead ||= '';
    $err_text_rear  ||= '';

    return "$err_text_ahead: $err_text_rear";
}
