import 'package:flutter/material.dart';
import 'package:scribble/views/widgets/custom_button.dart';
import 'package:scribble/views/widgets/custom_text_field.dart';

import '../constants.dart';

class CreateRoomPage extends StatefulWidget {
  CreateRoomPage({super.key});

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  TextEditingController _nameController = TextEditingController();

  TextEditingController _roomNameController = TextEditingController();

  int _selectedPlayerCount = 4;
  int _roundsCount = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        leading: Row(
          children: [
            const SizedBox(
              width: 15,
            ),
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Create',
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
                controller: _roomNameController,
                hintText: "Enter your Room Name"),
            const SizedBox(
              height: 15,
            ),
            DropdownButtonFormField<int>(
              items:
                  <int>[2, 3, 4, 5, 6].map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text("$value"),
                );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  _selectedPlayerCount = newValue!;
                });
              },
              value: _selectedPlayerCount,
            ),
            DropdownButtonFormField<int>(
              items: <int>[1, 2, 3, 4, 5, 6, 7, 8]
                  .map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text("$value"),
                );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  _roundsCount = newValue!;
                });
              },
              value: _roundsCount,
            ),
            CustomButton(
                text: "Create", onTap: () {}, icon: Icons.add, factor: 2),
          ],
        ),
      ),
    );
  }
}
