# $Id: IdpTool.pm,v 1.14 2006/10/09 19:49:50 javiera Exp $
# vim: ft=perl ts=3 sts=3 sw=3

=head1 NAME

IdpTool - a module for working with IDP queries and replies

=head1 SYNOPSIS

  use IdpTool;

  my $idp = new IdpTool("kp1300");
  my @query = ("SEARCH",
               "Query: ALLWORDS(pink floyd)");
  my @reply = $idp->Send(@query);
  print join("\n", @reply);

=head1 DESCRIPTION

C<IdpTool> provides an object interface for executing IDP queries as well as
parsing their results. Additional functionality includes logging, notification
of "killer queries," etc.

The module defines four other object types in addition to C<IdpTool>:

C<IdpRequestBlock> is an array of lines of an IDP request.

C<IdpResponseBlock> is an array of lines of an IDP response.

C<IdpRequest> is hash representing an IDP response, where "field: value" in
the request is converted to field => value in the hash.

C<IdpResponse> is an array of lines of an IDP response, where "field: value" 
in the response is converted to field => value in the hash.

In all cases, trailing newlines have been removed.

NOTE: Arguments after a ';' in function prototypes are optional.

=cut

package IdpTool;
use Exporter();
use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);
$VERSION     = "5.00";
@ISA         = qw(Exporter);
@EXPORT      = qw();
@EXPORT_OK   = qw(QueriesToBlocks SplitReplyBlock ParseReplyBlock
                  ExtractResults ReadIdp);

use Carp;
use FileHandle;
use IO::Socket;
use POSIX qw();


#==============================================================================
# Globals/Constants

use vars qw($DEFAULT_PORT $DEFAULT_CLIENT);
$DEFAULT_PORT   = 55555;
$DEFAULT_CLIENT = "inkdev";

=head1 METHODS

=over 4

=item new($node ; { Port => $port, Client => $client, Comment => $comment })

Creates a new C<IdpTool> object and returns a reference to it if the specified 
node is reachable, has proxy/idpd listening on the specified port, and a valid
client was specified.

Only the $node argument is required. A default of "inkdev" and 55555 will be
used for the client and port, respectively, if they are not provided.

NOTE: Previous versions of the module expected the Port, Client, and Comment
to be individual arguments, not part of a hash. The behavior was changed to
match perl coding conventions.

=cut

sub new
{
   my ($class, $node, @args) = @_;
   my $this = undef;
   my $read = '';
   my $sock;

   $this = { 
      'node'    => $node,
      'port'    => undef,
      'client'  => undef,
      'comment' => undef,
      'socket'  => undef,
      'handler' => undef,
      'outfh'   => undef
   };
   _ParseArgs($this, @args);

   # Verify that the node has idpd listening on the port before succeeding.
   _StartConnection($this, 0);
   if ($this->{'socket'}) {
      # Check that the connection was not closed after the connection block.
      vec($read, $this->{'socket'}->fileno(), 1) = 1;
      if (select($read, undef, undef, 0.1)) {
         _Carp(1, "bad client '$this->{client}'");
         $this->{'socket'}->close();
         $this = undef;
      }
      else {
         $this->{'socket'}->close();
         $this->{'socket'} = undef;
         bless($this, $class);
      }
   }
   else {
      _Carp(1, "could not establish connection to $node:$this->{port}");
      $this = undef;
   }

   return $this;
}

=item Send(@cmd_block)

Sends a command block to the IDP server and returns the response, recording
it in the log file if one has been set. If keep-alive is not on, a new socket
is opened to send the query and closed after the response is received.

The @cmd_block may be a list with each IDP line a separate item, or it can be
a single string with the IDP lines separated by newlines, or mixed.

In list context, returns an list of IDP reply lines. In scalar context, 
returns an IdpResponseBlock.

=cut

sub Send
{
   my ($this, @cmdBlock) = @_;
   my $keepAlive = defined($this->{'socket'});
   my $sock = $this->{'socket'};
   my $outFh = $this->{'outfh'};
   my $replyBlock = [];

   if (not $keepAlive and $this->_StartConnection(0)) {
      $sock = $this->{'socket'};
   }

   if ($sock) {
      my $oldListSep = $";
      my $replyLines;

      $" = "\n";

      # Send command block and log it.
      @cmdBlock = split(/\n+/m, join("\n", @cmdBlock));
      print $sock "@cmdBlock\n\n";
      if ($outFh) { print $outFh "@cmdBlock\n\n" }

      # Retrieve response and log it.
      $replyBlock->[0] = <$sock>;
      if (defined($replyBlock->[0])) {
         ($replyLines) = $replyBlock->[0] =~ /^.+ \d+ (\d+)/;
         foreach $_ (1 .. $replyLines) {
            $replyBlock->[$_] = <$sock>;
         }
         chomp(@$replyBlock);
         if ($outFh) { print $outFh "@$replyBlock\n\n\n" }
      }
      else {
         # Uh-oh. No response from the search engine is baaaaad!
         if ($outFh) { print $outFh "*** No response!\n\n\n" }
         _Carp(1, "did not receive a response");
         @$replyBlock = ();

         # Call the killer query handler, if any.
         if ($this->{'handler'}) { &{$this->{'handler'}}(@cmdBlock) }
      }

      $" = $oldListSep;
   }

   if ($this->{'socket'} and not $keepAlive) {
      $this->{'socket'}->close();
      $this->{'socket'} = undef;
   }

   return wantarray ? @$replyBlock : (@$replyBlock ? $replyBlock : undef);
}

=item BatchByBlock($input_file ; $echo = 0)

Reads IDP command blocks from $input_file (each block separated by an empty 
line) and sends them to the node via Send(). If $echo is true, "Echo:1" is
added to each command block before it is sent (unless it already has one).

Returns the number of queries successfully sent, or the negated number of
queries successfully sent before a killer query was encountered.

=cut

sub BatchByBlock
{
   my ($this, $inFile, $opt) = @_;
   my ($inFh, $outFh) = (new FileHandle("$inFile"), $this->{'outfh'});
   my (@cmdBlock, $replyBlock);
   my $killer = 0;
   my $count = 0;
   my $echo = 0;
   my $query_id = undef;

   if (ref($opt) =~ /HASH/) { # new-style call
      $query_id = $opt->{QueryId} if (defined $opt->{QueryId});
      $echo = 1 if ($opt->{Echo});
   }
   else {                     # old-style call
      $echo = 1;
   }

   # Return if we couldn't open the input file.
   if (not $inFh) {
      _Carp(1, "unable to open file '$inFile' for reading ($!)");
      return 0;
   };

   # This is were the actual batch processing is done.
   @cmdBlock = _GetCmdBlock($inFh, $this->{'outfh'}, $echo);
   while (@cmdBlock > 0 and not $killer) {
      $this->Log("QueryId: " . $query_id++ . "\n") if (defined $query_id);
      $replyBlock = $this->Send(@cmdBlock);
      if (@$replyBlock == 0) {
         $killer = 1;
      }
      else {
         ++$count;
         @cmdBlock = _GetCmdBlock($inFh, $this->{'outfh'}, $echo);
      }
   }
   $inFh->close();

   return $killer ? -$count: $count;
}

=item BatchByLine($input_file, @cmd_block)

Sends @cmd_block to the node once for each line in $input_file. If the query
argument in @cmd_block contains '{}', that is replaced with the line read
from $input_file. If no query argument is found or it does not contain '{}',
the line is used as the entire query string.

Returns the number of queries successfully sent, or the negated number of
queries successfully sent before a killer query was encountered.

=cut

sub BatchByLine
{
   my ($this, $inFile, @cmdBlock) = @_;
   my ($inFh, $outFh) = (new FileHandle("$inFile"), $this->{'outfh'});
   my ($qryIdx, $query, $savedQuery);
   my $replyBlock;
   my $killer = 0;
   my $count = 0;

   # Check we have a valid command block template.
   if (@cmdBlock == 0 or $cmdBlock[0] !~ /search/i) {
      _Carp(1, "invalid command block; must be SEARCH");
      return 0;
   }

   # Return if we couldn't open the input file.
   if (not $inFh) {
      _Carp(1, "unable to open file '$inFile' for reading ($!)");
      return 0;
   };

   # Make sure each IDP argument is a separate item in the list.
   @cmdBlock = split(/\n+/m, join("\n", @cmdBlock));

   # Find the index of the query argument in the list so we don't have to 
   # look for it every time.
   $qryIdx = -1;
   foreach $_ (0 .. $#cmdBlock) {
      if ($cmdBlock[$_] =~ /^query:/i) {
         $qryIdx = $_;
         last;
      }
   }
   if ($qryIdx == -1) {
      $qryIdx = @cmdBlock;
      $savedQuery = "Query:{}";
   }
   elsif ($cmdBlock[$qryIdx] =~ /\{\}/) {
       $savedQuery = $cmdBlock[$qryIdx];
    }
    else {
       $savedQuery = "Query:{}";
    }

   # This is were the actual batch processing is done.
   $query = <$inFh>;
   while (defined($query) and not $killer) {
      chomp $query;
      $cmdBlock[$qryIdx] = $savedQuery;
      $cmdBlock[$qryIdx] =~ s/\{\}/$query/m;
      $replyBlock = $this->Send(@cmdBlock);
      if (@$replyBlock == 0) {
         $killer = 1;
      }
      else {
         ++$count;
         $query = <$inFh>; 
      }
   }
   $inFh->close();

   return $killer ? -$count: $count;
}

=item SetLogFile($file = undef)

Sets the file to which queries that go through Send() are logged. Both the
command blocks and reply blocks are logged. The $file argument should be the
name of the file to log to, a reference to a file handle open for writing, or
'STDOUT'. Use ">> filename" to append to a log. Use "" or undef to turn
logging off.

Returns true if successful.

=cut

sub SetLogFile
{
   my ($this, $file) = @_;
   my $oldFh = $this->{'outfh'};

   if (defined($file) and $file =~ /\s*</) {
      _Carp(1, "attempted to open log file for reading", 1);
   }
   elsif (defined($file) and $file !~ /^STDOUT$/i and $file !~ /\s*>/) {
      $file = "> $file";
   }

   if ($oldFh) { $oldFh->close() }

   if (ref($file) and $file->isa('FileHandle')) {
      $this->{'outfh'} = $file;
   }
   elsif (defined($file) and $file =~ /^STDOUT$/i) {
      $this->{'outfh'} = 
         FileHandle->new_from_fd(POSIX::dup(fileno(STDOUT)), '>');
   }
   elsif (defined($file) and $file ne "") {
      $this->{'outfh'} = new FileHandle("$file") or
         _Carp(1, "unable to open '$file' for writing ($!)");
   }
   else {
      $this->{'outFh'} = undef;
   }

   return defined($this->{'outfh'});
}

=item Log($str)

Appends a string to the log file, if any.

Returns true if successful, false otherwise (e.g. no log file set).

=cut

sub Log
{
   my ($this, $str) = @_;
   my $logFh = $this->{'outfh'};

   if ($logFh) {
      print $logFh "$str";
   }

   return defined($logFh);
}

=item KillerQueryHandler( ; $handler)

Sets/gets the handler that will be called when a killer query (i.e. one that 
does not get a reply) is encountered by Send(). The handler can then do what
it pleases (i.e. exit, send mail, etc.). The $handler argument should be a
reference to a subroutine, or undef to remove the current handler.

Returns a reference to the previous handler.

=cut

sub KillerQueryHandler
{
   my ($this, $handler) = @_;
   my $oldHandler = $this->{'handler'};

   if (defined $handler) {
      if (ref($handler) eq 'CODE') {
         $this->{'handler'} = $handler;
      }
      else {
         _Carp(1, "not a code reference", 1);
      }
   }
   elsif (@_ > 1) {
      $this->{'handler'} = undef;
   }

   return $oldHandler;
}

=item KeepAlive()

Establishes a connection to the node and keeps it open. After a call to 
KeepAlive(), all queries sent through Send() will use the same socket.

Returns true if successful.

=cut

sub KeepAlive 
{
   my ($this) = @_;
   my $ok = defined($this->{'socket'}) ? 1 : 0;

   if (not $ok) {
      $ok = $this->_StartConnection(1);
   }

   return $ok;
}

=item KeepDead()

Closes a keep-alive connection so that each subsequent call to Send() uses a 
new socket.

=cut

sub KeepDead
{
   my ($this) = @_;

   if ($this->{'socket'}) {
      $this->{'socket'}->close();
      $this->{'socket'} = undef;
   }

   return undef;
}


=head1 FUNCTIONS

The following subroutines don't need an object to work on and can be called
like IdpTool::Foo(). They can be exported, but are not by default.


=item QueriesToBlocks($input_file, $cmd_block, $output_file = 'STDOUT')

Creates IDP blocks using the template $cmdBlock and the query strings in 
$inputFile and writes them to $outputFile. Each block is separated by a 
blank line.

Returns the number of queries converted or -1 if an error occured.

=cut

sub QueriesToBlocks($$;$)
{
   my ($inFile, $cmdBlock, $outFile) = @_;
   my @cmdBlock = split(/\n+/, $cmdBlock);
   my ($inFh, $outFh);
   my ($query, $count);
   my $qryIdx;
   my $oldSep;

   # Check we have a valid command block template.
   if (@cmdBlock == 0 or $cmdBlock[0] !~ /search/i) {
      _Carp(1, "invalid command block; must be SEARCH");
      return -1;
   }

   # Open the input file.
   $inFh = new FileHandle("< $inFile");
   if (not $inFh) {
      _Carp(1, "unable to open '$inFile' for reading ($!)");
      return -1;
   }

   # Make sure we write output to right place, either file or standard output.
   if (not defined($outFile) or 
       (defined($outFile) and $outFile =~ /^STDOUT$/i)) {
      $outFh = FileHandle->new_from_fd(POSIX::dup(fileno(STDOUT)), '>');
   }
   else {
      $outFh = new FileHandle("> $outFile");
      if (not $outFh) {
         _Carp(1, "unable to open '$outFile' for writing ($!)");
         return -1;
      }
   }

   # Find the index of the query argument in the list so we don't have to 
   # look for it every time.
   $qryIdx = -1;
   foreach $_ (0 .. $#cmdBlock) {
      if ($cmdBlock[$_] =~ /^query:/i) {
         $qryIdx = $_;
         last;
      }
   }
   if ($qryIdx == -1) { $qryIdx = @cmdBlock }

   # This is were the actual batch processing is done.
   $count = 0;
   ($oldSep, $") = ($", "\n");
   while (defined($query = <$inFh>)) {
      chomp($query);
      $cmdBlock[$qryIdx] = "Query:$query";
      print $outFh "@cmdBlock\n\n";
      $count++;
   }
   $" = $oldSep;

   return $count;
}

=item SplitReplyBlock($block)

Splits the reply block into two, a connection block and a results block.

Returns references to two new arrays. If there were no results
(i.e. NumResults:0), the second reference points to an empty list.

=cut

sub SplitReplyBlock($)
{
   my ($block) = @_;
   my ($reply_blk, $results_blk) = ([], []);

   my $blk = $reply_blk;
   for (my $i = 0; $i < @$block; $i++) {
      if ($block->[$i] =~ /\S/) {
         push @$blk, $block->[$i];
      }
      else {
         $blk = $results_blk;
      }
   }

   return ($reply_blk, $results_blk);
}

=item ParseReplyBlock($block)

Parses a search engine reply block to separate the information block from
the results block. $block should be a reference to an array containing the
reply block.

Returns a reference to a hash with IDP information block fields as keys, or
undef if an error occurs.

NOTE: The field 'Results' is an array containing the results block. For
a MULTISEARCH reply block, it is an array containg a reference to a hash for
each SEARCH/COMPOSE reply block.

=cut

sub ParseReplyBlock($)
{
   my ($block) = @_;
   my ($idpVer, $resultCode, $lines, $command);
   my $parsed;

   # So you can say $reply = ParseReplyBlock($IDP->Send($query))
   if (not defined($block)) { return undef }

   chomp @$block;
   $block->[0] =~ /^(IDP\/\d+\.\d+) (\d+) (\d+) (\w+)$/;
   ($idpVer, $resultCode, $lines, $command) = ($1, $2, $3, uc($4));
   if (not $idpVer or not $resultCode or not $command) {
      _Carp(1, "not a valid IDP reply block", 1);
   }

   $parsed = {
      IdpVer     => $idpVer,
      ResultCode => $resultCode,
      NumOfLines => $lines,
      Command    => $command,
      Results    => [ ]
   };

   if ($resultCode != 200) {
      foreach (1 .. @$block - 1) {
         push(@{$parsed->{Results}}, $block->[$_]);
      }

      return $parsed;
   }

   if ($command eq "MULTISEARCH") {
      my ($start, $end);

      $start = 1;
      while (defined($block->[$start])) {
         $end = $start + 1;

         while (defined($block->[$end]) and $block->[$end] !~ /^TotalHits:/) {
            $end++;
         }

         push(@{$parsed->{Results}}, 
              _ParseReply({}, $block, $start, $end - 1));
         $start = $end;
      }
   }
   else {
      _ParseReply($parsed, $block, 1, @$block - 1)
   }

   return $parsed;
}

=item ExtractResults($block ; { By => 'field' | 'rank' } )

Extracts the Results field of an IDP reply block that has been parsed by 
ParseReplyBlock(). If By is 'field', the return value is a hash ref with the
field names as keys and results array as values, as in

 $results = {
   url => [ "http://www.foo.com"   # 1st result
            "http://www.bar.com" ] # 2nd result
   score => [ 0.9980    # 1st result
              0.9975 ]  # 2nd result
 }

If By is 'rank', the return value is an array ref where each item is an hash
ref to the different field values, as in

 $results = [
   { url => "http://www.foo.com"    # 1st result
     score => 0.9980 }
   { url => "http://www.bar.com"    # 2nd result
     score => 0.9975 }
 ]

NOTE: Previous versions of the module did not accept a second argument and 
always returned results by field. If By is omitted, 'field' is used as default
for backward compatibility.

=cut

sub ExtractResults($;$)
{
   my ($block, $opt) = @_;
   my @fields;
   my $results;

   # So you can say ExtractResults(ParseReplyBlock(Send($query))).
   return undef if (not defined($block));

   if (not exists($block->{Results}) or not exists($block->{Fields}) or
       not exists($block->{NumResults})) {
      _Carp(1, "not a valid parsed IDP reply block", 1);
   }

   if ($opt and $opt !~ /^HASH/) {
      _Carp(1, "options not a hash ref", 1);
   }

   @fields = split(/\s*,\s*/, $block->{Fields});
   if (not $opt or $opt->{By} =~ /field/i) {
      $results = { };
      for (my $i = 0; $i < @fields; $i++) {
         for (my $j = 0; $j < $block->{NumResults}; $j++) {
            push(@{$results->{$fields[$i]}},
                 $block->{Results}->[$j * @fields + $i]);
         }
      }
   }
   elsif ($opt->{By} =~ /rank/i) {
      $results = [ ];
      for (my $i = 0; $i < $block->{NumResults}; $i++) {
         for (my $j = 0; $j < @fields; $j++) {
            $results->[$i]->{$fields[$j]} =
               $block->{Results}->[$i * @fields + $j];
         }
      }
   }
   else {
      _Carp(1, "invalid By argument '$opt->{By}'", 1);
   }

   return $results;
}

=item ReadIdp($fh)

Reads an IDP request or reply from and open file handle and returns it. The
returned block can the be passed to Send() or ParseReplyBlock(). File may be 
loadgen input file; sync: commands are ignored, connection args (e.g. client:)
are returned in second argument.

In scalar context, function returns a reference to the read IDP block, or undef
if EOF. In list context, the second return value is a hash refernce of connection arguments, if any.

=cut

sub ReadIdp
{
   my ($fh) = @_;
   my @block = ();
   my %args = ();

   my $line;
   while (defined($line = <$fh>)) {
      next if ($line =~ /^\s*#/);
      next if ($line =~ /^\s*$/ && @block == 0);

      # ignore loadgen command
      next if ($line =~ /^\s*sync:/);

      if ($line =~ /^\s*client:\s*(\S+)\s*$/i) {
         $args{Client} = $1;
      }
      elsif ($line =~ /^\s*port:\s*(\S+)\s*$/i) {
         $args{Port} = $1;
      }
      elsif ($line =~ /^\s*comment:\s*(.*)$/i) {
         $args{Comment} = $1;
      }
      elsif ($line =~ /^\s*(?:qry|query)id:\s*(.*)$/i) {
         $args{QueryId} = $1;
      }
      elsif ($line =~ m#^\s*(\S+)\s*$#) {
         _ReadIdpRequest($fh, $line, \@block);
         last;
      }
      elsif ($line =~ m#^\s*IDP/#i) {
         _ReadIdpResponse($fh, $line, \@block);
         last;
      }
      else {
         _Carp(1, "unexpected line", 1);
      }
   }

   return undef if (not defined($line) and @block == 0);
   return wantarray ? (\@block, \%args) : \@block;
}


#==============================================================================
# Private Functions

sub _StartConnection
{
   my ($this, $keepAlive)= @_;
   my $sock = new IO::Socket::INET(PeerAddr => $this->{'node'},
                                   PeerPort => $this->{'port'},
                                   Proto    => 'tcp');

   if ($sock) {
      $sock->autoflush(1);
      $keepAlive = $keepAlive ? '1' : '0';

      print $sock "IDP/1.0\n" .
                  "Client:$this->{'client'}\n";
      if (defined($this->{'comment'})) { 
         print $sock "Comment:$this->{'comment'}\n";
      }
      print $sock "KeepAlive:$keepAlive\n\n";
      $this->{'socket'} = $sock;
   }

   return $sock ? 1 : 0;
}

sub _GetCmdBlock
{
   my ($fh, $outFh, $echo) = @_;
   my $hasEcho = 0;
   my $client = "";
   my @cmdBlock;

   while (defined($_ = <$fh>) and not /^\s*$/) {
      if (/^#/) {
         print $outFh $_ if ($outFh);
      }
      elsif (/^\s*client:\s*(\S+)\s*$/i) {
         $client = $1;
      }
      else {
         push(@cmdBlock, $_);
         $hasEcho = 1 if (/^\s*echo:/i);
      }
   }

   return () unless (@cmdBlock);
   chomp(@cmdBlock);

   $echo = 0 unless ($echo);
   if ($echo == 1 and $hasEcho == 0) {
      push(@cmdBlock, "Echo:1");
   }
   if ($client) {
      push(@cmdBlock, "FakeClientName:$client");
   }

   return @cmdBlock;
}

sub _ParseReply
{
   my ($parsed, $block, $start, $end) = @_;
   my ($arg, $val);
   my $idx;

   $idx = $start;
   while (defined($block->[$idx]) and $block->[$idx] ne "" and $idx <= $end) {
      ($arg, $val) = $block->[$idx] =~ /(.+?):\s*(.*)/;
      if (not $arg) {
         $arg = $block->[$idx];
         $val = "";
      }
      else {
         $val = defined($val) ? $val : "";
      }

      if (exists($parsed->{$arg})) {
         if (ref($parsed->{$arg}) eq "ARRAY") {
            push(@{$parsed->{$arg}}, $val);
         }
         else {
            $parsed->{$arg} = [ $parsed->{$arg}, $val ];
         }
      }
      else {
         $parsed->{$arg} = $val;
      }

      $idx++;
   }

   if (defined($block->[$idx]) and $idx < $end) {
      for ($idx++; defined($block->[$idx]) and $idx <= $end; $idx++) {
         push(@{$parsed->{Results}}, $block->[$idx]);
      }
   }

   return bless $parsed, "IdpResponse";
}

sub _ParseArgs
{
   my ($this, @args) = @_;
   my $args = {};

   # If the first argument is a number, we'll just assume that this was an 
   # old-style, deprecated ($port, $client[, $comment]) call.
   if (defined($args[0]) and $args[0] =~ /^\d+$/) {
      $this->{port}    = $args[0];
      $this->{client}  = $args[1];
      $this->{comment} = $args[2] if (defined($args[2]));
      _Carp(2, "deprecated constructor");
      return;
   }

   if (defined $args[0]) {
      if (ref($args[0]) eq 'HASH') {
         # called with { Port => x, ... }
         $args = $args[0];
      }
      elsif (@args % 2 == 0) {
         # called with ( Port => x, ... )
         _Carp(2, "deprecated constructor");
         %$args = @args;
      }
      else {
         # who knows
         _Carp(2, "invalid arguments", 1);
      }
   }

   foreach (keys %$args) {
      if ($_ eq "Port") {
         $this->{port} = $args->{$_};
      }
      elsif ($_ eq "Client") {
         $this->{client} = $args->{$_};
      }
      elsif ($_ eq "Comment") {
         $this->{comment} = $args->{$_};
      }
      else {
         _Carp(2, "invalid argument '$_'", 1);
      }
   }

   # Use defaults for arguments not specified.
   $this->{port}   = $DEFAULT_PORT   unless ($this->{port});
   $this->{client} = $DEFAULT_CLIENT unless ($this->{client});   
}

sub _ReadIdpRequest
{
   my ($fh, $cmd, $request) = @_;
   my $line;

   push @$request, $cmd;
   while (defined($line = <$fh>)) {
      last if ($line =~ /^\s*$/);

      push @$request, $line;
   }
   chomp @$request;

   return bless $request, "IdpRequestBlock";
}

sub _ReadIdpResponse
{
   my ($fh, $header, $response) = @_;
   my $numLines = 0;
   my $line;

   if ($header =~ m#^\s*IDP/\d\.\d+\s+\d+\s+(\d+)\s+#i) {
      $numLines = $1;
   }
   else {
      _Carp(2, "invalid reply header", 1);
   }

   push @$response, $header;
   while ($numLines-- and defined($line = <$fh>)) {
      push @$response, $line;
   }
   chomp @$response;

   return bless $response, "IdpResponseBlock";
}

sub _Carp
{
   my ($frames, $error, $fatal) = @_;
   my ($file, $pkg, $sub, $line);

   # caller needs to be called from DB package to get extended information
   eval {
      package DB;
       ($pkg, $file, $sub, $line) = (caller($frames + 1))[0,1,3,2];
   };
   
   warn "${file}:${sub} [${line}]: $error\n" if ($^W or $fatal);
   die "Idp::Tool::_Carp" if ($fatal);
}

sub DESTROY
{
   my ($this) = @_;

   $this->KeepDead(); 
}

1;

=head1 AUTHOR

Javier Alvarado <javiera@inktomi.com>

=cut

# End IdpTool.pm
