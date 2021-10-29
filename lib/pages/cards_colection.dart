import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:memorise/components/admob_helper.dart';
import 'package:memorise/components/card_listtile.dart';
import 'package:memorise/components/create_card.dart';
import 'package:memorise/providers/casdsdata.dart';
import 'package:memorise/providers/userdata_provider.dart';
import 'package:memorise/providers/userstate_provider.dart';
import 'package:provider/provider.dart';

class CardsList extends StatefulWidget {
  final List cardkeylist;
  final String groupname;
  CardsList({Key? key, required this.cardkeylist, required this.groupname})
      : super(key: key);

  @override
  CardsListState createState() => CardsListState();
}

class CardsListState extends State<CardsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allCardslist = context.watch<AllCardsData>().doclist;
    List<QueryDocumentSnapshot<Map<String, dynamic>>> datalist = [];
    final userdata = context.watch<UserData>().data;
    final groupslist = userdata!["groups"].keys.toList();
    if (widget.cardkeylist.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.groupname),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await showDialog(
                context: context,
                builder: (context) {
                  return addCard(
                      context, userdata["uid"], groupslist, widget.groupname);
                });
          },
          child: Icon(Icons.add),
        ),
        body: const Center(
          child: Text("Empty"),
        ),
      );
    }

    for (String v in widget.cardkeylist) {
      QueryDocumentSnapshot<Map<String, dynamic>>? temp =
          context.watch<AllCardsData>().getcardsnapshot(v);
      if (temp != null) {
        datalist.add(temp);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupname),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (context) {
                return addCard(
                    context, userdata["uid"], groupslist, widget.groupname);
              });
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: Theme.of(context).brightness == Brightness.light
                  ? AssetImage("assets/day_background.jpg")
                  : AssetImage("assets/night_background.jpg"),
              fit: BoxFit.cover),
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 1,
              child: ListView.separated(
                itemCount: datalist.length,
                itemBuilder: (BuildContext context, int index) {
                  return CardListTile(
                    data: datalist[index].data(),
                    cardid: datalist[index].id,
                    groupname: widget.groupname,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  if ((index + 3) % 5 == 0) {
                    return AdmobHelper.OtherpageAdWidgetInlist();
                  }
                  return SizedBox();
                },
              ),
            ),
            AdmobHelper.OtherpageAdWidget(),
          ],
        ),
      ),
    );
  }
}
