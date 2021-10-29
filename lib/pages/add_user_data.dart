import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memorise/components/toast_comp.dart';
import 'package:memorise/providers/userstate_provider.dart';
import 'package:provider/provider.dart';

class AddUserData extends StatefulWidget {
  const AddUserData({Key? key}) : super(key: key);

  @override
  _AddUserDataState createState() => _AddUserDataState();
}

class _AddUserDataState extends State<AddUserData> {
  String username = "";
  String name = "";
  bool loader = false;
  String warning = "";
  String apmode = "dark";
  var font = "dancingScript";

  @override
  Widget build(BuildContext context) {
    print("Add User Data ...!");
    String uid = Provider.of<UserState>(context).user!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flash Memorize", style: TextStyle(fontSize: 30)),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/night_background.jpg"),
                fit: BoxFit.cover)),
        child: Center(
          child: !loader
              ? SingleChildScrollView(
                  child: AlertDialog(
                    title: const Center(child: Text("New User")),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            label: Text("Create user ID"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              warning = "";
                            });
                            username = val;
                          },
                        ),
                        const Text(
                          "Note:username must contain min 3 characters and no special character; eg: Abc123",
                          style: TextStyle(fontSize: 10, color: Colors.red),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            label: Text("Name"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              warning = "";
                            });
                            name = val;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Note: Name and username will be added only once. no further changes will be done.",
                          style: TextStyle(fontSize: 10, color: Colors.red),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    actions: [
                      Center(
                        child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                loader = true;
                              });
                              if (username.length >= 3 && name.length > 0) {
                                final validCharacters =
                                    RegExp(r'^[a-zA-Z0-9_]+$');
                                if (validCharacters.hasMatch(username)) {
                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .where("userid", isEqualTo: username)
                                      .get()
                                      .then((value) => {
                                            if (value.docs.isEmpty)
                                              {
                                                FirebaseFirestore.instance
                                                    .collection("users")
                                                    .doc(uid)
                                                    .set(
                                                  {
                                                    "name": name,
                                                    "username": username,
                                                    "uid": uid,
                                                    "mode": apmode,
                                                    "font": font,
                                                    "groups": {},
                                                    "friends": [],
                                                    "cancelled": [],
                                                  },
                                                )
                                              }
                                            else
                                              {
                                                warning =
                                                    "username alredy exists (-_-) .",
                                                ToastSucessful(warning),
                                              }
                                          });
                                } else {
                                  warning = "Invalid username";
                                  ToastSucessful(warning);
                                }
                              } else {
                                warning = "Fill all the details";
                                ToastSucessful(warning);
                              }

                              setState(() {
                                loader = false;
                              });
                            },
                            child: const Text("Save")),
                      )
                    ],
                  ),
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
