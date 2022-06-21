import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/services/base.dart';
import 'package:note_app/services/persist_data.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  //
  Widget switchButton(Color? switchColor) {
    // Transform.scale(
    //   scale: 0.7,
    //   child: )
    return Switch.adaptive(
      activeColor: Colors.white,
      activeTrackColor: switchColor,
      inactiveTrackColor: Colors.grey,
      value: isDarkMode,
      onChanged: (value) async {
        await UserPrefs.setTheme(value);
        setState(() {
          isDarkMode = value;
          //isDarkMode = !isDarkMode;
        });
      },
    );
  }

  Widget autoCorrectButton(Color? switchColor) {
    // Transform.scale(
    //   scale: 0.7,
    //   child: )
    return Switch.adaptive(
      activeColor: Colors.white,
      activeTrackColor: switchColor,
      inactiveTrackColor: Colors.grey,
      value: isAutoCorrect,
      onChanged: (value) async {
        await UserPrefs.setAuto(value);
        setState(() {
          isAutoCorrect = value;
        });
      },
    );
  }

  Widget customDivider() {
    return Divider(
      height: 2,
      color: !isDarkMode ? Colors.grey[400] : Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: !isDarkMode ? Colors.blue[200] : Colors.amber[400],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Settings",
          style: TextStyle(
              color: Colors.white,
              letterSpacing: 1,
              fontSize: 30,
              fontFamily: defaultAppFont,
              fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.menu_rounded,
                color: Colors.white,
              )),
        ],
        centerTitle: true,
        toolbarHeight: MediaQuery.of(context).size.height / 5,
        backgroundColor: !isDarkMode ? Colors.blue[200] : Colors.amber[400],
        elevation: 0,
      ),
      body: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: !isDarkMode ? lightAppColor : darkAppColor,
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //Dark Mode
                ListTile(
                  leading: CustomIcon().nightIcon(),
                  title: Text(
                    "Dark Mode",
                    style: TextStyle(
                        fontFamily: defaultAppFont,
                        color: !isDarkMode ? Colors.black : Colors.white),
                  ),
                  trailing: switchButton(Colors.amber),
                ),
                customDivider(),
                //Font
                GestureDetector(
                  child: ListTile(
                    leading: CustomIcon().textIcon(),
                    title: Text(
                      "Font",
                      style: TextStyle(
                          fontFamily: defaultAppFont,
                          color: !isDarkMode ? Colors.black : Colors.white),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: !isDarkMode ? Colors.black : Colors.white,
                    ),
                  ),
                  onTap: (() async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) => const FontAlert(),
                    );
                    //to rebuild after pop up
                    setState(() {});
                  }),
                ),
                customDivider(),

                //Auto Correct
                ListTile(
                  leading: CustomIcon().penIcon(),
                  title: Text(
                    "Auto Correct",
                    style: TextStyle(
                        fontFamily: defaultAppFont,
                        color: !isDarkMode ? Colors.black : Colors.white),
                  ),
                  trailing: autoCorrectButton(Colors.green),
                ),
                customDivider(),

                //Delete all notes
                GestureDetector(
                  onTap: () {
                    deleteAlert(context,
                        id: "All",
                        displayText: "Delete All Notes?",
                        goMenu: false);
                  },
                  child: ListTile(
                    leading: Icon(
                      CupertinoIcons.delete,
                      color: !isDarkMode ? Colors.grey[600] : Colors.grey[300],
                    ),
                    title: Text(
                      "Delete All Notes",
                      style: TextStyle(
                          fontFamily: defaultAppFont,
                          color: !isDarkMode ? Colors.black : Colors.white),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: !isDarkMode ? Colors.black : Colors.white,
                    ),
                  ),
                ),
                customDivider(),
                GestureDetector(
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => easterEgg());
                  },
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => contactMe());
                  },
                  child: ListTile(
                    leading: Icon(
                      CupertinoIcons.exclamationmark_circle,
                      color: !isDarkMode ? Colors.grey[600] : Colors.grey[300],
                    ),
                    title: Text(
                      "Contact Me",
                      style: TextStyle(
                          fontFamily: defaultAppFont,
                          color: !isDarkMode ? Colors.black : Colors.white),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: !isDarkMode ? Colors.black : Colors.white,
                    ),
                  ),
                ),
                customDivider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
