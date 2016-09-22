var gulp = require('gulp'),    
    sass = require('gulp-ruby-sass')
    notify = require("gulp-notify")
var config = {
    sassPath: '/app/sass',
    bowerDir: '/bower/bower_components/',
}

gulp.task('icons', function() {
    return gulp.src(config.bowerDir + '/font-awesome/fonts/**.*')
        .pipe(gulp.dest('/app/site/generated/fonts'));
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

gulp.task('default', ['icons', 'css']);
