import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get_ip/get_ip.dart';

var sockets = {};

void startServer(){
  Timer(Duration(seconds:3),handleTimeout);
  ServerSocket
  .bind('::', 4041)
  .then((serverSocket) {
      serverSocket.listen((socket) {
          sockets[socket] = [socket,new DateTime.now()];
          var tmpData="";
			    socket.listen((s) {
            tmpData = onData(socket, tmpData, s);
            sockets[socket] = [socket,new DateTime.now()];
          });
        }
      );
    }
  );
  print(DateTime.now().toString() + " Socket start listening on 4041...");
}

String onData(Socket socket, String sData, List<int> x){
  print(x);
  var s = "\n";
  socket.add([66]);
  return s;
}

void handleTimeout()
{
  var now = new DateTime.now();
  var sockets2 = {};
  for (var i in sockets.keys)
  {
    if (now.millisecondsSinceEpoch > sockets[i][1].millisecondsSinceEpoch + 6000)
    {
      sockets[i][0].close();
      print("timeout");
      continue;
    }
    sockets2[i] = sockets[i];
  }
  sockets = sockets2;
  Timer(Duration(seconds:3),handleTimeout);
}
var addresses = "";
void getIP()async{
  print("66666666666666666666666666666");
  addresses = await GetIp.ipv6Address;
  print(addresses);
}

void main() 
{
  getIP();
  startServer();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _ip = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }
  void startInternetGetIP() async {
    try {
      var responseBody;
      var url='http://nicehero.io:8000/';
      var httpClient = new HttpClient();
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == 200) 
      {
        responseBody = await response.transform(utf8.decoder).join();
        setState(() {
          _ip = _ip + "\n\ninternet get: " + responseBody;
        });
      }
      else
      {
        setState(() {
          _ip = _ip + "\n\nInternet get: Error";
        });
      } 
    }
    catch(e)
    {
      setState(() {
        _ip = _ip + "\n\nInternet get: Error";
      });
    }
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String ipAddress;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      ipAddress = await GetIp.ipAddress;
      ipAddress = ipAddress + ",";
      ipAddress = ipAddress + await GetIp.ipv6Address;
    } 
    on PlatformException 
    {
      ipAddress = 'Failed.';
    }

    if (!mounted) return;

    setState(() {
      _ip = ipAddress;
      startInternetGetIP();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('get IPv6 address and Listen on it'),
        ),
        body: new Center(
          child: new Text('Api get: $_ip\n'),
        ),
      ),
    );
  }
}