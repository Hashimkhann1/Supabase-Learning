

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddNote extends StatefulWidget {
  AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final titleController = TextEditingController();

  final descriptionController = TextEditingController();
  final _supabase = Supabase.instance.client;
  bool isLoading = false;

  Future<void> addNote() async {
    try{
      setState(() {
        isLoading = true;
      });

      await _supabase.from('notes').insert({
        'title' : titleController.text.toString(),
        'description' : descriptionController.text.toString()
      });

    }catch(error) {
      isLoading = false;
      print("Error while adding note $error");
    }finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
        child: ListView(
          children: [
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Enter Title"
              ),
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                  hintText: "Enter Description"
              ),
            ),
            SizedBox(height: 14,),

            ElevatedButton(onPressed: () {
              addNote();
            }, child: isLoading ? CircularProgressIndicator() : Text("Add Note"))
          ],
        ),
      ),
    );
  }
}
