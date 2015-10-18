module.exports = function (grunt) {

  require('load-grunt-tasks')(grunt);

  grunt.initConfig({
    clean: ['.compiled/'],

    connect: {
      server: {
        options: {
          port: 8080,
          base: './',
          livereload: true
        }
      }
    },

    express: {
      options: {
        port: 3000
      },
      dev: {
        options: {
          script: 'server/server.js',
          node_env: 'development'
        }
      }
    },

    coffee: {
      options: {
        bare: true
      },
      dev: {
        options: {
          sourceMap: true
        },
        files: [
          {
            expand: true,
            cwd: 'app/',
            src: ['**/*.coffee'],
            dest: '.compiled/',
            ext: '.js'
          }
        ]
      }
    },

    coffeelint: {
      app: ['app/**/*.coffee'],
      options: {
        max_line_length: {
          value: 100
        }
      }
    },

    sass: {
      dev: {
        files: {
          'app/assets/css/main.css': 'app/assets/scss/main.scss'
        },
        options: {
          style: 'expanded'
        }
      }
    },

    copy: {
      main: {
        files: [
          {
            expand: true,
            cwd: 'app/',
            src: [
              '**/*.css',
              '**/*.hbs',
              '**/*.js',
              '**/*.png',
              '**/*.gif',
              '**/*.jpg',
              '**/*.ttf',
              '**/*.woff',
              '**/*.eot',
              '**/*.svg',
              '**/*.html',
              'assets'
            ],
            dest: '.compiled/'
          }
        ]
      }
    },

    watch: {
      options: {
        livereload: true,
        add: true
      },
      coffee: {
        files: ['app/**/*.coffee'],
        tasks: ['coffeelint', 'coffee:dev']
      },
      scss: {
        files: ['app/**/*.scss'],
        tasks: ['sass', 'copy']
      },
      hbs: {
        files: ['app/**/*.hbs'],
        tasks: ['copy']
      },
      express: {
        files: ['server/**/*.js'],
        tasks: ['express:dev']
      }
    }
  });

  grunt.registerTask('run', 'run all tasks', function() {
    var tasks = [
      'clean',
      'coffeelint',
      'coffee:dev',
      'sass:dev',
      'copy',
      'express:dev',
      'watch'
    ];
    grunt.option('force', true);
    grunt.task.run(tasks);
  });

  grunt.registerTask('default', ['run']);
};