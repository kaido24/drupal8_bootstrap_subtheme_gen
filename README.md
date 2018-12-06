# Motivation
It is time consuming to learn and set up Drupal 8 Bootstrap 3 less subtheme every time when I need it.
I decided to create automatic script using my own workflow.

## Requirements
Node.js
Grunt.js

## Expected folder structure
themes/contrib/boostrap</br>
themes/custom/willGenerateYourTheme
## What to expect
It make a copy from less version of Bootstrap 3 starterkit and configure it using your values and will set up npm packages.

## Usage
Make sure you have following folder structure:</br>
themes/contrib/boostrap</br>
themes/custom/
Go to Drupal theme folder using terminal window and download shell file.
###  CURL
curl -O https://raw.githubusercontent.com/kaido24/drupal8_bootstrap_subtheme_gen/master/bootstrap_subtheme_gen.sh
### WGET
wget https://raw.githubusercontent.com/kaido24/drupal8_bootstrap_subtheme_gen/master/bootstrap_subtheme_gen.sh

run command: sh bootstrap_subtheme_gen.sh


###Gruntfile.js config
It has shell support built in and you sould define your drush/drupal executable path or make sure the command works.. 
If it doesn't suite for your workflow you can just remove shell option.

### Cool commands
grunt watch - normal watch command with default tasks clear cache included

grunt watch-all - watches for all the changes and builds the files and clears the caches

grunt watch-twig - watches twig file changes clears the caches
