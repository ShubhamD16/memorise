import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:memorise/components/toast_comp.dart';
import 'package:memorise/providers/userdata_provider.dart';
import 'package:provider/provider.dart';

class SharedCardListTile extends StatefulWidget {
  final Map<String, dynamic> data;
  final String cardid;
  const SharedCardListTile({
    Key? key,
    required this.data,
    required this.cardid,
  }) : super(key: key);

  @override
  _SharedCardListTileState createState() => _SharedCardListTileState();
}

class _SharedCardListTileState extends State<SharedCardListTile> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    final userdata = context.watch<UserData>().data;
    final friends = userdata!['friends'];
    List<String> grouplist = userdata["groups"].keys.toList();
    print(grouplist);
    if (grouplist.isNotEmpty) {
      grouplist[0] != "all cards" ? grouplist.insert(0, 'all cards') : null;
    } else {
      grouplist.add("all cards");
    }
    String group = 'all cards';
    print(grouplist);

    Widget? getTypeData(String type) {
      if (type == "1") {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            widget.data["imgurl"] != "NA"
                ? SizedBox(
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: widget.data["imgurl"],
                        placeholder: (context, s) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(
              height: 20,
            ),
            Text(
              widget.data["description"],
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        );
      }
      if (type == "2") {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            Card(
              color: widget.data["ans1"] ? Colors.greenAccent : null,
              child: ListTile(
                tileColor: Colors.transparent,
                title: Center(
                  child: Text(
                    widget.data["op1"],
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ),
            Card(
              color: widget.data["ans2"] ? Colors.greenAccent : null,
              child: ListTile(
                tileColor: Colors.transparent,
                title: Center(
                  child: Text(
                    widget.data["op2"],
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ),
            Card(
              color: widget.data["ans3"] ? Colors.greenAccent : null,
              child: ListTile(
                tileColor: Colors.transparent,
                title: Center(
                  child: Text(
                    widget.data["op3"],
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ),
            Card(
              color: widget.data["ans4"] ? Colors.greenAccent : null,
              child: ListTile(
                tileColor: Colors.transparent,
                title: Center(
                  child: Text(
                    widget.data["op4"],
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ),
          ],
        );
      }
    }

    return Slidable(
      actionExtentRatio: 0.15,
      actionPane: const SlidableDrawerActionPane(),
      secondaryActions: [
        grouplist.length > 0
            ? IconSlideAction(
                icon: Icons.save,
                color: Colors.yellow,
                onTap: () async {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Add card to group"),
                          content: DropDown(
                            items: grouplist,
                            isExpanded: true,
                            initialValue: group,
                            onChanged: (value) {
                              group = value.toString();
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
                                    await FirebaseFirestore.instance
                                        .collection("cards")
                                        .add(widget.data)
                                        .then((value) async {
                                      await FirebaseFirestore.instance
                                          .collection("cards")
                                          .doc(value.id)
                                          .update({
                                        "attempts": 0,
                                        "correct": 0,
                                        "uid": userdata["uid"],
                                        "timestamp": DateTime.now(),
                                        "preference": "NA",
                                        "shared": [],
                                      }).then((value2) async {
                                        ToastSucessful("Card Saved");
                                        if (group != "all cards") {
                                          await FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(userdata["uid"])
                                              .update({
                                            "groups.$group":
                                                FieldValue.arrayUnion(
                                                    [value.id])
                                          }).whenComplete(() {
                                            ToastSucessful(
                                                "Card added to $group");
                                          });
                                        }
                                        Navigator.pop(context);
                                      });
                                    });
                                  },
                                  child: const Text("Save"),
                                ),
                              ],
                            )
                          ],
                        );
                      });
                },
              )
            : const SizedBox(),
        IconSlideAction(
          icon: Icons.delete_forever,
          color: Colors.red[600],
          onTap: () async {
            await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Remove from shared list"),
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
                              await FirebaseFirestore.instance
                                  .collection("cards")
                                  .doc(widget.cardid)
                                  .update({
                                "shared":
                                    FieldValue.arrayRemove([userdata["uid"]])
                              });
                              Navigator.pop(context);
                            },
                            child: const Text("Remove"),
                          ),
                        ],
                      )
                    ],
                  );
                });
          },
        ),
        IconSlideAction(
          icon: Icons.cancel,
          color: Colors.redAccent[100],
          onTap: () {},
        ),
      ],
      child: GestureDetector(
        onTap: () {
          setState(() {
            expanded = !expanded;
          });
        },
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                child: ListTile(
                  trailing: const Icon(
                    Icons.keyboard_arrow_left_sharp,
                    size: 30,
                  ),
                  title: Center(
                    child: Text(
                      widget.data["lable"],
                      maxLines: expanded ? null : 1,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              ),
              const Divider(
                height: 10,
                thickness: 4,
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: expanded ? 300 : 0,
                child: SingleChildScrollView(
                  child: getTypeData(widget.data["type"]),
                ),
              ),
              !expanded ? const Text("tap to expand") : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
