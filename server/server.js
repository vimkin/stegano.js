/*jslint node: true */
'use strict';

var express = require('express');
var http = require('http');
var config = require('./config');
var routes = require('./routes');
var bodyParser = require('body-parser');
var errorHandler = require('errorhandler');
var mongoose = require('mongoose');
var app = express();
var server = http.createServer(app);

// Connect to database
mongoose.connect(config.mongo.uri, config.mongo.options);

// Set static dir servering
var staticDirName = __dirname.split((__dirname.indexOf('/')>-1) ? '/' : '\\');
staticDirName.pop();
app.use(express.static(staticDirName.join('/')));

// Set development nasty logs
if (process.env.NODE_ENV === 'development') {
    app.use(errorHandler());
    mongoose.set('debug', true);
}

// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({extended: false}));
// parse application/json
app.use(bodyParser.json());

// Set renderer
app.engine('.html', require('ejs').__express);
app.set('views', __dirname + '/pages');
app.set('view engine', 'html');

// Register routes
routes(app);

// Default route index page render
app.get('*', function (req, res) {
    res.render('index');
});

// Start server
server.listen(config.port, config.ip, 511, function () {
    var host = server.address().address;
    var port = server.address().port;
    console.log('App listening at http://%s:%s, mode %s', host, port, process.env.NODE_ENV);
});
