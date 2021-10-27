import 'package:flutter/material.dart';
import 'package:memorise/components/sharedcard_listtile.dart';
import 'package:memorise/providers/sharedcards_provider.dart';
import 'package:memorise/providers/userdata_provider.dart';
import 'package:provider/provider.dart';

class SharedCardsPage extends StatefulWidget {
  const SharedCardsPage({Key? key}) : super(key: key);

  @override
  _SharedCardsPageState createState() => _SharedCardsPageState();
}

class _SharedCardsPageState extends State<SharedCardsPage> {
  @override
  Widget build(BuildContext context) {
    List sharedcards = context.watch<SharedCards>().doclist;
    print(sharedcards);
    print(sharedcards.length);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shared cards"),
      ),
      body: sharedcards.length == 0 || sharedcards == null
          ? const Center(
              child: Text("No data vailable"),
            )
          : ListView.separated(
              itemCount: sharedcards.length,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 20,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return SharedCardListTile(
                    data: sharedcards[index].data(),
                    cardid: sharedcards[index].id);
              },
            ),
    );
  }
}
