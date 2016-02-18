# TinyBot

Tiny Bot is an IRC bot which can say useful information depending on what you
say.

## Configuration

First, you need to have Bot::BasicBot and Mojo::UserAgent. This module is 
available on the CPAN. If you don't have, just type `cpan Bot::BasicBot` and
cpan `Mojo::UserAgent`.
Next, you need to set up your YouTube API key in the `src/Youtube.pm`.
You can customize your bot (like its name) in the `src/Bot.pl` file.
You can create flags (starting with the ! character).
All flags are stored in "flags.bot". If we create a flag that does already
exist, it's replaced by the new one.
You can also customize a message in order to disconnect the bot of the channel.

## How to use it

`./Bot.pl` or `perl Bot.pl`. If you use ./Bot.pl, don't forget to give right
execution with `chmod +x Bot.pl`

## Default flags

* `!yt <sentence>`: display the first video matching `<sentence>` and a link

## How to create flags

Just type `!myflags = <what you want>` and after `!myflags` in order to display
the command.

