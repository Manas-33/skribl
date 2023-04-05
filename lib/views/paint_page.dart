// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class PaintPage extends StatefulWidget {
  final Map data;
  final String screenFrom;
  PaintPage({
    Key? key,
    required this.data,
    required this.screenFrom,
  });

  @override
  State<PaintPage> createState() => _PaintPageState();
}

class _PaintPageState extends State<PaintPage> {
  late IO.Socket _socket;
  String dataOfRoom = "";
  @override
  void initState() {
    super.initState();
    connect();
  }

  // Socket.io client connection
  void connect() {
    _socket = IO.io('http://192.168.1.4:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false
    });
    _socket.connect();

    if (widget.screenFrom == "createRoom") {
      _socket.emit("create-game", widget.data);
    }

    //listening to socket
    _socket.onConnect((data) {
      print("connected");
      _socket.on('updateRoom', (roomData) {
        setState(() {
          dataOfRoom = roomData;
        });
        if (roomData['isJoin'] != true) {
          //start tier
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
