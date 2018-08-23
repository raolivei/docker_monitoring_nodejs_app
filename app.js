var cluster = require('cluster');
var numCPUs = require('os').cpus().length;

var express = require('express');
var app = express();


if (cluster.isMaster) {

    //  console.log ('I am the MASTER');
    // Shows number of CPUs
    console.log('Num of CPUs: '+numCPUs)
    
    for (var i = 0; i < numCPUs; i++) {
    // Fork workers.
        cluster.fork();
    }
    
    
        cluster.on('exit', function(worker, code, signal) {
        console.log('WARNING: worker ' + worker.process.pid + ' is down');
    });

} else {
        
        // port 3000 listener
        app.get('/', function (req, res) {
        res.send('Hello world!');
        });
        app.listen(3000, function () {
        console.log('Example app listening on port 3000!');
        
        });
}