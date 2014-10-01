module.exports = function(grunt) {

    // INIT CONFIG
    grunt.initConfig({

        // -------------------------
        // BROWSERIFY
        // -------------------------
        browserify: {
            dist: {
                files: {
                    'bin/js/chi-prototype.js': ['scripts/**/*.coffee', 'scripts/prototype/*.coffee'],
                    'bin/js/chi-div.js': ['scripts/**/*.coffee', 'scripts/main.coffee'],

                },
                options: {
                  transform: ['coffeeify']
                }
            }
        },

        // -------------------------
        // JADE HTML
        // -------------------------
        jade: {
          compile: {
            options: {
              data: {
                debug: true
              }
            },
            files: {
              // "index.html": ["templates/index/*.jade"],
              "bin/signature-prototype.html": ["templates/signature/*.jade"]
            }
          }
        },

        // -------------------------
        // SASS CSS
        // -------------------------
        sass: {                              // Task
            dist: {                            // Target
              options: {                       // Target options
                style: 'expanded'
              },
              files: {                         // Dictionary of files
                'bin/style/main.css': 'scss/main.scss',       // 'destination': 'source'
                'bin/style/prototype.css': 'scss/prototype.scss'
              }
            }
        },

        // -------------------------
        // GRUNT-WATCH
        // -------------------------
        watch: {
            options: {
              livereload: true,
            },

            browserify: {
                files: ['Gruntfile.js', 'scripts/*.coffee', 'scripts/lib/*.js', 'scripts/**/*.coffee'],
                tasks: ['browserify'],
                // options: {
                //   event: ['added', 'deleted'],
                // },
            },

            jade: {
                files: ['templates/**/*.jade', 'script/*.jade'],
                tasks: ['jade']
            },

            css: {
                files: ['scss/**/*.scss', 'scss/*.scss'],
                tasks: ['sass']
            }

            // css: {
            //     files: []
            // },
        },


    });


    // LOAD NPM
    grunt.loadNpmTasks('grunt-contrib-jade');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-browserify');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-sass');

    // TASKS
    grunt.registerTask('js', ['browserify']);
    grunt.registerTask('default', ['browserify','jade', 'sass']);

};

