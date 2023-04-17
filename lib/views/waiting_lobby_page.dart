// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:scribble/constants.dart';

class WaitingLobbyPage extends StatefulWidget {
  final int occupancy;
  final int noOfPlayers;
  final String lobbyName;
  final players;
  const WaitingLobbyPage(
      {Key? key,
      required this.occupancy,
      required this.noOfPlayers,
      required this.lobbyName,
      required this.players})
      : super(key: key);

  @override
  State<WaitingLobbyPage> createState() => _WaitingLobbyPageState();
}

class _WaitingLobbyPageState extends State<WaitingLobbyPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        color: backgroundColor,
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.03,
            ),
            Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Waiting for ${widget.occupancy - widget.noOfPlayers} players to join",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                )),
            SizedBox(
              height: size.height * 0.06,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 55),
              child: Center(
                child: TextField(
                  readOnly: true,
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: widget.lobbyName));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: SizedBox(
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.copy_outlined,
                              weight: 25,
                              color: Colors.blue[800],
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Copied the room name!",
                              style: TextStyle(
                                  color: Colors.blue[800], fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.white.withOpacity(0.75),
                      elevation: 20,
                      margin: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      duration: const Duration(seconds: 2),
                    ));
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.touch_app),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 25),
                    filled: true,
                    fillColor: const Color(0xffF5F5FA),
                    hintText: 'Tap to copy room code!',
                    hintStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.blue),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.1,
            ),
            Text(
              'Players:',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  primary: true,
                  shrinkWrap: true,
                  itemCount: widget.noOfPlayers,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Text("${index + 1}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      title: Text(widget.players[index]['nickname'],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
