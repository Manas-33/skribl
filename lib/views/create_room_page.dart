import 'package:flutter/material.dart';
import 'package:scribble/views/paint_page.dart';
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

  String? _selectedPlayerCount;
  String? _roundsCount;

  void createRoom() {
    if (_nameController.text.isNotEmpty &&
        _roomNameController.text.isNotEmpty &&
        _roundsCount != null &&
        _selectedPlayerCount != null) {
      Map<String,String> data = {
        "nickname": _nameController.text,
        "name": _roomNameController.text,
        "occupancy": _selectedPlayerCount!,
        "maxRounds": _roundsCount!
      };
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              PaintPage(data: data, screenFrom: 'createRoom')));
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
                height: 20,
              ),
              CustomTextField(
                  controller: _roomNameController,
                  hintText: "Enter your Room Name"),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    filled: true,
                    fillColor: const Color(0xffF5F5FA),
                    hintText: "Select Room Size",
                    hintStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.blue),
                  ),
                  dropdownColor: Colors.white,
                  items: <String>['2', '3', '4', '5', '6']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPlayerCount = newValue;
                    });
                  },
                  value: _selectedPlayerCount,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    filled: true,
                    fillColor: const Color(0xffF5F5FA),
                    hintText: "Select Max Rounds",
                    hintStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.blue),
                  ),
                  dropdownColor: Colors.white,
                  items: <String>['1', '2', '3', '4', '5', '6', '7', '8']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _roundsCount = newValue!;
                    });
                  },
                  value: _roundsCount,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              CustomButton(
                  text: "Create",
                  onTap: createRoom,
                  icon: Icons.add,
                  factor: 2),
            ],
          ),
        ),
      ),
    );
  }
}
