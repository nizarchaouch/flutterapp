
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/database/database_handler.dart';
import 'package:flutterapp/models/note_model.dart';
import 'package:flutterapp/screens/create_note_page.dart';
import 'package:flutterapp/screens/edit_note_page.dart';
import 'package:flutterapp/screens/login_screen.dart';
import 'package:flutterapp/widgets/button_widget.dart';
import 'package:flutterapp/widgets/dialog_box_widget.dart';
import 'package:flutterapp/widgets/single_note_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Notes",
          style: TextStyle(fontSize: 40),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              children: [
                const ButtonWidget(icon: Icons.search),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await signOut();
                  },
                  child: const Icon(Icons.logout),
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 235, 235, 235),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CreateNotePage()));
          },
          child: const Icon(
            Icons.add,
            size: 30,
            color: Colors.black38,
          ),
        ),
      ),
      body: StreamBuilder<List<NoteModel>>(
          stream: DatabaseHandler.getNotes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Image.asset(
                  "assets/ios_loading.gif",
                  width: 50,
                  height: 50,
                ),
              );
            }
            if (snapshot.hasData == false) {
              return _noNotesWidget();
            }
            if (snapshot.data!.isEmpty) {
              return _noNotesWidget();
            }
            if (snapshot.hasData) {
              final notes = snapshot.data;
              return ListView.builder(
                itemCount: notes!.length,
                itemBuilder: (context, index) {
                  return SingleNoteWidget(
                    title: notes[index].title,
                    body: notes[index].body,
                    color: notes[index].color,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EditNotePage(
                                    noteModel: notes[index],
                                  )));
                    },
                    onLongPress: () {
                      showDialogBoxWidget(
                        context,
                        height: 250,
                        title: "Are you sure you want\nto delete this note ?",
                        onTapYes: () {
                          DatabaseHandler.deleteNote(notes[index].id!);
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
              );
            }
            return Center(
              child: Image.asset(
                "assets/ios_loading.gif",
                width: 50,
                height: 50,
              ),
            );
          }),
    );
  }

  _noNotesWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: 200,
              height: 200,
              child: Image.asset("assets/add_notes_image.png")),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "Create Colorful Notes",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
