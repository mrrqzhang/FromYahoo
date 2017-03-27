#! /usr/local/bin/perl -w

# Script to find questionable stemmer entries (e.g. morales->morale) 
# using ALLWORDS co-occurence.
# Input is two tab-separated columns, each with a word, phrase, or double-quoted phrase


use Getopt::Long;
use strict;

# Get our lib directory on the lib path
use FindBin '$Bin';


use lib "$Bin/lib";

use IdpTool qw(ExtractResults ParseReplyBlock);

use RankCorrelation;

$| = 1;

# Make an IDP tool
use vars qw($IDP);
#my $host = "yahoo-west-proxy.idp.inktomisearch.com";
#my $host = "qurdev7";
my $host = "idpproxy-yahooresearch1.idp.inktomisearch.com" ;
my $client = "yahoousrecency" ;

my $port = 55555;
#$IDP = new IdpTool( "yahoo-west-proxy.idp.inktomisearch.com", Port => 55555, Client => "yahoous2") or exit 1;
$IDP = new IdpTool( $host, Port => $port, Client => $client) or exit 1;

$IDP->SetLogFile("LOG");
#$IDP->SetLogFile("/dev/null");

sub GetResults( $$$$$ ) {
    my ( $query, $database, $add_query, $add_idp, $numresults ) = @_;
    my $idp = "SEARCH\n" .
        "Query: $query $add_query\n" .
#	"Fields: url title title.plain abstract.best.plain prisma smartdigest\n" .
	"Fields: rawscore,nodename,url\n".
        "NumResults: $numresults\n" .
#        "Query-Encoding: utf8\n" .
        "Unique: doc, host 2\n" .
        "echo:0\n" .
	"permitPragma:1\n".
	"xorrospec:noxorro\n".
	"nohashproxy:1\nhashtouse:1\n".
	"echoyquery:k\n".
        ($database ? "\nDatabase:$database" : "") . 
        ($add_idp ? "\n$add_idp" : "" );

	print stderr "$idp\n";

    my $response = $IDP->Send($idp);
    my $reply = ParseReplyBlock( $response );

    return ($reply->{QrwQueryAttrs}, $reply->{kSearchYquery}, $reply->{NumResults}, $reply->{TotalHits}, ExtractResults( $reply ) );
#	return ($reply->{QrwQueryAttrs}, $reply->{Phase0kSearchYquery}, $reply->{NumResults}, $reply->{TotalHits}, ExtractResults( $reply ) );

}


my $nresults=5;
my $QPS = 10;

while ( <STDIN> ) {
  chomp;

  my $q = $_;
  my $input = $_;
#  if($q =~ / /){
#	$q ="\"$q\"";
#  }

  my $se_query = $q;
  $se_query = "ALLWORDS($q ) " if($q !~ /YQUERY/);

#  my ($attributes, $yquery, $nr, $hits, $results) = GetResults( $se_query, "wow~qrw2-en-us", "", "", $nresults );

  my ($attributes, $yquery, $nr, $hits, $results) = GetResults( $se_query, "wow-en-us", "", "", $nresults );

  my @urls = defined($results->{"url"}) ? @{$results->{"url"}} : ();
  my @texts = defined($results->{"smartdigest"}) ? @{$results->{"smartdigest"}} : ();
  my @titles = defined($results->{"title"}) ? @{$results->{"title"}} : ();
  my @rawscores = defined($results->{"rawscore"}) ? @{$results->{"rawscore"}} : ();
  my @nodenames = defined($results->{"nodename"}) ? @{$results->{"nodename"}} : ();

  print "$se_query\n";
  print "QrwAttributes:$attributes\n";
  print "YQUERY: $yquery\n";

  foreach my $url(@urls){
	print "\t$url\n";
  }
  
  for(my $i=0; $i<@urls; $i++){
#	print "\tResults $i:\n";
#	print "\t".$urls[$i]."\n";
#	print "\t".$titles[$i]."\n\n";
#	print "\t".$texts[$i]."\n";

#	print "\n";
  }

   sleep(1/$QPS);


}
