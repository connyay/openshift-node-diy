'use strict';

var http = require('http'),
    fs = require('fs'),
    index;

var port = process.env.PORT || 9000;
var ip = process.env.IP || 'localhost';

var env = process.env.NODE_ENV || 'development';
if ('production' === env) {
    ip = process.env.OPENSHIFT_NODEDIY_IP || ip;
    port = process.env.OPENSHIFT_NODEDIY_PORT || port;
}

fs.readFile(__dirname + '/503.html', function (err, data) {
    if (err) { throw err; }
    index = data;
});

http.createServer(function(request, response) {
    response.writeHeader(503, {
        'Content-Type': 'text/html',
        'Pragma': 'no-cache',
        'Expires': '-1',
        'Cache-Control': 'no-store, no-cache, must-revalidate'
    });
    response.write(index);
    response.end();
}).listen(port, ip);
