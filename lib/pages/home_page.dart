import 'package:flutter/material.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/pages/add_note_page.dart';
import 'package:notes_app/services/note_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  Future<void> _refreshNotes() async {
    final data = await NoteService.getNotes();
    setState(() {
      notes = data;
    });
  }

  void _deleteNote(Note note) async {
    await NoteService.deleteNote(note);
    _refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    List<Note> sortedNotes = List.from(notes)..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return Scaffold(
      backgroundColor: Color(0xfff9fafb),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color (0xff6a7282),
                    width: 1.0,
                  )
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Catatan",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    "${notes.length} catatan",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff6a7282),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: notes.isNotEmpty ? ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(20),
                  itemBuilder: (content, index) {
                    int reversedIndex = sortedNotes.length - index - 1;
                    final note = sortedNotes[index];

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Color(0xff6a7282),
                          width: 1.0,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.only(top: 8, right: 4, bottom: 8, left: 16),
                        title: Text(
                          note.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4,),
                            Text(
                              note.content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xff6a7282),
                              ),
                            ),
                            SizedBox(height: 8,),
                            Text(
                              "${note.updatedAt.day}/${note.updatedAt.month}/${note.updatedAt.year}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xff6a7282),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Colors.white,
                          icon: Icon(
                            Icons.more_vert,
                            color: Color(0xff6a7282),
                          ),
                          onSelected: (value) {
                            if (value == 'edit') {

                            } else if (value == 'delete') {
                              _deleteNote(note);
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem<String>(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit_outlined,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                    SizedBox(width: 8,),
                                    Text(
                                      'Edit',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                )
                            ),
                            PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete_outline,
                                      size: 20,
                                      color: Color(0xfffb2c36),
                                    ),
                                    SizedBox(width: 8,),
                                    Text(
                                      'Hapus',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xfffb2c36),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 16,),
                  itemCount: sortedNotes.length
              ) : Text(""),
            )
          ],
        )
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 16, right: 16),
        child: FloatingActionButton(
          onPressed: () async {
            final bool? isSaved = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddNotePage()),
            );

            if (isSaved == true) {
              _refreshNotes();
            }
          },
          backgroundColor: Color(0xff2b7fff),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
