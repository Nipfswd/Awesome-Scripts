#!/usr/bin/perl
use strict;
use warnings;

my $filename = shift or die "Usage: $0 filename\n";

open(my $fh, '<', $filename) or die "Can't open '$filename': $!";

my %word_count;

while (my $line = <$fh>) {
    chomp $line;
    # Convert to lowercase, remove punctuation except apostrophes inside words
    $line = lc $line;
    $line =~ s/[^a-z0-9']+/ /g;
    
    for my $word (split /\s+/, $line) {
        next if $word eq '';
        $word_count{$word}++;
    }
}

close $fh;

# Sort by frequency desc, then alphabetically asc
for my $word (sort { $word_count{$b} <=> $word_count{$a} || $a cmp $b } keys %word_count) {
    print "$word: $word_count{$word}\n";
}
