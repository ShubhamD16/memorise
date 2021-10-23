import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CardListTile extends StatefulWidget {
  final Map<String, dynamic> data;
  final String cardid;
  const CardListTile({Key? key, required this.data, required this.cardid})
      : super(key: key);

  @override
  _CardListTileState createState() => _CardListTileState();
}

class _CardListTileState extends State<CardListTile> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionExtentRatio: 0.2,
      actionPane: const SlidableDrawerActionPane(),
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
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              ),
              const Divider(
                height: 10,
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: expanded ? 300 : 0,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      widget.data["imgurl"] != "NA"
                          ? SizedBox(
                              height: 200,
                              child: CachedNetworkImage(
                                imageUrl: widget.data["imgurl"],
                                placeholder: (context, s) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
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
                  ),
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
