#!/usr/bin/perl

use strict;
use warnings;
use 5.18.0;

#Reads dictionary file and adds each entry to a hash
my $filename = "englishspanish.txt";
open (my $fh, '<' , $filename)
    or die "Could not open file '$filename' $!";

my %dictionary;
while (my $row = <$fh>) {
    chomp $row;
    my @tokens = split('\t', $row);
    push @{$dictionary{$tokens[0]}}, $tokens[1];
}

#Closes file (may not be necessary)
close($fh);

#Displays menu
sub display_menu {
    print "\n---------- Please select an option: ----------\n";
    print "1) Translate English word to Spanish\n";
    print "2) Add a translation\n";
    print "3) Edit a translation\n";
    print "4) Remove a translation\n";
    print "5) Quit\n";
    print "-----------------------------------------------\n";
    
    my $ans = <STDIN>;
    chomp $ans;

    if ($ans > 0 && $ans < 6) {
        if ($ans == 1) {
            translate();
            display_menu();
        } elsif ($ans == 2) {
            add_entry();
            display_menu();
        } elsif ($ans == 3) {
            edit_entry();
            display_menu();
        } elsif ($ans == 4) {
            remove_entry();
            display_menu();
        } elsif ($ans == 5) {
            write_file($filename);
            print "---------- END ----------";
            exit;
        }
    }
}

#"Translates" the given word from English to Spanish
sub translate {
    print "Please enter an English word to translate: \n\n";
    my $word = <STDIN>;
    chomp $word;

    if (exists($dictionary{$word})) {
        foreach (@{$dictionary{$word}}) {
            print "\t$_\n";
        }
    } else {
        print "\t*Entry for $word not found*\n";
    }
}

#Adds an entry to the dictionary
sub add_entry {
    print "Please enter the English word: \n";
    my $englishWord = <STDIN>;
    chomp $englishWord;
    
    print "Please enter the Spanish word: \n";
    my $spanishWord = <STDIN>;
    chomp $spanishWord;
    
    push @{$dictionary{$englishWord}}, $spanishWord;
    print "\n*$englishWord => $spanishWord has been added to the dictionary*\n";
}

#Removes all translations for a given English word from the dictionary
sub remove_entry {
    print "Please enter the English word for the translations to be removed: \n";
    my $removeWord = <STDIN>;
    chomp $removeWord;
    
    if (exists($dictionary{$removeWord})) {
        delete($dictionary{$removeWord});
        print "\t*All entries for $removeWord have been removed from the dictionary*";
    } else {
        print "\t*Entry for $removeWord not found*\n";
    }
}

sub edit_entry {
    print "Please enter the English word for the translations to be edited: \n";
    my $englishEditWord = <STDIN>;
    chomp $englishEditWord;
    
    my $i=1;
    if (exists($dictionary{$englishEditWord})) {
        
        foreach (@{$dictionary{$englishEditWord}}) {
            print "\t$i) $_\n";
            $i++;
        }
        
        my $ans =-1;
        if ($i > 2) {
            print "\nPlease choose an option to edit: \n";
            $ans = <STDIN>
        } else {
            $ans = 1;
        }
        
        if($ans > 0 && $ans <= $i-1) {
            my $value = $dictionary{$englishEditWord}[$ans-1];
            print "\nEdit English[1] or edit Spanish[2]?: \n";
            my $newAns = <STDIN>;
            
            while ($newAns != 1 && $newAns != 2) {
                print "\nInvalid option selected. Edit English[1] or edit Spanish[2]?: \n";
                $newAns = <STDIN>;
            }
            
            print "Please enter the new translation: ";
            my $editWord = <STDIN>;
            
            delete($dictionary{$englishEditWord}[$ans-1]);
            
            if ($newAns == 1) {
                push @{$dictionary{$editWord}}, $value;
                print "*$englishEditWord => $value has been modified to $editWord => value*";
            } elsif ($newAns == 2) {
                push @{$dictionary{$englishEditWord}}, $editWord;
                print "*$englishEditWord => $value has been modified to $englishEditWord => $editWord*";
            } 
        }   
    } else {
        print "\t*Entry for $englishEditWord not found*\n";
    }
}

sub write_file {
    open (my $fh, '>' , $filename)
    or die "Could not open file '$filename' $!";
    
    foreach my $key (%dictionary) {
        foreach (@{$dictionary{$key}}) {
            print $fh "$key\t$_\n";
        }
    }
}

display_menu();

