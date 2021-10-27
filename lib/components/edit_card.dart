import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:memorise/components/text_recognization.dart';
import 'package:memorise/components/toast_comp.dart';

import 'package:image_picker/image_picker.dart';

editCard(BuildContext context, String uid, Map data, String id) async {
  print(data);

  print("check check");

  await showDialog(
      context: context,
      builder: (context) {
        print(data["type"]);
        if (data["type"] == "1") {
          return EditCard1(context, uid, data, id);
        }
        if (data["type"] == "2") {
          return EditCard2(context, uid, data, id);
        }
        return SizedBox();
      });
}

Widget EditCard1(BuildContext context, String uid, Map data, String id) {
  print(data);
  String lable = data["lable"];
  String description = data["description"];
  String imgurl = data["imgurl"];

  File? image;
  XFile? tempimg;

  bool loader = false;

  return StatefulBuilder(
    builder: (context, setState) {
      List<Widget> wgt = [
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: TextEditingController()..text = lable,
          maxLines: null,
          decoration: InputDecoration(
              suffixIcon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        String? text = await getTextFromPhoto();

                        if (text != null) {
                          setState(() {
                            lable = text;
                          });
                        } else {
                          ToastSucessful("No text recognized");
                        }
                      },
                      icon: const Icon(Icons.camera)),
                  IconButton(
                      onPressed: () async {
                        String? text = await getTextFromImage();

                        if (text != null) {
                          setState(() {
                            lable = text;
                          });
                        } else {
                          ToastSucessful("No text recognized");
                        }
                      },
                      icon: const Icon(Icons.text_fields)),
                ],
              ),
              border: const OutlineInputBorder(),
              label: const Text("Lable")),
          onChanged: (val) {
            print(val);
            lable = val;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        image == null && imgurl != "NA"
            ? SizedBox(height: 200, child: CachedNetworkImage(imageUrl: imgurl))
            : SizedBox(),
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
          controller: TextEditingController()..text = description,
          maxLines: null,
          decoration: InputDecoration(
              suffixIcon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        String? text = await getTextFromPhoto();

                        if (text != null) {
                          setState(() {
                            description = text;
                          });
                        } else {
                          ToastSucessful("No text recognized");
                        }
                      },
                      icon: const Icon(Icons.camera)),
                  IconButton(
                      onPressed: () async {
                        String? text = await getTextFromImage();

                        if (text != null) {
                          setState(() {
                            description = text;
                          });
                        } else {
                          ToastSucessful("No text recognized");
                        }
                      },
                      icon: const Icon(Icons.text_fields)),
                ],
              ),
              border: OutlineInputBorder(),
              label: Text("Description")),
          onChanged: (val) {
            description = val;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        const SizedBox(
          height: 10,
        ),
      ];

      return !loader
          ? AlertDialog(
              contentPadding: EdgeInsets.all(10),
              title: const Center(child: Text("Edit Card")),
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
                          "timestamp": DateTime.now(),
                          "type": "1",
                        };
                        if (imgurl.length > 0) {
                          data["imgurl"] = imgurl;
                        }

                        await FirebaseFirestore.instance
                            .collection("cards")
                            .doc(id)
                            .update(data)
                            .then((value) async {
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

Widget EditCard2(BuildContext context, String uid, Map data, String id) {
  String lable = data["lable"];
  String option1 = data["op1"];
  String option2 = data["op2"];
  String option3 = data["op3"];
  String option4 = data["op4"];
  bool correct1 = data["ans1"];
  bool correct2 = data["ans2"];
  bool correct3 = data["ans3"];
  bool correct4 = data["ans4"];

  bool loader = false;

  return StatefulBuilder(
    builder: (context, setState) {
      List<Widget> wgt = [
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: TextEditingController()..text = lable,
          maxLines: null,
          decoration: InputDecoration(
              suffixIcon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        String? text = await getTextFromPhoto();

                        if (text != null) {
                          setState(() {
                            lable = text;
                          });
                        } else {
                          ToastSucessful("No text recognized");
                        }
                      },
                      icon: const Icon(Icons.camera)),
                  IconButton(
                      onPressed: () async {
                        String? text = await getTextFromImage();

                        if (text != null) {
                          setState(() {
                            lable = text;
                          });
                        } else {
                          ToastSucessful("No text recognized");
                        }
                      },
                      icon: const Icon(Icons.text_fields)),
                ],
              ),
              border: const OutlineInputBorder(),
              label: const Text("Lable")),
          onChanged: (val) {
            print(val);
            lable = val;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: TextEditingController()..text = option1,
          decoration: InputDecoration(
              suffixIcon: Checkbox(
                onChanged: (val) {
                  setState(() {
                    correct1 = val!;
                  });
                },
                value: correct1,
              ),
              border: OutlineInputBorder(),
              label: Text("option1")),
          onChanged: (val) {
            option1 = val;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: TextEditingController()..text = option2,
          decoration: InputDecoration(
              suffixIcon: Checkbox(
                onChanged: (val) {
                  setState(() {
                    correct2 = val!;
                  });
                },
                value: correct2,
              ),
              border: OutlineInputBorder(),
              label: Text("option2")),
          onChanged: (val) {
            option2 = val;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: TextEditingController()..text = option3,
          decoration: InputDecoration(
              suffixIcon: Checkbox(
                onChanged: (val) {
                  setState(() {
                    correct3 = val!;
                  });
                },
                value: correct3,
              ),
              border: OutlineInputBorder(),
              label: Text("option3")),
          onChanged: (val) {
            option3 = val;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: TextEditingController()..text = option4,
          decoration: InputDecoration(
              suffixIcon: Checkbox(
                onChanged: (val) {
                  setState(() {
                    correct4 = val!;
                  });
                },
                value: correct4,
              ),
              border: OutlineInputBorder(),
              label: Text("option4")),
          onChanged: (val) {
            option4 = val;
          },
        ),
        const SizedBox(
          height: 10,
        ),
      ];

      return !loader
          ? AlertDialog(
              contentPadding: EdgeInsets.all(10),
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
                      if (lable.length > 0) {
                        if (!(option1.length > 0)) {
                          option1 = "NA";
                        }
                        if (!(option2.length > 0)) {
                          option2 = "NA";
                        }
                        if (!(option3.length > 0)) {
                          option3 = "NA";
                        }
                        if (!(option4.length > 0)) {
                          option4 = "NA";
                        }
                        Map<String, dynamic> data = {
                          "lable": lable,
                          "op1": option1,
                          "op2": option2,
                          "op3": option3,
                          "op4": option4,
                          "ans1": correct1,
                          "ans2": correct2,
                          "ans3": correct3,
                          "ans4": correct4,
                          "imgurl": "NA",
                          "timestamp": DateTime.now(),
                          "type": "2",
                        };

                        await FirebaseFirestore.instance
                            .collection("cards")
                            .doc(id)
                            .update(data)
                            .then((value) async {
                          ToastSucessful();
                          Navigator.pop(context);
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please add lable/question");
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
