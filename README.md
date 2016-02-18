# TinyBot

Tiny Bot is an IRC bot which can say useful information depending on what you
say.

## Configuration

First, you need to set up your YouTube API key in the `src/Youtube.pm`.
You can customize your bot (like its name) in the `src/Bot.pl` file.
You can create flags (starting with the ! character).

## How to use it

`./Bot.pl` or `perl Bot.pl`

## Default flags

* `!yt <sentence>`: display the first video matching `<sentence>` and a link

