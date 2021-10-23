import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:memorise/components/toast_comp.dart';

import 'package:image_picker/image_picker.dart';

Widget AddCard(BuildContext context, String uid, List<String> grouplist,
    [String? groupname]) {
  String lable = "";
  String description = "";
  String imgurl = "";

  File? image;
  XFile? tempimg;

  bool loader = false;
  print(grouplist);
  grouplist.insert(0, 'all cards');
  String group = groupname ?? 'all cards';

  print(group);
  print(grouplist);

  return StatefulBuilder(
    builder: (context, setState) {
      List<Widget> wgt = [
        const SizedBox(
          height: 10,
        ),
        TextField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(), label: Text("Lable")),
          onChanged: (val) {
            lable = val;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () async {
            tempimg =
                await ImagePicker().pickImage(source: ImageSource.gallery);
            if (tempimg != null) {
              setState(() {
                image = File(tempimg!.path);
              });
            }
          },
          child: image == null
              ? const SizedBox(
                  height: 50,
                  child: Center(
                    child: Icon(
                      Icons.add_a_photo,
                    ),
                  ),
                )
              : SizedBox(
                  height: 300,
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(image!),
                  ),
                ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(), label: Text("Description")),
          onChanged: (val) {
            description = val;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        DropDown(
          items: grouplist,
          isExpanded: true,
          initialValue: groupname ?? 'all cards',
          onChanged: (value) {
            group = value.toString();
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
                    onPressed: () async {
                      setState(() {
                        loader = true;
                      });
                      if (lable.length > 0 && description.length > 0) {
                        if (image != null) {
                          await FirebaseStorage.instance
                              .ref(
                                  "images/${DateTime.now().microsecondsSinceEpoch}")
                              .putFile(
                                image!,
                                SettableMetadata(contentType: 'image/jpeg'),
                              )
                              .then((p0) async {
                            imgurl = await p0.ref.getDownloadURL();
                          });
                        }
                        Map<String, dynamic> data = {
                          "lable": lable,
                          "description": description,
                          "imgurl": "NA",
                          "uid": uid,
                          "timestamp": DateTime.now(),
                          "type": "1",
                          "preference": "NA",
                        };
                        if (imgurl.length > 0) {
                          data["imgurl"] = imgurl;
                        }

                        await FirebaseFirestore.instance
                            .collection("cards")
                            .add(data)
                            .then((value) async {
                          if (group != 'all cards') {
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(uid)
                                .update({
                              "groups.$group": FieldValue.arrayUnion([value.id])
                            });
                          }
                          ToastSucessful();
                          Navigator.pop(context);
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please Fill All the Details");
                      }
                      setState(() {
                        loader = false;
                      });
                    },
                    child: const Text("Save"),
                  ),
                )
              ],
            )
          : const Center(child: CircularProgressIndicator());
    },
  );
}
