---
title: Hexo用gulp压缩静态资源的问题
date: 2020-04-04 05:40:48
tags: [problem,Hexo,gulp]
copyright: philxling
categories: problem
---

### Hexo 建站面临的访问缓慢问题一直不得其解,经过大量的搜索后解决一半

搜索几乎都是用neat和gulp,但是都是老版本的js,运行一直报错

#### 1 安装 gulp

站点目录下执行

```
npm install gulp -g
```

#### 2 安装gulp插件

```
npm install gulp-minify-css --save
npm install gulp-uglify --save
npm install gulp-htmlmin --save
npm install gulp-htmlclean --save
npm install gulp-imagemin --save
```

执行一次安装

```
 npm install gulp-htmlclean gulp-htmlmin gulp-minify-css gulp-uglify gulp-imagemin --save
```

安装其他一些插件

```
# 解决【Gulp打包问题】 GulpUglifyError: unable to minify JavaScript
# 解决 gulp-uglify 压缩JavaScript 不兼容 es5 语法的问题
npm install babel-core@6.26.3 --save
npm install gulp-babel@7.0.1 --save
npm install babel-preset-es2015@6.24.1 --save
# gulp-babel 取消严格模式方法("use strict")
npm install babel-plugin-transform-remove-strict-mode --save
```

#### 3 根目录创建gulpfile.js并加入一下代码

```javascript
var gulp = require('gulp');
var minifycss = require('gulp-minify-css');
var uglify = require('gulp-uglify');
var htmlmin = require('gulp-htmlmin');
var htmlclean = require('gulp-htmlclean');
var imagemin = require('gulp-imagemin');
var babel = require('gulp-babel');

// 压缩css文件
gulp.task('minify-css', async(done)=> {
    await gulp.src('./public/**/*.css')
        .pipe(minifycss())
        .pipe(gulp.dest('./public'));
    done();
});

// 压缩html文件
gulp.task('minify-html', async(done)=> {
    await gulp.src('./public/**/*.html')
        .pipe(htmlclean())
        .pipe(htmlmin({
            removeComments: true,
            minifyJS: true,
            minifyCSS: true,
            minifyURLs: true,
        }))
        .pipe(gulp.dest('./public'));
    done();
});

// 压缩js文件
gulp.task('minify-js', async(done)=>{
    await gulp.src(['./public/**/*.js', '!./public/**/*.min.js'])
        .pipe(babel({
            //将ES6代码转译为可执行的JS代码
            presets: ['es2015'] // es5检查机制
        }))
        .pipe(uglify())
        .pipe(gulp.dest('./public'));
    done();
});

// 压缩 public/images 目录内图片(Version<3)
// gulp.task('minify-images', function () {
//     gulp.src('./public/images/**/*.*')
//         .pipe(imagemin({
//             optimizationLevel: 5, //类型：Number  默认：3  取值范围：0-7（优化等级）
//             progressive: true, //类型：Boolean 默认：false 无损压缩jpg图片
//             interlaced: false, //类型：Boolean 默认：false 隔行扫描gif进行渲染
//             multipass: false, //类型：Boolean 默认：false 多次优化svg直到完全优化
//         }))
//         .pipe(gulp.dest('./public/images'));
// });

// 压缩 public/images 目录内图片(Version>3)
gulp.task('minify-images', async(done)=> {
    await gulp.src('./public/images/**/*.*')
        .pipe(imagemin([
            imagemin.gifsicle({interlaced: true}),
            //imagemin.jpegtran({progressive: true}),
            imagemin.optipng({optimizationLevel: 5}),
            imagemin.svgo({
                plugins: [
                    {removeViewBox: true},
                    {cleanupIDs: false}
                ]
            })
        ]))
        .pipe(gulp.dest('./public/images'));
    done();
});

//4.0以前的写法 
//gulp.task('default', [
//  'minify-html', 'minify-css', 'minify-js', 'minify-images'
//]);
//4.0以后的写法
// 执行 gulp 命令时执行的任务
gulp.task('default', gulp.series(gulp.parallel('minify-html', 'minify-css', 'minify-js', 'minify-images')), function () {
    console.log("----------gulp Finished----------");
    // Do something after a, b, and c are finished.
});
```

#### 4 执行

```
hexo g
gulp default
```

你会发现有这个错误

```
$ gulp default
[05:53:37] Using gulpfile E:\博客\philxling\gulpfile.js
[05:53:37] Starting 'default'...
[05:53:37] Starting 'minify-html'...
[05:53:37] Starting 'minify-css'...
[05:53:37] Starting 'minify-js'...
[05:53:37] Starting 'minify-images'...
[05:53:37] Finished 'minify-html' after 78 ms
[05:53:37] Finished 'minify-css' after 79 ms
[05:53:37] Finished 'minify-js' after 79 ms
[05:53:37] 'minify-images' errored after 79 ms
[05:53:37] TypeError: imagemin.jpegtran is not a function
    at E:\博客\philxling\gulpfile.js:60:22
    at minify-images (E:\博客\philxling\node_modules\undertaker\lib\set-task.js:13:15)
    at bound (domain.js:426:14)
    at runBound (domain.js:439:12)
    at asyncRunner (E:\博客\philxling\node_modules\async-done\index.js:55:18)
    at processTicksAndRejections (internal/process/task_queues.js:79:11)
[05:53:37] 'default' errored after 82 ms

```

注释掉` imagemin.jpegtran({progressive: true}),`并且修改代码, 将所有的function和return替换为async和await

```javascript
gulp.task('minify-css', function(done){
    return gulp.src('./public/**/*.css')
        .pipe(minifycss())
        .pipe(gulp.dest('./public'));
    done();
});
```

改为

```javascript
gulp.task('minify-css', async(done)=> {
    await gulp.src('./public/**/*.css')
        .pipe(minifycss())
        .pipe(gulp.dest('./public'));
    done();
});
```

再次` gulp`出现

```
$ gulp default
[05:32:10] Using gulpfile E:\博客\philxling\gulpfile.js
[05:32:10] Starting 'default'...
[05:32:10] Starting 'minify-html'...
[05:32:10] Starting 'minify-css'...
[05:32:10] Starting 'minify-js'...
[05:32:10] Starting 'minify-images'...
[05:32:11] Finished 'minify-html' after 434 ms
[05:32:11] Finished 'minify-css' after 435 ms
[05:32:11] Finished 'minify-js' after 435 ms
[05:32:11] Finished 'minify-images' after 434 ms
[05:32:11] Finished 'default' after 437 ms

events.js:288
      throw er; // Unhandled 'error' event
      ^
PluginError: ....
```

这些是js的一些问题,自己慢慢解决

我出现的是

```
 at new HTMLParser (E:\博客\philxling\node_modules\gulp-htmlmin\node_modules\
    at minify (E:\博客\philxling\node_modules\gulp-htmlmin\node_modules\html-min
    at Object.exports.minify (E:\博客\philxling\node_modules\gulp-htmlmin\node_m
    at minify (E:\博客\philxling\node_modules\gulp-htmlmin\index.js:16:44)
    at DestroyableTransform._transform (E:\博客\philxling\node_modules\gulp-html
    at DestroyableTransform.Transform._read (E:\博客\philxling\node_modules\read
    at DestroyableTransform.Transform._write (E:\博客\philxling\node_modules\rea
    at doWrite (E:\博客\philxling\node_modules\readable-stream\lib\_stream_writa
    at writeOrBuffer (E:\博客\philxling\node_modules\readable-stream\lib\_stream
    at DestroyableTransform.Writable.write (E:\博客\philxling\node_modules\reada
Emitted 'error' event on Domain instance at:
    at DestroyableTransform.EventEmitter.emit (domain.js:500:12)
    at DestroyableTransform.onerror (E:\博客\philxling\node_modules\readable-str
    at DestroyableTransform.emit (events.js:311:20)
    at DestroyableTransform.EventEmitter.emit (domain.js:482:12)
    at onwriteError (E:\博客\philxling\node_modules\readable-stream\lib\_stream_
    at onwrite (E:\博客\philxling\node_modules\readable-stream\lib\_stream_writa
    at WritableState.onwrite (E:\博客\philxling\node_modules\readable-stream\lib
    at DestroyableTransform.afterTransform (E:\博客\philxling\node_modules\reada
    at minify (E:\博客\philxling\node_modules\gulp-htmlmin\index.js:31:9)
    at DestroyableTransform._transform (E:\博客\philxling\node_modules\gulp-html
```

未解,但是能够` hexo d`

睡了,2020-4-4,祝大家好,祖国好.