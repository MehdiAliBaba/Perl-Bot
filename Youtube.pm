package Youtube;


use 5.014;
use warnings;

use Mojo::UserAgent;
use Bot::BasicBot;

use constant URL_YOUTUBE => 'https://youtube.com/watch?v=';
use constant API_KEY => 'AIzaSyDLI526AEz9VvCzvMIJKyTVKfCPeclZNE4';

# Create your own API_KEY at:
# https://developers.google.com/youtube/v3/getting-started

use constant API_URL => 'https://www.googleapis.com/youtube/v3/search?part=snippet&key=';
use constant API_OPTIONS => '&type=video&q=';

sub find
{
  my ($self, $msg) = @_;
  my $string = "";
  my @array = split(" ", $msg->{body});
  # Cut the string into an array
  
  foreach my $elt (@array)
  {
    next if ($elt =~ /!yt/);
    $string .= $elt . "%22";
    # %22 is used in an URL in order to replace space
    # i.e "Hello World" => "Hello%22World"
  }
  $string = substr($string, 0, -3);  # Cut the !yt

  chomp $string;

  my $url = API_URL . API_KEY . API_OPTIONS . $string;
  my $ua = Mojo::UserAgent->new;
  my $data =  $ua->get($url)->res->json; # Parse the JSON reques
  my $record = $data->{items}[0];
  my $id = $record->{id}{videoId};
  my $title = $record->{snippet}{title};
  $self->say(
    who=>$msg->{who},
    channel=>$msg->{channel},
    address=>$msg->{who},
    body=>$title . "  " . URL_YOUTUBE . "$id",
  );
}
1;
