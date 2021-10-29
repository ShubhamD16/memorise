import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:memorise/components/edit_card.dart';
import 'package:memorise/components/share_card.dart';
import 'package:memorise/components/toast_comp.dart';
import 'package:memorise/providers/userdata_provider.dart';
import 'package:provider/provider.dart';

class CardListTile extends StatefulWidget {
  final Map<String, dynamic> data;
  final String cardid;
  final String? groupname;
  const CardListTile({
    Key? key,
    required this.data,
    required this.cardid,
    this.groupname,
  }) : super(key: key);

  @override
  _CardListTileState createState() => _CardListTileState();
}

class _CardListTileState extends State<CardListTile> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    final userdata = context.watch<UserData>().data;
    final friends = userdata!['friends'];
    List<String> grouplist = userdata["groups"].keys.toList();
    widget.groupname != null ? grouplist.remove(widget.groupname) : null;

    String selectedgroup = grouplist.length > 0 ? grouplist[0] : "";

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
        IconSlideAction(
          icon: Icons.edit,
          color: Colors.green,
          onTap: () async {
            print(widget.data);
            await editCard(
                context, userdata["uid"], widget.data, widget.cardid);
          },
        ),
        IconSlideAction(
          icon: Icons.remove_from_queue,
          color: widget.groupname != "all cards"
              ? Colors.orange[600]
              : Colors.grey,
          onTap: () async {
            if (widget.groupname != "all cards") {
              await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("remove from ${widget.groupname}"),
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
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(userdata["uid"])
                                      .update({
                                    "groups.${widget.groupname}":
                                        FieldValue.arrayRemove([widget.cardid])
                                  }).whenComplete(() {
                                    ToastSucessful("card removed");
                                    Navigator.pop(context);
                                  }).onError(
                                          (error, stackTrace) => print(error));
                                },
                                child: const Text("Remove"))
                          ],
                        )
                      ],
                    );
                  });
            } else {
              ToastSucessful("Disabled");
            }
          },
        ),
        IconSlideAction(
          icon: Icons.add_to_queue,
          color: grouplist.length > 0 ? Colors.yellow : Colors.grey,
          onTap: () async {
            if (grouplist.length > 0) {
              print(grouplist);
              print(selectedgroup);
              await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Add card to group"),
                      content: DropDown(
                        items: grouplist,
                        isExpanded: true,
                        initialValue: selectedgroup,
                        onChanged: (value) {
                          selectedgroup = value.toString();
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
                                    .collection("users")
                                    .doc(userdata["uid"])
                                    .update({
                                  "groups.$selectedgroup":
                                      FieldValue.arrayUnion([widget.cardid])
                                }).whenComplete(() {
                                  Navigator.pop(context);
                                  ToastSucessful(
                                      "Card added to $selectedgroup");
                                });
                              },
                              child: const Text("Add"),
                            ),
                          ],
                        )
                      ],
                    );
                  });
            } else {
              ToastSucessful("Please add some groups");
            }
          },
        ),
        IconSlideAction(
          icon: Icons.share,
          color: Colors.lightBlue,
          onTap: () async {
            await showDialog(
                context: context,
                builder: (context) {
                  return shareDialog(friends, widget.cardid);
                });
          },
        ),
        IconSlideAction(
          icon: Icons.delete_forever,
          color: Colors.red[600],
          onTap: () async {
            await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: const Center(
                        child: Text("Delete Card"),
                      ),
                      content: const Text(
                          "Deleting card will remove card from all the groups"),
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
                              onPressed: () {
                                Map temp = userdata["groups"];
                                print(widget.cardid);
                                print(temp);
                                if (grouplist.length > 0) {
                                  for (var v in grouplist) {
                                    temp[v].remove(widget.cardid);
                                  }
                                  print(temp);

                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(userdata["uid"])
                                      .update({"groups": temp}).whenComplete(
                                          () async {
                                    FirebaseFirestore.instance
                                        .collection("cards")
                                        .doc(widget.cardid)
                                        .delete()
                                        .whenComplete(() {
                                      Navigator.pop(context);
                                      ToastSucessful("Card deleted");
                                    });
                                  });
                                } else {
                                  FirebaseFirestore.instance
                                      .collection("cards")
                                      .doc(widget.cardid)
                                      .delete()
                                      .whenComplete(() {
                                    Navigator.pop(context);
                                    ToastSucessful("Card deleted");
                                  });
                                }
                              },
                              child: const Text("Delete"),
                            ),
                          ],
                        )
                      ]);
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
