
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutterapp/database/database_handler.dart';
import 'package:flutterapp/models/note_model.dart';
import 'package:flutterapp/utils/utility.dart';
import 'package:flutterapp/widgets/button_widget.dart';
import 'package:flutterapp/widgets/form_widget.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({Key? key}) : super(key: key);

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  bool _isNoteCreating = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isNoteCreating == true
          ? Colors.grey[700]
          : const Color.fromARGB(255, 245, 244, 244),
      body: AbsorbPointer(
        absorbing: _isNoteCreating,
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              _isNoteCreating == true
                  ? Image.asset(
                      "assets/ios_loading.gif",
                      width: 50,
                      height: 50,
                    )
                  : Container(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 50),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonWidget(
                          icon: Icons.arrow_back,
                          onTap: () => Navigator.pop(context),
                        ),
                        ButtonWidget(icon: Icons.done, onTap: _createNote),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    FormWidget(
                      fontSize: 40,
                      controller: _titleController,
                      hintText: "Title",
                    ),
                    const SizedBox(height: 10),
                    FormWidget(
                      maxLines: 15,
                      fontSize: 20,
                      controller: _bodyController,
                      hintText: "Start typing...",
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _createNote() {
    setState(() => _isNoteCreating = true);
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      if (_titleController.text.isEmpty) {
        toast(message: 'Type something in the title');
        setState(() => _isNoteCreating = false);
        return;
      }
      if (_bodyController.text.isEmpty) {
        toast(message: 'Type something in the body');
        setState(() => _isNoteCreating = false);
        return;
      }

      final randomColor = predefinedColors.isNotEmpty
        ? predefinedColors[Random().nextInt(predefinedColors.length)]
        : Color(Random().nextInt(0xFFFFFFFF) | 0xFF000000);

      DatabaseHandler.createNote(NoteModel(
              title: _titleController.text,
              body: _bodyController.text,
              color: randomColor.value))
          .then((value) {
        _isNoteCreating = false;
        Navigator.pop(context);
      });
    });
  }
}
