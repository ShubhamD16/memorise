import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:memorise/components/create_group.dart';
import 'package:memorise/components/toast_comp.dart';
import 'package:memorise/pages/add_user_data.dart';
import 'package:memorise/pages/cards_colection.dart';
import 'package:memorise/components/create_card.dart';
import 'package:memorise/pages/friends_page.dart';
import 'package:memorise/pages/settings_page.dart';
import 'package:memorise/pages/test_page.dart';
import 'package:memorise/providers/casdsdata.dart';
import 'package:memorise/providers/userdata_provider.dart';
import 'package:memorise/providers/userstate_provider.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map? userdata = context.watch<UserData>().data;
    bool userdataloaded = false;
    List<String> groupkeys = [];
    if (userdata == null) {
      return const AddUserData();
    } else {
      if (userdata.isNotEmpty) {
        userdataloaded = true;
        groupkeys = userdata["groups"].keys.toList();
      }
    }

    if (context.watch<UserData>().data!.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    String uid = context.read<UserState>().user!.uid;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Memorise"),
        ),
        drawer: Container(
          width: 2 * MediaQuery.of(context).size.width / 3,
          child: Drawer(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: 200,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(bottom: 50),
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/drawer.jpg"),
                                fit: BoxFit.cover)),
                        height: 150,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                userdata["name"].toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 25),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SelectableText(userdata["username"].toString()),
                              IconButton(
                                  onPressed: () async {
                                    await Clipboard.setData(ClipboardData(
                                        text: userdata["username"].toString()));
                                    ToastSucessful("Copied to clipboard");
                                  },
                                  icon: const Icon(Icons.copy))
                            ],
                          ),
                        )),
                    ListTile(
                      title: const Text("Settings"),
                      onTap: () {
                        Navigator.pop(context);
                        if (userdataloaded) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SettingsPage(
                                font: userdata["font"], mode: userdata["mode"]);
                          }));
                        } else {
                          ToastSucessful("Data Loading Please Wait...!");
                        }
                      },
                    ),
                    ListTile(
                      title: const Text("Test"),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return TestPage(
                              idlist:
                                  context.watch<AllCardsData>().getidlist());
                        }));
                      },
                    ),
                    ListTile(
                      title: const Text("Friend List"),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return FriendsPage();
                        }));
                      },
                    ),
                    ListTile(
                      title: const Text("Logout"),
                      onTap: () async {
                        Navigator.pop(context);
                        await GoogleSignIn().signOut();
                        await FirebaseAuth.instance.signOut();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            await showDialog(
                context: context,
                builder: (context) {
                  return addCard(context, uid, groupkeys);
                });
          },
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: Theme.of(context).brightness == Brightness.light
                    ? AssetImage("assets/day_background.jpg")
                    : AssetImage("assets/night_background.jpg"),
                fit: BoxFit.cover),
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    if (userdataloaded) {
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return addGroup(context, uid, groupkeys);
                          });
                    } else {
                      ToastSucessful("Data Loading Please Wait...!");
                    }
                  },
                  child: const Text("ADD GROUP")),
              Expanded(
                flex: 1,
                child: Scrollbar(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 0),
                            child: ListTile(
                              title: const Text(
                                "All Cards",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.w300),
                              ),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return CardsList(
                                    cardkeylist: context
                                        .watch<AllCardsData>()
                                        .getidlist(),
                                    groupname: "all cards",
                                  );
                                }));
                              },
                              subtitle: SizedBox(
                                height: 30,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                        child: const Text(
                                          "Test Yourself",
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return TestPage(
                                                    idlist: context
                                                        .watch<AllCardsData>()
                                                        .getidlist());
                                              },
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        var key = groupkeys[index - 1];
                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.15,
                          secondaryActions: [
                            IconSlideAction(
                              icon: Icons.copy_all,
                              color: Colors.green,
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return copyGroup(context, uid, groupkeys,
                                          userdata["groups"][key]);
                                    });
                              },
                            ),
                            IconSlideAction(
                              icon: Icons.delete,
                              color: Colors.orange[600],
                              onTap: () async {
                                bool deleteCards = false;
                                await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Center(
                                          child: Text("Delete $key"),
                                        ),
                                        /*   // for deleting cards in group
                                        content: CheckboxListTile(
                                          onChanged: (bal) {
                                            deleteCards = bal!;
                                          },
                                          
                                          value: deleteCards,
                                          title: const Text(
                                              "also delete all the cards in it."),
                                        ),
                                        */
                                        actions: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Cancle")),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection("users")
                                                        .doc(uid)
                                                        .update({
                                                      "groups.$key":
                                                          FieldValue.delete()
                                                    }).whenComplete(() {
                                                      Navigator.pop(context);
                                                      ToastSucessful(
                                                          "Group deleted");
                                                    });
                                                  },
                                                  child: const Text("Delete")),
                                            ],
                                          )
                                        ],
                                      );
                                    });
                              },
                            ),
                            IconSlideAction(
                              icon: Icons.cancel,
                              color: Colors.red,
                              onTap: () {},
                            ),
                          ],
                          child: Card(
                            child: ListTile(
                              trailing: const Icon(Icons.keyboard_arrow_left),
                              title: Text(
                                key,
                                style: const TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.w300),
                              ),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return CardsList(
                                    cardkeylist: userdata["groups"][key],
                                    groupname: key,
                                  );
                                }));
                              },
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: SizedBox(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: ElevatedButton(
                                            child: const Text(
                                              "Test Yourself",
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return TestPage(
                                                      idlist: userdata["groups"]
                                                          [key],
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: ElevatedButton(
                                              child: const Text(
                                                "Add Card",
                                              ),
                                              onPressed: () async {
                                                await showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return addCard(context,
                                                          uid, groupkeys, key);
                                                    });
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: userdataloaded ? groupkeys.length + 1 : 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
