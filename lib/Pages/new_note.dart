import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/services/base.dart';
import 'package:note_app/services/note_template.dart';
import 'package:note_app/services/color.dart';
import 'package:note_app/services/time.dart';

class NewNote extends StatefulWidget {
  const NewNote({Key? key}) : super(key: key);

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  String titleLog = '';
  String textLog = '';
  bool isCreated = false;
  bool clickSliderButton = false;
  int currId = 0;
  int colorCode = 0;
  bool isFav = false;
  String date = '';
  String time = '';

  Icon favoriteIcon = const Icon(Icons.star_outline_rounded);

  late TextEditingController titleControl;
  late TextEditingController textControl;

  @override
  void dispose() {
    titleControl.dispose();
    textControl.dispose();
    super.dispose();
  }

  Future<void> create(argTitle, argContext, int argColor) async {
    await getDateTime();
    currId =
        await NoteTemplate().create(argTitle, argContext, argColor, date, time);
    setState(() {
      currId = currId;
    });
  }

  void goBack() {
    Navigator.pop(context);
  }

  Future<void> deleteData(int id) async {
    await NoteTemplate().delete(id);
    goBack();
  }

  Future<void> updateData(
      int id, String title, String text, int colorValue, bool argFav) async {
    await getDateTime();
    int value = argFav ? 1 : 0;
    await NoteTemplate().update(id, title, text, colorValue, value, date, time);
  }

  Future<void> getDateTime() async {
    date = await TimeTemplate().getDate();
    time = await TimeTemplate().getTime();
  }

  void onDiscard() {
    goBack();
    goBack();
  }

  Future<void> onSaveExit() async {
    setState(() {
      titleLog = titleControl.text;
      textLog = textControl.text;
    });

    isCreated
        ? await updateData(currId, titleLog, textLog, colorCode, isFav)
        : await create(titleLog, textLog, colorCode);

    setState(() {
      isCreated = true;
    });

    goBack();
    goBack();
  }

  @override
  Widget build(BuildContext context) {
    colorCode = (colorCode == 0) ? 0xffffffff : colorCode;

    titleControl = TextEditingController(
        text: (clickSliderButton) ? titleControl.text : '');
    textControl = TextEditingController(
        text: (clickSliderButton) ? textControl.text : '');

    return Scaffold(
      backgroundColor: Color(colorCode),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'New Note',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
            fontFamily: defaultAppFont,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(colorCode),
        elevation: 1.0,
        leading: IconButton(
          onPressed: () {
            (titleControl.text == titleLog && textControl.text == textLog)
                ? goBack()
                : saveAlert(context,
                    onDiscard: onDiscard, onSaveExit: onSaveExit);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              //Slider
              showModalBottomSheet(
                backgroundColor: !isDarkMode ? lightAppColor : darkAppColor,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15))),
                context: context,
                builder: (context) => Container(
                  padding: const EdgeInsets.all(8.0),
                  height: MediaQuery.of(context).size.height / 4,
                  //color: !isDarkMode ? lightAppColor : darkAppColor,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: Icon(
                                CupertinoIcons.delete,
                                size: 23,
                                color: !isDarkMode
                                    ? const IconThemeData().color
                                    : Colors.white,
                              ),
                              onPressed: () async {
                                goBack();
                                await deleteAlert(context,
                                    id: currId,
                                    displayText: "Delete this note?",
                                    goMenu: true);
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: Icon(
                                Icons.copy,
                                color: !isDarkMode
                                    ? const IconThemeData().color
                                    : Colors.white,
                              ),
                              onPressed: () async {
                                await create(titleControl.text,
                                    textControl.text, colorCode);
                                goBack();
                                goBack();

                                ScaffoldMessenger.of(context).showSnackBar(
                                    CustomNoti().slideNotiBar("Duplicated",
                                        Colors.white, const Icon(Icons.copy)));
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              onPressed: () async {
                                setState(() {
                                  clickSliderButton = true;
                                  isFav = !isFav;
                                });

                                await updateData(currId, titleLog, textLog,
                                    colorCode, isFav);

                                goBack();

                                //Favorite Noti

                                ScaffoldMessenger.of(context).showSnackBar(
                                    CustomNoti().notiBar(
                                        isFav
                                            ? 'Added to Favorite'
                                            : 'Remove from Favorite',
                                        Icon(Icons.favorite_rounded,
                                            color: isFav
                                                ? Colors.red
                                                : Colors.grey[400])));
                              },
                              icon: isFav
                                  ? Icon(
                                      Icons.star_outlined,
                                      color: Colors.yellow[600],
                                    )
                                  : Icon(
                                      Icons.star_outline_rounded,
                                      color: !isDarkMode
                                          ? const IconThemeData().color
                                          : Colors.white,
                                    ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: Icon(
                                Icons.check,
                                color: !isDarkMode
                                    ? const IconThemeData().color
                                    : Colors.white,
                              ),
                              onPressed: () async {
                                setState(() {
                                  titleLog = titleControl.text;
                                  textLog = textControl.text;
                                  clickSliderButton = true;
                                });
                                if (!isCreated) {
                                  await create(titleLog, textLog, colorCode);
                                  setState(() {
                                    isCreated = true;
                                  });
                                } else {
                                  await updateData(currId, titleLog, textLog,
                                      colorCode, isFav);
                                }
                                goBack();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(CustomNoti().notiBar(
                                        'Saved',
                                        const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        )));
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),
                      //Custom Widget from color.dart
                      SizedBox(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(colorList.length, (index) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          colorCode = colorList[index].value;
                                          clickSliderButton = true;
                                        });
                                        await updateData(currId, titleLog,
                                            textLog, colorCode, isFav);
                                      },
                                      //See at color.dart
                                      child: colorSlider(index),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                    //actions bar
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
          //Slider
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        child: SingleChildScrollView(
          //reverse: true,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              TextField(
                controller: titleControl,
                autocorrect: isAutoCorrect,
                maxLines: 1,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title',
                  hintStyle: TextStyle(fontFamily: defaultAppFont),
                ),
                autofocus: false,
                cursorColor: Colors.black,
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 1,
                  fontSize: 30,
                  fontFamily: defaultAppFont,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: textControl,
                autocorrect: isAutoCorrect,
                autofocus: false,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Context',
                    hintStyle: TextStyle(
                      fontFamily: defaultAppFont,
                    )),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                cursorColor: Colors.black,
                cursorHeight: 25,
                style: TextStyle(fontSize: 18, fontFamily: defaultAppFont),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
