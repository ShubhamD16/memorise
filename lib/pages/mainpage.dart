import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:memorise/components/create_group.dart';
import 'package:memorise/components/toast_comp.dart';
import 'package:memorise/pages/add_user_data.dart';
import 'package:memorise/pages/cards_colection.dart';
import 'package:memorise/components/create_card.dart';
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
                    const SizedBox(
                      height: 200,
                    ),
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
                  return AddCard(context, uid, groupkeys);
                });
          },
        ),
        body: SizedBox(
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
                            return addGroup(uid, groupkeys, context);
                          });
                    } else {
                      ToastSucessful("Data Loading Please Wait...!");
                    }
                  },
                  child: const Text("ADD GROUP")),
              Expanded(
                flex: 1,
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Card(
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
                                  cardkeylist:
                                      context.watch<AllCardsData>().getidlist(),
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
                                        "Take Test",
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
                            icon: Icons.edit,
                            color: Colors.green,
                            onTap: () {},
                          ),
                          IconSlideAction(
                            icon: Icons.delete,
                            color: Colors.orange[600],
                            onTap: () {},
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
                                        borderRadius: BorderRadius.circular(20),
                                        child: ElevatedButton(
                                          child: const Text(
                                            "Take Test",
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return TestPage(
                                                      idlist: userdata["groups"]
                                                          [key]);
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
                                        borderRadius: BorderRadius.circular(20),
                                        child: ElevatedButton(
                                            child: const Text(
                                              "Add Card",
                                            ),
                                            onPressed: () async {
                                              await showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AddCard(context, uid,
                                                        groupkeys, key);
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
            ],
          ),
        ),
      ),
    );
  }
}
