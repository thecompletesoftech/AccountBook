import 'dart:io';
import 'dart:typed_data';
import 'package:account_book/Constant/Strings/Strings.dart';
import 'package:account_book/Constant/navigaotors/Navagate_Next.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_range_picker_flutter/date_range_picker_flutter.dart';
import 'package:excel/excel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../Constant/Colors/Colors.dart';
import '../Constant/TextStyles/Textstyles.dart';
import '../insertdatamodel.dart';
import 'package:share/share.dart';

class ViewReport extends StatefulWidget {
  ViewReport({Key? key}) : super(key: key);

  @override
  State<ViewReport> createState() => _ViewReportState();
}

class _ViewReportState extends State<ViewReport> {
  // final databaseReference = FirebaseDatabase.instance.reference();

  var initialDate = DateTime.now();
  var initialDateRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());
  var entry_data = [];
  List datelist = [];

  DateTime? startdate;
  DateTime? enddate;

  // String _selectedDate = '';
  // String _dateCount = '';
  // String _range = '';
  // String _rangeCount = '';

  List dataofgave = [];
  List dataofgot = [];

  int totalgaveamount = 0;
  int totalgotamount = 0;

  int total = 0;

  String? date;

  bool showloading = false;

  List filter_data = [];

  @override
  void initState() {
    _get_entry_record('Entry');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    total = totalgaveamount - totalgotamount;
    // datelist.clear();
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            child: Column(
              children: [
                InkWell(
                  onTap: () {},
                  splashColor: Colors.black,
                  child: InkWell(
                      onTap: () {
                        // _business_bottomsheet();
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        color: MyColors.primarycolor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                backScreen(context);
                              },
                              child: Icon(
                                Icons.arrow_back,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            Text('View Report',
                                style: TextStyles.withColor(
                                    TextStyles.mb16, Colors.white)),
                            PopupMenuButton(
                                icon:
                                    Icon(Icons.more_vert, color: Colors.white),
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem<int>(
                                      value: 0,
                                      child: Text("By Date"),
                                    ),
                                    PopupMenuItem<int>(
                                      value: 1,
                                      child: Text("Date range"),
                                    ),
                                    PopupMenuItem<int>(
                                      value: 2,
                                      child: Text("today"),
                                    ),
                                    PopupMenuItem<int>(
                                      value: 3,
                                      child: Text("Create excel File"),
                                    ),
                                  ];
                                },
                                onSelected: (value) {
                                  if (value == 0) {
                                    datepicker(context);
                                  } else if (value == 1) {
                                    // showCustomRangePicker();
                                    showrangfilter(context);
                                  } else if (value == 2) {
                                    today_filter();
                                  }else if(value == 3){
                                     createexcel();
                                  }
                                })
                          ],
                        ),
                      )),
                ),
              ],
            ),
            preferredSize: Size.fromHeight(80)),
        body: Container(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Net Balance",
                    style: TextStyles.mb16,
                  ),
                  Text(
                    '\u{20B9}' + total.toString(),
                    style: TextStyles.withColor(TextStyles.mb14, Colors.red),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "TOTAL",
                      style: TextStyles.mb12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "YOU GAVE " + "\u{20B9}",
                          style:
                              TextStyles.withColor(TextStyles.mb12, Colors.red),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "YOU GOT " + "\u{20B9}",
                          style: TextStyles.withColor(
                              TextStyles.mb12, Colors.green),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width * 0.3,
                      child: Text(
                        entry_data.length.toString(),
                        style: TextStyles.mb12,
                      ),
                    ),
                    Container(
                      width: size.width * 0.4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            totalgaveamount.toString(),
                            style: TextStyles.withColor(
                                TextStyles.mb12, Colors.red),
                          ),
                          Text(
                            totalgotamount.toString(),
                            style: TextStyles.withColor(
                                TextStyles.mb12, Colors.green),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
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
              SingleChildScrollView(
                child: Container(
                  height: size.height * 0.65,
                  child: ListView.builder(
                      itemCount: entry_data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: size.width * 0.3,
                                        child: Text(
                                          entry_data[index]['name'].toString(),
                                          maxLines: 2,
                                          style: TextStyles.mb14,
                                        )),
                                    SizedBox(height: 10),
                                    Container(
                                        child: Text(
                                      entry_data[index]['date'],
                                      maxLines: 2,
                                      style: TextStyles.mn12,
                                    )),
                                  ],
                                ),
                                entry_data[index]['type'] == '0'
                                    ? Text(
                                        entry_data[index]['amount'].toString(),
                                        style: TextStyles.withColor(
                                            TextStyles.mb12, Colors.red),
                                      )
                                    : Container(),
                                entry_data[index]['type'] == '1'
                                    ? Text(
                                        entry_data[index]['amount'].toString(),
                                        style: TextStyles.withColor(
                                            TextStyles.mb12, Colors.green),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ]),
          ),
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () {
        //     createexcel();
        //   },
        //   label: Text('Create excel File'.toString()),
        //   backgroundColor: Colors.green,
        // ),
      ),
    );
  }

  _get_entry_record(tablename) async {
    setState(() {
      showloading = true;
    });
    FirebaseFirestore.instance
        .collection(tablename)
        .where('deleted_status', isEqualTo: "0")
        .where('status', isEqualTo: "1")
        .orderBy("date", descending: false)
        .get()
        .then((QueryDocumentSnapshot) {
      for (var value in QueryDocumentSnapshot.docs) {
        setState(() {
          entry_data.add(value.data());
        });
      }
      totalamount();

      print("data" + entry_data.toString());
      setState(() {
        showloading = false;
      });
    });
  }

  _get_entry_record_for_filter(tablename) async {
    setState(() {
      showloading = true;
    });
    FirebaseFirestore.instance
        .collection(tablename)
        .where('deleted_status', isEqualTo: "0")
        .where('status', isEqualTo: "1")
        .orderBy("date", descending: false)
        .get()
        .then((QueryDocumentSnapshot) {
      for (var value in QueryDocumentSnapshot.docs) {
        setState(() {
          filter_data.add(value.data());
        });
      }
      totalamount();
      getlistdata();
      print("data all for filter" + filter_data.toString());
      setState(() {
        showloading = false;
      });
    });
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

    var dateFormat = DateFormat('yyyy-MM-dd');
    var outputfilter = [];

    for (int i = 0; i < dates.length; i++) {
      var date = dateFormat.parse(dates[i]);

      if (date.compareTo(start) >= 0 && date.compareTo(end) <= 0) {
        outputfilter.add(items[i]);
        print("data" + outputfilter.toString());
      }
    }
    setState(() {
      filter_data = outputfilter;
      entry_data = filter_data;
      totalamount();
      datelist.clear();
    });
    return outputfilter;
  }

  // _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
  //   setState(() {
  //     if (args.value is PickerDateRange) {
  //       _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
  //           // ignore: lines_longer_than_80_chars
  //           ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
  //     } else if (args.value is DateTime) {
  //       _selectedDate = args.value.toString();
  //     } else if (args.value is List<DateTime>) {
  //       _dateCount = args.value.length.toString();
  //     } else {
  //       _rangeCount = args.value.length.toString();
  //     }
  //   });
  // }

  // showCustomRangePicker() async {
  //   var size = MediaQuery.of(context).size;
  //   print("hiii");
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Dialog(
  //             child: Container(
  //           height: size.height * 0.5,
  //           width: size.width,
  //           child: SfDateRangePicker(
  //             onSelectionChanged: _onSelectionChanged,
  //             selectionMode: DateRangePickerSelectionMode.range,
  //             initialSelectedRange: PickerDateRange(
  //                 DateTime.now().subtract(const Duration(days: 4)),
  //                 DateTime.now().add(const Duration(days: 3))),
  //           ),
  //         ));
  //       });
  // }

  showrangfilter(cnxt) async {
    entry_data = [];
    filter_data = [];
    _get_entry_record_for_filter('Entry');

    // if (entry_data.length <= 0) {
    //   _get_entry_record("Entry");
    // }

    var res = await showTCRDateRangePicker(
      context: cnxt,
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

      totalgaveamount = 0;
      totalgotamount = 0;

      itemsBetweenDates(
          dates: datelist,
          items: filter_data,
          start: startdate!,
          end: enddate!);
    }
  }

  datepicker(cnxt) async {
    entry_data.clear();
    _get_entry_record('Entry');

    DateTime? pickedDate = await showDatePicker(
        context: cnxt,
        initialDate: DateTime.now(),
        firstDate: DateTime(
            2000), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101));

    if (pickedDate != null) {
      //pickedDate output format => 2021-03-10 00:00:00.000
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      print(
          formattedDate); //formatted date output using intl package =>  2021-03-16
      //you can implement different kind of Date Format here according to your requirement

      setState(() {
        date = formattedDate; //set output date to TextField value.
      });
      setState(() {
        entry_data =
            entry_data.where((element) => element['date'] == date).toList();
        totalamount();
      });
    } else {
      print("date is no selected");
    }
  }

  totalamount() {
    dataofgave.clear();
    dataofgot.clear();
    setState(() {
      totalgaveamount = 0;
      totalgotamount = 0;
    });
    dataofgot = entry_data
        .where((element) => element['type'] == '1' && element['status'] == '1')
        .toList();

    dataofgave = entry_data.where((element) => element['type'] == '0').toList();

    print("data of got" + dataofgot.toString());
    print("data of got" + dataofgave.toString());

    for (var i = 0; i < dataofgot.length; i++) {
      setState(() {
        totalgotamount = int.parse(dataofgot[i]['amount']) + totalgotamount;
        print("total got" + totalgotamount.toString());
      });
    }

    for (var i = 0; i < dataofgave.length; i++) {
      setState(() {
        totalgaveamount = int.parse(dataofgave[i]['amount']) + totalgaveamount;
        print("total gave" + totalgaveamount.toString());
      });
    }
  }

  getlistdata() {
    // FirebaseFirestore.instance
    //     .collection("Entry")
    //     .where('deleted_status', isEqualTo: "0")
    //     .where('status', isEqualTo: "1")
    //     .orderBy("date", descending: false)
    //     .get()
    //     .then((QueryDocumentSnapshot) {
    //   for (var value in QueryDocumentSnapshot.docs) {
    //     setState(() {
    //       entry_data.add(value.data());
    //     });
    //   }

    //   print("data" + entry_data.toString());
    // });
    setState(() {
      datelist = filter_data.map((e) => e['date']).toList();
      print(datelist);
    });
  }

  today_filter() {
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    print("today" + today.toString());

    setState(() {
      entry_data = entry_data
          .where((element) => element['date'] == today.toString())
          .toList();
      totalamount();
    });

    print("data of today" + entry_data.toString());
  }

  createexcel() async {
    if (await Permission.storage.request().isGranted) {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];
      // var cell = sheetObject.cell(CellIndex.indexByString("A1"));

      List<String> firstrow = [
        "sr no",
        "name",
        "amount _gave",
        "amount _got",
        "date",
        "description",
      ];

      sheetObject.insertRowIterables(firstrow, 0);
      for (var row = 1; row < entry_data.length; row++) {
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
            .value = row;
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
            .value = entry_data[row]['name'];

        entry_data[row]['type'] == "0"
            ? sheetObject
                .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
                .value = entry_data[row]['amount']
            : sheetObject
                .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
                .value = entry_data[row]['amount'];
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
            .value = entry_data[row]['date'];
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
            .value = entry_data[row]['description'];
      }
      final directory = await getExternalStorageDirectory();
      print("path" + directory!.path);
      File file = File('${directory.path}/excel.xlsx');

      excel.encode().then((onValue) {
        file
          ..createSync(recursive: true)
          ..writeAsBytesSync(onValue);
      });
      Share.shareFiles(['${directory.path}/excel.xlsx'], text: 'xecel');
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {}
  }
}
