import 'package:account_book/Constant/TextStyles/Textstyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Credit_Score extends StatefulWidget {
  final id;
  Credit_Score({Key? key, this.id}) : super(key: key);

  @override
  State<Credit_Score> createState() => _Credit_ScoreState();
}

class _Credit_ScoreState extends State<Credit_Score> {
  double total_amount_gave = 0;
  double total_amount_got = 0;
  var role;
  double total_amount = 0;
  double score = 0;
  double total_per = 0;

  @override
  void initState() {
    calvulatescroe();
    super.initState();
  }

  calvulatescroe() async {
    await get_gave_total('Entry', widget.id);
    await get_got_total('Entry', widget.id);
    getscore();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                Text(
                  "Credit Score",
                  style: TextStyles.mb18,
                )
              ])),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total give", style: TextStyles.mb14),
                        Text(
                          total_amount_gave.toString(),
                          style:
                              TextStyles.withColor(TextStyles.mb16, Colors.red),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total got", style: TextStyles.mb14),
                        Text(
                          total_amount_got.toString(),
                          style: TextStyles.withColor(
                              TextStyles.mb16, Colors.green),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total you will get", style: TextStyles.mb14),
                        Text(
                          total_amount.toString(),
                          style:
                              TextStyles.withColor(TextStyles.mb16, Colors.red),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                  child: SfRadialGauge(axes: <RadialAxis>[
                RadialAxis(minimum: 0, maximum: 900, ranges: <GaugeRange>[
                  GaugeRange(startValue: 0, endValue: 300, color: Colors.red),
                  GaugeRange(
                      startValue: 300, endValue: 600, color: Colors.orange),
                  GaugeRange(
                      startValue: 600, endValue: 900, color: Colors.green)
                ], pointers: <GaugePointer>[
                  NeedlePointer(value: score)
                ], annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                      widget: Container(
                          child: Text(score.round().toString(),
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold))),
                      angle: 90,
                      positionFactor: 0.5)
                ])
              ])),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "your credit Score ",
                    style: TextStyles.mb18,
                  ),
                  score <= 300
                      ? Text(
                          score.round().toStringAsFixed(0),
                          style:
                              TextStyles.withColor(TextStyles.mb20, Colors.red),
                        )
                      : score <= 600
                          ? Text(
                              score.round().toStringAsFixed(0),
                              style: TextStyles.withColor(
                                  TextStyles.mb20, Colors.orange),
                            )
                          : Text(
                              score.round().toStringAsFixed(0),
                              style: TextStyles.withColor(
                                  TextStyles.mb20, Colors.green),
                            ),
                ],
              ),
            ],
          )),
    );
  }

  get_gave_total(tablename, id) async {
    List fetchdata_gave = [];
    setState(() {
      total_amount_gave = 0;
      fetchdata_gave.clear();
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role');
    });
    setState(() {
      fetchdata_gave.clear();
    });
    print("role" + role.toString());
    if (role == "collector") {
      FirebaseFirestore.instance
          .collection(tablename)
          .where('user_id', isEqualTo: id.toString())
          .where('type', isEqualTo: "0")
          .get()
          .then((QuerySnapshot querySnapshot) {
        {
          querySnapshot.docs.forEach((element) {
            setState(() {
              fetchdata_gave.add(element.data());
            });
          });

          print(fetchdata_gave.length);

          if (fetchdata_gave.length == 0) {
            print("hii");
          } else
            for (var i = 0; i < fetchdata_gave.length; i++) {
              total_amount_gave =
                  double.parse(fetchdata_gave[i]['amount']) + total_amount_gave;
            }
        }
      });
    } else {
      FirebaseFirestore.instance
          .collection(tablename)
          .where('user_id', isEqualTo: id.toString())
          .where('type', isEqualTo: "0")
          .where('status', isEqualTo: "1")
          .get()
          .then((QuerySnapshot querySnapshot) {
        {
          querySnapshot.docs.forEach((element) {
            setState(() {
              fetchdata_gave.add(element.data());
            });
          });

          print(fetchdata_gave.length);

          if (fetchdata_gave.length == 0) {
            print("hii");
          } else
            for (var i = 0; i < fetchdata_gave.length; i++) {
              total_amount_gave =
                  double.parse(fetchdata_gave[i]['amount']) + total_amount_gave;
            }
        }
      });
    }
  }

  get_got_total(tablename, id) async {
    List fetchdata_got = [];
    setState(() {
      fetchdata_got.clear();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role');
    });
    setState(() {
      fetchdata_got.clear();
    });
    if (role == "collector") {
      FirebaseFirestore.instance
          .collection(tablename)
          .where('user_id', isEqualTo: id.toString())
          .where('type', isEqualTo: "1")
          .get()
          .then((QuerySnapshot querySnapshot) {
        {
          querySnapshot.docs.forEach((element) {
            setState(() {
              fetchdata_got.add(element.data());
            });
          });
          if (fetchdata_got.length == 0) {
            print("hii");
          } else
            for (var i = 0; i < fetchdata_got.length; i++) {
              setState(() {
                total_amount_got =
                    double.parse(fetchdata_got[i]['amount']) + total_amount_got;
              });
            }
        }
      });
    } else {
      FirebaseFirestore.instance
          .collection(tablename)
          .where('user_id', isEqualTo: id.toString())
          .where('type', isEqualTo: "1")
          .where('status', isEqualTo: "1")
          .get()
          .then((QuerySnapshot querySnapshot) {
        {
          querySnapshot.docs.forEach((element) {
            setState(() {
              fetchdata_got.add(element.data());
            });
          });
          if (fetchdata_got.length == 0) {
            print("hii");
          } else
            for (var i = 0; i < fetchdata_got.length; i++) {
              setState(() {
                total_amount_got =
                    double.parse(fetchdata_got[i]['amount']) + total_amount_got;
              });
            }
        }
      });
    }
  }

  getscore() {
    total_amount = total_amount_gave - total_amount_got;
    total_per = total_amount_gave / total_amount_got;
    score = 900 / total_per;
  }
}
