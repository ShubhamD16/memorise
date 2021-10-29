import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:memorise/components/admob_helper.dart';
import 'package:memorise/components/toast_comp.dart';
import 'package:memorise/providers/userdata_provider.dart';
import 'package:provider/provider.dart';

class FriendsPage extends StatefulWidget {
  FriendsPage({Key? key}) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  String username = "";
  List<QueryDocumentSnapshot<Map<String, dynamic>>> requests = [];

  @override
  Widget build(BuildContext context) {
    final userdata = context.watch<UserData>().data;
    final List friendlist = userdata!['friends'];

    Widget requestDialog() {
      return StatefulBuilder(
        builder: (BuildContext context, setState) {
          return AlertDialog(
            title: const Center(child: Text("All Requests")),
            content: ListView.separated(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                var temp = requests[index];
                print("temp");
                print(temp.get('fromuid'));
                print(userdata["uid"]);

                if (temp.get('fromuid') == userdata["uid"]) {
                  return Card(
                    child: ListTile(
                      title: Center(child: Text(temp.get("toname"))),
                      subtitle: Center(
                        child: Text(
                          temp.get("tousername"),
                          style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : null),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_forever),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Center(
                                    child: Text("Delete"),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        temp.get("toname"),
                                        style: TextStyle(fontSize: 30),
                                      ),
                                      Text(temp.get("tousername"))
                                    ],
                                  ),
                                  actions: [
                                    Center(
                                      child: ElevatedButton(
                                        child: const Text("Delete"),
                                        onPressed: () async {
                                          await temp.reference
                                              .delete()
                                              .whenComplete(() =>
                                                  ToastSucessful(
                                                      "Request deleted"));
                                          Navigator.pop(context);
                                          if (requests.length == 1) {
                                            Navigator.pop(context);
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                );
                              });
                        },
                      ),
                    ),
                  );
                } else {
                  return Card(
                    child: Column(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              temp.get("fromname"),
                              style: const TextStyle(
                                fontSize: 30,
                              ),
                            ),
                            Text(temp.get("fromusername"))
                          ],
                        ),
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  child: const Text("Accept"),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(userdata["uid"])
                                        .update(
                                      {
                                        "friends": FieldValue.arrayUnion(
                                          [
                                            {
                                              "uid": temp.get("fromuid"),
                                              "username":
                                                  temp.get("fromusername"),
                                              "name": temp.get("fromname")
                                            },
                                          ],
                                        ),
                                      },
                                    );
                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(temp.get("fromuid"))
                                        .update(
                                      {
                                        "friends": FieldValue.arrayUnion(
                                          [
                                            {
                                              "uid": temp.get("touid"),
                                              "username":
                                                  temp.get("tousername"),
                                              "name": temp.get("toname")
                                            },
                                          ],
                                        ),
                                      },
                                    ).whenComplete(() async {
                                      await temp.reference.delete();
                                      ToastSucessful("Request accepted");
                                      setState(() {
                                        requests.remove(temp);
                                      });
                                    });
                                  },
                                ),
                                ElevatedButton(
                                  child: const Text("Delete"),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Center(
                                              child: Text("Delete"),
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(temp.get("toname")),
                                                Text(temp.get("tousername"))
                                              ],
                                            ),
                                            actions: [
                                              Center(
                                                child: ElevatedButton(
                                                  child: const Text("Delete"),
                                                  onPressed: () async {
                                                    await temp.reference
                                                        .delete()
                                                        .whenComplete(() =>
                                                            ToastSucessful(
                                                                "Request deleted"));
                                                    Navigator.pop(context);
                                                    if (requests.length == 1) {
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                ),
                                              )
                                            ],
                                          );
                                        });
                                  },
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 50,
                );
              },
            ),
          );
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Friends"),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Center(
                      child: Text("Add Friend"),
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Username")),
                            onChanged: (val) {
                              username = val;
                            },
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            print("sending request");
                            if (username.length > 0) {
                              bool arefriends = false;

                              if (friendlist.isNotEmpty) {
                                print(friendlist.isNotEmpty);
                                for (var v in friendlist) {
                                  //print(v);
                                  if (v['username'] == username) {
                                    ToastSucessful("Already friends");
                                    arefriends = true;
                                    break;
                                  }
                                }
                              }
                              print("check2");
                              if (!arefriends) {
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .where("username", isEqualTo: username)
                                    .get()
                                    .then((value) {
                                  if (value.docs.length == 1) {
                                    FirebaseFirestore.instance
                                        .collection("requests")
                                        .add(
                                      {
                                        "fromusername": userdata["username"],
                                        "fromuid": userdata["uid"],
                                        "fromname": userdata["name"],
                                        "tousername":
                                            value.docs[0].get("username"),
                                        "touid": value.docs[0].get("uid"),
                                        "toname": value.docs[0].get("name"),
                                        "status": 0,
                                        "timestamp": DateTime.now(),
                                      },
                                    ).whenComplete(() {
                                      Navigator.pop(context);
                                      ToastSucessful("Friend request sent");
                                    });
                                  } else if (value.docs.length == 0) {
                                    ToastSucessful("no user with username");
                                  } else {
                                    ToastSucessful("Error");
                                  }
                                });
                              }
                            } else {
                              ToastSucessful("Please enter username.");
                            }
                          },
                          child: const Center(child: Text("Send request"))),
                    ],
                  );
                });
          },
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 30,
                child: ElevatedButton(
                  child: const Text("Requests"),
                  onPressed: () async {
                    requests = [];
                    await FirebaseFirestore.instance
                        .collection("requests")
                        .where("touid", isEqualTo: userdata['uid'])
                        .get()
                        .then((value) async {
                      if (value.docs.length > 0) {
                        requests = value.docs;
                      }
                    });

                    await FirebaseFirestore.instance
                        .collection("requests")
                        .where("fromuid", isEqualTo: userdata['uid'])
                        .get()
                        .then((value) async {
                      print(value.docs.length);
                      if (value.docs.length > 0) {
                        requests = requests + value.docs;
                      }
                    });
                    if (requests.length > 0) {
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return requestDialog();
                          });
                    } else {
                      ToastSucessful("No Data Available");
                    }
                    print(requests);
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                flex: 1,
                child: Scrollbar(
                  child: ListView.separated(
                    itemCount: friendlist.length,
                    itemBuilder: (context, index) {
                      Map temp = friendlist[index];
                      return Card(
                        child: ListTile(
                          title: Text(temp["name"]),
                          subtitle: Text(temp["username"]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title:
                                          const Text("Remove from friend list"),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Cancle"),
                                            ),
                                            ElevatedButton(
                                                onPressed: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("users")
                                                      .doc(userdata["uid"])
                                                      .update({
                                                    "friends":
                                                        FieldValue.arrayRemove(
                                                            [temp])
                                                  }).whenComplete(() async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("users")
                                                        .doc(temp["uid"])
                                                        .update({
                                                      "friends": FieldValue
                                                          .arrayRemove([
                                                        {
                                                          "name":
                                                              userdata["name"],
                                                          "uid":
                                                              userdata["uid"],
                                                          "username": userdata[
                                                              "username"],
                                                        }
                                                      ])
                                                    }).whenComplete(() {
                                                      Navigator.pop(context);
                                                      ToastSucessful("Removed");
                                                    });
                                                  });
                                                },
                                                child: const Text("Remove"))
                                          ],
                                        )
                                      ],
                                    );
                                  });
                            },
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 20,
                      );
                    },
                  ),
                ),
              ),
              AdmobHelper.OtherpageAdWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
