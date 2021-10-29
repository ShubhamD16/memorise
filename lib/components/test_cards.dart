import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:memorise/components/toast_comp.dart';

class GetTestCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final String id;
  const GetTestCard({Key? key, required this.data, required this.id})
      : super(key: key);

  @override
  _GetTestCardState createState() => _GetTestCardState();
}

class _GetTestCardState extends State<GetTestCard> {
  bool open = false;

  Widget type1(Map<String, dynamic> data) {
    return FlipCard(
      back: Card(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                data["imgurl"] != "NA"
                    ? SizedBox(
                        height: 4 * MediaQuery.of(context).size.height / 12,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: data["imgurl"],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(
                        height: 30,
                      ),
                const SizedBox(
                  height: 10,
                ),
                Text(data["description"]),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
      front: const Card(
        child: Center(
          child: Icon(Icons.visibility_off),
        ),
      ),
    );
  }

  Widget type2(Map<String, dynamic> data) {
    return FlipCard(
      back: Card(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  color: data["ans1"] ? Colors.greenAccent : null,
                  child: ListTile(
                    tileColor: Colors.transparent,
                    title: Center(
                      child: Text(
                        data["op1"],
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: data["ans2"] ? Colors.greenAccent : null,
                  child: ListTile(
                    tileColor: Colors.transparent,
                    title: Center(
                      child: Text(
                        data["op2"],
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: data["ans3"] ? Colors.greenAccent : null,
                  child: ListTile(
                    tileColor: Colors.transparent,
                    title: Center(
                      child: Text(
                        data["op3"],
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: data["ans4"] ? Colors.greenAccent : null,
                  child: ListTile(
                    tileColor: Colors.transparent,
                    title: Center(
                      child: Text(
                        data["op4"],
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      front: Card(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  child: ListTile(
                    tileColor: Colors.transparent,
                    title: Center(
                      child: Text(
                        data["op1"],
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    tileColor: Colors.transparent,
                    title: Center(
                      child: Text(
                        data["op2"],
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    tileColor: Colors.transparent,
                    title: Center(
                      child: Text(
                        data["op3"],
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    tileColor: Colors.transparent,
                    title: Center(
                      child: Text(
                        data["op4"],
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget gettype(String i, Map<String, dynamic> data) {
    if (i == '1') {
      return type1(data);
    } else if (i == '2') {
      return type2(data);
    } else {
      print("No card of typr $i");
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 120),
              child: Card(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          widget.data["lable"],
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 25),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              thickness: 3,
              height: 1,
              color: Colors.black38,
            ),
            Expanded(
              flex: 1,
              child: gettype(widget.data["type"], widget.data),
            ),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: widget.data["preference"] == "easy"
                              ? Colors.green
                              : Theme.of(context).primaryColor),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection("cards")
                            .doc(widget.id)
                            .update({"preference": "easy"}).whenComplete(() {
                          ToastSucessful("Data updated.");
                        });
                      },
                      child: const Center(child: Text("EASY")),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: widget.data["preference"] == "medium"
                              ? Colors.green
                              : Theme.of(context).primaryColor),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection("cards")
                            .doc(widget.id)
                            .update({"preference": "medium"}).whenComplete(() {
                          ToastSucessful("Data updated.");
                        });
                      },
                      child: const Text("MEDIUM"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: widget.data["preference"] == "hard"
                              ? Colors.green
                              : Theme.of(context).primaryColor),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection("cards")
                            .doc(widget.id)
                            .update({"preference": "hard"}).whenComplete(() {
                          ToastSucessful("Data updated.");
                        });
                      },
                      child: const Text("HARD"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
