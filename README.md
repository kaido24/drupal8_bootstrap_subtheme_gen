# Motivation
It is time consuming to learn and set up Drupal 8 Bootstrap 3 less subtheme every time when I need it.
I decided to create automatic script using my own workflow.

## Requirements
Node.js
Grunt.js

## What to expect
This will download bootstrap theme using drush if its not there yet. (It reccommended to use composer nowdays). And make a copy from less version off bootrstap starterkit and configure it using your values.
## Usage
Go to Drupal theme folder using terminal window and download shell file.
###  CURL
curl -O https://raw.githubusercontent.com/kaido24/drupal8_bootstrap_subtheme_gen/master/bootstrap_subtheme_gen.sh
### WGET
wget https://raw.githubusercontent.com/kaido24/drupal8_bootstrap_subtheme_gen/master/bootstrap_subtheme_gen.sh

run command: sh bootstrap_subtheme_gen.sh
