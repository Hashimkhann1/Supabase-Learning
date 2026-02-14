

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateNoteView extends StatefulWidget {
  UpdateNoteView({super.key,required this.noteData});
  final Map<String, dynamic> noteData;

  @override
  State<UpdateNoteView> createState() => _UpdateNoteViewState();
}

class _UpdateNoteViewState extends State<UpdateNoteView> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final _supabase = Supabase.instance.client;
  bool isLoading = false;

  Future<void> updateNote() async {
    try{
      setState(() {
        isLoading = true;
      });

      await _supabase.from('notes').update({
        'title' : titleController.text.toString(),
        'description' : descriptionController.text.toString()
      }).eq('id', widget.noteData['id']);

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
  void initState() {
    titleController.text = widget.noteData['title'];
    descriptionController.text = widget.noteData['description'];
    super.initState();
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
              updateNote();
            }, child: isLoading ? CircularProgressIndicator() : Text("Update Note"))
          ],
        ),
      ),
    );
  }
}
