#!/bin/bash -x

echo Are you at themes folder y/n?
read IS_THEME_FOLDER
if [ $IS_THEME_FOLDER != 'y' ];then
  exit
fi
if ! [ -d bootstrap ];then
  drush dl bootstrap
fi

echo Enter your bootstrap subtheme name!
read THEME_NAME

if [ -d $THEME_NAME ];then
  echo There is already folder with this name! Would you like to recreate? y/n
  read RECREARE
  if [ $RECREARE != 'y' ];then
     exit
  else
    rm -rf $THEME_NAME
  fi
fi

cp -R bootstrap/starterkits/less $THEME_NAME

cd $THEME_NAME

tn='THEMENAME'
td='Bootstrap Sub-Theme (LESS)'
mv $tn.theme  $THEME_NAME.theme
mv $tn.starterkit.yml $THEME_NAME.info.yml

sed -i -e "s/$tn/$THEME_NAME/g" $THEME_NAME.info.yml
sed -i -e "s/$td/$THEME_NAME/g" $THEME_NAME.info.yml
rm *yml-e
rm THEMENAME.libraries.yml

echo 'global-styling:
  css:
    theme:
      assets/css/all.min.css: {}

bootstrap-scripts:
  js:
    assets/js/all.min.js: {}
' > "${THEME_NAME}.libraries.yml"

echo '{
  "name": "THEMENAME",
  "version": "1.0.0",
  "description": "<!-- @file Instructions for subtheming using the LESS Starterkit. --> <!-- @defgroup sub_theming_less --> <!-- @ingroup sub_theming --> # LESS Starterkit",
  "main": "Gruntfile.js",
  "dependencies": {},
  "devDependencies": {
    "grunt": "~0.4.5",
    "grunt-contrib-less": "^1.0.0",
    "grunt-contrib-watch": "~0.6.1",
    "grunt-contrib-concat": "~1.0.1",
    "grunt-contrib-cssmin": "~1.0.1",
    "grunt-contrib-uglify": "~2.0.0",
    "bootstrap": "~3.3.7"
  },
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "ISC"
}' > package.json

echo "module.exports = function(grunt) {
  grunt.initConfig({
    // Less settings
    less: {
      development: {
        options: {
          paths: ['css']
        },
        files: {
          'assets/css/style.css': 'less/style.less'
        }
      }
    },
    // Watch settings
    watch: {
      files: ['less/*'],
      tasks: ['less']
    },
    // Contact settings
    concat: {
      options: {
        separator: ';'
      },
      dist: {
        src: ['node_modules/bootstrap/dist/js/bootstrap.js'],
        dest: 'assets/js/all.js'
      },
    },
    // CSSMIN settings
    cssmin: {
      target: {
        files: {
          'assets/css/all.min.css': ['assets/css/style.css']
        }
      }
    },
    // Uglify settings
    uglify: {
      my_target: {
        files: {
          'assets/js/all.min.js': ['assets/js/all.js']
        }
      }
    }
  });

  // Register tasks
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-less');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.registerTask('default', ['concat', 'uglify', 'less', 'cssmin']);
};" > Gruntfile.js
sed -i -e "s/$tn/$THEME_NAME/g" $THEME_NAME.info.yml
sed -i -e "s/$td/$THEME_NAME/g" $THEME_NAME.info.yml
sed -i -e "s/$tn/$THEME_NAME/g" package.json
sed -i -e "s/$td/$THEME_NAME/g" $THEME_NAME.info.yml

npm install

sed -i -e "s/bootstrap\/less/\node_modules\/bootstrap\/less/g" less/bootstrap.less
sed -i -e "s/..\/bootstrap\/fonts/.\/..\/fonts/g" less/variable-overrides.less
sed -i -e "s/..\/node_modules\/bootstrap\/less\/variables.less/variables.less/g" less/bootstrap.less
cp node_modules/bootstrap/less/variables.less less/variables.less
if ! [ -d assets ];then
  mkdir assets
fi

cp -R node_modules/bootstrap/fonts assets
rm *.yml-e
rm less/*.less-e
grunt
cd ..
