import 'package:flutter/material.dart';
import 'package:flutterapp/database/database_handler.dart';
import 'package:flutterapp/models/note_model.dart';
import 'package:flutterapp/utils/utility.dart';
import 'package:flutterapp/widgets/button_widget.dart';
import 'package:flutterapp/widgets/dialog_box_widget.dart';
import 'package:flutterapp/widgets/form_widget.dart';


class EditNotePage extends StatefulWidget {
  final NoteModel noteModel;
  const EditNotePage({Key? key, required this.noteModel}) : super(key: key);

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  TextEditingController? _titleController;
  TextEditingController? _bodyController;
  int? selectedColor ;

  bool _isNoteEditing = false;


  @override
  void initState() {
    _titleController = TextEditingController(text: widget.noteModel.title);
    _bodyController = TextEditingController(text: widget.noteModel.body);
    selectedColor = widget.noteModel.color!;
    super.initState();
  }

  @override
  void dispose() {
    _titleController!.dispose();
    _bodyController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isNoteEditing == true? Colors.grey[700]
          : const Color.fromARGB(255, 245, 244, 244),
      body: AbsorbPointer(
        absorbing: _isNoteEditing,
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              _isNoteEditing == true ? Image.asset("assets/ios_loading.gif", width: 50, height: 50,) : Container(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 50),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonWidget(
                          icon: Icons.arrow_back,
                          onTap: () => Navigator.pop(context),
                        ),
                        ButtonWidget(icon: Icons.save_outlined, onTap: () {
                          showDialogBoxWidget(
                            context,
                            height: 200,
                            title: "Save Changes ?",
                            onTapYes: () {
                              _editNote();
                              Navigator.pop(context);
                            },
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 30,),
                    FormWidget(
                      fontSize: 40,
                      controller: _titleController!,
                      hintText: "Title",
                    ),
                    const SizedBox(height: 10),
                    FormWidget(
                      maxLines: 15,
                      fontSize: 20,
                      controller: _bodyController!,
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

  _editNote() {
    setState(() => _isNoteEditing = true);
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      if(_titleController!.text.isEmpty) {
        toast(message: 'Type something in the Title');
        setState(() => _isNoteEditing = false);
        return;
      }
      if(_bodyController!.text.isEmpty) {
        toast(message: 'Type something in the body');
        setState(() => _isNoteEditing = false);
        return;
      }
      
      DatabaseHandler.updateNote(NoteModel(
        id: widget.noteModel.id,
          title: _titleController!.text,
          body: _bodyController!.text,
          color: selectedColor
      )).then((value) {
        _isNoteEditing = false;
        Navigator.pop(context);
      });
    });
  }
}
