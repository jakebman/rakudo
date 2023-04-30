#!/usr/bin/env raku

# This script reads the HTML entities data from
#   https://html.spec.whatwg.org/entities.json
# converts the JSON and uses that data structure to create the source
# code of the Str.html5parse hash lookup.

# always use highest version of Raku
use v6.*;

my $generator := $*PROGRAM-NAME;
my $generated := DateTime.now.gist.subst(/\.\d+/,'');
my $start     := '#- start of generated part of HTML entities';
my $end       := '#- end of generated part of HTML entities';

# slurp the whole file and set up writing to it
my $filename = "src/core.c/RakuAST/HTML/Entities.pm6";
my @lines = $filename.IO.lines;
$*OUT = $filename.IO.open(:w);

my $url      := 'https://html.spec.whatwg.org/entities.json';
my $proc     := run 'curl', $url, :out;
my $entities := $proc.out.slurp(:close);
my %json     := Rakudo::Internals::JSON.from-json($entities);

# for all the lines in the source that don't need special handling
while @lines {
    my $line := @lines.shift;

    # nothing to do yet
    unless $line.starts-with($start) {
        say $line;
        next;
    }

    say "$start ------------------------------------";
    say "#- Generated on $generated by $generator";
    say "#- PLEASE DON'T CHANGE ANYTHING BELOW THIS LINE";
    say "";

    # skip the old version of the code
    while @lines {
        last if @lines.shift.starts-with($end);
    }

    my %seen;
    for %json.keys.sort(-> $a, $b { $a.lc cmp $b.lc || $a cmp $b }) {
        my $key := .substr(1).chomp(';');  # lose the & and any ;
        unless %seen{$key}++ {
            my @codepoints := %json{$_}<codepoints>;
            my $value := @codepoints > 1
              ?? ('(' ~ @codepoints.join(',') ~ ')')
              !! @codepoints.head.Str;

            say "      '$key', $value,";
        }
    }

    # we're done for this role
    say "";
    say "#- PLEASE DON'T CHANGE ANYTHING ABOVE THIS LINE";
    say "$end --------------------------------------";
}

# close the file properly
$*OUT.close;

# vim: expandtab sw=4