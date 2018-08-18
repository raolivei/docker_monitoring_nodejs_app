var cluster = require('cluster');
var numCPUs = require('os').cpus().length;

var express = require('express');
var app = express();

if (cluster.isMaster) {
    // Fork workers.
      console.log ('I am the MASTER');
    for (var i = 0; i < numCPUs; i++) {
        cluster.fork();
    }
    
        cluster.on('exit', function(worker, code, signal) {
        console.log('worker ' + worker.process.pid + ' died');
    });


} else {
        console.log('I am a WORKER');
//piece of code from chaordic
        app.get('/', function (req, res) {
        res.send('Hello World!');
        });
        app.listen(3000, function () {
          console.log('Example app listening on port 3000!');
        });
}