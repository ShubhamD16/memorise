import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  var font = "roboto";

  @override
  Widget build(BuildContext context) {
    print("Add User Data ...!");
    String uid = Provider.of<UserState>(context).user!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Memorise"),
      ),
      body: Center(
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
                      Text(warning),
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
                                                  "username alredy exists (-_-) ."
                                            }
                                        });
                              } else {
                                warning = "Invalid username";
                              }
                            } else {
                              warning = "Fill all the details";
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
    );
  }
}
