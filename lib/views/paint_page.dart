import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:scribble/models/drawing_point.dart';
import 'package:scribble/views/home_page.dart';
import 'package:scribble/views/waiting_lobby_page.dart';
import 'package:scribble/views/widgets/player_score_drawer.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/custom_painter.dart';
import 'leaderboard.dart';

class PaintPage extends StatefulWidget {
  final Map<String, String> data;
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
  Map dataOfRoom = {};
  List<DrawingPoint?> points = [];
  StrokeCap strokeType = StrokeCap.round;
  Color selectedColor = Colors.red;
  double opacity = 1;
  double strokeWidth = 2;
  List<Widget> textBlankWidget = [];
  ScrollController _scrollController = ScrollController();
  List<Map> messages = [];
  TextEditingController _controller = TextEditingController();
  int guessedUserCtr = 0;
  int _start = 60;
  late Timer _timer;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map> scoreboard = [];
  bool isTextInputReadOnly = false;
  int maxPoints = 0;
  String winner = '';
  bool isShowFinalLeaderboard = false;

  @override
  void initState() {
    super.initState();
    connect();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer time) {
      if (_start == 0) {
        _socket.emit('change-turn', dataOfRoom['name']);
        setState(() {
          _timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void renderTextBlank(String text) {
    textBlankWidget.clear();
    for (int i = 0; i < text.length; i++) {
      textBlankWidget.add(
          const Text('_', style: TextStyle(fontSize: 30, color: Colors.white)));
    }
  }

  // Socket.io client connection
  void connect() {
    _socket = IO.io('http://192.168.1.7:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false
    });
    _socket.connect();

    if (widget.screenFrom == "createRoom") {
      _socket.emit("create-game", widget.data);
    } else {
      _socket.emit("join-game", widget.data);
    }

    //listening to socket
    _socket.onConnect((data) {
      print("connected");
      _socket.on('updateRoom', (roomData) {
        print(roomData['word']);
        setState(() {
          renderTextBlank(roomData['word']);
          dataOfRoom = roomData;
        });
        if (roomData['isJoin'] != true) {
          startTimer();
        }
        scoreboard.clear();
        for (int i = 0; i < roomData['players'].length; i++) {
          setState(() {
            scoreboard.add({
              'username': roomData['players'][i]['nickname'],
              'points': roomData['players'][i]['points'].toString()
            });
          });
        }
      });

      _socket.on('points', (point) {
        if (point['details'] != null) {
          setState(() {
            points.add(DrawingPoint(
                Offset((point['details']['dx']).toDouble(),
                    (point['details']['dy']).toDouble()),
                Paint()
                  ..strokeCap = strokeType
                  ..isAntiAlias = true
                  ..color = selectedColor.withOpacity(opacity)
                  ..strokeWidth = strokeWidth));
          });
        } else {
          setState(() {
            points.add(null);
          });
        }
      });
    });

    _socket.on('color-change', (colorString) {
      int value = int.parse(colorString, radix: 16);
      Color otherColor = new Color(value);
      setState(() {
        selectedColor = otherColor;
      });
    });

    _socket.on('stroke-width', (value) {
      setState(() {
        strokeWidth = value.toDouble();
      });
    });

    _socket.on('clean-screen', (data) {
      setState(() {
        points.clear();
      });
    });

    _socket.on('msg', (msgData) {
      setState(() {
        messages.add(msgData);
        guessedUserCtr = msgData['guessedUserCtr'];
      });
      if (guessedUserCtr == dataOfRoom['players'].length - 1) {
        _socket.emit('change-turn', dataOfRoom['name']);
      }
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut);
    });

    _socket.on('change-turn', (data) {
      String oldWord = dataOfRoom['word'];
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(const Duration(seconds: 3), () {
              setState(() {
                dataOfRoom = data;
                renderTextBlank(data['word']);
                isTextInputReadOnly = false;
                guessedUserCtr = 0;
                _start = 60;
                points.clear();
              });
              Navigator.of(context).pop();
              _timer.cancel();
              startTimer();
            });
            return AlertDialog(
              title: Center(
                child: Text("The word was $oldWord"),
              ),
            );
          });
    });

    _socket.on('closeInput', (_) {
      _socket.emit('updateScore', widget.data['name']);
      setState(() {
        isTextInputReadOnly = true;
      });
    });

    _socket.on('updateScore', (roomData) {
      scoreboard.clear();
      for (int i = 0; i < roomData['players'].length; i++) {
        setState(() {
          scoreboard.add({
            'username': roomData['players'][i]['nickname'],
            'points': roomData['players'][i]['points'].toString()
          });
        });
      }
    });

    _socket.on('show-leaderboard', (roomPlayers) {
      scoreboard.clear();
      for (int i = 0; i < roomPlayers.length; i++) {
        setState(() {
          scoreboard.add({
            'username': roomPlayers[i]['nickname'],
            'points': roomPlayers[i]['points'].toString()
          });
        });
        if (maxPoints < int.parse(scoreboard[i]['points'])) {
          winner = scoreboard[i]['username'];
          maxPoints = int.parse(scoreboard[i]['points']);
        }
      }
      setState(() {
        _timer.cancel();
        isShowFinalLeaderboard = true;
      });
    });

    _socket.on('user-disconnected', (data) {
      scoreboard.clear();
      for (int i = 0; i < data['players'].length; i++) {
        setState(() {
          scoreboard.add({
            'username': data['players'][i]['nickname'],
            'points': data['players'][i]['points'].toString()
          });
        });
      }
    });

    _socket.on(
        'notCorrectGame',
        (data) => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false));
  }

  @override
  void dispose() {
    _socket.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    void selectColor() {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Choose a color"),
                content: SingleChildScrollView(
                  child: BlockPicker(
                      pickerColor: selectedColor,
                      onColorChanged: (color) {
                        String colorString = color.toString();
                        String valueString =
                            colorString.split('(0x')[1].split(')')[0];
                        print(colorString);
                        print(valueString);
                        Map map = {
                          'color': valueString,
                          'roomName': dataOfRoom['name']
                        };
                        _socket.emit('color-change', map);
                      }),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Close",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ));
    }

    return Scaffold(
      key: scaffoldKey,
      drawer: PlayerDrawer(
        userData: scoreboard,
      ),
      body: dataOfRoom != null
          ? dataOfRoom['isJoin'] != true
              ? !isShowFinalLeaderboard
                  ? Container(
                      width: size.width,
                      height: size.height,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: size.width,
                                      height: size.height * 0.55,
                                      child: dataOfRoom['turn']?['nickname'] ==
                                              widget.data['nickname']
                                          ? GestureDetector(
                                              onPanUpdate: (details) {
                                                _socket.emit('paint', {
                                                  'details': {
                                                    'dx': details
                                                        .localPosition.dx,
                                                    'dy': details
                                                        .localPosition.dy,
                                                  },
                                                  'roomName':
                                                      widget.data['name'],
                                                });
                                              },
                                              onPanStart: (details) {
                                                _socket.emit('paint', {
                                                  'details': {
                                                    'dx': details
                                                        .localPosition.dx,
                                                    'dy': details
                                                        .localPosition.dy,
                                                  },
                                                  'roomName':
                                                      widget.data['name'],
                                                });
                                              },
                                              onPanEnd: (details) {
                                                _socket.emit('paint', {
                                                  'details': null,
                                                  'roomName':
                                                      widget.data['name'],
                                                });
                                              },
                                              child: SizedBox.expand(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(20)),
                                                  child: RepaintBoundary(
                                                    child: CustomPaint(
                                                      size: Size.infinite,
                                                      painter: MyCustomPainter(
                                                          pointsList: points),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : SizedBox.expand(
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20)),
                                                child: RepaintBoundary(
                                                  child: CustomPaint(
                                                    size: Size.infinite,
                                                    painter: MyCustomPainter(
                                                        pointsList: points),
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    dataOfRoom['turn']?['nickname'] ==
                                            widget.data['nickname']
                                        ? Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.color_lens,
                                                  color: Colors.white,
                                                ),
                                                onPressed: selectColor,
                                              ),
                                              Expanded(
                                                child: Slider(
                                                  min: 1,
                                                  max: 10,
                                                  label:
                                                      "Strokewidth $strokeWidth",
                                                  onChanged: (double value) {
                                                    Map map = {
                                                      'value': value,
                                                      'roomName':
                                                          dataOfRoom['name']
                                                    };
                                                    _socket.emit(
                                                        'stroke-width', map);
                                                  },
                                                  value: strokeWidth,
                                                  activeColor: selectedColor,
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    _socket.emit('clean-screen',
                                                        dataOfRoom['name']);
                                                  },
                                                  icon: const Icon(
                                                    Icons
                                                        .cleaning_services_rounded,
                                                    color: Colors.white,
                                                  )),
                                            ],
                                          )
                                        : Container(),
                                    dataOfRoom['turn']?['nickname'] !=
                                            widget.data['nickname']
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: textBlankWidget,
                                          )
                                        : Center(
                                            child: Text(dataOfRoom['word'],
                                                style: const TextStyle(
                                                    fontSize: 30,
                                                    color: Colors.white))),
                                    Container(
                                      height: size.height * .3,
                                      child: ListView.builder(
                                        controller: _scrollController,
                                        shrinkWrap: true,
                                        itemCount: messages.length,
                                        itemBuilder: (context, index) {
                                          var msg = messages[index].values;
                                          print(msg.elementAt(0));
                                          return ListTile(
                                            title: Text(
                                              msg.elementAt(0),
                                              style: const TextStyle(
                                                  color: Colors.yellow,
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // const SizedBox(
                                                //   height: 3,
                                                // ),
                                                Text(msg.elementAt(1),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    )),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                SafeArea(
                                    child: IconButton(
                                  icon: const Icon(Icons.menu_rounded,
                                      color: Colors.blue, size: 30),
                                  onPressed: () => {
                                    scaffoldKey.currentState!.openDrawer(),
                                  },
                                )),
                              ],
                            ),
                            dataOfRoom['turn']?['nickname'] !=
                                    widget.data['nickname']
                                ? Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                        width: size.width,
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: TextField(
                                          readOnly: isTextInputReadOnly,
                                          controller: _controller,
                                          autocorrect: false,
                                          textInputAction: TextInputAction.done,
                                          onSubmitted: (value) {
                                            if (value.trim().isNotEmpty) {
                                              Map map = {
                                                'username':
                                                    widget.data['nickname'],
                                                'msg': value.trim(),
                                                'word': dataOfRoom['word'],
                                                'roomName': widget.data['name'],
                                                'guessedUserCtr':
                                                    guessedUserCtr,
                                                'totalTime': 60,
                                                'timeTaken': 60 - _start,
                                              };
                                              _socket.emit('msg', map);
                                              _controller.clear();
                                            }
                                          },
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 14),
                                            filled: true,
                                            fillColor: const Color(0xffF5F5FA),
                                            hintText: "Enter your guess",
                                            hintStyle: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.blue),
                                          ),
                                        )),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    )
                  : LeaderBoard(scoreboard, winner)
              : WaitingLobbyPage(
                  occupancy: dataOfRoom['occupancy'],
                  noOfPlayers: dataOfRoom['players'].length,
                  lobbyName: dataOfRoom['name'],
                  players: dataOfRoom['players'],
                )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 30),
        child: FloatingActionButton(
          onPressed: () {},
          elevation: 7,
          backgroundColor: Colors.white,
          child: Text(
            '$_start',
            style: const TextStyle(fontSize: 22, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
