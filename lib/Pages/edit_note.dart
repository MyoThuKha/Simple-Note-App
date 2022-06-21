import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/services/note_template.dart';
import 'package:note_app/services/color.dart';
import 'package:note_app/services/time.dart';
import 'package:note_app/services/base.dart';

class EditNote extends StatefulWidget {
  const EditNote({Key? key}) : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  Map data = {};
  bool isUpdate = false;
  String titleLog = '';
  String textLog = '';
  int colorCode = 0;
  //I add 2 as init cause 1 for true and 2 for false.
  bool clickSliderButton = false;
  int isFav = 2;
  String date = '';
  String time = '';

  late TextEditingController titleEditor;
  late TextEditingController contextEditor;

  Future<void> getDateTime() async {
    date = await TimeTemplate().getDate();
    time = await TimeTemplate().getTime();
  }

  Future<void> create(argTitle, argContext, int argColor) async {
    await getDateTime();
    await NoteTemplate().create(argTitle, argContext, argColor, date, time);
  }

  Future<void> deleteData(int id) async {
    await NoteTemplate().delete(id);
    goBack();
  }

  Future<void> updateData(int argId, String argTitle, String argText,
      int argColorCode, argFav) async {
    await getDateTime();
    //data['id'], titleEditor.text, contextEditor.text, colorValue
    await NoteTemplate()
        .update(argId, argTitle, argText, argColorCode, argFav, date, time);
  }

  void goBack() {
    Navigator.pop(context);
  }

  void onDiscard() {
    goBack();
    goBack();
  }

  Future<void> onSaveExit() async {
    setState(() {
      titleLog = titleEditor.text;
      textLog = contextEditor.text;
      isUpdate = true;
    });
    await updateData(data['id'], titleLog, textLog, colorCode, isFav);
    goBack();
    goBack();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    titleEditor.dispose();
    contextEditor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty
        ? data
        : ModalRoute.of(context)?.settings.arguments as Map;
    //
    isFav = isFav == 2 ? data['favorite'] : isFav;
    colorCode = (colorCode == 0) ? data['color'] : colorCode;
    titleEditor = TextEditingController(
        text: isUpdate || clickSliderButton ? titleEditor.text : data['title']);
    contextEditor = TextEditingController(
        text: isUpdate || clickSliderButton
            ? contextEditor.text
            : data['context']);

    titleLog = (titleLog == '') ? data['title'] : titleLog;
    textLog = (textLog == '') ? data['context'] : textLog;
    return Scaffold(
      backgroundColor: Color(colorCode),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Edit Note',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 1,
              fontFamily: defaultAppFont),
        ),
        centerTitle: true,
        backgroundColor: Color(colorCode),
        elevation: 1,
        //App Bar Buttons
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () async {
            (titleEditor.text == titleLog && contextEditor.text == textLog)
                ? goBack()
                : saveAlert(context,
                    onDiscard: onDiscard, onSaveExit: onSaveExit);
            //save before exit
          },
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              //Slider

              //Need to go back twice for closing slider.
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
                                deleteAlert(context,
                                    id: data['id'],
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
                                await create(titleEditor.text,
                                    contextEditor.text, colorCode);
                                setState(() {
                                  clickSliderButton = true;
                                });
                                goBack();
                                goBack();

                                ScaffoldMessenger.of(context).showSnackBar(
                                    CustomNoti().slideNotiBar('Duplicated',
                                        Colors.white, const Icon(Icons.copy)));
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: isFav == 1
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
                              onPressed: () async {
                                setState(() {
                                  isFav = (isFav == 0) ? 1 : 0;
                                  clickSliderButton = true;
                                });
                                await updateData(data['id'], titleLog, textLog,
                                    colorCode, isFav);
                                //Close slider
                                goBack();

                                ScaffoldMessenger.of(context).showSnackBar(
                                    CustomNoti().notiBar(
                                        isFav == 1
                                            ? 'Added to Favorite'
                                            : 'Remove from Favorite',
                                        Icon(Icons.favorite_rounded,
                                            color: isFav == 1
                                                ? Colors.red
                                                : Colors.grey[400])));
                              },
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
                                  //for input log
                                  titleLog = titleEditor.text;
                                  textLog = contextEditor.text;
                                });
                                await updateData(data['id'], titleLog, textLog,
                                    colorCode, isFav);
                                setState(() {
                                  isUpdate = true;
                                });

                                //close slider
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
                                        await updateData(data['id'], titleLog,
                                            textLog, colorCode, isFav);
                                      },
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
                  ),
                ),
              );
            },
            icon: const Icon(Icons.more_vert),
          ),
          //Slider
        ],
      ),

      //Body part
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        child: SingleChildScrollView(
          //reverse: true,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              TextField(
                controller: titleEditor,
                autocorrect: isAutoCorrect,
                maxLines: 1,
                decoration: InputDecoration(
                  hintStyle: TextStyle(fontFamily: defaultAppFont),
                  border: InputBorder.none,
                  hintText: 'Title',
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
                controller: contextEditor,
                autocorrect: isAutoCorrect,
                autofocus: false,
                decoration: InputDecoration(
                    hintStyle: TextStyle(fontFamily: defaultAppFont),
                    border: InputBorder.none,
                    hintText: 'Context'),
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
