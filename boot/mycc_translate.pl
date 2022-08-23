#!/usr/bin/perl
use strict;

our %syms;
our @maps;

$^I = ".raw";
my @call_stack;
while(<>){
    if (/^(0x\S+) - (0x\S+) \@\s+(0x\S+)\s*--\s*(\S+)/) {
        my ($a, $b, $off, $filename) = ($1, $2, $3, $4);
        push @maps, [hex($a), hex($b), hex($off), $filename];
        load_map($a, $b, $off, $filename);
    }
    elsif (/^(.*) Enter\s+0x(\S+)/) {
        my ($time, $addr) = ($1, $2);
        push @call_stack, $addr;
        print $time, '    ' x scalar(@call_stack);
        if ($syms{$addr}) {
            print "$syms{$addr} {\n";
        }
        else {
            my $str = find_symbol(hex($addr));
            print "$str {\n";
        }
    }
    elsif (/^(.*) Exit\s+0x(\S+)/) {
        my ($time, $addr) = ($1, $2);
        if ($addr eq $call_stack[-1]) {
            print $time, '    ' x scalar(@call_stack);
            print "}\n";
            pop @call_stack;
        }
    }
    else {
        print "$_";
    }
}

# ---- subroutines --------------------------------------------
sub load_map {
    my ($a, $b, $off, $filename) = @_;
    my $offset = hex($a) - hex($off);
    open In, "nm $filename 2>&1 |" or die "Can't open nm $filename 2>&1 |: $!\n";
    while(<In>){
        if (/^(0\S+) [Tt] (\w+)/) {
            my ($p, $name) = ($1, $2);
            my $addr = sprintf("%x", hex($p) + $offset);
            $syms{$addr} = $name;
        }
    }
    close In;
}

sub find_symbol {
    my ($addr) = @_;
    foreach my $m (@maps) {
        if ($addr >= $m->[0] && $addr <= $m->[1]) {
            my $a = $addr - ($m->[0] - $m->[2]);
            return sprintf("%x @ $m->[3]", $a);
        }
    }
    return sprintf("0x%x", $addr);
}

