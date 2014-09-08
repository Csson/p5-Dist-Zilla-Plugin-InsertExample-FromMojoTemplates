package Dist::Zilla::Plugin::InsertExample::FromMojoTemplates;

use strict;
use warnings;
use 5.10.1;

use File::Find::Rule;
use MojoX::CustomTemplateFileParser;
use Moose;
with 'Dist::Zilla::Role::FileMunger';
with 'Dist::Zilla::Role::FileFinderUser' => {
    default_finders => [qw/:InstallModules :ExecFiles]/],
};

has directory => (
    is => 'ro',
    isa => 'Str',
    default => sub { 'examples/source' },
);
has filepattern => (
    is => 'ro',
    default => sub { qr/\w+-\d+\.mojo/ },
);

sub munge_files {
    my $self = shift;
    $self->munge_file($_) for @{ $self->found_files };
}

sub munge_file {
    my $self = shift;
    my $filename = shift;

    my $content = $filename->content;
    my $re = $self->filepattern;
    if($content =~ m{^ # \s* EXAMPLE: \s* ($re):(.*) $}x) {
        my $filename = $1;
        my $what = $2;
        $what =~ s{ }{}g;
        $what =~ s{,,+}{,}g;

        my(@configs) = split m/,/ => $what;

        my @wanted = ();
        my @unwanted = ();
        my $all = 0;

        CONFIG:
        foreach my $config (@configs) {
            if($config eq 'all') {
                $all = 1;
            }
            elsif($config !~ m{^ (!) (\d+) (?:-(\d+))? }x) {
                my $exclude = defined $1 ? 1 : 0;
                my $first = $2;
                my $second = $3 || $first;

                map { push @wanted   => $_ } ($first..$second) if !$exclude;
                map { push @unwanted => $_ } ($first..$second) if $exclude;
            }
        }
        my %wanted;
        $wanted{ $_ } = 1 for @wanted;
        delete $wanted{ $_ } for @unwanted;

        my $structure = MojoX::CustomTemplateFileParser->new( path => path($self->directory)->child($filename)->absolute )->parse->structure;
        use Data::Dumper;
        warn $structure;
    }
}

1;
__END__

=encoding utf-8

=head1 NAME

Dist::Zilla::Plugin::InsertExample::FromMojoTemplate - Creates POD examples from custom L<Mojolicious> templates.

=head1 SYNOPSIS

  ; In dist.ini
  [InsertExample::FromMojoTemplate]
  directory = examples/source
  filepattern = ^\w+-\d+\.mojo$

=head1 DESCRIPTION

Dist::Zilla::Plugin::InsertExample::FromMojoTemplate inserts examples from L<MojoX::CustomTemplateFileParser> type files into POD.
Together with L<Dist::Zilla::Plugin::Test::CreateFromMojo> this produces examples in POD from the same source that creates the tests.
The purpose is to help develop tag helpers for L<Mojolicious>.

=head2 Attributes

B<C<directory>>

Default: C<examples/source>

Where DZP::IE::FMT should look for source files.

B<C<filepattern>

Default: C<^\w+-\d+\.mojo$>

Look for files that matches a certain pattern.

=head2 USAGE

Source files looks like this:

   ==test example 1==
    --t--
        %= link_to 'The example 3' => ['http://www.perl.org/']
    --t--
    --e--
        <a href="http://www.perl.org/">Perl</a>
    --e--

This is a test block. One file can have many test blocks.

In your pod:

    # EXAMPLE: filename.mojo:1, 3-30, !5, !22-26

    # EXAMPLE: filename.mojo:all

B<C<all>>

Adds all examples in the source file. C<all> can be used by itself or combined with exclusion commands.

B<C<1>>

Adds example number C<3>. In order to be able to refer to examples with numbers they must be numbered in the source file.

B<C<3-30>>

Add examples numbered C<5> through C<30>.

B<C<!5>>

Excludes example C<5> from the previous range.

B<C<!22-26>>

Excludes examples numbered C<22-26> from the previous range. If an example has been excluded it can't be included later. Exclusions are final.


=head1 AUTHOR

Erik Carlsson E<lt>info@code301.comE<gt>

=head1 COPYRIGHT

Copyright 2014- Erik Carlsson

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
