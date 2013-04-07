X11 Key Stats
=============

Simple, live, global key event stats for X11

## Installation

  * Clone and make https://github.com/RickyCook/keylogger-X11
  * Put resulting ```keylogger-X11``` binary in the same directory as stats.pl

## Installation (Google forms)

  * Install packages

    cpanm LWP::UserAgent Time::Format

  * Create a Google form with timestamp and WPM questions
  * From the form submission page, get the form action URL, timestamp question input name and the WPM question input name and put them in the ```FORM_URL```, ```TIMESTAMP_NAME``` and ```WPM_NAME``` fields respectively
  * Type some stuff! You should see information getting submitted right away. Make graphs, analyze the results!

## Usage

    ./stats.pl [-p]

    -p  Parsable mode; output is character time and wpm split by whitespace

    ./to-google-forms.pl
