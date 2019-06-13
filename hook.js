/**
 * date:2019-06-13 09:48:23
 * author:Gloomy
 * description: Node Git Hook
 * 将此脚本放在服务器上，使用pm2启动即可
 */

var http = require('http');
var process = require("child_process");
var fs = require("fs");
http.createServer(function (req, res) {
    var body = "";

    req.on('data', function (chunk) {
        body+=chunk;
    });

    req.on('end', function () {
        console.log(body);
        data = JSON.parse(body);
        try{
            var name = data.repository.name;
            if(fs.existsSync("/data/www/"+name)){
                process.exec("cd /data/www/"+name+";git pull;",function(err){
                    if(err !== null)
                    {
                        console.log("执行失败："+err);
                    }
                    else
                    {
                        console.log((new Date())+":"+name+" git pull ");
                    }
                });
            }
        }catch(e){
            console.log(e)
        }
        res.writeHead(200, {'Content-Type': 'text/plain'});
        res.end('.\n');
    });
}).listen(8008);
