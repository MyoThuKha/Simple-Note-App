import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:note_app/services/base.dart';
import 'package:note_app/services/note_template.dart';
import 'package:note_app/services/time.dart';
import 'package:advanced_icon/advanced_icon.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map> notes = [];
  bool isLoading = false;

  bool isFavorite = false;
  bool isToday = false;

  String currDay = '';

  @override
  void initState() {
    super.initState();
    refresh(false, false);
  }

  @override
  void dispose() {
    NoteTemplate().close();
    super.dispose();
  }

  Future<void> getDate() async {
    currDay = await TimeTemplate().getDate();
  }

  Future<void> refresh(bool isFavorite, bool isTodayNote) async {
    getDate();
    setState(() {
      isLoading = true;
    });

    if (isFavorite) {
      notes = await NoteTemplate().readNote('favorite', 1, orderBy);
    } else if (isTodayNote) {
      notes = await NoteTemplate().readNote('date', currDay, orderBy);
    } else {
      notes = await NoteTemplate().readAllNote(orderBy);
    }
    /*
    notes = isFavorite
        ? await NoteTemplate().readNote('favorite', 1)
        : await NoteTemplate().readAllNote();
    */
    setState(() {
      notes = notes;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    //notes = [];
    return Scaffold(
      backgroundColor: !isDarkMode ? Colors.white : darkAppBar,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        title: Text(
          isToday
              ? "Today Notes"
              : isFavorite
                  ? "Favorite Notes"
                  : "Notes",
          style: TextStyle(
              color: !isDarkMode ? Colors.black : Colors.white,
              fontSize: 24,
              letterSpacing: 1,
              fontFamily: defaultAppFont,
              fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: !isDarkMode ? Colors.white : darkAppBar,
        elevation: 0.5,

        //AppBar actions button
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              dynamic result = await Navigator.pushNamed(context, '/menu');
              setState(() {
                isFavorite = (result == null) ? isFavorite : result['favorite'];
                isToday = (result == null) ? isToday : result['today'];
              });
              refresh(isFavorite, isToday);
            },
            icon: const Icon(Icons.menu_rounded),
            color: isDarkMode ? Colors.white : darkAppBar,
          )
        ],
      ),
      body: isLoading
          ? SpinKitFadingCube(
              color: Colors.blue[300],
              size: 50,
            )
          : ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(0)),
              child: Container(
                color: !isDarkMode ? lightAppColor : darkAppColor,
                //padding: const EdgeInsets.only(top: 12),
                //margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: (notes.isEmpty)
                    ? (!isKeyboard
                        ? noNote('No Notes')
                        : null) //see at common.dart
                    : Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Container(
                          margin: const EdgeInsets.only(top: 0),
                          child: MasonryGridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            //mainAxisSpacing: 12,
                            itemCount: notes.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(top: 12),
                                child: GestureDetector(
                                  onTap: () async {
                                    await Navigator.pushNamed(context, '/edit',
                                        arguments: {
                                          'id': notes[index]['id'],
                                          'title': notes[index]['title'],
                                          'context': notes[index]['context'],
                                          'color': notes[index]['color'],
                                          'favorite': notes[index]['favorite']
                                        });

                                    refresh(isFavorite, isToday);
                                  },
                                  child: Material(
                                    borderRadius: BorderRadius.circular(10),
                                    elevation: 0.5,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        padding: const EdgeInsets.all(15.0),
                                        color: Color(notes[index]['color']),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            //time
                                            Text(
                                              currDay == notes[index]['date']
                                                  ? notes[index]['time']
                                                  : notes[index]['date'],
                                              style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 10),
                                            ),
                                            const SizedBox(height: 1),
                                            //title
                                            notes[index]['title'] == ''
                                                ? const SizedBox()
                                                : AutoSizeText(
                                                    notes[index]['title'],
                                                    style: TextStyle(
                                                        color: Colors.grey[850],
                                                        fontSize: 25,
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily:
                                                            defaultAppFont),
                                                    maxLines: null,
                                                  ),
                                            const SizedBox(height: 12),

                                            //text
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
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/new');
          refresh(isFavorite, isToday);
        },
        child: const AdvancedIcon(
          icon: Icons.add,
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.yellow, Colors.orange]),
          //color: Colors.orange[400],
          size: 30,
        ),
        backgroundColor: Colors.white,
        elevation: 5,
      ),
    );
  }
}
