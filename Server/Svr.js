var WebSocketServer = require ('ws').Server;
var EventEmitter = require('events').EventEmitter;

var wss = new WebSocketServer({port:3000});
console.log('Server on port 3000');

var socketsList = new Array();
var buffer = new Array();
var i = 0;

var dataEmitter = new EventEmitter();
dataEmitter.on('data',dataHandler);
wss.on('connection', function(ws){
		
		if(i==2){
			i=0;
			socketsList = [];
		}
		
		socketsList[i] = ws;
		console.log("对象"+i+"连接");
		i++;
		
		buffer = SyncPlayers(socketsList);
		
		ws = socketsList[1];
		

		//向客户端发送消息
		//socketsList[1].send('from Svr：Hello Cocos2d-x lua');
		//注册接收消息
		socketsList[0].on('message', function(data){
			//console.log(data);
			//console.log('end');
			//dataEmitter.emit('data');
		});
		
		if(i>1)
		{
			socketsList[0].on('message', function(data){
				socketsList[1].send(data);	
				//console.log(data);
			});
		}
});

function SyncPlayers(socketlist){
	var buf = new Array();
	if(socketlist.length <=1){
		console.log("正在等待其他玩家。")
	}
	else{
		socketlist.forEach(function(socket, index){
			console.log(index);
			socket.on('message', function(data){				
				console.log(index+":"+data)
				buf[index] = data;
			})
		})
	}
	return buf;
}

function dataHandler(){
	console.log("dataHandler");
}

