#!/bin/bash -x:

echo Are you at themes/custom folder y/n?
read IS_THEME_FOLDER
if [ $IS_THEME_FOLDER != 'y' ];then
  exit
fi
if ! [ -d ../contrib/bootstrap ];then
  echo "run command: 'composer require drupal/bootstrap' at your drupal root folder"
  exit
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

cp -R ../contrib/bootstrap/starterkits/less $THEME_NAME

cd $THEME_NAME

tn='THEMENAME'
tt='THEMETITLE'
td='Bootstrap Sub-Theme (LESS)'
mv $tn.theme  $THEME_NAME.theme
mv $tn.starterkit.yml $THEME_NAME.info.yml

mv config/install/THEMENAME.settings.yml config/install/$THEME_NAME.settings.yml
mv config/schema/THEMENAME.schema.yml  config/schema/$THEME_NAME.schema.yml

sed -i -e "s/$tn/$THEME_NAME/g" $THEME_NAME.info.yml
sed -i -e "s/$tt/$THEME_NAME/g" $THEME_NAME.info.yml
sed -i -e "s/$tn/$THEME_NAME/g" config/schema/$THEME_NAME.schema.yml
sed -i -e "s/$tt/$THEME_NAME/g" config/schema/$THEME_NAME.schema.yml

rm *yml-e
rm THEMENAME.libraries.yml

echo 'framework:
  css:
    theme:
      assets/css/all.min.css: {}
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
    "bootstrap": "~3.3.7",
    "grunt": "^1.0.3",
    "grunt-contrib-concat": "^1.0.1",
    "grunt-contrib-cssmin": "^3.0.0",
    "grunt-contrib-less": "^2.0.0",
    "grunt-contrib-uglify": "^4.0.0",
    "grunt-contrib-watch": "^1.1.0",
    "grunt-shell": "^2.1.0"
  },
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "ISC"
}' > package.json

echo "module.exports = function(grunt) {
  grunt.initConfig({
    shell: {
     options: {
       stderr: true
     },
     target: {
        command: 'php72-cli ~/vendor/drush/drush/drush cr'
      }
    },
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
      less: {
        files: ['less/*'],
        tasks: ['default'],
      },
    },
   
    // Watch settings
    watchtwig: {
      less: {
        files: ['templates/*'],
        tasks: ['shell'],
      },
    },
    // Watch settings
    watchall: {
      less: {
        files: ['templates/*', '*theme', '*yml', 'less/*'],
        tasks: ['default'],
      },
    },
    // Contact settings
    concat: {
      options: {
        separator: ';'
      },
      dist: {
        src: ['node_modules/bootstrap/dist/js/bootstrap.js','js/webpro.js'],
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
  grunt.loadNpmTasks('grunt-contrib-watch');
  // Rename watch to watchtwig and load it again
  grunt.renameTask('watch', 'watchtwig');
  grunt.loadNpmTasks('grunt-contrib-watch');
  // Rename watch to watchtwig and load it again
  grunt.renameTask('watch', 'watchall');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-less');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-shell'); 
  grunt.registerTask('default', ['concat', 'uglify', 'less', 'cssmin', 'shell']);
};" > Gruntfile.js
sed -i -e "s/$tn/$THEME_NAME/g" $THEME_NAME.info.yml
sed -i -e "s/$td/$THEME_NAME/g" $THEME_NAME.info.yml
sed -i -e "s/$tn/$THEME_NAME/g" package.json
sed -i -e "s/$td/$THEME_NAME/g" $THEME_NAME.info.yml

npm install

sed -i -e "s@bootstrap/less@node_modules/bootstrap/less@g" less/bootstrap.less
sed -i -e "s@../bootstrap/fonts@./../fonts@g" less/variable-overrides.less
sed -i -e "s@../node_modules/bootstrap/less/variables.less@variables.less@g" less/bootstrap.less
cp node_modules/bootstrap/less/variables.less less/variables.less
if ! [ -d assets ];then
  mkdir assets assets/images
fi
cp ../../../core/misc/icons/ee0000/required.svg assets/images
cp -R node_modules/bootstrap/fonts assets
rm *.yml-e
rm less/*.less-e
grunt
cd ..
