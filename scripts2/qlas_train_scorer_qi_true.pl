#!/home/y/bin/perl -w

use strict;
use Getopt::Std;
use MIME::Lite;

my $arch = `uname -m`; chomp($arch);
my $archbin = ($arch eq 'x86_64')? "bin64" : "bin";
my $ydir = "/home/y";
my $QLAS_HOME = ""; # empty => get from $PATH
my $SCORER_HOME = "$ydir/share/scorer";
my $logging_dir = '-';
my %opts;
my $tmp_dir = "/tmp/qlas_scorer_train";
my $cfg = "$ydir/etc/config.us.xml";
my $resource_dir = "$ydir";
my $editorial_mapping_file = "$SCORER_HOME/data/mapping_from_editorial_to_eng.txt";
my $bestfirst = 3;
my $trees = 150;
my $split_for_eval = 1;
my $max_interpretations = 99999999;
my $mail_report = '';
my $alatheia_to_tsv_args = '';
my $weight_args = '';
my $query_boost = '';
my $train_suffix = '';
my $intl = 'us';
my $copy_data = 1;
my %boost_per_query;
my $eval_filter = '';
my $existing_scorer_dir = '';
my $num_folds = 5;
my $random_seed = '';
my $language = 'en';

my $status = getopts('i:c:y:Y:s:S:w:W:e:M:h:p:m:l:H:C:R:b:t:T:r:f:E:d:k:Ln', \%opts);
die "Usage: $0\n" .
    "     -h QLAS_HOME,              default $ydir\n" .
    "     -H SCORER_HOME,            default $SCORER_HOME\n" .
    "     -M max interpretations     default $max_interpretations\n" .
    "     -r mail-report-to,         default no mail\n" .
    "     -T tmp dir,                default $tmp_dir\n" .
    "     -l logging dir,            default working-dir\n" .
    "     -b GBDT bestFirst,         default $bestfirst\n" .
    "     -t GBDT num trees,         default $trees\n" .
    "     -p editorial mapping,      default $editorial_mapping_file\n" .
    "     -w 'weight-args',          default no instance weights\n" .
    "     -W 'query-boost',          default no query-boost\n" .
    "     -C qlas config,            default $cfg\n" .
    "     -c copy to build area,     default $copy_data\n" .
    "     -Y yell dir,               default $ydir\n" .
    "     -y input language.         default $language\n".
    "     -A alatheia_to_tsv args,   default '$alatheia_to_tsv_args'\n" .
    "     -s split for eval?         default $split_for_eval\n" .
    "     -S suffix for training     default none\n" .
    "     -R resource dir,           default $resource_dir\n" .
    "     -i intl,                   default $intl\n" .
    "     -f eval_query_filter,      default none\n" .
    "     -L,                        run local training (with tree)\n" .
    "     -k number of folds,        default $num_folds\n" .
    "     -E existing scorer dir,    scorer files prefix (with path) to copy\n" .
    "     -n,                        no feature extraction\n" .
    "     -d seed,		     random seed for training\n"
    unless $status;

if ($opts{h}) { 
    $QLAS_HOME = $opts{h}; 
    $cfg = "$QLAS_HOME/etc/config.us.xml"; 
}
if ($opts{H}) { 
    $SCORER_HOME = $opts{H}; 
    $editorial_mapping_file = "$SCORER_HOME/data/mapping_from_editorial_to_eng.txt";
}
if ($opts{T}) { $tmp_dir = $opts{T}; }
if ($opts{r}) { $mail_report = $opts{r}; }
if ($opts{t}) { $trees = $opts{t}; }
if ($opts{b}) { $bestfirst = $opts{b}; }
if ($opts{C}) { $cfg = $opts{C}; }
if ($opts{Y}) { $ydir = $opts{Y}; }
if ($opts{y}) { $language = $opts{y}; }
if ($opts{R}) { $resource_dir = $opts{R}; }
if ($opts{p}) { $editorial_mapping_file = $opts{p}; }
if ($opts{M}) { $max_interpretations = $opts{M}; }
if ($opts{s}) { $split_for_eval = $opts{s}; }
if ($opts{S}) { $train_suffix = $opts{S}; }
if ($opts{d}) { $random_seed = $opts{d}; }
if ($opts{l}) { 
    $logging_dir = $opts{l}; 
    if (!-d $logging_dir) {
        `mkdir $logging_dir`;
    }
}
if ($opts{i}) { $intl = $opts{i}; }
if (defined $opts{c}) { $copy_data = $opts{c}; }

if (defined $opts{k}) { 
    $num_folds = $opts{k}; 
    if($num_folds < 1) {
       die "Invalid number of folds ($num_folds): -k must be >= 1";
    }
}

if ($opts{w}) { 
    $weight_args = $opts{w};
    if ($weight_args =~ /query_boost/){
        if ($opts{W}) { 
            $query_boost = "$SCORER_HOME/data/$intl/editorial/$opts{W}"; 
            open (QB, "$query_boost") or die "query_boost file $query_boost doesn't exist\n";
            while (<QB>) {
                s/\s*$//;
                $boost_per_query{$_} = 1;
            }
            close QB;
        }else{
            die "query_boost option used in -w, no query_boost file specified in -W\n";
        }
    }
}
if ($opts{f}) { $eval_filter = $opts{f}; }
if ($opts{E}) { $existing_scorer_dir = $opts{E}; }

my $skip_features = 0;
if ($opts{n}) { $skip_features = 1; }

# scripts always in .../bin not .../$archbin
my $SCRIPTS_HOME = "$ydir/bin";
$SCRIPTS_HOME = "$QLAS_HOME/bin" if length($QLAS_HOME);
# if running locally with a checked out tree
# training scripts are not installed in bin
if ($opts{L}) {
   $SCRIPTS_HOME = "$QLAS_HOME/misc/scorer/scripts";
   $archbin = "bin";   # tree just uses bin not bin64
}

my $date = `date -I`;
chomp $date;

my $host = `hostname`;
chomp $host;

#$tmp_dir = "$tmp_dir/$ENV{USER}/scorer_train/$date";
system "mkdir -p $tmp_dir";

############ various checks #############
my $feature_extraction_prog = "ExtractFeaturesNew"; # get from $PATH by default
$feature_extraction_prog = "$QLAS_HOME/$archbin/ExtractFeaturesNew" if length($QLAS_HOME);
die "Can't find $feature_extraction_prog" unless (0 == length($QLAS_HOME) || -x $feature_extraction_prog);

my $gbdt_prog = "/home/y/libexec64/dcp/dcp_gbdt";
die "Can't find $gbdt_prog" unless (-e $gbdt_prog);

my $editorial_file_regex_global = "$SCORER_HOME/data/$intl/editorial/[0-9]*tsv";
my $editorial_file_regex_intl = "$SCORER_HOME/data/$intl/editorial/$intl/[0-9]*tsv";

# if you run locally with a checked out tree
# grab the data from the tree
if ($opts{L}) {
   $editorial_file_regex_global = "$QLAS_HOME/misc/scorer/data/editorial/[0-9]*tsv";
   $editorial_file_regex_intl = "$QLAS_HOME/misc/scorer/data/editorial/$intl/[0-9]*tsv";
}

my @editorial_files_global = glob $editorial_file_regex_global;
my @editorial_files_intl = glob $editorial_file_regex_intl;

my @editorial_files = (@editorial_files_global, @editorial_files_intl);

############ get editorial data ############
my $editorial_combined = "$tmp_dir/ALL.tsv";
my $training_data = "$editorial_combined.train";
my $training_queries = "$editorial_combined.queries";

my $cmd = "";

if ($skip_features) {
   # skip feature extraction
} else {
   if (!$existing_scorer_dir) {
      die "No editorial files match $editorial_file_regex_global or $editorial_file_regex_intl" unless (@editorial_files);

      $cmd = "cat @editorial_files | head -$max_interpretations  > $editorial_combined";
      system "date";
      print STDERR "\n$cmd\n";
      system $cmd;
   
      $cmd = "cat $editorial_combined | " . 
          "$SCRIPTS_HOME/alatheia_to_tsv.pl $alatheia_to_tsv_args | " .
          "$SCRIPTS_HOME/map_tags_simple.pl $editorial_mapping_file 5 > " .
          "$training_data";
   
      system "date";
      print STDERR "\n$cmd\n";
      system $cmd;

      if ($intl eq 'us') {
         $cmd = "cat $training_data | $SCRIPTS_HOME/revert_compounds.pl > tmp";

         system "date";
         print STDERR "\n$cmd\n";
         system $cmd;

         $cmd = "mv tmp $training_data";

         system "date";
         print STDERR "\n$cmd\n";
         system $cmd;
      }
   
      $cmd = "cut -f2 $training_data | sort -u > $training_queries";
      system "date";
      print STDERR "\n$cmd\n";
      system $cmd;
   } else {
      $cmd = "cp $existing_scorer_dir/ALL* $tmp_dir/";
      system "date";
      print STDERR "\n$cmd\n";
      system $cmd;
   }
}


############ extract features ############

my $atom_name = "scorer$train_suffix";
my $training_out = "$tmp_dir/$atom_name";

if ($skip_features) {
   # skip feature extraction
} else {
   if ($existing_scorer_dir) {
      $cmd = "cp $existing_scorer_dir/$atom_name.* $tmp_dir/";
   } else {
      $cmd = 
          "$feature_extraction_prog " .
          "-Y $ydir " .
          "-l $language ".
          "-C $cfg " .
          "-R $resource_dir " .
	  "-p qi=true " .
          "-p interpreter=powerset " .
          "-p scorer=trained_scorer " .
          "-p ct_lm_thresh=0 " .
          "-D $training_out.unsorted.debug " .
          "-e $training_data " .
          "-o $training_out.unsorted " .
          "-i $training_queries ";
      
      if ($logging_dir ne '-') {
          $cmd .= ">& $logging_dir/feature-extraction.$date.log";
      }
   }
   system "date";
   print STDERR "\n$cmd\n";
   system $cmd;
}

############ sort feature extraction ########
# this step is necessary to ensure data are seen in the same order
# for fold generation and training
if (!$skip_features) {
   my ($del) = chr(1);
   $cmd = "paste -d$del $training_out.unsorted.debug $training_out.unsorted.label $training_out.unsorted.feat > $training_out.unsorted";
   print STDERR "\n$cmd\n";
   system $cmd;
   $cmd = "head -1 $training_out.unsorted > $training_out.sorted";
   print STDERR "\n$cmd\n";
   system $cmd;
   $cmd = "tail -n +2 $training_out.unsorted | sort >> $training_out.sorted";
   print STDERR "\n$cmd\n";
   system $cmd;
   $cmd = "cut -d$del -f1 $training_out.sorted > $training_out.debug";
   print STDERR "\n$cmd\n";
   system $cmd;
   $cmd = "cut -d$del -f2 $training_out.sorted > $training_out.label";
   print STDERR "\n$cmd\n";
   system $cmd;
   $cmd = "cut -d$del -f3- $training_out.sorted > $training_out.feat";
   print STDERR "\n$cmd\n";
   system $cmd;
}

# query boosting
my($feat2) = "$training_out.feat2";
my($tempfeat) = "$training_out.tempfeat";
if ($query_boost ne ''){
    open (DEBUG, "$training_out.debug") or die "Cannot read $training_out.debug\n";    
    open (TEMPFEAT, ">$tempfeat") or die "Cannot write $tempfeat\n";
    <DEBUG>;
    print TEMPFEAT "query_boost\n";
    while (<DEBUG>) {
        my($query) = /^(.+?)\t/;
        if (exists $boost_per_query{$query}) {
            print TEMPFEAT "1\n";
        } else {
            print TEMPFEAT "0\n";
        }
    }
    close TEMPFEAT;
   $cmd = "paste $training_out.feat $tempfeat > $feat2";
    system "date";
    print STDERR "\n$cmd\n";
    system $cmd;

} else {
    $cmd = "cp $training_out.feat $feat2";
    system "date";
    print STDERR "\n$cmd\n";
    system $cmd;
}

############ create weight vector ########

if ($weight_args) {
    my $args = "$weight_args basename=$training_out";
    $cmd = "cat $training_out.feat2 | $SCRIPTS_HOME/create_weight_file.pl $args > $training_out.wts";
    print STDERR "\n$cmd\n";
    system $cmd;
}

############ train GBDT model ############

$cmd = "head -1 $training_out.feat | wc -w > $training_out.info";
system "date";
print STDERR "\n$cmd\n";
system $cmd;

## Generate k folds.

if ($split_for_eval) {
    my $ratio = ( 1 / $num_folds ) ;
    $cmd = "cat $training_out.debug | $SCRIPTS_HOME/generate_folds.pl -folds $num_folds -ratio $ratio -seed 0 > $training_out.fold";
    print STDERR "\n$cmd\n";
    system $cmd;

    for(my $i=1; $i<=$num_folds; $i++) {
        $cmd = "ln -s $atom_name.fold $tmp_dir/$atom_name\_$i.fold";
        print STDERR "\n$cmd\n";
        system $cmd;
    }
}

## Train over each of the folds. 

for(my $i=1; $i<=$num_folds; $i++) {

    ## whether we ran feature extraction, or copied from an existing build dir,
    ## grab the features, debug, and labels files
    $cmd =
        "ln -s $atom_name.label $tmp_dir/$atom_name\_$i.label ; " .
        "ln -s $atom_name.feat $tmp_dir/$atom_name\_$i.feat ; " .
        "ln -s $atom_name.info $tmp_dir/$atom_name\_$i.info ; " .
        "ln -s $atom_name.debug $tmp_dir/$atom_name\_$i.debug " ;

    if (-e "$training_out.wts") {
        $cmd .= "; ln -s $atom_name.wts $tmp_dir/$atom_name\_$i.wts ";
    }
    
    system "date";
    print STDERR "\n$cmd\n";
    system $cmd;

    $cmd = "cd $tmp_dir; $gbdt_prog " . 
        "-trnfn=$atom_name\_$i " .
        "-tstfn=$atom_name\_$i " .
        "-outfn=$atom_name\_$i.scores " .
        "-modfn=$atom_name\_$i.model " .
        "-infofn=$atom_name\_$i.info " .
        "-parallel=4 " .
        "-label=-1 " .
        "-verbose=2 " .
        "-numTrees=$trees " .
        "-bestFirst=$bestfirst " .
        "-xmlformat=mlr ";

    if ($random_seed ne '') {
       $cmd .= "-seed=$random_seed ";
       $cmd .= "-seed1=$random_seed ";
    } 
    if ($split_for_eval) {
        $cmd .= " -fold_i=$i ";
    }
    
    $cmd .= "; cd -"; 
    
    system "date";
    print STDERR "\n$cmd\n";
    system $cmd;

}

if ($split_for_eval) {
    for(my $i=1; $i<=$num_folds; $i++) {
        ## We don't do filtering for each of the folds currently, but it is applied to the combined
        ## evaluation across all folds (see below).
        $cmd = "$SCRIPTS_HOME/eval_scorer.pl -editorial $training_data -prefix $training_out\_$i -test_fold $i > $tmp_dir/eval_$i.txt";
        print STDERR "\n$cmd\n";
        system $cmd;
    }

    ## Measure performance over all folds together.
    
    ## Re-assemble scores according to fold.
    my @scores = ();
    open IN, "sed 's/^/fold=/' $training_out\_1.fold |";
    while(<IN>) {
        chomp;
        next if ($_ =~ /^fold=fold/);
        push @scores, $_;
    }
    close IN;

    for(my $i=1; $i<=$num_folds; $i++) {
        my @fold_scores = ();
        open IN, "$training_out\_$i.scores" or die "could not open $training_out\$i.scores";
        while(<IN>) {
            chomp;
            next if ($_ =~ /^score/);
            push @fold_scores, $_;
        }
        close IN;
        
        ## Replace each fold=i entry in scores with the actual score for that fold.
        my $k=0;
        for(my $j=0; $j < scalar(@scores); $j++) {
            last if($k > scalar(@fold_scores));
            ## Match, so replace.
            if($scores[$j] =~ /^fold=$i$/) {
                $scores[$j] = $fold_scores[$k];
                $k++;
            }
        }
    }   

    ## Now, create a .scores of all scores together.
    open OUT, ">$training_out.all_scores";
    print OUT "score\n";
    foreach my $s (@scores) {
        ## Check that all lines got replaced by their score
        if($s =~ /^fold=/) {
            die "Error in score: $s";
        } 
        print OUT "$s\n";
    }

    ## Create fake '.fold' so all instances will be considered as the test set.
    $cmd = "sed 's/^[0-9]\$/1/g' $training_out\_1.fold > $training_out.fake_fold";
    print STDERR "\n$cmd\n";
    system $cmd;
    
    ## Run eval with fake fold and all scores.
    if ($eval_filter ne "") {
        my(@filter_files) = split /\s+/, $eval_filter;
        foreach my $filter_file (@filter_files){
            $cmd = "$SCRIPTS_HOME/eval_scorer.pl -editorial $training_data -labels $training_out.label -scores $training_out.all_scores ".
                "-interpretations $training_out.debug -fold $training_out.fake_fold -test_fold 1 ".
                "-filter_queries $SCORER_HOME/data/$intl/editorial/$filter_file > $tmp_dir/eval_all_folds_${filter_file}.txt";


            print STDERR "\n$cmd\n";
            system $cmd;
        }
    }
     
    ## always generate the non-filtered eval report
    $cmd = "$SCRIPTS_HOME/eval_scorer.pl -editorial $training_data -labels $training_out.label -scores $training_out.all_scores ".
        "-interpretations $training_out.debug -fold $training_out.fake_fold -test_fold 1 > $tmp_dir/eval_all_folds.txt";
    print STDERR "\n$cmd\n";
    system $cmd;

}

## Finally, train over the whole data set and save this as the model to use.

$cmd = "cd $tmp_dir; $gbdt_prog " . 
    "-trnfn=$atom_name " .
    "-tstfn=$atom_name " .
    "-outfn=$atom_name.scores " .
    "-modfn=$atom_name.model " .
    "-infofn=$atom_name.info " .
    "-parallel=4 " .
    "-label=-1 " .
    "-verbose=2 " .
    "-numTrees=$trees " .
    "-bestFirst=$bestfirst " .
    "-xmlformat=mlr ";

system "date";
print STDERR "\n$cmd\n";
system $cmd;

############ convert GBDT model ############

$cmd = "$SCRIPTS_HOME/dat2tnt.pl $training_out.model.tn-model.dat 1 > $tmp_dir/scorer$train_suffix.tnt";

system "date";
print STDERR "\n$cmd\n";
system $cmd;
 

############# clean up ################## 

my @delete_files = ();
#push @delete_files, glob "$tmp_dir/ALL*";
foreach my $f (@delete_files) {
    unlink $f;
}

######### model test and copy ###########

if ($copy_data) {
    my $test_treenet = "TestTreenet";
    if ($opts{L}) {
       $test_treenet = "$QLAS_HOME/$archbin/TestTreenet";
    }
    my $model = "$tmp_dir/scorer$train_suffix.tnt";
    my $cmd = "$test_treenet $model $training_out.feat > /tmp/test_treenet.out  ";
    if ( (system $cmd) == 0) {
        # copy model file
        system "cp $model /home/y/libdata/qlas/build/scorer/$intl/prefinal/data/gbdt/";
    } else {
        die "Treenet test failed";
    }
}

######### generate mail report ##########

if ($mail_report) {
    my @users = split ",", $mail_report;
    my $to = shift @users;
    my $cc = '';
    for (@users) {
        $cc .= "$_\@yahoo-inc.com, ";
    }
    my $ls_l = `ls -l $tmp_dir/*.tnt`;
    chomp $ls_l;
    my $mail_body = "Scorer training completed on $ENV{HOST} , result is in\n$ls_l\n";

    my $logfile = '/tmp/scorer_train_stable.log';
    if (-e $logfile) {
        $mail_body .= `tail -12 $logfile | head -10`;
        $mail_body .= "\n";
    }

    $mail_body .= "\nPerformance over all folds:\n";
    my $eval_file = "$tmp_dir/eval_all_folds.txt";
    if (-e $eval_file) {
        $mail_body .= `grep "#" $eval_file | grep Overall`;
        $mail_body .= "\n";
    }

    $mail_body .= "\n-----------------------------------------------";
    $mail_body .= "\n$num_folds\-fold Cross Validation Results:\n";
    for(my $i=1; $i<=$num_folds; $i++) {
        my $eval_file = "$tmp_dir/eval_$i.txt";
        if (-e $eval_file) {
            $mail_body .= `grep "#" $eval_file | grep Overall`;
            $mail_body .= "\n";
        }
    }

    my $message = MIME::Lite->new(
                                  To => "$to\@yahoo-inc.com",
                                  From =>'qlas-scorer-build@yahoo-inc.com',
                                  Cc => "$cc",
                                  Subject => uc($intl) . "-Scorer training $date on $host",
                                  Data => $mail_body
                                  );
    $message->send();
}

system "date";
exit(0);

