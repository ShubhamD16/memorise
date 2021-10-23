import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:memorise/components/fontsdata.dart';
import 'package:memorise/providers/userstate_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  final String? mode, font;
  const SettingsPage({Key? key, required this.mode, required this.font})
      : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState(mode, font);
}

class _SettingsPageState extends State<SettingsPage> {
  String? mode, font;

  _SettingsPageState(this.mode, this.font);
  @override
  Widget build(BuildContext context) {
    print(font);
    print(mode);
    String uid = context.watch<UserState>().user!.uid;
    List<String> names = [];
    List<Widget> widgets = [];
    for (String v in GetFont().fontDataMap.keys) {
      names.add(v);
      widgets.add(Text(
        v,
        style: GetFont().fontDataMap[v]!["textStyle"],
      ));
    }

    print(names);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              DropDown(
                items: names,
                customWidgets: widgets,
                hint: const Text("Select Font"),
                onChanged: (val) {
                  font = val.toString();
                },
                isExpanded: true,
              ),
              const SizedBox(
                height: 30,
              ),
              DropDown(
                items: const ["dark", "light"],
                hint: const Text("Select Mode"),
                onChanged: (val) {
                  mode = val.toString();
                },
                isExpanded: true,
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(uid)
                        .update({
                      "mode": mode,
                      "font": font,
                    });
                  },
                  child: const Text("Save")),
            ],
          ),
        ),
      ),
    );
  }
}
