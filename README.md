# NAME

Dist::Zilla::Plugin::InsertExample::FromMojoTemplates - Creates POD examples from a custom template format (deprecated)

![Requires Perl unknown](https://img.shields.io/badge/perl-unknown-brightgreen.svg) [![Travis status](https://api.travis-ci.org/Csson/p5-Dist-Zilla-Plugin-InsertExample-FromMojoTemplates.svg?branch=master)](https://travis-ci.org/Csson/p5-Dist-Zilla-Plugin-InsertExample-FromMojoTemplates) 

# VERSION

Version 0.0301, released 2016-01-25.

# SYNOPSIS

    ; In dist.ini
    [InsertExample::FromMojoTemplates]
    directory = examples/source
    filepattern = ^\w+-\d+\.mojo$

# DESCRIPTION

**Deprecated**. See [Pod::Elemental::Transformer::Stenciller](https://metacpan.org/pod/Pod::Elemental::Transformer::Stenciller) instead.

Dist::Zilla::Plugin::InsertExample::FromMojoTemplates inserts examples from [MojoX::CustomTemplateFileParser](https://metacpan.org/pod/MojoX::CustomTemplateFileParser) type files into POD.
Together with [Dist::Zilla::Plugin::Test::CreateFromMojo](https://metacpan.org/pod/Dist::Zilla::Plugin::Test::CreateFromMojo) this produces examples in POD from the same source that creates the tests.
The purpose is to help develop tag helpers for [Mojolicious](https://metacpan.org/pod/Mojolicious).

## Attributes

**`directory`**

Default: `examples/source`

Where DZP::IE::FMT should look for source files.

**`filepattern`**

Default: `^\w+-\d+\.mojo$`

Look for files that matches a certain pattern.

**`make_examples`**

Default: `1`

If true, will create html files in the chosen directory.

**`example_directory`**

Default: `examples`

The directory for html files.

## USAGE

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

    # EXAMPLE: filename.mojo:examples

**`all`**

Adds all examples in the source file. `all` can be used by itself or combined with exclusion commands.

**`1`**

Adds example number `3`. The test number is sequential. Looping tests count as one. You can add a number as in the example to make it easier to follow.

**`3-30`**

Add examples numbered `5` through `30`.

**`!5`**

Excludes example `5` from the previous range.

**`!22-26`**

Excludes examples numbered `22-26` from the previous range. If an example has been excluded it can't be included later. Exclusions are final.

**`examples`**

Includes all tests marked `==test example==` in the source file. Exclusion works as with `all`.

# SEE ALSO

The successor to this module is [Pod::Elemental::Transformer::Stenciller](https://metacpan.org/pod/Pod::Elemental::Transformer::Stenciller).

# SOURCE

[https://github.com/Csson/p5-Dist-Zilla-Plugin-InsertExample-FromMojoTemplates](https://github.com/Csson/p5-Dist-Zilla-Plugin-InsertExample-FromMojoTemplates)

# HOMEPAGE

[https://metacpan.org/release/Dist-Zilla-Plugin-InsertExample-FromMojoTemplates](https://metacpan.org/release/Dist-Zilla-Plugin-InsertExample-FromMojoTemplates)

# AUTHOR

Erik Carlsson <info@code301.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Erik Carlsson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
