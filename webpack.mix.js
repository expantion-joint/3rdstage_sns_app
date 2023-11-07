const mix = require('laravel-mix');

/*
 |--------------------------------------------------------------------------
 | Mix Asset Management
 |--------------------------------------------------------------------------
 |
 | Mix provides a clean, fluent API for defining some Webpack build steps
 | for your Laravel application. By default, we are compiling the Sass
 | file for the application as well as bundling up all the JS files.
 |
 */

mix.setPublicPath('public')
    .sass('app/assets/stylesheets/sass/app.scss', 'public/css/app.css')
    .js('app/javascript/app.js', 'public/js/app.js')
    .js('app/javascript/bootstrap.js', 'public/js/bootstrap.js')
    /*追加:turbo.jsをコンパイル対象とする*/
    .js('app/javascript/turbo.js', 'public/js/turbo.js')
    /*追加:modal.js*/
    .js('app/javascript/modal.js', 'public/js/modal.js')
    /*追加:jquery.jpostal.js*/
    // .js('app/javascript/jquery.jpostal.js', 'public/js/jquery.jpostal.js')
    /*追加:application.js*/
    .js('app/javascript/application.js', 'public/js/application.js')
    /*追加:time.js*/
    .js('app/javascript/time.js', 'public/js/time.js');

