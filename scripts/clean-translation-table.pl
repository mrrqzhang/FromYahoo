#!/usr/bin/perl -w

# $Id: filter-model-given-input.pl 2082 2009-02-05 17:39:36Z jdschroeder $
# Given a moses.ini file and an input text prepare minimized translation
# tables and a new moses.ini, so that loading of tables is much faster.

# original code by Philipp Koehn
# changes by Ondrej Bojar

use strict;

my $MAX_LENGTH = 10;

# utilities
my $ZCAT = "gzip -cd";

# consider phrases in input up to this length
# in other words, all phrase-tables will be truncated at least to 10 words per
# phrase

my $dir = shift; 
my $config = shift;
my $fr = shift;
my $en = shift ;

if (!defined $dir || !defined $config || !defined $fr || !defined $en) {
  print STDERR "usage: filter-model-given-input.pl targetdir moses.ini fr.train.corpus en.train.corpus\n";
  exit 1;
}

$dir = ensure_full_path($dir);

# buggy directory in place?
if (-d $dir && ! -e "$dir/info") {
    print STDERR "The directory $dir exists but does not belong to me. Delete $dir!\n";
    exit(1);
}



# filter the translation and distortion tables
safesystem("mkdir -p $dir") or die "Can't mkdir $dir";

# get tables to be filtered (and modify config file)
my (@TABLE,@TABLE_FACTORS,@TABLE_NEW_NAME,%CONSIDER_FACTORS);
my %new_name_used = ();
open(INI_OUT,">$dir/moses.ini") or die "Can't write $dir/moses.ini";
open(INI,$config) or die "Can't read $config";
while(<INI>) {
    print INI_OUT $_;
    if (/ttable-file\]/) {
        while(1) {	       
    	my $table_spec = <INI>;
    	if ($table_spec !~ /^([\d\,\-]+) ([\d\,\-]+) (\d+) (\S+)$/) {
    	    print INI_OUT $table_spec;
    	    last;
    	}
    	my ($source_factor,$t,$w,$file) = ($1,$2,$3,$4);

    	chomp($file);
    	push @TABLE, $file;

    	my $new_name = "$dir/phrase-table.$source_factor-$t";
        my $cnt = 1;
        $cnt ++ while (defined $new_name_used{"$new_name.$cnt"});
        $new_name .= ".$cnt";
        $new_name_used{$new_name} = 1;
    	print INI_OUT "$source_factor $t $w $new_name\n";
    	push @TABLE_NEW_NAME,$new_name;

    	$CONSIDER_FACTORS{$source_factor} = 1;
        print STDERR "Considering factor $source_factor\n";
    	push @TABLE_FACTORS, $source_factor;
        }
    }
    elsif (/distortion-file/) {
        while(1) {
    	  my $table_spec = <INI>;
    	  if ($table_spec !~ /^([\d\,\-]+) (\S+) (\d+) (\S+)$/) {
    	      print INI_OUT $table_spec;
    	      last;
    	}
    	my ($factors,$t,$w,$file) = ($1,$2,$3,$4);
	my $source_factor = $factors;
	$source_factor =~ s/\-[\d,]+$//;

    	chomp($file);
    	push @TABLE,$file;

    	$file =~ s/^.*\/+([^\/]+)/$1/g;
    	my $new_name = "$dir/$file";
	$new_name =~ s/\.gz//;
    	print INI_OUT "$factors $t $w $new_name\n";
    	push @TABLE_NEW_NAME,$new_name;

    	$CONSIDER_FACTORS{$source_factor} = 1;
        print STDERR "Considering factor $source_factor\n";
    	push @TABLE_FACTORS,$source_factor;
        }
    }
}
close(INI);
close(INI_OUT);


# get the phrase pairs appearing in the input text, up to the $MAX_LENGTH


my %PHRASE_USED ;

open(FR, $fr) or die "Can't read $fr" ;
open(EN, $en) or die "Can't read $en" ;

while(my $frline=<FR>) {
	chomp($frline) ;
	my $enline=<EN> ;
	chomp($enline) ;
	$PHRASE_USED{"$frline|||$enline"} = 1 ;
}

close(FR) ;
close(EN) ;



# filter files
for(my $i=0;$i<=$#TABLE;$i++) {
    my ($used,$total) = (0,0);
    my $file = $TABLE[$i];
    my $factors = $TABLE_FACTORS[$i];
    my $new_file = $TABLE_NEW_NAME[$i];
    print STDERR "filtering $file -> $new_file...\n";

    my $openstring;
    if ($file !~ /\.gz$/ && -e "$file.gz") {
      $openstring = "$ZCAT $file.gz |";
    } elsif ($file =~ /\.gz$/) {
      $openstring = "$ZCAT $file |";
    } else {
      $openstring = "< $file";
    }

    open(FILE,$openstring) or die "Can't open '$openstring'";
    open(FILE_OUT,">$new_file") or die "Can't write $new_file";

    while(my $entry = <FILE>) {
        my ($foreign,$english, $rest) = split(/ \|\|\| /,$entry,3);
        $foreign =~ s/ $//;
        $english =~ s/ $//;
        if (defined($PHRASE_USED{"$foreign|||$english"})) {
    	print FILE_OUT $entry;
    	$used++;
        }
        $total++;
    }
    close(FILE);
    close(FILE_OUT);
    die "No phrases found in $file!" if $total == 0;
    printf STDERR "$used of $total phrases pairs used (%.2f%s) - note: max length $MAX_LENGTH\n",(100*$used/$total),'%';
}

open(INFO,">$dir/info");
close(INFO);


print "To run the decoder, please call:
  moses -f $dir/moses.ini \n";

sub safesystem {
  print STDERR "Executing: @_\n";
  system(@_);
  if ($? == -1) {
      print STDERR "Failed to execute: @_\n  $!\n";
      exit(1);
  }
  elsif ($? & 127) {
      printf STDERR "Execution of: @_\n  died with signal %d, %s coredump\n",
          ($? & 127),  ($? & 128) ? 'with' : 'without';
      exit(1);
  }
  else {
    my $exitcode = $? >> 8;
    print STDERR "Exit code: $exitcode\n" if $exitcode;
    return ! $exitcode;
  }
}
sub ensure_full_path {
    my $PATH = shift;
    return $PATH if $PATH =~ /^\//;
    my $dir = `pawd 2>/dev/null`;
    if (!$dir) {$dir = `pwd`;}
    chomp $dir;
    $PATH = $dir."/".$PATH;
    $PATH =~ s/[\r\n]//g;
    $PATH =~ s/\/\.\//\//g;
    $PATH =~ s/\/+/\//g;
    my $sanity = 0;
    while($PATH =~ /\/\.\.\// && $sanity++<10) {
        $PATH =~ s/\/+/\//g;
        $PATH =~ s/\/[^\/]+\/\.\.\//\//g;
    }
    $PATH =~ s/\/[^\/]+\/\.\.$//;
    $PATH =~ s/\/+$//;
    return $PATH;
}

