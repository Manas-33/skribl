import 'package:flutter/material.dart';
import 'package:scribble/views/create_room_page.dart';
import 'package:scribble/views/join_room_page.dart';
import 'package:scribble/views/widgets/custom_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50.0),
            const Text(
              'Create/Join a room to play!',
              style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomButton(
                    text: "Create",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateRoomPage()));
                    },
                    icon: Icons.group_add,
                    factor: 2.5),
                const SizedBox(width: 20),
                CustomButton(
                    text: "Join",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JoinRoomPage()));
                    },
                    icon: Icons.group,
                    factor: 2.5),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
