import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:superbase_learning/view/add_note/add_note.dart';
import 'package:superbase_learning/view/add_note/update_note_view/update_note_view.dart';
import 'package:superbase_learning/view_model/auth_view_model/auth_view_model.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _supabase = Supabase.instance.client;

  List<Map<String, dynamic>> notes = [];
  bool isLoading = false;

  Future<void> getNotes() async {
    try {
      isLoading = true;

      // notes = await _supabase.from('notes').select();

      _supabase.from('notes').stream(primaryKey: ['id']).listen((data) {
       setState(() {
         notes = data;
       });
      });

    } catch (error) {
      print("Error while getting notes $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _supabase.auth.currentUser!.userMetadata!['name'].toString(),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () {
                  AuthViewModel().signOut(context);
                },
                child: Text("Log out"),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _supabase.from('notes').stream(primaryKey: ['id']),
        builder: (context, snapshot) {

          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: notes.length,
              itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateNoteView(noteData: notes[index])));
                },
                title: Text(notes[index]['title']),
                subtitle: Text(notes[index]['description']),
                trailing: IconButton(
                    onPressed: () async {
                      await _supabase.from('notes').delete().eq('id', notes[index]['id']);
                      setState(() {});
                    },
                    icon: Icon(Icons.delete_forever)),
              );
              });
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNote()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
