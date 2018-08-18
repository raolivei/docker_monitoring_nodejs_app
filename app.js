cluster = require 'cluster'
numCPUs = require('os').cpus().length

var express = require('express');
var app = express();
                         
                         
if (cluster.isMaster)
    console.log 'I am the master, launching workers!'     
    cluster.fork() for i in [0...numCPUs]

else                     
    app.get('/', function (req, res) {
      res.send('Hello World!');
    });
    app.listen(3000, function () {
      console.log('Example app listening on port 3000!');
    });