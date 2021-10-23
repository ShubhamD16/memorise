import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:memorise/components/toast_comp.dart';

Widget addGroup(String uid, List allgroups, BuildContext context) {
  String groupname = "";

  bool loader = false;
  return StatefulBuilder(
    builder: (context, setState) {
      List<Widget> wgt = [
        const SizedBox(
          height: 10,
        ),
        TextField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(), label: Text("Name")),
          onChanged: (val) {
            groupname = val;
          },
        ),
        const SizedBox(
          height: 10,
        ),
      ];

      return !loader
          ? AlertDialog(
              title: const Center(child: Text("Add Card")),
              content: !loader
                  ? SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: wgt,
                      ),
                    )
                  : const CircularProgressIndicator(),
              actions: [
                Center(
                  child: ElevatedButton(
                    child: const Text("Save"),
                    onPressed: () async {
                      setState(() {
                        loader = true;
                      });
                      if (allgroups.contains(groupname)) {
                        ToastSucessful("Group Already Exists");
                      } else {
                        if (groupname.length > 0) {
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(uid)
                              .update({"groups.$groupname": []}).whenComplete(
                                  () {
                            ToastSucessful();
                            Navigator.pop(context);
                          });
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please Fill All the Details");
                        }
                      }
                      setState(() {
                        loader = false;
                      });
                    },
                  ),
                )
              ],
            )
          : const Center(child: CircularProgressIndicator());
    },
  );
}
