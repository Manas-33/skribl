import 'package:flutter/material.dart';

class LeaderBoard extends StatelessWidget {
  final scoreboard;
  final String winner;
  LeaderBoard(this.scoreboard, this.winner);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8),
        height: double.maxFinite,
        child: Column(
          children: [
            ListView.builder(
                primary: true,
                shrinkWrap: true,
                itemCount: scoreboard.length,
                itemBuilder: (context, index) {
                  var data = scoreboard[index].values;
                  return ListTile(
                    title: Text(data.elementAt(0),
                        style: TextStyle(color: Colors.white, fontSize: 23)),
                    trailing: Text(data.elementAt(1),
                        style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  );
                }),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Text("$winner has won the game!",
                    style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 27,
                        fontWeight: FontWeight.w700)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
