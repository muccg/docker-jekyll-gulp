var gulp = require('gulp'),    
    sass = require('gulp-ruby-sass')
    notify = require("gulp-notify")
    uglify = require("gulp-uglify")
var config = {
    sassPath: '/app/sass',
    bowerDir: '/bower/bower_components/',
}

gulp.task('icons', function() {
    return gulp.src(config.bowerDir + '/font-awesome/fonts/**.*')
        .pipe(gulp.dest('/app/site/generated/fonts'));
});

gulp.task('minify-js', function() {
    return gulp.src(['/bower/bower_components/bootstrap-sass/assets/javascripts/bootstrap.js', '/bower/bower_components/jquery/dist/jquery.js'])
        .pipe(uglify())
        .pipe(gulp.dest('/app/site/generated/js/'));
});

gulp.task('css', function() {
    return gulp.src(config.sassPath + '/style.scss')
        .pipe(sass({
            style: 'compressed',
            loadPath: [
                config.sassPath,
                config.bowerDir + '/bootstrap-sass/assets/stylesheets',
                config.bowerDir + '/font-awesome/scss',
            ]
        })
            .on("error", notify.onError(function (error) {
                return "Error: " + error.message;
            })))
        .pipe(gulp.dest('/app/site/generated/css'));
});

// Rerun the task when a file changes
gulp.task('watch', function() {
    gulp.watch(config.sassPath + '/**/*.scss', ['css']);
});

gulp.task('default', ['minify-js', 'icons', 'css']);
