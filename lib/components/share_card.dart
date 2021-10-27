import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memorise/components/toast_comp.dart';

Widget shareDialog(List friendslist, String cardID) {
  List selected = [];
  bool loader = false;
  return StatefulBuilder(
    builder: (BuildContext context, setState) {
      return !loader
          ? AlertDialog(
              title: const Center(
                child: Text("Share card"),
              ),
              content: ListView.builder(
                itemCount: friendslist.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(friendslist[index]["name"]),
                    subtitle: Text(friendslist[index]["username"]),
                    trailing: Checkbox(
                      onChanged: (val) {
                        if (val!) {
                          if (!selected.contains(index)) {
                            setState(() {
                              selected.add(index);
                            });
                          }
                        } else {
                          if (selected.contains(index)) {
                            setState(() {
                              selected.remove(index);
                            });
                          }
                        }
                      },
                      value: selected.contains(index),
                    ),
                  );
                },
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancle"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          loader = true;
                        });
                        print(selected);
                        List selecteduid = [];
                        for (int v in selected) {
                          selecteduid.add(friendslist[v]["uid"]);
                        }
                        FirebaseFirestore.instance
                            .collection("cards")
                            .doc(cardID)
                            .update({
                          "shared": FieldValue.arrayUnion(selecteduid)
                        }).whenComplete(() {
                          ToastSucessful("card shared");
                          Navigator.pop(context);
                        });

                        setState(() {
                          loader = false;
                        });
                      },
                      child: const Text("Share"),
                    )
                  ],
                )
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            );
    },
  );
}
