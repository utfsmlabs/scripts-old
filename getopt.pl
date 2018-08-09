#!/usr/bin/perl
use Getopt::Std;
%options=();
getopts("a:b:c:"=> \%options);

print "-a actiado $options{a}\n" if defined $options{a};
print "-b actiado $options{b}\n" if defined $options{b};
print "-c actiado $options{c}\n" if defined $options{c};


