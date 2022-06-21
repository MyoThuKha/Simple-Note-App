import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_app/services/base.dart';
import 'package:note_app/services/note_template.dart';
import 'package:note_app/services/time.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map> allNotes = [];
  List<Map> notes = [];
  bool isToday = false;
  String currDay = '';
  Color? searchColor = Colors.white;

  TextEditingController searchController = TextEditingController();

  Future<void> getDate() async {
    currDay = await TimeTemplate().getDate();
  }

  Future<void> getAllNote(orderBy) async {
    allNotes = await NoteTemplate().readAllNote(orderBy);
  }

  OutlineInputBorder searchBar() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: (searchColor)!),
    );
  }

  // Future<void> searchNote(String query) async {
  //   notes = await NoteTemplate().readNote('title', query);
  //   setState(() {
  //     notes = notes;
  //   });
  // }

  void searchNote(String query) {
    final suggestions = allNotes.where((note) {
      final noteTitle = note['title'].toString().toLowerCase();
      final input = query.toLowerCase();

      return noteTitle.contains(input);
    }).toList();
    setState(() => notes = suggestions);
  }

  @override
  void initState() {
    super.initState();
    getAllNote(orderBy);
    searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    getDate();
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: !isDarkMode ? lightAppColor : darkAppColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: MediaQuery.of(context).size.height / 4,
          backgroundColor: !isDarkMode ? lightAppColor : darkAppColor,
          elevation: 0,
          flexibleSpace: Container(
            margin: const EdgeInsets.fromLTRB(15, 40, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Notes",
                        style: TextStyle(
                            color: !isDarkMode ? Colors.black : Colors.white,
                            fontSize: 30,
                            letterSpacing: 1,
                            fontFamily: defaultAppFont),
                      ),
                      SizedBox(
                        height: 35,
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.menu_rounded,
                              color: !isDarkMode ? Colors.black : Colors.white,
                            )),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Material(
                  elevation: 1,
                  borderRadius: BorderRadius.circular(15),
                  child: TextField(
                    controller: searchController,
                    style: TextStyle(fontFamily: defaultAppFont),
                    autocorrect: isAutoCorrect,
                    onChanged: searchNote,
                    decoration: InputDecoration(
                      fillColor: searchColor,
                      filled: true,
                      hintText: "Search Notes",
                      prefixIcon: CustomIcon().searchIcon(),
                      suffixIcon: searchController.text.isEmpty
                          ? const SizedBox(width: 0)
                          : IconButton(
                              onPressed: () => searchController.clear(),
                              icon:
                                  const Icon(Icons.clear, color: Colors.orange),
                            ),
                      enabledBorder: searchBar(),
                      focusedBorder: searchBar(),
                    ),
                    cursorColor: Colors.orange,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: const Divider(height: 1),
                )
              ],
            ),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(12),
          child: (notes.isEmpty)
              ? (!isKeyboard ? noNote('Find Notes') : null) //see at base.dart
              : MasonryGridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 12,
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.pushNamed(context, '/edit', arguments: {
                          'id': notes[index]['id'],
                          'title': notes[index]['title'],
                          'context': notes[index]['context'],
                          'color': notes[index]['color'],
                          'favorite': notes[index]['favorite']
                        });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          color: Color(notes[index]['color']),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                currDay == notes[index]['date']
                                    ? notes[index]['time']
                                    : notes[index]['date'],
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 10),
                              ),
                              const SizedBox(height: 1),
                              notes[index]['title'] == ''
                                  ? const SizedBox()
                                  : AutoSizeText(
                                      notes[index]['title'],
                                      style: TextStyle(
                                          color: Colors.grey[850],
                                          fontSize: 25,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: defaultAppFont),
                                      maxLines: null,
                                    ),
                              const SizedBox(height: 12),
                              AutoSizeText(
                                notes[index]['context'],
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: defaultAppFont),
                                minFontSize: 10,
                                maxFontSize: 14,
                                maxLines: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
