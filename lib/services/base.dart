import 'package:advanced_icon/advanced_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/services/note_template.dart';
import 'package:note_app/services/persist_data.dart';

String chooseFont = "Roboto";
Color? lightAppColor = Colors.grey[200];
//Color? darkAppColor = const Color.fromARGB(255, 31, 29, 44);
Color? darkAppColor = Colors.grey[850];
Color? darkAppBar = Colors.grey[800];

bool isDarkMode = UserPrefs.getTheme() ?? false;
bool isAutoCorrect = UserPrefs.getAuto() ?? false;
String orderBy = UserPrefs.getSort() ?? 'ASC';
String defaultAppFont = UserPrefs.getFont() ?? "Roboto";

int selectedValue = UserPrefs.getIndex() ?? 0;

bool isASC = false;

bool isFavorite = false;
bool isToday = false;
List<String> fonts = [
  'Roboto',
  'Abel',
  'Lobster',
  'NotoSerif',
  'Rubik',
  'ShadowsIntoLight',
  'SourceCodePro',
];
Widget noNote(String displayText) {
  return Container(
    margin: const EdgeInsets.only(bottom: 56),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        /*Center(
          child: Image.asset(
            'assets/Images/iceCoffee.png',
            scale: 12,
          ),
        ),*/
        Center(
          child: Material(
            borderRadius: BorderRadius.circular(20),
            elevation: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: Colors.white,
                width: 150,
                height: 150,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 5),
                    CustomIcon().pinIcon(),
                    const SizedBox(height: 35),
                    Text(
                      displayText,
                      style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 1,
                          //fontWeight: FontWeight.w600,
                          fontFamily: defaultAppFont),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    ),
  );
}

class FontAlert extends StatefulWidget {
  const FontAlert({Key? key}) : super(key: key);

  @override
  State<FontAlert> createState() => _FontAlertState();
}

class _FontAlertState extends State<FontAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: !isDarkMode ? Colors.white : darkAppColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Column(
        children: <Widget>[
          Text(
            "Choose Font",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
              fontFamily: chooseFont,
            ),
          ),
          Divider(color: !isDarkMode ? Colors.grey[500] : Colors.white),
        ],
      ),
      content: SizedBox(
        height: 200,
        child: ListView.builder(
            itemCount: fonts.length,
            itemBuilder: (BuildContext context, int index) {
              return RadioListTile<int>(
                activeColor: !isDarkMode ? Colors.green : Colors.amber,
                value: index,
                title: Text(
                  fonts[index] == 'Roboto' ? 'Default' : fonts[index],
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                groupValue: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = index;
                    chooseFont = fonts[index];
                  });
                },
              );
            }),
      ),
      actions: <Widget>[
        const Divider(),
        Row(
          children: <Widget>[
            Expanded(
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  )),
            ),
            Expanded(
              child: TextButton(
                  onPressed: () async {
                    await UserPrefs.setFont(chooseFont);
                    await UserPrefs.setIndex(selectedValue);
                    setState(() {
                      defaultAppFont = chooseFont;
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  )),
            ),
          ],
        )
      ],
    );
  }
}

//Department of Notifications
class CustomNoti {
  SnackBar notiBar(String whatNoti, Widget leading) {
    return SnackBar(
      duration: const Duration(milliseconds: 800),
      content: Row(
        children: <Widget>[
          leading,
          const SizedBox(width: 20),
          Text(
            whatNoti,
            style: TextStyle(
                letterSpacing: 1,
                color: Colors.grey[800],
                fontSize: 15,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
      elevation: 5,
    );
  }

  SnackBar slideNotiBar(String whatNoti, Color? whatColor, Widget leading) {
    return SnackBar(
      duration: const Duration(milliseconds: 1000),
      content: Row(
        children: <Widget>[
          leading,
          const SizedBox(width: 20),
          Text(
            whatNoti,
            style: TextStyle(
                letterSpacing: 1,
                color: Colors.grey[700],
                fontSize: 15,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
      backgroundColor: whatColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      elevation: 5,
    );
  }
}

Future<void> deleteAlert(context,
    {required dynamic id,
    required String displayText,
    required bool goMenu}) async {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: !isDarkMode ? Colors.white : darkAppColor,
          title: Column(
            children: <Widget>[
              Text(
                displayText,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black),
              ),
              Divider(
                height: 20,
                color: !isDarkMode ? Colors.grey[500] : Colors.white,
              )
            ],
          ),
          //content: Divider(height: 20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          actions: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? Colors.white : Colors.black),
                      )),
                ),
                Expanded(
                  child: TextButton(
                      onPressed: () async {
                        try {
                          id == "All"
                              ? await NoteTemplate().deleteAll()
                              : await NoteTemplate().delete(id);
                          //goBack once cause deleteData has goBack function.
                        } catch (e) {
                          //Do nothing.
                        }
                        if (goMenu) {
                          Navigator.pop(context);
                        }

                        Navigator.pop(context);
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? Colors.white : Colors.black),
                      )),
                ),
              ],
            )
          ],
        );
      });
}

Future<void> saveAlert(context,
    {required VoidCallback onDiscard,
    required Future<void> Function() onSaveExit}) async {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: !isDarkMode ? Colors.white : darkAppColor,
          title: Column(
            children: <Widget>[
              Text(
                'Save before exit?',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black),
              ),
              Divider(
                height: 20,
                color: !isDarkMode ? Colors.grey[500] : Colors.white,
              )
            ],
          ),
          //content: Divider(height: 20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          actions: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                      onPressed: () {
                        onDiscard();
                      },
                      child: Text(
                        'Discard',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? Colors.white : Colors.black),
                      )),
                ),
                Expanded(
                  child: TextButton(
                      onPressed: () async {
                        // //og
                        // setState(() {
                        //   titleLog = titleEditor.text;
                        //   textLog = contextEditor.text;
                        //   isUpdate = true;
                        // });
                        // await updateData(
                        //     data['id'], titleLog, textLog, colorCode, isFav);
                        // goBack();
                        // goBack();
                        await onSaveExit();
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? Colors.white : Colors.black),
                      )),
                ),
              ],
            )
          ],
        );
      });
}

Widget contactMe() {
  return AlertDialog(
    backgroundColor: !isDarkMode ? lightAppColor : darkAppColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    title: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Text(
                "Contact Me",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black),
              ),
            ),
            const SizedBox(width: 5),
            CustomIcon().explanIcon(),
          ],
        ),
        Divider(
          height: 20,
          color: !isDarkMode ? Colors.grey[500] : Colors.white,
        )
      ],
    ),
    content: Text(
        '''Hey ! If you have something\non your mind. Don't hesitate\nto Contact me.\nAnd Enjoy the app :)''',
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
  );
}

Widget easterEgg() {
  return AlertDialog(
    backgroundColor: !isDarkMode ? lightAppColor : darkAppColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    title: Column(
      children: <Widget>[
        const SizedBox(width: 5),
        CustomIcon().explanIcon(),
        Divider(
          height: 20,
          color: !isDarkMode ? Colors.grey[500] : Colors.white,
        )
      ],
    ),
    content: Text("Wait ! How did you find me ?\nCongrats! you're awesome :) ",
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
  );
}

//Department of Icons
class CustomIcon {
  Widget searchIcon() {
    return const AdvancedIcon(
      icon: Icons.search_rounded,
      gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.green, Colors.blue]),
    );
  }

  Widget todayIcon() {
    return AdvancedIcon(
      icon: !isDarkMode
          ? CupertinoIcons.cloud_sun_fill
          : CupertinoIcons.cloud_moon_fill,
      size: 30,
      gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.yellow, Colors.amber, Colors.red]),
    );
  }

  Widget pinIcon() {
    return const Icon(
      Icons.push_pin,
      color: Colors.red,
    );
  }

  Widget nightIcon() {
    LinearGradient gradientColor =
        const LinearGradient(colors: [Colors.amber, Colors.orange]);
    return AdvancedIcon(
      color: !isDarkMode ? const IconThemeData().color : Colors.white,
      icon: !isDarkMode
          ? CupertinoIcons.moon_fill
          : CupertinoIcons.moon_stars_fill,
      gradient: gradientColor,
    );
  }

  Widget textIcon() {
    return AdvancedIcon(
        color: !isDarkMode ? const IconThemeData().color : Colors.white,
        icon: CupertinoIcons.textformat,
        gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.red, Colors.blue]));
  }

  Widget penIcon() {
    return AdvancedIcon(
      color: !isDarkMode ? const IconThemeData().color : Colors.white,
      icon: CupertinoIcons.pen,
      size: 28,
      gradient: const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Colors.blue, Colors.green],
      ),
    );
  }

  Widget explanIcon() {
    return const AdvancedIcon(
      icon: CupertinoIcons.exclamationmark_circle,
      size: 28,
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Colors.red, Colors.amber],
      ),
    );
  }

  Widget sortIcon() {
    return AdvancedIcon(
      icon: isASC ? CupertinoIcons.sort_down : CupertinoIcons.sort_up,
      size: 28,
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.centerRight,
        colors: [Colors.purple, Colors.green],
      ),
    );
  }
}
