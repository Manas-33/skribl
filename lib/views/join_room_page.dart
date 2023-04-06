import 'package:flutter/material.dart';
import 'package:scribble/views/paint_page.dart';
import 'package:scribble/views/widgets/custom_button.dart';
import 'package:scribble/views/widgets/custom_text_field.dart';

import '../constants.dart';

class JoinRoomPage extends StatefulWidget {
  JoinRoomPage({super.key});

  @override
  State<JoinRoomPage> createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> {
  TextEditingController _nameController = TextEditingController();

  TextEditingController _roomNameController = TextEditingController();

  void joinRoom() {
    if (_nameController.text.isNotEmpty &&
        _roomNameController.text.isNotEmpty) {
      Map<String,String> data = {
        "nickname": _nameController.text,
        "name": _roomNameController.text,
      };
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PaintPage(data: data, screenFrom: "joinRoom")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        leading: Row(
          children: [
            BackButton(
              color: secondaryColor,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Join',
                style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 25,
              ),
              CustomTextField(
                  controller: _nameController, hintText: "Enter Your Name"),
              const SizedBox(
                height: 15,
              ),
              CustomTextField(
                  controller: _roomNameController, hintText: "Enter Room Name"),
              const SizedBox(
                height: 15,
              ),
              CustomButton(
                  text: "Join",
                  onTap: joinRoom,
                  icon: Icons.person_add,
                  factor: 2),
            ],
          ),
        ),
      ),
    );
  }
}
