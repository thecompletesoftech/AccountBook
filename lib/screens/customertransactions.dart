import 'dart:ffi';

import 'package:account_book/screens/Credit_Score.dart';
import 'package:account_book/screens/Customer_profile.dart';
import 'package:account_book/screens/MoneyGotScreen.dart';
import 'package:account_book/screens/homescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_range_picker_flutter/date_range_picker_flutter.dart';

import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constant/TextStyles/Textstyles.dart';
import '../Constant/navigaotors/Navagate_Next.dart';
import '../insertdatamodel.dart';
import 'Edit_Entry.dart';
import 'MoneyGaveScreen.dart';

class Customertransaction extends StatefulWidget {
  final Contact? contact;
  final String? name;
  final iscustomer;
  final mobile_no;
  final String? id;
  final p_image;
  final address;
  final token;
  final searchtxt;

  Customertransaction({
    Key? key,
    this.contact,
    this.iscustomer,
    this.id,
    this.name,
    this.mobile_no,
    this.p_image,
    this.address,
    this.token,
    this.searchtxt,
  }) : super(key: key);

  @override
  State<Customertransaction> createState() => _CustomertransactionState();
}

class _CustomertransactionState extends State<Customertransaction> {
  var entry_data = [];
  double total_amount_gave = 0;
  double total_amount_got = 0;
  double total_amount = 0;
  List datelist = [];
  DateTime? startdate;
  DateTime? enddate;
  List gotdate = [];
  List entry_data_id = [];
  int totaldue = 0;
  String? role;
  List gotdates = [];
  bool showloading = false;
  List got = [];
  List filter_data = [];

  DateTime _currentDate = DateTime(DateTime.now().year.toInt(),
      DateTime.now().month.toInt(), DateTime.now().day.toInt());

  DateTime _currentDate2 = DateTime(DateTime.now().year.toInt(),
      DateTime.now().month.toInt(), DateTime.now().day.toInt());

  DateTime _targetDateTime = DateTime(DateTime.now().year.toInt(),
      DateTime.now().month.toInt(), DateTime.now().day.toInt());

  String _currentMonth = DateFormat.yMMM().format(DateTime(
      DateTime.now().year.toInt(),
      DateTime.now().month.toInt(),
      DateTime.now().day.toInt()));

  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.green, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.green,
    ),
  );

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {},
  );

  @override
  void initState() {
    // print("hii searchdata" + widget.searchtxt.toString());
    // print("hii customer or not" + widget.iscustomer.toString());
    // print("adress" + widget.address.toString());
    // print('u_id' + widget.id.toString());
    // print('u_id for token' + widget.token.toString());
    // print("p_image" + widget.p_image);
    _getdata("Entry", widget.id);
    get_gave_total("Entry", widget.id);
    get_got_total("Entry", widget.id);
    updatetotaluserwillget();
    super.initState();
  }

  updatetotaluserwillget() async {
    double userwillget =
        await Provider.of<Insetdatamodel>(context, listen: false)
            .get_total_Userwillget(widget.id);

    await Provider.of<Insetdatamodel>(context, listen: false)
        .updatecustomertable(
            collectionname: "customer_record",
            id: widget.id,
            jsondata: {"youllgetamount": userwillget});
  }

  @override
  Widget build(BuildContext context) {
    if (totaldue < 0) {
      setState(() {
        totaldue = 0;
      });
    }
    total_amount = total_amount_gave - total_amount_got;

    var size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () =>
                    // backScreen(context)
                    nextScreen(
                        context, HomeScreen(searchtxt: widget.searchtxt))),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      widget.contact == null
                          ? CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.blueGrey,
                              child: widget.p_image == " "
                                  ? Text(
                                      widget.name!.split('').first.toString())
                                  : Container(
                                      width: 100,
                                      height: 110,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.blueGrey,
                                          ),
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                              widget.p_image,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100))),
                                    ),
                            )
                          : CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.blueGrey,
                              child: widget.p_image == " "
                                  ? Text(widget.contact!.displayName
                                      .split('')
                                      .first
                                      .toString())
                                  : Container(
                                      width: 100,
                                      height: 110,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.blueGrey,
                                          ),
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                              widget.p_image,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100))),
                                    ),
                            ),
                      SizedBox(width: 10),
                      widget.contact == null
                          ? Expanded(
                              child: Text(
                                widget.name.toString(),
                                style: TextStyles.mb14,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          : Expanded(
                              child: Text(
                                widget.contact!.displayName.toString(),
                                maxLines: 2,
                                style: TextStyles.mb14,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    widget.contact == null
                        ? GestureDetector(
                            onTap: () {
                              _callNumber(widget.mobile_no);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Icon(
                                Icons.call,
                                size: 20,
                              ),
                            ))
                        : GestureDetector(
                            onTap: () {
                              _callNumber(widget.contact!.phones.first.number);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Icon(
                                Icons.call,
                                size: 20,
                              ),
                            )),
                    role != 'collector'
                        ? GestureDetector(
                            onTap: () {
                              nextScreen(
                                  context,
                                  Customer_profile(
                                      name: widget.contact == null
                                          ? widget.name
                                          : widget.contact!.displayName,
                                      mobile_no: widget.contact == null
                                          ? widget.mobile_no
                                          : widget.contact!.phones.first.number,
                                      p_image: widget.p_image,
                                      id: widget.id,
                                      address: widget.address));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Icon(
                                Icons.more_vert,
                                size: 20,
                              ),
                            ),
                          )
                        : Container(),
                    GestureDetector(
                      onTap: () {
                        showCustomRangePicker();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Icon(
                          Icons.filter_alt_outlined,
                          size: 20,
                        ),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     nextScreen(context, Credit_Score(id: widget.id));
                    //   },
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(left: 5, right: 5),
                    //     child: Image.asset("image/Credit_Score.png",
                    //         height: 30, width: 30),
                    //   ),
                    // )
                  ],
                )
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: size.height * 0.07,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "You will get",
                            style: TextStyles.mb16,
                          ),
                          Text(
                            "\u{20B9} " + total_amount.toString(),
                            style: TextStyles.withColor(
                                TextStyles.mb14, Colors.red),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text('\u{20B9} ' + total_amount_gave.toString(),
                                    style: TextStyles.withColor(
                                        TextStyles.mb20, Colors.red)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("you  Got",
                                    style: TextStyles.withColor(
                                        TextStyles.mn14, Colors.red))
                              ],
                            ),
                            VerticalDivider(
                              width: 5,
                              color: Colors.black,
                              thickness: 2,
                            ),
                            Column(
                              children: [
                                Text('\u{20B9} ' + total_amount_got.toString(),
                                    style: TextStyles.withColor(
                                        TextStyles.mb20, Colors.green)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("you  Gave",
                                    style: TextStyles.withColor(
                                        TextStyles.mn14, Colors.green))
                              ],
                            ),
                          ],
                        ),
                        // Divider(),
                        // GestureDetector(
                        //   onTap: () {
                        //     // nextScreen(context, ViewReport());
                        //   },
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: Text("View Report",
                        //             style: TextStyles.withColor(
                        //                 TextStyles.mb14, Colors.black)),
                        //       ),
                        //       SizedBox(width: 10),
                        //       Icon(
                        //         Icons.arrow_forward_ios_outlined,
                        //         size: 15,
                        //       )
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: size.height * 0.07,
                  child: GestureDetector(
                    onTap: () {
                      due_daye_bottomsheet();
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Due Days",
                              style: TextStyles.mb16,
                            ),
                            Text(
                              totaldue.toString(),
                              style: TextStyles.withColor(
                                  TextStyles.mb14, Colors.red),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ENTRIES",
                        style: TextStyles.mb12,
                      ),
                      Container(
                        width: size.width * 0.4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "You Gave",
                              style: TextStyles.withColor(
                                  TextStyles.mb12, Colors.red),
                            ),
                            Text(
                              "You GOT",
                              style: TextStyles.withColor(
                                  TextStyles.mb12, Colors.green),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                if (showloading == true)
                  Center(child: CircularProgressIndicator()),
                if (entry_data.length == 0 && showloading == false)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                        child: Text(
                      "NO DATA FOUND",
                      style: TextStyles.mb14,
                    )),
                  ),
                Container(
                  height: size.height * 0.45,
                  child: ListView.builder(
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: entry_data.length,
                      itemBuilder: (BuildContext context, int index) {
                        // print("entry_id" + entry_data_id[index].toString());
                        // print("name" + widget.name.toString());
                        entry_data
                            .sort((b, a) => a['timespam'].compareTo(b['timespam']));
                        return GestureDetector(
                          onTap: () {
                            if (role == "collector") {
                              if (entry_data[index]['status'] == "0") {
                                widget.contact == null
                                    ? nextScreen(
                                        context,
                                        Edit_Entry(
                                            u_id: entry_data[index]['user_id'],
                                            des: entry_data[index]
                                                ['description'],
                                            p_image: widget.p_image,
                                            name: widget.name,
                                            contact: null,
                                            amount: entry_data[index]['amount'],
                                            type: entry_data[index]['type'],
                                            mobile_no: widget.mobile_no,
                                            entry_id: entry_data[index]['entryid']))
                                    : nextScreen(
                                        context,
                                        Edit_Entry(
                                            u_id: entry_data[index]['user_id'],
                                            des: entry_data[index]
                                                ['description'],
                                            p_image: widget.p_image,
                                            name: widget.contact!.displayName,
                                            contact: widget.contact,
                                            amount: entry_data[index]['amount'],
                                            type: entry_data[index]['type'],
                                            mobile_no: widget.mobile_no,
                                            entry_id: entry_data[index]['entryid']));
                              }
                            } else if (role == "admin") {
                              if (entry_data[index]['status'] == "1") {
                                widget.contact == null
                                    ? nextScreen(
                                        context,
                                        Edit_Entry(
                                            u_id: entry_data[index]['user_id'],
                                            des: entry_data[index]
                                                ['description'],
                                            p_image: widget.p_image,
                                            name: widget.name,
                                            contact: null,
                                            amount: entry_data[index]['amount'],
                                            type: entry_data[index]['type'],
                                            date: entry_data[index]['date'],
                                            timestamp: entry_data[index]['timespam'],
                                            mobile_no: widget.mobile_no,
                                            entry_id: entry_data[index]['entryid']))
                                    : nextScreen(
                                        context,
                                        Edit_Entry(
                                            u_id: entry_data[index]['user_id'],
                                            des: entry_data[index]
                                                ['description'],
                                            p_image: widget.p_image,
                                            name: widget.contact!.displayName,
                                            contact: widget.contact,
                                            amount: entry_data[index]['amount'],
                                            type: entry_data[index]['type'],
                                            date: entry_data[index]['date'],
                                            timestamp: entry_data[index]['timespam'],
                                            mobile_no: widget.mobile_no,
                                            entry_id: entry_data[index]['entryid']));
                              }
                            }
                          },
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: size.width * 0.3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            DateFormat('dd-MM-yyyy').format(
                                                DateTime.parse(entry_data[index]
                                                        ['date']
                                                    .toString())),
                                            maxLines: 2,
                                            style: TextStyles.mn12,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          entry_data[index]['description'] !=
                                                  " "
                                              ? Text(
                                                  entry_data[index]
                                                          ['description']
                                                      .toString(),
                                                  style: TextStyles.mn12,
                                                )
                                              : Text(
                                                  "No Description",
                                                  style: TextStyles.mn12,
                                                )
                                        ],
                                      )),
                                  entry_data[index]['type'] == "0"
                                      ? Text(
                                          entry_data[index]['amount']
                                              .toString(),
                                          style: TextStyles.withColor(
                                              TextStyles.mb12, Colors.red),
                                        )
                                      : Container(),
                                  entry_data[index]['type'] == "1"
                                      ? Text(
                                          entry_data[index]['amount']
                                              .toString(),
                                          style: TextStyles.withColor(
                                              TextStyles.mb12, Colors.green),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              role == "collector"
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        nextScreen(
                            context,
                            MoneyGaveScreen(
                                // ignore: unnecessary_null_comparison
                                name: widget.contact == null
                                    ? widget.name.toString()
                                    : widget.contact!.displayName,
                                mobile_no: widget.contact == null
                                    ? widget.mobile_no
                                    : widget.contact!.phones.first.number
                                        .replaceAll(" ", '')
                                        .toString()
                                        .replaceAll("+91", ''),
                                iscustomer: widget.iscustomer,
                                u_id: widget.id,
                                p_image: widget.p_image,
                                token: widget.token));
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          height: size.height * 0.05,
                          alignment: Alignment.bottomCenter,
                          child: Center(
                              child: Text(
                            "You Gave  " + '\u{20B9} ',
                            style: TextStyles.withColor(
                                TextStyles.mb16, Colors.white),
                          ))),
                    ),
              SizedBox(width: 10),
              GestureDetector(
                  onTap: (() {
                    nextScreen(
                        context, HomeScreen(searchtxt: widget.searchtxt));
                  }),
                  child: Container(
                      width: 50,
                      child: Icon(
                        Icons.arrow_circle_left,
                        size: 45,
                      ))),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  nextScreen(
                      context,
                      MoneyGotScreen(
                          // ignore: unnecessary_null_comparison
                          name: widget.contact == null
                              ? widget.name.toString()
                              : widget.contact!.displayName,
                          mobile_no: widget.contact == null
                              ? widget.mobile_no
                              : widget.contact!.phones.first.number
                                  .replaceAll(" ", '')
                                  .toString()
                                  .replaceAll("+91", ''),
                          iscustomer: widget.iscustomer,
                          u_id: widget.id,
                          p_image: widget.p_image,
                          token: widget.token));
                },
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    height: size.height * 0.05,
                    child: Center(
                        child: Text(
                      "  You Got  " + '\u{20B9} ',
                      style:
                          TextStyles.withColor(TextStyles.mb16, Colors.white),
                    ))),
              ),
            ],
          ),
        ));
  }

  List itemsBetweenDates({
    required List dates,
    required List items,
    required DateTime start,
    required DateTime end,
  }) {
    print("date lenth" + dates.length.toString());
    print('item lenth' + items.length.toString());

    assert(dates.length == items.length);

    var dateFormat = DateFormat('y-MM-dd');

    List output = [];
    for (var i = 0; i < dates.length; i += 1) {
      var date = dateFormat.parse(dates[i]);

      print("all date" + date.toString());

      if (date.compareTo(start) >= 0 && date.compareTo(end) <= 0) {
        output.add(items[i]);
        print("data" + output.toString());
      }
    }

    setState(() {
      filter_data = output;
      entry_data = filter_data;
      datelist.clear();
    });

    return output;
  }

  showCustomRangePicker() async {
    filter_data = [];
    entry_data = [];

    // getlistdata();
    _get_data_for_filter();
    total_amount_gave = 0;
    total_amount_got = 0;
    // if (entry_data.length <= 0) {
    //   _getdata("Entry", widget.id);
    // }

    var res = await showTCRDateRangePicker(
      context: context,
      selectRange: CustomDateTimeRange(),
      validRange:
          CustomDateTimeRange(start: DateTime(2022, 1), end: DateTime(2023, 7)),
    );
    if (res != null) {
      setState(() {
        startdate = res.start;
        enddate = res.end;
      });
      print('res = ${res.start} => ${res.end}');
      itemsBetweenDates(
          dates: datelist,
          items: filter_data,
          start: startdate!,
          end: enddate!);
    }

    // print("data filter" + entry_data.toString());

    // for total ------------

    List fetchdata_gave =
        entry_data.where((element) => element['type'] == "0").toList();
    print('fetchdata' + fetchdata_gave.toString());
    List fetchdata_got =
        entry_data.where((element) => element['type'] == "1").toList();
    print('fetchdata got' + fetchdata_got.toString());

    for (int i = 0; i < fetchdata_gave.length; i++)
      total_amount_gave = double.parse(fetchdata_gave[i]['amount'].toString()) +
          total_amount_gave;

    print("total gave f" + total_amount_gave.toString());

    for (int i = 0; i < fetchdata_got.length; i++) {
      total_amount_got =
          double.parse(fetchdata_got[i]['amount']) + total_amount_got;
    }
    print("total got" + total_amount_gave.toString());

    setState(() {
      total_amount = total_amount_gave - total_amount_got;
    });
    print("data tt" + total_amount.toString());
  }

  getlistdata() {
    setState(() {
      datelist = filter_data.map((e) => e['date'].toString()).toList();
      print(datelist);
    });
  }

  _getdata(tablename, id) async {
    entry_data.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role');
    });
    print("role" + role.toString());

    if (role == "collector") {
      setState(() {
        showloading = true;
      });
      print("this is a collector");
      FirebaseFirestore.instance
          .collection(tablename)
          .where('user_id', isEqualTo: id.toString())
          .get()
          .then((QuerySnapshot querySnapshot) {
        {
          querySnapshot.docs.forEach((element) {
            print("data" + element.data().toString());
            setState(() {
              entry_data.add(element.data());
              entry_data_id.add(element.id);
            });
          });
          setState(() {
            got =
                entry_data.where((element) => element['type'] == "1").toList();
          });

          print("data" + got.toString());

          List firstdata = [];

          FirebaseFirestore.instance
              .collection("Entry")
              .where('user_id', isEqualTo: widget.id)
              .where('status', isEqualTo: "1")
              .orderBy("date", descending: false)
              .limit(1)
              .get()
              .then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((element) {
              setState(() {
                firstdata.add(element.data());
              });
            });

            for (int i = 0; i < got.length; i++) {
              setState(() {
                gotdates.add(got[i]['date'].toString());
              });
            }
            print("gotdates" + gotdates.toString());

            DateTime tempDate =
                DateFormat("yyyy-MM-dd").parse(firstdata[0]['date']);
            print("tmpdate" + tempDate.toString());

            final firstdate =
                DateTime(tempDate.year, tempDate.month, tempDate.day);
            final date2 = DateTime.now();
            final difference = date2.difference(firstdate).inDays;

            setState(() {
              totaldue = difference - got.length;
            });

            print("totaldue" + totaldue.toString());
            print("defference" + difference.toString());
            print("data" + firstdata.toString());

            List<DateTime> days = [];
            for (int i = 0;
                i <= DateTime.now().difference(tempDate).inDays;
                i++) {
              setState(() {
                days.add(tempDate.add(Duration(days: i)));
              });
            }
            print("data days" + days.toString());

            for (var i = 0; i < gotdates.length; i++) {
              setState(() {
                _markedDateMap.add(
                    new DateTime(
                        int.parse(
                            gotdates[i].toString().split("-")[0].toString()),
                        int.parse(
                            gotdates[i].toString().split("-")[1].toString()),
                        int.parse(
                            gotdates[i].toString().split("-")[2].toString())),
                    new Event(
                      date: new DateTime(
                          int.parse(
                              gotdates[i].toString().split("-")[0].toString()),
                          int.parse(
                              gotdates[i].toString().split("-")[1].toString()),
                          int.parse(
                              gotdates[i].toString().split("-")[2].toString())),
                      title: 'Event 5',
                      icon: _eventIcon,
                    ));
              });
            }
          });

          setState(() {
            showloading = false;
          });
        }
      });
    } else {
      setState(() {
        showloading = true;
      });
      FirebaseFirestore.instance
          .collection(tablename)
          .where('user_id', isEqualTo: id.toString())
          .where('status', isEqualTo: "1")
          .orderBy("date", descending: true)
          .get()
          .then((QuerySnapshot querySnapshot) {
        {
          querySnapshot.docs.forEach((element) {
            setState(() {
              entry_data.add(element.data());
              entry_data_id.add(element.id);
            });
          });

          print('data of enty' + entry_data.toString());

          setState(() {
            got =
                entry_data.where((element) => element['type'] == "1").toList();
          });

          List firstdata = [];

          FirebaseFirestore.instance
              .collection("Entry")
              .where('user_id', isEqualTo: widget.id)
              .where('status', isEqualTo: "1")
              .orderBy("date", descending: false)
              .limit(1)
              .get()
              .then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((element) {
              setState(() {
                firstdata.add(element.data());
              });
            });

            print("got length" + got.length.toString());

            for (int i = 0; i < got.length; i++) {
              setState(() {
                gotdates.add(got[i]['date'].toString());
              });
            }
            print("gotdates" + gotdates.toString());

            DateTime tempDate =
                DateFormat("yyyy-MM-dd").parse(firstdata[0]['date']);

            final firstdate =
                DateTime(tempDate.year, tempDate.month, tempDate.day);

            final date2 = DateTime.now();
            final difference = date2.difference(firstdate).inDays;
            setState(() {
              totaldue = difference - got.length;
            });

            print("totaldue" + totaldue.toString());
            print("defference" + difference.toString());
            print("data" + firstdata.toString());

            List<DateTime> days = [];
            for (int i = 0;
                i <= DateTime.now().difference(tempDate).inDays;
                i++) {
              days.add(tempDate.add(Duration(days: i)));
            }
            print("data days" + days.toString());

            for (var i = 0; i < gotdates.length; i++) {
              setState(() {
                _markedDateMap.add(
                    new DateTime(
                        int.parse(
                            gotdates[i].toString().split("-")[0].toString()),
                        int.parse(
                            gotdates[i].toString().split("-")[1].toString()),
                        int.parse(
                            gotdates[i].toString().split("-")[2].toString())),
                    new Event(
                      date: new DateTime(
                          int.parse(
                              gotdates[i].toString().split("-")[0].toString()),
                          int.parse(
                              gotdates[i].toString().split("-")[1].toString()),
                          int.parse(
                              gotdates[i].toString().split("-")[2].toString())),
                      title: 'Event 5',
                      icon: _eventIcon,
                    ));
              });
            }
          });
          setState(() {
            showloading = false;
          });
        }
      });

      // for due dates----------------
    }
  }

  _get_data_for_filter() {
    if (role == "collector") {
      FirebaseFirestore.instance
          .collection("Entry")
          .where('user_id', isEqualTo: widget.id.toString())
          .orderBy("date", descending: false)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            filter_data.add(element.data());
            // filter_data.add(element.id);
          });
        });
        print('filter data' + filter_data.toString());
        getlistdata();
      });
    }

    FirebaseFirestore.instance
        .collection("Entry")
        .where('user_id', isEqualTo: widget.id.toString())
        .where('status', isEqualTo: "1")
        .orderBy("date", descending: false)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        setState(() {
          filter_data.add(element.data());
          // filter_data.add(element.id);
        });
      });
      print('filter data' + filter_data.toString());
      getlistdata();
    });
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
            for (var i = 0; i <= fetchdata_gave.length; i++) {
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
      total_amount_got = 0;
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
            for (var i = 0; i <= fetchdata_got.length; i++) {
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
              print("amount fetch amount" +
                  fetchdata_got[i]['amount'].toString());
              setState(() {
                total_amount_got =
                    double.parse(fetchdata_got[i]['amount']) + total_amount_got;
              });
            }
        }
      });
    }
  }

  due_daye_bottomsheet() {
    var size = MediaQuery.of(context).size;
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            Container(
                padding: const EdgeInsets.only(left: 25, top: 25, bottom: 25),
                child: Text(
                  "Payment Days",
                  style: TextStyles.mb18,
                )),
            Container(
                padding: EdgeInsets.only(
                  left: 25,
                  right: 25,
                ),
                height: size.height * 0.45,
                child: CalendarCarousel<Event>(
                  todayBorderColor: Colors.green,

                  onDayPressed: (date, events) {
                    this.setState(() => _currentDate2 = date);
                    events.forEach((event) => print(event.title));
                  },
                  daysHaveCircularBorder: true,
                  showOnlyCurrentMonthDate: false,
                  weekendTextStyle: TextStyle(color: Colors.black),
                  thisMonthDayBorderColor: Colors.grey,
                  weekFormat: false,
                  //      firstDayOfWeek: 4,
                  markedDatesMap: _markedDateMap,
                  height: 420.0,
                  selectedDateTime: _currentDate2,
                  targetDateTime: _targetDateTime,
                  customGridViewPhysics: NeverScrollableScrollPhysics(),

                  markedDateCustomShapeBorder:
                      CircleBorder(side: BorderSide(color: Colors.green)),
                  markedDateCustomTextStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.green,
                  ),
                  showHeader: false,
                  todayTextStyle: TextStyle(
                    color: Colors.blue,
                  ),
                  // markedDateShowIcon: true,
                  // markedDateIconMaxShown: 2,
                  // markedDateIconBuilder: (event) {
                  //   return event.icon;
                  // },
                  // markedDateMoreShowTotal: true,
                  todayButtonColor: Colors.red,
                  selectedDayTextStyle: TextStyle(
                    color: Colors.yellow,
                  ),
                  minSelectedDate: _currentDate.subtract(Duration(days: 360)),
                  maxSelectedDate: _currentDate.add(Duration(days: 360)),
                  prevDaysTextStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.pinkAccent,
                  ),
                  inactiveDaysTextStyle: TextStyle(
                    color: Colors.tealAccent,
                    fontSize: 16,
                  ),
                  onCalendarChanged: (DateTime date) {
                    this.setState(() {
                      _targetDateTime = date;
                      _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                    });
                  },
                  onDayLongPressed: (DateTime date) {
                    print('long pressed date $date');
                  },
                )),
          ],
        );
      },
    );
  }

  _callNumber(String phoneNumber) async {
    String number = phoneNumber;
    await FlutterPhoneDirectCaller.callNumber(number);
  }
}
