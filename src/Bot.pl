#!/usr/bin/perl

use 5.014;
use warnings;

package MyBot;
use base qw( Bot::BasicBot );
use Mojo::UserAgent;
use Tie::File;
use Youtube;

my $busy = 0;
tie my @array, 'Tie::File', "flags.bot" or die $!;

#self->{master} : Master's bot
#msg->{who} : Who send the message
#self->{nick} : The nick of the bot
#msg->{body} : the body of the message

sub said {
  my ($self, $msg) = @_;
  my $response = $msg->{body};
  my @splitword = split(/\s+/, $msg->{body});
  if ($response =~ /^!\w+\s+=.*$/) # If we want register a flags
  {
    my $flags = $splitword[0];
    my $find = -1;
    foreach my $i (0 .. $#array)
    {
      say $array[$i];
      if ($array[$i] =~ /^$flags/) #We remplace it
      {
        $array[$i] = $msg->{body} . " &authors& " . $msg->{who};
        $find = $i;
        last;
      }
    }
    if ($find == -1) # We havn't find it
    {
      push @array, $msg->{body} . " &authors& " . $msg->{who};
    }
  }
  elsif($msg->{body} =~ /^!\w+$/) #Call a flags
  {
    my $string = "";
    foreach my $i (0 .. $#array)
    {
      if ($array[$i] =~ /^$response\s+/)
      {
        my @toPrint = split(/\s+/, $array[$i]);
        foreach my $elt (2 .. $#toPrint - 2)
        {
          $string .= $toPrint[$elt] . " ";
        }
      }
    }
    if ($string ne "")
    {
      $self->say(
        who=>$msg->{who},
        channel=>$msg->{channel},
        address=>$msg->{who},
        body=>$string,
      );
    }
  }
  elsif($msg->{body} =~ /^!\w+\s+>\s+\w+$/) #A flags to another person
  {
    my $string = "";
    foreach my $i (0 .. $#array)
    {
      if ($array[$i] =~ /^$splitword[0]\s+/)
      {
        my @toPrint = split(/\s+/, $array[$i]);
        foreach my $elt (2 .. $#toPrint - 2)
        {
          $string .= $toPrint[$elt] . " ";
        }
      }
    }
    if ($string ne "")
    {
      $self->say(
        who=>$splitword[-1],
        channel=>$msg->{channel},
        address=>$splitword[-1],
        body=>$string,
      );
    }
  }

  Youtube::find($self, $msg) if ($msg->{body} =~ /^!yt/); #Youtube API

  if (($msg->{body} =~ $self->{hl_regexp}) and $busy) {
      $self->say(
        who=>"all",
        channel=>$msg->{channel},
        body=>$self->{msg_hl},
     );
  }
  
  $busy = 0
   if (($self->{master} eq $msg->{who}) and 
        $msg->{body} =~ /Je suis la/);
  if (($self->{master} eq $msg->{who}) and 
        $msg->{body} =~ /Je suis occupe/)
  {
      $busy = 1;
      $self->say(
      who=>$self->{master},
      channel=>$msg->{channel},
      body=>"Ok",
     );
  }
 
  # In order to leave the bot of IRC
  if (($self->{master} eq $msg->{who}) and 
        $msg->{body} =~ /The message you want in order it leave the chan/)
  {
    $self->shutdown($self->quit_message("Merci maitre"));
    # The message where it quit the chan
  }
}

sub emoted {
  my ($self, $msg) = @_;
  if ($msg->{body} =~ $self->{hl_regexp}) {
      $self->say(
        who=>$msg->{who},
        channel=>$msg->{channel},
        body=>$self->{msg_hl},
      );
  }
}

sub chanjoin {
  my ($self, $msg) = @_;
  if ($msg->{who} ne $self->{master} and $msg->{who} ne $self->{nick}) {
    $self->say(
      who=>$msg->{who},
      address=>$msg->{who},
      channel=>$msg->{channel},
      body=>$self->{msg_join},
    );
  }
}


my $bot = MyBot->new(
  server => "your server",
  channels => ["#yourchannel"],
  nick => 'Name of your bot',
  charset=> "utf-8",
  master=>"Your name",
  hl_regexp=>qr/.*Your name.*/i, #Don't forget to escape character if we need
  msg_hl=>"I'm busy", # If you'r busy
)->run();

END
{
  untie @array;
}
