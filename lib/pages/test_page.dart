import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:memorise/components/test_cards.dart';
import 'package:memorise/providers/casdsdata.dart';
import 'package:provider/provider.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:switcher_button/switcher_button.dart';

class TestPage extends StatefulWidget {
  final List idlist;
  const TestPage({Key? key, required this.idlist}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  bool timer = true;
  bool random = true;
  int duration = 60;
  bool isready = false;
  String checkfor = 'all';
  final CarouselController _carouselController = CarouselController();
  List sortedidlist = [];

  Widget startTest() {
    return AlertDialog(
      title: const Center(child: Text("TestSetup")),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Random
            //SetTimer or not
            //Timer time
            //type of cards (all,easy,hard,medium,med-hard, med-easy,easy-hard)
            //max no of cards (Slider).
            //card type

            SizedBox(
              height: 30,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Shuffle:          "),
                  SwitcherButton(
                    size: 45,
                    value: true,
                    onColor: Colors.lightGreen,
                    offColor: Colors.deepOrange,
                    onChange: (value) {
                      random = value;
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 30,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Set timer:        "),
                  SwitcherButton(
                    size: 45,
                    value: true,
                    onColor: Colors.lightGreen,
                    offColor: Colors.deepOrange,
                    onChange: (value) {
                      timer = value;
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Duration"),
              ),
              controller: TextEditingController()..text = duration.toString(),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (val) {
                duration = int.parse(val);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            DropDown(
              items: const [
                'all',
                'new',
                'easy',
                'medium',
                'hard',
                'easy-medium',
                'medium-hard',
                'easy-hard'
              ],
              initialValue: checkfor,
              onChanged: (val) {
                checkfor = val.toString();
              },
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            child: const Text("Start Test"),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              setState(() {
                isready = true;
              });
            },
          ),
        )
      ],
    );
  }

  sorttest() {
    if (checkfor != "all") {
      if (checkfor == 'easy') {
        for (String v in widget.idlist) {
          var val = context.watch<AllCardsData>().getcardsnapshot(v);
          if (val != null) {
            if (val.get("preference") == 'easy') {
              sortedidlist.add(v);
            }
          }
        }
      } else if (checkfor == 'medium') {
        for (String v in widget.idlist) {
          var val = context.watch<AllCardsData>().getcardsnapshot(v);
          if (val != null) {
            if (val.get("preference") == 'medium') {
              sortedidlist.add(v);
            }
          }
        }
      } else if (checkfor == 'hard') {
        for (String v in widget.idlist) {
          var val = context.watch<AllCardsData>().getcardsnapshot(v);
          if (val != null) {
            if (val.get("preference") == 'hard') {
              sortedidlist.add(v);
            }
          }
        }
      } else if (checkfor == 'new') {
        for (String v in widget.idlist) {
          var val = context.watch<AllCardsData>().getcardsnapshot(v);
          if (val != null) {
            if (val.get("preference") == 'NA') {
              sortedidlist.add(v);
            }
          }
        }
      } else if (checkfor == 'easy-medium') {
        for (String v in widget.idlist) {
          var val = context.watch<AllCardsData>().getcardsnapshot(v);
          if (val != null) {
            if (val.get("preference") == 'easy' ||
                val.get("preference") == 'medium') {
              sortedidlist.add(v);
            }
          }
        }
      } else if (checkfor == 'medium-hard') {
        for (String v in widget.idlist) {
          var val = context.watch<AllCardsData>().getcardsnapshot(v);
          if (val != null) {
            if (val.get("preference") == 'hard' ||
                val.get("preference") == 'medium') {
              sortedidlist.add(v);
            }
          }
        }
      } else if (checkfor == 'easy-hard') {
        for (String v in widget.idlist) {
          var val = context.watch<AllCardsData>().getcardsnapshot(v);
          if (val != null) {
            if (val.get("preference") == 'easy' ||
                val.get("preference") == 'hard') {
              sortedidlist.add(v);
            }
          }
        }
      }
    } else {
      sortedidlist = widget.idlist;
    }

    if (random == true) {
      sortedidlist.shuffle();
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    CountDownController _controller = CountDownController();

    sorttest();

    return SafeArea(
      child: Scaffold(
        body: isready
            ? SizedBox(
                height: h,
                width: w,
                child: Column(
                  children: [
                    SizedBox(
                      height: h / 12,
                      width: w,
                      child: const Card(
                        child: Center(child: Text("Test Yourself")),
                      ),
                    ),
                    // For Timer and other details
                    SizedBox(
                      height: h / 12,
                      width: w,
                      child: timer
                          ? Center(
                              child: CircularCountDownTimer(
                                duration: duration,
                                initialDuration: 0,
                                controller: _controller,
                                width: MediaQuery.of(context).size.width / 2,
                                height: MediaQuery.of(context).size.height / 2,
                                ringColor: Colors.grey,
                                ringGradient: null,
                                fillColor: Colors.lightBlue,
                                fillGradient: const RadialGradient(
                                    colors: [Colors.blueGrey, Colors.blue]),
                                backgroundColor: Colors.blueGrey,
                                backgroundGradient: null,
                                strokeWidth: 10.0,
                                strokeCap: StrokeCap.round,
                                textStyle: const TextStyle(
                                    fontSize: 30.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textFormat: CountdownTextFormat.S,
                                isReverse: true,
                                isReverseAnimation: false,
                                isTimerTextShown: true,
                                autoStart: true,
                                onStart: () {
                                  print('Countdown Started');
                                },
                                onComplete: () {
                                  print('Countdown Ended');
                                },
                              ),
                            )
                          : const SizedBox(),
                    ),
                    // Ford card corosule
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                        height: 8 * h / 12,
                        width: 300,
                        child: widget.idlist.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CarouselSlider.builder(
                                  carouselController: _carouselController,
                                  itemCount: sortedidlist.length,
                                  itemBuilder: (context, index, index2) {
                                    var temp = context
                                        .watch<AllCardsData>()
                                        .getcardsnapshot(sortedidlist[index]);

                                    return temp != null
                                        ? GetTestCard(
                                            data: temp.data(), id: temp.id)
                                        : const Center(
                                            child: Text("Card Deleted"),
                                          );
                                  },
                                  options: CarouselOptions(
                                    height: 8 * h / 12,
                                    viewportFraction: 1,
                                    enableInfiniteScroll: false,
                                  ),
                                ),
                              )
                            : const Center(
                                child: Text("No Cards Available for testing."),
                              ),
                      ),
                    ),
                    // For buttons and all.
                    SizedBox(
                      width: w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _carouselController.previousPage();
                            },
                            child: const Text("Previous"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _carouselController.nextPage();
                            },
                            child: const Text("next"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return startTest();
                          });
                    },
                    child: const Text("Test Setup")),
              ),
      ),
    );
  }
}
