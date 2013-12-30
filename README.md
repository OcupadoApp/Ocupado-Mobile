# Ocupado Mobile

### About
This is a fork of [Ocupado](https://github.com/richgilbank/Ocupado) intended to be built with Phonegap for mobile devices to allow them to book rooms.
More info is available there.

### Stack
 - [Backbone](http://backbonejs.org/)
     - [Backbone-relational](http://backbonerelational.org/)
 - [Grunt](http://gruntjs.com/)
     - [Grunt-contrib-stylus](https://github.com/gruntjs/grunt-contrib-stylus)
     - [Grunt-contrib-handlebars](https://github.com/gruntjs/grunt-contrib-handlebars)
     - [Grunt-mocha](https://github.com/kmiyashiro/grunt-mocha)
 - [Raphael](http://raphaeljs.com/)
 - [Handlebars](http://handlebarsjs.com/)
 - [Yeoman](http://yeoman.io)
 - [Bower](http://bower.io/)

### Running it
To run it, you must have Node.js installed on your system. `cd` into the directory you cloned the repo into. From there, you'll need to install grunt and a few other things, which can be done with `npm install -g`. You'll also need to pull the bower dependencies, with `bower install`.

`grunt server` will start the server on port 9000, from where you will have to authenticate using the Google account you use to access your meeting rooms.

`grunt test` will run the test suite (currently incomplete).

`grunt build` compiles the app into the `dist` directory.

